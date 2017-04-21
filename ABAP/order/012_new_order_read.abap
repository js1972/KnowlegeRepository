*&---------------------------------------------------------------------*
*& Report Z_NEW_ORDER_READ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_new_order_read.

DATA: lt_header_guid TYPE crmt_object_guid_tab,
      lt_cum_h       TYPE crmt_cumulat_h_wrkt,
      lt_orderadm_h  TYPE crmt_orderadm_h_wrkt.

START-OF-SELECTION.

  " it is a service order
  APPEND '00163EA720041EE29F86484C5645774D' TO lt_header_guid.

  CALL FUNCTION 'ZCRM_ORDER_READ'
    EXPORTING
      it_header_guid   = lt_header_guid
      iv_no_auth_check = abap_true
    IMPORTING
      et_cumulat_h     = lt_cum_h
      et_orderadm_h    = lt_orderadm_h.

  PERFORM print_result USING lt_orderadm_h lt_cum_h.

  CLEAR: lt_cum_h, lt_orderadm_h.

  CALL FUNCTION 'ZCRM_ORDER_READ'
    EXPORTING
      it_header_guid   = lt_header_guid
      iv_no_auth_check = abap_true
    IMPORTING
      et_cumulat_h     = lt_cum_h
      et_orderadm_h    = lt_orderadm_h.

  PERFORM print_result USING lt_orderadm_h lt_cum_h.

FORM print_result USING it_order TYPE crmt_orderadm_h_wrkt
                         it_cum_h TYPE crmt_cumulat_h_wrkt.
  READ TABLE it_order INTO DATA(is_order) INDEX 1.
  READ TABLE it_cum_h INTO DATA(is_cum_h) INDEX 1.
  WRITE: / 'Order:' , is_order-object_id, ' Gross weight:', is_cum_h-gross_weight.
ENDFORM.