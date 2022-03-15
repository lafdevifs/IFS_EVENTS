-- LU: CustomerOrder
-- Table: Customer_Order_Tab
-- Campos: CONTRACT, CUSTOMER_NO, C_AGREEMENT_ID, DATE_ENTERED, ORDER_ID, SALESMAN_CODE
-- Quando : &NEW:DATE_ENTERED = TRUNC(SYSDATE-7), ORDER_ID=OV;OR

DECLARE

  PRAGMA AUTONOMOUS_TRANSACTION;

  CONTRACT_        varchar2(3200) := '&NEW:CONTRACT';
  CUSTOMER_NO_     varchar2(3200) := '&NEW:CUSTOMER_NO';
  SALESMAN_CODE_   varchar2(3200) := '&NEW:SALESMAN_CODE';
  CREATION_DATE_   varchar2(3200) := '&NEW:DATE_ENTERED';
  ORDER_NO_          varchar2(3200) :='&NEW:ORDER_NO';
  EXISTS_ORDER_NO_    varchar2(3200) := NULL;
  SURVEY_          NUMBER := 507;
  INTEGRATION_EXT_ varchar2(3200) := 'INOVYO';
  DATE_7_AGO_  VARCHAR2(3200):= NULL;

  COMPANY_ varchar2(3200);

  PERSON_ID_ varchar2(3200);
  NAME_  varchar2(3200);
  PHONE_ varchar2(3200);
  EMAIL_ varchar2(3200);

  p0_ VARCHAR2(32000) := NULL;
  p1_ VARCHAR2(32000) := NULL;
  p2_ VARCHAR2(32000) := NULL;
  p3_ VARCHAR2(32000) := NULL;
  p4_ VARCHAR2(32000) := 'DO';

BEGIN

