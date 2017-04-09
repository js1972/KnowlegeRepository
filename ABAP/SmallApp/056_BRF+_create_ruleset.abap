*&---------------------------------------------------------------------*
*& Report  ZCREATE_RULESET
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
REPORT zcreate_ruleset.

DEFINE write_errors.
  IF &1 IS NOT INITIAL.
  LOOP AT &1 ASSIGNING <ls_message>.
  WRITE: <ls_message>-text.
  ENDLOOP.
  RETURN.
  ENDIF.
END-OF-DEFINITION.

DATA:   lv_app_id      TYPE if_fdt_types=>id,
        lv_func_id     TYPE if_fdt_types=>id,
        lv_cust_ele_id TYPE if_fdt_types=>id,
        lv_item_ele_id TYPE if_fdt_types=>id,
        lv_fina_ele_id TYPE if_fdt_types=>id,
        lv_shel_ele_id TYPE if_fdt_types=>id.

INITIALIZATION.
  lv_app_id = 'FA163E8EAB031EE48B847A9EF751D5F0'.
  lv_func_id = 'FA163E8EAB031EE48B847ADC6A96D5F0'.
  lv_cust_ele_id = 'FA163E8EAB031EE48B847ADC6A96F5F0'.
  lv_item_ele_id = 'FA163E8EAB031EE48B847ADC6A9715F0'.
  lv_fina_ele_id = 'FA163E8EAB031EE48B847ADC6A9775F0'.
  lv_shel_ele_id = 'FA163E8EAB031EE48B847ADC6A9755F0'.

START-OF-SELECTION.

  DATA: lo_ruleset     TYPE REF TO if_fdt_ruleset,
        lo_factory     TYPE REF TO if_fdt_factory,
        lts_rule       TYPE if_fdt_ruleset=>ts_rule,
        lts_variable   TYPE if_fdt_ruleset=>ts_variable,
        lt_message     TYPE if_fdt_types=>t_message,
        lv_boolean     TYPE abap_bool,
        lts_expression TYPE if_fdt_ruleset=>ts_init_expr.

  FIELD-SYMBOLS: <ls_message> TYPE if_fdt_types=>s_message.

  lo_factory = cl_fdt_factory=>if_fdt_factory~get_instance(
  iv_application_id = lv_app_id ).

  lo_ruleset ?= lo_factory->get_ruleset( ).
  lo_ruleset->if_fdt_transaction~enqueue( ).

  lo_ruleset->set_ruleset_switch( iv_switch = if_fdt_ruleset=>gc_switch_on ).

  lo_ruleset->if_fdt_admin_data~set_name( 'price_calculation_rules' ).

  lo_ruleset->if_fdt_admin_data~set_texts( iv_short_text = 'price calc. rules'
                            iv_text = 'price calculation rules' ).

  lo_ruleset->set_function_restriction(
   iv_function_id = lv_func_id ).

* WE NEED TO CREATE RULESET VARIABLES AND
* ASSIGNED TO lts_variable

* Ruleset variables extend the function context,
* but within the scope of the ruleset only. they are also based on data objects.
  DATA: lo_element      TYPE REF TO if_fdt_element,
        ls_variable     TYPE if_fdt_ruleset=>s_variable,
        lv_pro_discount TYPE if_fdt_types=>id,
        lv_cus_discount TYPE if_fdt_types=>id.

  lo_element ?= lo_factory->get_data_object( iv_data_object_type =
  if_fdt_constants=>gc_data_object_type_element ).

  lo_element->if_fdt_transaction~enqueue( ).
  lo_element->if_fdt_admin_data~set_name( 'customer_discount' ).
  lo_element->if_fdt_admin_data~set_texts( iv_short_text = 'Customer Discount' ).
* SET type for customer_discount: NUMBER
  lo_element->set_element_type( if_fdt_constants=>gc_element_type_number ).
  lo_element->set_element_type_attributes(
      iv_length        = 3
      iv_decimals      = 2
      iv_only_positive = abap_true ).
  ls_variable-position = 1.

  ls_variable-data_object_id = lo_element->mv_id.
  INSERT ls_variable INTO TABLE lts_variable.

  lv_cus_discount = lo_element->mv_id.
