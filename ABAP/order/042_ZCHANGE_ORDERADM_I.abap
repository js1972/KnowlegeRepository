REPORT ZCHANGE_ORDERADM_I.


PARAMETERS: txt TYPE crmd_orderadm_h-description OBLIGATORY DEFAULT 'txt',
             item TYPE crmd_orderadm_i-number_int OBLIGATORY DEFAULT 20,
             srvo_id TYPE crmd_orderadm_h-object_id OBLIGATORY DEFAULT '5700000242'.

DATA: lv_srvo_guid       TYPE crmd_orderadm_h-guid,
      lt_to_save         TYPE crmt_object_guid_tab,
      lt_saved           TYPE crmt_return_objects,
      lt_changed_fields  TYPE crmt_input_field_tab,
      ls_changed_fields  LIKE LINE OF lt_changed_fields,
      lt_orderadm_i      TYPE CRMT_ORDERADM_I_COMT,
      ls_db              TYPE crmd_orderadm_i,
      ls_orderadm_i      LIKE LINE OF lt_orderadm_i.

START-OF-SELECTION.

SELECT SINGLE * INTO @DATA(ls_header) FROM crmd_orderadm_h WHERE object_id = @srvo_id.

CHECK sy-subrc = 0.

lv_srvo_guid = ls_header-guid.

SELECT SINGLE * INTO ls_db FROM crmd_orderadm_i WHERE header = lv_srvo_guid AND
  number_int = item.
IF sy-subrc <> 0.
   WRITE:/ 'Cannot find line item for item id:', item.
   RETURN.
ENDIF.

MOVE-CORRESPONDING ls_db TO ls_orderadm_i.

ls_changed_fields-ref_guid = ls_db-guid.
ls_changed_fields-objectname = 'ORDERADM_I'.
APPEND 'DESCRIPTION' TO ls_changed_fields-field_names.
APPEND ls_changed_fields TO lt_changed_fields.

ls_orderadm_i-description = txt.
APPEND ls_orderadm_i TO lt_orderadm_i.

CALL FUNCTION 'CRM_ORDER_MAINTAIN'
  CHANGING
    ct_input_fields   = lt_changed_fields
    ct_orderadm_i     = lt_orderadm_i
  EXCEPTIONS
    error_occurred    = 1
    document_locked   = 2
    no_change_allowed = 3
    no_authority      = 4.

IF sy-subrc <> 0.
  WRITE: / 'error during quantity change'.
  RETURN.
ENDIF.

"APPEND ls_orderadm_i-guid TO lt_to_save.
APPEND lv_srvo_guid TO lt_to_save.

CALL FUNCTION 'CRM_ORDER_SAVE'
  EXPORTING
    it_objects_to_save   = lt_to_save
    iv_update_task_local = abap_true
  IMPORTING
    et_saved_objects     = lt_saved
  EXCEPTIONS
    document_not_saved   = 1.

IF sy-subrc <> 0.
  WRITE:/ 'Save failed'.
  RETURN.
ENDIF.

COMMIT WORK AND WAIT.

SELECT SINGLE * INTO @data(newitem) FROM crmd_orderadm_i WHERE header = @lv_srvo_guid AND
  number_int = @item.
WRITE:/ 'New description' COLOR COL_NEGATIVE, newitem-description COLOR COL_GROUP.