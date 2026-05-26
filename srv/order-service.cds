using { nexcart.db } from '../db/schema' ;

service OrderService {
    entity Orders          as projection on db.ORDERS;
    entity OrderItems      as projection on db.ORDER_ITEMS;
    entity OrderTracking   as projection on db.ORDER_TRACKING;
}