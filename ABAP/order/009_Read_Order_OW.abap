*&---------------------------------------------------------------------*
*& Report ZREAD_ORDER_OW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZREAD_ORDER_OW.

data: lt_header_guid TYPE CRMT_OBJECT_GUID_TAB,
      lt_orderadm_h type CRMT_ORDERADM_H_WRKT,
      lv_handle TYPE BALLOGHNDL.

append '00163EA720001ED29D9420A624836ED3' to lt_header_guid.

call FUNCTION 'CRM_ORDER_READ_OW'
  EXPORTING
     IT_HEADER_GUID = lt_header_guid
  IMPORTING
     ET_ORDERADM_H = lt_orderadm_h
  CHANGING
     CV_LOG_HANDLE = lv_handle.

BREAK-POINT.