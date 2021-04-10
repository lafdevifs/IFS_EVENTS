DECLARE

SITE_OS_ VARCHAR2(3200) := '&NEW:CONTRACT';
SITE_EQUIP_ VARCHAR2(3200) := '&NEW:MCH_CODE_CONTRACT';


BEGIN

IF SITE_OS_ != SITE_EQUIP_ THEN

RAISE_APPLICATION_ERROR(-20100,'LAF_MNT_027: O site do equipamento não pode ser diferente do site informado no cabeçalho da Ordem de Serviço!');

END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    BEGIN
      RAISE_APPLICATION_ERROR(-20100, 'Não foi possível encontrar dados!');
    END;
  

END;