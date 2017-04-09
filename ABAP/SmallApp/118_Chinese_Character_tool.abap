class ZCL_CHINESE_TOOL definition
  public
  final
  create public .

public section.
  type-pools ABAP .

  types:
    tt_post_attributes TYPE STANDARD TABLE OF crmt_soc_post_attr .
  types:
    tt_post_uuid TYPE STANDARD TABLE OF crmt_soc_data_uuid .
  types:
    tt_socialuserinfo type standard table of socialuserinfo .

  class-methods CLASS_CONSTRUCTOR .
  class-methods GET_FORMATTED_STRING
    importing
      !IV_FLAG type CRMT_SOC_UNICODE_FLAG optional
      !IV_STRING type STRING
    returning
      value(RV_STRING) type STRING .
protected section.
private section.

  types:
    tt_sentit TYPE STANDARD TABLE OF crmc_soc_senti_t .


  class-data SV_UNICODE_FLAG type CRMT_SOC_UNICODE_FLAG .
  class-data ST_INVALID type STRING_TABLE .

  class-data ST_CONTROL_FLAGS type STRING_TABLE .

  class-methods IS_HEXDECIMAL
    importing
      !IV_STRING type CHAR4
    returning
      value(IS_HEXDECIMAL) type ABAP_BOOL .
  class-methods IS_VALID_UNICODE_FLAG
    importing
      !IV_FLAG type CRMT_SOC_UNICODE_FLAG
    returning
      value(RV_VALID) type ABAP_BOOL .
ENDCLASS.



CLASS ZCL_CHINESE_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CHINESE_TOOL=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CLASS_CONSTRUCTOR.

     APPEND cl_abap_conv_in_ce=>uccp( 'p2d3' ) to st_invalid. "#EC NOTEXT
     APPEND cl_abap_conv_in_ce=>uccp( '1234' ) to st_invalid. "#EC NOTEXT
     DATA: it_taba TYPE STANDARD TABLE OF dd07v,
           it_tabb TYPE STANDARD TABLE OF dd07v.

     FIELD-SYMBOLS: <item> TYPE dd07v.

   CALL FUNCTION 'DD_DOMA_GET'
      EXPORTING
        domain_name   = 'CRM_SOC_UNICODE_FLAG'
        langu         = sy-langu
        withtext      = 'X'
      TABLES
        dd07v_tab_a   = it_taba
        dd07v_tab_n   = it_tabb
      EXCEPTIONS
        illegal_value = 1
        op_failure    = 2
        OTHERS        = 3.

   LOOP AT it_taba ASSIGNING <item>.
      APPEND <item>-domvalue_l TO st_control_flags.
   ENDLOOP.


  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CHINESE_TOOL=>GET_FORMATTED_STRING
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_FLAG                        TYPE        CRMT_SOC_UNICODE_FLAG(optional)
* | [--->] IV_STRING                      TYPE        STRING
* | [<-()] RV_STRING                      TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_FORMATTED_STRING.

    CONSTANTS: c_default TYPE CRMT_SOC_UNICODE_FLAG VALUE '\u'.
    TYPES: BEGIN OF ty_pair,
               unicode TYPE char4,
               chinese TYPE char2,
           END OF ty_pair.

    DATA: lv_offset TYPE i,
          lv_start TYPE i,
          lt_match TYPE match_result_tab,
          ls_match LIKE LINE OF lt_match,
          lv_unicode TYPE char4,
          lv_upper TYPE char4,
          lt_chinese TYPE STANDARD TABLE OF ty_pair,
          ls_pair TYPE ty_pair,
          lv_len TYPE i,
          lv_chinese TYPE crmt_soc_unicode_flag,
          lv_replace TYPE char7,
          lv_input TYPE string.

    IF iv_flag IS NOT SUPPLIED.
        sv_unicode_flag = c_default.
    ELSEIF is_valid_unicode_flag( iv_flag ) = abap_false.
        rv_string = iv_string.
        RETURN.
    ELSE.
        sv_unicode_flag = iv_flag.
    ENDIF.

    FIND ALL OCCURRENCES OF sv_unicode_flag IN iv_string RESULTS lt_match.
    IF sy-subrc <> 0.
       rv_string = iv_string.
       RETURN.
    ENDIF.

    lv_input = iv_string.
    lv_len = strlen( lv_input ).

    CLEAR: lt_chinese.

    LOOP AT lt_match INTO ls_match.
       lv_start = ls_match-offset + ls_match-length.
       CHECK lv_len >= lv_start + 4.

       lv_upper = lv_unicode = iv_string+lv_start(4).
       TRANSLATE lv_upper TO UPPER CASE.
       CHECK is_hexdecimal( lv_unicode ) = abap_true.
       lv_chinese = cl_abap_conv_in_ce=>uccp( lv_upper ).
       READ TABLE st_invalid WITH KEY table_line = lv_chinese TRANSPORTING NO FIELDS.
       CHECK sy-subrc <> 0.
       ls_pair-unicode = lv_unicode.
       ls_pair-chinese = lv_chinese.
       APPEND ls_pair TO lt_chinese.
    ENDLOOP.

    LOOP AT lt_chinese INTO ls_pair.
       lv_replace = sv_unicode_flag && ls_pair-unicode.
       REPLACE ALL OCCURRENCES OF lv_replace IN lv_input WITH ls_pair-chinese.
    ENDLOOP.

    rv_string = lv_input.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_CHINESE_TOOL=>IS_HEXDECIMAL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_STRING                      TYPE        CHAR4
* | [<-()] IS_HEXDECIMAL                  TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IS_HEXDECIMAL.
     CONSTANTS: mask TYPE string VALUE '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.

     IF iv_string CO mask.
        is_hexdecimal = abap_true.
     ENDIF.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_CHINESE_TOOL=>IS_VALID_UNICODE_FLAG
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_FLAG                        TYPE        CRMT_SOC_UNICODE_FLAG
* | [<-()] RV_VALID                       TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IS_VALID_UNICODE_FLAG.
     READ TABLE st_control_flags WITH KEY table_line = iv_flag TRANSPORTING NO FIELDS.
     IF sy-subrc = 0.
        rv_valid = abap_true.
     ENDIF.

  endmethod.
ENDCLASS.