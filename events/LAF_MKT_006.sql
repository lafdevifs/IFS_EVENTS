-- LU: CRecAgreementItem
-- Table: C_REC_AGREEMENT_ITEM_TAB
-- Campos: LOST_REASON_ID, OPPORTUNITY_NO, AGREEMENT_ID, LINE_NO, ROWSTATE
-- Quando : Alterado o ROWSTATE = Lost & LOST_REASON_ID != 21
-- Descr: Enivar dados de Contratos Perdidos diferente de emissão incorreta para tela de integração Inovyo 

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
  DATE_7_AGO_      VARCHAR2(3200) := NULL;

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

  select crai.agreement_id
  INTO EXISTS_ORDER_NO_
  from ifslaf.C_RECURRENT_AGREEMENT crai
  where NOT EXISTS (
  select cf$_order_no   
            from laf_integracao_clv li
           where li.cf$_order_no = 'AGREE: ' ||crai.agreement_id)
        
    and crai.agreement_id = '&NEW:AGREEMENT_ID' ;

  IF EXISTS_ORDER_NO_ IS NOT NULL THEN
  
    select C_RECURRENT_AGREEMENT_API.Get_Company(opportunity_no_ => '&NEW:OPPORTUNITY_NO',
                                                 agreement_id_   => '&NEW:AGREEMENT_ID') COMPANY,
           C_RECURRENT_AGREEMENT_API.Get_Contract(opportunity_no_ => '&NEW:OPPORTUNITY_NO',
                                                  agreement_id_   => '&NEW:AGREEMENT_ID') CONTRACT,
           C_RECURRENT_AGREEMENT_API.Get_Customer_Id(opportunity_no_ => '&NEW:OPPORTUNITY_NO',
                                                     agreement_id_   => '&NEW:AGREEMENT_ID') CUSTOMER_NO,
           C_RECURRENT_AGREEMENT_API.Get_Salesman_Code(opportunity_no_ => '&NEW:OPPORTUNITY_NO',
                                                       agreement_id_   => '&NEW:AGREEMENT_ID') SALESMAN_CODE,
           'AGREE: '||CRAI.AGREEMENT_ID ,
           (select value
              from ifslaf.PERSON_INFO_COMM_METHOD2
             where identity =
                   IFSLAF.C_RECURRENT_AGREEMENT_API.Get_Main_Contact_Id(opportunity_no_ => '&NEW:OPPORTUNITY_NO',
                                                                        agreement_id_   => '&NEW:AGREEMENT_ID')
               and PARTY_TYPE_DB = 'PERSON'
               AND METHOD_ID_DB = 'E_MAIL') AS EMAIL,
               IFSLAF.C_RECURRENT_AGREEMENT_API.Get_Main_Contact_Id(opportunity_no_ => '&NEW:OPPORTUNITY_NO',
                                                                                                agreement_id_   => '&NEW:AGREEMENT_ID') AS PERSON_ID,
           IFSLAF.PERSON_INFO_API.Get_Name(IFSLAF.C_RECURRENT_AGREEMENT_API.Get_Main_Contact_Id(opportunity_no_ => '&NEW:OPPORTUNITY_NO',
                                                                                                agreement_id_   => '&NEW:AGREEMENT_ID')) AS NAME,
           NVL((select value
                 from ifslaf.PERSON_INFO_COMM_METHOD2
                where identity =
                      IFSLAF.C_RECURRENT_AGREEMENT_API.Get_Main_Contact_Id(opportunity_no_ => '&NEW:OPPORTUNITY_NO',
                                                                           agreement_id_   => '&NEW:AGREEMENT_ID')
                  and PARTY_TYPE_DB = 'PERSON'
                  AND METHOD_ID_DB = 'MOBILE' FETCH FIRST 1 ROWS ONLY),
               (select value
                  from ifslaf.PERSON_INFO_COMM_METHOD2
                 where identity =
                       IFSLAF.C_RECURRENT_AGREEMENT_API.Get_Main_Contact_Id(opportunity_no_ => '&NEW:OPPORTUNITY_NO',
                                                                            agreement_id_   => '&NEW:AGREEMENT_ID')
                   and PARTY_TYPE_DB = 'PERSON'
                   AND METHOD_ID_DB = 'PHONE')) AS PHONE,
           
           IFSLAF.C_RECURRENT_AGREEMENT_API.Get_Create_Date(opportunity_no_ => '&NEW:OPPORTUNITY_NO',
                                                            agreement_id_   => '&NEW:AGREEMENT_ID') DATE_CREATION
      into COMPANY_,
           CONTRACT_,
           CUSTOMER_NO_,
           SALESMAN_CODE_,
           ORDER_NO_,
           EMAIL_,
           PERSON_ID,
           NAME_,
           PHONE_,
           CREATION_DATE_
      from C_REC_AGREEMENT_ITEM_TAB crai
     where crai.Agreement_Id = '&NEW:AGREEMENT_ID'
      FETCH FIRST 1 ROWS ONLY;
  
    p3_ := 'CF$_COMPANY' || chr(31) || COMPANY_ || chr(30) ||
           'CF$_CONTRACT' || chr(31) || CONTRACT_ || chr(30) ||
           'CF$_CUSTOMER_NO' || chr(31) || CUSTOMER_NO_ || chr(30) ||
           'CF$_SALESMAN_CODE' || chr(31) || SALESMAN_CODE_ || chr(30) ||
           'CF$_ORDER_NO' || chr(31) || ORDER_NO_ || chr(30) ||
           'CF$_INTEGRATION_EXT' || chr(31) || 'INOVYO' || chr(30) ||
           'CF$_EMAIL' || chr(31) || EMAIL_ || chr(30) ||                             
           'CF$_PERSON_ID'||chr(31)|| PERSON_ID_ ||chr(30)||
           'CF$_NAME' || chr(31) || NAME_ || chr(30) ||
           'CF$_PHONE' || chr(31) || PHONE_ || chr(30) || 
           'CF$_CREATION_DATE' || chr(31) || CREATION_DATE_ ||chr(30) || 
           'CF$_SURVEY' || chr(31) || SURVEY_ || chr(30);
  
    IFSLAF.LAF_INTEGRACAO_CLP.NEW__(p0_, p1_, p2_, p3_, p4_);
  
  END IF;
  COMMIT;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    BEGIN
      DBMS_OUTPUT.PUT_LINE('');
    END;
END;
