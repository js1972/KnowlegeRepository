REPORT ZSIMULATE.

data: lt_sales_area_all TYPe CRMT_BUS_SALES_AREA_T,
      ls_sales_area LIKE LINE OF lt_sales_area_all,
      lt_sales_area_some TYPE CRMT_BUS_SALES_AREA_T,
      lv_sale_org TYPE CRMT_BUS_SALES_AREA-sales_org,
      lv_some TYPE int4 value 40000,
      lv_value TYPE int4,
      lv_all TYPE int4 value 450,
      lv_start TYPE int4,
      lv_end TYPE int4.

START-OF-SELECTION.

DO lv_some TIMES.
  ls_sales_area-sales_org = sy-index.
  PERFORM get_two_digit USING sy-index CHANGING ls_sales_area-division.
  PERFORM get_two_digit USING sy-index CHANGING ls_sales_area-channel.
  APPEND ls_sales_area TO lt_sales_area_some.
ENDDO.

lt_sales_area_all = lt_sales_area_some.

DO lv_all TIMES.
   lv_value = sy-index + lv_some.
   ls_sales_area-sales_org = lv_value.
   PERFORM get_two_digit USING sy-index CHANGING ls_sales_area-division.
   PERFORM get_two_digit USING sy-index CHANGING ls_sales_area-channel.
   APPEND ls_sales_area TO lt_sales_area_all.
ENDDO.

GET RUN TIME FIELD lv_start.

LOOP AT lt_sales_area_some ASSIGNING FIELD-SYMBOL(<some>).
   READ TABLE lt_sales_area_all WITH KEY table_line = <some> TRANSPORTING NO FIELDS.
   IF sy-subrc <> 0.
      WRITE:/ 'not found'.
   ENDIF.
ENDLOOP.

GET RUN TIME FIELD lv_end.

lv_end = lv_end - lv_start.

WRITE: / 'end: ' , lv_end.


GET RUN TIME FIELD lv_start.

LOOP AT lt_sales_area_some ASSIGNING FIELD-SYMBOL(<some2>).
   READ TABLE lt_sales_area_all WITH key sales_org = <some2>-sales_org channel = <some2>-channel division = <some2>-division
    TRANSPORTING NO FIELDS.
   IF sy-subrc <> 0.
      WRITE:/ 'not found'.
   ENDIF.
ENDLOOP.

GET RUN TIME FIELD lv_end.

lv_end = lv_end - lv_start.

WRITE: / 'end2: ' , lv_end.

FORM get_two_digit USING iv_index TYPE int4 CHANGING cv_value TYPE any.
   cv_value = iv_index MOD 9.
ENDFORM.