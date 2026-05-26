using { nexcart.db } from '../db/schema' ;

service PaymentService {
    entity Payments    as projection on db.PAYMENTS;
    entity Coupons     as projection on db.COUPONS;
    entity GiftCards   as projection on db.GIFT_CARDS;
}