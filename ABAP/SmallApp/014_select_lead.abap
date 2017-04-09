METHOD select_campaigns_by_sql.
    TYPES:
      BEGIN OF lty_s_objnr,
        objnr TYPE crmt_object_guid,
      END OF lty_s_objnr.

    INCLUDE: crm_status_con.
    DATA: lv_max_hits     TYPE i,
          lv_langu        TYPE sy-langu,
          lv_cursor       TYPE cursor,
          lt_package_data TYPE crmt_odata_lead_campaignt,
          ls_package_data TYPE crmt_odata_lead_campaign,
          lt_objnr        TYPE STANDARD TABLE OF lty_s_objnr,
          ls_objnr        TYPE lty_s_objnr,
          lv_package_size TYPE i.

    lv_max_hits     = iv_max_hits.

    IF lv_max_hits <= 0.
      lv_max_hits = 900.
    ENDIF.

    lv_package_size = lv_max_hits.

    lv_langu = iv_langu.

    SELECT crm_jest~objnr
      INTO TABLE lt_objnr
      FROM crm_jest
     INNER JOIN crm_jsto ON crm_jest~objnr = crm_jsto~objnr
     WHERE crm_jest~inact = space
       AND crm_jest~stat  = gc_status-released.             " 'I1004'.

    // Jerry 2015-11-16 19:45PM in Germany - 
    SORT lt_objnr.

    OPEN CURSOR WITH HOLD @lv_cursor FOR
      SELECT DISTINCT header~guid,
                      external_id,
                      text1,
                      header~object_type
                 FROM cgpl_project AS header
           INNER JOIN crm_mktpl_attr ON header~guid = crm_mktpl_attr~guid
      LEFT OUTER JOIN cgpl_text      ON header~guid = cgpl_text~guid
                                    AND cgpl_text~langu = @lv_langu
                WHERE ( header~external_id IN @it_select_option
                   OR   textu              IN @it_select_option )
                  AND header~object_type = 'CPG'
                  AND crm_mktpl_attr~template = @space
    UNION
      SELECT DISTINCT header~guid,
                      external_id,
                      text1,
                      header~object_type
                 FROM cgpl_task AS header
           INNER JOIN crm_mktpl_attr ON header~guid = crm_mktpl_attr~guid
      LEFT OUTER JOIN cgpl_text      ON header~guid = cgpl_text~guid
                                    AND cgpl_text~langu = @lv_langu
                WHERE ( header~external_id IN @it_select_option
                   OR   textu              IN @it_select_option )
                  AND header~object_type = 'CPT'
                  AND crm_mktpl_attr~template = @space
    ORDER BY text1.

    DO.
      FETCH NEXT CURSOR @lv_cursor
            INTO TABLE @lt_package_data
            PACKAGE SIZE @lv_package_size.

      IF sy-subrc = 0.
        LOOP AT lt_package_data INTO ls_package_data.
          READ TABLE lt_objnr TRANSPORTING NO FIELDS
               WITH KEY objnr = ls_package_data-guid
               BINARY SEARCH.
          IF sy-subrc <> 0.
            DELETE lt_package_data.
          ENDIF.
        ENDLOOP.

        APPEND LINES OF lt_package_data TO et_campaigns.

        IF  lines( et_campaigns ) >= lv_max_hits.
          EXIT.
        ELSE.
          lv_package_size = lv_max_hits - lines( et_campaigns ).
        ENDIF.
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.
    CLOSE CURSOR @lv_cursor.

  ENDMETHOD.
