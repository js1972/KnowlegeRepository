@AbapCatalog.sqlViewName: 'ZSALESOINVVW' 
@AbapCatalog.compiler.compareFilter: true
define view zjerry_invoice as 
  select from 
         /* Association "sales_order" with filter as data source */ 
         zjerry_business_partner.sales_order[ 
           lifecycle_status <> 'X'] 
           as bpa_so //alias for data source 
         /* Association only used in this view definition */ 
         association [0..1] to snwd_so_inv_head as invoice_header 
           on bpa_so.node_key = invoice_header.so_guid 
        { key bpa_so.node_key, //Field from ON-condition in invoice_header 
              bpa_so.so_id, 
              bpa_so.note_guid, //Field from ON-condition in note_header 
              bpa_so.lifecycle_status, 
              /* Association is not published, but its element */ 
              invoice_header.dunning_level, 
              /* Association from data source is published here */ 
              bpa_so.note_header } 
          /* Path expression in WHERE clause */ 
          where invoice_header.dunning_level < '1';