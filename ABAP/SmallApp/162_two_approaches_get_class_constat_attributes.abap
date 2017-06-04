DATA: lo_node TYPE REF TO object.

cl_crm_order_timer=>start( ).
DO 1000 TIMES.
  CREATE OBJECT lo_node TYPE ('CL_PRD01OV_MATERIALOV_CN00').
  ASSIGN lo_node->('BASE_ENTITY_NAME') TO FIELD-SYMBOL(<name>).
ENDDO.
cl_crm_order_timer=>stop( 'Field Symbol' ).
WRITE:/ <name>.

cl_crm_order_timer=>start( ).
SELECT SINGLE attvalue INTO @DATA(lv) FROM vseoattrib WHERE clsname = 'CL_PRD01OV_MATERIALOV_CN00'
  AND cmpname = 'BASE_ENTITY_NAME'.
  REPLACE ALL OCCURRENCES OF '''' IN lv WITH space.
cl_crm_order_timer=>stop( 'DB' ).

WRITE:/ lv.