class ZCL_COMPARATOR definition
  public
  final
  create public .

public section.

  class-methods COMPARE
    importing
      !IV_A type INT4
      !IV_B type INT4
    returning
      value(RV_RESULT) type INT4 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_COMPARATOR IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_COMPARATOR=>COMPARE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_A                           TYPE        INT4
* | [--->] IV_B                           TYPE        INT4
* | [<-()] RV_RESULT                      TYPE        INT4
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method COMPARE.

FIELD-SYMBOLS: <lv1> TYPE x.
FIELD-SYMBOLS: <lv2> TYPE x.
DATA: lv_temp TYPE x LENGTH 4,
      lv_result TYPE x LENGTH 4,
      lv_diff TYPE x LENGTH 4.

DATA(lv_a) = iv_a.
DATA(lv_b) = iv_b.
ASSIGN lv_a TO <lv1> CASTING.
ASSIGN lv_b TO <lv2> CASTING.

lv_diff = <lv1> BIT-XOR <lv2>.

" diff |= diff >> 1;
lv_temp = lv_diff.

lv_diff = ZCL_BITWISE=>right_shift_x( value = lv_diff positions = 1 ).
lv_diff = lv_temp BIT-OR lv_diff.

lv_temp = lv_diff.
lv_diff = ZCL_BITWISE=>right_shift_x( value = lv_diff positions = 2 ).
lv_diff = lv_temp BIT-OR lv_diff.

lv_temp = lv_diff.
lv_diff = ZCL_BITWISE=>right_shift_x( value = lv_diff positions = 4 ).
lv_diff = lv_temp BIT-OR lv_diff.

lv_temp = lv_diff.
lv_diff = ZCL_BITWISE=>right_shift_x( value = lv_diff positions = 8 ).
lv_diff = lv_temp BIT-OR lv_diff.

lv_temp = lv_diff.
lv_diff = ZCL_BITWISE=>right_shift_x( value = lv_diff positions = 16 ).
lv_diff = lv_temp BIT-OR lv_diff.

" diff ^= diff >> 1;
lv_temp = lv_diff.
lv_diff = ZCL_BITWISE=>right_shift_x( value = lv_diff positions = 1 ).
lv_diff = lv_temp BIT-XOR lv_diff.

"return a & diff ? 1 : -1;

lv_result = <lv1> BIT-AND lv_diff.

rv_result = COND #( when lv_result IS NOT INITIAL then 1 else -1 ).
  endmethod.
ENDCLASS.