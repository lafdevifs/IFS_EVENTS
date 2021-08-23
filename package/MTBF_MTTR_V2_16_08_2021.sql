select * 
from ifsinfo.laf_mtbf_mttr_ial
where mch_code = 'L96';

select  eom.contract, --eom.recorded_value , eom.reg_date, eom.remark, 
SUBSTR(eom.reg_date,4,6) ,(
       select count(*)
       from historical_separate_overview hso
       where hso.mch_code = eom.mch_code
       and hso.work_type_id='COR'
       and substr(hso.real_s_date,4,6) = substr(eom.reg_date,4,6)

) qtd_os_cor
from ifslaf.EQUIPMENT_OBJECT_MEAS EOM
WHERE EOM.MCH_CODE in (
select hso.mch_code
from HISTORICAL_SEPARATE_OVERVIEW hso
where hso.mch_code='L96'
and hso.work_type_id='COR'
and SUBSTR(hso.real_s_date,4,6) = SUBSTR(eom.reg_date,4,6)
) 
and eom.measurement_type_db = 'RecordedReading'
and eom.reg_date between to_date('01/04/2021','dd/mm/yyyy') and to_date('30/08/2021','dd/mm/yyyy')
GROUP BY  eom.mch_code, eom.contract,SUBSTR(eom.reg_date,4,6)
order by SUBSTR(eom.reg_date,4,6);


------------

select * 
from HISTORICAL_SEPARATE_OVERVIEW hso
where hso.mch_code='L96'
and hso.work_type_id='COR';

------------


SELECT * FROM ifslaf.EQUIPMENT_OBJECT_MEAS EOM WHERE EOM.mch_code= 'L96' and eom.measurement_type_db = 'RecordedReading' AND REG_DATE > TO_dATE('01/04/2021','DD/MM/YYYY') ORDER BY REG_DATE ;

-----------------------------
-----------------------------
---------- 19/08/2021 ------
----------------------------
----------------------------- NOVA VIEW MTBF MTTR VERSAO 2

SELECT LRM.CONTRACT, LRM.MCH_CODE, LRM.MCH_NAME, LRM.MES_ANO, SUM(LRM.RODAGEM) RODAGEM
, (SELECT NVL(SUM(24*(MAX(JTU.actual_finish) -MIN(JTU.actual_start))),0) HORAS
        FROM  IFSLAF.JT_TASK_UIV JTU
        WHERE JTU.work_type_id = 'COR'
        AND JTU.ACTUAL_OBJECT_ID = LRM.MCH_CODE
        AND JTU.actual_object_site  = LRM.CONTRACT
        AND JTU.OBJSTATE IN ('FINISHED','WORKDONE')
        AND SUBSTR(TRUNC(JTU.actual_finish),4,6) = LRM.MES_ANO
            GROUP BY SUBSTR(TRUNC(JTU.actual_finish),4,6)
    ) TEMPO_EM_MANUTENCAO  
,   (SELECT NVL(SUM(COUNT(DISTINCT(WO_NO))),0) AS OS   FROM  IFSLAF.JT_TASK_UIV JTU
                                                    WHERE JTU.work_type_id = 'COR'
                                                    AND JTU.ACTUAL_OBJECT_ID = LRM.MCH_CODE
                                                    AND JTU.actual_object_site  = LRM.CONTRACT
                                                    AND JTU.OBJSTATE IN ('FINISHED','WORKDONE')
                                                    AND SUBSTR(TRUNC(JTU.actual_finish),4,6) = LRM.MES_ANO
                                                        GROUP BY SUBSTR(TRUNC(JTU.actual_finish),4,6)
    ) QTD_OS
, ( NVL( (SUM(LRM.RODAGEM))
            /
        (SELECT SUM(COUNT(DISTINCT(WO_NO))) AS OS   FROM  IFSLAF.JT_TASK_UIV JTU
                                                    WHERE JTU.work_type_id = 'COR'
                                                    AND JTU.ACTUAL_OBJECT_ID = LRM.MCH_CODE
                                                    AND JTU.actual_object_site  = LRM.CONTRACT
                                                    AND JTU.OBJSTATE IN ('FINISHED','WORKDONE')
                                                    AND SUBSTR(JTU.actual_finish,4,6) = LRM.MES_ANO
                                                        GROUP BY SUBSTR(TRUNC(JTU.actual_finish),4,6)
            ),0
        )
    ) MTBF 
