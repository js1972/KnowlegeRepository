*&---------------------------------------------------------------------*
*& Report ZTEST_ZCRM_ORDERADM_I_READ_OB
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTEST_ZCRM_ORDERADM_I_READ_OB.

data: lt_item TYPE CRMT_ORDERADM_I_WRKT.
START-OF-SELECTION.

call FUNCTION 'ZCRM_ORDERADM_I_READ_OB'
   EXPORTING
      iv_header = 'FA163E8EAB031ED682EF2F89113485EF'
   IMPORTING
      ET_ORDERADM_I_WRK = lt_item.

PERFORM print_item using lt_item.
CLEAR: lt_item.

call FUNCTION 'ZCRM_ORDERADM_I_READ_OB'
   EXPORTING
      iv_header = 'FA163E8EAB031ED682EF2F89113485EF'
   IMPORTING
      ET_ORDERADM_I_WRK = lt_item.

PERFORM print_item using lt_item.

FORM print_item USING it_item TYPE CRMT_ORDERADM_I_WRKT.
   READ TABLE it_item INTO data(is_item) INDEX 1.
   WRITE: / 'item:', is_item-product.
ENDFORM.