const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {

    const { CartItems } = this.entities;

    // BEFORE
    this.before("CREATE", CartItems, async (req) => {

        const product = await SELECT.one
            .from('nexcart.db.PRODUCTS')
            .where({ ID: req.data.PRODUCT_ID });

        if (product.STOCK < req.data.QUANTITY) {
            req.error(400, "Insufficient stock");
        }
    });
     // ON
    this.on("clearCart", async () => {
        return {
            message: "Cart cleared successfully"
        };
    });
    // AFTER
    this.after("CREATE", CartItems, async () => {

        console.log("Cart updated");
        // Recalculate Cart Total
    });

});