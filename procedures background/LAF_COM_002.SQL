CREATE OR REPLACE PROCEDURE LAF_COM_002(attr_ IN VARCHAR2) IS

  CUSTOMER_ID_ VARCHAR2(3200) := client_sys.Get_Item_Value('customerId_',attr_);
  ADDRESS_ID_  VARCHAR2(3200) := client_sys.Get_Item_Value('addressId_',attr_);

  p0_ VARCHAR2(32000) := NULL;
  p1_ VARCHAR2(32000) := NULL;
  p2_ VARCHAR2(32000) := NULL;
  p3_ VARCHAR2(32000) := 'CUSTOMER_ID' || chr(31) || CUSTOMER_ID_ ||
                         chr(30) || 'ADDRESS_ID' || chr(31) ||
                         ADDRESS_ID_ || chr(30) || 'OPERATION_ID' ||
                         chr(31) || '2050' || chr(30) || 'ICMS_TAX_TYPE' ||
                         chr(31) || 'Tributável' || chr(30) ||
                         'ICMS_TAX_PAYER' || chr(31) || 'TRUE' || chr(30) ||
                         'CUSTOMER_TAX_INFO_TYPE' || chr(31) || 'Privado' ||
                         chr(30) || 'FINAL_CONSUMER' || chr(31) || 'FALSE' ||
                         chr(30);

  p4_ VARCHAR2(32000) := 'DO';

  p5_ NUMBER;

BEGIN

  select COUNT(*)
    into p5_
    from CUSTOMER_TAX_INFO_BR_TAB A
   WHERE A.CUSTOMER_ID = client_sys.Get_Item_Value('customerId_', attr_)
     AND A.ADDRESS_ID = client_sys.Get_Item_Value('addressId_', attr_);

  if p5_ = 0 THEN
    IFSLAF.CUSTOMER_TAX_INFO_BR_API.NEW__(p0_, p1_, p2_, p3_, p4_);
  
    COMMIT;
  END IF;

END;
