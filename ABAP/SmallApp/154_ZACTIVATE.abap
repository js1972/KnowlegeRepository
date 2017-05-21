REPORT zactivate.

PARAMETERS: purl TYPE string OBLIGATORY LOWER CASE.

DATA: lv_content TYPE string,
      lt_node    TYPE zcl_jerry_tool=>tt_sorted_node,
      lv_number  TYPE int4,
      lv_size    TYPE int4,
      lv_index   TYPE int4 VALUE 1,
      lt_pic     TYPE string_table.

CONSTANTS: folder TYPE string VALUE 'C:\Users\i042416\Desktop\pic\clipboard'.

START-OF-SELECTION.

  DATA: lv_url TYPE string.

  lv_url = 'http://note.youdao.com/yws/public/note/' && purl && '?keyfrom=public'.
  lv_content = zcl_crm_cm_tool=>get_text_by_url( purl ).

  CALL METHOD zcl_jerry_tool=>parse_json_to_internal_table
    EXPORTING
      iv_json        = lv_content
    IMPORTING
      et_node        = lt_node
      ev_node_number = lv_number.

  ASSERT lv_number = 1.

  READ TABLE lt_node ASSIGNING FIELD-SYMBOL(<node>) WITH KEY attribute = 'content'.

  ASSERT sy-subrc = 0.

  SPLIT <node>-value AT space INTO TABLE DATA(lt_result).

  LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<entry>) WHERE table_line CS 'src='.
    lv_number = strlen( <entry> ) - 6.
    DATA(url) = <entry>+5(lv_number).
    APPEND url TO lt_pic.
  ENDLOOP.

  DATA(lv_total) = lines( lt_pic ).
  LOOP AT lt_pic ASSIGNING FIELD-SYMBOL(<pic>).
    DATA(lv_name) = folder && lv_index && '.png'.
    DATA(lv_text) = 'Downloading file: ' && lv_name.
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
         PERCENTAGE = lv_index * 100 / lv_total
         text = lv_text.

    DATA(binary) = zcl_crm_cm_tool=>get_data_by_url( <pic> ).

    zcl_crm_cm_tool=>download_locally( iv_local_path = lv_name iv_binary = binary ).
    ADD 1 TO lv_index.
  ENDLOOP.

  WRITE: / 'totally ', lv_total, ' pictures downloaded successfully!' COLOR COL_NEGATIVE.

  class ZCL_CRM_CM_TOOL definition
  public
  final
  create public .

public section.

  class-methods GET_DATA_BY_URL
    importing
      !IV_URL type STRING
    returning
      value(EV_DATA) type XSTRING .
  class-methods CREATE_DOC
    importing
      !IV_DATA type XSTRING
      !IV_BOR_TYPE type STRING
      !IV_GUID type SMI_SOCIALDATAUUID
      !IV_FILE_NAME type STRING .
  class-methods DELETE_DOC
    importing
      !IV_BOR_TYPE type STRING
      !IV_UUID type SOCIALDATA-SOCIALDATAUUID
    returning
      value(RV_SUCCESSFUL) type ABAP_BOOL .
  class-methods GET_ATTACHMENTS
    importing
      !IV_GUID type SIBFLPORB-INSTID
      !IV_BOR_TYPE type STRING
    exporting
      value(LOIOS) type SKWF_IOS
      value(PHIOS) type SKWF_IOS .
  class-methods CHANGE_PROPERTY
    importing
      !IV_GUID type SIBFLPORB-INSTID
      !IV_BOR_TYPE type STRING
      !IV_ATTR_NAME type STRING
      !IV_NEW_VALUE type STRING .
  class-methods CLASS_CONSTRUCTOR .
  class-methods GET_PRODUCT_DOC_URL
    importing
      !IV_PROD_ID type COMM_PRODUCT-PRODUCT_ID
    returning
      value(RT_URL) type STRING_TABLE .
  class-methods GET_TEXT_BY_URL
    importing
      !IV_URL type STRING
    returning
      value(EV_TEXT) type STRING .
  class-methods IS_TEXT_FILE
    importing
      !IS_IO type SKWF_IO
    returning
      value(RV_TRUE) type ABAP_BOOL .
  class-methods GET_PROD_ID_BY_PHIO
    importing
      !IV_PHIO type SDOK_PHID
    returning
      value(RV_PROD_ID) type COMM_PRODUCT-PRODUCT_ID .
  class-methods DOWNLOAD_LOCALLY
    importing
      !IV_LOCAL_PATH type STRING
      !IV_BINARY type XSTRING .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CRM_CM_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_CM_TOOL=>CHANGE_PROPERTY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_GUID                        TYPE        SIBFLPORB-INSTID
* | [--->] IV_BOR_TYPE                    TYPE        STRING
* | [--->] IV_ATTR_NAME                   TYPE        STRING
* | [--->] IV_NEW_VALUE                   TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CHANGE_PROPERTY.
    DATA: loios  TYPE SKWF_IOS,
          phios  TYPE SKWF_IOS,
          ls_header TYPE SDOKOBJECT,
          lt_properties TYPE STANDARD TABLE OF SDOKPROPTY.

    DATA(ls_property) = VALUE SDOKPROPTY( name = iv_attr_name value = iv_new_value ).
    APPEND ls_property TO lt_properties.

    CALL METHOD zcl_crm_cm_tool=>GET_ATTACHMENTS
      EXPORTING
         iv_guid = iv_guid
         iv_bor_type = iv_bor_type
      IMPORTING
         LOIOS = LOIOS
         phios = phios.

    LOOP AT phios ASSIGNING FIELD-SYMBOL(<ios>).
       ls_header-class =  <ios>-class.
       ls_header-objid = <ios>-objid.
      CALL FUNCTION 'SDOK_PHIO_PROPERTIES_SET'
        EXPORTING
          object_id = ls_header
        TABLES
          properties = lt_properties
        EXCEPTIONS
          NOT_EXISTING = 1
          BAD_PROPERTIES = 2
          NOT_AUTHORIZED = 3
          EXCEPTION_IN_EXIT = 4.

      IF sy-subrc <> 0.
         BREAK-POINT.
      ENDIF.

    ENDLOOP.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_CM_TOOL=>CLASS_CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CLASS_CONSTRUCTOR.
    CALL FUNCTION 'SDOK_INTERNAL_MODE_ACCESS'
      EXPORTING
        MODE_REQUESTED = '01'.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_CM_TOOL=>CREATE_DOC
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DATA                        TYPE        XSTRING
* | [--->] IV_BOR_TYPE                    TYPE        STRING
* | [--->] IV_GUID                        TYPE        SMI_SOCIALDATAUUID
* | [--->] IV_FILE_NAME                   TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method CREATE_DOC.
    DATA:
         ls_bo              TYPE sibflporb,
         ls_prop            TYPE LINE OF sdokproptys,
         lt_prop            TYPE sdokproptys,
         lt_properties_attr TYPE crmt_attr_name_value_t,
         ls_file_info       TYPE sdokfilaci,
         lt_file_info       TYPE sdokfilacis,
         lt_file_content    TYPE sdokcntbins,
         lv_length          TYPE i,
         lv_file_xstring    TYPE xstring,
         ls_loio            TYPE skwf_io,
         ls_phio            TYPE skwf_io,
         ls_error           TYPE skwf_error.

    ls_prop-name = 'DESCRIPTION'.
    ls_prop-value = 'created by Tool'.
    APPEND ls_prop TO lt_prop.

    ls_prop-name = 'KW_RELATIVE_URL'.
    ls_prop-value = iv_file_name.
    APPEND ls_prop TO lt_prop.

    ls_prop-name = 'LANGUAGE'.
    ls_prop-value = sy-langu.
    APPEND ls_prop TO lt_prop.

