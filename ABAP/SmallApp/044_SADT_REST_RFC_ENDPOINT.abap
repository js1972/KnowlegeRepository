*&---------------------------------------------------------------------*
*& Report  ZTEST_RESOURCE
*&
*&---------------------------------------------------------------------*
* 2016-12-4 19:44PM Jerry's ABAP in Eclipse test - at Frankfort airplane to Chengdu 
*&
*&---------------------------------------------------------------------*

REPORT ztest_resource.
DATA: lv_request  TYPE sadt_rest_request,
      lv_response TYPE sadt_rest_response,
      lv_header   LIKE LINE OF lv_request-header_fields.

lv_request-request_line-method = 'GET'.
lv_request-request_line-uri = '/sap/bc/adt/crm/product/STAB_PROD_01'.
lv_request-request_line-version = 'HTTP/1.1'.

CALL FUNCTION 'SADT_REST_RFC_ENDPOINT'
  EXPORTING
    request  = lv_request
  IMPORTING
    response = lv_response.

BREAK-POINT.