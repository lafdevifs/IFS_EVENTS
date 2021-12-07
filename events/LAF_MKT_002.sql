-- LU : BusinessLead
-- Tabela : BUSINESS_LEAD_TAB
-- Quando : Excluído o Registro do LEAD 
-- Campos : ASSOCIATION_NO, CORPORATE_FORM, LEAD_ID, MAIN_CONTACT_NAME, MAIN_REPRESENTATIVE_ID, NAME, SOURCE_ID, STAGE_ID
-- Descrição : Criar registro na tela de histórico de LEADS

DECLARE
   PRAGMA AUTONOMOUS_TRANSACTION;

   notas_       VARCHAR2(32000) := NULL;
   contact_id_  VARCHAR2(32000) := NULL;
   person_name_ VARCHAR2(32000) := NULL;
   phone_       VARCHAR2(32000) := NULL;
   email_       VARCHAR2(32000) := NULL;
   p0_          VARCHAR2(32000) := NULL;
   p1_          VARCHAR2(32000) := NULL;
   p2_          VARCHAR2(32000) := NULL;
   p3_          VARCHAR2(32000) := NULL;
   p4_          VARCHAR2(32000) := 'DO';

BEGIN
   BEGIN
      SELECT TO_CHAR(SUBSTR(A.NOTE, 0, 4000)),
             B.CONTACT_ID,
             B.NAME,
             B.PHONE,
             B.EMAIL
        INTO notas_,
             contact_id_,
             person_name_,
             phone_,
             email_
        FROM IFSLAF.BUSINESS_LEAD A
        LEFT JOIN IFSLAF.BUSINESS_LEAD_CONTACT B ON (A.LEAD_ID = B.LEAD_ID AND B.MAIN_CONTACT_DB = 'TRUE')
       WHERE A.LEAD_ID = '&OLD:LEAD_ID';
   
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         raise_application_error(-20100, 'LAF_MKT_002: O lead ' || '&OLD:LEAD_ID' || ' não está cadastrado!');
   END;

   p3_ := 'CF$_CORPORATE_FORM'         || chr(31) || '&OLD:CORPORATE_FORM'         || chr(30) ||
          'CF$_ASSOCIATION_NO'         || chr(31) || '&OLD:ASSOCIATION_NO'         || chr(30) ||
          'CF$_NAME'                   || chr(31) || '&OLD:NAME'                   || chr(30) ||
          'CF$_NOTAS'                  || chr(31) || notas_                        || chr(30) ||
          'CF$_ORIGEM'                 || chr(31) || '&OLD:SOURCE_ID'              || chr(30) ||
          'CF$_STAGE_ID'               || chr(31) || '&OLD:STAGE_ID'               || chr(30) ||
          'CF$_MAIN_REPRESENTATIVE_ID' || chr(31) || '&OLD:MAIN_REPRESENTATIVE_ID' || chr(30) ||
          'CF$_CONTACT_ID'             || chr(31) || contact_id_                   || chr(30) ||
          'CF$_LEAD_ID'                || chr(31) || '&OLD:LEAD_ID'                || chr(30) ||
          'CF$_CONTRATO_PRINCIPAL_DB'  || chr(31) || '1'                           || chr(30) ||
          'CF$_PERSON_NAME'            || chr(31) || person_name_                  || chr(30) ||
          'CF$_PERSON_PHONE'           || chr(31) || phone_                        || chr(30) ||
          'CF$_PERSON_MAIL'            || chr(31) || email_                        || chr(30) ||
          'CF$_CREATION_DATE'          || chr(31) || '&OLD:CREATION_DATE'          || chr(30);

   IFSLAF.LAF_LEADS_CLP.NEW__(p0_, p1_, p2_, p3_, p4_);

   COMMIT;
END;