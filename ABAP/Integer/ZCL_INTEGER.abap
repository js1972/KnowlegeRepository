class ZCL_INTEGER definition
  public
  final
  create private .

public section.

  class-methods VALUE_OF
    importing
      !IV_VALUE type INT4
    returning
      value(RO_INSTANCE) type ref to ZCL_INTEGER .
  methods GET_BINARY_FORMAT
    returning
      value(RV_FORMAT) type STRING .
protected section.
private section.

  types:
    BEGIN OF ty_cache,
             int_value TYPE int4,
             instance TYPE REF TO ZCL_INTEGER,
         end of ty_cache .
  types:
    tt_cache TYPE TABLE OF ty_cache WITH KEY int_value .

  data MV_BINARY_FORMAT type STRING .
  class-data MT_CACHE type TT_CACHE .
  data MV_VALUE type INT4 .
  data MT_BITS type ZBIT_TYPE_T .
  constants CV_MAX_BIT type INT4 value 32 ##NO_TEXT.

  methods CONSTRUCTOR
    importing
      !IV_VALUE type INT4 .
  methods POPULATE_BINARY_BITS .
ENDCLASS.



CLASS ZCL_INTEGER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_INTEGER->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_VALUE                       TYPE        INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CONSTRUCTOR.
    me->mv_value = IV_VALUE.
    me->populate_binary_BITS( ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_INTEGER->GET_BINARY_FORMAT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_FORMAT                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_BINARY_FORMAT.
    LOOP AT mt_bits ASSIGNING FIELD-SYMBOL(<bit>).
       rv_format = rv_format && <bit>.
    ENDLOOP.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_INTEGER->POPULATE_BINARY_BITS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD POPULATE_BINARY_BITS.
    datA: lt_bits LIKE mt_bits.
    DATA(lv) = mv_value.
    DO.
      DATA(div_result) = lv DIV 2.
      DATA(div_left) = lv MOD 2.
      APPEND div_left TO lt_bits.

      IF div_result = 0.
        EXIT.
      ENDIF.
      lv = div_result.
    ENDDO.

    DATA(lv_len) = lines( lt_bits ).
    DATA(lv_index) = lv_len.
    DATA(lv_left) = cv_max_bit - lv_len.
    DO lv_left TIMES.
       APPEND 0 TO mt_bits.
    ENDDO.

    DO lv_len TIMES.
       READ TABLE lt_bits ASSIGNING FIELD-SYMBOL(<bit>) INDEX lv_index.
       APPEND <bit> TO mt_bits.
       lv_index = lv_index - 1.
    ENDDO.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_INTEGER=>VALUE_OF
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_VALUE                       TYPE        INT4
* | [<-()] RO_INSTANCE                    TYPE REF TO ZCL_INTEGER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method VALUE_OF.
     READ TABLE MT_CACHE ASSIGNING FIELD-SYMBOL(<cache>) WITH KEY int_value = IV_VALUE.
     IF sy-subrc = 0.
        ro_instance = <cache>-instance.
        RETURN.
     ENDIF.

     APPEND INITIAL LINE TO MT_CACHE ASSIGNING FIELD-SYMBOL(<new_cache>).
     <new_cache>-int_value = IV_VALUE.
     CREATE OBJECT <new_cache>-instance
       EXPORTING
         IV_VALUE = IV_VALUE.

     ro_instance = <new_cache>-instance.
  endmethod.
ENDCLASS.