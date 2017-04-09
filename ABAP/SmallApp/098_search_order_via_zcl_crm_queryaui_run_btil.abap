*&---------------------------------------------------------------------*
*& Report  ZORDER_SEARCH
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

" order search via inherited sub Genil handler class
REPORT zorder_search.

DATA: lo_tool TYPE REF TO zcl_crm_queryaui_run_btil.

DATA: lt_parameter TYPE crmt_name_value_pair_tab,
      ls_parameter LIKE LINE OF lt_parameter,
      lt_sel_para  TYPE genilt_selection_parameter_tab,
      ls_sel_para  LIKE LINE OF lt_sel_para.


ls_parameter-name = 'MAINCATEGORY'.
ls_parameter-value = 'SRVO'.
APPEND ls_parameter TO lt_parameter.

ls_parameter-name = 'POSTING_DATE'.
ls_parameter-value = '20140318'.
APPEND ls_parameter TO lt_parameter.

ls_sel_para-attr_name = 'MAINCATEGORY'.
ls_sel_para-sign = 'I'.
ls_sel_para-option = 'EQ'.
ls_sel_para-low = 'SRVO'.
APPEND ls_sel_para TO lt_sel_para.

ls_sel_para-attr_name = 'POSTING_DATE'.
ls_sel_para-sign = 'I'.
ls_sel_para-option = 'BT'.
ls_sel_para-low = '20140318'.
ls_sel_para-high = '20140320'.
APPEND ls_sel_para TO lt_sel_para.


CREATE OBJECT lo_tool EXPORTING iv_objname = 'BTAdvQueryAUI'.

lo_tool->read( i_param_tab             = lt_parameter
               it_selection_parameters = lt_sel_para
               iv_advanced_search      = abap_true ).

DATA(result) = lo_tool->get( ).
BREAK-POINT.