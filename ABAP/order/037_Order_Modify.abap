*&---------------------------------------------------------------------*
*& Report ZONEORDER_MODIFY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zoneorder_modify.

PARAMETERS: newda TYPE crmt_opport_h_com-expect_end OBLIGATORY DEFAULT '20170101',
            txt   TYPE crmd_orderadm_h-description OBLIGATORY DEFAULT 'txt'.

CONSTANTS: gv_guid TYPE crmt_object_guid VALUE '00163EA71FFC1ED19D98873599E85BAB'. "opportunity
DATA: lt_opport_h      TYPE crmt_opport_h_comt,
      lt_header        TYPE crmt_orderadm_h_comt,
      ls_header        LIKE LINE OF lt_header,
      ls_opport_h      LIKE LINE OF lt_opport_h,
      lt_saved         TYPE crmt_return_objects,
      lt_exception     TYPE crmt_exception_t,
      lt_changed_input TYPE crmt_input_field_tab,
      ls_changed_input LIKE LINE OF lt_changed_input,
      lt_to_save       TYPE crmt_object_guid_tab,
      lt_not_to_save   TYPE crmt_object_guid_tab.

ls_opport_h-ref_guid = gv_guid.
ls_opport_h-expect_end = newda.

ls_changed_input = VALUE #( ref_guid = gv_guid ref_kind = 'A' objectname = 'OPPORT_H' ).
APPEND 'EXPECT_END' TO ls_changed_input-field_names.
INSERT ls_changed_input INTO TABLE lt_changed_input.
APPEND ls_opport_h TO lt_opport_h.

ls_header-guid = gv_guid.
ls_header-description = txt.
APPEND ls_header TO lt_header.
CLEAR: ls_changed_input.

ls_changed_input-ref_guid = gv_guid.
ls_changed_input-objectname = 'ORDERADM_H'.
APPEND 'DESCRIPTION' TO ls_changed_input-field_names.
APPEND ls_changed_input TO lt_changed_input.

CALL FUNCTION 'CRM_ORDER_MAINTAIN'
  EXPORTING
    it_opport_h       = lt_opport_h
  CHANGING
    ct_orderadm_h     = lt_header
    ct_input_fields   = lt_changed_input
  EXCEPTIONS
    error_occurred    = 1
    document_locked   = 2
    no_change_allowed = 3
    no_authority      = 4.

APPEND gv_guid TO lt_to_save.
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
  SELECT SINGLE * INTO @DATA(ls) FROM crmd_orderadm_h WHERE guid = @gv_guid.
  ASSERT sy-subrc = 0.
  WRITE: / 'new description:' , ls-description.

  SELECT SINGLE * INTO @DATA(opp) FROM crmd_opport_h WHERE guid = @gv_guid.
  ASSERT sy-subrc = 0.
  WRITE: / 'new date:', opp-expect_end.
ENDFORM.