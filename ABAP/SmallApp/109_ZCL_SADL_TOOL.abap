class ZCL_SADL_TOOL definition
  public
  final
  create public .

public section.

  methods GET_METADATA_BY_SRV_NAME
    importing
      !IV_SRV_NAME type STRING
    returning
      value(RO_META_MODEL) type ref to /IWBEP/IF_MGW_ODATA_RE_MODEL .
  methods GET_VIEW_CONSUMPTION_INFO
    importing
      !IV_VIEW_NAME type STRING
    returning
      value(RO_INFO) type IF_SADL_ENTITY_CONSUMP_INFO=>TY_CONSUMPTION_INFORMATION .
  methods GET_VIEW_ENTITIES
    importing
      !IV_VIEW_NAME type STRING
    returning
      value(RT_ENTITIES) type IF_SADL_ENTITY=>TT_ENTITIES .
  methods GET_MODEL_BY_SRV_NAME
    importing
      !IV_SRV_NAME type /IWBEP/MED_GRP_TECHNICAL_NAME
    exporting
      !ET_OBJECT_MODELS type /IWBEP/T_OBJECT_MODEL
      !ET_MSG_CONTAINER type /IWBEP/T_MESSAGE_CONTAINER
      !ES_MSG_CONTAINER_H type /IWBEP/S_MESSAGE_CONTAINER_H
      !ES_MODEL_USAGE type /IWBEP/S_MED_MDL_USAGE .
  methods GET_LAST_MODIFIED
    importing
      !IV_VIEW_NAME type STRING
    returning
      value(RV_LAST_MODIFIED) type TIMESTAMP .
  methods GET_SADL_DEFINITION
    importing
      !IV_VIEW_NAME type STRING
    returning
      value(RS_SADL_DEFINITION) type IF_SADL_TYPES=>TY_SADL_DEFINITION .
protected section.
private section.

  methods GET_MP_BY_VIEW_NAME
    importing
      !IV_VIEW_NAME type STRING
    returning
      value(RO_MP) type ref to CL_SADL_MP_ENTITY_EXPOSURE .
ENDCLASS.



