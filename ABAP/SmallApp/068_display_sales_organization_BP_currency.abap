*&---------------------------------------------------------------------*
*& Report ZLIST_BP_CURRENCY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZLIST_BP_CURRENCY.

data: lt_currency TYPE STANDARD TABLE OF CRMM_BUT_SET0030,
      lt_bp_link TYPE STANDARD TABLE OF CRMM_BUT_LNK0031,
      lt_bp TYPE STANDARD TABLE OF but000.

SELECT * INTO TABLE lt_currency FROM CRMM_BUT_SET0030.

SELECt * INTO TABLE lt_bp_link FROM CRMM_BUT_LNK0031.

SELECT * INTO TABLE lt_bp FROM but000 FOR ALL ENTRIES IN lt_bp_link
  WHERE partner_guid = lt_bp_link-partner_guid.

LOOP AT lt_bp_link ASSIGNING FIELD-SYMBOL(<link>).
   READ TABLE lt_bp ASSIGNING FIELD-SYMBOL(<bp>) WITH KEY
      partner_guid = <link>-partner_guid.
   CHECK sy-subrc = 0.

   READ TABLE lt_currency ASSIGNING FIELD-SYMBOL(<cu>) WITH KEY
     set_guid = <link>-set_guid.
   CHECK sy-subrc = 0.

   WRITE: / 'BP: ' , <bp>-partner COLOR COL_NEGATIVE,
    'Sales Org: ', <link>-sales_org COLOR COL_TOTAL,
    'Channel: ' , <link>-channel COLOR COL_POSITIVE,
    'Division: ', <link>-division COLOR COL_KEY,
    'Currency: ', <cu>-currency COLOR COL_HEADING,
    'Pricing group:', <cu>-price_group COLOR COL_GROUP.
    ENDLOOP.