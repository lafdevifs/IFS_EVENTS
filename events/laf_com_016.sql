DECLARE

  contract_ VARCHAR(3200) := NULL;

  cursor verificarsite_ is
    select bol.contract
      from BUSINESS_OPPORTUNITY_LINE_tab bol
     where opportunity_no = &NEW:OPPORTUNITY_NO;

begin

  open verificarsite_;
  loop
    fetch verificarsite_
      into contract_;
    exit when verificarsite_%NOTFOUND;
    if contract_ != &NEW:CONTRACT then
      raise_application_error(-20100,
                              'Não é permitido sites diferentes na mesma oportunidade');
    
    end if;
  
  end loop
  
  close ;
end;