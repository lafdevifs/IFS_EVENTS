/*-- base
SELECT CO.ORDER_NO 
         FROM CUSTOMER_ORDER CO
         WHERE CO.DATE_ENTERED BETWEEN TO_DATE('11/01/2022','DD/MM/YYYY') AND TO_DATE('18/01/2022','DD/MM/YYYY')
         AND CO.ORDER_ID IN ('OR')--,'OV')
         AND NOT EXISTS(select cf$_order_no from laf_integracao_clv li where li.cf$_order_no = CO.ORDER_NO );
         
  ---
  
   p3_ := 'CF$_COMPANY' || chr(31) || COMPANY_ || chr(30) ||
             'CF$_CONTRACT' || chr(31) || CONTRACT_ || chr(30) ||
             'CF$_CUSTOMER_NO' || chr(31) || CUSTOMER_NO_ || chr(30) ||
             'CF$_SALESMAN_CODE' || chr(31) || SALESMAN_CODE_ || chr(30) ||
             'CF$_ORDER_NO' || chr(31) || ORDER_NO_ || chr(30) ||
             'CF$_INTEGRATION_EXT' || chr(31) || 'INOVYO' || chr(30) ||
             'CF$_EMAIL' || chr(31) || EMAIL_ || chr(30) || 'CF$_NAME' ||
             chr(31) || NAME_ || chr(30) || 'CF$_PHONE' || chr(31) ||
             PHONE_ || chr(30) || 'CF$_CREATION_DATE' || chr(31) ||
             CREATION_DATE_ || chr(30) || 'CF$_SURVEYs || chr(31) || '507' ||
             chr(30);
    
     -- IFSLAF.LAF_INTEGRACAO_CLP.NEW__(p0_, p1_, p2_, p3_, p4_);
 -- 
 *
 
 select co.company, co.CONTRACT, co.CUSTOMER_NO, co.SALESMAN_CODE, co.order_no, 
 
 (select value from ifslaf.PERSON_INFO_COMM_METHOD2 where identity = IFSLAF.C_RECURRENT_AGREEMENT_API.Get_Main_Contact_Id(opportunity_no_ => CO.C_OPPORTUNITY_NO ,agreement_id_ => CO.C_AGREEMENT_ID ) and PARTY_TYPE_DB = 'PERSON' AND METHOD_ID_DB = 'E_MAIL' ) AS EMAIL,
  IFSLAF.PERSON_INFO_API.Get_Name(IFSLAF.C_RECURRENT_AGREEMENT_API.Get_Main_Contact_Id(opportunity_no_ => CO.C_OPPORTUNITY_NO ,agreement_id_ => CO.C_AGREEMENT_ID )) AS NAME,

 (select value from ifslaf.PERSON_INFO_COMM_METHOD2 where identity = IFSLAF.C_RECURRENT_AGREEMENT_API.Get_Main_Contact_Id(opportunity_no_ => CO.C_OPPORTUNITY_NO ,agreement_id_ => CO.C_AGREEMENT_ID ) and PARTY_TYPE_DB = 'PERSON' AND METHOD_ID_DB = 'PHONE' ) AS PHONE,
 ROWNUM = 1)
 CO.DATE_ENTERED AS DATE_CREATION
 FROM CUSTOMER_ORDER CO
 WHERE CO.DATE_ENTERED BETWEEN TO_DATE('11/01/2022','DD/MM/YYYY') AND TO_DATE('18/01/2022','DD/MM/YYYY')
         AND CO.ORDER_ID IN ('OR')--,'OV')
         AND NOT EXISTS(select cf$_order_no from laf_integracao_clv li where li.cf$_order_no = CO.ORDER_NO )
         AND C_RECURRENT_AGREEMENT_API.Get_Main_Contact_Id(opportunity_no_ => CO.C_OPPORTUNITY_NO ,agreement_id_ => CO.C_AGREEMENT_ID ) IS NOT NULL; 
      
 
 SELECT * FROM PERSON_INFO_COMM_METHOD2
 */

