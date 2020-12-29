declare
  p1_ number;

PRAGMA AUTONOMOUS_TRANSACTION;

begin

  select wo_no
    into p1_
    from active_separate 
   where objstate != 'RELEASED'
     and mch_code = '&NEW:MCH_CODE'
     and work_type_id = 'COR'
     and mch_code_contract = '&NEW:MCH_CODE_CONTRACT'
     and rownum = 1
   order by 1 desc;


      if p1_ is not null then
    raise_application_error(-20100,
                            'Já existe um OS Corretiva para este equipamento, Verifique a OS  Nº ' ||
                            p1_);
  end if;

  exception
    when no_data_found then
    begin
      dbms_output.put_line('NOT DATA FOUND');
    end;
      
end;
