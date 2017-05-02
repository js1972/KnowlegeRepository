*&---------------------------------------------------------------------*
*& Report CRMS4_FILL_ITEM_SHADOW_TABLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT CRMS4_FILL_ITEM_SHADOW_TABLE.

data: lt_shadow TYPE TABLE OF crms4d_btx_i,
      ls_shadow LIKE LINE OF lt_shadow.
data: lv_object_id TYPE crmd_orderadm_h-object_id VALUE '8000000072'.
datA:ls_head TYPE crmd_orderadm_h.

select single * into ls_head FROM crmd_orderadm_h where object_id = lv_object_id.
IF sy-subrc <> 0 OR ls_head-process_type <> 'SRVO'.
   WRITE:/ 'service Order does not exist', lv_object_id.
   RETURN.
ENDIF.

select * INTO TABLE @data(lt_item) FROM crmd_orderadm_i
   where header = @ls_head-guid.

IF sy-subrc <> 0.
   WRITE:/ ' This service order does not have line item'.
   RETURN.
ENDIF.

LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<item>).
   ls_shadow-header_guid = ls_head-guid.
   ls_shadow-item_guid = <item>-guid.
   ls_shadow-object_type = <item>-object_type.
   APPEND ls_shadow TO lt_shadow.
ENDLOOP.

INSERT crms4d_btx_i FROM TABLE lt_shadow.

WRITE: / 'shadow table inserted ok'.