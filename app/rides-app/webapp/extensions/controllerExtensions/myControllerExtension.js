sap.ui.define([
  'jquery.sap.global',
  'sap/m/MessageToast',
  'sap/ui/core/mvc/ControllerExtension',
  'sap/ui/core/mvc/OverrideExecution'
], function (jQuery, MessageToast, ControllerExtension, OverrideExecution) {
  return ControllerExtension.extend('rides.extensions.controllerExtensions.myControllerExtension', {

    metadata: {
      methods: {
        handleCompletePress: {
          'public': true,
          'final': false,
          'overrideExecution': OverrideExecution.Instead
        }
      }
    },

    handleCompletePress: oEvent => {
        MessageToast.show("Button Pressed");
        return;
      
    }
  });
});