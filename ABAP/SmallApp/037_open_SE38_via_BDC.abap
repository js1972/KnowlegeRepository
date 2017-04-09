REPORT zse38.
DATA: bdcdata_tab  TYPE TABLE OF bdcdata,
      opt          TYPE ctu_params,
      bdcdata_line TYPE bdcdata.

bdcdata_line-program = 'SAPLWBABAP'.
bdcdata_line-dynpro = '0100'.
bdcdata_line-dynbegin = 'X'.
APPEND bdcdata_line TO bdcdata_tab.

CLEAR: bdcdata_line.

bdcdata_line-fnam = 'BDC_CURSOR'.
bdcdata_line-fval = 'RS38M-PROGRAMM'.
APPEND bdcdata_line TO bdcdata_tab.


CLEAR: bdcdata_line.
bdcdata_line-fnam = 'BDC_OKCODE'.
bdcdata_line-fval = '=SHOP'.
APPEND bdcdata_line TO bdcdata_tab.

CLEAR: bdcdata_line.
bdcdata_line-fnam = 'RS38M-PROGRAMM'.
bdcdata_line-fval = 'ZHISTORY'.
APPEND bdcdata_line TO bdcdata_tab.


opt-dismode = 'E'.
opt-defsize = 'X'.

CALL TRANSACTION 'SE38' USING bdcdata_tab  OPTIONS FROM opt.