*&---------------------------------------------------------------------*
*& Report ZGENERATE_ACCESS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGENERIC_ACCESS.

PARAMETERS: name TYPE tadir-obj_name OBLIGATORY DEFAULT 'SFLIGHT'.

DATA: dyn_table TYPE REF TO DATA.

TRY.

CREATE DATA dyn_table TYPE TABLE OF (name).

FIELD-SYMBOLS: <table> TYPE ANY TABLE.

ASSIGN dyn_table->* TO <table>.

ASSERT sy-subrc = 0.


SELECT * INTO TABLE <table> FROM (name) UP TO 10 ROWS.

CATCH cx_root INTO data(cx_root).
   WRITE: / cx_root->get_text( ).
   RETURN.
ENDTRY.

FIELD-SYMBOLS: <row> TYPE ANY,
               <wa>  TYPE ANY.
LOOP AT <TABLE> ASSIGNING <row>.
   DO.
     ASSIGN COMPONENT sy-INDEX OF STRUCTURE <row> TO <wa>.
     IF sy-SUBRC = 0.
       WRITE <wa>.
     ELSE.
      SKIP.
      EXIT.
     ENDIF.
   ENDDO.
ENDLOOP.