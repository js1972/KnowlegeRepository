*&---------------------------------------------------------------------*
*& Report ZFILL_ZCRMS4D_SRVO_I
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfill_zcrms4d_svpr_i.

DATA: lv_item_guid  TYPE crmt_object_guid VALUE 'FA163EE56C3A1EE789B8E2CDC940D4CD',
      ls_orderadm_i TYPE crmd_orderadm_i,
      ls_svpr_i     TYPE zcrms4d_svpr_i.

SELECT SINGLE * INTO ls_orderadm_i FROM crmd_orderadm_i WHERE guid = lv_item_guid.
CHECK sy-subrc = 0.

MOVE-CORRESPONDING ls_orderadm_i TO ls_svpr_i.

INSERT zcrms4d_svpr_i FROM ls_svpr_i.