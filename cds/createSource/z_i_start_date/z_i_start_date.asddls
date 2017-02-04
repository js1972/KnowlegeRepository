@AbapCatalog.sqlViewName: 'zstartdate'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'start date'
define view Z_I_Start_Date as select from scapptseg
inner join crmd_link as _link 
on appl_guid = _link.guid_set and _link.objtype_hi = '05' 
and _link.objtype_set = '30' 
{
   key scapptseg.appl_guid,
   key _link.guid_hi as order_guid,
   scapptseg.tst_from as requested_start
   
} where scapptseg.appt_type = 'SRV_CUST_BEG'