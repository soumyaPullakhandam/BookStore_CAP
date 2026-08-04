const cds = require('@sap/cds')
const { UPDATE, SELECT } = cds.ql

module.exports = class BookstoreService extends cds.ApplicationService {
  async init() {
    const { Books, Authors } = this.entities

    this.on('error', (err, req) => {
      switch (err.message) {
        case 'UNIQUE_CONSTRAINT_VIOLATION':
          err.message = 'The entry already exists.'
          break

        default:
          err.message =
            `An error occurred. Please retry. Technical error message: ${err.message}`
          break
      }
    })

    /**
     * Unbound action: submit an order for a book
     */
    this.on('submitOrder', async req => {
      const { book, amount } = req.data

      if (!book) {
        return req.reject(400, 'Book ID is missing')
      }

      if (!Number.isInteger(amount) || amount <= 0) {
        return req.reject(
          400,
          'Order amount must be a positive integer'
        )
      }

      const tx = cds.tx(req)

      const selectedBook = await tx.run(
        SELECT.one
          .from(Books)
          .columns('ID', 'title', 'stock')
          .where({ ID: book })
      )

      if (!selectedBook) {
        return req.reject(
          404,
          `Book with ID ${book} was not found`
        )
      }

      const currentStock = Number(selectedBook.stock ?? 0)

      if (currentStock < amount) {
        return req.reject(
          409,
          `Requested amount ${amount} exceeds the available stock of ${currentStock}`
        )
      }

      const remainingStock = currentStock - amount

      await tx.run(
        UPDATE(Books)
          .set({ stock: remainingStock })
          .where({ ID: book })
      )

      /**
       * Publish the event.
       */
      await this.emit('OrderedBook', {
        book,
        amount,
        buyer: req.user.id
      })

      /**
       * Send the action result to the caller.
       */
      return req.reply({
        book,
        stock: remainingStock,
        message: `${amount} unit(s) of "${selectedBook.title}" ordered successfully`
      })
    })

    /**
     * Event handler triggered by this.emit('OrderedBook', ...)
     */
    this.on('OrderedBook', async msg => {
      const { book, amount, buyer } = msg.data

      console.log('OrderedBook event received:', {
        book,
        amount,
        buyer
      })

      // Optional:
      // Insert an order-history record, send a notification,
      // or publish the event to SAP Event Mesh.
    })

    /**
     * Unbound action: apply a 10% discount to all books
     */
    this.on('addDiscount', async req => {
      const tx = cds.tx(req)

      const affectedRows = await tx.run(
        UPDATE(Books).set({
          price: {
            func: 'round',
            args: [
              {
                xpr: [
                  { ref: ['price'] },
                  '*',
                  { val: 0.9 }
                ]
              },
              { val: 2 }
            ]
          }
        })
      )

      if (affectedRows === 0) {
        return req.reject(404, 'No books were found')
      }

      return req.reply(
        await tx.run(SELECT.from(Books))
      )
    })

    /**
     * Bound action: increase stock by one
     */
    this.on('addStock', Books, async req => {
      const bookID = req.params?.[0]?.ID

      if (!bookID) {
        return req.reject(400, 'Book ID is missing')
      }

      const tx = cds.tx(req)

      const affectedRows = await tx.run(
        UPDATE(Books)
          .set({
            stock: { '+=': 1 }
          })
          .where({ ID: bookID })
      )

      if (affectedRows === 0) {
        return req.reject(
          404,
          `Book with ID ${bookID} was not found`
        )
      }

      const updatedBook = await tx.run(
        SELECT.one.from(Books).where({ ID: bookID })
      )

      return req.reply(updatedBook)
    })

    /**
     * Bound action: change publication date
     */
    this.on('changePublishDate', Books, async req => {
      const { newDate } = req.data
      const bookID = req.params?.[0]?.ID

      if (!bookID) {
        return req.reject(400, 'Book ID is missing')
      }

      if (!newDate) {
        return req.reject(
          400,
          'New publication date is missing'
        )
      }

      const tx = cds.tx(req)

      const affectedRows = await tx.run(
        UPDATE(Books)
          .set({ publishedAt: newDate })
          .where({ ID: bookID })
      )

      if (affectedRows === 0) {
        return req.reject(
          404,
          `Book with ID ${bookID} was not found`
        )
      }

      const updatedBook = await tx.run(
        SELECT.one.from(Books).where({ ID: bookID })
      )

      return req.reply(updatedBook)
    })

    /**
     * Bound action: change book status
     */
    this.on('changeStatus', Books, async req => {
      const { newStatus } = req.data
      const bookID = req.params?.[0]?.ID

      if (!bookID) {
        return req.reject(400, 'Book ID is missing')
      }

      if (!newStatus) {
        return req.reject(400, 'New status is missing')
      }

      const tx = cds.tx(req)

      const affectedRows = await tx.run(
        UPDATE(Books)
          .set({ status_code: newStatus })
          .where({ ID: bookID })
      )

      if (affectedRows === 0) {
        return req.reject(
          404,
          `Book with ID ${bookID} was not found`
        )
      }

      const updatedBook = await tx.run(
        SELECT.one.from(Books).where({ ID: bookID })
      )

      return req.reply(updatedBook)
    })

    /**
     * Calculate virtual bookCount for authors
     */
    this.after('READ', Authors, async (result, req) => {
      const authors = Array.isArray(result)
        ? result
        : result
          ? [result]
          : []

      if (authors.length === 0) {
        return
      }

      const authorIDs = authors
        .map(author => author.ID)
        .filter(Boolean)

      if (authorIDs.length === 0) {
        return
      }

      const tx = cds.tx(req)

      const counts = await tx.run(
        SELECT.from(Books)
          .columns(
            'author_ID',
            {
              func: 'count',
              args: [{ ref: ['ID'] }],
              as: 'count'
            }
          )
          .where({
            author_ID: {
              in: authorIDs
            }
          })
          .groupBy('author_ID')
      )

      for (const author of authors) {
        const countResult = counts.find(
          row => row.author_ID === author.ID
        )

        author.bookCount = Number(
          countResult?.count ?? 0
        )
      }
    })

    this.before('READ', Books, req => {
      console.log('Before READ Books', req.query)
    })

    this.on('READ', Books, async (req, next) => {
      console.log('On READ Books')
      return next()
    })

    this.after('READ', Books, books => {
      console.log('After READ Books', books)
    })

    return super.init()
  }
}