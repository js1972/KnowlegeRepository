" I remember this class is written for Li Ke in year 2012 but actually is not needed
* from airplane Beijing to Chengdu on 2016-12-5 9:34AM 
class ZCL_RANDOM_GENERATOR definition
  public
  final
  create public .

public section.

  class-methods INIT
    importing
      !IV_COUNT type I .
  class-methods GET_ACCOUNT_ID
    returning
      value(RV_ID) type BUT000-PARTNER .
protected section.
private section.

  TYPES: tt_but000 TYPE STANDARD TABLE OF but000.
  class-data: MT_BUT000 type tt_BUT000,
              mv_count TYPE i.
ENDCLASS.



CLASS ZCL_RANDOM_GENERATOR IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_RANDOM_GENERATOR=>GET_ACCOUNT_ID
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_ID                          TYPE        BUT000-PARTNER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_ACCOUNT_ID.
    DATA: lv_line TYPE i,
          lv_index TYPE i,
          lv_time TYPE timestamp,
          ls_but000 TYPE but000.

    IF mt_but000 IS INITIAL.
       rv_id = 'NO ID ANY MORE!'.
       RETURN.
    ENDIF.

    lv_line = lines( mt_but000 ).

    GET TIME STAMP FIELD lv_time.

    lv_index = ( lv_time + lv_line ) MOD lv_line + 1.

    READ TABLE mt_but000 INTO ls_but000 INDEX lv_index.
    DELETE mt_but000 INDEX lv_index.
    rv_id = ls_but000-partner.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_RANDOM_GENERATOR=>INIT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_COUNT                       TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method INIT.
     mv_count = iv_count.

     SELECT * INTO TABLE mt_but000 FROM but000 UP TO mv_count ROWS.
  endmethod.
ENDCLASS.