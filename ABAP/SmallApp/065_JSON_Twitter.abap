*&---------------------------------------------------------------------*
*& Report  ZTESTDATA
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZJSON_TWITTER.
data: lv_content type string,
      lv_number TYPE i,
      lr_json TYPE REF TO CL_CLB_PARSE_JSON,
      lxstring TYPE xstring,
      lv_converted TYPE string.

lv_content = zcl_jerry_tool=>GET_FILE_CONTENT_BY_PATH( '\\TSHomeServer\TSHome$\i042416\Desktop\12.txt' ).
lxstring   = cl_abap_codepage=>convert_to( lv_content ).
lv_converted = CL_CLB_TOOLS=>XSTRING_TO_STRING( lxstring ).


data: lv_id type string,
      lv_text type string,
      lv_string_table TYPE string_table,
      lr_data TYPE REF TO CL_ABAP_TYPEDESCR,
      lr_indices TYPE REF TO CL_ABAP_TABLEDESCR,
      lrs_user_mentions    TYPE REF TO cl_abap_structdescr,
      lrs_entities         TYPE REF TO cl_abap_structdescr,
      lrs_root             TYPE REF TO cl_abap_structdescr,
      lrt_user_mentions    TYPE REF TO cl_abap_tabledescr,
      ls_comp          TYPE abap_componentdescr,
      lt_components    TYPE abap_component_tab,
      lr_content          TYPE REF TO data.

FIELD-SYMBOLS: <structure> TYPE any.

lr_data = CL_ABAP_TYPEDESCR=>describe_by_data( lv_id ).

lr_indices ?= CL_ABAP_TYPEDESCR=>describe_by_data( lv_string_table ).
ls_comp-name = 'id'.
ls_comp-type ?= lr_data.
APPEND ls_comp TO lt_components.

ls_comp-name = 'id_str'.
ls_comp-type ?= lr_data.
APPEND ls_comp TO lt_components.

ls_comp-name = 'indices'.
ls_comp-type ?= lr_indices.
APPEND ls_comp TO lt_components.

ls_comp-name = 'name'.
ls_comp-type ?= lr_data.
APPEND ls_comp TO lt_components.

ls_comp-name = 'screen_name'.
ls_comp-type ?= lr_data.
APPEND ls_comp TO lt_components.

lrs_user_mentions  = cl_abap_structdescr=>create( lt_components ).
lrt_user_mentions      = cl_abap_tabledescr=>create( lrs_user_mentions ).

CLEAR: lt_components.
ls_comp-name = 'user_mentions'.
ls_comp-type ?= lrt_user_mentions.
APPEND ls_comp TO lt_components.

lrs_entities = cl_abap_structdescr=>create( lt_components ).

CLEAR: lt_components.
ls_comp-name = 'created_at'.
ls_comp-type ?= lr_data.
APPEND ls_comp TO lt_components.

ls_comp-name = 'entities'.
ls_comp-type ?= lrs_entities.
APPEND ls_comp TO lt_components.

ls_comp-name = 'id'.
ls_comp-type ?= lr_data.
APPEND ls_comp TO lt_components.

ls_comp-name = 'text'.
ls_comp-type ?= lr_data.
APPEND ls_comp TO lt_components.

lrs_root = cl_abap_structdescr=>create( lt_components ).
CREATE DATA lr_content TYPE HANDLE lrs_root.
ASSIGN lr_content->* TO <structure>.

BREAK-POINT.
CREATE OBJECT lr_json.

CALL METHOD lr_json->JSON_TO_DATA
   EXPORTING
      IV_JSON = lv_converted
   CHANGING
      c_data = <structure>.
BREAK-POINT.