class ZCL_CURRY definition
  public
  final
  create public .

public section.

  class-methods CLASS_CONSTRUCTOR .
  class-methods CURRY
    importing
      !IV_FUNC type RS38L_FNAM
      !IT_ARGUMENT type STRING_TABLE
    returning
      value(RV_CURRIED_FUNC) type RS38L_FNAM .
protected section.
private section.

  types:
    begin of ty_curried_argument,
           arg_name TYPE string,
           arg_value TYPE string,
       END OF ty_curried_argument .
  types:
    tt_curried_argument TYPE TABLE OF ty_curried_argument WITH KEY arg_name .
  types:
    BEGIN OF ty_curried_func,
           func_name TYPE RS38L_FNAM,
           curried_func TYPE RS38L_FNAM,
           curried_arg TYPE tt_curried_argument,
        END OF ty_curried_func .
  types:
    tt_curried_func TYPE TABLE OF ty_curried_func WITH KEY func_name curried_func .

  data MT_CURRIED_FUNC type TT_CURRIED_FUNC .
  data MV_ORG_FUNC type RS38L_FNAM .
  class-data SO_INSTANCE type ref to ZCL_CURRY .

  methods RUN
    importing
      !IV_FUNC type RS38L_FNAM
      !IT_ARGUMENT type STRING_TABLE .
  methods PARSE_ARGUMENT
    importing
      !IT_ARGUMENT type STRING_TABLE .
ENDCLASS.



CLASS ZCL_CURRY IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CURRY=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CLASS_CONSTRUCTOR.
    create object so_instance.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CURRY=>CURRY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_FUNC                        TYPE        RS38L_FNAM
* | [--->] IT_ARGUMENT                    TYPE        STRING_TABLE
* | [<-()] RV_CURRIED_FUNC                TYPE        RS38L_FNAM
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CURRY.
    so_instance->run( IV_FUNC = IV_FUNC IT_ARGUMENT = IT_ARGUMENT ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CURRY->PARSE_ARGUMENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ARGUMENT                    TYPE        STRING_TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method PARSE_ARGUMENT.
    data: lt_argu TYPE TABLE OF FUPARAREF,
          lt_parsed TYPE tt_curried_argument.

    SELECT * INTO TABLE lt_argu FROM FUPARAREF WHERE funcname = mv_org_func and paramtype = 'I'.
    CHECK sy-subrc = 0.

    LOOP AT lt_argu ASSIGNING FIELD-SYMBOL(<form_argu>).
      APPEND INITIAL LINE TO lt_parsed ASSIGNING FIELD-SYMBOL(<parsed_argu>).
      CLEAR: <parsed_argu>.
      <parsed_argu>-arg_name = <form_argu>-parameter.
      READ TABLE IT_ARGUMENT ASSIGNING FIELD-SYMBOL(<curried>) INDEX sy-tabix.
      IF sy-subrc = 0.
        <parsed_argu>-arg_value = <curried>.
      ENDIF.
    ENDLOOP.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_CURRY->RUN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_FUNC                        TYPE        RS38L_FNAM
* | [--->] IT_ARGUMENT                    TYPE        STRING_TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method RUN.
     mv_org_func = IV_FUNC.
  endmethod.
ENDCLASS.