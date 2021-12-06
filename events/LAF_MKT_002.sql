-- LU : BusinessLead
-- Tabela : BUSINESS_LEAD_TAB
-- Quando : Alteração : MAIN_REPRESENTATIVE_ID
-- Campos : ASSOCIATION_NO, CORPORATE_FORM, LEAD_ID, MAIN_CONTACT_NAME, MAIN_REPRESENTATIVE_ID, NAME, SOURCE_ID, STAGE_ID
-- Descrição : Criar registro na tela de histórico de LEADS


DECLARE

PRAGMA AUTONOMOUS_TRANSACTION;

 notas_ varchar2 (3200) :=null;

 contact_id_ varchar2 (3200) := null;
 person_name_ varchar2(3200) := null;
 phone_ varchar2(3200) := null;
 email_ varchar2(3200) := null;

   p0_ VARCHAR2(32000) := NULL;
   p1_ VARCHAR2(32000) := NULL;
   p2_ VARCHAR2(32000) := NULL;
   p3_ VARCHAR2(32000) := NULL;
   p4_ VARCHAR2(32000) := 'DO';

BEGIN
    IFSLAF.Log_SYS.Init_Debug_Session_('bp');

  SELECT TO_CHAR(SUBSTR(NOTE,0,3999))
  INTO notas_
  FROM IFSLAF.BUSINESS_LEAD 
  WHERE LEAD_ID = '&NEW:LEAD_ID';

  SELECT CONTACT_ID,NAME, PHONE, EMAIL
  INTO contact_id_,person_name_, phone_, email_
  FROM IFSLAF.BUSINESS_LEAD_CONTACT
  WHERE LEAD_ID = '&NEW:LEAD_ID';

  p3_ := 
 'CF$_CORPORATE_FORM'||chr(31)||  '&NEW:CORPORATE_FORM'  ||chr(30)||
 'CF$_ASSOCIATION_NO'||chr(31)||  '&NEW:ASSOCIATION_NO'   ||chr(30)||
 'CF$_NAME'||chr(31)||  '&NEW:NAME'  ||chr(30)||
 'CF$_NOTAS'||chr(31)|| notas_ ||chr(30)||
 'CF$_ORIGEM'||chr(31)||  '&NEW:SOURCE_ID' ||chr(30)||
 'CF$_STAGE_ID'||chr(31)||  '&NEW:STAGE_ID' ||chr(30)||
 'CF$_MAIN_REPRESENTATIVE_ID'||chr(31)|| '&NEW:MAIN_REPRESENTATIVE_ID' || chr(30)||
 'CF$_CONTACT_ID'||chr(31)|| contact_id_||chr(30)||
 'CF$_LEAD_ID'||chr(31)||   '&NEW:LEAD_ID' ||chr(30)||
 'CF$_CONTRATO_PRINCIPAL_DB'||chr(31)||'1'||chr(30)||
 'CF$_PERSON_NAME'||chr(31)||  person_name_ ||chr(30)||
 'CF$_PERSON_PHONE'||chr(31)||  phone_  ||chr(30)||
 'CF$_PERSON_MAIL'||chr(31)|| email_ ||chr(30)||
 'CF$_CREATION_DATE'||chr(31)|| '&NEW:CREATION_DATE' || chr(30)
;
    
IFSLAF.LAF_LEADS_CLP.NEW__( p0_ , p1_ , p2_ , p3_ , p4_ );

commit;

   ----------------------------------
   ---Dbms_Output Section---
   ----------------------------------
   Dbms_Output.Put_Line('p0_ -> __lsResult');
   Dbms_Output.Put_Line(p0_);
   Dbms_Output.New_Line;

   Dbms_Output.Put_Line('p1_ -> __sObjid');
   Dbms_Output.Put_Line(p1_);
   Dbms_Output.New_Line;

   Dbms_Output.Put_Line('p2_ -> __lsObjversion');
   Dbms_Output.Put_Line(p2_);
   Dbms_Output.New_Line;

   Dbms_Output.Put_Line('p3_ -> __lsAttr');
   Dbms_Output.Put_Line(p3_);
   Dbms_Output.New_Line;

   Dbms_Output.Put_Line('p4_ -> __sAction');
   Dbms_Output.Put_Line(p4_);
   ----------------------------------

END;