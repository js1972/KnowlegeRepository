*&---------------------------------------------------------------------*
*& Report  ZCALL_FUNCTION
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zcall_function.

DATA: lo_function   TYPE REF TO if_fdt_function,
      lo_context    TYPE REF TO if_fdt_context,
      lo_result     TYPE REF TO if_fdt_result,
      lx_fdt        TYPE REF TO cx_fdt,
      lo_trace      TYPE REF TO if_fdt_trace,
      lo_lean_trace TYPE REF TO if_fdt_lean_trace,
      lt_trace      TYPE if_fdt_lean_trace=>ts_record,
      lv_string     TYPE string.
FIELD-SYMBOLS <ls_message> TYPE if_fdt_types=>s_message.
lo_function =
cl_fdt_factory=>if_fdt_factory~get_instance(
)->get_function( iv_id = '3440B5B172DE1ED48BEAF1808FD98CB7' ).
TRY.
    lo_context = lo_function->get_process_context( ).
    lo_context->set_value( iv_name = 'CUSTOMER'
    ia_value = 'sap' ).
    CALL METHOD lo_function->process
      EXPORTING
        io_context    = lo_context
        iv_trace_mode = if_fdt_constants=>gc_trace_mode_lean
      IMPORTING
        eo_result     = lo_result
        eo_trace      = lo_trace.

    lo_result->get_value( IMPORTING ea_value = lv_string ).
    WRITE lv_string .
  CATCH cx_fdt INTO lx_fdt.
    LOOP AT lx_fdt->mt_message ASSIGNING <ls_message>.
      WRITE / <ls_message>-text.
    ENDLOOP.
ENDTRY.

lo_lean_trace ?= lo_trace.

lo_lean_trace->read( IMPORTING ets_trace_record = lt_trace ).

lo_lean_trace->save( ).