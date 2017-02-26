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
  methods GENERATE_CURRIED_FM
    returning
      value(RV_RESULT) type INT4 .
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
* | Instance Private Method ZCL_CURRY->GENERATE_CURRIED_FM
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_RESULT                      TYPE        INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GENERATE_CURRIED_FM.
    DATA: lv_date               TYPE sy-datum,
      lv_time               TYPE sy-uzeit,
      lv_pool_name          TYPE rs38l-area,
      lv_func_name          TYPE rs38l-name,
      lt_codeline        TYPE STANDARD TABLE OF char255,
      l_function_include TYPE progname.

DATA it_exception_list     TYPE TABLE OF rsexc.
DATA it_export_parameter   TYPE TABLE OF rsexp.
DATA it_import_parameter   TYPE TABLE OF rsimp.
DATA wa_rsimp TYPE rsimp.
DATA it_tables_parameter   TYPE TABLE OF rstbl.
DATA it_changing_parameter TYPE TABLE OF rscha.
DATA wa_rscha TYPE rscha.
DATA it_parameter_docu TYPE TABLE OF rsfdo.

lv_date = sy-datum.
lv_time = sy-uzeit.

CONCATENATE 'ZCURRY' lv_date lv_time INTO lv_pool_name.
CONCATENATE 'ZCUR' lv_pool_name INTO lv_func_name.

CALL FUNCTION 'RS_FUNCTION_POOL_INSERT'
  EXPORTING
    function_pool       = lv_pool_name
    short_text          = 'Curried test by Jerry'       "#EC NOTEXT
    devclass            = '$TMP'                        "#EC NOTEXT
    responsible         = sy-uname
    suppress_corr_check = space
  EXCEPTIONS
      NAME_ALREADY_EXISTS = 1
      NAME_NOT_CORRECT = 2
      FUNCTION_ALREADY_EXISTS = 3
      INVALID_FUNCTION_POOL = 4
      INVALID_NAME = 5
      TOO_MANY_FUNCTIONS = 6
      NO_MODIFY_PERMISSION = 7
      NO_SHOW_PERMISSION = 8
      ENQUEUE_SYSTEM_FAILURE = 9
      CANCELED_IN_CORR = 10
      UNDEFINED_ERROR = 11
    OTHERS              = 12.
IF sy-subrc <> 0.
  rv_result = sy-subrc.
  WRITE:/ 'Functio group was not created!' .
  RETURN.
ENDIF.

wa_rsimp-parameter = 'P1_I'.                                "#EC NOTEXT
wa_rsimp-default   = '10'.                                  "#EC NOTEXT
wa_rsimp-reference = 'X'.                                   "#EC NOTEXT
wa_rsimp-typ       = 'I'.                                   "#EC NOTEXT
APPEND wa_rsimp TO it_import_parameter.

wa_rscha-parameter = 'P1_C'.                                "#EC NOTEXT
wa_rscha-reference     = 'X'.                                   "#EC NOTEXT
wa_rscha-typ       = 'I'.                              "#EC NOTEXT
APPEND wa_rscha TO it_changing_parameter.

CALL FUNCTION 'FUNCTION_CREATE'
  EXPORTING
    funcname                = lv_func_name
    function_pool           = lv_pool_name
    short_text              = 'TEST_FUNC_FB'                 "#EC NOTEXT
  IMPORTING
    function_include        = l_function_include
  TABLES
    exception_list          = it_exception_list
    export_parameter        = it_export_parameter
    import_parameter        = it_import_parameter
    tables_parameter        = it_tables_parameter
    changing_parameter      = it_changing_parameter
    parameter_docu          = it_parameter_docu
  EXCEPTIONS
    double_task             = 1
    error_message           = 2
    function_already_exists = 3
    invalid_function_pool   = 4
    invalid_name            = 5
    too_many_functions      = 6
    OTHERS                  = 7.

IF sy-subrc <> 0.
  WRITE: / 'failed:', sy-subrc.
  RETURN.
ENDIF.

READ REPORT l_function_include INTO lt_codeline.

DELETE lt_codeline INDEX lines( lt_codeline ).
DELETE lt_codeline WHERE table_line IS INITIAL.

WRITE: / 'created successful:', lv_func_name.
APPEND | WRITE:/ 'OK'.| TO lt_codeline.
APPEND | WRITE:/ P1_I.| TO lt_codeline.
APPEND 'ENDFUNCTION.' TO lt_codeline.
INSERT REPORT l_function_include FROM lt_codeline.
COMMIT WORK AND WAIT.
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