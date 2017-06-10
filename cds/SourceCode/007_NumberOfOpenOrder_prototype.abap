* done on 2017-06-10 10:07AM ER9/001

@AbapCatalog.sqlViewName: 'ZORDERSTATUS1'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Order status'
define view zorder_status_jerry as select from zorder {
   key zorder.order_id,
   zorder.post_date,
   case when zorder.status_open = 'X' 
          then 1
          else 0
   end as numberOfOpenOrders
}

@AbapCatalog.sqlViewName: 'ZOPENORDER'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@Analytics.dataCategory: #CUBE
@VDM.viewType: #COMPOSITE
@EndUserText.label: 'Open Order'
define view zopen_order as select from zorder_status_jerry {
   // key zorder_status_jerry.order_id,
   zorder_status_jerry.post_date,
   count ( * ) as numberOfOrders,
   sum ( zorder_status_jerry.numberOfOpenOrders ) as numberOfOpenOrders 
} group by post_date
