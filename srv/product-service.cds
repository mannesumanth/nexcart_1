using { nexcart.db } from '../db/schema' ;

service ProductService {
    entity Categories      as projection on db.CATEGORIES;
    entity Products        as projection on db.PRODUCTS;
    entity ProductImages   as projection on db.PRODUCT_IMAGES;
    entity ProductVariants as projection on db.PRODUCT_VARIANTS;
    entity Reviews         as projection on db.REVIEWS;
}