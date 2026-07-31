using {tutorial.db as db} from '../db/schema';


service BookstoreService {

    entity Books      as projection on db.Books
        actions {
            // @(Common.SideEffects: { TargetEntities: ['in']})
            @(Common.SideEffects: {TargetProperties: ['stock']})
            action addStock();
            @(Common.SideEffects: {TargetProperties: ['publishedAt']})
            action changePulishData(newDate: Date);
            @(Common.SideEffects: {TargetProperties: ['status_code']})
            action changeStatus( @(Common: {
                                     Text.@UI.TextArrangement: #TextOnly,
                                     Label                   : 'New Status',
                                     Text                    : status.displayText,
                                     ValueListWithFixedValues: true,
                                     ValueList               : {
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

    //Outbound side effect
    @(Common.SideEffects: { TargetEntities: ['/BookstoreService.EntityContainer/Books']})
    action addDiscount();
}


annotate BookstoreService.Books with @odata.draft.enabled;
annotate BookstoreService.Authors with @odata.draft.enabled;
