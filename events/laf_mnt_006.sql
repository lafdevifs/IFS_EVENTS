DECLARE
 
  p0_ VARCHAR2(32000) := NULL;
  p1_ VARCHAR2(32000) := NULL;
  p2_ VARCHAR2(32000) := 'CF$_STATUS_EQUIPMENT' || chr(31) || 'Manutenção' || chr(30);
  p3_ VARCHAR2(32000) := 'REMOVE_REQUIREMENTS' || chr(31) || 'FALSE' || chr(30);
  p4_ VARCHAR2(32000) := 'DO';
 
BEGIN
 
  SELECT objid
    INTO p1_
    FROM equipment_serial
   WHERE contract = '&NEW:MCH_CODE_CONTRACT'  AND mch_code = '&NEW:MCH_CODE';
 
    IFSLAF.Log_SYS.Init_Debug_Session_('bp');
    IFSLAF.EQUIPMENT_SERIAL_CFP.Cf_Modify__(p0_, p1_, p2_, p3_, p4_);
 
END; 