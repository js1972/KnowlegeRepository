
@EndUserText.label: 'CDS with TF'

define table function Z05_Cds_Tf
with parameters 
    @Environment.systemField: #CLIENT 
    p_clnt   :abap.clnt,
    p_carrid :s_carr_id,
    p_currency : s_currcode

returns {
    client   :s_mandt; 
    carrid: s_carr_id;
    carrname :s_carrname; 
    connid   :s_conn_id;
    fldate : s_date;
    paymentsum: s_sum;
    currency: s_currcode;
    paymentsumnew: s_sum;
  } 
  implemented by method 
    Z05_CL_DEMO_CDS=>GET_DATA_Z05_CDS_TF;

class Z05_CL_DEMO_CDS definition
  public
  final
  create public .

public section.
 "Include interface
 INTERFACES if_amdp_marker_hdb.

 CLASS-METHODS GET_DATA_Z05_CDS_TF
                  FOR TABLE FUNCTION Z05_Cds_Tf.

protected section.
private section.
ENDCLASS.



CLASS Z05_CL_DEMO_CDS IMPLEMENTATION.

METHOD GET_DATA_Z05_CDS_TF
         BY DATABASE FUNCTION FOR HDB
         LANGUAGE SQLSCRIPT
         OPTIONS READ-ONLY
         USING sflight scarr.
RETURN    SELECT  client,
                  carrid,
                  carrname,
                  connid,
                  fldate,
                  paymentsum,
                  currency,
                  sum(paymentsum) over (partition by carrid, connid
                                        order by carrid, connid, fldate) as paymentsumnew
    FROM
    (
    SELECT sf.mandt as client,
                  sf.carrid,
                  sc.carrname,
                  sf.connid,
                  sf.fldate,
                  sf.paymentsum,
                  sf.currency
                  FROM sflight AS sf
                    INNER JOIN scarr AS sc ON sf.mandt = sc.mandt AND
                                              sf.carrid = sc.carrid
                    WHERE sf.mandt = :p_clnt and
                          sf.carrid = :p_carrid and
                          sf.currency = :p_currency
             )
     order by
          carrid,
          connid,
          fldate;


  ENDMETHOD.
ENDCLASS.

