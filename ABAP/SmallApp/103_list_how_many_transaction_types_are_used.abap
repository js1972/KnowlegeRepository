*&---------------------------------------------------------------------*
*& Report  ZUSED_PROCESS_TYPES
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZUSED_PROCESS_TYPES.

Data: lt_proc_type type STANDARD TABLE OF crmd_orderadm_h-process_type,
      lv_process_type type crmd_orderadm_h-process_type,
      lv_rows type i.


select process_type count( * ) as rows  from crmd_orderadm_h into (lv_process_type, lv_rows)
  group by process_type
  order by rows DESCENDING.
  write: / lv_process_type, lv_rows.
endselect.