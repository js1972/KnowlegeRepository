# 2017-02-21
1. useful tool to get callstack: CL_ABAP_GET_CALL_STACK
2. [CRQS](http://www.cnblogs.com/youxin/p/3149695.html)
3. Default value
```abap
DATA(ls3) = VALUE #( lt_data[ name = 'Spring2' ]
              DEFAULT VALUE #( name = 'SpringInvalid' value = 999 ) ).
```
4. check whether we are in IC - interaction center context
```abap
lt_page_instances = cl_bsp_context=>c_page_instances.
  READ TABLE lt_page_instances ASSIGNING <ic_instance>
     WITH KEY class = 'CL_BSP_WD_VIEW_MANAGER'.
  IF sy-subrc = 0.
    lv_ic_mode = 'X'.
  ENDIF.
``` 

# 2017-04-22

good tip: find //bas/745_COR/src/krn/abap/ -name "*.c" | xargs grep "IF_BADI_INTERFACE"

# 2017-05-07
1. txt1 = condense( txt2 && txt3 ).
2. String template: multiple line should be joined by &.