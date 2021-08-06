CREATE OR REPLACE PACKAGE Laf_Equipment_Utils_Api is 

  module_  CONSTANT VARCHAR2(10) := 'EQUIP';
  lu_name_ CONSTANT VARCHAR2(30) := 'LafEquipmentUtils';
  lu_type_ CONSTANT VARCHAR2(20) := 'Entity';
  
FUNCTION Laf_Get_Prev_Recorded_Value_By_Date (
  
   date_             IN DATE,
   contract_         IN VARCHAR2,
   mch_code_         IN VARCHAR2,
   test_point_id_    IN VARCHAR2,
   parameter_code_   IN VARCHAR2)RETURN NUMBER;
   
FUNCTION Laf_Calc_TM_MTBF (
   date_             IN DATE,
   mch_code_         IN VARCHAR2,
   contract_         IN VARCHAR2) RETURN FLOAT; 
      
FUNCTION Laf_Calc_Qtd_Os (
   date_             IN DATE,
   mch_code_         IN VARCHAR2,
   contract_         IN VARCHAR2) RETURN NUMBER;
   
END Laf_Equipment_Utils_Api;
