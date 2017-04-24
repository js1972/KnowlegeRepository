*&---------------------------------------------------------------------*
*& Report ZFILL_CRMD_PRODUCT_I
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfill_crmd_product_i.

" this guid is used to query on table CRMD_PRODUCT_I
DATA: lv_prod_guid TYPE crmt_object_guid VALUE 'FA163EE56C3A1EE789BA15E33B2218B6'.

DATA: ls_admin_i   TYPE crmd_orderadm_i,
      ls_product_i TYPE crmd_product_i,
      ls_shadow_i  TYPE zcrms4d_btx_i,
      ls_main_item TYPE zcrms4d_svpr_i.

SELECT SINGLE * INTO ls_admin_i FROM crmd_orderadm_i WHERE guid = lv_prod_guid.
CHECK sy-subrc = 0.

SELECT SINGLE * INTO ls_product_i FROM crmd_product_i where guid = lv_prod_guid.
CHECK sy-subrc = 0.

ls_shadow_i-object_type = 'BUS2000140'.
ls_shadow_i-header_guid = ls_admin_i-header.
ls_shadow_i-item_guid = ls_admin_i-guid.

INSERT zcrms4d_btx_i FROM ls_shadow_i.
IF sy-subrc <> 0.
  UPDATE zcrms4d_btx_i FROM ls_shadow_i.
ENDIF.

MOVE-CORRESPONDING ls_admin_i TO ls_main_item.
MOVE-CORRESPONDING ls_product_i TO ls_main_item.
INSERT zcrms4d_svpr_i FROM ls_main_item.
IF sy-subrc <> 0.
  UPDATE zcrms4d_svpr_i FROM ls_main_item.
ENDIF.
WRITE: / sy-subrc.