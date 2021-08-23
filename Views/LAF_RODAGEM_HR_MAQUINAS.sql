CREATE OR REPLACE VIEW LAF_RODAGEM_HR_MAQUINAS_ AS 
SELECT EOM.CONTRACT, EOM.MCH_CODE, EOM.MCH_NAME, EOM.MES_ANO , EOM.RODAGEM 
FROM (  SELECT EOM.CONTRACT, EOM.MCH_CODE, IFSLAF.Equipment_Object_API.Get_Mch_Name(EOM.CONTRACT, EOM.MCH_CODE) AS  MCH_NAME 
               ,CASE 
                 WHEN (SELECT NVL(SUM(COUNT(DISTINCT(WO_NO))),0) AS OS  FROM  IFSLAF.JT_TASK_UIV JTU
                                                      WHERE JTU.work_type_id = 'COR'
                                                      AND JTU.ACTUAL_OBJECT_ID = EOM.MCH_CODE
                                                      AND JTU.actual_object_site = EOM.CONTRACT
                                                      AND JTU.OBJSTATE IN ('FINISHED','WORKDONE')
                                                      AND SUBSTR(TRUNC(JTU.actual_finish),4,6) = substr(TRUNC(EOM.REG_DATE),4,6)
                                                      GROUP BY SUBSTR(TRUNC(JTU.actual_finish),4,6) ) = 0 
                    AND (substr(TRUNC(EOM.REG_DATE),4,6)) != (SUBSTR(TRUNC(SYSDATE),4,6))
                 THEN SUBSTR(TO_CHAR(ADD_MONTHS((TRUNC(EOM.REG_DATE)),1),'DD/MM/YY'),4,6)
             ELSE SUBSTR(TRUNC(EOM.REG_DATE),4,6) 
             END MES_ANO

              ,SUM((EOM.MEASURED_VALUE - IFSLAF.Laf_Equipment_Utils_Api.Laf_Get_Prev_Recorded_Value_By_Date(EOM.reg_date,EOM.contract,EOM.mch_code,EOM.test_point_id, EOM.parameter_code)) ) AS RODAGEM 
                       FROM   IFSLAF.EQUIPMENT_OBJECT_MEAS_TAB EOM
                       WHERE EOM.parameter_code = 'HR'
                       AND EOM.test_point_id = '*'
                       AND EOM.Measurement_Type = 'RecordedReading'
                       AND EOM.reg_date > TO_DATE('01/04/2021','DD/MM/YYYY')
                       GROUP BY 
                       EOM.CONTRACT, EOM.MCH_CODE, IFSLAF.Equipment_Object_API.Get_Mch_Name(EOM.CONTRACT, EOM.MCH_CODE) 
                       , substr(TRUNC(EOM.REG_DATE),4,6) 
                       ,SUBSTR(TO_CHAR(ADD_MONTHS((TRUNC(EOM.REG_DATE)),1),'DD/MM/YY'),4,6)
                       ORDER BY substr(TRUNC(EOM.REG_DATE),4,6)       
         
      ) EOM 
LEFT JOIN IFSLAF.JT_TASK_UIV JTUE
              ON ( JTUE.actual_object_site =  EOM.CONTRACT 
              AND JTUE.actual_object_id = EOM.mch_code 
              AND JTUE.OBJSTATE IN ('FINISHED','WORKDONE') )
WHERE EOM.MES_ANO = SUBSTR(TRUNC(JTUE.actual_finish),4,6)
GROUP BY EOM.CONTRACT, EOM.CONTRACT, EOM.MCH_CODE, EOM.MCH_NAME ,  EOM.MES_ANO ,EOM.RODAGEM