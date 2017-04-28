class ZCL_INTEGER definition
  public
  final
  create private .

public section.

  methods OR
    importing
      !IO_OTHER_INT type ref to ZCL_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_INTEGER .
  class-methods CLASS_CONSTRUCTOR .
  class-methods VALUE_OF
    importing
      !IV_VALUE type INT4
    returning
      value(RO_INSTANCE) type ref to ZCL_INTEGER .
  methods GET_BINARY_FORMAT
    returning
      value(RV_FORMAT) type STRING .
  methods AND
    importing
      !IO_OTHER_INT type ref to ZCL_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_INTEGER .
  methods XOR
    importing
      !IO_OTHER_INT type ref to ZCL_INTEGER
    returning
      value(RO_RESULT) type ref to ZCL_INTEGER .
  methods GET_RAW_VALUE
    returning
      value(RV_RAW) type INT4 .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ty_cache,
        int_value TYPE int4,
        instance  TYPE REF TO zcl_integer,
      END OF ty_cache .
  types:
    tt_cache TYPE TABLE OF ty_cache WITH KEY int_value .
  types:
    BEGIN OF ty_bit_operation_rule,
        op_type       TYPE int4,
        left_operand  TYPE zbit_type,
        right_operand TYPE zbit_type,
        result        TYPE zbit_type,
      END OF ty_bit_operation_rule .
  types:
    tt_bit_operation_rule TYPE TABLE OF ty_bit_operation_rule WITH KEY
                op_type left_operand right_operand .

  constants:
    BEGIN OF cs_bit_operation,
        or  TYPE int4 VALUE 1,
        and TYPE int4 VALUE 2,
        xor TYPE int4 VALUE 3,
      END OF cs_bit_operation .
  data MV_BINARY_FORMAT type STRING .
  class-data MT_CACHE type TT_CACHE .
  data MV_VALUE type INT4 .
  data MT_BITS type ZBIT_TYPE_T .
  constants CV_MAX_BIT type INT4 value 32 ##NO_TEXT.
  class-data ST_BIT_RULE type TT_BIT_OPERATION_RULE .

  methods CONSTRUCTOR
    importing
      !IV_VALUE type INT4 .
  methods POPULATE_BINARY_BITS .
  methods BIT_OPERATE
    importing
      !IV_BIT1 type ZBIT_TYPE
      !IV_BIT2 type ZBIT_TYPE
      !IV_OP_TYPE type INT4
    returning
      value(RV_RESULT) type ZBIT_TYPE .
  methods BINARY_2_DECIMAL
    importing
      !IV_BINARY type STRING
    returning
      value(RV_DECIMAL) type INT4 .
  methods PERFORM_BIT
    importing
      !IO_INT1 type ref to ZCL_INTEGER
      !IO_INT2 type ref to ZCL_INTEGER
      !IV_OP_TYPE type INT4
    returning
      value(RO_RESULT) type ref to ZCL_INTEGER .
ENDCLASS.



