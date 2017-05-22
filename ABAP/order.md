# 2017-05-12
1. previously in ORDERADM_I convert class, I call CRM_ORDERADM_I_SAVE_OB to populate the changed timestamp field in item object buffer. Now I extract related code of CRM_ORDERADM_I_SAVE_OB to a private method in item convert class. 
![image](https://cloud.githubusercontent.com/assets/5669954/26000168/332e0fce-3728-11e7-8f32-32510f804574.png)

2. do not invert a new internal table to differentiate the creation or update mode on header, but use FM CRM_ORDERADM_H_ON_DATABASE_OW instead:
![image](https://cloud.githubusercontent.com/assets/5669954/26000219/62ddd7f4-3728-11e7-9891-22a0a6c8339e.png)

3. For Interface method IF_CRMS4_BTX_DATA_MODEL_CONV~CONVERT_1O_TO_S4, signature has been purified. iv_current_guid is not necessary and removed:
![image](https://cloud.githubusercontent.com/assets/5669954/26000286/a4d4561a-3728-11e7-8f84-639fbd5aa7a1.png)

4. For set data read, it is enough to use READ_OB instead of READ_OW. Fixed for Shipping and Pricing.

# 2017-05-15
For review today:

![image](https://cloud.githubusercontent.com/assets/5669954/26011119/0b936ab8-3750-11e7-9227-16dc694d6824.png)

![image](https://cloud.githubusercontent.com/assets/5669954/26013074/16486ec0-3757-11e7-9a63-e801ef464eff.png)

After our meeting at 3:00PM ~ 4:00PM today:
![image](https://cloud.githubusercontent.com/assets/5669954/26066381/eef98100-3996-11e7-9e10-924068a2f61b.png)

# 2017-05-16

I think interface method GET_WRK_STRUCTURE_NAME and CONVERT_S4_TO_1O are no longer needed any more.
In function module: CRM_ORDERADM_H_SELECT_S_DB

![image](https://cloud.githubusercontent.com/assets/5669954/26103858/a3df2ea4-3a3b-11e7-8963-509c54ca9be7.png)

![image](https://cloud.githubusercontent.com/assets/5669954/26103888/d77f6d28-3a3b-11e7-8fb9-9cf36b1f81d4.png)

![image](https://cloud.githubusercontent.com/assets/5669954/26103931/0874908e-3a3c-11e7-8974-c34e7a24eb96.png)

# 2017-05-17
result structure: CRMST_QUERY_R_SRVO_BTIL.
I need to cover the fields visible in WebUI search result using CDS view.
* OBJECT_ID
* DESCRIPTION
* PRODUCT_ID

We do need to support search on item level, for example product_id:

![image](https://cloud.githubusercontent.com/assets/5669954/26146363/391925ce-3af0-11e7-9510-b82a468c5127.png)

CL_CRM_REPORT_ACC_DYNAMIC

# 2017-05-18 For review

CDS view name: CRMS4V_SALE_I

Query result structure name: CRMST_QUERY_R_SRVO_BTIL

## Jerry's question

Currently I have always queried against item CDS view which I don't think is 100% correct, even from semantic point of view: since the method CL_CRMS4_SRVO_SEARCH_TOOL=>SEARCH_CDS should return an internal table with line type CRMST_QUERY_R_SRVO_BTIL, however here I directly use the result from my item CDS view simply because it also has lots of fields needed in CRMST_QUERY_R_SRVO_BTIL.

![image](https://cloud.githubusercontent.com/assets/5669954/26161394/17717ba4-3b24-11e7-9ec1-54b5f3b49f26.png)

This solution leads to an error when you search with two Product ID criterials:

![image](https://cloud.githubusercontent.com/assets/5669954/26161568/9728c3b6-3b24-11e7-90a7-1333f56397b5.png)

Suppose by chance I have an Service Order which has two line items with product ID "1" and "JERRY_PRODUCT", then there are two line items in CRMS4D_SALE_I.

If I still perform query on item table or item CDS view, then two exactly the same line will be displayed in WebUI, since the two lines from item table have **EXACTLY THE SAME HEADER FIELD VALUE**.

![image](https://cloud.githubusercontent.com/assets/5669954/26161781/2a25ad5a-3b25-11e7-9e5b-d2b2ec239ca0.png)

Currently I am using this workaround to remove the duplicate.

I doubt if this is really correct. ( Poor performance!)


![image](https://cloud.githubusercontent.com/assets/5669954/26161806/3b00dff0-3b25-11e7-8293-ec78eba56686.png)

![image](https://cloud.githubusercontent.com/assets/5669954/26161913/8ee76fbc-3b25-11e7-9b6c-6dade79f3eb3.png)

# Guideline needed

For what kinds of search parameters we should search in header CDS view and what fields in item view??

The current approach which always start with item table is not so correct.
Suppose this scenario: I create a service order today, but I didn't maintain any item to it.
Then I search via this parameter. The order I just created will not be found, since no data for it in item table.

![image](https://cloud.githubusercontent.com/assets/5669954/26194316/4fc2732a-3bb8-11e7-8563-f58882f0ba13.png)

# 2017-05-22 Review

## Currently supported Search fields

### 1. Product id ( item level )

![image](https://cloud.githubusercontent.com/assets/5669954/26161201/809b6da2-3b23-11e7-8112-ba98c76595b4.png)

### 2. Object id ( header level )

![image](https://cloud.githubusercontent.com/assets/5669954/26161310/e2d8159c-3b23-11e7-827a-095e4a329de4.png)

### 3. Posting Date in Range ( header level )

![image](https://cloud.githubusercontent.com/assets/5669954/26194976/79dbacc4-3bba-11e7-88e3-8f1fcd91a0a9.png)

### 4. Posting Date

![image](https://github.wdf.sap.corp/storage/user/4674/files/359d7c66-3bbc-11e7-9908-d66967ef2e2d)

![image](https://cloud.githubusercontent.com/assets/5669954/26195512/5c1de5f6-3bbc-11e7-9083-bdc5669cba10.png)

### 5. Description

![image](https://cloud.githubusercontent.com/assets/5669954/26209237/860f2e9e-3bec-11e7-8e8a-ae557130453e.png)

### 6. Priority

![image](https://cloud.githubusercontent.com/assets/5669954/26209291/a90f7e44-3bec-11e7-9aa0-bb99b4fdaf0c.png)

### 7. Search both header ( description ) and item field ( Product ID)

![image](https://cloud.githubusercontent.com/assets/5669954/26210490/040ecbee-3bf0-11e7-998c-9e8b48638353.png)

# How does search by CONTACT_FIRSTNAME and CONTACT_LASTNAME work int the past?

![clipboard1](https://cloud.githubusercontent.com/assets/5669954/26251103/724714e2-3cac-11e7-9d92-0b0ef3d89fb9.png)
![clipboard2](https://cloud.githubusercontent.com/assets/5669954/26251104/7256adb2-3cac-11e7-876f-27c48ec3ccfe.png)
![clipboard3](https://cloud.githubusercontent.com/assets/5669954/26251100/7226b742-3cac-11e7-871a-e2c11661ccc7.png)

In the old implementation, BP search is done separately to first find the corresponding BP number, and then join CRMD_ORDER_INDEX with PARTNER_NO.
![clipboard4](https://cloud.githubusercontent.com/assets/5669954/26251101/722aa37a-3cac-11e7-9fac-f0ccc1231ab9.png)
![clipboard5](https://cloud.githubusercontent.com/assets/5669954/26251102/72431784-3cac-11e7-865e-acfceb413895.png)

Search by CONTACT_FIRSTNAME and CONTACT_LASTNAME is supported now :)

![clipboard1](https://cloud.githubusercontent.com/assets/5669954/26262360/e01ffeac-3cd4-11e7-9173-bda330ebbbb8.png)

Here is how I implemented:
1. define an association _partner in my header view. There is no performance loss if we don't do any query against the fields in association.

![image](https://cloud.githubusercontent.com/assets/5669954/26262635/c2c2d3d8-3cd5-11e7-8bcd-1ab47836e5f0.png)

2. how I dynamically generate where statement:

![image](https://cloud.githubusercontent.com/assets/5669954/26263012/358ef788-3cd7-11e7-9484-1b8f315c8044.png)

Check this for example:

![image](https://cloud.githubusercontent.com/assets/5669954/26263067/70afd4d6-3cd7-11e7-9066-aeea5b4754eb.png)

# Jerry's question

For such combination, from semantic point of view, should we treat the contact first and last name as header fields, or as item fields? Since both header and item can have their own contact person maintained?

![image](https://cloud.githubusercontent.com/assets/5669954/26301016/20c443a2-3ee0-11e7-8c3a-33125d9f4c20.png)

## discuss with you about current implementation for Sold-to party name search

[current implementation see here](https://github.wdf.sap.corp/OneOrderModelRedesign/DesignPhase/issues/84)
[How is FM BUPA_SEARCH_2 implemented](https://github.wdf.sap.corp/OneOrderModelRedesign/DesignPhase/issues/85)

Jerry's doubt: some time in gross time is lost?

![image](https://cloud.githubusercontent.com/assets/5669954/26305774/029026d8-3ef1-11e7-8b30-84762c5c43c3.png)

## Sold to party- individual Account and Corporate Account

See [this](https://github.wdf.sap.corp/OneOrderModelRedesign/DesignPhase/issues/86)
