create or replace procedure laf_mnt_010(attr_ in varchar2) is
--ação do evento paara que um objeto serial seja sucatado quando uma ordem de fabricação seja criada usando este objserial
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

  r1_ VARCHAR2(3200) := client_sys.Get_Item_Value('ORDER_', attr_);
  --serial_no equipment_serial

  serial_ varchar2(3200);
  --part_no into equipment serial
  part_no varchar(3200);

BEGIN

  select mh.serial_no, mh.part_no
    into serial_, part_no
    from material_history mh
   where mh.order_ref1 = r1_
     AND mh.material_history_action_db = 'ISSUE'
     and serial_no != '*';

  select ES.objid
    into p1_
    from equipment_serial_cfv es
   where es.part_no = part_no
     and es.SERIAL_NO = serial_;

  IFSLAF.EQUIPMENT_SERIAL_CFP.Cf_Modify__(p0_, p1_, p2_, p3_, p4_);

  dbms_output.put_line(p1_);
end;
