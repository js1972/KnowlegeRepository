@AbapCatalog.sqlViewName: 'zorderitemnumber'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'item number'
define view ZORDER_item_num as select from zorder_item {
   key zorder_item.parent_id,
   
   count ( * ) as itemTotalNumber,
   sum ( zorder_item.quantity) as orderTotalQuantity 
} group by zorder_item.parent_id