------ OV DE CONTRATOS PARA TELA DE INTEGRAÇÃO         
declare

  CONTRACT_        varchar2(3200) := NULL;
  CUSTOMER_NO_     varchar2(3200) := NULL;
  SALESMAN_CODE_   varchar2(3200) := NULL;
  CREATION_DATE_   varchar2(3200) := NULL;
  ORDER_NO_        varchar2(3200) := NULL;
  EXISTS_ORDER_NO_ varchar2(3200) := NULL;
  SURVEY_          NUMBER := 507;
  INTEGRATION_EXT_ varchar2(3200) := 'INOVYO';
  AGREEMENT_ID_    VARCHAR2(3200) := NULL;

  COMPANY_ varchar2(3200);

  NAME_  varchar2(3200);
  PHONE_ varchar2(3200);
  EMAIL_ varchar2(3200);

  p0_ VARCHAR2(32000) := NULL;
  p1_ VARCHAR2(32000) := NULL;
  p2_ VARCHAR2(32000) := NULL;
  p3_ VARCHAR2(32000) := NULL;
  p4_ VARCHAR2(32000) := 'DO';

  cursor ovs_or is
    select co.company,
           co.CONTRACT,
           co.CUSTOMER_NO,
           co.SALESMAN_CODE,
           co.order_no,
           (select value
              from ifslaf.PERSON_INFO_COMM_METHOD2
             where identity =
                   IFSLAF.C_RECURRENT_AGREEMENT_API.Get_Main_Contact_Id(opportunity_no_ => CO.C_OPPORTUNITY_NO,
                                                                        agreement_id_   => CO.C_AGREEMENT_ID)
               and PARTY_TYPE_DB = 'PERSON'
               AND METHOD_ID_DB = 'E_MAIL') AS EMAIL,
           IFSLAF.PERSON_INFO_API.Get_Name(IFSLAF.C_RECURRENT_AGREEMENT_API.Get_Main_Contact_Id(opportunity_no_ => CO.C_OPPORTUNITY_NO,
                                                                                                agreement_id_   => CO.C_AGREEMENT_ID)) AS NAME,
           NVL((select value
                 from ifslaf.PERSON_INFO_COMM_METHOD2
                where identity =
                      IFSLAF.C_RECURRENT_AGREEMENT_API.Get_Main_Contact_Id(opportunity_no_ => CO.C_OPPORTUNITY_NO,
                                                                           agreement_id_   => CO.C_AGREEMENT_ID)
                  and PARTY_TYPE_DB = 'PERSON'
                  AND METHOD_ID_DB = 'MOBILE' FETCH FIRST 1 ROWS ONLY),
               (select value
                  from ifslaf.PERSON_INFO_COMM_METHOD2
                 where identity =
                       IFSLAF.C_RECURRENT_AGREEMENT_API.Get_Main_Contact_Id(opportunity_no_ => CO.C_OPPORTUNITY_NO,
                                                                            agreement_id_   => CO.C_AGREEMENT_ID)
                   and PARTY_TYPE_DB = 'PERSON'
                   AND METHOD_ID_DB = 'PHONE')) AS PHONE,
          CO.DATE_ENTERED AS CREATION_DATE
      FROM CUSTOMER_ORDER CO
     WHERE CO.DATE_ENTERED BETWEEN TO_DATE('11/01/2022', 'DD/MM/YYYY') AND
           TO_DATE('18/01/2022', 'DD/MM/YYYY')
       AND CO.ORDER_ID IN ('OR') --,'OV')
       AND NOT EXISTS
     (select cf$_order_no
              from laf_integracao_clv li
             where li.cf$_order_no = CO.ORDER_NO)
       AND C_RECURRENT_AGREEMENT_API.Get_Main_Contact_Id(opportunity_no_ => CO.C_OPPORTUNITY_NO,
                                                         agreement_id_   => CO.C_AGREEMENT_ID) IS NOT NULL;


begin

  open ovs_or;
  FOR i IN 1..1000000
  loop
    fetch ovs_or
      into COMPANY_,
           CONTRACT_,
           CUSTOMER_NO_,
           SALESMAN_CODE_,
           ORDER_NO_,
           EMAIL_,
           NAME_,
           PHONE_,
           CREATION_DATE_;
  
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
   DBMS_OUTPUT.ENABLE(1000000);
    IFSLAF.LAF_INTEGRACAO_CLP.NEW__(p0_, p1_, p2_, p3_, p4_);
    COMMIT;
    EXIT WHEN ovs_or%NOTFOUND;
  
  end loop;
  close ovs_or;

end;
