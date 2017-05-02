report z.

DATA: lt_header_guid TYPE crmt_object_guid_tab,
      lt_requested   TYPE crmt_object_name_tab,
      lv_request_obj TYPE crmt_object_name,
      lt_srv_req_h   TYPE crmt_srv_req_h_wrkt,
      lt_orderadm_h  TYPE crmt_orderadm_h_wrkt,
      lt_orderadm_i  TYPE CRMT_ORDERADM_I_WRKT,
      lt_cum_h       TYPE CRMT_CUMULAT_H_WRKT.

START-OF-SELECTION.

  DATA(ls_header) = value crmd_orderadm_h( object_id = '8000000072'
                                            guid = '6C0B84B754971ED78B83CC0F775F5A1A' ).
  APPEND ls_header-guid TO lt_header_guid.
  lv_request_obj = 'CUMULAT_H'.
  INSERT lv_request_obj INTO TABLE lt_requested.

  CALL FUNCTION 'CRM_ORDER_READ'
    EXPORTING
      it_header_guid       = lt_header_guid
      it_requested_objects = lt_requested
      iv_no_auth_check     = abap_true
    IMPORTING
      ET_CUMULAT_H = lt_cum_h
      ET_ORDERADM_i = lt_orderadm_i.

 READ TABLE lt_cum_h INTO DATA(ls_cum_h) INDEX 1.
 READ TABLE lt_orderadm_i INTO DATA(ls_order_i) INDEX 1.
 IF ls_cum_h IS NOT INITIAL.
    WRITE:/ 'Gross weight in header:' COLOR COL_NEGATIVE, ls_cum_h-gross_weight
       COLOR COL_POSITIVE.
 ENDIF.

 IF ls_order_i IS NOT INITIAL.
    WRITE:/ 'line item:' COLOR COL_GROUP, ls_order_i-description COLOR COL_KEY.
 ENDIF.