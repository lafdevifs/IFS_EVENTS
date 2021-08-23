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
GROUP BY LRM.CONTRACT, LRM.MCH_CODE, LRM.MCH_NAME, LRM.MES_ANO;

