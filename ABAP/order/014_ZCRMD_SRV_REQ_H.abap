*&---------------------------------------------------------------------*
*& Report ZCRMD_SRV_REQ_H
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCRMD_SRV_REQ_H.
DATA: lt_seq_h TYPE TABLE OF CRMD_SRV_REQ_H,
      lt_order type TABLE OF crmd_orderadm_h.

SELECT * INTO TABLE lt_seq_h FROM CRMD_SRV_REQ_H.

check sy-subrc = 0.

select * INTO TABLE lt_order FROM crmd_orderadm_h for ALL ENTRIES IN lt_seq_h
   where guid = lt_seq_h-guid.

BREAK-POINT.