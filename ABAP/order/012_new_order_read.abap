*&---------------------------------------------------------------------*
*& Report Z_NEW_ORDER_READ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_new_order_read.

DATA: lt_header_guid TYPE crmt_object_guid_tab,
      lt_orderadm_h  TYPE crmt_orderadm_h_wrkt.

" it is a service order
APPEND 'FA163E8EAB031ED682EF2F89113485EF' TO lt_header_guid.

CALL FUNCTION 'ZCRM_ORDER_READ'
  EXPORTING
    it_header_guid = lt_header_guid
  IMPORTING
    et_orderadm_h  = lt_orderadm_h.

READ TABLE lt_orderadm_h ASSIGNING FIELD-SYMBOL(<result>) INDEX 1.
IF sy-subrc = 0.
  WRITE: / 'found order: ' , <result>-object_id, ' type:', <result>-process_type, ' description:' ,
   <result>-description.
ENDIF.

CLEAR: lt_orderadm_h.
* this time result should directly be returned from buffer.
CALL FUNCTION 'ZCRM_ORDER_READ'
  EXPORTING
    it_header_guid = lt_header_guid
  IMPORTING
    et_orderadm_h  = lt_orderadm_h.

READ TABLE lt_orderadm_h ASSIGNING <result> INDEX 1.
IF sy-subrc = 0.
  WRITE: / 'found order: ' , <result>-object_id, ' type:', <result>-process_type, ' description:' ,
   <result>-description.
ENDIF.