SELECT co.order_no
INTO EXISTS_ORDER_NO_
FROM customer_order co
WHERE NOT EXISTS  (select cf$_order_no from laf_integracao_clv li where li.cf$_order_no = co.order_no)
AND co.order_no =  ORDER_NO_;

  IF EXISTS_ORDER_NO_ IS NOT NULL THEN 
    IF '&NEW:ORDER_ID' = 'OR' THEN

      SELECT CONTRACT, COMPANY
        INTO CONTRACT_, COMPANY_
        FROM ifslaf.COMPANY_SITE
      WHERE CONTRACT = '&NEW:CONTRACT';
      
        SELECT CONTACT_ID,
        ifslaf.Person_Info_API.Get_Name(CONTACT_ID),
              NVL(COMM_METHOD_API.Get_Value('PERSON',
                                            CONTACT_ID,
                                            COMM_METHOD_CODE_API.Decode('MOBILE'),
                                            1,
                                            CONTACT_ADDRESS,
                                            sysdate),
                  ifslaf.Comm_Method_API.Get_Value('PERSON',
                                            CONTACT_ID,
                                            Comm_Method_Code_API.Decode('PHONE'),
                                            1,
                                            CONTACT_ADDRESS,
                                            sysdate)) ,
              ifslaf.Comm_Method_API.Get_Value('PERSON',
                                        CONTACT_ID,
                                        Comm_Method_Code_API.Decode('E_MAIL'),
                                        1,
                                        CONTACT_ADDRESS,
                                        sysdate) 
          INTO PERSON_ID_, NAME_, PHONE_, EMAIL_
          FROM ifslaf.BUSINESS_OBJECT_CONTACT
        WHERE BUSINESS_OBJECT_ID = '&NEW:C_AGREEMENT_ID'
          AND CONNECTION_ID = '&NEW:CUSTOMER_NO'
          AND MAIN_CONTACT_DB = 'TRUE';
      
        p3_ := 
      'CF$_COMPANY'||chr(31)|| COMPANY_ ||chr(30)||
      'CF$_CONTRACT'||chr(31)|| CONTRACT_ || chr(30) ||   
      'CF$_CUSTOMER_NO'||chr(31)||  CUSTOMER_NO_ || chr(30) ||
      'CF$_SALESMAN_CODE'||chr(31)|| SALESMAN_CODE_ ||chr(30)||
      'CF$_ORDER_NO'||chr(31)|| ORDER_NO_ ||chr(30)||
      'CF$_INTEGRATION_EXT'||chr(31)||'INOVYO'||chr(30)||
      'CF$_PERSON_ID'||chr(31)|| PERSON_ID_ ||chr(30)||
      'CF$_EMAIL'||chr(31)|| EMAIL_ ||chr(30)||
      'CF$_NAME'||chr(31)|| NAME_ ||chr(30)||
      'CF$_PHONE'||chr(31)|| PHONE_ ||chr(30)|| 
      'CF$_CREATION_DATE' ||chr(31)|| CREATION_DATE_ ||chr(30)||
      'CF$_SURVEY'||chr(31)||'507'||chr(30);
      
        IFSLAF.LAF_INTEGRACAO_CLP.NEW__(p0_, p1_, p2_, p3_, p4_);
      
    ELSIF '&NEW:ORDER_ID' = 'OV' THEN

      SELECT CONTRACT, COMPANY
        INTO CONTRACT_, COMPANY_
        FROM ifslaf.COMPANY_SITE
      WHERE CONTRACT = '&NEW:CONTRACT';

        SELECT CONTACT_ID,
        ifslaf.Person_Info_API.Get_Name(CONTACT_ID),
              NVL(COMM_METHOD_API.Get_Value('PERSON',
                                            CONTACT_ID,
                                            COMM_METHOD_CODE_API.Decode('MOBILE'),
                                            1,
                                            CONTACT_ADDRESS,
                                            sysdate),
                  ifslaf.Comm_Method_API.Get_Value('PERSON',
                                            CONTACT_ID,
                                            Comm_Method_Code_API.Decode('PHONE'),
                                            1,
                                            CONTACT_ADDRESS,
                                            sysdate)),
              ifslaf.Comm_Method_API.Get_Value('PERSON',
                                        CONTACT_ID,
                                        Comm_Method_Code_API.Decode('E_MAIL'),
                                        1,
                                        CONTACT_ADDRESS,
                                        sysdate)
          INTO PERSON_ID_, NAME_, PHONE_, EMAIL_
          FROM ifslaf.BUSINESS_OBJECT_CONTACT
        WHERE BUSINESS_OBJECT_ID = '&NEW:QUOTATION_NO'
          AND CONNECTION_ID = '&NEW:CUSTOMER_NO'
          AND MAIN_CONTACT_DB = 'TRUE';
      
        p3_ := 
      'CF$_COMPANY'||chr(31)|| COMPANY_ ||chr(30)||
      'CF$_CONTRACT'||chr(31)|| CONTRACT_ || chr(30) ||
      'CF$_CUSTOMER_NO'||chr(31)|| CUSTOMER_NO_ || chr(30) ||
      'CF$_SALESMAN_CODE'||chr(31)|| SALESMAN_CODE_ ||chr(30)||
      'CF$_ORDER_NO'||chr(31)|| ORDER_NO_||chr(30)||
      'CF$_INTEGRATION_EXT'||chr(31)||'INOVYO'||chr(30)||
      'CF$_EMAIL'||chr(31)|| EMAIL_ ||chr(30)||      
      'CF$_PERSON_ID'||chr(31)|| PERSON_ID_ ||chr(30)||
      'CF$_NAME'||chr(31)|| NAME_ ||chr(30)||
      'CF$_PHONE'||chr(31)|| PHONE_ ||chr(30)|| 
      'CF$_CREATION_DATE' ||chr(31)|| CREATION_DATE_ ||chr(30)||
      'CF$_SURVEY'||chr(31)||'507'||chr(30);
      
        IFSLAF.LAF_INTEGRACAO_CLP.NEW__(p0_, p1_, p2_, p3_, p4_);
      
    END IF;
  END IF;
COMMIT;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
      BEGIN
        DBMS_OUTPUT.PUT_LINE('');
      END;
END;