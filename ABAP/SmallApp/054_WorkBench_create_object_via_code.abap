*&---------------------------------------------------------------------*
*& Report  ZCREATE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT ZCREATE.
data: lr_tool TYPE REF TO ZCL_PRODUCT_WB_ACCESS,
      lr_state TYPE REF TO IF_WB_PROGRAM_STATE,
      lr_i_state TYPE REF TO CL_WB_ABSTRACT_TOOL_STATE,
      lr_container TYPE REF TO CL_WB_DATA_CONTAINER,
      lr_request type ref to CL_WB_REQUEST.

CREATE OBJECT lr_tool.
CREATE OBJECT lr_i_state
   EXPORTING
      p_parentnode_key = '$TMP'
      p_parentnode_type = 'K'.

CREATE  OBJECT lr_request
  EXPORTING
     p_object_type = 'Q0E'
     p_operation = 'CREATE'
     p_object_name = 'ZZ'
     p_object_state = lr_i_state.

call method lr_tool->IF_WB_PROGRAM~process_wb_request
      EXPORTING
              p_wb_request               = lr_request
              p_wb_program_state         = lr_state
              p_window_id                = 0
           CHANGING
              p_wb_data_container        = lr_container
           EXCEPTIONS
              action_cancelled           = swbm_c_er_action_cancelled
              error_occured              = swbm_c_er_error_occured
              object_not_found           = swbm_c_er_object_not_found
              operation_not_supported    = swbm_c_er_op_not_supported
              permission_failure         = swbm_c_er_permission_failure
              wrong_program_state        = swbm_c_er_wrong_program_state
              OTHERS                     = swbm_c_er_unknown_error.