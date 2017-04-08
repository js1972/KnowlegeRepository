When the given header extension is read via CRM_ORDER_READ, take OPPORT_H for example:
```abap
DATA: lt_header_guid TYPE  crmt_object_guid_tab,
      lv_guid        TYPE crmt_object_guid,
      lv_object_id   TYPE CRMT_OBJECT_ID_DB value '21',
      lt_oppt        TYPE CRMT_OPPORT_H_WRKT,
      lt_partner     TYPE crmt_partner_external_wrkt.

START-OF-SELECTION.
CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
   EXPORTING
      input = lv_object_id
   IMPORTING
      output = lv_object_id.

  SELECT SINGLE guid INTO lv_guid FROM crmd_orderadm_h
      WHERE object_id = lv_object_id AND process_type = 'CXOP'.

  CHECK sy-subrc = 0.

  APPEND lv_guid TO lt_header_guid.

  CALL FUNCTION 'CRM_ORDER_READ'
    EXPORTING
      it_header_guid = lt_header_guid
    IMPORTING
*      et_partner     = lt_partner
      et_opport_h   = lt_oppt.
```
The calling hierarchy could be found from below:
![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard1-40.png)
Every header extension has one corresponding read function module acting as entry point for read which will be called by CRM_ORDER_READ_OW with naming convention CRM_<Object name>_READ_OB. In OB ( object buffer ) read function module, the corresponding object buffer is evaluated. If object buffer is not hit for current read, another DB read function module ( CRM_<Object name>_READ_DB is called. Within this DB read function module, another internal table which represents Database buffer is evaluated again. The real read access on database table is only performed when this second fold buffer check fails.
Take OPPORT_H read for example, I draw a picture to demonstrate this two-fold buffer evaluation logic:
![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard1-41.png)
In the runtime, OPPORT_H object buffer could be monitored in the context of CRM_OPPORT_H_READ_OB,
![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard2-24.png)
and database buffer in CRM_OPPORT_H_READ_DB accordingly.
![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard3-22.png)
The object buffer is declared in function group CRM_OPPORT_H_OB:
![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard4-16.png)
and database buffer is defined in function group CRM_OPPORT_H_DB:
![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard5-9.png)