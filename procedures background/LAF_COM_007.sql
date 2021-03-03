create or replace procedure laf_com_007(attr_ in varchar2) is

  DISTRICT_CODE_ VARCHAR2(3200);
  REGION_CODE_   VARCHAR2(3200);
  CUSTOMER_ID_   VARCHAR2(3200):= client_sys.Get_Item_Value('customerId_',attr_);
  ADDRESS_ID_    VARCHAR2(3200):= client_sys.Get_Item_Value('addressId_',attr_);

  p0_ VARCHAR2(32000) := NULL;

  p1_ VARCHAR2(32000) := NULL;

  p2_ VARCHAR2(32000) := NULL;

  p3_ VARCHAR2(32000) := NULL;

  p4_ VARCHAR2(32000) := 'DO';

BEGIN

  SELECT CR.CF$_DISTRICT_CODE, CR.CF$_REGION_CODE
    INTO DISTRICT_CODE_, REGION_CODE_
    FROM LAF_RELATIONSHIPCITYREGION_CLV CR
   INNER JOIN CUSTOMER_INFO_ADDRESS CIA
      ON (CIA.CITY = CR.CF$_CITY_NAME AND CIA.STATE = CR.CF$_STATE_CODE)
   WHERE CIA.ADDRESS_ID = ADDRESS_ID_ 
     AND CIA.customer_id = CUSTOMER_ID_;

  p3_ := 'CUSTOMER_ID' || chr(31) || CUSTOMER_ID_ || chr(30) || 'ADDRESS_ID' ||
         chr(31) || ADDRESS_ID_ || chr(30) || 'DELIVERY_TERMS' || chr(31) ||
         'CIF' || chr(30) || 'DEL_TERMS_LOCATION' || chr(31) || '' ||
         chr(30) || 'SHIP_VIA_CODE' || chr(31) || 'ROD' || chr(30) ||
         'SHIPMENT_UNCON_STRUCT_DB' || chr(31) || 'FALSE' || chr(30) ||
         'REGION_CODE' || chr(31) || REGION_CODE_ || chr(30) || 'DISTRICT_CODE' ||
         chr(31) || DISTRICT_CODE_ || chr(30) || 'DELIVERY_TIME' || chr(31) || '' ||
         chr(30) || 'INTRASTAT_EXEMPT_DB' || chr(31) || 'INCLUDE' ||
         chr(30);

  IFSLAF.CUST_ORD_CUSTOMER_ADDRESS_API.NEW__(p0_, p1_, p2_, p3_, p4_);

END;
