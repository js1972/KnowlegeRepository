class ZCL_AXT_CUSTOM_BEHAVIOR definition
  public
  inheriting from CL_AXT_ABST_BEHAVIOR_HDLR
  final
  create public
  shared memory enabled .

public section.

  methods IF_AXT_BEHAVIOR_HANDLER~GET_BEHAVIOR_TYPE
    redefinition .
  methods IF_AXT_BEHAVIOR_HANDLER~GET_COMPATIBLE_DATATYPES
    redefinition .
  methods IF_AXT_BEHAVIOR_HANDLER~IS_SUPPORTED
    redefinition .
  methods IF_AXT_DATATYPE_HANDLER~ADJUST_GET_P
    redefinition .
  methods IF_AXT_DATATYPE_HANDLER~ADJUST_SET
    redefinition .
protected section.
  PRIVATE SECTION.
*"* private components of class ZCL_AXT_CUSTOM_BEHAVIOR
*"* do not include other source files here!!!
ENDCLASS.



CLASS ZCL_AXT_CUSTOM_BEHAVIOR IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_AXT_CUSTOM_BEHAVIOR->IF_AXT_BEHAVIOR_HANDLER~GET_BEHAVIOR_TYPE
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RV_BEHAVIOR_TYPE               TYPE        AXT_FIELD_BEHAVIOR_TYPE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD IF_AXT_BEHAVIOR_HANDLER~GET_BEHAVIOR_TYPE.
    rv_behavior_type = 'ZAXT_BEHAVIOR'.
  ENDMETHOD.                    "IF_AXT_BEHAVIOR_HANDLER~GET_BEHAVIOR_TYPE


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_AXT_CUSTOM_BEHAVIOR->IF_AXT_BEHAVIOR_HANDLER~GET_COMPATIBLE_DATATYPES
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RT_DATATYPES                   TYPE        AXTT_FIELD_DATA_TYPE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD IF_AXT_BEHAVIOR_HANDLER~GET_COMPATIBLE_DATATYPES.
    APPEND 'CHAR' TO rt_datatypes.
    APPEND 'STRING' TO rt_datatypes.
  ENDMETHOD.                    "IF_AXT_BEHAVIOR_HANDLER~GET_COMPATIBLE_DATATYPES


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_AXT_CUSTOM_BEHAVIOR->IF_AXT_BEHAVIOR_HANDLER~IS_SUPPORTED
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_BO_PART                     TYPE        AXTT_EXT_BO_PART(optional)
* | [--->] IT_SUPPORTED_UI_FRAMEWORKS     TYPE        AXTT_UI_FRAMEWORK(optional)
* | [--->] IV_EXTENSION_TYPE              TYPE        AXT_EXTENSION_TYPE
* | [--->] IV_BOL_REGISTERED              TYPE        AXT_BOOLEAN (default =ABAP_TRUE)
* | [--->] IV_RENDERING_TABLE_ONLY        TYPE        AXT_BOOLEAN (default =ABAP_FALSE)
* | [--->] IV_RENDERING_TABLE_POSSIBLE    TYPE        AXT_BOOLEAN (default =ABAP_TRUE)
* | [--->] IV_TRANSIENT_CALCULATE_SET     TYPE        AXT_BOOLEAN (default =ABAP_FALSE)
* | [--->] IV_MANUAL_DATA_ELEMENT_SET     TYPE        AXT_BOOLEAN (default =ABAP_FALSE)
* | [<-()] RV_SUPPORTED                   TYPE        AXT_BOOLEAN
* +--------------------------------------------------------------------------------------</SIGNATURE>
method IF_AXT_BEHAVIOR_HANDLER~IS_SUPPORTED.


  RV_SUPPORTED = abap_true.
endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_AXT_CUSTOM_BEHAVIOR->IF_AXT_DATATYPE_HANDLER~ADJUST_GET_P
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_FIELD                       TYPE        AXTS_RUNTIME_EXT_FIELD
* | [--->] IV_COMPONENT                   TYPE        STRING
* | [--->] IO_CURRENT                     TYPE REF TO IF_BOL_BO_PROPERTY_ACCESS(optional)
* | [--->] IV_PROPERTY                    TYPE        STRING
* | [--->] IV_DISPLAY_MODE                TYPE        ABAP_BOOL
* | [--->] IV_ORIGINAL_VALUE              TYPE        STRING
* | [--->] IV_IS_TABLE                    TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [--->] IV_IS_SEARCH                   TYPE        ABAP_BOOL (default =ABAP_FALSE)
* | [<-()] RV_VALUE                       TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD IF_AXT_DATATYPE_HANDLER~ADJUST_GET_P.

    CASE iv_property.
      WHEN if_bsp_wd_model_setter_getter=>fp_fieldtype.
        IF iv_is_table = abap_true OR iv_is_search = abap_true.
          rv_value = cl_bsp_dlc_view_descriptor=>field_type_input.
        ELSE.
          rv_value = cl_bsp_dlc_view_descriptor=>field_type_textarea.
        ENDIF.
      WHEN if_bsp_wd_model_setter_getter=>fp_textarea_rows.
        rv_value = 10.
      WHEN OTHERS.
        rv_value = super->if_axt_datatype_handler~adjust_get_p(
           is_field          = is_field
           iv_component      = iv_component
           io_current        = io_current
           iv_property       = iv_property
           iv_display_mode   = iv_display_mode
           iv_original_value = iv_original_value ).
    ENDCASE.
  ENDMETHOD.                    "IF_AXT_DATATYPE_HANDLER~ADJUST_GET_P


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_AXT_CUSTOM_BEHAVIOR->IF_AXT_DATATYPE_HANDLER~ADJUST_SET
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_FIELD                       TYPE        AXTS_RUNTIME_EXT_FIELD
* | [--->] IV_ATTRIBUTE_PATH              TYPE        STRING
* | [--->] IV_COMPONENT                   TYPE        STRING
* | [--->] IO_CURRENT                     TYPE REF TO IF_BOL_BO_PROPERTY_ACCESS
* | [--->] IV_UI_VALUE                    TYPE        STRING
* | [--->] IT_FORM_FIELDS                 TYPE        TIHTTPNVP(optional)
* | [<-->] CV_VALUE                       TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
method IF_AXT_DATATYPE_HANDLER~ADJUST_SET.
DATA: tsl TYPE timestampl,
      lv_zone type TZONREF-TZONE value 'UTC',
      lv_time TYPE string.

GET TIME STAMP FIELD tsl.

lv_time = | Edited by: { tsl TIMESTAMP = ISO
                   TIMEZONE = lv_zone }|.
 CONCATENATE cv_value lv_time INTO cv_value SEPARATED BY cl_abap_char_utilities=>cr_lf.
endmethod.
ENDCLASS.