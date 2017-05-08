# 2017-05-07
1. the object I create is database, not table!
set client_encoding to gbk;
输入命令 SET client_encoding=GBK; - does not work!
chcp - in my laptop it is 936 - changes to 437
2. it can only accept default port in 5432?
3. command line naming convention: <username>#:
GRANT ALL PRIVILEGES ON DATABASE postgres to jerry;
column name must be wrapped with "";
INSERT INTO public.zcrm_product(
	"PRODUCT_GUID", "PRODUCT_ID")
	VALUES ('00163EA71FFC1ED28BCDD602F750AC54', '1002029');
INSERT INTO public.zcrm_product(
	"PRODUCT_GUID", "PRODUCT_ID", "CREATED_AT")
	VALUES ('00163EA71FFC1ED28BCDD616B9D76C58', '12222201', TIMESTAMP '2011-05-16 15:36:38');
INSERT INTO public.zcrm_product(
	"PRODUCT_GUID", "PRODUCT_ID", "CREATED_AT")
	VALUES ('00163EA71FFC1ED28BCDD616B9D76C5A', '12222201', current_timestamp);

# 2017-05-08
1. insert to product table:
INSERT INTO public.comm_product(
	client, product_guid, product_id, product_type, config, xnosearch, object_family, batch_dedicated, competitor_prod, "VALID_FROM", "VALID_TO", upname, histex, logsys)
	VALUES ('001', '00163EA71FFC1ED28BCDD602F750AC54', '1002029', '01', 'C', 'X', '0401', 'X', '', TIMESTAMP '2011-05-16 15:36:38', current_timestamp, 'WANGJER', '', 'AG3CLNT001');
2. If you are using Java 8 or newer then you should use the JDBC 4.2 version.
		