using { nexcart.db } from '../db/schema' ;

service CartService {
    entity Cart        as projection on db.CART;
    //entity CartItems   as projection on db.CART_ITEMS;
    //entity Wishlist    as projection on db.WISHLIST;
}