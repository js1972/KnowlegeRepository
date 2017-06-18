class ZCL_DOCUMENT_UTILITY definition
  public
  final
  create public .

public section.

  class-methods GET_DISPLAY_VALUE
    importing
      !IO_ITERATOR type ref to IF_BOL_BO_COL_ITERATOR
    returning
      value(RV_VALUE) type STRING .
  class-methods OPEN_URL
    importing
      !IV_EVENT_ID type STRING
      !IO_COL_WRAPPER type ref to CL_BSP_WD_COLLECTION_WRAPPER
      !IO_WD_MANAGER type ref to IF_BSP_WD_WINDOW_MANAGER .
protected section.
private section.

  types:
    BEGIN OF ty_url_buffer,
            uuid TYPE /IPRO/TDOCMNT-docmnt,
            content TYPE /IPRO/TDOCMNT-content,
            docid TYPE /IPRO/TDOCMNT-docmnt_id,
            url TYPE string,
         END OF ty_url_buffer .
  types:
    tt_url_buffer TYPE STANDARD TABLE OF ty_url_buffer WITH KEY uuid .

  class-data ST_URL_BUFFER type TT_URL_BUFFER .

  class-methods FILL_BUFFER
    importing
      !IV_DOCGUID type CRMT_CT_INBOX_WF_BOR_ATTRIB-OBJKEY
    returning
      value(RV_VALUE) type STRING .
  class-methods GET_SELECTED_BY_EVENT
    importing
      !IV_EVENT type STRING
      !IV_COL_WRAPPER type ref to CL_BSP_WD_COLLECTION_WRAPPER
    returning
      value(RV_RESULT) type ref to CL_CRM_BOL_ENTITY .
  class-methods OPEN_URL_INTERNAL
    importing
      !IV_GUID type /IPRO/TDOCMNT-DOCMNT
      !IO_WD_MANAGER type ref to IF_BSP_WD_WINDOW_MANAGER .
ENDCLASS.



CLASS ZCL_DOCUMENT_UTILITY IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_DOCUMENT_UTILITY=>FILL_BUFFER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_DOCGUID                     TYPE        CRMT_CT_INBOX_WF_BOR_ATTRIB-OBJKEY
* | [<-()] RV_VALUE                       TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method FILL_BUFFER.
    DATA: ls_document TYPE /ipro/tdocmnt,
          lt_parameters   TYPE tihttpnvp,
          lv_url TYPE string.

    SELECT SINGLE * FROM /ipro/tdocmnt INTO ls_document WHERE docmnt  = iv_docguid.
    CHECK sy-subrc = 0.

    DATA(ls_line) = VALUE ihttpnvp( name = 'P_CONTENT' value = ls_document-content ).
    APPEND ls_line TO lt_parameters.
    DATA(lv_doc_id) = ls_document-docmnt_id.
    ls_line = VALUE ihttpnvp( name = 'P_OBJECTID' value = lv_doc_id ).
    APPEND ls_line TO lt_parameters.

    cl_wd_utilities=>construct_wd_url(
      EXPORTING
        application_name = '/IPRO/WD_DOCB'
        in_parameters    = lt_parameters
      IMPORTING
        out_absolute_url = lv_url ).

    SHIFT lv_doc_id LEFT DELETING LEADING '0'.

    DATA(ls_buffer) = VALUE ty_url_buffer( uuid  = iv_docguid content = ls_document-content
                                           docid = lv_doc_id  url     = lv_url ).
    APPEND ls_buffer TO st_url_buffer.
    CONCATENATE 'Content: ' ls_buffer-content ' Document ID: ' ls_buffer-docid INTO rv_value.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_DOCUMENT_UTILITY=>GET_DISPLAY_VALUE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IO_ITERATOR                    TYPE REF TO IF_BOL_BO_COL_ITERATOR
