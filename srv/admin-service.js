const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {

    this.before("*", async () => {

        console.log("Admin operation started");
    });

    this.on("getDashboardStats", async () => {
        return {
            users: 100,
            orders: 250,
            revenue: 50000
        };
    });

    this.after("*", async () => {
        console.log("Admin operation completed");
    });

});