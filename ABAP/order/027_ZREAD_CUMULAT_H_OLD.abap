report z.

DATA: lv_id TYPE crmd_orderadm_h-object_id VALUE '8000000072',
      lv_guid TYPe crmt_object_guid,
      lt_header_guid TYPE crmt_object_guid_tab,
      lt_requested   TYPE crmt_object_name_tab,
      lv_request_obj TYPE crmt_object_name,
      lt_srv_req_h   TYPE crmt_srv_req_h_wrkt,
      lt_orderadm_h  TYPE crmt_orderadm_h_wrkt,
      lt_orderadm_i  TYPE CRMT_ORDERADM_I_WRKT,
      lt_cum_h       TYPE CRMT_CUMULAT_H_WRKT.

START-OF-SELECTION.

  SELECT single guid INTO lv_guid FROM crmd_orderadm_h where object_id = lv_id.
  IF sy-subrc <> 0.
     WRITE: / 'Service Order does not exist:' , lv_id.
     RETURN.
  ENDIF.
  APPEND lv_guid TO lt_header_guid.
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
      ET_CUMULAT_H = lt_cum_h
      ET_ORDERADM_i = lt_orderadm_i.

  BREAK-POINT.