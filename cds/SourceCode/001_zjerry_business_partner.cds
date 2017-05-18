@AbapCatalog.sqlViewName: 'ZJERRYBPAVW' 
define view zjerry_business_partner as 
  select from snwd_bpa 
         association [0..*] to zjerry_sales_order as sales_order 
           on snwd_bpa.node_key = sales_order.buyer_guid 
  {
   key snwd_bpa.bp_id,
   snwd_bpa.node_key,
   snwd_bpa.bp_role,
   snwd_bpa.changed_at,
   snwd_bpa.client,
   // Association sales_order can influence the cardinality of the resulting set
   // sales_order.lifecycle_status
   @ObjectModel.association.type: #TO_COMPOSITION_CHILD
   sales_order
   }