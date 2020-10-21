CREATE OR REPLACE PROCEDURE LAF_COM_012 (attr_ IN VARCHAR2) IS
-- Ação do evento para que todas os casos (PROCESSO COMERCIAL CALL CENTER) sejam aceitos automaticamente quando criados.
  -- p0 -> __lsResult
  p0_ VARCHAR2(32000) := '';

  -- p1 -> __sObjid
  p1_ VARCHAR2(32000) := NULL;

  -- p2 -> __lsObjversion
  p2_ VARCHAR2(32000) := NULL;

  -- p3 -> __lsAttr
  p3_ VARCHAR2(32000) := 'FOCUS_ID' || chr(31) || 'EM ANALISE' || chr(30) ||
                         'ORGANIZATION_ID' || chr(31) ||
                         'Processo Comercial' || chr(30) || 'WORK_FOLDER' ||
                         chr(31) || 'Default' || chr(30) || 'MESSAGE' ||
                         chr(31) || '' || chr(30) || 'CONTACT_DATE' ||
                         chr(31) || '' || chr(30);

  -- p4 -> __sAction
  p4_ VARCHAR2(32000) := 'DO';

  r1_  VARCHAR2(3200):= client_sys.Get_Item_Value('CASE_ID', attr_);

BEGIN
  SELECT objid ,OBJVERSION into p1_ ,p2_ FROM CC_CASE WHERE CASE_ID = r1_;

  IFSLAF.CC_CASE_API.ACCEPT__(p0_, p1_, p2_, p3_, p4_);

END;