,     (NVL(  (SELECT SUM(24*(MAX(JTU.actual_finish) -MIN(JTU.actual_start))) HORAS    FROM  IFSLAF.JT_TASK_UIV JTU
                                                                                    WHERE JTU.work_type_id = 'COR'
                                                                                    AND JTU.ACTUAL_OBJECT_ID = LRM.MCH_CODE
                                                                                    AND JTU.actual_object_site = LRM.CONTRACT
                                                                                    AND JTU.OBJSTATE IN ('FINISHED','WORKDONE')
                                                                                    AND SUBSTR(TRUNC(JTU.actual_finish),4,6) = LRM.MES_ANO
                                                                                    GROUP BY SUBSTR(TRUNC(JTU.actual_finish),4,6)
            ) 
            / 
            (  SELECT SUM(COUNT(DISTINCT(WO_NO))) AS OS   FROM  IFSLAF.JT_TASK_UIV JTU
                                                WHERE JTU.work_type_id = 'COR'
                                                AND JTU.ACTUAL_OBJECT_ID = LRM.MCH_CODE
                                                AND JTU.actual_object_site = LRM.CONTRACT
                                                AND JTU.OBJSTATE IN ('FINISHED','WORKDONE')
                                                AND SUBSTR(TRUNC(JTU.actual_finish),4,6) = LRM.MES_ANO
                                                GROUP BY  SUBSTR(TRUNC(JTU.actual_finish),4,6)
            ) ,0
        )
    ) MTTR

FROM IFSINFO.LAF_RODAGEM_HR_MAQUINAS LRM
WHERE LRM.CONTRACT = '09'
AND LRM.MCH_CODE = 'L96'
GROUP BY LRM.CONTRACT, LRM.MCH_CODE, LRM.MCH_NAME, LRM.MES_ANO;

-----------------------------
-----------------------------
---------- 23/08/2021 ------
----------------------------
----------------------------- NOVA VIEW MTBF MTTR VERSAO 3

SELECT LRM.CONTRACT, LRM.MCH_CODE, LRM.MCH_NAME, LRM.MES_ANO, SUM(LRM.RODAGEM) RODAGEM
, (SELECT NVL(SUM(24*(MAX(JTU.actual_finish) -MIN(JTU.actual_start))),0) HORAS
        FROM  IFSLAF.JT_TASK_UIV JTU
        WHERE JTU.work_type_id = 'COR'
        AND JTU.ACTUAL_OBJECT_ID = LRM.MCH_CODE
        AND JTU.actual_object_site  = LRM.CONTRACT
        AND JTU.OBJSTATE IN ('FINISHED','WORKDONE')
        AND SUBSTR(TRUNC(JTU.actual_finish),4,6) = LRM.MES_ANO
            GROUP BY SUBSTR(TRUNC(JTU.actual_finish),4,6)
    ) TEMPO_EM_MANUTENCAO  
,   (SELECT NVL(SUM(COUNT(DISTINCT(WO_NO))),0) AS OS   FROM  IFSLAF.JT_TASK_UIV JTU
                                                    WHERE JTU.work_type_id = 'COR'
                                                    AND JTU.ACTUAL_OBJECT_ID = LRM.MCH_CODE
                                                    AND JTU.actual_object_site  = LRM.CONTRACT
                                                    AND JTU.OBJSTATE IN ('FINISHED','WORKDONE')
                                                    AND SUBSTR(TRUNC(JTU.actual_finish),4,6) = LRM.MES_ANO
                                                        GROUP BY SUBSTR(TRUNC(JTU.actual_finish),4,6)
    ) QTD_OS
, ( NVL( (SUM(LRM.RODAGEM))
            /
        (SELECT SUM(COUNT(DISTINCT(WO_NO))) AS OS   FROM  IFSLAF.JT_TASK_UIV JTU
                                                    WHERE JTU.work_type_id = 'COR'
                                                    AND JTU.ACTUAL_OBJECT_ID = LRM.MCH_CODE
                                                    AND JTU.actual_object_site  = LRM.CONTRACT
                                                    AND JTU.OBJSTATE IN ('FINISHED','WORKDONE')
                                                    AND SUBSTR(JTU.actual_finish,4,6) = LRM.MES_ANO
                                                        GROUP BY SUBSTR(TRUNC(JTU.actual_finish),4,6)
            ),0
        )
    ) MTBF 
