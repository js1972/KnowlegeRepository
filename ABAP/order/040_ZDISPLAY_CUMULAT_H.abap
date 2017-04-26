*&---------------------------------------------------------------------*
*& Report ZDISPLAY_CUMULAT_H
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZDISPLAY_CUMULAT_H.

PARAMETERS: orderid TYPE crmd_orderadm_h-object_id OBLIGATORY DEFAULT '5700000242'.

START-OF-SELECTION.

  SELECT SINGLE * INTO @DATA(order) FROM crmd_orderadm_h where object_id = @orderid.
  check sy-subrc = 0.

  SELECT SINGLE * INTO @DATA(cumul_h) FROM crmd_cumulat_h WHERE guid = @order-guid.

  check sy-subrc = 0.

  WRITE: / 'Gross weight:' COLOR COL_NEGATIVE, cumul_h-gross_weight COLOR COL_GROUP.