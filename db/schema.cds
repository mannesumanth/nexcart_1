namespace nexcart.db;

using {managed} from '@sap/cds/common';

// TYPES / ENUMS

type USER_ROLE                  : String enum {
    CUSTOMER;
    ADMIN;
};

type PRODUCT_SIZE               : String enum {
    XS;
    S;
    M;
    L;
    XL;
    XXL;
};

type ORDER_STATUS               : String enum {
    PENDING;
    PLACED;
    CONFIRMED;
    SHIPPED;
    DELIVERED;
    CANCELLED;
};

type PAYMENT_METHOD             : String enum {
    CARD;
    UPI;
    COD;
    NETBANKING;
};

type PAYMENT_STATUS             : String enum {
    PENDING;
    SUCCESS;
    FAILED;
    REFUNDED;
};

type TRACKING_STATUS            : String enum {
    ORDER_PLACED;
    PACKED;
    SHIPPED;
    OUT_FOR_DELIVERY;
    DELIVERED;
};

type INVENTORY_TRANSACTION_TYPE : String enum {
    STOCK_IN;
    STOCK_OUT;
    RETURNED;
    DAMAGED;
    TRANSFERRED;
};

type COUPON_TYPE                : String enum {
    PERCENTAGE;
    FIXED_AMOUNT;
};

type OFFER_TYPE                 : String enum {
    PRODUCT;
    CATEGORY;
    CART;
};

type NOTIFICATION_TYPE          : String enum {
    EMAIL;
    SMS;
    PUSH;
    SYSTEM;
};

type NOTIFICATION_STATUS        : String enum {
    PENDING;
    SENT;
    FAILED;
    READ;
};

type SHIPMENT_STATUS            : String enum {
    PENDING;
    PACKED;
    SHIPPED;
    IN_TRANSIT;
    OUT_FOR_DELIVERY;
    DELIVERED;
    RETURNED;
};

type DELIVERY_PARTNER_TYPE      : String enum {
    INTERNAL;
    THIRD_PARTY;
};

type TICKET_STATUS              : String enum {
    OPEN;
    IN_PROGRESS;
    RESOLVED;
    CLOSED;
};

type RETURN_STATUS              : String enum {
    REQUESTED;
    APPROVED;
    REJECTED;
    PICKED_UP;
    COMPLETED;
};

type REFUND_STATUS              : String enum {
    INITIATED;
    PROCESSING;
    COMPLETED;
    FAILED;
};

type SECURITY_EVENT_TYPE        : String enum {
    LOGIN_SUCCESS;
    LOGIN_FAILED;
    PASSWORD_CHANGED;
    ACCOUNT_LOCKED;
    UNAUTHORIZED_ACCESS;
};

// USER & AUTHENTICATION MODULE

entity USERS : managed {

    key ID                : UUID;

        FULL_NAME         : String(100) not null;
        EMAIL             : String(100) not null 
                                        @assert.unique
                                        @assert.format : '^[^@]+@[^@]+\.[^@]+$';
        PASSWORD          : String(255) not null;
        PHONE_NUMBER      : String(15);
        ROLE              : USER_ROLE default 'CUSTOMER';
        IS_ACTIVE         : Boolean default true;
        IS_EMAIL_VERIFIED : Boolean default false;
        PROFILE_IMAGE     : String(500);
        LAST_LOGIN_AT     : Timestamp;
        ADDRESSES         : Composition of many ADDRESSES
                                on ADDRESSES.USER = $self;
        CART              : Association to one CART;
        ORDERS            : Association to many ORDERS
                                on ORDERS.USER = $self;
        REVIEWS           : Association to many REVIEWS
                                on REVIEWS.USER = $self;
        WISHLIST_ITEMS    : Association to many WISHLIST
                                on WISHLIST_ITEMS.USER = $self;
        NOTIFICATIONS     : Composition of many NOTIFICATIONS
                                on NOTIFICATIONS.USER = $self;
        TICKETS           : Association to many TICKETS
                                on TICKETS.USER = $self;
        LOGIN_HISTORY     : Composition of many LOGIN_HISTORY
                                on LOGIN_HISTORY.USER = $self;
        SECURITY_EVENTS   : Composition of many SECURITY_EVENTS
                                on SECURITY_EVENTS.USER = $self;
}

entity ADDRESSES : managed {

    key ID             : UUID;

        USER           : Association to USERS not null;
        FULL_NAME      : String(100);
        PHONE_NUMBER   : String(15);
        ADDRESS_LINE_1 : String(200) not null;
        ADDRESS_LINE_2 : String(200);
        LANDMARK       : String(100);
        CITY           : String(100) not null;
        STATE          : String(100) not null;
        COUNTRY        : String(100) default 'India';
        POSTAL_CODE    : String(10) not null;
        IS_DEFAULT     : Boolean default false;
}

