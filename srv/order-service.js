const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {

    const {
        Orders,
        OrderItems
    } = this.entities;

    // BEFORE
    this.before("CREATE", Orders, async (req) => {

        req.data.ORDER_DATE = new Date();

        req.data.ORDER_NUMBER =
            "ORD-" + Date.now();
    });

    // ON
    this.on("placeOrder", async (req) => {

        const tx = cds.tx(req);

        // Order Logic
        // Inventory Reduction
        // Payment Creation
        // Shipment Creation

        return {
            message: "Order placed successfully"
        };
    });

    // AFTER
    this.after("CREATE", Orders, async () => {

        console.log("Order created");

        // Notification
        // Audit Log
        // Tracking Creation
    });

});