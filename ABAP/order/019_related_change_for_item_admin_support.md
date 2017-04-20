# 2017-04-20 Thursday

CRM_ORDER_READ_OW line 1303 calls CRM_ORDERADM_I_READ_OB

inside CRM_ORDERADM_I_READ_OB, no changes. call subroutine read_by_header

in READ_BY_HEADER, line 151, calls CRM_ORDERADM_I_READ_DB.

in FM CRM_ORDERADM_I_READ_DB, line 167, calls CRM_ORDERADM_I_SELECT_M_DB

