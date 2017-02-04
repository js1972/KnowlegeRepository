DATA: lv1 TYPE int4 value 30,
      lv2 TYPE int4 value 21.

FIELD-SYMBOLS: <lv1> TYPE x.
FIELD-SYMBOLS: <lv2> TYPE x.

ASSIGN lv1 TO <lv1> CASTING.
ASSIGN lv2 TO <lv2> CASTING.

<lv1> = <lv1> BIT-XOR <lv2>.

<lv2> = <lv1> BIT-XOR <lv2>.

<lv1> = <lv1> BIT-XOR <lv2>.

WRITE: / lv1, lv2.