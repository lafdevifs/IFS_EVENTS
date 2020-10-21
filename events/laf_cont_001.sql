begin
  if LENGTH(&NEW:FNE_STATE_ID) != 44 then
    raise_application_error(-20100,
                            'O campo chave de Nfe deve conter 44 digitos');
  
  end if;
  
  select LENGTH(TRIM(TRANSLATE(&NEW:FNE_STATE_ID, '0123456789', ' '))) var
    into p1_
    from DUAL;
  if p1_ is not null then
    raise_application_error(-20100,
                            'O campo chave de Nfe deve conter apenas números');
  end if;
end;


----backup evento funcionando


begin
  if LENGTH(&NEW:FNE_STATE_ID) != 44 then
  raise_application_error(-20100, 'O campo chave de Nfe deve conter 44 digitos');
    
  end if;
end;