@AbapCatalog.sqlViewName: 'ZJERRYSO' 
define view zjerry_sales_order as 
  select from snwd_so 
         association [0..1] to snwd_text_key as note_header 
           on snwd_so.note_guid = note_header.node_key 
  { * 
  } // Include all fields from snwd_text_key
