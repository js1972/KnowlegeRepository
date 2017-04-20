*&---------------------------------------------------------------------*
*& Report Z_OLD_READ_ITEM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_old_read_item.

DATA: lt_header_guid TYPE crmt_object_guid_tab,
      lt_requested   TYPE crmt_object_name_tab,
      lv_requested   LIKE LINE OF lt_requested,
      lt_orderadm_i  TYPE crmt_orderadm_i_wrkt.

APPEND 'FA163E8EAB031ED682EF2F89113485EF' TO lt_header_guid.

CALL FUNCTION 'CRM_ORDER_READ'
  EXPORTING
    it_header_guid   = lt_header_guid
    iv_no_auth_check = abap_true.
*  IMPORTING
*    et_orderadm_i    = lt_orderadm_i.

BREAK-POINT.