* CREATE RULE VARIABLE promotion_discount
  lo_element ?= lo_factory->get_data_object(
  iv_data_object_type = if_fdt_constants=>gc_data_object_type_element ).

  lo_element->if_fdt_transaction~enqueue( ).
  lo_element->if_fdt_admin_data~set_name( 'promotion_discount' ).
  lo_element->if_fdt_admin_data~set_texts(
       iv_short_text = 'promotion discount' ).
  lo_element->set_element_type( if_fdt_constants=>gc_element_type_number ).
  lo_element->set_element_type_attributes(
        iv_length        = 3
        iv_decimals      = 2
        iv_only_positive = abap_true ).
  ls_variable-position = 2.
  ls_variable-data_object_id = lo_element->mv_id.
  INSERT ls_variable INTO TABLE lts_variable.
  lv_pro_discount = lo_element->mv_id.

* THESE TWO VARIABLES COULD ONLY BE USED WITHIN RULESET

  lo_ruleset->set_ruleset_variables( lts_variable ).

* CREATE DECISION TABLE

  DATA: lo_decision_table TYPE REF TO if_fdt_decision_table,
        lts_column        TYPE if_fdt_decision_table=>ts_column,
        lts_table_data    TYPE if_fdt_decision_table=>ts_table_data,
        ls_expression     TYPE if_fdt_ruleset=>s_init_expr.

  lo_decision_table ?= lo_factory->get_expression( iv_expression_type_id =
  if_fdt_constants=>gc_exty_decision_table ).

  lo_decision_table->if_fdt_transaction~enqueue( ).
  lo_decision_table->if_fdt_admin_data~set_name( 'calc_customer_discount' ).

  lo_decision_table->if_fdt_admin_data~set_texts(
   iv_short_text = 'calc. cust. discount'
   iv_text       = 'calculate customer discount' ).

* Code for table definition <<<lts_column>>> to be inserted here

  DATA: ls_column TYPE if_fdt_decision_table=>s_column.
  ls_column-col_no = 1. "customer
  ls_column-object_id = lv_cust_ele_id.
  ls_column-is_result = abap_false.
  INSERT ls_column INTO TABLE lts_column.
  ls_column-col_no = 2. "item
  ls_column-object_id = lv_item_ele_id.
  INSERT ls_column INTO TABLE lts_column.

  ls_column-col_no = 3. "customer discount
  ls_column-object_id = lv_cus_discount.
  ls_column-is_result = abap_true.
  INSERT ls_column INTO TABLE lts_column.

  lo_decision_table->set_columns( lts_column ).

* SET RESULT DATA OBJECT OF DECISION TABLE TO RULE VARIABLE WE JUST CREATE
  lo_decision_table->if_fdt_expression~set_result_data_object(
    lv_cus_discount ).

*  ls_expression-position = 1.
*  ls_expression-id = lo_decision_table->mv_id.
*  ls_expression-change_mode =
*  if_fdt_ruleset=>gc_change_mode_update.
*  INSERT ls_expression INTO TABLE lts_expression.

* Code for table content <<<lts_table_data>>> to be inserted here

  DATA: ls_range      TYPE if_fdt_range=>s_range,
        ls_table_data TYPE if_fdt_decision_table=>s_table_data.
  FIELD-SYMBOLS <lv_number> TYPE if_fdt_types=>element_number.

  ls_range-position = 1.
  ls_range-sign = if_fdt_range=>gc_sign_include.
  ls_range-option = if_fdt_range=>gc_option_equal.
  ls_table_data-col_no = 1. "start of row 1
  ls_table_data-row_no = 1.

  GET REFERENCE OF 'sap' INTO ls_range-r_low_value.
  INSERT ls_range INTO TABLE ls_table_data-ts_range.
  INSERT ls_table_data INTO TABLE lts_table_data.

