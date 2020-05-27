sap.ui.define([
  "jquery.sap.global",
  "sap/m/MessageToast",
  "sap/ui/core/mvc/ControllerExtension",
  "sap/ui/core/mvc/OverrideExecution"
], function (jQuery, MessageToast, ControllerExtension, OverrideExecution) {
    "use strict";
    return ControllerExtension.extend("rides-app.ext.controller.MyObjectPageExt", {
		override: {
            onAfterRendering: function () {
                MessageToast.show("Ext Called");
            }
        }        
    })
});

/*sap.ui.controller("rides-app.ext.controller.MyObjectPageExt", {
  onLaunchSurvey : function(oEvent) { 
      //
      alert("Hello!");
   }
}*/