-- LU: ProjecMiscProcurement
-- Table: PROJECT_MISC_PROCUREMENT_TAB
-- Campos: REQUEST_DATE - NEW 
-- Acionamento: 

BEGIN 

IF TO_DATE('&NEW:REQUEST_DATE', 'YYYY-MM-DD HH24.MI.SS')  < SYSDATE 

THEN  raise_application_error (-20100, 'A data da requisição não pode ser menor que data atual!');


END IF;

END;
