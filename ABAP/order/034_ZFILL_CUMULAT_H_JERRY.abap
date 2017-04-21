*&---------------------------------------------------------------------*
*& Report ZFILL_CRMD_SRV_REQ_H
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfill_cumulat_h_jerry.

DATA: ls_new_header TYPE zcrms4d_srvo_h,
      ls_header     TYPE crmd_orderadm_h,
      ls_cum_h      TYPE crmd_cumulat_h,
      lv_guid       TYPE crmt_object_guid VALUE 'FA163E8EAB031ED682EF2F89113485EF'.

SELECT SINGLE * INTO ls_header FROM crmd_orderadm_h
   WHERE guid = lv_guid.

CHECK sy-subrc = 0.

MOVE-CORRESPONDING ls_header TO ls_new_header.

SELECT SINGLE * INTO ls_cum_h FROM crmd_cumulat_h
   WHERE guid = lv_guid.
CHECK sy-subrc = 0.

MOVE-CORRESPONDING ls_cum_h TO ls_new_header.

INSERT zcrms4d_srvo_h FROM ls_new_header.

IF sy-subrc <> 0.
   update zcrms4d_srvo_h FROM ls_new_header.
ENDIF.