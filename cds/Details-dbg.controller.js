sap.ui.define(["sap/suite/ui/generic/template/lib/TemplateViewController", "sap/m/Table", "sap/m/Button", "sap/m/ActionSheet", "sap/ushell/ui/footerbar/AddBookmarkButton"], function(BaseController, Table, Button, ActionSheet, AddBookmarkButton) {
	"use strict";

	return BaseController.extend("sap.suite.ui.generic.template.ObjectPage.view.Details", {

		onInit: function() {
			BaseController.prototype.onInit.apply(this, arguments);
			this.triggerPrepareOnEnterKeyPress();
			var bShell = false;
			try {
				bShell = (sap.ushell && sap.ushell.Container && sap.ushell.Container.getService("URLParsing").isIntentUrl(document.URL)) ? true : false;
			} catch (err) {
				jQuery.sap.log.error("Detail.controller: UShell service is not available.");
			}
			var oAdminModel = new sap.ui.model.json.JSONModel({
				HasDetail: !this.getOwnerComponent().getIsLeaf(),
				HasShell: bShell
			});
			oAdminModel.setDefaultBindingMode("OneWay");
			this.getView().setModel(oAdminModel, "admin");
		},

		onPressDraftInfo : function(oEvent) {
			var oContext = this.getContext();
			var oLockButton = {};
			if (oEvent.getId() === 'markChangesPress') {
				oLockButton = sap.ui.getCore().byId(oEvent.getSource().getId() + "-changes");
			} else if (oEvent.getId() === 'markLockedPress') {
				oLockButton = sap.ui.getCore().byId(oEvent.getSource().getId() + "-lock");
			}

			BaseController.prototype.fnDraftPopover.call(this, this, oContext, this.oView, oLockButton);
		},

		onShareObjectPageActionButtonPress: function(oEvent) {
			var oButton = oEvent.getSource();
			var oResource = sap.ui.getCore().getLibraryResourceBundle("sap.m");
			var oAddBookmarkButton;
			var sObjectHeader = this.getView().byId("objectPage").getAggregation("headerTitle");
			var fnGetUser = jQuery.sap.getObject("sap.ushell.Container.getUser");
			if (!this._actionSheet) {
				if (sap.ushell) {
					oAddBookmarkButton = new AddBookmarkButton({
						text: oResource.getText("SEMANTIC_CONTROL_SAVE_AS_TILE"),
						title: sObjectHeader.getProperty("objectTitle"),
						subtitle: sObjectHeader.getProperty("objectSubtitle"),
						customUrl: document.URL
					});
				}
				this._actionSheet = new ActionSheet({
					buttons: [new Button({
									text: oResource.getText("SEMANTIC_CONTROL_SEND_EMAIL"),
									icon: "sap-icon://email",
									press: this.onShareObjectPageEmailPress
								}),
								new Button({
									text: oResource.getText("SEMANTIC_CONTROL_SHARE_IN_JAM"),
									visible: fnGetUser ? fnGetUser().isJamActive() : false,
									icon: "sap-icon://share-2",
									press: this.onShareObjectPageInJamPress
								}),
								oAddBookmarkButton
					]
				});
				this._actionSheet._objectTitle = sObjectHeader.getProperty("objectTitle");
				this._actionSheet._objectSubtitle = sObjectHeader.getProperty("objectSubtitle");
				this.getView().addDependent(this._actionSheet);
			}
			this._actionSheet.openBy(oButton);
		},

		onShareObjectPageEmailPress: function(oEvent){
			var oParent = this.getParent();
			var sEmailSubject = oParent._objectTitle;
			if (oParent._objectSubtitle) {
				sEmailSubject = sEmailSubject + " - " + oParent._objectSubtitle;
			}
			sap.m.URLHelper.triggerEmail(null, sEmailSubject, document.URL);
		},

		onShareObjectPageInJamPress: function(oEvent) {
			var oParent = this.getParent();
			var oShareDialog = sap.ui.getCore().createComponent({
				name : "sap.collaboration.components.fiori.sharing.dialog",
				settings : {
					object : {
						id : document.URL,
						share : oParent._objectTitle + " " + oParent._objectSubtitle
					}
				}
			});
			oShareDialog.open();
		}
	});
}, /* bExport= */true);