*&---------------------------------------------------------------------*
*& Report ZCHANGE_CUMULAT_H
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zchange_cumulat_h.

PARAMETERS: quantity TYPE int4 OBLIGATORY DEFAULT 1,
             txt TYPE crmd_orderadm_h-description OBLIGATORY DEFAULT 'txt',
             item TYPE crmd_orderadm_i-number_int OBLIGATORY DEFAULT 20,
             srvo_id TYPE crmd_orderadm_h-object_id OBLIGATORY DEFAULT '5700000242'.
CONSTANTS: cv_sales_item TYPE crmt_subobject_category_db VALUE 'BUS2000131'.
DATA: lv_srvo_guid       TYPE crmd_orderadm_h-guid,
      lt_to_save         TYPE crmt_object_guid_tab,
      lt_order        TYPE crmt_orderadm_h_comt,
      ls_order        LIKE LINE OF lt_order,
      lt_saved           TYPE crmt_return_objects,
      lv_schedule_guid   TYPE crmt_object_guid,
      lt_schedule_line   TYPE crmt_schedlin_i_comt,
      lt_schedule_detail TYPE crmt_schedlin_extdt,
      ls_schedule_detail LIKE LINE OF lt_schedule_detail,
      ls_schedule_line   LIKE LINE OF lt_schedule_line,
      lt_changed_fields  TYPE crmt_input_field_tab,
      ls_changed_fields  LIKE LINE OF lt_changed_fields,
      lt_orderadm_i      TYPE TABLE OF crmd_orderadm_i.

START-OF-SELECTION.

SELECT SINGLE * INTO @DATA(ls_header) FROM crmd_orderadm_h WHERE object_id = @srvo_id.

CHECK sy-subrc = 0.

SELECT SINGLE * INTO @DATA(ls_cum_h) FROM crmd_cumulat_h WHERE guid = @ls_header-guid.

CHECK sy-subrc = 0.
lv_srvo_guid = ls_header-guid.

WRITE:/ 'Old gross weight', ls_cum_h-gross_weight COLOR COL_GROUP.
PERFORM print_gross_weight_detail.

SELECT * INTO TABLE lt_orderadm_i FROM crmd_orderadm_i WHERE header = lv_srvo_guid AND object_type = cv_sales_item.
CHECK sy-subrc = 0.

" Jerry 2017-04-26 4:57PM - for test data preparation, you should only have one item as sales item
READ TABLE lt_orderadm_i ASSIGNING FIELD-SYMBOL(<sales_item>) with key number_int = item.
IF sy-subrc <> 0.
   WRITE:/ 'Cannot find line item for item id:', item.
   RETURN.
ENDIF.

SELECT SINGLE guid INTO lv_schedule_guid FROM crmd_schedlin WHERE item_guid = <sales_item>-guid.
CHECK lv_schedule_guid IS NOT INITIAL.

ls_schedule_line-ref_guid = <sales_item>-guid.
ls_schedule_detail-guid = ls_schedule_detail-logical_key = lv_schedule_guid.
ls_schedule_detail-item_guid = <sales_item>-guid.
ls_schedule_detail-mode = 'B'.
ls_schedule_detail-quantity = quantity.
APPEND ls_schedule_detail TO ls_schedule_line-schedlines.
APPEND ls_schedule_line TO lt_schedule_line.

ls_changed_fields-ref_guid = <sales_item>-guid.
ls_changed_fields-ref_kind = 'B'.
ls_changed_fields-objectname = 'SCHEDLIN'.
ls_changed_fields-logical_key = lv_schedule_guid.
APPEND 'QUANTITY' TO ls_changed_fields-field_names.
APPEND ls_changed_fields TO lt_changed_fields.

CLEAR: ls_changed_fields.

ls_changed_fields-ref_guid = lv_srvo_guid.
ls_changed_fields-objectname = 'ORDERADM_H'.
APPEND 'DESCRIPTION' TO ls_changed_fields-field_names.
INSERT ls_changed_fields INTO TABLE lt_changed_fields.

ls_order-guid = lv_srvo_guid.
ls_order-description = txt.
APPEND ls_order TO lt_order.

CALL FUNCTION 'CRM_ORDER_MAINTAIN'
  EXPORTING
    it_schedlin_i     = lt_schedule_line
  CHANGING
    ct_input_fields   = lt_changed_fields
    ct_orderadm_h     = lt_order
  EXCEPTIONS
    error_occurred    = 1
    document_locked   = 2
    no_change_allowed = 3
    no_authority      = 4.

IF sy-subrc <> 0.
  WRITE: / 'error during quantity change'.
  RETURN.
ENDIF.

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

SELECT SINGLE * INTO ls_cum_h FROM crmd_cumulat_h WHERE guid = ls_header-guid.

CHECK sy-subrc = 0.
WRITE: / 'New Gross weight after change:' COLOR COL_NEGATIVE, ls_cum_h-gross_weight.
PERFORM print_gross_weight_detail.

FORM print_gross_weight_detail.
  DATA: lt_product TYPE TABLE OF crmd_product_i,
        lt_item TYPE TABLE OF crmd_orderadm_i.

  SELECT * INTO TABLE lt_item FROM crmd_orderadm_i where header = lv_srvo_guid.
  CHECK lt_item IS NOT INITIAL.
  SELECT * INTO TABLE lt_product FROM crmd_product_i FOR ALL ENTRIES IN lt_item
     WHERE guid = lt_item-guid.

  LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<item>).
     WRITE: / 'Item id:' COLOR COL_POSITIVE, <item>-number_int COLOR COL_HEADING.
     READ TABLE lt_product ASSIGNING FIELD-SYMBOL(<prod>) WITH KEY guid = <item>-guid.
     CHECK sy-subrc = 0.
     WRITE: / 'Item Gross Weight:' COLOR COL_POSITIVE, <prod>-gross_weight COLOR COL_GROUP.
  ENDLOOP.
ENDFORM.