entity LOGIN_HISTORY : managed {

    key ID               : UUID;
        USER             : Association to USERS;
        LOGIN_TIME       : Timestamp;
        IP_ADDRESS       : String(100);
        DEVICE_INFO      : String(500);
        BROWSER          : String(100);
        OPERATING_SYSTEM : String(100);
        IS_SUCCESSFUL    : Boolean;
}

entity SECURITY_EVENTS : managed {

    key ID                : UUID;
        USER              : Association to USERS;
        EVENT_TYPE        : SECURITY_EVENT_TYPE;
        EVENT_DESCRIPTION : String(1000);
        EVENT_TIME        : Timestamp;
        IP_ADDRESS        : String(100);
}

// PRODUCT & CATEGORY MODULE

entity CATEGORIES : managed {

    key ID          : UUID;
        NAME        : String(100) not null;
        DESCRIPTION : String(500);
        IMAGE_URL   : String(500);
        PRODUCTS    : Association to many PRODUCTS
                          on PRODUCTS.CATEGORY = $self;
}

entity PRODUCTS : managed {

    key ID                  : UUID;
        NAME                : String(150) not null;
        DESCRIPTION         : String(3000);
        BRAND               : String(100);
        SKU                 : String(100);
        PRICE               : Decimal(12, 2) not null;
        DISCOUNT_PERCENTAGE : Decimal(5, 2);
        FINAL_PRICE         : Decimal(12, 2);
        STOCK               : Integer default 0;
        RATING              : Decimal(2, 1);
        IS_AVAILABLE        : Boolean default true;
        CATEGORY            : Association to CATEGORIES not null;
        INVENTORY           : Association to one INVENTORY;
        IMAGES              : Composition of many PRODUCT_IMAGES
                                  on IMAGES.PRODUCT = $self;
        VARIANTS            : Composition of many PRODUCT_VARIANTS
                                  on VARIANTS.PRODUCT = $self;
        REVIEWS             : Association to many REVIEWS
                                  on REVIEWS.PRODUCT = $self;
}

entity PRODUCT_IMAGES : managed {

    key ID            : UUID;
        PRODUCT       : Association to PRODUCTS not null;
        IMAGE_URL     : String(1000) not null;
        ALT_TEXT      : String(200);
        IS_PRIMARY    : Boolean default false;
        DISPLAY_ORDER : Integer default 1;
}

entity PRODUCT_VARIANTS : managed {

    key ID               : UUID;
        PRODUCT          : Association to PRODUCTS not null;
        COLOR            : String(50);
        SIZE             : PRODUCT_SIZE;
        STOCK            : Integer default 0;
        ADDITIONAL_PRICE : Decimal(12, 2) default 0;
}

entity REVIEWS : managed {

    key ID      : UUID;
        USER    : Association to USERS not null;
        PRODUCT : Association to PRODUCTS not null;
        RATING  : Integer;
        COMMENT : String(1000);
}

// CART & WISHLIST MODULE

entity CART : managed {

    key ID           : UUID;
        USER         : Association to USERS not null;
        TOTAL_AMOUNT : Decimal(12, 2) default 0;
        CART_ITEMS   : Composition of many CART_ITEMS
                           on CART_ITEMS.CART = $self;
}

entity CART_ITEMS : managed {

    key ID          : UUID;
        CART        : Association to CART not null;
        PRODUCT     : Association to PRODUCTS not null;
        QUANTITY    : Integer default 1;
        TOTAL_PRICE : Decimal(12, 2);
}

entity WISHLIST : managed {

    key ID      : UUID;
        USER    : Association to USERS not null;
        PRODUCT : Association to PRODUCTS not null;
}

// ORDER & PAYMENT MODULE

entity ORDERS : managed {

    key ID               : UUID;
        ORDER_NUMBER     : String(20) not null @assert.unique;
        USER             : Association to USERS not null;
        ORDER_DATE       : Timestamp;
        STATUS           : ORDER_STATUS default 'PENDING';
        TOTAL_AMOUNT     : Decimal(12, 2);
        SHIPPING_ADDRESS : String(500);
        PAYMENT_STATUS   : PAYMENT_STATUS default 'PENDING';
        COUPON           : Association to one COUPONS;
        ORDER_ITEMS      : Composition of many ORDER_ITEMS
                               on ORDER_ITEMS.ORDER = $self;
        PAYMENT          : Association to one PAYMENTS;
        SHIPMENT         : Association to one SHIPMENTS;
        TRACKING_HISTORY : Composition of many ORDER_TRACKING
                               on TRACKING_HISTORY.ORDER = $self;
}

