var oModl = new sap.ui.model.json.JSONModel();
		//the json text has to be a straight string, can't /n!  ,otherwise cannot parse!
		oModl.setJSON('{"selection":"please select a name","data":[{"text":"Jerry","key":"Jerry"},{"text":"vicky","key":"vicky"},{"text":"sara","key":"sara"}]}');
		var oListItem0 = new sap.ui.core.ListItem("li",{
			text:"{text}",
			key:"{key}"
		});
		//sorter
		var oSorter = new sap.ui.model.Sorter("text",true); //descend
		//filter : the value is case ignore
		//the path parameter shoult be the data array's var name. here is text
		var oFilter = new sap.ui.model.Filter("text",sap.ui.model.FilterOperator.StartsWith, 'v');
		var oTextField = new sap.ui.commons.TextField({id:"tf",value:""});
		var oComoBox = new sap.ui.commons.ComboBox("cb",{
			//items:{path:"/data",template:oListItem0,filters:[oFilter]},
			change:function(oEvent){
				sap.ui.getCore().byId("tf").setValue(oEvent.oSource.getSelectedKey());
			}
		});
		var oLayout = new sap.ui.layout.HorizontalLayout("lyt");
		oLayout.addContent(oComoBox);
		oLayout.addContent(oTextField);

		oComoBox.setModel(oModl);
		oComoBox.bindValue("/selection"); 
		oComoBox.bindItems("/data", oListItem0,null,oFilter);//path,template,sorter,filter
		//oComoBox.bindItems("/data", oListItem0,oSorter);
		var tf1 = new sap.ui.commons.TextField("tf1");
		var tfv = new sap.ui.commons.TextView();
		var but = new sap.ui.commons.Button({
			text:"submit",
			press:function(evt){
				//tfv.setText(sap.ui.getCore().byId("tf1").getValue());
				oModlData.setData({name:sap.ui.getCore().byId("tf1").getValue()});
			}
		});
		
		var oData = {"name":"wenxin"};
		var oModlData = new sap.ui.model.json.JSONModel();
		
		tf1.setModel(oModlData);
		tfv.setModel(oModlData);
		
		oModlData.setData(oData);
		tf1.bindProperty("value","/name");// has to b("property","/path")
		//formatter
		tfv.bindProperty("text",{path:"/name",formatter:oController.toUpperCase});	
	
		oLayout.addContent(tf1);
		oLayout.addContent(tfv);
		oLayout.addContent(but);
		return oLayout;