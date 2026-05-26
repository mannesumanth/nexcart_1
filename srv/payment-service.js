const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {

    const { Payments } = this.entities;
    // BEFORE
    this.before("CREATE", Payments, async (req) => {
        req.data.PAYMENT_DATE = new Date();
    });
    //ON
    this.on("processRefund", async () => {
        return {
            message: "Refund processed successfully"
        };
    });
    // AFTER
    this.after("CREATE", Payments, async () => {

        console.log("Payment completed");
        // Invoice Generation
        // Notification
    });

});