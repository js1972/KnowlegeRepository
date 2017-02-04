@AbapCatalog.sqlViewName: 'zreqenddate'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'end date'
define view Z_I_end_Date as select from scapptseg
inner join crmd_link as _link 
on appl_guid = _link.guid_set and _link.objtype_hi = '05' 
and _link.objtype_set = '30' 
{
   key scapptseg.appl_guid,
   key _link.guid_hi as order_guid,
   scapptseg.tst_from as requested_end
   
} where scapptseg.appt_type = 'SRV_CUST_END'