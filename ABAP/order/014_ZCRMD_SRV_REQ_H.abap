*&---------------------------------------------------------------------*
*& Report ZCRMD_SRV_REQ_H
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcrmd_srv_req_h.
DATA: lt_seq_h       TYPE TABLE OF crmd_srv_req_h,
      lt_order       TYPE TABLE OF crmd_orderadm_h,
      lt_proc_type_t TYPE TABLE OF crmc_proc_type_t,
      lt_proc_type   TYPE SORTED TABLE OF crmc_proc_type-process_type WITH UNIQUE KEY table_line.

SELECT * INTO TABLE lt_seq_h FROM crmd_srv_req_h.

CHECK sy-subrc = 0.

SELECT * INTO TABLE lt_order FROM crmd_orderadm_h FOR ALL ENTRIES IN lt_seq_h
   WHERE guid = lt_seq_h-guid.

"DELETE lt_order where created_by <> sy-uname.

LOOP AT lt_order ASSIGNING FIELD-SYMBOL(<order>).
  INSERT <order>-process_type INTO TABLE lt_proc_type.
ENDLOOP.

*loop at lt_order ASSIGNING FIELD-SYMBOL(<srvo>) where process_type = 'SRVO'.
*   BREAK-POINT.
*ENDLOOP.

DELETE lt_order WHERE process_type <> 'SRVO'.
LOOP AT lt_order ASSIGNING FIELD-SYMBOL(<order_with_seq>).
   READ TABLE lt_seq_h ASSIGNING FIELD-SYMBOL(<seq>) with key guid = <order_with_seq>-guid.
ENDLOOP.

SELECT * INTO TABLE lt_proc_type_t FROM crmc_proc_type_t
   FOR ALL ENTRIES IN lt_proc_type WHERE process_type = lt_proc_type-table_line
   AND langu = sy-langu.

LOOP AT lt_proc_type_t ASSIGNING FIELD-SYMBOL(<type>).
  WRITE: / <type>-process_type, ' description: ' , <type>-p_description.
ENDLOOP.