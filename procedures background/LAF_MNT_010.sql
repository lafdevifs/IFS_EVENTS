create or replace procedure laf_mnt_010(attr_ in varchar2) is

  -- p0 -> __lsResult
  p0_ VARCHAR2(32000) := NULL;

  -- p1 -> __sObjid
  p1_ VARCHAR2(32000) := NULL;

  -- p2 -> __g_Bind.s[0]
  p2_ VARCHAR2(32000) := 'CF$_STATUS_EQUIPMENT' || chr(31) || 'Sucateado' ||
                         chr(30);

  -- p3 -> __lsAttr
  p3_ VARCHAR2(32000) := 'REMOVE_REQUIREMENTS' || chr(31) || 'FALSE' ||
                         chr(30);

  -- p4 -> __sAction
  p4_ VARCHAR2(32000) := 'DO';

  --serial_no equipment_serial
  serial_ varchar2(3200) := client_sys.Get_Item_Value('serialNo_', attr_);

  --part_no into equipment serial
  part_no_ varchar(3200) := client_sys.Get_Item_Value('partNo_', attr_);

  cursor modify_unic_serial is
    select ES.objid
      from equipment_serial_cfv es
     where es.PART_NO = part_no_
       and es.SERIAL_NO = serial_;

begin

  open modify_unic_serial;
  loop
  fetch modify_unic_serial
    into p1_;
  exit when modify_unic_serial%NOTFOUND;
     IFSLAF.EQUIPMENT_SERIAL_CFP.Cf_Modify__(p0_, p1_, p2_, p3_, p4_);
  end loop;
  close modify_unic_serial;
  
end;
/
