*&---------------------------------------------------------------------*
*& Report  ZNGAP
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZNGAP.
TYPES:
   BEGIN OF struc,
      col1 TYPE c LENGTH 2,
      col2 TYPE i,
      col3 TYPE i,
   END OF struc.

DATA itab TYPE SORTED TABLE OF struc WITH UNIQUE KEY col1
          WITH UNIQUE SORTED KEY sec_key COMPONENTS col2.

itab = VALUE #( ( col1 = 'AA' col2 = 5 col3 = 100 )
                ( col1 = 'BB' col2 = 4 col3 = 100 )
                ( col1 = 'CC' col2 = 3 col3 = 100 )
                ( col1 = 'DD' col2 = 2 col3 = 100 )
                ( col1 = 'EE' col2 = 1 col3 = 100 ) ).

DATA(wa) = itab[ 1 ].

ASSIGN itab[ col1 = 'BB' ] TO FIELD-SYMBOL(<fs>).

cl_demo_output=>display( itab[ 3 ] ).

IF line_exists( itab[ KEY sec_key col2 = 2 ] ).
ENDIF.

DATA(line) = itab[ KEY sec_key col2 = 4 ].

TRY.
DATA(not) = itab[ KEY sec_key col2 = 333 ].
CATCH cx_root.
ENDTRY.

itab[ col1 = 'EE' ]-col3 = 555.