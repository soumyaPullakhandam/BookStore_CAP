sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"authorslistview/test/integration/pages/AuthorsList.gen",
	"authorslistview/test/integration/pages/AuthorsObjectPage.gen",
	"authorslistview/test/integration/pages/BooksObjectPage.gen"
], function (JourneyRunner, AuthorsListGenerated, AuthorsObjectPageGenerated, BooksObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('authorslistview') + '/test/flpSandbox.html#authorslistview-tile',
        pages: {
			onTheAuthorsListGenerated: AuthorsListGenerated,
			onTheAuthorsObjectPageGenerated: AuthorsObjectPageGenerated,
			onTheBooksObjectPageGenerated: BooksObjectPageGenerated
        },
        async: true
    });

    return runner;
});

