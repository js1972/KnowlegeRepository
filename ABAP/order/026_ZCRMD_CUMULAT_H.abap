*&---------------------------------------------------------------------*
*& Report ZCRMD_CUMULAT_H
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcrmd_cumulat_h.

DATA: lt_crmd_cumu_h TYPE TABLE OF crmd_cumulat_h,
      lt_order type TABLE OF crmd_orderadm_h.

select * INTO TABLE lt_order FROM crmd_orderadm_h where process_type = 'SRVO'.

SELECT * INTO TABLE lt_crmd_cumu_h FROM crmd_cumulat_h for ALL ENTRIES IN lt_order
   where guid = lt_order-guid.

delete lt_crmd_cumu_h where gross_weight = space.

LOOP AT lt_crmd_cumu_h ASSIGNING FIELD-SYMBOL(<cumu>).
   READ TABLE lt_order ASSIGNING FIELD-SYMBOL(<order>) with key guid = <cumu>-guid.
   check sy-subrc = 0.
   WRITE: / <order>-object_id.
ENDLOOP.