
types: begin of ty_data,
           name type string,
           score TYPe int4,
        end of ty_Data.

TYPES: tt_data TYPE STANDARD TABLE OF ty_Data,
       tt_Data_hash TYPE HASHED TABLE OF ty_data WITH UNIQUE key name.

data: lt_data TYPE tt_Data,
      lt_hash TYPE tt_Data_hash.

APPEND INITIAL LINE TO lt_Data ASSIGNING FIELD-SYMBOL(<line>).
<line> = value #( name = 'Jerry' score = 1 ).

APPEND INITIAL LINE TO lt_Data ASSIGNING FIELD-SYMBOL(<line2>).
<line2> = value #( name = 'Jerry' score = 1 ).

INSERT <line2> INTO TABLE lt_hash.
BREAK-POINT.