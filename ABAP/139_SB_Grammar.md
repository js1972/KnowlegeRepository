# test structure: CRMT_JAVA_T in AG3

1. xx = |{ variable } CASE = UPPER }|.

2. lt_child = VALUE #( FOR <node> IN node_tab
                      WHERE ( parent_key IS INITIAL )
                      ( lo_test->create_data( <node>-node_key ) )
                    ).