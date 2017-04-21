*&---------------------------------------------------------------------*
*& Report ZREAD_CUMULAT_H_OLD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZREAD_CUMULAT_H_OLD.

DATA: lt_header_guid TYPE crmt_object_guid_tab,
      lt_requested   TYPE crmt_object_name_tab,
      lv_request_obj TYPE crmt_object_name,
      lt_srv_req_h   TYPE crmt_srv_req_h_wrkt,
      lt_orderadm_h  TYPE crmt_orderadm_h_wrkt,
      lt_cum_h       TYPE CRMT_CUMULAT_H_WRKT.

START-OF-SELECTION.

  APPEND '00163EA720041EE29F86484C5645774D' TO lt_header_guid.
  lv_request_obj = 'CUMULAT_H'.
  INSERT lv_request_obj INTO TABLE lt_requested.

  CALL FUNCTION 'CRM_ORDER_READ'
    EXPORTING
      it_header_guid       = lt_header_guid
      it_requested_objects = lt_requested
      iv_no_auth_check     = abap_true
    IMPORTING
      ET_CUMULAT_H = lt_cum_h.

  CLEAR: lt_cum_h.

  CALL FUNCTION 'CRM_ORDER_READ'
    EXPORTING
      it_header_guid       = lt_header_guid
      it_requested_objects = lt_requested
      iv_no_auth_check     = abap_true
    IMPORTING
      ET_CUMULAT_H = lt_cum_h.