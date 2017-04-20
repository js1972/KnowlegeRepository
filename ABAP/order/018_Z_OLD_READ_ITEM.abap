*&---------------------------------------------------------------------*
*& Report Z_OLD_READ_ITEM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_OLD_READ_ITEM.

DATA: lt_header_guid TYPE crmt_object_guid_tab,
      lt_orderadm_i  TYPE crmt_orderadm_i_wrkt.

APPEND 'FA163E8EAB031ED682EF2F89113485EF' TO lt_header_guid.

CALL FUNCTION 'CRM_ORDER_READ'
  EXPORTING
    it_header_guid = lt_header_guid
  IMPORTING
    et_orderadm_i  = lt_orderadm_i.

BREAK-POINT.