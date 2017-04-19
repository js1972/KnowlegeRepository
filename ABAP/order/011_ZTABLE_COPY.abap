*&---------------------------------------------------------------------*
*& Report ZTABLE_COPY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTABLE_COPY.

data: lv_src_name type string value 'CRMC_SUBOB_CAT',
      lv_target_name TYPE string VALUE 'ZCRMC_SUBOB_CAT',
      lr_source TYPE REF TO data.

FIELD-SYMBOLS: <src_tab> TYPE ANY TABLE.
CREATE DATA lr_source TYPE TABLE OF (lv_src_name).

ASSIGN lr_source->* TO <src_tab>.

SELECT * INTO TABLE <src_tab> FROM (lv_src_name).

BREAK-POINT.