CLASS ZCL_SADL_TOOL IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SADL_TOOL->GET_LAST_MODIFIED
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_VIEW_NAME                   TYPE        STRING
* | [<-()] RV_LAST_MODIFIED               TYPE        TIMESTAMP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_last_modified.
    DATA lt_paths TYPE string_table.

    DATA(lv_path) = 'CDS~' && iv_view_name.

    APPEND lv_path TO lt_paths.
    DATA: lo_mp TYPE REF TO cl_sadl_mp_entity_exposure.

    lo_mp = CAST #( NEW cl_sadl_mp_entity_exposure( it_paths = lt_paths
                   iv_timestamp = 20160319014636 iv_expose_associations = abap_true ) ).

    cl_sadl_entity_mp_registry=>register_mp( lo_mp ).
    rv_last_modified = cl_sadl_entity_load_handler=>get_latest_timestamp( lo_mp ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SADL_TOOL->GET_METADATA_BY_SRV_NAME
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SRV_NAME                    TYPE        STRING
* | [<-()] RO_META_MODEL                  TYPE REF TO /IWBEP/IF_MGW_ODATA_RE_MODEL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_METADATA_BY_SRV_NAME.
   data(lo_metadata_provider) = /iwbep/cl_mgw_med_provider=>get_med_provider( ).

   ro_meta_model ?= lo_metadata_provider->get_service_metadata(
              iv_internal_service_name    = conv #( iv_srv_name )
              iv_internal_service_version = '0001'
            ).

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SADL_TOOL->GET_MODEL_BY_SRV_NAME
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_SRV_NAME                    TYPE        /IWBEP/MED_GRP_TECHNICAL_NAME
* | [<---] ET_OBJECT_MODELS               TYPE        /IWBEP/T_OBJECT_MODEL
* | [<---] ET_MSG_CONTAINER               TYPE        /IWBEP/T_MESSAGE_CONTAINER
* | [<---] ES_MSG_CONTAINER_H             TYPE        /IWBEP/S_MESSAGE_CONTAINER_H
* | [<---] ES_MODEL_USAGE                 TYPE        /IWBEP/S_MED_MDL_USAGE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_MODEL_BY_SRV_NAME.

    CALL FUNCTION '/IWBEP/FM_MGW_GET_OBJ_MODELS'
      EXPORTING
       IV_LANGUAGE                    = 'E'
       IV_SERVICE_GROUP_NAME          = iv_srv_name
       IV_SERVICE_GROUP_VERSION       = '0001'
       "IV_CONTEXT                     =
       IV_INCLUDE_MODEL_USAGE         = 'X'
     IMPORTING
       RT_OBJECT_MODELS               = eT_OBJECT_MODELS
       ET_MSG_CONTAINER               = ET_MSG_CONTAINER
       ES_MSG_CONTAINER_H             = ES_MSG_CONTAINER_H
       ES_MODEL_USAGE                 = ES_MODEL_USAGE.
              .

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_SADL_TOOL->GET_MP_BY_VIEW_NAME
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_VIEW_NAME                   TYPE        STRING
* | [<-()] RO_MP                          TYPE REF TO CL_SADL_MP_ENTITY_EXPOSURE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_MP_BY_VIEW_NAME.
     DATA: lt_paths TYPE string_table.

    " APPEND | { `CDS~Z_C_Service_Order_View` CASE = UPPER }| TO lt_paths.
    APPEND |{ `CDS~` && iv_view_name case = upper }| TO lt_paths.
    DATA: lo_mp TYPE REF TO cl_sadl_mp_entity_exposure.

    lo_mp = CAST #( NEW cl_sadl_mp_entity_exposure( it_paths = lt_paths
                   "iv_timestamp = 20160319014636
                   iv_expose_associations = abap_true ) ).

    ro_mp = lo_mp.

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SADL_TOOL->GET_SADL_DEFINITION
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_VIEW_NAME                   TYPE        STRING
* | [<-()] RS_SADL_DEFINITION             TYPE        IF_SADL_TYPES=>TY_SADL_DEFINITION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_SADL_DEFINITION.

    DATA: lt_paths TYPE string_table,
          lo_Context TYPE REF TO IF_BSA_SADL_MP_CONTEXT.
    DATA: ls_sadl_definition_orig TYPE if_sadl_types=>ty_sadl_definition.

    " APPEND | { `CDS~Z_C_Service_Order_View` CASE = UPPER }| TO lt_paths.
    APPEND |{ `CDS~` && iv_view_name case = upper }| TO lt_paths.
    DATA: lo_mp TYPE REF TO cl_sadl_mp_entity_exposure.

    lo_mp = CAST #( NEW cl_sadl_mp_entity_exposure( it_paths = lt_paths
                   "iv_timestamp = 20160319014636
                   iv_expose_associations = abap_true ) ).

    "cl_sadl_entity_mp_registry=>register_mp( lo_mp ).
    lo_context ?= lo_mp.

    lo_context->get_sadl_definition( IMPORTING
         es_sadl_definition = rs_sadl_definition ).
    "DATA(rv_last_modified) = cl_sadl_entity_load_handler=>get_latest_timestamp( lo_mp ).

  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SADL_TOOL->GET_VIEW_CONSUMPTION_INFO
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_VIEW_NAME                   TYPE        STRING
* | [<-()] RO_INFO                        TYPE        IF_SADL_ENTITY_CONSUMP_INFO=>TY_CONSUMPTION_INFORMATION
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_view_consumption_info.
    ro_info = cl_sadl_entity_factory=>get_instance(
                )->get_entity_consumption_info( iv_id   = CONV #( iv_view_name )
                                                iv_type = 'CDS' )->get_consumption_information( ).
  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_SADL_TOOL->GET_VIEW_ENTITIES
* +-------------------------------------------------------------------------------------------------+
* | [--->] IV_VIEW_NAME                   TYPE        STRING
* | [<-()] RT_ENTITIES                    TYPE        IF_SADL_ENTITY=>TT_ENTITIES
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method GET_VIEW_ENTITIES.
    data(lo_mp) = GET_MP_BY_VIEW_NAME( iv_view_name ).

    data(lo_common_runtime) = NEW cl_sadl_gw_odata_runtime( ).
    data(lo_sadl_api) = cl_sadl_entity_api_factory=>create( CAST #( lo_mp ) ).

    CALL METHOD lo_sadl_api->get_entities
      IMPORTING
        et_entities = rt_entities.


  endmethod.
ENDCLASS.