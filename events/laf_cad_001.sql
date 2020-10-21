begin
  if &NEW:CNPJ = '00.000.000/0000-00' or 
  &NEW:CNPJ = '99.999.999/9999-99' or 
  &NEW:CNPJ = '11.111.111/1111-11' or 
  &NEW:CNPJ = '22.222.222/2222-22' or 
  &NEW:CNPJ = '33.333.333/3333-33' or 
  &NEW:CNPJ = '44.444.444/4444-44' or 
  &NEW:CNPJ = '55.555.555/5555-55' or 
  &NEW:CNPJ = '66.666.666/6666-66' or 
  &NEW:CNPJ = '77.777.777/7777-77' or 
  &NEW:CNPJ = '88.888.888/8888-88' or
  then
  raise_application_error(-20100, 'O CNPJ', &NEW:CNPJ,'é inválido'); 
  end if;
  if 
      lenght(&NEW:CNPJ) =! 18 then
      raise_application_error(-20100, 'O CNPJ', &NEW:CNPJ,'está incompleto'); 
    
  end if;
end;