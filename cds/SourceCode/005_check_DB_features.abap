Report z.
IF NOT cl_abap_dbfeatures=>use_features(
          EXPORTING
            requested_features =
              VALUE #( ( cl_abap_dbfeatures=>amdp_table_function ) ) ).
      cl_demo_output=>display(
        `System does not support CDS table functions` ).
      RETURN.
ENDIF.
