-- LU: OrderQuotation
-- Table: ORDER_QUOTATION_TAB
-- Campos: BUSINESS_OPPORTUNITY_NO
-- Acionamento: BUSINESS_OPPORTUNITY_NO IS NULL

BEGIN

IF '&NEW:BUSINESS_OPPORTUNITY_NO' IS NULL THEN 
     RAISE_APPLICATION_ERROR(-20100,'Só é possível criar Cotação de Vendas através da Oportunidade!');
END IF;

END;