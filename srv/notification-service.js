const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {

    this.before("*", async () => {
        console.log("Preparing notification");
    });

    this.on("sendNotification", async () => {
        return {
            message: "Notification sent successfully"
        };
    });

    this.after("*", async () => {
        console.log("Notification processed");
    });

});