REPORT  zbcalv_tree_01.

DATA: g_alv_tree         TYPE REF TO cl_gui_alv_tree,
      g_custom_container TYPE REF TO cl_gui_custom_container,
      gt_scala           TYPE STANDARD TABLE OF zcl_alv_tool=>TY_DISPLAYED_NODE,
      ok_code            LIKE sy-ucomm,
      save_ok            LIKE sy-ucomm,
      ls_data            LIKE LINE OF gt_scala,
      g_max              TYPE i VALUE 255.

END-OF-SELECTION.
  DATA(lo_tool) = NEW zcl_alv_tool( ).
  DATA(lt_fieldcat) = lo_tool->get_fieldcat_by_data( ls_data ).
  CALL SCREEN 100.

MODULE pbo OUTPUT.

  SET PF-STATUS 'MAIN100'.
  SET TITLEBAR 'MAINTITLE'.

  IF g_alv_tree IS INITIAL.
    PERFORM init_tree.
    CALL METHOD cl_gui_cfw=>flush
      EXCEPTIONS
        cntl_system_error = 1
        cntl_error        = 2.
    ASSERT sy-subrc = 0.
  ENDIF.
ENDMODULE.                             " PBO  OUTPUT

MODULE pai INPUT.
  save_ok = ok_code.
  CLEAR ok_code.

  CASE save_ok.
    WHEN 'EXIT' OR 'BACK' OR 'CANC'.
      PERFORM exit_program.
    WHEN OTHERS.
      CALL METHOD cl_gui_cfw=>dispatch.
  ENDCASE.

  CALL METHOD cl_gui_cfw=>flush.
ENDMODULE.                             " PAI  INPUT


FORM init_tree.
  g_custom_container = lo_tool->GET_CONTAINER( 'CCONTAINER1' ).

  g_alv_tree = lo_tool->get_tree( g_custom_container ).

  DATA l_hierarchy_header TYPE treev_hhdr.
  PERFORM build_hierarchy_header CHANGING l_hierarchy_header.

  CALL METHOD g_alv_tree->set_table_for_first_display
    EXPORTING
      is_hierarchy_header = l_hierarchy_header
    CHANGING
      it_fieldcatalog     = lt_fieldcat
      it_outtab           = gt_scala.

  PERFORM jerry_create_tree.

  CALL METHOD g_alv_tree->frontend_update.
ENDFORM.

FORM jerry_create_tree.

  data(lt_data) = lo_tool->get_test_Data( ).
  lo_tool->draw_tree( lt_data ).

ENDFORM.                             " init_tree

FORM build_hierarchy_header CHANGING p_hierarchy_header TYPE treev_hhdr.

  p_hierarchy_header-heading = 'Material hierarchy'.
  p_hierarchy_header-width = 30.
  p_hierarchy_header-width_pix = ' '.

ENDFORM.                               " build_hierarchy_header

FORM exit_program.

  CALL METHOD g_custom_container->free.
  LEAVE PROGRAM.

ENDFORM.                               " exit_program