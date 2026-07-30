sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"bookstorelistview/test/integration/pages/BooksList.gen",
	"bookstorelistview/test/integration/pages/BooksObjectPage.gen"
], function (JourneyRunner, BooksListGenerated, BooksObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('bookstorelistview') + '/test/flpSandbox.html#bookstorelistview-tile',
        pages: {
			onTheBooksListGenerated: BooksListGenerated,
			onTheBooksObjectPageGenerated: BooksObjectPageGenerated
        },
        async: true
    });

    return runner;
});