* ROW1, COLUMN2
  CLEAR ls_table_data-ts_range.
  ls_table_data-col_no = 2.
  ls_table_data-row_no = 1.
  GET REFERENCE OF 'ballpen' INTO ls_range-r_low_value.
  INSERT ls_range INTO TABLE ls_table_data-ts_range.
  INSERT ls_table_data INTO TABLE lts_table_data.

* ROW1, COLUMN3
  CLEAR ls_table_data-ts_range.
  ls_table_data-col_no = 3.
  ls_table_data-row_no = 1.
  CREATE DATA ls_table_data-r_value TYPE if_fdt_types=>element_number.
  ASSIGN ls_table_data-r_value->* TO <lv_number>.
  <lv_number> = '0.15'.
  INSERT ls_table_data INTO TABLE lts_table_data.
* ROW2, COLUMN1
  CLEAR ls_table_data-r_value.
  ls_table_data-col_no = 1. "start of row 2
  ls_table_data-row_no = 2.
  GET REFERENCE OF 'sap' INTO ls_range-r_low_value.
  INSERT ls_range INTO TABLE ls_table_data-ts_range.
  INSERT ls_table_data INTO TABLE lts_table_data.
* ROW2, COLUMN2
  CLEAR ls_table_data-ts_range.
  ls_table_data-col_no = 2.
  ls_table_data-row_no = 2.
  GET REFERENCE OF 'pencil' INTO ls_range-r_low_value.
  INSERT ls_range INTO TABLE ls_table_data-ts_range.
  INSERT ls_table_data INTO TABLE lts_table_data.
* ROW2, COLUMN3
  CLEAR ls_table_data-ts_range.
  ls_table_data-col_no = 3.
  ls_table_data-row_no = 2.
  CREATE DATA ls_table_data-r_value TYPE if_fdt_types=>element_number.
  ASSIGN ls_table_data-r_value->* TO <lv_number>.
  <lv_number> = '0.12'.
  INSERT ls_table_data INTO TABLE lts_table_data.
* ROW3, COLUMN3????????????????
  CLEAR ls_table_data-r_value.
  ls_table_data-col_no = 3. "start of row 3
  ls_table_data-row_no = 3.
  CREATE DATA ls_table_data-r_value TYPE if_fdt_types=>element_number.
  ASSIGN ls_table_data-r_value->* TO <lv_number>.
  <lv_number> = '0'.

  INSERT ls_table_data INTO TABLE lts_table_data.
  lo_decision_table->set_table_data( lts_table_data ).

  ls_expression-position = 1.
  ls_expression-id = lo_decision_table->mv_id.
  ls_expression-change_mode = if_fdt_ruleset=>gc_change_mode_update.
  INSERT ls_expression INTO TABLE lts_expression.

* Create second decision table for promotion
  lo_decision_table ?= lo_factory->get_expression( iv_expression_type_id =
       if_fdt_constants=>gc_exty_decision_table ).
  lo_decision_table->if_fdt_transaction~enqueue( ).
  lo_decision_table->if_fdt_admin_data~set_name( 'calc_promotion_discount' ).
  lo_decision_table->if_fdt_admin_data~set_texts(
      iv_short_text = 'calc. pro. discount'
      iv_text       = 'calculate promotion discount' ).
* set column for promotion decision table
  CLEAR: lts_column.
  ls_column-col_no = 1. "customer
  ls_column-object_id = lv_cust_ele_id.
  ls_column-is_result = abap_false.
  INSERT ls_column INTO TABLE lts_column.
  ls_column-col_no = 2. "item
  ls_column-object_id = lv_item_ele_id.
  INSERT ls_column INTO TABLE lts_column.

  ls_column-col_no = 3. "customer discount
  ls_column-object_id = lv_pro_discount.
  ls_column-is_result = abap_true.
  INSERT ls_column INTO TABLE lts_column.
  lo_decision_table->set_columns( lts_column ).
  lo_decision_table->if_fdt_expression~set_result_data_object(
  lv_pro_discount ). "promotion discount