,     (NVL(  (SELECT SUM(24*(MAX(JTU.actual_finish) -MIN(JTU.actual_start))) HORAS    FROM  IFSLAF.JT_TASK_UIV JTU
                                                                                    WHERE JTU.work_type_id = 'COR'
                                                                                    AND JTU.ACTUAL_OBJECT_ID = LRM.MCH_CODE
                                                                                    AND JTU.actual_object_site = LRM.CONTRACT
                                                                                    AND JTU.OBJSTATE IN ('FINISHED','WORKDONE')
                                                                                    AND SUBSTR(TRUNC(JTU.actual_finish),4,6) = LRM.MES_ANO
                                                                                    GROUP BY SUBSTR(TRUNC(JTU.actual_finish),4,6)
            ) 
            / 
            (  SELECT SUM(COUNT(DISTINCT(WO_NO))) AS OS   FROM  IFSLAF.JT_TASK_UIV JTU
                                                WHERE JTU.work_type_id = 'COR'
                                                AND JTU.ACTUAL_OBJECT_ID = LRM.MCH_CODE
                                                AND JTU.actual_object_site = LRM.CONTRACT
                                                AND JTU.OBJSTATE IN ('FINISHED','WORKDONE')
                                                AND SUBSTR(TRUNC(JTU.actual_finish),4,6) = LRM.MES_ANO
                                                GROUP BY  SUBSTR(TRUNC(JTU.actual_finish),4,6)
            ) ,0
        )
    ) MTTR
FROM (
SELECT EOM.CONTRACT, EOM.MCH_CODE, EOM.MCH_NAME, EOM.MES_ANO , EOM.RODAGEM 
FROM (  SELECT EOM.CONTRACT, EOM.MCH_CODE, IFSLAF.Equipment_Object_API.Get_Mch_Name(EOM.CONTRACT, EOM.MCH_CODE) AS  MCH_NAME 
               ,CASE 
                 WHEN (SELECT NVL(SUM(COUNT(DISTINCT(WO_NO))),0) AS OS  FROM  IFSLAF.JT_TASK_UIV JTU -- VERIFICA SE POSSIU O.S. PARA O HORIMETRO
                                                      WHERE JTU.work_type_id = 'COR'
                                                      AND JTU.ACTUAL_OBJECT_ID = EOM.MCH_CODE
                                                      AND JTU.actual_object_site = EOM.CONTRACT
                                                      AND JTU.OBJSTATE IN ('FINISHED','WORKDONE')
                                                      AND SUBSTR(TRUNC(JTU.actual_finish),4,6) = substr(TRUNC(EOM.REG_DATE),4,6)
                                                      GROUP BY SUBSTR(TRUNC(JTU.actual_finish),4,6) ) = 0 
                    AND ( SELECT NVL(SUM(COUNT(DISTINCT(WO_NO))),0) AS OS  FROM  IFSLAF.JT_TASK_UIV JTU  -- VERIFICA SE POSSUI MAIS DE UMA O.S. PARA O PROXIMO MES DO HORIMETRO
                                                      WHERE JTU.work_type_id = 'COR'
                                                      AND JTU.ACTUAL_OBJECT_ID = EOM.MCH_CODE
                                                      AND JTU.actual_object_site = EOM.CONTRACT
                                                      AND JTU.OBJSTATE IN ('FINISHED','WORKDONE')
                                                      AND NOT EXISTS (SELECT SUBSTR(TO_CHAR(ADD_MONTHS((TRUNC(EOM.REG_DATE)),1),'DD/MM/YY'),4,6) FROM DUAL)  
                                                      GROUP BY SUBSTR(TRUNC(JTU.actual_finish),4,6)   ) > 1
                   AND ( substr(TRUNC(EOM.REG_DATE),4,6)) != (SUBSTR(TRUNC(SYSDATE),4,6))                       -- VERIFICA SE O MES VERIFICADO DO HORIMETRO NAO E O ATUA, 
                 THEN SUBSTR(TO_CHAR(ADD_MONTHS((TRUNC(EOM.REG_DATE)),1),'DD/MM/YY'),4,6)  -- ADICINA 1 MES NO MES DO HORIMETOS LANÇADO, SE O HORIMETOR NÃO POSSUI O.S., O PROXIMO MES O POSSUI PELO MENOS UMA O.S. E O MES DO HORIMETRO NÃO É MES ATUAL.
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
      ) EOM 
LEFT JOIN IFSLAF.JT_TASK_UIV JTUE
              ON ( JTUE.actual_object_site =  EOM.CONTRACT 
              AND JTUE.actual_object_id = EOM.mch_code 
              AND JTUE.OBJSTATE IN ('FINISHED','WORKDONE') )
WHERE EOM.MES_ANO = SUBSTR(TRUNC(JTUE.actual_finish),4,6)
GROUP BY EOM.CONTRACT, EOM.CONTRACT, EOM.MCH_CODE, EOM.MCH_NAME ,  EOM.MES_ANO ,EOM.RODAGEM
)LRM
WHERE LRM.contract = '10'
GROUP BY LRM.CONTRACT, LRM.MCH_CODE, LRM.MCH_NAME, LRM.MES_ANO;

