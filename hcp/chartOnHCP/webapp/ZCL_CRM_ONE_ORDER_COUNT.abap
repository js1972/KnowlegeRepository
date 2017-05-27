class ZCL_CRM_ONE_ORDER_COUNT definition
  public
  final
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CRM_ONE_ORDER_COUNT IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_CRM_ONE_ORDER_COUNT->IF_HTTP_EXTENSION~HANDLE_REQUEST
* +-------------------------------------------------------------------------------------------------+
* | [--->] SERVER                         TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD if_http_extension~handle_request.
    server->response->set_header_field(
         EXPORTING
           name  = 'Access-Control-Allow-Origin'
           value = '*' ).

    zcl_crm_order_statistic=>count( ).
    DATA(item) = zcl_crm_order_statistic=>get_item_json( ).
    DATA(sale) = zcl_crm_order_statistic=>get_sales_json( ).
    DATA(service) = zcl_crm_order_statistic=>get_service_json( ).
    DATA(lv_text) = |\{"data": \{"item": { item }, "sale": { sale }, "service": { service }\}\}|.
    server->response->append_cdata(
                         data   = lv_text
                         length = strlen( lv_text ) ).
  ENDMETHOD.
ENDCLASS.