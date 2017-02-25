*&---------------------------------------------------------------------*
*& Report ZCREATE_FM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcreate_fm.

DATA: sap_cus(10).
DATA: date      TYPE sy-datum,
      time      TYPE sy-uzeit,
      pool_name TYPE rs38l-area,
      func_name TYPE rs38l-name,
       lt_codeline              type standard table of char255,
      l_function_include       type progname.

DATA it_exception_list     TYPE TABLE OF rsexc.
DATA wa_rsexc TYPE rsexc.
DATA it_export_parameter   TYPE TABLE OF rsexp.
DATA it_import_parameter   TYPE TABLE OF rsimp.
DATA wa_rsimp TYPE rsimp.
DATA it_tables_parameter   TYPE TABLE OF rstbl.
DATA it_changing_parameter TYPE TABLE OF rscha.
DATA wa_rscha TYPE rscha.
DATA it_parameter_docu TYPE TABLE OF rsfdo.
DATA subrc             TYPE sy-subrc.
DATA l_result          TYPE cts_check_result.

date = sy-datum.
time = sy-uzeit.

CONCATENATE 'TEST_FBS_' date time INTO pool_name.
CONCATENATE 'FB1_' pool_name INTO func_name.

CALL FUNCTION 'RS_FUNCTION_POOL_INSERT'
  EXPORTING
    function_pool       = pool_name
    short_text          = 'TEST_FUGR_FBS'               "#EC NOTEXT
    devclass            = '$TMP'                        "#EC NOTEXT
    responsible         = sy-uname
    suppress_corr_check = space
  EXCEPTIONS
    OTHERS              = 12.
IF sy-subrc <> 0.
  WRITE:/ 'Fugr was not created!' .
  RETURN.
ENDIF.

wa_rsimp-parameter = 'P1_I'.                                "#EC NOTEXT
wa_rsimp-default   = '10'.                                  "#EC NOTEXT
wa_rsimp-reference = 'X'.                                   "#EC NOTEXT
wa_rsimp-typ       = 'I'.                                   "#EC NOTEXT
APPEND wa_rsimp TO it_import_parameter.

wa_rscha-parameter = 'P1_C'.                                "#EC NOTEXT
wa_rscha-types     = 'X'.                                   "#EC NOTEXT
wa_rscha-ref_class = 'X'.                                   "#EC NOTEXT
wa_rscha-typ       = 'CL_FUNCTION_BUILDER'.                 "#EC NOTEXT
APPEND wa_rscha TO it_changing_parameter.

CALL FUNCTION 'FUNCTION_CREATE'
  EXPORTING
    funcname           = func_name
    function_pool      = pool_name
    short_text         = 'TEST_FUNC_FB'                 "#EC NOTEXT
     importing
            function_include             = l_function_include
  tables
        exception_list          = it_exception_list
        export_parameter        = it_export_parameter
        import_parameter        = it_import_parameter
        tables_parameter        = it_tables_parameter
        changing_parameter      = it_changing_parameter
        parameter_docu          = it_parameter_docu
      exceptions
        double_task             = 1
        error_message           = 2
        function_already_exists = 3
        invalid_function_pool   = 4
        invalid_name            = 5
        too_many_functions      = 6
        others                  = 7.

IF sy-subrc <> 0.
  WRITE: / 'failed:', sy-subrc.
  RETURN.
ENDIF.

WRITE: / 'created successful:', func_name.
APPEND | WRITE:/ 'OK'.| TO lt_codeline.
insert report l_function_include from lt_codeline.