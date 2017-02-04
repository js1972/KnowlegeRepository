@AbapCatalog.sqlViewName: 'ZI_PART_BUT'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'try to consume table function'
define view Z_I_PARTNER_BUT000 
 with parameters @Environment.systemField: #CLIENT 
                  clnt:abap.clnt, 
                  bp_guidset: CRMT_PARTNER_NO,
                  bp_no:CRMT_PARTNER_NO
  as select from ztf_crmd_partner_but000( clnt: :clnt, bp_guidset: :bp_guidset,  bp_no: :bp_no)  
  {
    key ztf_crmd_partner_but000.bp_guid,
    ztf_crmd_partner_but000.name,
    ztf_crmd_partner_but000.title
  }