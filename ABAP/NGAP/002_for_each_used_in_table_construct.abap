DATA address_annos TYPE STANDARD TABLE OF field_anno-annoname
                            WITH EMPTY KEY.
    address_annos = VALUE #(
      ( 'SEMANTICS.NAME.FULLNAME' )
      ( 'SEMANTICS.ADDRESS.STREET' )
      ( 'SEMANTICS.ADDRESS.CITY' )
      ( 'SEMANTICS.ADDRESS.ZIPCODE' )
      ( 'SEMANTICS.ADDRESS.COUNTRY' ) ).

    DATA address_components TYPE STANDARD TABLE OF field_anno-fieldname
                                 WITH EMPTY KEY.
    address_components = VALUE #(
      FOR address_anno IN address_annos
      ( VALUE #( fieldannos[ annoname = address_anno ]-fieldname
                 DEFAULT '---' ) ) ).