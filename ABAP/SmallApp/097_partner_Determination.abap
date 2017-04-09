*&---------------------------------------------------------------------*
*& Report  ZPARTNER_DETERMINE_VIA_CODE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zpartner_determine_via_code.

DATA: ls_partner_control TYPE crmt_partner_control,
      ls_com_structure   TYPE string.

DATA: lv_selection_needed TYPE  crmt_boolean,
      lv_is_buying_center TYPE  abap_bool,
      lt_partner_com      TYPE  crmt_partner_comt,
      lt_input_fields     TYPE  crmt_input_field_tab,
      lt_attributes_com   TYPE  crmt_partner_attribute_com_tab.


ls_partner_control-document_id = 'FA163EEF573D1EE4BBC44EC5ED565039'.
ls_partner_control-caller = 'CRM'.
ls_partner_control-object_type = 'BUS2000112'.
ls_partner_control-master_data_structure = 'CRMT_BUS_SALES_COM'.
ls_partner_control-determ_proc = '00000041'.
ls_partner_control-scope = 'A'.
ls_partner_control-no_default_for_calendar_flag = 'X'.
ls_partner_control-process_type = 'SC1'.

CALL FUNCTION 'CRM_PARTNER_DETERMINATION_OW'
  EXPORTING
    iv_ref_guid         = 'FA163EEF573D1EE4BBC44EC5ED565039'
    iv_ref_kind         = 'A'
    iv_point_of_determ  = '0'
    iv_predecessor_guid = '00000000000000000000000000000000'
    is_partner_control  = ls_partner_control
    is_md_structure     = ls_com_structure
  IMPORTING
    ev_selection_needed = lv_selection_needed
    et_partner_com      = lt_partner_com
    et_input_fields     = lt_input_fields
    et_attributes_com   = lt_attributes_com
  EXCEPTIONS
    error_occurred      = 1
    parameter_error     = 2
    OTHERS              = 3.

IF sy-subrc = 0.
   WRITE: / 'partner determination is done successfully'.
ENDIF.

BREAK-POINT.