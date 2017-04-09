types: BEGIN OF ty_data,
         cc type c length 2,
         nn type n length 3,
         bi type xstring,
       end of ty_Data.

TYPES: tt_data TYPE STANDARD TABLE OF ty_data.
 data: ls type ty_data,
       lv_total type int4.

 ls = value #( cc = '1' nn = 2 bi = 'AB' ).
 data(ls_type) = CAST CL_ABAP_TABLEDESCR( cl_abap_typedescr=>describe_by_name( 'TT_DATA' ) ).

 data(ls_line) = cast CL_ABAP_STRUCTDESCR( ls_type->get_table_line_type( ) ).
 data(lt_comp) = ls_line->components." length 4,6,8

 DO.
   ASSIGN COMPONENT sy-index OF STRUCTURE ls TO FIELD-SYMBOL(<data>).
   IF sy-subrc <> 0.
      EXIT.
   ENDIF.

   READ TABLE lt_comp ASSIGNING FIELD-SYMBOL(<line_type>) INDEX sy-index.
   CASE <line_type>-type_kind.

    WHEN cl_abap_typedescr=>typekind_char OR cl_abap_typedescr=>typekind_num.
      lv_total = lv_total + strlen( <data> ) * 2.
    WHEN cl_abap_typedescr=>typekind_xstring.
      lv_total = lv_total + xstrlen( <data> ).
    WHEN OTHERS.
      ASSERT 1 = 0.
   ENDCASE.

   "17
 ENDDO.
 WRITE: / strlen( ls-cc ), strlen( ls-nn ) , xstrlen( ls-bi ). " 1, 3, 1
 BREAK-POINT  .