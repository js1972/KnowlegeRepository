REPORT ZTEST_F4_DYNPRO MESSAGE-ID ztest1.

*data
DATA:
ls_dyn_field type dynpread,
"Very important
lt_dyn_field type TABLE OF dynpread.
DATA:
ls_spfli type spfli,
lt_spfli like TABLE OF ls_spfli.

* parameters
PARAMETERS:
p_carrid type spfli-carrid,
p_connid type spfli-connid.

* PBO
AT SELECTION-SCREEN OUTPUT.
ls_dyn_field-fieldname                                       = 'P_CARRID'.
APPEND ls_dyn_field to lt_dyn_field. " carrid
ls_dyn_field-fieldname                                       = 'P_CONNID'.
APPEND ls_dyn_field to lt_dyn_field. " Connid

* PAI(Value-Request)
AT SELECTION-SCREEN on VALUE-REQUEST FOR p_connid.
"1. get the values in the dynpro
CALL FUNCTION 'DYNP_VALUES_READ'
EXPORTING
DYNAME                                                       = sy-repid
DYNUMB                                                       = sy-dynnr
*      TRANSLATE_TO_UPPER                                    = ’ ’
*      REQUEST                                               = ’ ’
*      PERFORM_CONVERSION_EXITS                              = ’ ’
*      PERFORM_INPUT_CONVERSION                              = ’ ’
*      DETERMINE_LOOP_INDEX                                  = ’ ’
*      START_SEARCH_IN_CURRENT_SCREEN                        = ’ ’
*      START_SEARCH_IN_MAIN_SCREEN                           = ’ ’
*      START_SEARCH_IN_STACKED_SCREEN                        = ’ ’
*      START_SEARCH_ON_SCR_STACKPOS                          = ’ ’
*      SEARCH_OWN_SUBSCREENS_FIRST                           = ’ ’
*      SEARCHPATH_OF_SUBSCREEN_AREAS                         = ’ ’
TABLES
DYNPFIELDS                                                   = lt_dyn_field
EXCEPTIONS
INVALID_ABAPWORKAREA                                         = 1
INVALID_DYNPROFIELD                                          = 2
INVALID_DYNPRONAME                                           = 3
INVALID_DYNPRONUMMER                                         = 4
INVALID_REQUEST                                              = 5
NO_FIELDDESCRIPTION                                          = 6
INVALID_PARAMETER                                            = 7
UNDEFIND_ERROR                                               = 8
DOUBLE_CONVERSION                                            = 9
STEPL_NOT_FOUND                                              = 10
OTHERS                                                       = 11 .
IF SY-SUBRC <> 0.
WRITE:/ 'Error occurs in Read_value.'.
LEAVE LIST-PROCESSING.
ENDIF.

"2. check if Connid has already been input
READ TABLE lt_dyn_field into ls_dyn_field with key FIELDNAME = 'P_CONNID'.
IF ls_dyn_field-FIELDVALUE is NOT INITIAL.
"You have already input data in CONNID’.
MESSAGE i028.
EXIT.
ENDIF.

"3. get the CARIID value of user-input
READ TABLE lt_dyn_field into ls_dyn_field with key FIELDNAME = 'P_CARRID'.
IF ls_dyn_field-FIELDVALUE is INITIAL.
"You should first input data in CARRID’.
MESSAGE i029.
exit.
ENDIF.

"4. get the table-value from BD
SELECT * from spfli into TABLE lt_spfli
WHERE carrid                                                 = ls_dyn_field-FIELDVALUE.
IF sy-subrc <> 0.
"No data found for your input of CARRID.
MESSAGE i030.
exit.
ENDIF.

"5. form the F4Help
CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
EXPORTING
*      DDIC_STRUCTURE                                        = ’ ’
RETFIELD                                                     = 'CONNID'
*      PVALKEY                                               = ’ ’
DYNPPROG                                                     = sy-repid
DYNPNR                                                       = sy-dynnr
DYNPROFIELD                                                  = 'P_CONNID'
*      STEPL                                                 = 0
*      WINDOW_TITLE                                          =
*      VALUE                                                 = ’ ’
VALUE_ORG                                                    = 'S' "S:Structure;Default(C):cell by cell
*      MULTIPLE_CHOICE                                       = ’ ’
*      DISPLAY                                               = ’ ’
*      CALLBACK_PROGRAM                                      = ’ ’
*      CALLBACK_FORM                                         = ’ ’
*      MARK_TAB                                              =
*    IMPORTING
*      USER_RESET                                            =
TABLES
VALUE_TAB                                                    = lt_spfli
*      FIELD_TAB                                             =
*      RETURN_TAB                                            =
*      DYNPFLD_MAPPING                                       =
EXCEPTIONS
PARAMETER_ERROR                                              = 1
NO_VALUES_FOUND                                              = 2
OTHERS                                                       = 3.
IF SY-SUBRC <> 0.
"Error occurs in F4 for CONNID.
MESSAGE i031.
EXIT.
ENDIF.