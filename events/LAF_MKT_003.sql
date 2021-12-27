-- LU: CustomerInfo
-- Table: Customer_Info_Tab
-- Quando: Alterado o campo CORPORATE_FORM
-- Campos: CORPORATE_FORM
-- Acionamento: OLD:CORPORATE_FORM = RD

BEGIN

raise_application_error(-20100,'LAF_MKT_003: Não é possível alterar a origem do cliente quando o mesmo foi converdito de um LEAD com origem do RD Station! ');

END;