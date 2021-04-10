DECLARE
  
ANALYSIS_CREDIT_ VARCHAR2(3200) := '2';

BEGIN

    SELECT CF$_APPROVED_ANALYSIS_CRED_DB
    INTO ANALYSIS_CREDIT_
    FROM LAF_CREDIT_ANALYSIS_CLV
    WHERE CF$_QUOTATION_NO = &NEW:QUOTATION_NO
    AND CF$_APPROVED_ANALYSIS_CRED_DB = '2'
    ORDER BY OBJVERSION DESC;

IF ANALYSIS_CREDIT_DB = 2 THEN 

    RAISE_APPLICATION_ERROR(-20100,
                            'LAF_FIN_008: Não é possível enviar para a análise de crédito, pois a linha já está em análise aguarde retorno do Financeiro!');

END IF;


EXCEPTION
  WHEN NO_DATA_FOUND THEN
    BEGIN
        RAISE_APPLICATION_ERROR(-20100,'Não foi possível encontrar os dados!');
    END;
END;