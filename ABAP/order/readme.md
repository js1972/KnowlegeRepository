1. business transaction category决定了某个business transaction最多允许的structure, 而具体的由customizing决定。error fix之后error message必须删除。
2. include CRM_OBJECTTYPES_CON defines constant value for object type name,
for example gc_objtype-orderadm_h type crmt_object_type value '05'.
3. Input function module: CRM_OBJECT_NAMES_DETERMINE, input is object name. And CRM_ORDER_UPDATE_TABLES_DETERM.
4. CALL FUNCTION 'CRM_ORDERADM_H_OBJ_ALLOWED_OW'
    EXPORTING
      iv_ref_guid            = iv_header_guid
    IMPORTING
      et_allowed_objects     = gt_allowed_objects

# Short cut
1. 9ZONEORDER_MODIFY