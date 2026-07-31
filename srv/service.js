
const cds = require('@sap/cds')
const { UPDATE, SELECT } = require('@sap/cds/lib/ql/cds-ql')

module.exports = class BookstoreService extends cds.ApplicationService {
  init() {

    const { Books } = cds.entities('BookstoreService')



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

      return tx.run(SELECT.from(Books))

    })




    this.on('addStock', Books, async (req) => {
      console.log('On addStock Event', req.data)
      const bookID = req.params?.[0]?.ID

      if (!bookID) {
        return req.reject(400, 'Book ID is missing')
      }

      const tx = cds.tx(req)

      const affectedRows = await tx.run(
        UPDATE(Books)
          .set({ stock: { '+=': 1 } })
          .where({ ID: bookID })
      )

      if (!affectedRows) {
        return req.reject(404, `Book with ID ${bookID} was not found`)
      }

      return tx.run(
        SELECT.one.from(Books).where({ ID: bookID })
      )

    })




    this.on('changePulishData', Books, async (req) => {

      const newDate = req.data.newDate
      console.log('On changePulishData', newDate)
      const bookID = req.params?.[0]?.ID

      if (!bookID) {
        return req.reject(400, 'Book ID is missing')
      }

      const tx = cds.tx(req)

      const affectedRows = await tx.run(
        UPDATE(Books)
          .set({ publishedAt: newDate })
          .where({ ID: bookID })
      )

      if (!affectedRows) {
        return req.reject(404, `Book with ID ${bookID} was not found`)
      }

      return tx.run(
        SELECT.one.from(Books).where({ ID: bookID })
      )

    })





    this.on('changeStatus', Books, async (req) => {

      const newStatus = req.data.newStatus
      console.log('Changed Status is:', newStatus)
      const bookID = req.params?.[0]?.ID

      if (!bookID) {
        return req.reject(400, 'Book ID is missing')
      }

      const tx = cds.tx(req)

      const affectedRows = await tx.run(
        UPDATE(Books)
          .set({ status_code: newStatus })
          .where({ ID: bookID })
      )

      if (!affectedRows) {
        return req.reject(404, `Book with ID ${bookID} was not found`)
      }

      return tx.run(
        SELECT.one.from(Books).where({ ID: bookID })
      )

    })






    this.before('READ', Books, async (req) => {
      console.log('Before READ Books', req.data)
    })

    this.on('READ', Books, async (req, next) => {
      console.log('On Event', req.data, next)
      return next()
    })

    this.after('READ', Books, async (books, req) => {
      console.log('After READ Books', books)
    })

    return super.init()
  }
}