" read only field, cannot work
*    ls_prop-name = 'CREATED_BY'.
*    ls_prop-value = 'DAIDE'.
*    APPEND ls_prop TO lt_prop.

    lv_file_xstring = iv_data.
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = lv_file_xstring
      IMPORTING
        output_length = lv_length
      TABLES
        binary_tab    = lt_file_content.

    ls_file_info-binary_flg = 'X'.
    ls_file_info-file_name = iv_file_name.
    ls_file_info-file_size = lv_length.
    ls_file_info-mimetype = 'image/jpeg'.
    APPEND ls_file_info TO lt_file_info.

    ls_bo-INSTID = iv_guid.
    ls_bo-typeid = iv_bor_type.
    ls_bo-catid = 'BO'.

    CALL METHOD cl_crm_documents=>create_with_table
      EXPORTING
        business_object     = ls_bo
        properties          = lt_prop
        properties_attr     = lt_properties_attr
        file_access_info    = lt_file_info
        file_content_binary = lt_file_content
        raw_mode            = 'X'
      IMPORTING
        loio                = ls_loio
        phio                = ls_phio
        error               = ls_error.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_CM_TOOL=>DELETE_DOC
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_BOR_TYPE                    TYPE        STRING
* | [--->] IV_UUID                        TYPE        SOCIALDATA-SOCIALDATAUUID
* | [<-()] RV_SUCCESSFUL                  TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method DELETE_DOC.
    DATA: ls_bo       TYPE SIBFLPORB,
          lt_loios    TYPE SKWF_IOS,
          ls_loios    TYPE SKWF_IO,
          ls_error    TYPE SKWF_ERROR,
          lt_badios   TYPE SKWF_IOERRS,
          lv_del_flag TYPE ABAP_BOOL.

    ls_bo-instid = iv_uuid.
    ls_bo-typeid = iv_bor_type.
    ls_bo-catid  = 'BO'.
    rv_successful = abap_false.
    CALL METHOD cl_crm_documents=>get_info
      EXPORTING
        business_object = ls_bo
      IMPORTING
        loios           = lt_loios.

    LOOP AT lt_loios INTO ls_loios.
      CALL METHOD cl_crm_documents=>lock
        EXPORTING
          is_bo    = ls_bo
          is_loio  = ls_loios
        IMPORTING
          es_error = ls_error.

      IF ls_error IS NOT INITIAL.
         RETURN.
      ENDIF.
    ENDLOOP.

    CALL METHOD cl_crm_documents=>delete
      EXPORTING
         business_object = ls_bo
         ios             = lt_loios
      IMPORTING
         bad_ios         = lt_badios
         error           = ls_error.

    IF ls_error IS INITIAL. " deletion failed
       rv_successful = abap_true.
    ENDIF.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_CM_TOOL=>DOWNLOAD_LOCALLY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_LOCAL_PATH                  TYPE        STRING
* | [--->] IV_BINARY                      TYPE        XSTRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD download_locally.
    TYPES: BEGIN OF ts_line,
             data(1024) TYPE x,
           END OF ts_line.

    DATA: lv_size TYPE int4,
          lt_data TYPE STANDARD TABLE OF ts_line.

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer        = iv_binary
      IMPORTING
        output_length = lv_size
      TABLES
        binary_tab    = lt_data.

    CALL METHOD cl_gui_frontend_services=>gui_download
      EXPORTING
        bin_filesize = lv_size
        filename     = iv_local_path
        filetype     = 'BIN'
        append       = space
      IMPORTING
        filelength   = lv_size
      CHANGING
        data_tab     = lt_data
      EXCEPTIONS
        OTHERS       = 01.

    ASSERT sy-subrc = 0.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_CM_TOOL=>GET_ATTACHMENTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_GUID                        TYPE        SIBFLPORB-INSTID
* | [--->] IV_BOR_TYPE                    TYPE        STRING
* | [<---] LOIOS                          TYPE        SKWF_IOS
* | [<---] PHIOS                          TYPE        SKWF_IOS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_ATTACHMENTS.
     DATA(ls) = VALUE SIBFLPORB( INSTID = iv_guid typeid = iv_bor_type catid = 'BO' ).

     CALL METHOD CL_CRM_DOCUMENTS=>get_info
       EXPORTING
          BUSINESS_OBJECT = ls
       IMPORTING
          LOIOS = LOIOS
          phios = phios.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_CM_TOOL=>GET_DATA_BY_URL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_URL                         TYPE        STRING
* | [<-()] EV_DATA                        TYPE        XSTRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_DATA_BY_URL.
    DATA:lo_http_client           TYPE REF TO if_http_client,
         lv_status                TYPE i,
         lv_sysubrc               TYPE sysubrc.

    CALL METHOD cl_http_client=>create_by_url
      EXPORTING
        url                = iv_url
        "proxy_host         = 'PROXY.SHA.SAP.CORP'
        "proxy_service      = '8080'
        "ssl_id             = 'ANONYM'
        "sap_username       = ''
        "sap_client         = ''
      IMPORTING
        client             = lo_http_client
      EXCEPTIONS
        argument_not_found = 1
        plugin_not_active  = 2
        internal_error     = 3
        OTHERS             = 4.

    ASSERT sy-subrc = 0.

    CALL METHOD lo_http_client->request->set_method( if_http_request=>co_request_method_get ).

*Disable pop-up when request receives unauthorized error: error 401.
    lo_http_client->propertytype_logon_popup = if_http_client=>co_disabled.

*Send request.
    CALL METHOD lo_http_client->send
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3.

    ASSERT sy-subrc = 0.

