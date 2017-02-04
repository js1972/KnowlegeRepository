
@ClientDependent: true
@AccessControl.authorizationCheck: #NOT_REQUIRED 
define table function ztf_crmd_partner_but000 
  with parameters @Environment.systemField: #CLIENT 
                  clnt:abap.clnt, bp_guidset: crmt_partner_no, bp_no: crmt_partner_no
  returns { client:s_mandt;
            bp_guid: BU_PARTNER_GUID;
            title:AD_TITLE;
            name: BU_NAME1TX; 
          } 
  implemented by method 
    zcl_amdp_bp_impl=>crmd_partner_but000;