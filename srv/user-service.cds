
using { nexcart.db } from '../db/schema' ;
service UserService {
    entity Users           as projection on db.USERS;
     entity Orders          as projection on db.ORDERS;
    entity Addresses       as projection on db.ADDRESSES;
    entity LoginHistory    as projection on db.LOGIN_HISTORY;
    entity SecurityEvents  as projection on db.SECURITY_EVENTS;
}