*&---------------------------------------------------------------------*
*& Report  ZNEWABAP
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZNEWABAP.
types: BEGIN OF ty_data,
       name type string,
       title type string,
      END OF ty_data.

TYPES: tt_Data TYPE TABLE OF ty_Data WITH EMPTY KEY WITH UNIQUE SORTED KEY nk COMPONENTS name.

DATA: ls_data type ty_data,
      lt_data type tt_Data.

ls_data-name = 'jerry'.
ls_data-title = '1'.

APPEND ls_data TO lt_data.

ls_data-name = 'jerry1'.
APPEND ls_data TO lt_data.

CLEAR: ls_data.
ls_data-name = 'jerry2'.
ls_data-title = '2'.
APPEND ls_data to LT_data.

data(local) = lt_Data[ name = 'jerry1' ].
WRITE:/ local-name.
WRITE:/ local-title.
BREAK-POINT.

IF NOT line_exists( lt_Data[ name = 'jerry2' ] ).

    WRITE:/ 'not found'.

ENDIF.

data(index) = line_index( lt_Data[ name = 'jerry2' ] ).
WRITE:/ index.

data(sub) = lt_data[ name = 'jerry' ].

DATA sflight_tab TYPE SORTED TABLE OF sflight
                 WITH UNIQUE KEY carrid connid fldate.
data(index2) = lt_data[ 2 ].

data: lv_s type ty_data.
lv_s-title = '1'.

data: ll type string VALUE 'dd'.
lt_data = VALUE #( ( name = 'a' title = 'a1' ) ( name = 'b' title = 'b1' ) ).
lv_s = VALUE #( name = 'c' title = ll ).
APPEND lv_s TO lt_Data.
lv_s = VALUE #( name = 'c1' title = 'c2' ).
APPEND lv_s TO lt_data.

BREAK-POINT.
SELECT *
       FROM sflight
       INTO TABLE @sflight_tab.

  BREAK-POINT.
  data: aa LIKE lt_Data.

  IF line_exists( lt_data[ KEY nk COMPONENTS name = 'c' ] ).
  ENDIF.


  BREAK-POINT.

  data(nbe) = value ty_data( name = 'j2' title = 'sd' ).
  data(new) = value tt_data( ( name = 'j23' title = 'sd' ) ).
  APPEND lines of new TO lt_data.
  BREAK-POINT.