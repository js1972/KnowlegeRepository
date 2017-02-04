*&---------------------------------------------------------------------*
*& Report ZFAKE_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfake_test.

CONSTANTS: cv_prod_guid TYPE crmt_object_guid VALUE '0123456789123456'.
DATA(ls_prod_header) = VALUE comt_product_ui( product_guid = cv_prod_guid
 product_id = 'I042416' product_type = '01' ).


DATA(ro_entity) = zcl_prod_unit_test_tool=>get_fake_bol_entity(
   iv_bol_name = 'Product'
   is_data = ls_prod_header
   iv_key = cv_prod_guid ).

DATA(lv_type) = ro_entity->get_property_as_string( 'PRODUCT_TYPE' ).
DATA(lv_guid) = ro_entity->get_property_as_string( 'PRODUCT_GUID' ).
DATA(lv_id) = ro_entity->get_property_as_string( 'PRODUCT_ID' ).

WRITE: / lv_type.
WRITE: / lv_guid.
WRITE: / lv_id.

data: ls_prod TYPE COMT_PRODUCT,
      lv_prodguid TYPE comm_product-product_guid.

ls_prod-product_type = '01'.

TRY.
CALL FUNCTION 'COM_PRODUCT_CREATEM'
  EXPORTING
     IV_SUPPRESS_NEW_ID = 'O'
  IMPORTING
     EV_PRODUCT_GUID = lv_prodguid
  CHANGING
     CS_PRODUCT = ls_prod.
CATCH cx_root INTO data(cx_root).
   WRITE:/ cx_root->get_text( ).
ENDTRY.

CLEAR: ls_prod.
CALL FUNCTION 'COM_PRODUCT_MAINTAIN_READ'
   EXPORTING
      IV_PRODUCT_GUID = lv_prodguid
   IMPORTING
      ES_PRODUCT = ls_prod
   EXCEPTIONS
      NOT_FOUND = 1
      INTERNAL_ERROR = 2.

WRITE: / sy-subrc.


BREAK-POINT.

*&---------------------------------------------------------------------*
*& Report ZFAKE_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfake_test.

CONSTANTS: cv_prod_guid TYPE crmt_object_guid VALUE '0123456789123456'.
DATA(ls_prod_header) = VALUE comt_product_ui( product_guid = cv_prod_guid
 product_id = 'I042416' product_type = '01' ).


DATA(ro_entity) = zcl_prod_unit_test_tool=>get_fake_bol_entity(
   iv_bol_name = 'Product'
   is_data = ls_prod_header
   iv_key = cv_prod_guid ).

DATA(lv_type) = ro_entity->get_property_as_string( 'PRODUCT_TYPE' ).
DATA(lv_guid) = ro_entity->get_property_as_string( 'PRODUCT_GUID' ).
DATA(lv_id) = ro_entity->get_property_as_string( 'PRODUCT_ID' ).

WRITE: / lv_type.
WRITE: / lv_guid.
WRITE: / lv_id.

data: ls_prod TYPE COMT_PRODUCT,
      lv_prodguid TYPE comm_product-product_guid.

ls_prod-product_type = '01'.

TRY.
CALL FUNCTION 'COM_PRODUCT_CREATEM'
  EXPORTING
     IV_SUPPRESS_NEW_ID = 'O'
  IMPORTING
     EV_PRODUCT_GUID = lv_prodguid
  CHANGING
     CS_PRODUCT = ls_prod.
CATCH cx_root INTO data(cx_root).
   WRITE:/ cx_root->get_text( ).
ENDTRY.

CLEAR: ls_prod.
CALL FUNCTION 'COM_PRODUCT_MAINTAIN_READ'
   EXPORTING
      IV_PRODUCT_GUID = lv_prodguid
   IMPORTING
      ES_PRODUCT = ls_prod
   EXCEPTIONS
      NOT_FOUND = 1
      INTERNAL_ERROR = 2.

WRITE: / sy-subrc.


BREAK-POINT.