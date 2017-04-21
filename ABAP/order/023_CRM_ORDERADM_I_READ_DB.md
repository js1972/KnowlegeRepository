1. check if item is allowed: CRM_ORDERADM_H_OBJ_ALLOWED_OW - gc_object_name-orderadm_i

2. check whether header exists in DB via ZCRM_ORDERADM_H_ON_DATABASE_OW. if not, throw exception

3. check in DB buffer go_orderadm_i_db_wrk. If ls_orderadm_i_db_wrk-norec_flag = false, put this record to exporting parameter and return.

4. Delete those items that were already found in the buffer (the rest will be read later on from the DB)

5. perform real DB read: CALL FUNCTION 'ZCRM_ORDERADM_I_SELECT_M_DB'


