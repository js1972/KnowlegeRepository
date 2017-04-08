*&---------------------------------------------------------------------*
*& Report ZREAD_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zread_report.
INCLUDE: crm_object_names_con.

TYPES:
  BEGIN OF ty_clipdata,
    data TYPE c LENGTH 100,
  END   OF ty_clipdata .
TYPES:
  tt_formatted TYPE STANDARD TABLE OF ty_clipdata .

DATA: lt_source    TYPE string_table,
      lv_ret       TYPE int4,
      lt_token     TYPE TABLE OF stokes,
      lt_statement TYPE TABLE OF sstmnt,
      lt_export    TYPE tt_formatted.

CONSTANTS: gc_variable TYPE char20 VALUE 'Variable',
           gc_value    TYPE char20 VALUE 'Value'.
READ REPORT 'LCRM_ORDER_OWF03' INTO lt_source .

SCAN ABAP-SOURCE lt_source TOKENS INTO lt_token
                      STATEMENTS INTO lt_statement.

WRITE:  10 gc_variable COLOR COL_NEGATIVE, 40 gc_value COLOR COL_POSITIVE.

APPEND |{ gc_variable } \| { gc_value } | TO lt_export.
APPEND '-----|-----' TO lt_export.
LOOP AT lt_token ASSIGNING FIELD-SYMBOL(<when>) WHERE str = 'WHEN'.
  DATA(lv_name) = lt_token[ sy-tabix + 1 ]-str.
  ASSIGN (lv_name) TO FIELD-SYMBOL(<name>).
  WRITE:/  lv_name UNDER gc_variable, <name> UNDER gc_value.
  APPEND |{ lv_name } \| { <name> }| TO lt_export.
ENDLOOP.

cl_gui_frontend_services=>clipboard_export(
    EXPORTING
        no_auth_check        = abap_true
        IMPORTING
          data                 = lt_export
        CHANGING
          rc                   = lv_ret
        EXCEPTIONS
          cntl_error           = 1
          error_no_gui         = 2
          not_supported_by_gui = 3
      ).