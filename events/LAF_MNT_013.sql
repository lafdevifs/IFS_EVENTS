DECLARE

  contract_   varchar(3) := null;
  part_no_    varchar(20) := null;
  disponivel_ varchar(10) := null;

BEGIN

  select ESV.CONTRACT, ESV.PART_NO
    INTO contract_, part_no_
    from ifslaf.equipment_serial_uiv esv
   where esv.serial_no = '&NEW:MCH_CODE';

  select ipis.serial_no
   into disponivel_
    from ifslaf.inventory_part_in_stock ipis
   where ipis.qty_onhand = 1
     and ipis.qty_reserved = 0
     and ipis.serial_no = '&NEW:MCH_CODE'
     and ipis.contract = contract_
     and ipis.part_no = part_no_;
    
    IF disponivel_ IS NULL THEN
    
      RAISE_APPLICATION_ERROR(-20100, 'LAF_MNT_013: #USER_ID#,  não existe estoque para o Objeto: &NEW:MCH_CODE, só é possível gerar O.S. de Transformação para objetos que possuam estoque. ');
  
    END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    BEGIN
        RAISE_APPLICATION_ERROR(-20100,'LAF_MNT_013: #USER_ID#,  não existe estoque para o Objeto: &NEW:MCH_CODE, só é possível gerar O.S. de Transformação para objetos que possuam estoque. ');
    END;
END;