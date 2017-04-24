1. business transaction category决定了某个business transaction最多允许的structure, 而具体的由customizing决定。error fix之后error message必须删除。
2. include CRM_OBJECTTYPES_CON defines constant value for object type name,
for example gc_objtype-orderadm_h type crmt_object_type value '05'.
3. Input function module: CRM_OBJECT_NAMES_DETERMINE, input is object name. And CRM_ORDER_UPDATE_TABLES_DETERM.
4. CALL FUNCTION 'CRM_ORDERADM_H_OBJ_ALLOWED_OW'
    EXPORTING
      iv_ref_guid            = iv_header_guid
    IMPORTING
      et_allowed_objects     = gt_allowed_objects
5. CRM_ORDER_INDEX_SAVE
--CRM_ORDER_PROCESS_MODE_GET_OW
--CRM_ORDERADM_H_OBJ_ALLOWED_OW
--CRM_ORDERADM_H_READ_OB - compare change
--CRM_ORDERADM_H_READ_DB
--if really change-CRM_ORDER_INDEX_SELECT_DB
--CRM_ORDER_INDEX_UPDATE_DU
# Short cut
1. 9ZONEORDER_MODIFY

# Useful FM

1. CRM_OBJECT_NAMES_DETERMINE
2. CRM_ORDERADM_H_ON_DATABASE_OW - works under new DB in SE37.
3. item's read logic: if a specific item guid is specified, first CRMD_ORDERADM_I is read against guid = 
lv_item_guid, once one entry is found, the header guid is available in <entry>-header. Then all items are fetched 
by this header guid.
4. CRM_ORDER_OBJECT_ASSI_SEL_CB - input is transaction type

# table
1. item object type: CRMC_SUBOB_CAT_I
2. CRMC_BT_BTI_ASSI - from Oliver
3. 

# BUS type
1. BUS2000140 - CRM Service Product Item

# Question

SRVO can have SRV_REQ_H? 5700000380 in AG3

# 2017-04-24
1. Even I didn't put item buffer by calling PUT_OB explicitly, the buffer is inserted automatically.Where?

2. it seems no convertor class is needed for item component, since it is already done in FM CRM_ORDERADM_H_READ_OB, subroutine ORDERADM_H_READ_WITH_GUID_LIST, line 155:
```abap
INSERT ls_orderadm_h_wrk INTO TABLE gt_orderadm_h_wrk.
```

3. fill one entry in table ZCRMC_OBJ_ASSI_I. Sub cate:BUS2000140, Name: PRODUCT_I. 