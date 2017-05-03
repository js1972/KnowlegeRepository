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

4. item to be read: FA163EE56C3A1EE789BA15E33B2218B6 in shadow table.

SVPR: Service Product Item

5. CRM_EVENT_SET_EXETIME_MULTI_OW, line 54
6. event: CRM_EVENT_FILTER_PROC_TYPE_OW
7. CRM_OPPORT_H_SAVE_EC->CRM_ORDERADM_H_UPDATE_DU->CRM_ORDER_WRITE_DOCUMENT->CRM_ORDER_INDEX_UPDATE_DU
8. next task: CRM_CUMULATED_I_SAVE_EC, CRM_CUMULAT_H_SAVE_EC
9. EC called via CRM_EVENT_SET_EXETIME_MULTI_OW
10. marvellous绝妙的; 不可思议的; 惊奇的; 极好的

# 2017-04-25
1. search service order header against a product. add header information in item table. 

CRMD_ORDERADM_H is updated by CRM_ORDERADM_H_UPDATE_DU.
target today: CRM_OPPORT_H_SAVE_EC

should be changed to PUT_TO_DB buffer

2. DLV_SYSTC table contains the modification of component.
ZCRM_SRVO_H_SAVE_EC
SRVO_HEAD_SAVE
ZSRVO_H

CRM_EVENT_FILTER_PROC_TYPE_OW

transaction type and allowed object type.

SRVO->BUS2000116 - ZSRVO_H - table: CRMC_OBJECT_ASSI
FM CRM_ORDER_OBJECT_ASSI_SEL_CB, tcode 
entry point for event callback execution: CRM_EVENT_SET_EXETIME_MULTI_OW, line 108

# 2017-04-26
1. no fields in signature of CRM_ORDER_MAINTAIN so it means I could not directly make changes on CUMULAT_H simply via CRM_ORDER_MAIN.
When I change quantity in Service order line item, SCHEDLIN is changed and change field name: QUANTITY. 
2. today do this: CRM_CUMULAT_H_SAVE_EC
CRM_EVENT_PUBLISH_OW
I can still get cumulat_h change based on determine FM. 
CRM_OBJECT_NAMES_DETERMINE
CRM_CUMULAT_H_CHANGE_OW

why CUMULAT_H is changed when quantity in line item is changed? 

CRM_CUMULAT_H_UPD_COLLECT_EC
CRM_CUMULAT_H_UPD_BUFFER_OB
CRM_CUMULAT_H_UPD_BUFFER_EC

# 2017-04-27
1. CRM_ORDER_GET_OBJECTS_TO_SAVE check whether header object is changed.
2. ZCRM_SRVO_H_SAVE_EC 

# 2017-04-28
1. CRM_1O_TOOLS
CRM_ORDER_NEW_MODEL 
USE_1ORDER_NEW_MODEL
Via debugging Jerry confirmes that when you click object id hyperlink for the first time, the object buffer is initial.

# 2017-05-02
1. should take care object type initial case in creation.