CLASS ZCL_INTEGER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_INTEGER->AND
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_OTHER_INT                   TYPE REF TO ZCL_INTEGER
* | [<-()] RO_RESULT                      TYPE REF TO ZCL_INTEGER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD AND.
    ro_result = PERFORM_BIT( io_int1 = me io_int2 = IO_OTHER_INT
                             IV_OP_TYPE = cs_bit_operation-and ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_INTEGER->BINARY_2_DECIMAL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_BINARY                      TYPE        STRING
* | [<-()] RV_DECIMAL                     TYPE        INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD binary_2_decimal.
    DO cv_max_bit TIMES.
      DATA(lv_index) = sy-index - 1.
      DATA(bit) = iv_binary+lv_index(1).
      IF bit = 1.
        lv_index = cv_max_bit - sy-index.
        rv_decimal = rv_decimal + ipow( base = 2 exp = lv_index ).
      ENDIF.
    ENDDO.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_INTEGER->BIT_OPERATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_BIT1                        TYPE        ZBIT_TYPE
* | [--->] IV_BIT2                        TYPE        ZBIT_TYPE
* | [--->] IV_OP_TYPE                     TYPE        INT4
* | [<-()] RV_RESULT                      TYPE        ZBIT_TYPE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD bit_operate.
    READ TABLE st_bit_rule WITH KEY op_type = iv_op_type left_operand = iv_bit1
        right_operand = iv_bit2 ASSIGNING FIELD-SYMBOL(<rule>).

    ASSERT sy-subrc = 0.

    rv_result = <rule>-result.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_INTEGER=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD class_constructor.

    DATA: ls_rule TYPE ty_bit_operation_rule.
    DEFINE insert_rule.
      ls_rule = VALUE #( op_type = &1 left_operand = &2
                         right_operand = &3 result = &4 ).
      APPEND ls_rule TO st_bit_rule.
    END-OF-DEFINITION.

    insert_rule cs_bit_operation-or '1' '1' '1'.
    insert_rule cs_bit_operation-or '1' '0' '1'.
    insert_rule cs_bit_operation-or '0' '1' '1'.
    insert_rule cs_bit_operation-or '0' '0' '0'.

    insert_rule cs_bit_operation-and '1' '1' '1'.
    insert_rule cs_bit_operation-and '1' '0' '0'.
    insert_rule cs_bit_operation-and '0' '1' '0'.
    insert_rule cs_bit_operation-and '0' '0' '0'.

    insert_rule cs_bit_operation-xor '1' '1' '0'.
    insert_rule cs_bit_operation-xor '1' '0' '1'.
    insert_rule cs_bit_operation-xor '0' '1' '1'.
    insert_rule cs_bit_operation-xor '0' '0' '0'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_INTEGER->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_VALUE                       TYPE        INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
    me->mv_value = iv_value.
    me->populate_binary_bits( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_INTEGER->GET_BINARY_FORMAT
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_FORMAT                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_binary_format.
    LOOP AT mt_bits ASSIGNING FIELD-SYMBOL(<bit>).
      rv_format = rv_format && <bit>.
    ENDLOOP.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_INTEGER->GET_RAW_VALUE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_RAW                         TYPE        INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_RAW_VALUE.
      rv_raw = me->mv_value.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_INTEGER->OR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_OTHER_INT                   TYPE REF TO ZCL_INTEGER
* | [<-()] RO_RESULT                      TYPE REF TO ZCL_INTEGER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD or.
    ro_result = PERFORM_BIT( io_int1 = me io_int2 = IO_OTHER_INT
                             IV_OP_TYPE = cs_bit_operation-or ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_INTEGER->PERFORM_BIT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_INT1                        TYPE REF TO ZCL_INTEGER
* | [--->] IO_INT2                        TYPE REF TO ZCL_INTEGER
* | [--->] IV_OP_TYPE                     TYPE        INT4
* | [<-()] RO_RESULT                      TYPE REF TO ZCL_INTEGER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD PERFORM_BIT.
    DATA(lv_bin1) = io_int1->get_binary_format( ).
    DATA(lv_bin2) = io_int2->get_binary_format( ).

    DATA: lv_result_binary TYPE string.
    DO cv_max_bit TIMES.
      DATA(offset) = sy-index - 1.
      DATA(left_bit) = CONV zbit_type( lv_bin1+offset(1) ).
      DATA(right_bit) = CONV zbit_type( lv_bin2+offset(1) ).
      DATA(bit) = bit_operate( iv_bit1 = left_bit
                               iv_bit2 = right_bit
                               iv_op_type = IV_OP_TYPE ).
      lv_result_binary = lv_result_binary && bit.
    ENDDO.

    DATA(lv_decimal) = binary_2_decimal( lv_result_binary ).
    ro_result = zcl_integer=>value_of( lv_decimal ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_INTEGER->POPULATE_BINARY_BITS
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD populate_binary_bits.
    DATA: lt_bits LIKE mt_bits.
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
  METHOD value_of.
    READ TABLE mt_cache ASSIGNING FIELD-SYMBOL(<cache>) WITH KEY int_value = iv_value.
    IF sy-subrc = 0.
      ro_instance = <cache>-instance.
      RETURN.
    ENDIF.

    APPEND INITIAL LINE TO mt_cache ASSIGNING FIELD-SYMBOL(<new_cache>).
    <new_cache>-int_value = iv_value.
    CREATE OBJECT <new_cache>-instance
      EXPORTING
        iv_value = iv_value.

    ro_instance = <new_cache>-instance.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_INTEGER->XOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_OTHER_INT                   TYPE REF TO ZCL_INTEGER
* | [<-()] RO_RESULT                      TYPE REF TO ZCL_INTEGER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD XOR.
    ro_result = PERFORM_BIT( io_int1 = me io_int2 = IO_OTHER_INT
                             IV_OP_TYPE = cs_bit_operation-xor ).
  ENDMETHOD.
ENDCLASS.