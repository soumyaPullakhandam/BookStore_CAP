using {tutorial.db as db} from '../db/schema';


service BookstoreService {

    entity Books      as projection on db.Books
        actions {
            action addStock();
            action changePulishData(newDate: Date);
            action changeStatus(newStatus : String);
            
        };

    entity Authors    as projection on db.Authors;
    entity Chapters   as projection on db.Chapters;
    entity BookStatus as projection on db.BookStatus;

    entity Genres     as projection on db.Genres;
}


annotate BookstoreService.Books with @odata.draft.enabled;
