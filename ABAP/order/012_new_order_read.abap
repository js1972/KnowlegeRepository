*&---------------------------------------------------------------------*
*& Report Z_NEW_ORDER_READ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_NEW_ORDER_READ.

DATA: LT_HEADER_GUID TYPE CRMT_OBJECT_GUID_TAB,
      LT_ORDERADM_H TYPE CRMT_ORDERADM_H_WRKT.

APPEND 'FA163E8EAB031ED682EF2F89113485EF' TO LT_HEADER_GUID.

call FUNCTION 'ZCRM_ORDER_READ'
 EXPORTING
    IT_HEADER_GUID = LT_HEADER_GUID
 IMPORTING
    ET_ORDERADM_H = LT_ORDERADM_H.

BREAK-POINT.