entity ORDER_ITEMS : managed {

    key ID          : UUID;
        ORDER       : Association to ORDERS not null;
        PRODUCT     : Association to PRODUCTS not null;
        QUANTITY    : Integer not null;
        PRICE       : Decimal(12, 2) not null;
        TOTAL_PRICE : Decimal(12, 2);
}

entity PAYMENTS : managed {

    key ID             : UUID;
        ORDER          : Association to ORDERS not null;
        PAYMENT_METHOD : PAYMENT_METHOD;
        PAYMENT_STATUS : PAYMENT_STATUS default 'PENDING';
        TRANSACTION_ID : String(200);
        AMOUNT         : Decimal(12, 2);
        PAYMENT_DATE   : Timestamp;
}

entity ORDER_TRACKING : managed {

    key ID              : UUID;
        ORDER           : Association to ORDERS not null;
        TRACKING_STATUS : TRACKING_STATUS;
        DESCRIPTION     : String(500);
        UPDATED_AT      : Timestamp;
}

// INVENTORY & WAREHOUSE MODULE

entity WAREHOUSES : managed {

    key ID           : UUID;
        NAME         : String(100) not null;
        LOCATION     : String(300);
        MANAGER_NAME : String(100);
        PHONE_NUMBER : String(15);
        INVENTORIES  : Composition of many INVENTORY
                           on INVENTORIES.WAREHOUSE = $self;
}

entity INVENTORY : managed {

    key ID                  : UUID;
        PRODUCT             : Association to PRODUCTS not null;
        WAREHOUSE           : Association to WAREHOUSES not null;
        AVAILABLE_STOCK     : Integer default 0;
        RESERVED_STOCK      : Integer default 0;
        MINIMUM_STOCK_LEVEL : Integer default 5;
        MAXIMUM_STOCK_LEVEL : Integer;
        INVENTORY_LOGS      : Composition of many INVENTORY_LOGS
                                  on INVENTORY_LOGS.INVENTORY = $self;
}

entity INVENTORY_LOGS : managed {

    key ID               : UUID;
        INVENTORY        : Association to INVENTORY not null;
        TRANSACTION_TYPE : INVENTORY_TRANSACTION_TYPE;
        PREVIOUS_STOCK   : Integer;
        UPDATED_STOCK    : Integer;
        QUANTITY_CHANGED : Integer;
        REMARKS          : String(500);
}

entity STOCK_TRANSFERS : managed {

    key ID             : UUID;
        PRODUCT        : Association to PRODUCTS not null;
        FROM_WAREHOUSE : Association to WAREHOUSES not null;
        TO_WAREHOUSE   : Association to WAREHOUSES not null;
        QUANTITY       : Integer;
        TRANSFER_DATE  : Timestamp;
        REMARKS        : String(500);
}

// COUPONS, OFFERS & CAMPAIGNS MODULE

entity COUPONS : managed {

    key ID                      : UUID;
        CODE                    : String(50) not null;
        DESCRIPTION             : String(500);
        COUPON_TYPE             : COUPON_TYPE;
        DISCOUNT_VALUE          : Decimal(12, 2);
        MINIMUM_ORDER_AMOUNT    : Decimal(12, 2);
        MAXIMUM_DISCOUNT_AMOUNT : Decimal(12, 2);
        USAGE_LIMIT             : Integer;
        USED_COUNT              : Integer default 0;
        VALID_FROM              : Date;
        VALID_TO                : Date;
        IS_ACTIVE               : Boolean default true;
}

entity OFFERS : managed {
    key ID                  : UUID;

        TITLE               : String(150);
        DESCRIPTION         : String(1000);
        OFFER_TYPE          : OFFER_TYPE;
        DISCOUNT_PERCENTAGE : Decimal(5, 2);
        START_DATE          : Date;
        END_DATE            : Date;
        IS_ACTIVE           : Boolean default true;
        PRODUCT             : Association to PRODUCTS;
        CATEGORY            : Association to CATEGORIES;
}

entity CAMPAIGNS : managed {

    key ID          : UUID;
        NAME        : String(150);
        DESCRIPTION : String(1000);
        START_DATE  : Date;
        END_DATE    : Date;
        BUDGET      : Decimal(12, 2);
        IS_ACTIVE   : Boolean default true;
}

entity GIFT_CARDS : managed {

    key ID             : UUID;
        CODE           : String(100);
        AMOUNT         : Decimal(12, 2);
        BALANCE_AMOUNT : Decimal(12, 2);
        EXPIRY_DATE    : Date;
        IS_ACTIVE      : Boolean default true;
        ASSIGNED_TO    : Association to USERS;
}

