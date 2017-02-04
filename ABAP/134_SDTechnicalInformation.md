```ABAP
data(go_snapshot) = cl_sd_sls_snapshot=>get_inst_by_vbeln( '0000021207' ).
data(ls_vbak) = cl_sd_data_select=>get_vbak( iv_vbeln = '0000021207'
                                               iv_session = abap_true ).
function module: SD_CCARD_SALES_AUTHORITY_CHECK
```
# read partner from Order
```abap
DATA: xvbadr TYPE STANDARD TABLE OF sadrvb,
      xvbpa  TYPE STANDARD TABLE OF vbpavb,
      yvbadr TYPE STANDARD TABLE OF sadrvb,
      yvbpa  TYPE STANDARD TABLE OF vbpavb,
      xvbpa2 TYPE STANDARD TABLE OF vbpa2vb,
      yvbpa2 LIKE xvbpa2.

CALL FUNCTION 'SD_PARTNER_READ'
  EXPORTING
    f_vbeln  = '0000021207'
  TABLES
    i_xvbadr = xvbadr
    i_xvbpa  = xvbpa
    i_yvbadr = yvbadr
    i_yvbpa  = yvbpa
    i_xvbpa2 = xvbpa2
    i_yvbpa2 = yvbpa2.
```
# Read Partner detail
```abap
CALL FUNCTION 'V_KNA1_SINGLE_READ'
       EXPORTING
            PI_KUNNR         = 'MY_CUST_01'
            PI_READ_CAM               = 'X'     "IAV
            PI_ACCESS_TO_ADDR_VERSION = 'X' "IAV
       IMPORTING
            PE_KNA1          = LKNA1
       EXCEPTIONS
            NO_RECORDS_FOUND = 1
            OTHERS           = 2.
```
# get price
```abap
" knumv is a data element
cl_prc_result_factory=>get_instance( )->get_prc_result( )->get_price_element_db_by_key(
         EXPORTING
            iv_knumv                      = '0000069700'
         IMPORTING
            et_prc_element_classic_format = DATA(hkonv) ).
```
# Interface
* if_prc_result_database=>prc_result_source-default
* IF_SD_DOC_CATEGORY

# Read Material
```abap
CALL FUNCTION 'MARA_SINGLE_READ'
    EXPORTING
      matnr             = vbap-matnr
    IMPORTING
      wmara             = ls_wmara
    EXCEPTIONS
      lock_on_material  = 1
      lock_system_error = 2
      wrong_call        = 3
      not_found         = 4
      OTHERS            = 5.
```
# function module
```abap
CALL FUNCTION 'RV_CUSTOMER_MATERIAL_PRE_READ'
```