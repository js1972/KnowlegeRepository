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
* | Instance Public Method ZCL_ABAP_COVARIANCE_TOOL->GET_USED_OBJECTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_METHOD_DEF                  TYPE        SEOCPDKEY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_USED_OBJECTS.
     data: lv_include TYPE progname,
           lv_main TYPE progname,
           lt_result TYPE SCR_REFS.

     call method GET_METHODS_INCLUDE
       EXPORTING
          IS_METHOD_DEF = IS_METHOD_DEF
       IMPORTING
          EV_PROGRAM = lv_main
          EV_INCLUDE = lv_include.

     data(lo_compiler) = new cL_ABAP_COMPILER( p_name = lv_main P_INCLUDE = lv_include ).

     lo_compiler->get_all( IMPORTING p_result = lt_result ).

types: BEGIN OF TY_METHOD,
              METHOD_NAME type STRING,
              method_type type string,
       end of ty_method.

 types: tt_method TYPE STANDARD TABLE OF ty_method.

 types: BEGIN OF TY_variable,
              variable_NAME type STRING,
              variable_type type string,
       end of ty_variable.

 types: tt_variable TYPE STANDARD TABLE OF ty_variable.

 data: lt_method TYPE tt_method,
       lt_variable TYPE tt_variable.

 FIELD-SYMBOLS:<method> LIKE LINE OF lt_result.

   LOOP AT lt_result ASSIGNING <method> where tag = 'ME'.
      data(ls_method) = value ty_method( METHOD_NAME = <method>-name
                                         method_type = <method>-full_name ).
      APPEND ls_method TO lt_method.
   ENDLOOP.

    LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<variable>) where tag = 'DA'.
      data(ls_variable) = value ty_variable( variable_NAME = <variable>-name
                                         variable_type = <variable>-full_name ).
      APPEND ls_variable TO lt_variable.
   ENDLOOP.


     data: lt_ref TYPE SCR_GLREFS.

     lo_compiler->get_all_refs( EXPORTING p_local = 'X' IMPORTING p_result = lt_ref ).

  endmethod.
ENDCLASS.