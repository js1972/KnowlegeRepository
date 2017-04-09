REPORT ZDELETE_COMPARE.

* Jerry 2016-12-4 20:28PM - what is result ? :( on Aircraft from Frankfort to Beijing
PARAMETERS: num type i OBLIGATORY DEFAULT 100.

types: begin of ty_product,
      id type comm_product-product_id,
      text type string,
     end of ty_product.

data: lt_product type STANDARD TABLE OF ty_product,
      lt_product1 LIKE lt_product,
      lt_compare type STANDARD TABLE OF comm_product-product_id,
      lt_range type RANGE OF comm_product-product_id,
      lv_start TYPE i,
      lv_end TYPE i.

FIELD-SYMBOLS: <product> TYPE ty_product,
               <range> LIKE LINE OF lt_range.

START-OF-SELECTION.
  PERFORM generate_main_tab.
  PERFORM solution1.
  PERFORM solution2.
  ASSERT lt_product = lt_product1.


FORM generate_main_tab.
   DO num TIMES.
     APPEND INITIAL LINE TO lt_product ASSIGNING <product>.
     <product>-id = sy-index.
     <product>-text = sy-index.
     APPEND INITIAL LINE TO lt_product1 ASSIGNING <product>.
     <product>-id = sy-index.
     <product>-text = sy-index.

     IF ( sy-index MOD 2 = 0 ).
        APPEND sy-index TO lt_compare.
     ENDIF.
   ENDDO.
ENDFORM.

FORM solution1.
   GET RUN TIME FIELD lv_start.

   LOOP AT lt_product ASSIGNING FIELD-SYMBOL(<product1>).
     READ TABLE lt_compare WITH KEY table_line = <product1>-id TRANSPORTING NO FIELDS.
     IF sy-subrc <> 0.
       DELETE TABLE lt_product FROM <product1>.
     ENDIF.
   ENDLOOP.

   GET RUN TIME FIELD lv_end.
   lv_end = lv_end - lv_start.
  WRITE: / 'Solution1: ' , lv_end COLOR COL_NEGATIVE.
ENDFORM.

FORM solution2.
   GET RUN TIME FIELD lv_start.

   LOOP AT lt_compare ASSIGNING FIELD-SYMBOL(<valid>).
      APPEND INITIAL LINE TO lt_range ASSIGNING <range>.
      <range>-low = <valid>.
      <range>-option = 'EQ'.
      <range>-sign = 'I'.
   ENDLOOP.

   DELETE lt_product1 WHERE id NOT IN lt_range.

   GET RUN TIME FIELD lv_end.
   lv_end = lv_end - lv_start.
  WRITE: / 'Solution2: ' , lv_end COLOR COL_NEGATIVE.
ENDFORM.