using { nexcart.db } from '../db/schema' ;

service ReturnService {
    entity Returns    as projection on db.RETURNS;
    entity Refunds    as projection on db.REFUNDS;
}