* Get response.
    CALL METHOD lo_http_client->receive
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3.

   IF sy-subrc <> 0.
        CALL METHOD lo_http_client->get_last_error
        IMPORTING
          code    = lv_sysubrc
          message = DATA(ev_message).
        BREAK-POINT.
        RETURN.
   ENDIF.

   ev_data = lo_http_client->response->get_data( ).

   lo_http_client->close( ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_CM_TOOL=>GET_PRODUCT_DOC_URL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PROD_ID                     TYPE        COMM_PRODUCT-PRODUCT_ID
* | [<-()] RT_URL                         TYPE        STRING_TABLE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_PRODUCT_DOC_URL.
    DATA:  lt_query_parameter    TYPE crmt_name_value_pair_tab,
           ls_query_parameter    LIKE LINE OF lt_query_parameter,
           lv_view_name          TYPE crmt_view_name,
           ls_doc                TYPE CRMT_PRIL_DOCUMENTS_URI,
           lv_query_name         TYPE crmt_ext_obj_name.
    ls_query_parameter-name = 'PRODUCT_ID'.
    ls_query_parameter-value = iv_prod_id.
    APPEND ls_query_parameter TO lt_query_parameter.

    DATA(lo_core) = cl_crm_bol_core=>get_instance( ).
    lo_core->load_component_set( 'PROD_ALL' ).
    lv_query_name = 'ProdAdvancedSearchProducts'.

  try.
   DATA(lo_collection) = lo_core->query(
      iv_query_name               = lv_query_name
      it_query_params             = lt_query_parameter
      iv_view_name                = lv_view_name ).
   CATCH CX_SY_ARITHMETIC_ERROR.
      write:/ 'Error' .
   ENDTRY.

   DATA(lo_product) = lo_collection->get_first( ).
   DATA(lo_doc) = lo_product->get_related_entities( IV_RELATION_NAME = 'ProductDocumentLink' ).
   CHECK lo_doc IS NOT INITIAL.

   DATA(lo_item) = lo_doc->get_first( ).
   WHILE lo_item IS NOT INITIAL.
     lo_item->get_properties( IMPORTING ES_ATTRIBUTES = ls_doc ).
     APPEND ls_doc-document_uri TO rt_url.
     lo_item = lo_doc->get_next( ).
   ENDWHILE.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_CM_TOOL=>GET_PROD_ID_BY_PHIO
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PHIO                        TYPE        SDOK_PHID
* | [<-()] RV_PROD_ID                     TYPE        COMM_PRODUCT-PRODUCT_ID
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_prod_id_by_phio.
    DATA: ls_ph         TYPE bdsphio22,
          ls_product    TYPE comm_product,
          lv_instance_b TYPE skwg_brel-instid_b,
          ls_relation   TYPE skwg_brel.

    SELECT SINGLE * INTO ls_ph FROM bdsphio22 WHERE phio_id = iv_phio.
    CHECK sy-subrc = 0.

    lv_instance_b = 'L/' && ls_ph-lo_class && '/' && ls_ph-loio_id.


    SELECT SINGLE * INTO ls_relation FROM skwg_brel WHERE instid_b = lv_instance_b AND typeid_a = 'BUS1178'.
    CHECK sy-subrc = 0.

    SELECT SINGLE * INTO ls_product FROM comm_product WHERE product_guid = ls_relation-instid_a.
    CHECK sy-subrc = 0.

    rv_prod_id = ls_product-product_id.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_CM_TOOL=>GET_TEXT_BY_URL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_URL                         TYPE        STRING
* | [<-()] EV_TEXT                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_TEXT_BY_URL.
    DATA:lo_http_client           TYPE REF TO if_http_client,
         lv_status                TYPE i,
         lv_sysubrc               TYPE sysubrc.

    CALL METHOD cl_http_client=>create_by_url
      EXPORTING
        url                = iv_url
*        proxy_host         = 'PROXY.SHA.SAP.CORP'
*        proxy_service      = '8080'
*        ssl_id             = 'ANONYM'
*        sap_username       = ''
*        sap_client         = ''
      IMPORTING
        client             = lo_http_client
      EXCEPTIONS
        argument_not_found = 1
        plugin_not_active  = 2
        internal_error     = 3
        OTHERS             = 4.

    ASSERT sy-subrc = 0.

    CALL METHOD lo_http_client->request->set_method( if_http_request=>co_request_method_get ).

*Disable pop-up when request receives unauthorized error: error 401.
    "lo_http_client->propertytype_logon_popup = if_http_client=>co_disabled.

*Send request.
    CALL METHOD lo_http_client->send
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3.

    ASSERT sy-subrc = 0.

* Get response.
    CALL METHOD lo_http_client->receive
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3.

   IF sy-subrc <> 0.
        CALL METHOD lo_http_client->get_last_error
        IMPORTING
          code    = lv_sysubrc
          message = DATA(ev_message).
        BREAK-POINT.
        RETURN.
   ENDIF.

   ev_text = lo_http_client->response->get_cdata( ).

   lo_http_client->close( ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_CRM_CM_TOOL=>IS_TEXT_FILE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_IO                          TYPE        SKWF_IO
* | [<-()] RV_TRUE                        TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method IS_TEXT_FILE.

    DATA: lv_type type W3CONTTYPE.

    CALL METHOD cl_crm_documents=>get_file_info
      EXPORTING
        phio      = is_io
      IMPORTING
        mimetype  = lv_type.

    IF lv_type = 'text/plain'.
       rv_true = abap_true.
    ENDIF.
  endmethod.
ENDCLASS.

 

CLASS zcl_jerry_tool DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_def,
        crm TYPE c LENGTH 1,
        fin TYPE c LENGTH 1,
        srm TYPE c LENGTH 1,
      END OF ty_def .
    TYPES:
      BEGIN OF ty_level,
        level     TYPE i,
        indicator TYPE string,
      END OF ty_level .
    TYPES:
      tt_level TYPE STANDARD TABLE OF ty_level WITH KEY level .
    TYPES:
      BEGIN OF ty_post,
        external_uuid        TYPE smi_socialpost,
        content              TYPE crmt_soc_data_content,
        creation_date_time   TYPE crmt_soc_data_created,
        created_by_user_uuid TYPE smi_socialuser,
        parent_external_uuid TYPE smi_socialpost,
        language             TYPE laiso,
        created_by_user_name TYPE smi_socialusername,
      END OF ty_post .
    TYPES:
      tt_post TYPE TABLE OF ty_post .
    TYPES:
      BEGIN OF ty_node,
        node_type TYPE string,
        prefix    TYPE string,
        name      TYPE string,
        nsuri     TYPE string,
        value     TYPE string,
        value_raw TYPE xstring,
      END OF ty_node .
    TYPES:
      tt_node TYPE TABLE OF ty_node .
    TYPES:
      BEGIN OF ty_sorted_node,
        index     TYPE string,
        attribute TYPE string,
        value     TYPE string,
      END OF ty_sorted_node .
    TYPES:
      tt_sorted_node TYPE STANDARD TABLE OF ty_sorted_node .

    CONSTANTS gc_def TYPE ty_def VALUE '123' ##NO_TEXT.
    CONSTANTS gc_json_open_element TYPE string VALUE 'open element' ##NO_TEXT.
    CONSTANTS gc_json_attribute TYPE string VALUE 'attribute' ##NO_TEXT.
    CONSTANTS gc_json_close_element TYPE string VALUE 'close element' ##NO_TEXT.
    CONSTANTS gc_json_value TYPE string VALUE 'value' ##NO_TEXT.
    CONSTANTS gc_json_error TYPE string VALUE 'Error' ##NO_TEXT.

    CLASS-METHODS get_bol_entity_by_id
      IMPORTING
        !iv_internal_id      TYPE crmd_soc_post-internal_id
      RETURNING
        VALUE(rv_bol_entity) TYPE REF TO cl_crm_bol_entity .
    CLASS-METHODS get_file_binary_by_path
      IMPORTING
        !iv_path          TYPE string
      RETURNING
        VALUE(rv_content) TYPE xstring .
    CLASS-METHODS get_file_content_by_path
      IMPORTING
        !iv_path          TYPE string
      RETURNING
        VALUE(rv_content) TYPE string .
    CLASS-METHODS get_query_result
      IMPORTING
        !iv_col_wrapper  TYPE REF TO cl_bsp_wd_collection_wrapper
      RETURNING
        VALUE(rv_result) TYPE REF TO if_bol_entity_col .
    CLASS-METHODS get_selected_post_by_event
      IMPORTING
        !iv_event        TYPE string
        !iv_col_wrapper  TYPE REF TO cl_bsp_wd_collection_wrapper
      RETURNING
        VALUE(rv_result) TYPE REF TO cl_crm_bol_entity .
    CLASS-METHODS get_sample_bol_entity_by_id
      IMPORTING
        !iv_account_id   TYPE genilt_account_attr-account_id
      RETURNING
        VALUE(rv_entity) TYPE REF TO cl_crm_bol_entity .
    CLASS-METHODS modify_and_save
      IMPORTING
        !iv_bol_entity    TYPE REF TO cl_crm_bol_entity
        !iv_attr_name     TYPE string
        !iv_attr_value    TYPE string
      RETURNING
        VALUE(rv_success) TYPE abap_bool .
    CLASS-METHODS execute .
    CLASS-METHODS parse_json_to_internal_table
      IMPORTING
        !iv_json        TYPE string
      EXPORTING
        VALUE(et_node)  TYPE tt_sorted_node
        !ev_node_number TYPE i .
    CLASS-METHODS populate_post_table
      IMPORTING
        !it_sorted_node   TYPE tt_sorted_node
        !iv_node_number   TYPE i
      EXPORTING
        !et_post          TYPE tt_post
        !ev_soc_post_info TYPE smi_lastprocessedsocialpost .
    CLASS-METHODS get_root_by_result_entity
      IMPORTING
        !ir_result     TYPE REF TO cl_crm_bol_entity
      RETURNING
        VALUE(rv_root) TYPE REF TO cl_crm_bol_entity .
    METHODS constructor
      IMPORTING
        !ev_error_code TYPE i .
    CLASS-METHODS get_query_results
      IMPORTING
        !iv_col_wrapper  TYPE REF TO cl_bsp_wd_collection_wrapper
      RETURNING
        VALUE(rv_result) TYPE REF TO if_bol_entity_col .
    CLASS-METHODS get_selected_root_by_event
      IMPORTING
        !iv_event        TYPE string
        !iv_col_wrapper  TYPE REF TO cl_bsp_wd_collection_wrapper
      RETURNING
        VALUE(rv_result) TYPE REF TO cl_crm_bol_entity .
    CLASS-METHODS insert_dl_entry .
    CLASS-METHODS delete_dl_entry .
    CLASS-METHODS get_new_date
      IMPORTING
        !iv_old_date       TYPE string
      RETURNING
        VALUE(rv_new_date) TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA mv_private TYPE string .

    CLASS-METHODS convert_to_timestamp
      IMPORTING
        !iv_time_string TYPE string
      EXPORTING
        !ev_timestamp   TYPE crmt_soc_data_created .
    CLASS-METHODS get_core_message
      IMPORTING
        !is_json_item TYPE ty_sorted_node
        !iv_type      TYPE char1
      CHANGING
        !cs_post      TYPE ty_post .
    CLASS-METHODS parse_json_to_raw_table
      IMPORTING
        !iv_json TYPE string
      EXPORTING
        !et_node TYPE tt_node
      EXCEPTIONS
        json_parse_error .
    CLASS-METHODS sort_raw_table
      IMPORTING
       !it_node        TYPE tt_node
      EXPORTING
        !et_sorted_node TYPE tt_sorted_node
        !ev_node_number TYPE i .
    CLASS-METHODS get_switch
      RETURNING
        VALUE(rv_status) TYPE abap_bool .
    CLASS-METHODS add_obj_to_inter_record .
    CLASS-METHODS get_host_url .
ENDCLASS.



CLASS ZCL_JERRY_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_JERRY_TOOL=>ADD_OBJ_TO_INTER_RECORD
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD add_obj_to_inter_record.
    DATA: ls_obj_rolea TYPE borident,
          ls_obj_roleb TYPE borident,
          ls_rel       TYPE gbinrel.

    DATA: ls_post TYPE crmd_soc_post.

    SELECT SINGLE * INTO ls_post FROM crmd_soc_post WHERE internal_id = '201300010287'.
    CHECK sy-subrc = 0.
    ls_obj_rolea-objkey = '00163EA720041ED2B99037CC5233E27F'.
    ls_obj_rolea-objtype = 'BUS2000126'.

    ls_obj_roleb-objkey = ls_post-uuid.
    ls_obj_roleb-objtype = 'CRMSOCPOST'.
    CALL FUNCTION 'BINARY_RELATION_CREATE'
      EXPORTING
        obj_rolea      = ls_obj_rolea
        obj_roleb      = ls_obj_roleb
        relationtype   = 'INTO'
      IMPORTING
        binrel         = ls_rel
      EXCEPTIONS
        no_model       = 1
        internal_error = 2
        unknown        = 3.
    CHECK sy-subrc = 0.
    COMMIT WORK AND WAIT.
    WRITE: / 'Relation created'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_JERRY_TOOL->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* | [--->] EV_ERROR_CODE                  TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD constructor.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_JERRY_TOOL=>CONVERT_TO_TIMESTAMP
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_TIME_STRING                 TYPE        STRING
* | [<---] EV_TIMESTAMP                   TYPE        CRMT_SOC_DATA_CREATED
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD convert_to_timestamp.

    DATA: lt_time_tab   TYPE STANDARD TABLE OF char20,
          lv_year_str   TYPE char10,
          lv_time_str   TYPE char10,
          lv_mon_str    TYPE char5,
          lv_day_str    TYPE char5,
          lv_result_str TYPE char20.

    FIELD-SYMBOLS: <fs_str>  TYPE any.

    IF iv_time_string IS NOT INITIAL.
      SPLIT iv_time_string AT space INTO TABLE  lt_time_tab.

*Get correct month
      READ TABLE lt_time_tab ASSIGNING <fs_str> INDEX 2.
      CASE <fs_str>.
        WHEN 'Jan'.
          lv_mon_str = '01'.
        WHEN 'Feb'.
          lv_mon_str = '02'.
        WHEN 'Mar'.
          lv_mon_str = '03'.
        WHEN 'Apr'.
          lv_mon_str = '04'.
        WHEN 'May'.
          lv_mon_str = '05'.
        WHEN 'Jun'.
          lv_mon_str = '06'.
        WHEN 'Jul'.
          lv_mon_str = '07'.
        WHEN 'Aug'.
          lv_mon_str = '08'.
        WHEN 'Sep'.
          lv_mon_str = '09'.
        WHEN 'Oct'.
          lv_mon_str = '10'.
        WHEN 'Nov'.
          lv_mon_str = '11'.
        WHEN 'Dec'.
          lv_mon_str = '12'.
      ENDCASE.

*Get correct year
      READ TABLE lt_time_tab ASSIGNING <fs_str> INDEX 6.
      lv_year_str = <fs_str>.

*Get correct day
      READ TABLE lt_time_tab ASSIGNING <fs_str> INDEX 3.
      lv_day_str = <fs_str>.

*Get correct time
      READ TABLE lt_time_tab ASSIGNING <fs_str> INDEX 4.
      lv_time_str = <fs_str>.
      REPLACE ALL OCCURRENCES OF ':' IN lv_time_str WITH ''.

      CONCATENATE lv_year_str lv_mon_str lv_day_str lv_time_str INTO lv_result_str.
      ev_timestamp = lv_result_str.


    ENDIF.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JERRY_TOOL=>DELETE_DL_ENTRY
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD delete_dl_entry.
    DELETE FROM bsp_dlc_settings WHERE no_hidden = 'X'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JERRY_TOOL=>EXECUTE
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD execute.
    DATA: lv_switch TYPE abap_bool.

    lv_switch = get_switch( ).
    WHILE lv_switch = abap_true.
      lv_switch = get_switch( ).
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JERRY_TOOL=>GET_BOL_ENTITY_BY_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_INTERNAL_ID                 TYPE        CRMD_SOC_POST-INTERNAL_ID
* | [<-()] RV_BOL_ENTITY                  TYPE REF TO CL_CRM_BOL_ENTITY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_bol_entity_by_id.
**/
*
* Get Social Post BOL entity instance by given internal ID.
*
* @param IV_INTERNAL_ID internal id of social post to be retrieved
*
* @return BOL entity instance of given social post
*
*/

* add a few lines

    DATA: lo_core            TYPE REF TO cl_crm_bol_core,
          lo_collection      TYPE REF TO if_bol_entity_col,
          lv_view_name       TYPE crmt_view_name,
          lv_query_name      TYPE crmt_ext_obj_name,
          lt_query_parameter TYPE crmt_name_value_pair_tab,
          ls_query_parameter LIKE LINE OF lt_query_parameter,
          lv_size            TYPE i.

    ls_query_parameter-name = 'INTERNAL_ID'.
    ls_query_parameter-value = iv_internal_id.
    APPEND ls_query_parameter TO lt_query_parameter.

    lo_core = cl_crm_bol_core=>get_instance( ).
    lo_core->load_component_set( 'CRMSMT' ).
    lv_query_name = 'PostSearch'.


    lo_collection = lo_core->query(
        iv_query_name               = lv_query_name
        it_query_params             = lt_query_parameter
        iv_view_name                = lv_view_name ).

    lv_size = lo_collection->if_bol_bo_col~size( ).
    ASSERT lv_size = 1.

    rv_bol_entity = lo_collection->get_first( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_JERRY_TOOL=>GET_CORE_MESSAGE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_JSON_ITEM                   TYPE        TY_SORTED_NODE
* | [--->] IV_TYPE                        TYPE        CHAR1
* | [<-->] CS_POST                        TYPE        TY_POST
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_core_message.

    DATA lv_timestamp TYPE crmt_soc_data_created.

    CASE is_json_item-attribute.
*--------------------------post id
      WHEN 'statuses-idstr'.
        cs_post-external_uuid        = is_json_item-value.
*--------------------------post content
      WHEN 'statuses-text'.
        cs_post-content              = is_json_item-value.
*--------------------------sender user id
      WHEN 'statuses-user-idstr'.
        cs_post-created_by_user_uuid = is_json_item-value.
*Check sender screen name for post
      WHEN 'statuses-user-screen_name'.
        cs_post-created_by_user_name = is_json_item-value.
*--------------------------reply post id
      WHEN 'statuses-in_reply_to_status_id'.
*Check needed as we stored nothing if no parent post id found instead of null
        IF is_json_item-value = 'null'.
          cs_post-parent_external_uuid = ''.
        ELSE.
          cs_post-parent_external_uuid  = is_json_item-value.
        ENDIF.
*Get language key
      WHEN 'sender-lang'.
        IF iv_type = 'D'.
          cs_post-language = is_json_item-value.
        ENDIF.

      WHEN 'user-lang'.
        IF iv_type = 'P'.
          cs_post-language = is_json_item-value.
        ENDIF.
*--------------------------creation date
      WHEN 'statuses-created_at'.
        IF is_json_item-value IS NOT INITIAL.
          CALL METHOD convert_to_timestamp
            EXPORTING
              iv_time_string = is_json_item-value
            IMPORTING
              ev_timestamp   = lv_timestamp.

          IF lv_timestamp IS NOT INITIAL.
            cs_post-creation_date_time = lv_timestamp.
          ENDIF.
        ENDIF.
    ENDCASE.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JERRY_TOOL=>GET_FILE_BINARY_BY_PATH
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PATH                        TYPE        STRING
* | [<-()] RV_CONTENT                     TYPE        XSTRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_file_binary_by_path.
    CONSTANTS c_linelen TYPE i VALUE 255.
    DATA: wa_data(c_linelen) TYPE x,
          it_data            LIKE TABLE OF wa_data,
          converter          TYPE REF TO cl_abap_conv_in_ce,
          lv_xstring         TYPE xstring,
          lv_length          TYPE i.

    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename                = iv_path
        filetype                = 'BIN'
      IMPORTING
        filelength              = lv_length
      CHANGING
        data_tab                = it_data
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        not_supported_by_gui    = 17
        error_no_gui            = 18
        OTHERS                  = 19.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = lv_length
      IMPORTING
        buffer       = lv_xstring
      TABLES
        binary_tab   = it_data
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.
    IF sy-subrc  <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    rv_content = lv_xstring.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JERRY_TOOL=>GET_FILE_CONTENT_BY_PATH
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_PATH                        TYPE        STRING
* | [<-()] RV_CONTENT                     TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_file_content_by_path.
    CONSTANTS c_linelen TYPE i VALUE 255.
    DATA: wa_data(c_linelen) TYPE x,
          it_data            LIKE TABLE OF wa_data,
          converter          TYPE REF TO cl_abap_conv_in_ce,
          lv_xstring         TYPE xstring,
          lv_length          TYPE i.

    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename                = iv_path
        filetype                = 'BIN'
        "codepage                = '4103'
      IMPORTING
        filelength              = lv_length
      CHANGING
        data_tab                = it_data
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        not_supported_by_gui    = 17
        error_no_gui            = 18
        OTHERS                  = 19.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING
        input_length = lv_length
      IMPORTING
        buffer       = lv_xstring
      TABLES
        binary_tab   = it_data
      EXCEPTIONS
        failed       = 1
        OTHERS       = 2.
    IF sy-subrc  <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    converter = cl_abap_conv_in_ce=>create( encoding = 'UTF-8' input = lv_xstring ).
    converter->read( IMPORTING data = rv_content ).

    DATA: lv_c(1) TYPE c,
          len     TYPE i.

    FIELD-SYMBOLS: <any> TYPE x.

    lv_c = rv_content+0(1).
    ASSIGN lv_c TO <any> CASTING.
    IF <any> = 'FFFE'.
      len = strlen( rv_content ) - 1.
      rv_content = rv_content+1(len).
    ENDIF.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_JERRY_TOOL=>GET_HOST_URL
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_host_url.
    DATA(lo_runtime) = cl_bsp_runtime=>get_runtime_instance( ).

    DATA(lo_url) = NEW cl_url( server = lo_runtime->server ).

    DATA: url TYPE string.
    lo_url->host( CHANGING url = url ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JERRY_TOOL=>GET_NEW_DATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_OLD_DATE                    TYPE        STRING
* | [<-()] RV_NEW_DATE                    TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_new_date.
    rv_new_date = iv_old_date.
    REPLACE ALL OCCURRENCES OF '-' IN rv_new_date WITH '.'.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JERRY_TOOL=>GET_QUERY_RESULT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_COL_WRAPPER                 TYPE REF TO CL_BSP_WD_COLLECTION_WRAPPER
* | [<-()] RV_RESULT                      TYPE REF TO IF_BOL_ENTITY_COL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_query_result.
    CHECK iv_col_wrapper IS NOT INITIAL.
    DATA: lv_query TYPE REF TO cl_crm_bol_query_service.
    TRY.
        lv_query ?= iv_col_wrapper->get_current( ).
      CATCH cx_root.
        RETURN.
    ENDTRY.

    rv_result = lv_query->get_query_result( ).


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JERRY_TOOL=>GET_QUERY_RESULTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_COL_WRAPPER                 TYPE REF TO CL_BSP_WD_COLLECTION_WRAPPER
* | [<-()] RV_RESULT                      TYPE REF TO IF_BOL_ENTITY_COL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_query_results.
    CHECK iv_col_wrapper IS NOT INITIAL.
    DATA: lv_query TYPE REF TO cl_crm_bol_query_service.
    TRY.
        lv_query ?= iv_col_wrapper->get_current( ).
      CATCH cx_root.
        RETURN.
    ENDTRY.

    DATA(lr_result) = lv_query->get_query_result( ).

    DATA(iterator) = lr_result->get_iterator( ).
    CREATE OBJECT rv_result TYPE cl_crm_bol_entity_col.
    DATA(lo_result) = iterator->get_first( ).
    WHILE lo_result IS NOT INITIAL.
      DATA(lo_root) = lo_result->get_related_entity( 'SocialPostRel' ).
      rv_result->add( lo_root ).
      lo_result = iterator->get_next( ).
    ENDWHILE.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JERRY_TOOL=>GET_ROOT_BY_RESULT_ENTITY
* +-------------------------------------------------------------------------------------------------+
* | [--->] IR_RESULT                      TYPE REF TO CL_CRM_BOL_ENTITY
* | [<-()] RV_ROOT                        TYPE REF TO CL_CRM_BOL_ENTITY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_root_by_result_entity.
    rv_root = ir_result->get_related_entity( 'SocialPostRel' ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JERRY_TOOL=>GET_SAMPLE_BOL_ENTITY_BY_ID
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_ACCOUNT_ID                  TYPE        GENILT_ACCOUNT_ATTR-ACCOUNT_ID
* | [<-()] RV_ENTITY                      TYPE REF TO CL_CRM_BOL_ENTITY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_sample_bol_entity_by_id.
    DATA: lo_core            TYPE REF TO cl_crm_bol_core,
          lo_collection      TYPE REF TO if_bol_entity_col,
          lv_view_name       TYPE crmt_view_name,
          lv_query_name      TYPE crmt_ext_obj_name,
          lt_query_parameter TYPE crmt_name_value_pair_tab,
          ls_query_parameter LIKE LINE OF lt_query_parameter,
          lv_size            TYPE i.

    ls_query_parameter-name = 'ACCOUNT_ID'.
    ls_query_parameter-value = iv_account_id.
    APPEND ls_query_parameter TO lt_query_parameter.

    lo_core = cl_crm_bol_core=>get_instance( ).
    lo_core->load_component_set( 'JERRYT' ).
    lv_query_name = 'Jerry_AccountQuery'.

    TRY.
        lo_collection = lo_core->query(
            iv_query_name               = lv_query_name
            it_query_params             = lt_query_parameter
            iv_view_name                = lv_view_name ).
      CATCH cx_sy_arithmetic_error.
        WRITE:/ 'Error' .
    ENDTRY.

    lv_size = lo_collection->if_bol_bo_col~size( ).
    ASSERT lv_size = 1.

    rv_entity = lo_collection->get_first( ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JERRY_TOOL=>GET_SELECTED_POST_BY_EVENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_EVENT                       TYPE        STRING
* | [--->] IV_COL_WRAPPER                 TYPE REF TO CL_BSP_WD_COLLECTION_WRAPPER
* | [<-()] RV_RESULT                      TYPE REF TO CL_CRM_BOL_ENTITY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_selected_post_by_event.
    DATA:
      lv_index_str TYPE string,
      lv_idx       TYPE string,
      lv_index     TYPE i,
      lv_result    TYPE REF TO cl_crm_bol_entity.

    lv_index_str = iv_event.

    SHIFT lv_index_str UP TO '[' LEFT CIRCULAR.
    SHIFT lv_index_str BY 1 PLACES.
    WHILE lv_index_str(1) <> ']'.
      CONCATENATE lv_idx lv_index_str(1) INTO lv_idx.
      SHIFT lv_index_str BY 1 PLACES.
    ENDWHILE.

    lv_index = lv_idx.
    CHECK lv_index >= 0.
    lv_result ?= iv_col_wrapper->find( iv_index = lv_index ).

    CHECK lv_result IS NOT INITIAL.

    rv_result = lv_result->get_related_entity( 'SocialPostRel' ). "#EC NOTEXT
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JERRY_TOOL=>GET_SELECTED_ROOT_BY_EVENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_EVENT                       TYPE        STRING
* | [--->] IV_COL_WRAPPER                 TYPE REF TO CL_BSP_WD_COLLECTION_WRAPPER
* | [<-()] RV_RESULT                      TYPE REF TO CL_CRM_BOL_ENTITY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_selected_root_by_event.
    DATA:
      lv_index_str TYPE string,
      lv_idx       TYPE string,
      lv_index     TYPE i.

    lv_index_str = iv_event.

    SHIFT lv_index_str UP TO '[' LEFT CIRCULAR.
    SHIFT lv_index_str BY 1 PLACES.
    WHILE lv_index_str(1) <> ']'.
      CONCATENATE lv_idx lv_index_str(1) INTO lv_idx.
      SHIFT lv_index_str BY 1 PLACES.
    ENDWHILE.

    lv_index = lv_idx.
    CHECK lv_index >= 0.
    rv_result ?= iv_col_wrapper->find( iv_index = lv_index ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_JERRY_TOOL=>GET_SWITCH
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_STATUS                      TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_switch.
    DATA: lv_line TYPE zworkflowcontrol.

    SELECT SINGLE * INTO lv_line FROM zworkflowcontrol.
    CHECK sy-subrc = 0.
    rv_status = lv_line-status_on.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JERRY_TOOL=>INSERT_DL_ENTRY
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD insert_dl_entry.
    DATA: ls_entry TYPE bsp_dlc_settings.

    ls_entry-no_hidden = 'X'.
    ls_entry-client = '001'.

    INSERT bsp_dlc_settings FROM ls_entry.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JERRY_TOOL=>MODIFY_AND_SAVE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_BOL_ENTITY                  TYPE REF TO CL_CRM_BOL_ENTITY
* | [--->] IV_ATTR_NAME                   TYPE        STRING
* | [--->] IV_ATTR_VALUE                  TYPE        STRING
* | [<-()] RV_SUCCESS                     TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD modify_and_save.
    DATA:  lo_core        TYPE REF TO cl_crm_bol_core,
           lo_transaction TYPE REF TO if_bol_transaction_context,
           lv_success     TYPE abap_bool,
           lv_name        TYPE name_komp,
           lv_changed     TYPE abap_bool.

    lv_name = iv_attr_name.
    lo_core = cl_crm_bol_core=>get_instance( ).
    lo_transaction = lo_core->get_transaction( ).
    CHECK iv_bol_entity IS NOT INITIAL.
    iv_bol_entity->switch_to_change_mode( ).
    iv_bol_entity->set_property( iv_attr_name = lv_name iv_value = iv_attr_value ).
    lo_core->modify( ).
    CHECK lo_transaction->check_save_needed( ) = abap_true.
    CHECK lo_transaction->save( ) = abap_true.
    lo_transaction->commit( ).
    rv_success = abap_true.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JERRY_TOOL=>PARSE_JSON_TO_INTERNAL_TABLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<---] ET_NODE                        TYPE        TT_SORTED_NODE
* | [<---] EV_NODE_NUMBER                 TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD parse_json_to_internal_table.

    DATA lt_raw_node TYPE tt_node.

    CALL METHOD parse_json_to_raw_table
      EXPORTING
        iv_json          = iv_json
      IMPORTING
        et_node          = lt_raw_node
      EXCEPTIONS
        json_parse_error = 1
        OTHERS           = 2.

    ASSERT sy-subrc = 0.


    CALL METHOD sort_raw_table
      EXPORTING
        it_node        = lt_raw_node
      IMPORTING
        et_sorted_node = et_node
        ev_node_number = ev_node_number.


  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_JERRY_TOOL=>PARSE_JSON_TO_RAW_TABLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_JSON                        TYPE        STRING
* | [<---] ET_NODE                        TYPE        TT_NODE
* | [EXC!] JSON_PARSE_ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD parse_json_to_raw_table.
    DATA:
      node_wa TYPE ty_node.

    DATA(json) = cl_abap_codepage=>convert_to( iv_json ).
    DATA(reader) = cl_sxml_string_reader=>create( json ).

    TRY.
        DO.
          CLEAR node_wa.
          DATA(node) = reader->read_next_node( ).
          IF node IS INITIAL.
            EXIT.
          ENDIF.
          CASE node->type.
            WHEN if_sxml_node=>co_nt_element_open.
              DATA(open_element) = CAST if_sxml_open_element( node ).
              node_wa-node_type = gc_json_open_element.
              node_wa-prefix    = open_element->prefix.
              node_wa-name      = open_element->qname-name.
              node_wa-nsuri     = open_element->qname-namespace.
              DATA(attributes)  = open_element->get_attributes( ).
              APPEND node_wa TO et_node.
              LOOP AT attributes INTO DATA(attribute).
                node_wa-node_type = gc_json_attribute.
                node_wa-prefix    = attribute->prefix.
                node_wa-name      = attribute->qname-name.
                node_wa-nsuri     = attribute->qname-namespace.
                IF attribute->value_type = if_sxml_value=>co_vt_text.
                  node_wa-value = attribute->get_value( ).
                ELSEIF attribute->value_type =
                                   if_sxml_value=>co_vt_raw.
                  node_wa-value_raw = attribute->get_value_raw( ).
                ENDIF.
                APPEND node_wa TO et_node.
              ENDLOOP.
              CONTINUE.
            WHEN if_sxml_node=>co_nt_element_close.
              DATA(close_element) = CAST if_sxml_close_element( node ).
              node_wa-node_type   = gc_json_close_element.
              node_wa-prefix      = close_element->prefix.
              node_wa-name        = close_element->qname-name.
              node_wa-nsuri       = close_element->qname-namespace.
              APPEND node_wa TO et_node.
              CONTINUE.
            WHEN if_sxml_node=>co_nt_value.
              DATA(value_node) = CAST if_sxml_value_node( node ).
              node_wa-node_type   = gc_json_value.
              IF value_node->value_type = if_sxml_value=>co_vt_text.
                node_wa-value = value_node->get_value( ).
              ELSEIF value_node->value_type = if_sxml_value=>co_vt_raw.
                node_wa-value_raw = value_node->get_value_raw( ).
              ENDIF.
              APPEND node_wa TO et_node.
              CONTINUE.
            WHEN OTHERS.
              node_wa-node_type   = gc_json_error.
              APPEND node_wa TO et_node.
              EXIT.
          ENDCASE.
        ENDDO.
      CATCH cx_sxml_parse_error INTO DATA(parse_error).
        RAISE json_parse_error.
    ENDTRY.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_JERRY_TOOL=>POPULATE_POST_TABLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_SORTED_NODE                 TYPE        TT_SORTED_NODE
* | [--->] IV_NODE_NUMBER                 TYPE        I
* | [<---] ET_POST                        TYPE        TT_POST
* | [<---] EV_SOC_POST_INFO               TYPE        SMI_LASTPROCESSEDSOCIALPOST
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD populate_post_table.

    DATA: ls_node      LIKE LINE OF it_sorted_node,
          ls_post_line LIKE LINE OF et_post.

    DO iv_node_number TIMES.
      LOOP AT it_sorted_node INTO ls_node WHERE index = sy-index.
        CALL METHOD get_core_message
          EXPORTING
            is_json_item = ls_node
            iv_type      = 'P'
          CHANGING
            cs_post      = ls_post_line.

*Check max id and return it if necessary
        IF ev_soc_post_info IS INITIAL.
          ev_soc_post_info =  ls_post_line-external_uuid.
        ELSE.
          IF  ev_soc_post_info < ls_post_line-external_uuid.
            ev_soc_post_info =  ls_post_line-external_uuid.
          ENDIF.
        ENDIF.

      ENDLOOP.
*Append to post result table and hand over to manager class to write to DB
      IF ls_post_line IS NOT INITIAL.
        APPEND ls_post_line TO et_post.
      ENDIF.

    ENDDO.
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_JERRY_TOOL=>SORT_RAW_TABLE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_NODE                        TYPE        TT_NODE
* | [<---] ET_SORTED_NODE                 TYPE        TT_SORTED_NODE
* | [<---] EV_NODE_NUMBER                 TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD sort_raw_table.

    DATA:
      ls_node              TYPE ty_node,
      lv_level_counter     TYPE i VALUE 0,
      lv_attribute_name    TYPE string,
      lv_seperator         TYPE char1,
      ls_sorted_node       TYPE ty_sorted_node,
      lv_node_counter      TYPE i VALUE 1,
      lv_node_flag_counter TYPE i,
      lt_level_tab         TYPE tt_level,
      ls_level_tab         TYPE ty_level,
      lv_index             TYPE i,
      lv_temp_counter      TYPE i.

    FIELD-SYMBOLS <fs_level_tab> TYPE ty_level.

    LOOP AT it_node INTO ls_node.
*Check if open element, if yes increase level counter
      IF  ls_node-node_type = gc_json_open_element.
        lv_level_counter = lv_level_counter + 1.

*Check if it is new node, if yes increase node counter
        IF lv_node_flag_counter IS NOT INITIAL AND lv_level_counter = lv_node_flag_counter.
          lv_node_counter = lv_node_counter + 1.
        ENDIF.

*Add level indicator to level table in order to remember which level we are in
        CLEAR ls_level_tab.
        READ TABLE lt_level_tab INTO ls_level_tab WITH TABLE KEY level = lv_level_counter.
        IF ls_level_tab IS INITIAL.
          ls_level_tab-level = lv_level_counter.
          APPEND ls_level_tab TO lt_level_tab.
        ENDIF.
      ENDIF.

*Check if attribute
      IF  ls_node-node_type = gc_json_attribute.
*If no entry in our generated result table then me mark current level as the begining of each node
        IF et_sorted_node IS INITIAL.
          lv_node_flag_counter = lv_level_counter - 1.
        ENDIF.

        LOOP AT lt_level_tab ASSIGNING <fs_level_tab> WHERE level = lv_level_counter.
          <fs_level_tab>-indicator =  ls_node-value.
        ENDLOOP.
      ENDIF.


*Check if value
*-------------------------------------------------------------------------
*Add level indicator to level table in order to show hierachy node
*For instance if we have following node hieracy
*   -A
*     -a
*     -b
*we wil have following naming convertion in our generated table
*  A-a  &  A-b
*-------------------------------------------------------------------------
      IF  ls_node-node_type = gc_json_value.
        CLEAR lv_attribute_name.
        LOOP AT lt_level_tab ASSIGNING <fs_level_tab> FROM 0 TO lv_level_counter.
          IF <fs_level_tab>-indicator IS NOT INITIAL.
            CONCATENATE lv_attribute_name '-' <fs_level_tab>-indicator INTO lv_attribute_name.
          ENDIF.
        ENDLOOP.

        CLEAR: lv_seperator, lv_index.
        lv_seperator = lv_attribute_name+0(1).
        IF lv_seperator = '-'.
          lv_index = strlen( lv_attribute_name ) - 1.
          lv_attribute_name = lv_attribute_name+1(lv_index).
        ENDIF.

        IF lv_attribute_name IS NOT INITIAL.
          ls_sorted_node-attribute = lv_attribute_name.
          ls_sorted_node-value =  ls_node-value.
          ls_sorted_node-index = lv_node_counter.
          APPEND ls_sorted_node TO et_sorted_node.
        ENDIF.
        CLEAR: ls_sorted_node.
      ENDIF.

*Check if close element
      IF  ls_node-node_type = gc_json_close_element.
        lv_level_counter = lv_level_counter - 1.

*Remove level indicator from level table
        DESCRIBE TABLE lt_level_tab LINES lv_temp_counter.
        LOOP AT lt_level_tab ASSIGNING <fs_level_tab> FROM lv_level_counter + 1 TO lv_temp_counter.
          <fs_level_tab>-indicator = ''.
        ENDLOOP.
      ENDIF.
    ENDLOOP.

*Return total number of nodes
    ev_node_number = lv_node_counter.
  ENDMETHOD.
ENDCLASS.