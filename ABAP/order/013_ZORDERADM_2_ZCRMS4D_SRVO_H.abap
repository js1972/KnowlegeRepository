*&---------------------------------------------------------------------*
*& Report ZORDERADM_2_ZCRMS4D_SRVO_H
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zorderadm_2_zcrms4d_srvo_h.

DATA: ls_source   TYPE crmd_orderadm_h,
      lv_src_guid TYPE crmd_orderadm_h-guid VALUE 'FA163EEF573D1ED5808E7E04835A02E9',
      ls_target   TYPE zcrms4d_srvo_h.

SELECT SINGLE * INTO ls_source FROM crmd_orderadm_h WHERE guid = lv_src_guid.
CHECK sy-subrc = 0.

MOVE-CORRESPONDING ls_source TO ls_target.

INSERT zcrms4d_srvo_h FROM ls_target.

IF sy-subrc <> 0.
  UPDATE zcrms4d_srvo_h FROM ls_target.
ENDIF.

WRITE: / sy-subrc.