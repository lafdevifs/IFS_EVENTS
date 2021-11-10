-- Impedir alteração do Origem do LEAD caso o Form Negócio seja RD STATION
-- LU: BusinessLead
-- Tabela: BUSINESS_LEAD_TAB
-- Quando: Alterações : SOURCE_ID
-- Campos: SOURCE_ID, CORPORATE_FORM
-- Acionamento : NEW:DESTINATION_ID = RD

DECLARE 

origem_ VARCHAR(3200) := '&NEW:SOURCE_ID';

BEGIN 

IF origem_ != '05 ' THEN

RAISE_APPLICATION_ERROR(-20100,'LAF_MKT_001: Não é possível alterar a Origem de Atendimento se o Form Negócio é RD STATION! '|| origem_);

END IF;

END;