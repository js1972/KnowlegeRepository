REPORT ztest_bubblesort.

TYPES:BEGIN OF ty_line,
        number TYPE i,
      END OF ty_line.

DATA: lt_array TYPE STANDARD TABLE OF ty_line,
      ls_array TYPE ty_line,
      ls_array_temp type ty_line,
      lv_length TYPE i.

DATA: i TYPE i,
      j TYPE i,
      k TYPE i.

DO 10 TIMES.
  CLEAR ls_array.
  CALL FUNCTION 'QF05_RANDOM_INTEGER'
    EXPORTING
      ran_int_max   = 100
      ran_int_min   = 1
    IMPORTING
      ran_int       = ls_array-number
    EXCEPTIONS
      invalid_input = 1
      OTHERS        = 2.
  IF sy-subrc <> 0.
    WRITE:/ 'Error occured.'.
    EXIT.
  ENDIF.
  APPEND ls_array TO lt_array.
ENDDO.

LOOP AT lt_array INTO ls_array.
    WRITE: ls_array-number.
ENDLOOP.


  lv_length = lines( lt_array ).
  i = 1.
  DO lv_length - 1 TIMES.
    j = lv_length - i.
    k = 1.
    DO j TIMES.
      CLEAR: ls_array, ls_array_temp.
      READ TABLE lt_array INTO ls_array INDEX k.
      READ TABLE lt_array INTO ls_array_temp INDEX k + 1.
      IF ls_array-number > ls_array_temp-number .
        MODIFY lt_array FROM ls_array_temp INDEX k.
        MODIFY lt_array FROM ls_array INDEX k + 1 .
      ENDIF.
      k = k + 1.
    ENDDO.
    i = i + 1.
  ENDDO.

WRITE:/ 'result: '.
LOOP AT lt_array INTO ls_array.
  WRITE: ls_array-number.
ENDLOOP.

class ZCL_MARCH_SORT definition
  public
  final
  create public .

public section.

  types:
    tt_table TYPE TABLE OF int4 .

  methods BUBBLE_SORT
    changing
      !CT_TABLE type TT_TABLE .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MARCH_SORT IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MARCH_SORT->BUBBLE_SORT
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CT_TABLE                       TYPE        TT_TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD bubble_sort.

    DATA(length) = lines( ct_table ).
    DATA(mark) = 1.
    DATA nextnum TYPE int4 .
    DATA currentnum TYPE int4 .
    DATA tempnum TYPE int4.

    DO lines( ct_table ) TIMES .

      WHILE mark < length .

        IF ct_table[ mark ] > ct_table[  mark + 1 ].
          tempnum = ct_table[ mark ] .
          ct_table[ mark ] = ct_table[  mark + 1 ] .
          ct_table[  mark + 1 ] = tempnum .
        ENDIF.

        mark = mark + 1.

      ENDWHILE.
      mark = 1.
      length = length - 1.

    ENDDO.
  ENDMETHOD.
ENDCLASS.