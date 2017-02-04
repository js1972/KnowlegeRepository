class ZCL_ZSERVICE_POC_MPC_EXT definition
  public
  inheriting from ZCL_ZSERVICE_POC_MPC
  create public .

public section.

  methods DEFINE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZSERVICE_POC_MPC_EXT IMPLEMENTATION.


  METHOD define.

    super->define( ).
    CHECK sy-uname = 'WANGJER'.

    DATA lo_annotation TYPE REF TO /iwbep/if_mgw_odata_annotation.
    DATA  lo_property TYPE REF TO /iwbep/if_mgw_odata_property.
    DATA  lo_entity_set TYPE REF TO /iwbep/if_mgw_odata_entity_set.

    lo_entity_set = model->get_entity_set( 'Z_C_Service_Order_View' ).

    lo_annotation = lo_entity_set->create_annotation( 'sap' ).

    lo_annotation->add( iv_key = 'semantics' iv_value = 'fixed-values').

    DATA(lo_entitytype) = model->get_entity_type( 'Z_C_Service_Order_ViewType' ).
    lo_entitytype->set_is_value_list( abap_true ).

    data(lo_txt_property) = model->get_entity_type( 'Z_C_Service_Order_ViewType' )->get_property( 'txt04' ).
    lo_txt_property->set_value_list( /iwbep/if_mgw_odata_property=>gcs_value_list_type_property-fixed_values ).

    data(lo_text_anno) = lo_txt_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' ).
    lo_text_anno->add( iv_key = 'text' iv_value = 'to_statusfixedvalue/status_text').

    lo_txt_property = model->get_entity_type( 'Z_C_Status_FixedvalueType' )->get_property( 'status_code' ).
    lo_txt_property->set_value_list( /iwbep/if_mgw_odata_property=>gcs_value_list_type_property-fixed_values ).

    lo_text_anno = lo_txt_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' ).
    lo_text_anno->add( iv_key = 'text' iv_value = 'status_text').

    "2016-04-21 17:04PM
     data:
        lo_entity_type    type ref to /iwbep/if_mgw_odata_entity_typ.

        lo_entity_type = model->get_entity_type( iv_entity_name = 'Z_C_Service_Order_ViewType').
        lo_property = lo_entity_type->get_property( iv_property_name = 'requested_start' ).
        lo_property->set_type_edm_datetime( ).

        data(lo_date_anno) = lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' ).
        lo_date_anno->add( iv_key = 'display-format' iv_value = 'Date').

        lo_property = lo_entity_type->get_property( iv_property_name = 'requested_end' ).
        lo_property->set_type_edm_datetime( ).

        lo_date_anno = lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' ).
        lo_date_anno->add( iv_key = 'display-format' iv_value = 'Date').
        "data(lo_label_anno) = lo_property->/iwbep/if_mgw_odata_annotatabl~create_annotation( 'sap' ).
        "lo_label_anno->add( iv_key = 'display-format' iv_value = 'Date').



  ENDMETHOD.
ENDCLASS.