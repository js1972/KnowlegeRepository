*&---------------------------------------------------------------------*
*& Report Z_NEW_READ_SRV_REQ_H
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_new_read_srv_req_h.

DATA: lt_header_guid TYPE crmt_object_guid_tab,
      lt_requested   TYPE crmt_object_name_tab,
      lv_request_obj TYPE crmt_object_name,
      lt_srv_req_h   TYPE crmt_srv_req_h_wrkt,
      lt_orderadm_h  TYPE crmt_orderadm_h_wrkt.

START-OF-SELECTION.

  APPEND '0090FA0D8DC21ED29A9E6E72D7F81A80' TO lt_header_guid.
  lv_request_obj = 'SRV_REQ_H'.
  INSERT lv_request_obj INTO TABLE lt_requested.

  CALL FUNCTION 'ZCRM_ORDER_READ'
    EXPORTING
      it_header_guid       = lt_header_guid
      it_requested_objects = lt_requested
      iv_no_auth_check     = abap_true
    IMPORTING
      et_orderadm_h        = lt_orderadm_h
      et_srv_req_h         = lt_srv_req_h.

  PERFORM print_result USING lt_orderadm_h lt_srv_req_h.

* read for the second time
  CLEAR: lt_orderadm_h, lt_srv_req_h.

  CALL FUNCTION 'ZCRM_ORDER_READ'
    EXPORTING
      it_header_guid       = lt_header_guid
      it_requested_objects = lt_requested
    IMPORTING
      et_orderadm_h        = lt_orderadm_h
      et_srv_req_h         = lt_srv_req_h.

  PERFORM print_result USING lt_orderadm_h lt_srv_req_h.

FORM print_result USING it_orderadm_h TYPE crmt_orderadm_h_wrkt
                         it_srv_req_h TYPE crmt_srv_req_h_wrkt.
  READ TABLE it_orderadm_h ASSIGNING FIELD-SYMBOL(<result>) INDEX 1.
  IF sy-subrc = 0.
    WRITE: / 'found order: ' , <result>-object_id, ' type:', <result>-process_type, ' description:' ,
     <result>-description.
  ENDIF.

  READ TABLE it_srv_req_h ASSIGNING FIELD-SYMBOL(<srv_req_h>) INDEX 1.
  IF sy-subrc = 0.
    WRITE: / 'Service request problem category:' , <srv_req_h>-problem_category.
    WRITE: / 'Impact: ' , <srv_req_h>-impact, ' escalation: ' , <srv_req_h>-escalation.
  ENDIF.
ENDFORM.