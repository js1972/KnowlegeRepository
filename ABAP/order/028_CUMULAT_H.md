DB buffer not hit: go_cumulat_h_db_wrk

then CRM_CUMULAT_H_SELECT_S_DB

check result of this FM. If no result, still insert a fake data in DB buffer:
ls_cumulat_h_db_wrk-client     = sy-mandt.
ls_cumulat_h_db_wrk-guid       = iv_guid.
ls_cumulat_h_db_wrk-norec_flag = abap_true.
INSERT ls_cumulat_h_db_wrk INTO TABLE go_cumulat_h_db_wrk.

if DB buffer is hit and norec_flag EQ abap_true, data not in DB.

CRM_CUMULAT_H_READ_OB
--line 21 perform read_cumulat_h_single
----line 70:  READ TABLE gt_cumulat_h_wrk INTO ls_cumulat_h WITH TABLE KEY guid = iv_header_guid.

it is executed in subroutine read_cumulat_h in ZCRM_ORDER_READ_OW, line 1631. 

within the subroutine, ZCRM_CUMULAT_H_READ_OB is called in line 21.
inside this FM READ_OB, subroutine read_cumulat_h_single is called.

In my context, at this time object buffer gt_cumulat_h_wrk should already be available. 