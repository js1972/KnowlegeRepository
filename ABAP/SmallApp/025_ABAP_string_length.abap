REPORT ZLENGTH.

data: lv type string value ' 1', "2
      lv2 type string value ' 2',"2
      lv3 type char10 value ' 3 ',"2
      lv4 type char16 value '000104', "6
      lv5 type comm_product-product_id VALUE '5', "1
      id TYPE comm_product-product_id.

WRITE: / strlen( lv ).
WRITE: / strlen( lv2 ).
WRITE: / strlen( lv3 ).
WRITE: / strlen( lv4 ).
WRITE: / strlen( lv5 ).


SHIFT lv4 LEFT DELETING LEADING '0'.

CALL FUNCTION 'CONVERSION_EXIT_PRID1_INPUT'
   EXPORTING
      input = lv4
   IMPORTING
      output = id.
WRITE: / 'after: ' , id. "104