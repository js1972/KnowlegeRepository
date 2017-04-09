REPORT ZTEST_TABLE.

TYPES: BEGIN OF ty_structure,
    name TYPE string,
    score TYPE int4,
    skill TYPE int4,
    rank TYPe int4,
    END OF ty_structure.

START-OF-SELECTION.
     DATA(ls1) = value ty_structure( name = 'Jerry' score = 100 skill = 1 rank = 1 ).
     DATA(ls2) = value ty_structure( name = 'Sean' score = 101 skill = 2 rank = 1 ).

     PERFORM print_first_n_field using 2 ls1.
     WRITE: / '*******************************' COLOR COL_NEGATIVE.
     PERFORM print_first_n_field using 3 ls2.

FORM print_first_n_field USING iv_index TYPE int4 iv_data TYPE ANY.
   FIELD-SYMBOLS: <field> TYPE ANY.

   DO iv_index TIMES.
      ASSIGN COMPONENT sy-index OF STRUCTURE iv_data TO <field>.
      CHECK sy-subrc = 0.
      WRITE: / <field>.
   ENDDO.
ENDFORM.