// DELIVERY & SHIPMENT MODULE

entity DELIVERY_PARTNERS : managed {

    key ID           : UUID;
        NAME         : String(150);
        PARTNER_TYPE : DELIVERY_PARTNER_TYPE;
        PHONE_NUMBER : String(15);
        EMAIL        : String(100);
        IS_ACTIVE    : Boolean default true;
}

entity SHIPMENTS : managed {

    key ID                      : UUID;
        ORDER                   : Association to ORDERS not null;
        DELIVERY_PARTNER        : Association to DELIVERY_PARTNERS;
        TRACKING_NUMBER         : String(200);
        SHIPMENT_STATUS         : SHIPMENT_STATUS default 'PENDING';
        SHIPPED_DATE            : Timestamp;
        ESTIMATED_DELIVERY_DATE : Date;
        DELIVERED_DATE          : Timestamp;
        SHIPPING_CHARGES        : Decimal(12, 2);
        TRACKING_UPDATES        : Composition of many TRACKING_UPDATES
                                      on TRACKING_UPDATES.SHIPMENT = $self;
}

entity TRACKING_UPDATES : managed {

    key ID          : UUID;
        SHIPMENT    : Association to SHIPMENTS not null;
        STATUS      : SHIPMENT_STATUS;
        LOCATION    : String(200);
        DESCRIPTION : String(500);
        UPDATED_AT  : Timestamp;
}

// NOTIFICATION & COMMUNICATION MODULE
entity NOTIFICATIONS : managed {

    key ID                  : UUID;
        USER                : Association to USERS not null;
        TITLE               : String(200);
        MESSAGE             : String(2000);
        NOTIFICATION_TYPE   : NOTIFICATION_TYPE;
        NOTIFICATION_STATUS : NOTIFICATION_STATUS default 'PENDING';
        IS_READ             : Boolean default false;
        SENT_AT             : Timestamp;
}

entity EMAIL_TEMPLATES : managed {

    key ID            : UUID;
        TEMPLATE_NAME : String(100);
        SUBJECT       : String(200);
        BODY          : LargeString;
        IS_ACTIVE     : Boolean default true;
}

entity SMS_LOGS : managed {

    key ID                  : UUID;
        USER                : Association to USERS;
        PHONE_NUMBER        : String(15);
        MESSAGE             : String(1000);
        NOTIFICATION_STATUS : NOTIFICATION_STATUS;
        SENT_AT             : Timestamp;
}

entity PUSH_NOTIFICATIONS : managed {
    key ID                  : UUID;
        USER                : Association to USERS;
        TITLE               : String(200);
        MESSAGE             : String(1000);
        DEVICE_TOKEN        : String(500);
        NOTIFICATION_STATUS : NOTIFICATION_STATUS;
        SENT_AT             : Timestamp;
}

// SUPPORT & TICKETING MODULE

entity TICKETS : managed {
    key ID            : UUID;
        USER          : Association to USERS not null;
        SUBJECT       : String(200);
        DESCRIPTION   : String(2000);
        STATUS        : TICKET_STATUS default 'OPEN';
        SUPPORT_CHATS : Composition of many SUPPORT_CHATS
                            on SUPPORT_CHATS.TICKET = $self;
}

entity SUPPORT_CHATS : managed {
    key ID      : UUID;
        TICKET  : Association to TICKETS not null;
        SENDER  : String(100);
        MESSAGE : String(2000);
        SENT_AT : Timestamp;
}

// RETURNS & REFUNDS MODULE

entity RETURNS : managed {
    key ID            : UUID;
        ORDER         : Association to ORDERS not null;
        USER          : Association to USERS not null;
        RETURN_REASON : String(1000);
        RETURN_STATUS : RETURN_STATUS default 'REQUESTED';
        REQUESTED_AT  : Timestamp;
        REFUNDS       : Composition of many REFUNDS
                            on REFUNDS.RETURN_REQUEST = $self;
}

entity REFUNDS : managed {
    key ID             : UUID;
        RETURN_REQUEST : Association to RETURNS not null;
        REFUND_AMOUNT  : Decimal(12, 2);
        REFUND_STATUS  : REFUND_STATUS default 'INITIATED';
        REFUND_DATE    : Timestamp;
        REMARKS        : String(1000);
}

// AUDIT MODULE

entity AUDIT_LOGS : managed {
    key ID          : UUID;
        USER        : Association to USERS;
        ACTION      : String(200);
        ENTITY_NAME : String(100);
        ENTITY_ID   : String(100);
        DESCRIPTION : String(1000);
}
