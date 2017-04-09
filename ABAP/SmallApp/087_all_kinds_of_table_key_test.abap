REPORT ztest_key.

TYPES: BEGIN OF ty_data,
         index TYPE int4,
         name  TYPE char10,
         score TYPE int4,
         text  TYPE string,
       END OF ty_data.

TYPES: tt_data1 TYPE STANDARD TABLE OF ty_data,
       "tt_data2 type STANDARD  TABLE OF ty_data with UNIQUE key dsf. SYNTAX ERROR
       tt_data2 TYPE SORTED TABLE OF ty_data WITH UNIQUE KEY score,
       tt_data3 TYPE SORTED TABLE OF ty_data WITH UNIQUE KEY primary_key COMPONENTS name score
         WITH NON-UNIQUE SORTED KEY k1 COMPONENTS text.

DATA: lt_table1 TYPE tt_data1,
      lt_table2 TYPE tt_data2,
      lt_table3 TYPE tt_data3.

READ TABLE lt_table1 TRANSPORTING NO FIELDS WITH KEY index = 1.
READ TABLE lt_table1 TRANSPORTING NO FIELDS WITH KEY name = 'Jerry'.
READ TABLE lt_table1 TRANSPORTING NO FIELDS WITH KEY score = 20.
READ TABLE lt_table1 TRANSPORTING NO FIELDS WITH KEY text = 'Jerry'.

"READ TABLE lt_table1 TRANSPORTING NO FIELDS WITH TABLE KEY index = 1.
" Specification for component "NAME" of key "PRIMARY_KEY" of table "LT_TABLE1" is missing or incomplete.
" Key must be completely provided.

READ TABLE lt_table1 TRANSPORTING NO FIELDS WITH TABLE KEY name = 'Jerry' text = 'Text'.

READ TABLE lt_table2 TRANSPORTING NO FIELDS WITH KEY index = 1.
READ TABLE lt_table2 TRANSPORTING NO FIELDS WITH KEY name = 'Jerry'.
READ TABLE lt_table2 TRANSPORTING NO FIELDS WITH KEY score = 20.
READ TABLE lt_table2 TRANSPORTING NO FIELDS WITH KEY text = 'Jerry'.

"Syntax error
" Jerry 2016-12-4 11:44PM - it seems *READ XXXX WITH TABLE KEY* can only work if explicit table key is defined
" using keyword WITH UNIQUE KEY or WITH NON-UNIQUE KEY

"READ TABLE lt_table2 TRANSPORTING NO FIELDS WITH TABLE KEY index = 1.

"syntax error
"READ TABLE lt_table2 TRANSPORTING NO FIELDS WITH TABLE KEY name = 'Jerry'.

READ TABLE lt_table2 TRANSPORTING NO FIELDS WITH TABLE KEY score = 20.
"Syntax error

"syntax error
"READ TABLE lt_table3 TRANSPORTING NO FIELDS WITH TABLE KEY text = 'Jerry'.

"syntax error
"READ TABLE lt_table3 TRANSPORTING NO FIELDS WITH TABLE KEY name = 'Jerry'.

"syntax error
"READ TABLE lt_table3 TRANSPORTING NO FIELDS WITH TABLE KEY score = 20.

READ TABLE lt_table3 TRANSPORTING NO FIELDS WITH TABLE KEY name = 'Jerry' score = 20.

READ TABLE lt_table3 TRANSPORTING NO FIELDS WITH TABLE KEY k1 COMPONENTS text = 'this is text'.

DATA(type1) = CAST cl_abap_tabledescr( cl_abap_typedescr=>describe_by_data( lt_table1 ) ).

DATA(lt_keys1) = type1->get_keys( ).
WRITE:/ 'Key information for lt_key1...' COLOR COL_KEY.
PERFORM print USING lt_keys1.


DATA(type2) = CAST cl_abap_tabledescr( cl_abap_typedescr=>describe_by_data( lt_table2 ) ).

DATA(lt_keys2) = type2->get_keys( ).
WRITE:/ 'Key information for lt_key2...' COLOR COL_KEY.
PERFORM print USING lt_keys2.

DATA(type3) = CAST cl_abap_tabledescr( cl_abap_typedescr=>describe_by_data( lt_table3 ) ).

DATA(lt_keys3) = type3->get_keys( ).
WRITE:/ 'Key information for lt_key3...' COLOR COL_KEY.
PERFORM print USING lt_keys3.

FORM print USING it_table TYPE abap_table_keydescr_tab.
  LOOP AT it_table ASSIGNING FIELD-SYMBOL(<item>) WHERE is_primary = abap_true.
    WRITE: / 'The following fields are primary key:' COLOR COL_GROUP.
    LOOP AT <item>-components ASSIGNING FIELD-SYMBOL(<data>).
      WRITE: / <data> COLOR COL_NEGATIVE.
    ENDLOOP.
  ENDLOOP.

  LOOP AT it_table ASSIGNING FIELD-SYMBOL(<item2>) WHERE is_primary = abap_false.
    WRITE: / 'The following fields are secondary key:' COLOR COL_POSITIVE.
    LOOP AT <item2>-components ASSIGNING FIELD-SYMBOL(<data2>).
      WRITE: / <data2> COLOR COL_TOTAL.
    ENDLOOP.
  ENDLOOP.
ENDFORM.