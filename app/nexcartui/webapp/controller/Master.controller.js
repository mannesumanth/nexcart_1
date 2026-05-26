sap.ui.define([
    "sap/ui/core/mvc/Controller",
    "sap/m/MessageToast"
], function (Controller, MessageToast) {
    "use strict";

    return Controller.extend("com.amista.nexcartui.controller.Master", {

        onInit: function () {
            
        },

        onRefresh: function () {
            var oBinding = this.byId("productsTable").getBinding("items");
            oBinding.refresh();
            MessageToast.show("Refreshed");
        }

    });
});