-- LU: PurchaseReqLinePart
-- Table: PURCHASE_REQ_LINE_TAB
-- Campos: PART_NO
-- Acionamentos: 

DECLARE

  MATERIAL_USADO_ VARCHAR2(200);

  CURSOR GET_MATERIAL_USADO IS
    SELECT 1
      FROM INVENTORY_PART_CFV
     WHERE CF$_STATUS_MAT_DB = 'USED'
       AND PART_NO = '&NEW:PART_NO';

BEGIN

  OPEN GET_MATERIAL_USADO;
  FETCH GET_MATERIAL_USADO
    INTO MATERIAL_USADO_;
  CLOSE GET_MATERIAL_USADO;

  IF MATERIAL_USADO_ IS NOT NULL THEN
  
    RAISE_APPLICATION_ERROR(-20100,
                           'Material usado não pode ser vinculado na ordem de compra'');
  
  END IF;

END;