create or replace procedure laf_cont_002(attr_ in varchar2) is

  -- p0 -> __lsResult
  p0_ VARCHAR2(32000) := NULL;

  -- p1 -> __sObjid
  p1_ VARCHAR2(32000) := NULL;

  -- p2 -> __lsObjversion
  p2_ VARCHAR2(32000) := NULL;

  -- p3 -> __lsAttr
  p3_ VARCHAR2(32000) := 'PART_OWNERSHIP' || chr(31) ||
                         'Ativo de Locação da Empresa' || chr(30);

  -- p4 -> __sAction
  p4_ VARCHAR2(32000) := 'DO';

  part_no_ VARCHAR(3200) := client_sys.Get_Item_Value('part_no', attr_);
  vendor_no_ VARCHAR(3200) := client_sys.Get_Item_Value('vendor_no', attr_);

  cursor ativo_de_locacao is
    select pps.objid, pps.OBJVERSION
      from PURCHASE_PART_SUPPLIER pps
     where pps.PART_NO = part_no_ and pps.VENDOR_NO = vendor_no_;
begin

  OPEN ativo_de_locacao;
  LOOP
    FETCH ativo_de_locacao 
          into p1_, p2_;
    EXIT WHEN ativo_de_locacao%NOTFOUND;  
        IFSLAF.PURCHASE_PART_SUPPLIER_API.MODIFY__(p0_, p1_, p2_, p3_, p4_);
  END LOOP;
  CLOSE ativo_de_locacao;

end;
