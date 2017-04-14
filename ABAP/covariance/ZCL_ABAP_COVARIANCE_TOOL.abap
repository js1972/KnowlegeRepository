CLASS zcl_abap_covariance_tool DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS get_methods_include
      IMPORTING
        !is_method_def TYPE seocpdkey
      EXPORTING
        !ev_program    TYPE progname
        !ev_include    TYPE program .
    METHODS get_used_objects
      IMPORTING
        !is_method_def TYPE seocpdkey .
  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ty_method_detail,
        method_type          TYPE c LENGTH 1,
        caller_variable_name TYPE string,
        method_cls_name      TYPE string,
        method_name          TYPE string,
        call_parameter_name  TYPE string, "should be a string_table in productive use
* for simpliciation reason in this POC Jerry assume each constructor / instance method
* only define ONLY ONE parameter, in productive use should use TABLE OF instead to
* support multiple parameter
        method_signature     TYPE seosubcodf,
      END OF ty_method_detail .
  types:
    tt_method_detail TYPE STANDARD TABLE OF ty_method_detail .

  constants:
    BEGIN OF cs_method_type,
        constructor TYPE c LENGTH 1 VALUE 1,
        instance    TYPE c LENGTH 1 VALUE 2,
      END OF cs_method_type .
  data MT_RESULT type SCR_REFS .
  data MT_METHOD_DETAIL type TT_METHOD_DETAIL .
  data MT_SOURCE_CODE type SEOP_SOURCE_STRING .
  data MS_WORKING_METHOD type SEOCPDKEY .

  methods FILL_CALLER_VARIABLE_NAME
    importing
      !IV_CURRENT_INDEX type INT4
    changing
      !CS_METHOD_DETAIL type TY_METHOD_DETAIL .
  methods GET_METHOD_TYPE
    importing
      !IV_RAW type STRING
    returning
      value(RS_METHOD_DETAIL) type TY_METHOD_DETAIL .
  methods FILL_CALL_PARAMETER
    importing
      !IV_CURRENT_INDEX type INT4
    changing
      !CS_METHOD_DETAIL type TY_METHOD_DETAIL .
  methods FILL_METHOD_SOURCE .
ENDCLASS.



CLASS ZCL_ABAP_COVARIANCE_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_ABAP_COVARIANCE_TOOL->FILL_CALLER_VARIABLE_NAME
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CURRENT_INDEX               TYPE        INT4
* | [<-->] CS_METHOD_DETAIL               TYPE        TY_METHOD_DETAIL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD fill_caller_variable_name.
    DATA: lv_index TYPE int4.

    lv_index = iv_current_index.
    WHILE lv_index > 0.
      READ TABLE mt_result ASSIGNING FIELD-SYMBOL(<line>) INDEX lv_index.
      IF <line>-tag = 'DA'.
        cs_method_detail-caller_variable_name = <line>-name.
        RETURN.
      ENDIF.

      lv_index = lv_index - 1.
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_ABAP_COVARIANCE_TOOL->FILL_CALL_PARAMETER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_CURRENT_INDEX               TYPE        INT4
* | [<-->] CS_METHOD_DETAIL               TYPE        TY_METHOD_DETAIL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD fill_call_parameter.
    DATA: lv_index TYPE int4,
          lv_total TYPE int4.

    FIELD-SYMBOLS: <line> LIKE LINE OF mt_result.
    lv_total = lines( mt_result ).
    lv_index = iv_current_index.

    CASE cs_method_detail-method_type.
      WHEN cs_method_type-instance.
        WHILE lv_index < lv_total.
          READ TABLE mt_result ASSIGNING <line> INDEX lv_index.
          IF <line>-tag = 'DA'.
            cs_method_detail-call_parameter_name = <line>-name.
            RETURN.
          ENDIF.
          lv_index = lv_index + 1.
        ENDWHILE.
      WHEN cs_method_type-constructor.
         WHILE lv_index < lv_total.
           READ TABLE mt_result ASSIGNING <line> INDEX lv_index.
          IF <line>-name = cs_method_Detail-method_signature-sconame.
            READ TABLE mt_source_code ASSIGNING FIELD-SYMBOL(<codeline>) INDEX <line>-line.
            cs_method_detail-call_parameter_name = <codeline>.
            RETURN.
          ENDIF.
          lv_index = lv_index + 1.
        endwhile.
    ENDCASE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_ABAP_COVARIANCE_TOOL->FILL_METHOD_SOURCE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method FILL_METHOD_SOURCE.

     CALL FUNCTION 'SEO_METHOD_GET_SOURCE'
       EXPORTING
          MTDKEY = ms_working_method
       IMPORTING
          SOURCE_expanded = mt_source_code.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABAP_COVARIANCE_TOOL->GET_METHODS_INCLUDE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_METHOD_DEF                  TYPE        SEOCPDKEY
