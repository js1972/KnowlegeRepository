// subscribe for events triggered from S3 controller
						var oBus = sap.ui.getCore().getEventBus();
						oBus.subscribe("cus.crm.notes", "SectionChanged",
								this.handleSectionChanged, this);

						sap.ui.getCore().getEventBus().publish(
									"cus.crm.notes", "SectionChanged", {
										context : true
									});