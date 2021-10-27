-- Confere igualdade entre condições de pagamento da ordem de compra e da NF 
-- LU : FiscalNoteTemp
-- Table: FISCAL_NOTE_TEMP_TAB
-- Ação: Novos
-- Campos : ADDRESSEE_ID, INPUT_OUTPUT_TYPE, PAY_TERM_ID, CONTRACT
-- Campo Personalizado: PAY_TER_OC : PURCHASE_ORDER_API.Get_Pay_Term_Id(PURCHASE_ORDER_INFO(&NEW:ADDRESSEE_ID,&NEW:CONTRACT)) 


BEGIN

if (&NEW:PAY_TERM_ID != &PAY_TER_OC)  THEN

raise_application_error(-20100 ,'Laf_Central_NF_003 Diz: Condição de Pagamento difere da proposta na ordem de compra');

end if;

END;