* | [<---] EV_PROGRAM                     TYPE        PROGNAME
* | [<---] EV_INCLUDE                     TYPE        PROGRAM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_methods_include.
    ev_include = cl_oo_classname_service=>get_method_include( is_method_def ).

    ev_program = cl_oo_classname_service=>get_classpool_name( is_method_def-clsname ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_ABAP_COVARIANCE_TOOL->GET_METHOD_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_RAW                         TYPE        STRING
* | [<-()] RS_METHOD_DETAIL               TYPE        TY_METHOD_DETAIL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_method_type.
    CONSTANTS : cv_instance    TYPE string VALUE '^\\TY:(.*)\\ME:(.*)$',
                cv_constructor TYPE string VALUE '^\\TY:(.*)$'.

    DATA: lo_regex            TYPE REF TO cl_abap_regex,
          lo_matcher          TYPE REF TO cl_abap_matcher,
          lt_reg_match_result TYPE match_result_tab.
    FIELD-SYMBOLS: <reg_entry> LIKE LINE OF lt_reg_match_result,
                   <match1>    LIKE LINE OF <reg_entry>-submatches,
                   <match2>    LIKE <match1>.

    lo_regex = NEW #( pattern = cv_instance ).

    lo_matcher = lo_regex->create_matcher( EXPORTING text = iv_raw ).

    IF lo_matcher->match( ) = abap_false.
      lo_regex = NEW #( pattern = cv_constructor ).
      lo_matcher = lo_regex->create_matcher( EXPORTING text = iv_raw ).
      CHECK lo_matcher->match( ) = abap_true.
      rs_method_detail-method_type = cs_method_type-constructor.
    ELSE.
      rs_method_detail-method_type = cs_method_type-instance.
    ENDIF.

    lt_reg_match_result = lo_matcher->find_all( ).
    READ TABLE lt_reg_match_result ASSIGNING <reg_entry> INDEX 1.

    READ TABLE <reg_entry>-submatches ASSIGNING <match1> INDEX 1.
    rs_method_detail-method_cls_name = iv_raw+<match1>-offset(<match1>-length).
    IF lines( <reg_entry>-submatches ) = 2.

      READ TABLE <reg_entry>-submatches ASSIGNING <match2> INDEX 2.
      rs_method_detail-method_name = iv_raw+<match2>-offset(<match2>-length).
    ELSE.
      rs_method_detail-method_name = 'CONSTRUCTOR'.
    ENDIF.
    SELECT SINGLE * INTO rs_method_detail-method_signature FROM seosubcodf
        WHERE clsname = rs_method_detail-method_cls_name AND cmpname = rs_method_detail-method_name.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABAP_COVARIANCE_TOOL->GET_USED_OBJECTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_METHOD_DEF                  TYPE        SEOCPDKEY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_used_objects.
    DATA: lv_include TYPE progname,
          lv_main    TYPE progname,
          lv_index   TYPE int4 VALUE 1.

    ms_working_method = IS_METHOD_DEF.
    fill_method_source( ).
    CALL METHOD get_methods_include
      EXPORTING
        is_method_def = is_method_def
      IMPORTING
        ev_program    = lv_main
        ev_include    = lv_include.

    DATA(lo_compiler) = NEW cl_abap_compiler( p_name = lv_main p_include = lv_include ).

    lo_compiler->get_all( IMPORTING p_result = mt_result ).

    TYPES: BEGIN OF ty_method,
             method_name TYPE string,
             method_type TYPE string,
           END OF ty_method.

    TYPES: tt_method TYPE STANDARD TABLE OF ty_method.

    TYPES: BEGIN OF ty_variable,
             variable_name TYPE string,
             variable_type TYPE string,
           END OF ty_variable.

    TYPES: tt_variable TYPE STANDARD TABLE OF ty_variable.

    DATA: lt_method   TYPE tt_method,
          lt_variable TYPE tt_variable.

    FIELD-SYMBOLS:<method> LIKE LINE OF mt_result.

    LOOP AT mt_result ASSIGNING <method>.
      CASE <method>-tag.
        WHEN 'ME'.
          DATA(ls_method) = VALUE ty_method( method_name = <method>-name
                                             method_type = <method>-full_name ).
          DATA(ls_method_detail) = get_method_type( <method>-full_name ).
          fill_caller_variable_name( EXPORTING iv_current_index = lv_index
                                     CHANGING  cs_method_detail = ls_method_detail ).
          IF ls_method_detail-method_signature IS NOT INITIAL.
            fill_call_parameter( EXPORTING iv_current_index = lv_index
                                    CHANGING cs_method_detail = ls_method_detail ).
          ENDIF.
          APPEND ls_method_detail TO mt_method_detail.
          APPEND ls_method TO lt_method.
        WHEN OTHERS.
      ENDCASE.
      ADD 1 TO lv_index.
    ENDLOOP.

    LOOP AT mt_result ASSIGNING FIELD-SYMBOL(<variable>) WHERE tag = 'DA'.
      DATA(ls_variable) = VALUE ty_variable( variable_name = <variable>-name
                                         variable_type = <variable>-full_name ).
      APPEND ls_variable TO lt_variable.
    ENDLOOP.


    DATA: lt_ref TYPE scr_glrefs.

    lo_compiler->get_all_refs( EXPORTING p_local = 'X' IMPORTING p_result = lt_ref ).

  ENDMETHOD.
ENDCLASS.