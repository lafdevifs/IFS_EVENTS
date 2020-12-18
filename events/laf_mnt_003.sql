
DECLARE
   -- p0 -> __lsResult
   p0_ VARCHAR2(32000) := NULL;

   -- p1 -> __sObjid
   p1_ VARCHAR2(32000) := NULL;

   -- p2 -> __g_Bind.s[0]
   p2_ VARCHAR2(32000) := 'CF$_LOCEQUIP'||chr(31)||'No Cliente'||chr(30);

   -- p3 -> __lsAttr
   p3_ VARCHAR2(32000) := 'REMOVE_REQUIREMENTS'||chr(31)||'FALSE'||chr(30);

   -- p4 -> __sAction
   p4_ VARCHAR2(32000) := 'DO';

   r1_ VARCHAR2(3200) := NULL;


BEGIN

select OBJID
  into p1_  
  from EQUIPMENT_SERIAL_CFV
 where part_no = 

IFSLAF.EQUIPMENT_SERIAL_CFP.Cf_Modify__(p0_ , p1_ , p2_ , p3_ , p4_ );

END;

