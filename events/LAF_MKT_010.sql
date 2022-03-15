DECLARE

  PRAGMA AUTONOMOUS_TRANSACTION;

  CONTRACT_           varchar2(3200) := NULL;
  CUSTOMER_NO_        varchar2(3200) := NULL;
  SALESMAN_CODE_      varchar2(3200) := NULL;
  CREATION_DATE_      varchar2(3200) := NULL;
  ORDER_NO_           varchar2(3200) := NULL;
  EXISTS_CUSTOMER_NO_ varchar2(3200) := NULL;
  SURVEY_             NUMBER := 509;
  INTEGRATION_EXT_    varchar2(3200) := 'INOVYO';

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

  CURSOR CLI_INATIVOS IS
    SELECT CIC.CUSTOMER_ID,
          CIC.PERSON_ID,
           PERSON_INFO_API.Get_Name(CIC.PERSON_ID),
           Comm_Method_API.Get_Value('PERSON',
                                     CIC.person_id,
                                     Comm_Method_Code_API.Decode('E_MAIL'),
                                     1,
                                     ''),
           NVL(Comm_Method_API.Get_Value('PERSON',
                                         CIC.person_id,
                                         Comm_Method_Code_API.Decode('MOBILE'),
                                         1,
                                         ''),
               Comm_Method_API.Get_Value('PERSON',
                                         CIC.person_id,
                                         Comm_Method_Code_API.Decode('PHONE'),
                                         1,
                                         '')) AS PHONE, to_char(sysdate,'yyyy/mm/dd')
      FROM CUSTOMER_INFO_CONTACT CIC
     WHERE CIC.PERSON_ID NOT IN ('4511', '4512')
       AND CIC.customer_id IN
           (SELECT BI.ID_CLIENTE
              from ifsinfo.laf_integracao_cli_inativo bi
             where BI.status_cliente = 'Inativo'
               AND NOT EXISTS
             (select cf$_order_no
                      from laf_integracao_clv li
                     where li.CF$_CUSTOMER_NO = BI.Id_cliente
                       and cf$_survey = 509)
               AND EXISTS (SELECT CO.CUSTOMER_NO
                      FROM CUSTOMER_ORDER CO
                     WHERE CO.CUSTOMER_NO = BI.Id_cliente)
               and bi.Tipo_Cliente = 'Externo');

BEGIN

  select bi.Id_cliente
    into EXISTS_CUSTOMER_NO_
    from ifsinfo.laf_integracao_cli_inativo bi
   where BI.status_cliente = 'Inativo'
     AND NOT EXISTS (select cf$_order_no
            from laf_integracao_clv li
           where li.CF$_CUSTOMER_NO = BI.Id_cliente
             and cf$_survey = 509)
     AND EXISTS (SELECT CO.CUSTOMER_NO
            FROM CUSTOMER_ORDER CO
           WHERE CO.CUSTOMER_NO = BI.Id_cliente)
     and bi.Tipo_Cliente = 'Externo' fetch first 1 rows only;

  IF EXISTS_CUSTOMER_NO_ IS NOT NULL THEN
    OPEN CLI_INATIVOS;
    loop
      FETCH CLI_INATIVOS
        INTO CUSTOMER_NO_, PERSON_ID_, NAME_, EMAIL_, PHONE_, CREATION_DATE_;
    
      EXIT WHEN CLI_INATIVOS%NOTFOUND;
      
      p3_ := 'CF$_COMPANY' || chr(31) || COMPANY_ || chr(30) ||
             'CF$_CONTRACT' || chr(31) || CONTRACT_ || chr(30) ||
             'CF$_CUSTOMER_NO' || chr(31) || CUSTOMER_NO_ || chr(30) ||
             'CF$_SALESMAN_CODE' || chr(31) || SALESMAN_CODE_ || chr(30) ||
             'CF$_ORDER_NO' || chr(31) || ORDER_NO_ || chr(30) ||
             'CF$_INTEGRATION_EXT' || chr(31) || 'INOVYO' || chr(30) ||
             'CF$_EMAIL' || chr(31) || EMAIL_ || chr(30) ||                                
             'CF$_PERSON_ID'||chr(31)|| PERSON_ID_ ||chr(30)||
             'CF$_NAME' || chr(31) || NAME_ || chr(30) || 'CF$_PHONE' || chr(31) ||
             PHONE_ || chr(30) || 'CF$_CREATION_DATE' || chr(31) ||
             CREATION_DATE_ || chr(30) || 'CF$_SURVEY' || chr(31) ||
             SURVEY_ || chr(30);
    
      IFSLAF.LAF_INTEGRACAO_CLP.NEW__(p0_, p1_, p2_, p3_, p4_);
      COMMIT;
    
      DBMS_OUTPUT.ENABLE(1000000);
    end loop;
    CLOSE CLI_INATIVOS;
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    BEGIN
      DBMS_OUTPUT.PUT_LINE('');
    END;
END;