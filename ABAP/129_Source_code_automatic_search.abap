*&---------------------------------------------------------------------*
*& Report ZFAKE_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zfake_test.

DATA: ddic type DEVELEMTAB,
      ddic_line LIKE LINE OF ddic,
      input type DEVELEM,
      table type DEVELEMTAB.
input-ELEM_TYPE = 'DTEL'.
input-ELEM_KEY = 'COMT_OBJECT_GUID'.
append input to table.
CALL FUNCTION 'PA_DDIC_RECURSIVE_WHERE_USED'
  EXPORTING
    I_DDIC_TYPES                 = table
 IMPORTING
    E_DDIC_TABL_WHERE_USED       = ddic
 EXCEPTIONS
   FAILED                       = 1
   OTHERS                       = 2
          .
ASSERT sy-subrc = 0.
DATA:     rspar     TYPE TABLE OF rsparams,
          wa_rspar  LIKE LINE OF rspar,
          lt_class TYPE STANDARD TABLE OF SEOCLASS,
          ls_class    TYPE SEOCLASS.
SELECT * INTO TABLE lt_class FROM SEOCLASS  UP TO 100 ROWS WHERE clsname LIKE 'CL_CRM%'.
CHECK sy-subrc = 0.
LOOP AT lt_class INTO ls_class.
      wa_rspar-selname = 'P_CLASS'.
      wa_rspar-kind = 'S'.
      wa_rspar-sign = 'I'.
      wa_rspar-option = 'EQ'.
      wa_rspar-low  = ls_class-clsname.
      APPEND wa_rspar to rspar.
ENDLOOP.
LOOP AT DDIC INTO ddic_line.
      wa_rspar-selname = 'SSTRING'.
      wa_rspar-kind = 'S'.
      wa_rspar-sign = 'I'.
      wa_rspar-option = 'EQ'.
      wa_rspar-low  = ddic_line-ELEM_KEY.
      APPEND wa_rspar to rspar.
ENDLOOP.
submit RS_ABAP_SOURCE_SCAN VIA SELECTION-SCREEN
             WITH SELECTION-TABLE rspar.