*&---------------------------------------------------------------------*
*& Report ZONEORDER_MODIFY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZONEORDER_MODIFY.

PARAMETERS: newda TYPE crmt_opport_h_com-expect_end OBLIGATORY DEFAULT '20170101'.

CONSTANTS: gv_guid TYPE crmt_object_guid VALUE 'FA163E8EAB031ED682EF2F89113485EF'.
DATA: lt_opport_h    TYPE crmt_opport_h_comt,
      ls_opport_h    LIKE LINE OF lt_opport_h,
      lt_change      TYPE crmt_input_field_tab,
      ls_change      LIKE LINE OF lt_change,
      lt_saved       TYPE crmt_return_objects,
      lt_exception   TYPE crmt_exception_t,
      lt_to_save     TYPE crmt_object_guid_tab,
      lt_not_to_save TYPE crmt_object_guid_tab.

ls_opport_h-ref_guid = gv_guid.
ls_opport_h-expect_end = newda.

ls_change = VALUE #( ref_guid = gv_guid ref_kind = 'A' objectname = 'OPPORT_H' ).
APPEND 'EXPECT_END' TO ls_change-field_names.
APPEND ls_change TO lt_change.
APPEND ls_opport_h TO lt_opport_h.
CALL FUNCTION 'CRM_ORDER_MAINTAIN'
  EXPORTING
    it_opport_h       = lt_opport_h
  CHANGING
    ct_input_fields   = lt_change
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