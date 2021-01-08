-- LU: InventoryPart
-- Table: INVENTORY_PART_CFT
-- Campos: ROWKEY, CF$_STATUS_MAT - NEW & ALTER
-- Acionamentos: 

DECLARE

CONTRACT_ VARCHAR2(100);
PART_NO_ VARCHAR2(100);
COST_ VARCHAR2(100);

cursor get_data is
select contract, part_no, zero_cost_flag_db from inventory_part where objkey = '&NEW:ROWKEY';


BEGIN

OPEN get_data;
FETCH get_data INTO CONTRACT_ , PART_NO_ , COST_;
CLOSE get_data;

IF COST_ <> 'O' and '&NEW:CF$_STATUS_MAT' = 'USED' THEN

RAISE_APPLICATION_ERROR(-20101, 'Todo material usado deve ser informado como Apenas Custo Zero!');

END IF;
END;