* code for table content (lts_table_data) to be inserted here

  CLEAR: ls_range, lts_table_data, ls_table_data.

  ls_range-position = 1.
  ls_range-sign = if_fdt_range=>gc_sign_include.
  ls_range-option = if_fdt_range=>gc_option_equal.
  ls_table_data-col_no = 1. "start of row 1
  ls_table_data-row_no = 1.

  GET REFERENCE OF 'oracle' INTO ls_range-r_low_value.
  INSERT ls_range INTO TABLE ls_table_data-ts_range.
  INSERT ls_table_data INTO TABLE lts_table_data.

* ROW1, COLUMN2
  CLEAR ls_table_data-ts_range.
  ls_table_data-col_no = 2.
  ls_table_data-row_no = 1.
  GET REFERENCE OF 'notebook' INTO ls_range-r_low_value.
  INSERT ls_range INTO TABLE ls_table_data-ts_range.
  INSERT ls_table_data INTO TABLE lts_table_data.

* ROW1, COLUMN3
  CLEAR ls_table_data-ts_range.
  ls_table_data-col_no = 3.
  ls_table_data-row_no = 1.
  CREATE DATA ls_table_data-r_value TYPE if_fdt_types=>element_number.
  ASSIGN ls_table_data-r_value->* TO <lv_number>.
  <lv_number> = '0.34'.
  INSERT ls_table_data INTO TABLE lts_table_data.
* ROW2, COLUMN1
  CLEAR ls_table_data-r_value.
  ls_table_data-col_no = 1. "start of row 2
  ls_table_data-row_no = 2.
  GET REFERENCE OF 'oracle' INTO ls_range-r_low_value.
  INSERT ls_range INTO TABLE ls_table_data-ts_range.
  INSERT ls_table_data INTO TABLE lts_table_data.
* ROW2, COLUMN2
  CLEAR ls_table_data-ts_range.
  ls_table_data-col_no = 2.
  ls_table_data-row_no = 2.
  GET REFERENCE OF 'glue' INTO ls_range-r_low_value.
  INSERT ls_range INTO TABLE ls_table_data-ts_range.
  INSERT ls_table_data INTO TABLE lts_table_data.
* ROW2, COLUMN3
  CLEAR ls_table_data-ts_range.
  ls_table_data-col_no = 3.
  ls_table_data-row_no = 2.
  CREATE DATA ls_table_data-r_value TYPE if_fdt_types=>element_number.
  ASSIGN ls_table_data-r_value->* TO <lv_number>.
  <lv_number> = '0.52'.
  INSERT ls_table_data INTO TABLE lts_table_data.
* ROW3, COLUMN3????????????????
  CLEAR ls_table_data-r_value.
  ls_table_data-col_no = 3. "start of row 3
  ls_table_data-row_no = 3.
  CREATE DATA ls_table_data-r_value TYPE if_fdt_types=>element_number.
  ASSIGN ls_table_data-r_value->* TO <lv_number>.
  <lv_number> = '0'.

  INSERT ls_table_data INTO TABLE lts_table_data.
  lo_decision_table->set_table_data( lts_table_data ).

  ls_expression-position = 2.
  ls_expression-id = lo_decision_table->mv_id.
  ls_expression-change_mode = if_fdt_ruleset=>gc_change_mode_update.
  INSERT ls_expression INTO TABLE lts_expression.

  lo_ruleset->set_ruleset_initializations( lts_expression ).
* TODO: code for rules (lts_rule) to be inserted here

  DATA: lo_rule             TYPE REF TO if_fdt_rule,
        ls_rule             TYPE if_fdt_ruleset=>s_rule,
        ls_cond_range       TYPE if_fdt_range=>s_param_range,
        ls_rule_expr        TYPE if_fdt_rule=>s_expression,
        lt_rule_expr        TYPE if_fdt_rule=>t_expression,
        lv_formula_cus_disc TYPE if_fdt_types=>id,
        lv_formula_pro_disc TYPE if_fdt_types=>id.

  lo_rule ?= lo_factory->get_expression(
  iv_expression_type_id = if_fdt_constants=>gc_exty_rule ).
  lo_rule->if_fdt_transaction~enqueue( ).
  lo_rule->if_fdt_admin_data~set_texts( iv_text = 'apply discount' ).
