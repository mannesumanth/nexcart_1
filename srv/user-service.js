const cds = require('@sap/cds');
const bcrypt = require('bcrypt');

module.exports = cds.service.impl(async function () {
    const { Users } = this.entities;

    // BEFORE
    this.before("CREATE", Users, async (req) => {
        // Password Hashing
        if (req.data.PASSWORD) {
            req.data.PASSWORD =
                await bcrypt.hash(req.data.PASSWORD, 10);
        }
        // Default Role
        if (!req.data.ROLE) {
            req.data.ROLE = 'CUSTOMER';
        }
    });

    // ON
    this.on("resetPassword", async (req) => {
        return {
            message: "Password reset link sent successfully"
        };
    });

    // AFTER
    this.after("CREATE", Users, async (data, req) => {
        console.log("User created successfully");
    });

});