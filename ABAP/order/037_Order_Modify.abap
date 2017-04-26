*&---------------------------------------------------------------------*
*& Report ZONEORDER_MODIFY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsrvo_modify.

PARAMETERS: txt   TYPE crmd_orderadm_h-description OBLIGATORY DEFAULT 'txt'.

CONSTANTS: gv_srvo_guid TYPE crmt_object_guid VALUE 'FA163EEF573D1ED5808E7E04835A02E9'. "Service Order
DATA: lt_header        TYPE crmt_orderadm_h_comt,
      ls_header        LIKE LINE OF lt_header,
      lt_saved         TYPE crmt_return_objects,
      lt_exception     TYPE crmt_exception_t,
      lt_changed_input TYPE crmt_input_field_tab,
      ls_changed_input LIKE LINE OF lt_changed_input,
      lt_to_save       TYPE crmt_object_guid_tab,
      lt_not_to_save   TYPE crmt_object_guid_tab.

ls_header-guid = gv_srvo_guid.
ls_header-description = txt.
APPEND ls_header TO lt_header.
CLEAR: ls_changed_input.

ls_changed_input-ref_guid = gv_srvo_guid.
ls_changed_input-objectname = 'ORDERADM_H'.
APPEND 'DESCRIPTION' TO ls_changed_input-field_names.
APPEND ls_changed_input TO lt_changed_input.

CALL FUNCTION 'CRM_ORDER_MAINTAIN'
  CHANGING
    ct_orderadm_h     = lt_header
    ct_input_fields   = lt_changed_input
  EXCEPTIONS
    error_occurred    = 1
    document_locked   = 2
    no_change_allowed = 3
    no_authority      = 4.

WRITE: / 'order maintain successful?', sy-subrc.

APPEND gv_srvo_guid TO lt_to_save.

"PERFORM populate_update_table.

CALL FUNCTION 'CRM_ORDER_SAVE'
  EXPORTING
    it_objects_to_save   = lt_to_save
    iv_update_task_local = abap_true
  IMPORTING
    et_saved_objects     = lt_saved
    et_exception         = lt_exception
    et_objects_not_saved = lt_not_to_save
  EXCEPTIONS
    document_not_saved   = 1.

WRITE: / sy-subrc.

COMMIT WORK AND WAIT.

PERFORM check_save.

FORM check_save.
  SELECT SINGLE * INTO @DATA(ls) FROM crmd_orderadm_h WHERE guid = @gv_srvo_guid.
  ASSERT sy-subrc = 0.
  WRITE: / 'new description:' , ls-description.

ENDFORM.

FORM populate_update_table.
  DATA: lt_insert TYPE CRMT_ORDERADM_H_DU_TAB,
        lt_update TYPE CRMT_ORDERADM_H_DU_TAB,
        lt_delete TYPE CRMT_ORDERADM_H_DU_TAB.

   call function 'CRM_ORDER_UPDATE_TABLES_DETERM'
      exporting
        iv_object_name            = 'ORDERADM_H'
        iv_field_name_key         = 'GUID'
        it_guids_to_process       = lt_to_save
        iv_header_to_save         = gv_srvo_guid
      importing
        et_records_to_insert      = lt_insert
        et_records_to_update      = lt_update
        et_records_to_delete      = lt_delete.

ENDFORM.