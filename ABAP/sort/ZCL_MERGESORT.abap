CLASS zcl_mergesort DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS sort
      IMPORTING
        !iv_table       TYPE abadr_tab_int4
      RETURNING
        VALUE(rv_table) TYPE abadr_tab_int4 .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-METHODS concat
      IMPORTING
        !iv_merged       TYPE abadr_tab_int4
        !iv_left         TYPE abadr_tab_int4
        !iv_right        TYPE abadr_tab_int4
      RETURNING
        VALUE(rv_result) TYPE abadr_tab_int4 .
    CLASS-METHODS cut_table
      IMPORTING
        !iv_origin    TYPE abadr_tab_int4
        !iv_start     TYPE int4
        !iv_end       TYPE int4
      RETURNING
        VALUE(rv_sub) TYPE abadr_tab_int4 .
    CLASS-METHODS merge
      IMPORTING
        !iv_left         TYPE abadr_tab_int4
        !iv_right        TYPE abadr_tab_int4
      RETURNING
        VALUE(rv_merged) TYPE abadr_tab_int4 .
    CLASS-METHODS shift
      EXPORTING
        !ev_element TYPE int4
      CHANGING
        !cv_table   TYPE abadr_tab_int4 .
ENDCLASS.



CLASS ZCL_MERGESORT IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_MERGESORT=>CONCAT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_MERGED                      TYPE        ABADR_TAB_INT4
* | [--->] IV_LEFT                        TYPE        ABADR_TAB_INT4
* | [--->] IV_RIGHT                       TYPE        ABADR_TAB_INT4
* | [<-()] RV_RESULT                      TYPE        ABADR_TAB_INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD concat.
    APPEND LINES OF iv_merged TO rv_result.
    APPEND LINES OF iv_left TO rv_result.
    APPEND LINES OF iv_right TO rv_result.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_MERGESORT=>CUT_TABLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ORIGIN                      TYPE        ABADR_TAB_INT4
* | [--->] IV_START                       TYPE        INT4
* | [--->] IV_END                         TYPE        INT4
* | [<-()] RV_SUB                         TYPE        ABADR_TAB_INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD cut_table.
    LOOP AT iv_origin ASSIGNING FIELD-SYMBOL(<item>) FROM iv_start TO iv_end.
      APPEND <item> TO rv_sub.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_MERGESORT=>MERGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_LEFT                        TYPE        ABADR_TAB_INT4
* | [--->] IV_RIGHT                       TYPE        ABADR_TAB_INT4
* | [<-()] RV_MERGED                      TYPE        ABADR_TAB_INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD merge.
    DATA(lv_left) = iv_left.
    DATA(lv_right) = iv_right.
    DATA:lv_shift TYPE int4.

    WHILE lines( lv_left ) > 0 AND lines( lv_right ) > 0.
      IF lv_left[ 1 ] < lv_right[ 1 ].
        shift( IMPORTING ev_element = lv_shift
               CHANGING cv_table = lv_left ).
      ELSE.
        shift( IMPORTING ev_element = lv_shift
               CHANGING cv_table = lv_right ).
      ENDIF.
      APPEND lv_shift TO rv_merged.
    ENDWHILE.

    rv_merged = concat( iv_merged = rv_merged iv_left = lv_left iv_right = lv_right ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_MERGESORT=>SHIFT
* +-------------------------------------------------------------------------------------------------+
* | [<---] EV_ELEMENT                     TYPE        INT4
* | [<-->] CV_TABLE                       TYPE        ABADR_TAB_INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD shift.
    ev_element = cv_table[ 1 ].
    DELETE cv_table INDEX 1.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_MERGESORT=>SORT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TABLE                       TYPE        ABADR_TAB_INT4
* | [<-()] RV_TABLE                       TYPE        ABADR_TAB_INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD sort.
    IF lines( iv_table ) = 1.
      rv_table = iv_table.
      RETURN.
    ENDIF.

    DATA(lv_middle) = lines( iv_table ) DIV 2.

    DATA(lv_left) = cut_table( iv_origin = iv_table iv_start = 1 iv_end = lv_middle ).
    DATA(lv_right) = cut_table( iv_origin = iv_table iv_start = lv_middle + 1
                                iv_end = lines( iv_table ) ).

    DATA(lv_left_sorted) = sort( lv_left ).
    DATA(lv_right_sorted) = sort( lv_right ).

    rv_table = merge( iv_left = lv_left_sorted
                      iv_right = lv_right_sorted ).

  ENDMETHOD.
ENDCLASS.