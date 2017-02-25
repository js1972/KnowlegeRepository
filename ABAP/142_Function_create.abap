*&---------------------------------------------------------------------*
*& Report ZCREATE_FM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcreate_fm.

DATA: date               TYPE sy-datum,
      time               TYPE sy-uzeit,
      pool_name          TYPE rs38l-area,
      func_name          TYPE rs38l-name,
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
wa_rscha-reference     = 'X'.                                   "#EC NOTEXT
wa_rscha-typ       = 'I'.                              "#EC NOTEXT
APPEND wa_rscha TO it_changing_parameter.

CALL FUNCTION 'FUNCTION_CREATE'
  EXPORTING
    funcname                = func_name
    function_pool           = pool_name
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

WRITE: / 'created successful:', func_name.
APPEND | WRITE:/ 'OK'.| TO lt_codeline.
APPEND | WRITE:/ P1_I.| TO lt_codeline.
APPEND 'ENDFUNCTION.' TO lt_codeline.
INSERT REPORT l_function_include FROM lt_codeline.
COMMIT WORK AND WAIT.

DATA: ptab TYPE abap_func_parmbind_tab,
      lv_i TYPE int4 value 12.

ptab = VALUE #( ( name  = 'P1_I'
                  kind  = abap_func_exporting
                  value = REF #( 3 ) )

                ( name  = 'P1_C'
                  kind  = abap_func_changing
                  value = REF #( lv_i ) )
                ).
TRY.
    CALL FUNCTION func_name
      PARAMETER-TABLE ptab.
  CATCH cx_root INTO DATA(cx_root).
    WRITE: / cx_root->get_text( ).
ENDTRY.

call FUNCTION 'FUNCTION_DELETE'
   EXPORTING
      FUNCNAME = func_name.

call FUNCTION 'FUNCTION_POOL_DELETE'
   EXPORTING
      pool = pool_name.