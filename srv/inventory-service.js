const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {

    const { Inventory } = this.entities;

    this.before("UPDATE", Inventory, async (req) => {
        if (req.data.AVAILABLE_STOCK < 0) {
            req.error(400, "Invalid stock");
        }
    });

    this.on("transferStock", async () => {
        return {
            message: "Stock transferred successfully"
        };
    });

    this.after("UPDATE", Inventory, async (data) => {
        if (data.AVAILABLE_STOCK < 5) {
            console.log("Low stock alert");
        }
    });

});