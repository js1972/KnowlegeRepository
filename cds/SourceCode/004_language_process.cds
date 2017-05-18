@AbapCatalog.sqlViewName: 'CRMS4VSALEI'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
// See this blog: https://blogs.sap.com/2016/10/28/abap-news-release-7.51-abap-cds-client-handling/
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'View on Sales Item DB table'

define view CRMS4V_SALE_I 
 with parameters
    @Environment.systemField: #SYSTEM_LANGUAGE
    P_Language : spras
    as select from crms4d_sale_i as Sale_I 
    inner join scpriot on  Sale_I.header_priority = scpriot.priority
                                  and scpriot.langu = $parameters.P_Language
{
   key Sale_I.guid as item_guid,
   Sale_I.header_object_id as object_id,
   Sale_I.header_description as description,
   Sale_I.header_posting_date as posting_date,
   Sale_I.ordered_prod as product_id,
   Sale_I.header_guid as guid,
   Sale_I.header_priority as priority,
   scpriot.txt_long as priority_txt,
   $parameters.P_Language as Language
}
consume:  
SELECT * FROM crms4v_sale_i( p_language = @sy-langu )
        WHERE (lv_where) INTO TABLE @lt_item UP TO 100 ROWS.

Another solution:
@AbapCatalog.sqlViewName: 'CRMS4VSALEI'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
// See this blog: https://blogs.sap.com/2016/10/28/abap-news-release-7.51-abap-cds-client-handling/
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'View on Sales Item DB table'

define view CRMS4V_SALE_I as select from crms4d_sale_i as Sale_I 
    inner join scpriot on  Sale_I.header_priority = scpriot.priority
                                  and scpriot.langu = $session.system_language
{
   key Sale_I.guid as item_guid,
   Sale_I.header_object_id as object_id,
   Sale_I.header_description as description,
   Sale_I.header_posting_date as posting_date,
   Sale_I.ordered_prod as product_id,
   Sale_I.header_guid as guid,
   Sale_I.header_priority as priority,
   scpriot.txt_long as priority_txt
}
