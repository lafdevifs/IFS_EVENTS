declare

PRAGMA AUTONOMOUS_TRANSACTION;
  -- Análise de crédito
  p1_ varchar2(3200);
begin
  if &NEW:C_AGREEMENT_ID is not null then
    select q.CF$_APPROVED_ANALYSIS_CRED
      into p1_ 
      from C_REC_AGREEMENT_ITEM_CFV q
     where q.AGREEMENT_ID = '&NEW:C_AGREEMENT_ID' and q.objstate = 'Released';
  
    if p1_ <> 'Credito Aprovado' or p1_ is null  then
      raise_application_error(-20100,
                              'Não é possivel gerar ordem de venda, se o crédito não estiver aprovado');
    end if;
    end if;
end;