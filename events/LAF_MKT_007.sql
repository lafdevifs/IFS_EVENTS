-- LU: OrderQuotationLine
-- Table: ORDER_QUOTATION_LINE_TAB
-- Campos: QUOTATION_NO, ROWSTATE, CANCEL_REASON
-- Quando : Alterado o ROWSTATE = Cancelled & CANCEL_REASON != 2
-- Descr: Enviar dados de Cotação perdida para a tela de integração Inovyo quando o motivo de perda não seja emissão incorreta

DECLARE

  PRAGMA AUTONOMOUS_TRANSACTION;

  CONTRACT_        varchar2(3200) := NULL;
  CUSTOMER_NO_     varchar2(3200) := NULL;
  SALESMAN_CODE_   varchar2(3200) := NULL;
  CREATION_DATE_   varchar2(3200) := NULL;
  ORDER_NO_        varchar2(3200) := NULL;
  EXISTS_ORDER_NO_ varchar2(3200) := NULL;
  SURVEY_          NUMBER := 577;
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

  SELECT oq.quotation_no
    iNTO EXISTS_ORDER_NO_
    FROM ORDER_QUOTATION OQ
   WHERE NOT EXISTS (select cf$_order_no
            from laf_integracao_clv li
           where li.cf$_order_no = 'CO: '||oq.quotation_no)
     AND oq.quotation_no = '&NEW:QUOTATION_NO';

  IF EXISTS_ORDER_NO_ IS NOT NULL THEN
  
    SELECT ORDER_QUOTATION_API.Get_Company(quotation_no_ => '&NEW:QUOTATION_NO') COMPANY,
           ORDER_QUOTATION_API.Get_Contract(quotation_no_ => '&NEW:QUOTATION_NO') CONTRACT,
           ORDER_QUOTATION_API.Get_Customer_No(quotation_no_ => '&NEW:QUOTATION_NO') CUSTOMER_NO,
           ORDER_QUOTATION_API.Get_Salesman_Code(quotation_no_ => '&NEW:QUOTATION_NO') SALESMAN_CODE,
           'CO: '||'&NEW:QUOTATION_NO',
           Comm_Method_API.Get_Value('PERSON',
                                     ORDER_QUOTATION_API.Get_Cust_Ref(quotation_no_ => '&NEW:QUOTATION_NO'),
                                     Comm_Method_Code_API.Decode('E_MAIL'),
                                     1,
                                     NULL,
                                     sysdate) EMAIL,
           ifslaf.Person_Info_API.Get_Name(person_id_ => ORDER_QUOTATION_API.Get_Cust_Ref(quotation_no_ => '&NEW:QUOTATION_NO')) NAME,
           NVL(COMM_METHOD_API.Get_Value('PERSON',
                                         ORDER_QUOTATION_API.Get_Cust_Ref(quotation_no_ => '&NEW:QUOTATION_NO'),
                                         COMM_METHOD_CODE_API.Decode('MOBILE'),
                                         1,
                                         NULL,
                                         sysdate),
               ifslaf.Comm_Method_API.Get_Value('PERSON',
                                                ORDER_QUOTATION_API.Get_Cust_Ref(quotation_no_ => '&NEW:QUOTATION_NO'),
                                                Comm_Method_Code_API.Decode('PHONE'),
                                                1,
                                                NULL,
                                                sysdate)) PHONE,
           ifslaf.order_quotation_api.Get_Date_Entered(quotation_no_ => '&NEW:QUOTATION_NO') DATE_CREATION
      into COMPANY_,
           CONTRACT_,
           CUSTOMER_NO_,
           SALESMAN_CODE_,
           ORDER_NO_,
           EMAIL_,
           NAME_,
           PHONE_,
           CREATION_DATE_            
      FROM ORDER_QUOTATION_LINE OQL
     WHERE OQL.cancel_reason != '2'
     AND OQL.quotation_no = '&NEW:QUOTATION_NO'
     FETCH FIRST 1 ROWS ONLY; 
     
     p3_ := 'CF$_COMPANY' || chr(31) || COMPANY_ || chr(30) ||
           'CF$_CONTRACT' || chr(31) || CONTRACT_ || chr(30) ||
           'CF$_CUSTOMER_NO' || chr(31) || CUSTOMER_NO_ || chr(30) ||
           'CF$_SALESMAN_CODE' || chr(31) || SALESMAN_CODE_ || chr(30) ||
           'CF$_ORDER_NO' || chr(31) || ORDER_NO_ || chr(30) ||
           'CF$_INTEGRATION_EXT' || chr(31) || 'INOVYO' || chr(30) ||
           'CF$_EMAIL' || chr(31) || EMAIL_ || chr(30) || 'CF$_NAME' ||
           chr(31) || NAME_ || chr(30) || 'CF$_PHONE' || chr(31) || PHONE_ ||
           chr(30) || 'CF$_CREATION_DATE' || chr(31) || CREATION_DATE_ ||
           chr(30) || 'CF$_SURVEY' || chr(31) || SURVEY_ || chr(30);
  
    IFSLAF.LAF_INTEGRACAO_CLP.NEW__(p0_, p1_, p2_, p3_, p4_);
  
  END IF;
  COMMIT;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    BEGIN
      DBMS_OUTPUT.PUT_LINE('');
    END;
END;
  
   