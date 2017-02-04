@AbapCatalog.sqlViewName: 'zstatvaluhep'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'value help for status -Jerry'
define view Z_C_Status_Valuehelp as select from zstatus_valuehel {
   @EndUserText.label: 'status key for help'
   key zstatus_valuehel.status_key,
   @EndUserText.label: 'status description for help'
   zstatus_valuehel.status_text
}