REPORT zopen_func_class.

PARAMETERS: id TYPE if_fdt_types=>id OBLIGATORY DEFAULT '3440B5B172DE1ED48BE66B75D1D603E9'.
DATA: bdcdata_tab  TYPE TABLE OF bdcdata,
      opt          TYPE ctu_params,
      ls_entry     TYPE fdt_cc_0000,
      bdcdata_line TYPE bdcdata.

START-OF-SELECTION.

SELECT SINGLE * INTO ls_entry FROM fdt_cc_0000 WHERE id = id.
IF sy-subrc <> 0.
   WRITE: / 'this function does not have a valid generated class'.
   RETURN.
ENDIF.

bdcdata_line-program = 'SAPLSEOD'.
bdcdata_line-dynpro = '1000'.
bdcdata_line-dynbegin = 'X'.
APPEND bdcdata_line TO bdcdata_tab.

CLEAR: bdcdata_line.

bdcdata_line-fnam = 'BDC_CURSOR'.
bdcdata_line-fval = 'SEOCLASS-CLSNAME'.
APPEND bdcdata_line TO bdcdata_tab.

CLEAR: bdcdata_line.
bdcdata_line-fnam = 'BDC_OKCODE'.
bdcdata_line-fval = '=WB_DISPLAY'.
APPEND bdcdata_line TO bdcdata_tab.

CLEAR: bdcdata_line.
bdcdata_line-fnam = 'SEOCLASS-CLSNAME'.
bdcdata_line-fval = ls_entry-obj_name.
APPEND bdcdata_line TO bdcdata_tab.

opt-dismode = 'E'.
opt-defsize = 'X'.

CALL TRANSACTION 'SE24' USING bdcdata_tab  OPTIONS FROM opt.