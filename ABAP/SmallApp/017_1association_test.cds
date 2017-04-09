@AbapCatalog.sqlViewName: 'zcorder'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'association test'
define view Z_C_Order_Asso with parameters
    @Consumption.hidden: true
    @Environment.systemField: #SYSTEM_LANGUAGE
    P_Language              : sylangu

as select from Z_I_Order_Asso_Test {
   key Z_I_Order_Asso_Test.order_id,
   Z_I_Order_Asso_Test.order_type,
   Z_I_Order_Asso_Test._text[1: spras=$parameters.P_Language].type_text
}  

@AbapCatalog.sqlViewName: 'zorderass'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'association test'
define view Z_I_Order_Asso_Test 

as select from zorder association [1..*] to zorder_type_text as _text 
on $projection.order_type = _text.order_type {
  key zorder.order_id,
  zorder.order_type,
  @ObjectModel.association.type: #TO_COMPOSITION_CHILD
  _text
}    