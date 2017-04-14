class ZCL_ABAP_COVARIANCE_TOOL definition
  public
  final
  create public .

public section.

  methods GET_METHODS_INCLUDE
    importing
      !IS_METHOD_DEF type SEOCPDKEY
    exporting
      !EV_PROGRAM type PROGNAME
      !EV_INCLUDE type PROGRAM .
  methods GET_USED_OBJECTS
    importing
      !IS_METHOD_DEF type SEOCPDKEY .
protected section.
private section.

  types:
    BEGIN OF ty_method_detail,
           method_type TYPE c length 1,
           caller_name TYPE string,
           method_cls_name TYPe string,
           method_name TYPE string,
           method_signature TYPE SEOSUBCODF,
        END OF Ty_method_detail .
  types:
    tt_method_detail TYPE STANDARD TABLE OF ty_method_detail .

  constants:
    BEGIN OF cs_method_Type,
              constructor TYPE c length 1 value 1,
              instance type c length 1 value 2,
            end of cs_method_type .
  data MT_RESULT type SCR_REFS .

  methods GET_METHOD_TYPE
    importing
      !IV_RAW type STRING
    returning
      value(RS_METHOD_DETAIL) type TY_METHOD_DETAIL .
ENDCLASS.



CLASS ZCL_ABAP_COVARIANCE_TOOL IMPLEMENTATION.


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
    CONSTANTS : cv_instance TYPE string VALUE '^\\TY:(.*)\\ME:(.*)$'.

    DATA: lo_regex            TYPE REF TO cl_abap_regex,
          lo_matcher          TYPE REF TO cl_abap_matcher,
          lt_reg_match_result TYPE match_result_tab.
    FIELD-SYMBOLS: <reg_entry> LIKE LINE OF lt_reg_match_result,
                   <match1>    LIKE LINE OF <reg_entry>-submatches,
                   <match2>    LIKE <match1>.

    lo_regex = NEW #( pattern = cv_instance ).

    lo_matcher = lo_regex->create_matcher( EXPORTING text = iv_raw ).

    IF lo_matcher->match( ) = abap_true.
      rs_method_detail-method_type = cs_method_type-instance.
      lt_reg_match_result = lo_matcher->find_all( ).
      READ TABLE lt_reg_match_result ASSIGNING <reg_entry> INDEX 1.

      READ TABLE <reg_entry>-submatches ASSIGNING <match1> INDEX 1.
      rs_method_detail-method_cls_name = iv_raw+<match1>-offset(<match1>-length).

      READ TABLE <reg_entry>-submatches ASSIGNING <match2> INDEX 2.
      rs_method_detail-method_name = iv_raw+<match2>-offset(<match2>-length).

      SELECT SINGLE * INTO rs_method_detail-method_signature FROM SEOSUBCODF
          where CLSNAME = rs_method_detail-method_cls_name and cmpname = rs_method_detail-method_name.
    ENDIF.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_ABAP_COVARIANCE_TOOL->GET_USED_OBJECTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_METHOD_DEF                  TYPE        SEOCPDKEY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_used_objects.
    DATA: lv_include TYPE progname,
          lv_main    TYPE progname.

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

    LOOP AT mt_result ASSIGNING <method> WHERE tag = 'ME'.
      DATA(ls_method) = VALUE ty_method( method_name = <method>-name
                                         method_type = <method>-full_name ).
      APPEND ls_method TO lt_method.
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