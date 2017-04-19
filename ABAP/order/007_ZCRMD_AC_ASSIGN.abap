*&---------------------------------------------------------------------*
*& Report ZCRMD_AC_ASSIGN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcrmd_ac_assign.

DATA: lt_assign  TYPE TABLE OF crmd_ac_assign,
      lt_order_h TYPE TABLE OF crmd_orderadm_h,
      lt_link TYPE TABLE OF crmd_link.

SELECT * INTO TABLE lt_assign FROM crmd_ac_assign where ac_assignment <> space.
CHECK lt_assign IS NOT INITIAL.
SELECT * INTO TABLE lt_link FROM crmd_link FOR ALL ENTRIES IN lt_assign
   where guid_Set = lt_assign-guid.

check lt_link is not INITIAL.
SELECT * INTO TABLE lt_order_h FROM crmd_orderadm_h FOR ALL ENTRIES IN lt_link
   WHERE guid = lt_link-guid_hi.

DATA: lt_type TYPE TABLE OF crmc_proc_type_t.

select * INTO TABLE lt_Type FROM crmc_proc_type_t FOR ALL ENTRIES IN lt_order_h
   where process_type = lt_order_h-process_type and LANGU = sy-langu.

LOOP AT lt_order_h ASSIGNING FIELD-SYMBOL(<order>).
   READ TABLE lt_type INTO DATA(type_description) WITH KEY process_type = <order>-process_type.
   WRITE: / 'Order id:' , <ordeR>-object_id, 'Description:' , <order>-description, ' type:' , <order>-process_type,
   'Type description:', type_description-p_description.

ENDLOOP.