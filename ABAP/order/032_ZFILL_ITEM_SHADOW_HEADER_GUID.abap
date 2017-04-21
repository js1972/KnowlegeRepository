*&---------------------------------------------------------------------*
*& Report ZFILL_ITEM_SHADOW_HEADER_GUID
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFILL_ITEM_SHADOW_HEADER_GUID.

data: lt_item_shadow type TABLE OF zcrms4d_btx_i,
      lt_item type TABLE OF crmd_orderadm_i.

select * into TABLE lt_item_shadow FROM zcrms4d_btx_i where header_guid = space.

check sy-subrc = 0.

select * into TABLE lt_item FROM crmd_orderadm_i for ALL ENTRIES IN lt_item_shadow
   where guid = lt_item_shadow-item_guid.

loop at lt_item_shadow ASSIGNING FIELD-SYMBOL(<shadow>).
   read TABLE lt_item ASSIGNING FIELD-SYMBOL(<item>) with key guid = <shadow>-item_guid.
   IF sy-subrc = 0.
      <shadow>-header_guid = <item>-header.
   ENDIF.
ENDLOOP.

CHECK lt_item_shadow IS NOT INITIAL.

UPDATE zcrms4d_btx_i FROM TABLE lt_item_shadow.