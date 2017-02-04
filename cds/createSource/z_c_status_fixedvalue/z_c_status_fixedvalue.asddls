@AbapCatalog.sqlViewName: 'zstatusfixed'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'fixed value'
define view Z_C_Status_Fixedvalue as select from zstatus_fixedval {
   @EndUserText.label: 'status key for fixed value'
   key zstatus_fixedval.status_code,
   @EndUserText.label: 'status description for fixed value'
   zstatus_fixedval.status_text
}