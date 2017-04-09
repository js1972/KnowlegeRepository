*&---------------------------------------------------------------------*
*& Report  ZPARTNER_DETERMINE_VIA_CODE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zdeter_and_create.

DATA: lt_input_fields     TYPE  crmt_input_field_tab,
      ls_input_field      LIKE LINE OF lt_input_fields,
      ls_field_name       LIKE LINE OF ls_input_field-field_names,
      lv_guid             TYPE guid_16,
      lt_orderadm_h_com   TYPE crmt_orderadm_h_comt,
      ls_orderadm_h_com   LIKE LINE OF lt_orderadm_h_com,
      lt_partner          TYPE crmt_partner_comt,
      ls_partner          LIKE LINE OF lt_partner,
      ls_partner_control  TYPE crmt_partner_control,
      ls_com_structure    TYPE string,
      lv_selection_needed TYPE  crmt_boolean,
      lv_is_buying_center TYPE  abap_bool,
      lt_partner_com      TYPE  crmt_partner_comt,
      ls_partner_com      LIKE LINE OF lt_partner_com,
      lt_attributes_com   TYPE  crmt_partner_attribute_com_tab,
      lt_save             TYPE crmt_object_guid_tab,
      lt_saved            TYPE crmt_return_objects,
      ls_saved            LIKE LINE OF lt_saved,
      lt_switch           TYPE crmt_active_switch_t,
      ls_switch           TYPE LINE OF crmt_active_switch_t.

START-OF-SELECTION.

  PERFORM call_bp_determ_api.
  PERFORM call_order_maintain.
  PERFORM call_order_save.

FORM call_bp_determ_api.
  CALL FUNCTION 'GUID_CREATE'
    IMPORTING
      ev_guid_16 = lv_guid.


  ls_partner_control-document_id = lv_guid.
  ls_partner_control-caller = 'CRM'.
  ls_partner_control-object_type = 'BUS2000112'.
  ls_partner_control-master_data_structure = 'CRMT_BUS_SALES_COM'.
  ls_partner_control-determ_proc = '00000041'.
  ls_partner_control-scope = 'A'.
  ls_partner_control-no_default_for_calendar_flag = 'X'.
  ls_partner_control-process_type = 'SC1'.

  CALL FUNCTION 'CRM_PARTNER_DETERMINATION_OW'
    EXPORTING
      iv_ref_guid         = lv_guid
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
ENDFORM.

FORM call_order_maintain.
  CLEAR: ls_orderadm_h_com, ls_input_field, lt_input_fields.
  ls_orderadm_h_com-guid = lv_guid.
  ls_orderadm_h_com-description = 'created by code on:' && sy-timlo.
  ls_orderadm_h_com-process_type = 'SC1'.
  ls_orderadm_h_com-mode = 'A'.
  APPEND ls_orderadm_h_com TO lt_orderadm_h_com.

  ls_input_field-ref_guid = lv_guid.
  ls_input_field-ref_kind = 'A'.
  ls_input_field-objectname = 'ORDERADM_H'.

* sorted table
  ls_field_name-fieldname = 'DESCRIPTION'.
  APPEND ls_field_name TO ls_input_field-field_names.
  ls_field_name-fieldname = 'MODE'.
  APPEND ls_field_name TO ls_input_field-field_names.
  ls_field_name-fieldname = 'PROCESS_TYPE'.
  APPEND ls_field_name TO ls_input_field-field_names.

  APPEND ls_input_field TO lt_input_fields.

  CLEAR: ls_input_field.
  ls_input_field-ref_guid = lv_guid.
  ls_input_field-ref_kind = 'A'.
  ls_input_field-objectname = 'PARTNER'.

  CLEAR: ls_field_name.
  ls_field_name-fieldname = 'DISPLAY_TYPE'.
  APPEND ls_field_name TO ls_input_field-field_names.

  ls_field_name-fieldname = 'KIND_OF_ENTRY'.
  APPEND ls_field_name TO ls_input_field-field_names.

  ls_field_name-fieldname = 'NO_TYPE'.
  APPEND ls_field_name TO ls_input_field-field_names.

  ls_field_name-fieldname = 'PARTNER_FCT'.
  APPEND ls_field_name TO ls_input_field-field_names.

  ls_field_name-fieldname = 'PARTNER_NO'.
  APPEND ls_field_name TO ls_input_field-field_names.

  ls_input_field-ref_handle = '0000000000'.
  ls_input_field-logical_key = '0000'.
  APPEND ls_input_field TO lt_input_fields.

  ls_partner-ref_guid = lv_guid.
  ls_partner-ref_kind = 'A'.
  ls_partner-kind_of_entry = 'C'.
  ls_partner-partner_fct = '00000003'. "Bill to
  ls_partner-partner_no = '0004102821'.
  ls_partner-display_type = 'BP'.
  ls_partner-no_type = 'BP'.
  APPEND ls_partner TO lt_partner.

  READ TABLE lt_partner_com INTO ls_partner_com INDEX 1.

  ls_partner-ref_guid = lv_guid.
  ls_partner-ref_kind = 'A'.
  ls_partner-kind_of_entry = 'C'.
  ls_partner-partner_fct = ls_partner_com-partner_fct.
  ls_partner-partner_no = ls_partner_com-partner_no.
  ls_partner-display_type = 'BP'.
  ls_partner-no_type = 'BP'.
  APPEND ls_partner TO lt_partner.


  ls_switch-ref_guid = lv_guid.
  ls_switch-ref_kind = 'A'.
  ls_switch-partner_determ = 'A'.
  APPEND ls_switch TO lt_switch.

  CALL FUNCTION 'CRM_ORDER_MAINTAIN'
    EXPORTING
      it_active_switch = lt_switch
      it_partner       = lt_partner
    CHANGING
      ct_orderadm_h    = lt_orderadm_h_com
      ct_input_fields  = lt_input_fields
    EXCEPTIONS
      OTHERS           = 99.

  IF sy-subrc = 0.
    WRITE:/ 'Order maintain function is done successfully.'.
  ENDIF.
ENDFORM.

FORM call_order_save.
  INSERT lv_guid INTO TABLE lt_save.

  CALL FUNCTION 'CRM_ORDER_SAVE'
    EXPORTING
      it_objects_to_save   = lt_save
      iv_update_task_local = abap_true
      iv_no_bdoc_send      = abap_true
    IMPORTING
      et_saved_objects     = lt_saved
    EXCEPTIONS
      document_not_saved   = 1.

  IF sy-subrc <> 0.
    WRITE: / 'Service contract created failed'.
  ELSE.
    READ TABLE lt_saved INTO ls_saved INDEX 1.
    WRITE: / 'service contract created successfully, id: ' , ls_saved-object_id.

  ENDIF.

  COMMIT WORK AND WAIT.

ENDFORM.