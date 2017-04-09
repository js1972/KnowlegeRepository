report  zbcalv_tree_01.
types: begin of ty_tree_node,
                   id type char18,
                   text type char40,
       end of ty_tree_node.

data: g_alv_tree         type ref to cl_gui_alv_tree,
      g_custom_container type ref to cl_gui_custom_container.

data: gt_sflight      type sflight occurs 0,      "Output-Table
      gt_scala TYPE STANDARD TABLE OF ty_tree_node,
      ok_code like sy-ucomm,
      save_ok like sy-ucomm,           "OK-Code
      g_max type i value 255.

end-of-selection.

  call screen 100.

module pbo output.

  set pf-status 'MAIN100'.
  set titlebar 'MAINTITLE'.

  if g_alv_tree is initial.
    perform init_tree.

    call method cl_gui_cfw=>flush
      exceptions
        cntl_system_error = 1
        cntl_error        = 2.
    assert sy-subrc = 0.

  endif.

endmodule.                             " PBO  OUTPUT

module pai input.
  save_ok = ok_code.
  clear ok_code.

  case save_ok.
    when 'EXIT' or 'BACK' or 'CANC'.
      perform exit_program.

    when others.
      call method cl_gui_cfw=>dispatch.
  endcase.

  call method cl_gui_cfw=>flush.
endmodule.                             " PAI  INPUT


form init_tree.
  data: l_tree_container_name(30) type c.
  l_tree_container_name = 'CCONTAINER1'.

     create object g_custom_container
        exporting
              container_name = l_tree_container_name
        exceptions
              cntl_error                  = 1
              cntl_system_error           = 2
              create_error                = 3
              lifetime_error              = 4
              lifetime_dynpro_dynpro_link = 5.
    if sy-subrc <> 0.
      message x208(00) with 'ERROR'(100).
    endif.

  create object g_alv_tree
    exporting
        parent              = g_custom_container
        node_selection_mode = cl_gui_column_tree=>node_sel_mode_single
        item_selection      = 'X'
        no_html_header      = 'X'
        no_toolbar          = ''
    exceptions
        cntl_error                   = 1
        cntl_system_error            = 2
        create_error                 = 3
        lifetime_error               = 4
        illegal_node_selection_mode  = 5
        failed                       = 6
        illegal_column_name          = 7.
  if sy-subrc <> 0.
    message x208(00) with 'ERROR'.                          "#EC NOTEXT
  endif.

  data l_hierarchy_header type treev_hhdr.
  perform build_hierarchy_header changing l_hierarchy_header.

  call method g_alv_tree->set_table_for_first_display
    exporting
      i_structure_name    = 'SFLIGHT'
      is_hierarchy_header = l_hierarchy_header
    changing
      it_outtab           = gt_sflight. "table must be empty !

  perform jerry_create_tree.

  call method g_alv_tree->frontend_update.

endform.

form jerry_create_tree.
   DATA: p_relat_key type lvc_nkey,
         p_node_key type lvc_nkey,
         ls_sflight LIKE LINE OF gt_sflight.

   call method g_alv_tree->add_node
    exporting
      i_relat_node_key = p_relat_key
      i_relationship   = cl_gui_column_tree=>relat_last_child
      i_node_text      = 'Jerry'
      is_outtab_line   = ls_sflight
    importing
      e_new_node_key   = p_node_key.

   call method g_alv_tree->add_node
    exporting
      i_relat_node_key = p_node_key
      i_relationship   = cl_gui_column_tree=>relat_last_child
      i_node_text      = 'Scala'
      is_outtab_line   = ls_sflight
    importing
      e_new_node_key   = p_node_key.

   "ls_sflight-id = 'Spring'.
   "ls_sflight-text = 'SSH Integration'.

   call method g_alv_tree->add_node
    exporting
      i_relat_node_key = p_node_key
      i_relationship   = cl_gui_column_tree=>relat_last_child
      i_node_text      = 'i042416'
      is_outtab_line   = ls_sflight
    importing
      e_new_node_key   = p_node_key.
endform.                             " init_tree

form build_hierarchy_header changing
                               p_hierarchy_header type treev_hhdr.

  p_hierarchy_header-heading = 'Month/Carrier/Date'(300).
  p_hierarchy_header-tooltip = 'Flights in a month'(400).
  p_hierarchy_header-width = 30.
  p_hierarchy_header-width_pix = ' '.

endform.                               " build_hierarchy_header

form exit_program.

  call method g_custom_container->free.
  leave program.

endform.                               " exit_program