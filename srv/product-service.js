const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {

    const { Products } = this.entities;
    // BEFORE
    this.before("CREATE", Products, async (req) => {

        const price = req.data.PRICE || 0;
        const discount = req.data.DISCOUNT_PERCENTAGE || 0;

        req.data.FINAL_PRICE =
            price - (price * discount / 100);
    });

    // ON
    this.on("getLowStockProducts", async () => {

        return await SELECT.from(Products)
            .where({ STOCK: { '<': 5 } });
    });

    // AFTER
    this.after("UPDATE", Products, async (data) => {

        console.log("Product updated");

    });

});