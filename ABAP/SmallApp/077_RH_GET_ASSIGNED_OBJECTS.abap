REPORT zget_assigned_unit.

* Jerry 2016-12-4 20:43PM on aircraft - according to Ulf's KT in Germany :)
DATA: lt_org_tab TYPE hrsettab OCCURS 0.
CALL FUNCTION 'RH_GET_ASSIGNED_OBJECTS'
  EXPORTING
    otype            = 'CP'
    objid            = '50003657'
    wegid            = 'CP_012_O' " 012: relationship in table. O: organization unit
    sbegd            = '20150702'
    sendd            = '20150702'
  TABLES
    assigned_objects = lt_org_tab.
BREAK-POINT.