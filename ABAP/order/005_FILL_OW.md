# Logic of FILL_OW function module in One Order

There are totally 60 function modules in One order with naming convention CRM_<Object>_FILL_OW:

![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard1-42.png)


They are NOT used in read scenario but in modify scenario. For example once you change the Closing Date of a given opportunity in WebUI ( from 2017-02-15 to 2017-02-16 )

![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard2-25.png)

The function module for Opportunity header extension, CRM_ORDERADM_H_FILL_OW, is called with the following callstack:

![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard3-24.png)

As its name FILL_OW indicates, it is responsible to FILL the latest input by consumer into so called object work area( OW ) for later use.
In order to make the research life easier I write the following report to trigger this FILL_OW function module call from backend:

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
It’s very clear now the logic of this FILL_OW consists of four main parts:

![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard4-18.png)

## 1. field check done in FM CRM_OPPORT_H_FIELDCHECK_FC

This check function module further calls two function modules:

### a. CRM_ORDER_GENERAL_CHECKS_FC

This check could be switched off by function module CRM_ORDER_SET_ACTIVE_OW.
A customer exit if_ex_crm_order_fieldcheck and a new BAdI definition crm_order_fieldcheck_new is allowed for customer to implement their own check logic and called within this check function module.

### b. CRM_FIELDCHECK_CALL

This FM will call dedicated check function module for a given field registered in system table CRMC_FIELDCHECK:

![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard5-10.png)

## 2.CRM_OPPORT_H_READ_OB

The logic of this FM is already explained in blog: Buffer logic in One Order header extension Read.

## 3. CRM_ORDER_INPUT_DATA

This FM is responsible to move the latest value entered by consumer ( is_opport_h_com in line 65 ) to object work area ( postfix WRK in variable ls_opport_h_wrk in line 68 ). You can observe in the debugger that before this FM is executed, object work area still contains the old value 2017-02-15 read from FM CRM_OPPORT_H_READ_OB in step 2.

![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard6-7.png)

Inside this FM there is a check to avoid the field is being changed unnecessarily ( specified new value = old value ) or by mistake ( the field validation fails ).
This is a screenshot how ls_opport_h_wrk looks like after this third step is executed:

![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard8-4.png)

## 4.CRM_OPPORT_H_MERGE_OW

Opportunity header extension specific fields are filled in this FM.
The following fields are populated in this FM with related business logic.
* probability
* phase_since
* assistant_phase
* exp_weighted_revenue
* salescycle
Once all these four steps are done successfully, CRM_OPPORT_H_FILL_OW has now generated a consistent object work area and stored in ls_opport_h_wrk.

![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard1-44.png)

This object work area will be put to object buffer for later save usage via FM CRM_OPPORT_H_PUT_OB.

![](https://blogs.sap.com/wp-content/uploads/2017/03/clipboard2-26.png)