* promotion discount > cusomter discount
  CLEAR ls_range.
  ls_cond_range-parameter_id = lv_pro_discount.
  ls_range-position = 1.
  ls_range-sign = if_fdt_range=>gc_sign_include.
  ls_range-option = if_fdt_range=>gc_option_greater.
  ls_range-low = lv_cus_discount.
  INSERT ls_range INTO TABLE ls_cond_range-ts_range.

  lo_rule->set_condition_range( ls_cond_range ).
*TODO define formulas, insert missing code later

  DATA: lo_formula TYPE REF TO if_fdt_formula,
        lv_formula TYPE string.

  lo_formula ?= lo_factory->get_expression(
  iv_expression_type_id = if_fdt_constants=>gc_exty_formula ).

  lo_formula->if_fdt_transaction~enqueue( ).
  lo_formula->if_fdt_admin_data~set_name( 'apply_promotion_discount' ).

  lo_formula->if_fdt_admin_data~set_texts(
      iv_short_text = 'apply prom. discount'
      iv_text       = 'apply promotion discount' ).

  lo_formula->if_fdt_expression~set_result_data_object(
   lv_fina_ele_id ). "final price

* Final Price = Shelf Price / ( 1 + Promotion Discount )
*  lv_formula = ‘00505683359d02ee98fc41ef3591caa8’ &&
  lv_formula = lv_shel_ele_id &&
  ` / ( 1 + ` && lv_pro_discount && ` )`.

  lo_formula->set_formula( lv_formula ).
  lv_formula_pro_disc = lo_formula->mv_id.

* The second formula, which will calculate the customer discount
  lo_formula ?= lo_factory->get_expression(
  iv_expression_type_id = if_fdt_constants=>gc_exty_formula ).

  lo_formula->if_fdt_transaction~enqueue( ).
  lo_formula->if_fdt_admin_data~set_name( 'apply_customer_discount' ).

  lo_formula->if_fdt_admin_data~set_texts(
      iv_short_text = 'apply cust. discount'
      iv_text       = 'apply customer discount' ).

  lo_formula->if_fdt_expression~set_result_data_object(
   lv_fina_ele_id ). "final price

  lv_formula = lv_shel_ele_id &&
  ` / ( 1 + ` && lv_cus_discount && ` )`.

  lo_formula->set_formula( lv_formula ).
  lv_formula_cus_disc = lo_formula->mv_id.

  ls_rule_expr-position = 1.
  ls_rule_expr-change_mode = if_fdt_rule=>gc_change_mode_update.
  ls_rule_expr-expression = lv_formula_pro_disc.
  INSERT ls_rule_expr INTO TABLE lt_rule_expr.

  lo_rule->set_true_action_extended( it_expression = lt_rule_expr ).

  CLEAR lt_rule_expr.
  ls_rule_expr-expression = lv_formula_cus_disc.
  INSERT ls_rule_expr INTO TABLE lt_rule_expr.
  lo_rule->set_false_action_extended( it_expression = lt_rule_expr ).

  ls_rule-position = 1.
  ls_rule-rule_id = lo_rule->mv_id.
  ls_rule-switch = if_fdt_ruleset=>gc_switch_on.
  INSERT ls_rule INTO TABLE lts_rule.

  lo_ruleset->set_rules( lts_rule ).

  WRITE: / 'calling check logic...'.
*  lt_message = lo_ruleset->if_fdt_transaction~check( iv_deep = abap_true ).
*  write_errors lt_message.

  WRITE: / 'ruleset check passed, ready for activation'.
  lo_ruleset->if_fdt_transaction~activate(
     EXPORTING
        iv_deep              = abap_true
     IMPORTING
        et_message           = lt_message
        ev_activation_failed = lv_boolean ).
  write_errors lt_message.
  lo_ruleset->if_fdt_transaction~save( EXPORTING iv_deep = abap_true ).

  lo_ruleset->if_fdt_transaction~dequeue(
  EXPORTING iv_deep = abap_true ).

  WRITE: / 'Rule set created successfully'.