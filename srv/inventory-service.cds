using { nexcart.db } from '../db/schema' ;

service InventoryService {
    entity Warehouses      as projection on db.WAREHOUSES;
    entity Inventory       as projection on db.INVENTORY;
    entity InventoryLogs   as projection on db.INVENTORY_LOGS;
    entity StockTransfers  as projection on db.STOCK_TRANSFERS;
}