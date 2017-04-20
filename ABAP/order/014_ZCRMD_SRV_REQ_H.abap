*&---------------------------------------------------------------------*
*& Report ZCRMD_SRV_REQ_H
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCRMD_SRV_REQ_H.
DATA: lt_seq_h TYPE TABLE OF CRMD_SRV_REQ_H,
      lt_order type TABLE OF crmd_orderadm_h,
      lt_proc_Type_t type table of crmc_proc_type_t,
      lt_proc_type type SORTED TABLE OF crmc_proc_type-process_type with UNIQUE KEY TABLE_LINE.

SELECT * INTO TABLE lt_seq_h FROM CRMD_SRV_REQ_H.

check sy-subrc = 0.

select * INTO TABLE lt_order FROM crmd_orderadm_h for ALL ENTRIES IN lt_seq_h
   where guid = lt_seq_h-guid.

LOOP AT lt_order ASSIGNING FIELD-SYMBOL(<order>).
   INSERT <order>-process_type INTO TABLE lt_proc_type.
ENDLOOP.

SELECT * INTO TABLE lt_proc_Type_t FROM crmc_proc_type_t
   for ALL ENTRIES IN lt_proc_type where process_type = lt_proc_type-TABLE_LINE
   and langu = sy-langu.

LOOP at lt_proc_Type_t ASSIGNING FIELD-SYMBOL(<type>).
   WRITE: / <type>-process_type, ' description: ' , <type>-p_description.
ENDLOOP.