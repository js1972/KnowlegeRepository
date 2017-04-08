# Logic of CHANGE_OW function module in One Order

Use the naming convention CRM*CHANGE_OW to search in SE37 and there are totally 92 function modules found in my system.

![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard1-45.png)

Still use the same scenario ( change Closing Date in Opportunity header ) to research how this CHANGE_OW function works:

![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard2-27.png)

Use the following report to trigger the corresponding CHANGE_OW function module for Opportunity header, CRM_OPPORT_H_CHANGE_OW.

```abap
REPORT zoneorder_modify.
CONSTANTS: gv_guid TYPE crmt_object_guid VALUE '6C0B84B759DF1ED6BDF05763B3DC8841'.

DATA: lt_opport_h TYPE crmt_opport_h_comt,
      ls_opport_h LIKE LINE OF lt_opport_h,
      lt_change   TYPE crmt_input_field_tab,
      ls_change   LIKE LINE OF lt_change.

ls_opport_h-ref_guid = gv_guid.
ls_opport_h-expect_end = '20170216'.

ls_change = VALUE #( ref_guid = gv_guid ref_kind = 'A' objectname = 'OPPORT_H' ).
APPEND 'EXPECT_END' TO ls_change-field_names.
APPEND ls_change TO lt_change.
APPEND ls_opport_h TO lt_opport_h.
CALL FUNCTION 'CRM_ORDER_MAINTAIN'
  EXPORTING
    it_opport_h       = lt_opport_h
  CHANGING
    ct_input_fields   = lt_change
  EXCEPTIONS
    error_occurred    = 1
    document_locked   = 2
    no_change_allowed = 3
    no_authority      = 4.

WRITE: / sy-subrc.
```

Execute the report under transaction code SAT and you can easily find this function module consists of five major steps:
![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard4-19.png)

## 1.CRM_OPPORT_H_READ_OB

The logic is already explained in this [url](https://github.com/i042416/KnowlegeRepository/blob/master/ABAP/order/004_Object_buffer_read.md).
The input for this object buffer read function module only contains opportunity guid and latest closing date specified by consumer:

![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard1-46.png)

The data read from CRM_OPPORT_H_READ_OB:

![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard2-28.png)

## 2. CRM_OPPORT_H_FILL_OW

This function module fills the latest order data specified by consumer into object work area. Details could be found from this [url]().

## 3.CRM_OPPORT_H_CHECK_OW
Please kindly notice that there are also check logic performed in function module CRM_OPPORT_H_FILL_OW, Let’s recall what kinds of checks are done there:
### a. CRM_ORDER_GENERAL_CHECKS_FC
This check could be switched off by function module CRM_ORDER_SET_ACTIVE_OW.
A customer exit if_ex_crm_order_fieldcheck and a new BAdI definition crm_order_fieldcheck_new is allowed for customer to implement their own check logic and called within this check function module.
### b. CRM_FIELDCHECK_CALL
This FM will call dedicated check function module for a given field registered in system table CRMC_FIELDCHECK:
![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard1-47.png)

And back to CRM_OPPORT_H_CHECK_OW in this blog, the consistency of each field in Opportunity header are checked there.

![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard2-29.png)

## 4. CRM_OPPORT_H_PUT_OB
Once the object work area passes validation successfully, it will be put to Opportunity header object buffer via function module CRM_OPPORT_H_PUT_OB.
![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard3-25.png)
![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard4-20.png)

## 5.CRM_OPPORT_H_PUBLISH_OW
This function module raises event via generic function module CRM_EVENT_PUBLISH_OW:

![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard5-11.png)
In this example why CRM_OPPORT_H_SET_PRICE_DATE_EC is called?
![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard6-8.png)

Check via tcode CRMV_EVENT,
![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard7-6.png)
And the callback is registered here:
![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard8-5.png)