using {tutorial.db as db} from '../db/schema';


service BookstoreService {

    entity Books      as projection on db.Books
        actions {
            action addStock();
            action changePulishData(newDate: Date);
            action changeStatus( @(Common: {
                                     Text.@UI.TextArrangement : #TextOnly,
                                     Label : 'New Status',
                                     Text : status.displayText,
                                     ValueListWithFixedValues: true,
                                     ValueList         : {
                                         $Type         : 'Common.ValueListType',
                                         CollectionPath: 'BookStatus',
                                         Parameters    : [{
                                             $Type            : 'Common.ValueListParameterInOut',
                                             LocalDataProperty: newStatus,
                                             ValueListProperty: 'code',
                                         }, ],
                                     },
                                     

                                 }) newStatus: String);

        };

    entity Authors    as projection on db.Authors;
    entity Chapters   as projection on db.Chapters;
    entity BookStatus as projection on db.BookStatus;

    entity Genres     as projection on db.Genres;
}


annotate BookstoreService.Books with @odata.draft.enabled;