* | [<-()] RV_VALUE                       TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_DISPLAY_VALUE.
   data: lo_workitem TYPE REF TO cl_crm_bol_entity,
         ls_attr  TYPE CRMT_CT_INBOX_WF_BOR_ATTRIB.

   lo_workitem ?= io_iterator->get_current( ).
   CHECK lo_workitem IS NOT INITIAL.

   data(lo_leading) = cl_crm_uiu_ct_ib_ui_tools=>get_leading_object( lo_workitem ).
   CHECK lo_leading IS NOT INITIAL.
   lo_leading->get_properties( IMPORTING es_attributes = ls_attr ).
   CHECK ls_attr-objtype = '/IPRO/CL_WFL_DOCUMNT'.

   READ TABLE st_url_buffer ASSIGNING FIELD-SYMBOL(<buffer>) WITH KEY uuid = ls_attr-objkey.
   IF sy-subrc = 0.
      CONCATENATE 'Content: ' <buffer>-content ' Document ID: ' <buffer>-docid INTO rv_value.
      RETURN.
   ENDIF.

   rv_value = fill_buffer( iv_docguid = ls_attr-objkey ).

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_DOCUMENT_UTILITY=>GET_SELECTED_BY_EVENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_EVENT                       TYPE        STRING
* | [--->] IV_COL_WRAPPER                 TYPE REF TO CL_BSP_WD_COLLECTION_WRAPPER
* | [<-()] RV_RESULT                      TYPE REF TO CL_CRM_BOL_ENTITY
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_SELECTED_BY_EVENT.
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
  rv_result ?= iv_col_wrapper->find( iv_index = lv_index ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_DOCUMENT_UTILITY=>OPEN_URL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_EVENT_ID                    TYPE        STRING
* | [--->] IO_COL_WRAPPER                 TYPE REF TO CL_BSP_WD_COLLECTION_WRAPPER
* | [--->] IO_WD_MANAGER                  TYPE REF TO IF_BSP_WD_WINDOW_MANAGER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method OPEN_URL.
    DATA: ls_attr  TYPE CRMT_CT_INBOX_WF_BOR_ATTRIB.
    DATA(lo_entity) = get_selected_by_event( iv_event = iv_event_id iv_col_wrapper = io_col_wrapper ).
    CHECK lo_entity IS NOT INITIAL.

    data(lo_leading) = cl_crm_uiu_ct_ib_ui_tools=>get_leading_object( lo_entity ).
    CHECK lo_leading IS NOT INITIAL.
    lo_leading->get_properties( IMPORTING es_attributes = ls_attr ).

    open_url_internal( iv_guid = CONV #( ls_attr-objkey ) io_wd_manager = io_wd_manager ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Private Method ZCL_DOCUMENT_UTILITY=>OPEN_URL_INTERNAL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_GUID                        TYPE        /IPRO/TDOCMNT-DOCMNT
* | [--->] IO_WD_MANAGER                  TYPE REF TO IF_BSP_WD_WINDOW_MANAGER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method OPEN_URL_INTERNAL.

    DATA(lv_title) = cl_wd_utilities=>get_otr_text_by_alias( 'Document(to be approved) Preview' ). "#EC NOTEXT
    DATA(lr_popup) = io_wd_manager->create_popup(  iv_interface_view_name = 'GS_CMSRCH/CMDisplayContentWindow'
                                                   iv_usage_name          = 'GS_CMSRCH'
                                                   iv_title               = lv_title ).
    DATA(lr_cn)  = lr_popup->get_context_node( 'PARAMS' ).
    DATA(lr_obj) = lr_cn->collection_wrapper->get_current( ).

    READ TABLE st_url_buffer ASSIGNING FIELD-SYMBOL(<buffer>) WITH KEY uuid = iv_guid.
    CHECK sy-subrc = 0.

    DATA(ls_params) = VALUE crmt_gsurlpopup_params( url = <buffer>-url height = '1000' ).

    lr_obj->set_properties( ls_params ).
    lr_popup->set_display_mode( if_bsp_wd_popup=>C_DISPLAY_MODE_PLAIN ).
    lr_popup->set_window_width( 1000 ).
    lr_popup->set_window_height( 10000 ).
    lr_popup->open( ).
  endmethod.
ENDCLASS.