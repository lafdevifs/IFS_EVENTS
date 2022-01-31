-- LU: CustomerInfo
-- Table: CUSTOMER_INFO_TAB
-- Campos: CORPORATE_FORM, CUSTOMER_ID
-- Quando : New : CORPORATE_FORM = RD
-- Descr: Mandar dados de cliente quando o mesmo for convertido de LEAD de origem do RD Station

DECLARE

  PRAGMA AUTONOMOUS_TRANSACTION;

  CUSTOMER_NO_     varchar2(3200) := '&NEW:CUSTOMER_ID';
  EXISTS_ORDER_NO_ varchar2(3200) := NULL;
  SURVEY_          NUMBER := 576;
  INTEGRATION_EXT_ varchar2(3200) := 'INOVYO';

  NAME_  varchar2(3200);
  PHONE_ varchar2(3200);
  EMAIL_ varchar2(3200);

  p0_ VARCHAR2(32000) := NULL;
  p1_ VARCHAR2(32000) := NULL;
  p2_ VARCHAR2(32000) := NULL;
  p3_ VARCHAR2(32000) := NULL;
  p4_ VARCHAR2(32000) := 'DO';

BEGIN

  SELECT co.customer_id
    INTO EXISTS_ORDER_NO_
    FROM ifslaf.CUSTOMER_INFO co
   WHERE NOT EXISTS (select cf$_order_no
            from laf_integracao_clv li
           where li.cf$_customer_no = co.CUSTOMER_ID
             and li.cf$_survey = 576)
     AND co.CUSTOMER_ID = CUSTOMER_NO_;

  IF EXISTS_ORDER_NO_ IS NOT NULL THEN
  
    SELECT ifslaf.Person_Info_API.Get_Name (SELECT PERSON_ID
                                              FROM IFSLAF.CUSTOMER_INFO_CONTACT
                                             where customer_id = CUSTOMER_NO_
                                             FETCH 1 ROW ONLY),
           NVL(COMM_METHOD_API.Get_Value('PERSON',
                                         (SELECT PERSON_ID
                                            FROM IFSLAF.CUSTOMER_INFO_CONTACT
                                           where customer_id = CUSTOMER_NO_
                                           FETCH 1 ROW ONLY),
                                         COMM_METHOD_CODE_API.Decode('MOBILE'),
                                         1,
                                         CONTACT_ADDRESS,
                                         sysdate),
               ifslaf.Comm_Method_API.Get_Value('PERSON',
                                                (SELECT PERSON_ID
                                                   FROM IFSLAF.CUSTOMER_INFO_CONTACT
                                                  where customer_id =
                                                        CUSTOMER_NO_
                                                  FETCH 1 ROW ONLY),
                                                Comm_Method_Code_API.Decode('PHONE'),
                                                1,
                                                CONTACT_ADDRESS,
                                                sysdate)),
           ifslaf.Comm_Method_API.Get_Value('PERSON',
                                            (SELECT PERSON_ID
                                               FROM IFSLAF.CUSTOMER_INFO_CONTACT
                                              where customer_id =
                                                    CUSTOMER_NO_ FETCH 1 ROW ONLY),
                                            Comm_Method_Code_API.Decode('E_MAIL'),
                                            1,
                                            CONTACT_ADDRESS,
                                            sysdate)
      INTO NAME_, PHONE_, EMAIL_
      FROM ifslaf.BUSINESS_OBJECT_CONTACT
           
           p3_ := 'CF$_CUSTOMER_NO' || chr(31) || CUSTOMER_NO_ || chr(30) || 'CF$_INTEGRATION_EXT' || chr(31) || 'INOVYO' || chr(30) || 'CF$_EMAIL' || chr(31) || EMAIL_ || chr(30) || 'CF$_NAME' || chr(31) || NAME_ || chr(30) || 'CF$_PHONE' || chr(31) || PHONE_ || chr(30) || 'CF$_CREATION_DATE' || chr(31) || CREATION_DATE_ || chr(30) || 'CF$_SURVEY' || chr(31) || SURVEY_ || chr(30);
  
    IFSLAF.LAF_INTEGRACAO_CLP.NEW__(p0_, p1_, p2_, p3_, p4_);
  
  END IF;
  COMMIT;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    BEGIN
      DBMS_OUTPUT.PUT_LINE('');
    END;
END;