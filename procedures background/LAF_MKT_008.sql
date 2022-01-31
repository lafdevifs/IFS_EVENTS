DECLARE

  PRAGMA AUTONOMOUS_TRANSACTION;

  CONTRACT_        varchar2(3200) := NULL;
  CUSTOMER_NO_     varchar2(3200) := NULL;
  SALESMAN_CODE_   varchar2(3200) := NULL;
  CREATION_DATE_   varchar2(3200) := NULL;
  ORDER_NO_        varchar2(3200) := NULL;
  EXISTS_ORDER_NO_ varchar2(3200) := NULL;
  SURVEY_          NUMBER := 508;
  INTEGRATION_EXT_ varchar2(3200) := 'INOVYO';

  COMPANY_ varchar2(3200);

  NAME_  varchar2(3200);
  PHONE_ varchar2(3200);
  EMAIL_ varchar2(3200);

  p0_ VARCHAR2(32000) := NULL;
  p1_ VARCHAR2(32000) := NULL;
  p2_ VARCHAR2(32000) := NULL;
  p3_ VARCHAR2(32000) := NULL;
  p4_ VARCHAR2(32000) := 'DO';

BEGIN

  SELECT CRA.agreement_id
    INTO EXISTS_ORDER_NO_
    FROM C_RECURRENT_AGREEMENT CRA
   WHERE NOT EXISTS (
   select cf$_order_no
            from laf_integracao_clv li
           where li.cf$_order_no = 'AGREE :'||CRA.agreement_id)
     AND CRA.agreement_id = ORDER_NO_;

  IF EXISTS_ORDER_NO_ IS NOT NULL THEN
  
    select CRA.COMPANY COMPANY,
           CRA.CONTRACT CONTRACT,
           CRA.customer_id CUSTOMER_NO,
           CRA.SALESMAN_CODE SALESMAN_CODE,
           'AGREE: '||CRA.AGREEMENT_ID,
           (select value
              from ifslaf.PERSON_INFO_COMM_METHOD2
             where identity = CRA.MAIN_CONTACT_ID
               and PARTY_TYPE_DB = 'PERSON'
               AND METHOD_ID_DB = 'E_MAIL') AS EMAIL,
           IFSLAF.PERSON_INFO_API.Get_Name(CRA.MAIN_CONTACT_ID) AS NAME,
           NVL((select value
                 from ifslaf.PERSON_INFO_COMM_METHOD2
                where identity = CRA.MAIN_CONTACT_ID
                  and PARTY_TYPE_DB = 'PERSON'
                  AND METHOD_ID_DB = 'MOBILE' FETCH FIRST 1 ROWS ONLY),
               (select value
                  from ifslaf.PERSON_INFO_COMM_METHOD2
                 where identity = CRA.MAIN_CONTACT_ID
                   and PARTY_TYPE_DB = 'PERSON'
                   AND METHOD_ID_DB = 'PHONE' FETCH FIRST 1 ROWS ONLY)) AS PHONE,
           
           CRA.create_date
      into COMPANY_,
           CONTRACT_,
           CUSTOMER_NO_,
           SALESMAN_CODE_,
           ORDER_NO_,
           EMAIL_,
           NAME_,
           PHONE_,
           CREATION_DATE_
      from IFSLAF.C_RECURRENT_AGREEMENT cra
     where cra.state = 'Finalizado'
     AND CRA.agreement_id = '&NEW:AGREEMENT_ID';
  
    p3_ := 'CF$_COMPANY' || chr(31) || COMPANY_ || chr(30) ||
           'CF$_CONTRACT' || chr(31) || CONTRACT_ || chr(30) ||
           'CF$_CUSTOMER_NO' || chr(31) || CUSTOMER_NO_ || chr(30) ||
           'CF$_SALESMAN_CODE' || chr(31) || SALESMAN_CODE_ || chr(30) ||
           'CF$_ORDER_NO' || chr(31) || ORDER_NO_ || chr(30) ||
           'CF$_INTEGRATION_EXT' || chr(31) || 'INOVYO' || chr(30) ||
           'CF$_EMAIL' || chr(31) || EMAIL_ || chr(30) || 'CF$_NAME' ||
           chr(31) || NAME_ || chr(30) || 'CF$_PHONE' || chr(31) || PHONE_ ||
           chr(30) || 'CF$_CREATION_DATE' || chr(31) || CREATION_DATE_ ||
           chr(30) || 'CF$_SURVEY' || chr(31) || '507' || chr(30);
  
    IFSLAF.LAF_INTEGRACAO_CLP.NEW__(p0_, p1_, p2_, p3_, p4_);
  
  END IF;
  COMMIT;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    BEGIN
      DBMS_OUTPUT.PUT_LINE('');
    END;
END;
