-- Impedir requisição de compra dentro da O.S. diferente de FRETE
-- LU: PurchaseRequisition
-- Tabela: PUCHASE_REQUISITION_TAB
-- Quando: Novos e Alterações : DESTINAITON_ID
-- Campos: MARK_FOR, DESTINATION_ID
-- Acionamento : NEW:DESTINATION_ID != FRETE

DECLARE

origem_ varchar2(200) :=  '&NEW:MARK_FOR';
os_ varchar2(200);


BEGIN

select * 
into os_
from dual 
where REGEXP_LIKE(origem_,'Ordem Serviço$');

IF os_ = 'X' then

  RAISE_APPLICATION_ERROR(-20100, 'LAF_MNT_020: Não é possível abrir Requisição de Compra dentro da O.S. sem que o tipo de destino seja FRETE! ' || os_);

END IF;
exception
  when no_data_found then
  begin

      DBMS_OUTPUT.PUT_LINE('Dados não encontrados');

  end;

END;
