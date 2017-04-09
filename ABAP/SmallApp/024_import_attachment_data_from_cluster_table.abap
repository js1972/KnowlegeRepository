REPORT zdata.

DATA: phio_cluster TYPE  scmst_r3db_cont_cluster.
IMPORT phio_cluster FROM DATABASE bdscont22(ir) CLIENT sy-mandt
                            ID 'FA163EEF573D1ED49DA44708EF3ABF63' IGNORING CONVERSION ERRORS.

BREAK-POINT.