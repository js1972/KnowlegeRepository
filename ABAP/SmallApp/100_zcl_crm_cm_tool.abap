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
    ls_file_info-mimetype = 'text/html'."'image/jpeg'.
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
        proxy_host         = 'PROXY.WDF.SAP.CORP'
        proxy_service      = '8080'
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
        "BREAK-POINT.
        WRITE: / 'error: ' , ev_message.
        RETURN.
   ENDIF.

   ev_data = lo_http_client->response->get_data( ).

   DATA: lv_length TYPE i.

   lv_length = xstrlen( ev_data ).

   WRITE: / 'data length: ' , lv_length.

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
        proxy_host         = 'PROXY.WDF.SAP.CORP'
        proxy_service      = '8080'
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
        "BREAK-POINT.
        WRITE: / 'error: ' , ev_message.
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