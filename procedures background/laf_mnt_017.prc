create or replace procedure laf_mnt_017(attr_ in varchar2) is
 -- varAux
  p2_ number;
  -- varAux
  p3_ number;
  -- p0 -> __lsResult
  r0_ VARCHAR2(32000) := NULL;

  -- p1 -> __sObjid
  r1_ VARCHAR2(32000) := NULL;

  -- p2 -> __lsObjversion
  r2_ VARCHAR2(32000) := NULL;

  -- p3 -> __lsAttr
  r3_ VARCHAR2(32000) := 'REPLACED_PM_NO' || chr(31) || p3_ || chr(30) ||
                         'REPLACED_PM_REVISION' || chr(31) || '1' ||
                         chr(30) || 'PM_NO' || chr(31) || '' || chr(30) ||
                         'PM_REVISION' || chr(31) || '1' || chr(30);

  -- p4 -> __sAction
  r4_ VARCHAR2(32000) := 'DO';

  cursor c1_ is
    select a.pm_no
      FROM PM_ACTION_UIV a
      join pm_program_object b
        on a.mch_code = b.object_id
     where a.mch_code = client_sys.Get_Item_Value('mchcode_', attr_)
     order by a.pm_no;

begin
  for p1_ in c1_ LOOP
  
    dbms_output.put_line('substituir' || p1_.pm_no);
    -- bloco de programação 
    p2_ := (p1_.pm_no + 1);
  
    select a.pm_no
      into p3_
      from PM_ACTION_UIV a
      join pm_program_object b
        on a.mch_code = b.object_id
     where a.mch_code = client_sys.Get_Item_Value('mchcode_', attr_)
       and a.pm_no = p2_;
    dbms_output.put_line('por' || p3_);
    if p3_ is not null then
      -- Método de substituição 
      r3_ := 'REPLACED_PM_NO' || chr(31) || p1_.pm_no || chr(30) ||
             'REPLACED_PM_REVISION' || chr(31) || '1' || chr(30) || 'PM_NO' ||
             chr(31) || p3_ || chr(30) || 'PM_REVISION' || chr(31) || '1' ||
             chr(30);
    
      ifslaf.pm_action_replaced_api.New__(r0_, r1_, r2_, r3_, r4_);
    end if;
   dbms_output.put_line('Virada de Loop');
  end loop;
exception
  when no_data_found then
    begin
      dbms_output.put_line('Dados não encontrados');
    end;
  
end;
