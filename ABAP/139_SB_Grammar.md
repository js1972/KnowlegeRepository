# test structure: CRMT_JAVA_T in AG3

1. xx = |{ variable } CASE = UPPER }|.

2. lt_child = VALUE #( FOR <node> IN node_tab
                      WHERE ( parent_key IS INITIAL )
                      ( lo_test->create_data( <node>-node_key ) )
                    ).

3. VALUE # BASE pattern:
data: t_object_list TYPE crmt_cont_object_tab,
        t_object_list1 LIKE t_object_list.

 t_object_list = VALUE #(
                       BASE t_object_list
                       ( object_name = 'Product' attr_requested = abap_true rels_requested = abap_true )
                     ).
4. create a reference based on a data structure:
data: ls_category TYPE zcrms4s_prod_category_ui.

ls_category = value #( material_Type = 'HAWA' ).
data(lv) = NEW zcrms4s_prod_category_ui( ls_category ).
