select 								
'HOSP' TIPO_VENTA,TO_CHAR(A.FECHA_CONTABLE,'DD/MM/YYYY') FECHA_PAGO,								
 A.COD_CENTRO CENTROCOSTO_MOV,a.cod_unidad, A.ID_INGRESO,COD_PROF, a.COD_ISAPRE isapre, 								
A.COD_PRESTACION, 								
SUM(A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) CANT,								
SUM(A.VALOR_TOTAL*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) TOTAL,								
SUM(A.VALOR_AFECTO*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) AFECTO,								
SUM(A.VALOR_EXENTO*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) EXENTO,								
SUM(A.VALOR_AFECTO*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) +								
 SUM(A.VALOR_EXENTO*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) NETO								
 from INT_VENTA_DEVENGADA A, TAB_PARAMET G, ap_prestaciones ap, gen_isapre GI								
 WHERE A.FECHA_CONTABLE >= TO_DATE ( :Fecha_inicio,'DD/MM/YYYY')								
 AND A.FECHA_CONTABLE < TO_DATE ( :Fecha_final,'DD/MM/YYYY')								
 --AND A.COD_CENTRO IN (15010) 								
AND A.CONSUMO_URGENCIA IS NULL 								
AND A.TIPO_CONSUMO <> 'HMQ' 								
AND A.COD_EMPRESA= 15 								
and CODIGO_MOVIMIENTO IN (100,101,110,111,150,151)								
 and a.cod_empresa=g.cod_empresa 								
and a.COD_CENTRO=G.COD_ITEM 								
AND G.COD_GRUPO=5 								
and A.COBRO_ISAPRE ='S' 								
and A.COBRO_PACIENTE ='S' 								
and a.cod_empresa=ap.cod_empresa 								
and a.cod_prestacion=ap.cod_prestacion  								
and a.cod_empresa=GI.cod_empresa 								
and a.cod_isapre=gi.cod_isapre 								
--and a.COD_PRESTACION='50-04-501-00' 								
GROUP BY TO_CHAR(A.FECHA_CONTABLE,'DD/MM/YYYY'), 'HOSP', A.FECHA_CONTABLE, 'DD/MM/YYYY', A.COD_CENTRO, 
a.cod_unidad, A.ID_INGRESO, COD_PROF, COD_PROF, a.COD_ISAPRE, 
A.COD_PRESTACION 								
UNION 								
select 								
'HOSP' TIPO_VENTA,TO_CHAR(A.FECHA_CONTABLE,'DD/MM/YYYY') FECHA_PAGO,								
 A.COD_CENTRO CENTROCOSTO_MOV,a.cod_unidad, A.ID_INGRESO,COD_PROF, a.COD_ISAPRE isapre, 								
'INSUMOS Y FARMACOS', 								
SUM(A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) CANT,								
 SUM(A.VALOR_TOTAL*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) TOTAL,								
SUM(A.VALOR_AFECTO*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) AFECTO,								
 SUM(A.VALOR_EXENTO*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) EXENTO,								
 SUM(A.VALOR_AFECTO*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) +								
 SUM(A.VALOR_EXENTO*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) NETO								
 from INT_VENTA_DEVENGADA A, TAB_PARAMET G,  gen_isapre GI								
 WHERE A.FECHA_CONTABLE >= TO_DATE ( :Fecha_inicio,'DD/MM/YYYY')								
 AND A.FECHA_CONTABLE < TO_DATE ( :Fecha_final,'DD/MM/YYYY')								
 --AND A.COD_CENTRO IN (15010) 								
AND A.CONSUMO_URGENCIA IS NULL 								
AND A.TIPO_CONSUMO <> 'HMQ' 								
AND A.COD_EMPRESA= 15 								
and CODIGO_MOVIMIENTO IN (100,101,110,111,150,151)								
 and a.cod_empresa=g.cod_empresa 								
and a.COD_CENTRO=G.COD_ITEM 								
AND G.COD_GRUPO=5 								
and A.COBRO_ISAPRE ='S' 								
and A.COBRO_PACIENTE ='S' 								
AND A.COD_PRODUCTO > 0 								
and a.cod_empresa=GI.cod_empresa 								
and a.cod_isapre=gi.cod_isapre 								
--AND A.COD_PRODUCTO IN (10550013,10550017)  								
GROUP BY TO_CHAR(A.FECHA_CONTABLE,'DD/MM/YYYY'),								
 A.COD_CENTRO,a.cod_unidad, A.ID_INGRESO,COD_PROF, a.COD_ISAPRE								
union								
Select            								
decode(A.COD_SISTEMA,4,'URG','AMB') TIPO_VENTA,TO_CHAR(fecha_pago,'DD/MM/YYYY') fecha_Pago,                      								
cod_centro centrocosto_mov, 								
cod_unidad,ID_ATENCION,COD_PROF, --ID_AMBULATORIO, 								
COD_PREVISION Isapre,             								
                   SUBSTR(TO_CHAR(a.grupo_pres,'09'),2,2)||'-'||             								
                   SUBSTR(TO_CHAR(a.tipo_pres,'09'),2,2)||'-'||              								
                  SUBSTR(TO_CHAR(a.codigo_pres,'099'),2,3)||'-'||                 								
                   SUBSTR(TO_CHAR(a.codadd_pres,'09'),2,2) codigo_pres ,           								
                   SUM(DECODE(cantidad_pres,0,1,null,1,cantidad_pres))  Cant,                  								
                  SUM(((afecto_pres*1.19) + exento_pres  )* DECODE(cantidad_pres,0,1,null,1,cantidad_pres)) Total,                 								
                   SUM(afecto_pres * DECODE(cantidad_pres,0,1,null,1,cantidad_pres)) Afecto,                  								
                  SUM(exento_pres * DECODE(cantidad_pres,0,1,null,1,cantidad_pres)) Exento      ,           								
                   SUM(afecto_pres * DECODE(cantidad_pres,0,1,null,1,cantidad_pres)) +               								
                   SUM(exento_pres * DECODE(cantidad_pres,0,1,null,1,cantidad_pres)) Neto                   								
              from                        								
                   caj_prestapago a,ap_prestaciones ap, tab_paramet tp,                  								
                       (select correl_proceso_pago, correl_pago,            								
                                   TO_DATE(TO_CHAR(fecha_pago,'dd/mm/yyyy'),'dd/mm/yyyy') fecha_pago								
                         from caj_pago           								
                         where fecha_pago  >=TO_DATE(:Fecha_inicio,'dd/mm/yyyy')           								
                         and fecha_pago   < TO_DATE(:Fecha_final,'dd/mm/yyyy')            								
                        group by correl_proceso_pago, correl_pago,           								
                         TO_DATE(TO_CHAR(fecha_pago,'dd/mm/yyyy'),'dd/mm/yyyy')) pagos          								
            where      a.correl_proceso = pagos.correl_proceso_pago               								
             and  a.correl_pago =  pagos.correl_pago             								
             and a.CORREL_PAGO>0                     								
             and a.cod_empresa = 15                  								
            and codigo_movimiento in (1,2)                      								
            and not (a.grupo_pres =99 and a.tipo_pres=99  and a.codigo_pres= 999 and a.codadd_pres=99)                  								
            and   a.cod_sucursal = 1               								
             and    ap.COD_EMPRESA=a.cod_empresa                 								
             and    ap.grupo_PRES = a.GRUPO_PRES                 								
             and    ap.TIPO_PRES = a.TIPO_PRES             								
             and    ap.CODIGO_PRES= a.CODIGO_PRES                								
            and    ap.CODADD_PRES= a.CODADD_PRES                								
            and    a.cod_empresa=tp.cod_empresa                 								
             and    a.cod_centro=tp.cod_item               								
             and    tp.cod_grupo=5    								
--AND     id_atencion=&id_atencion          								
            --AND        COD_CENTRO=15010                 								
             group by                    								
                  TO_CHAR(fecha_pago,'DD/MM/YYYY') ,              								
                  a.cod_centro,cod_unidad,ID_ATENCION,COD_PROF,--ID_AMBULATORIO,                 								
                    SUBSTR(TO_CHAR(a.grupo_pres,'09'),2,2)||'-'||             								
                   SUBSTR(TO_CHAR(a.tipo_pres,'09'),2,2)||'-'||              								
                  SUBSTR(TO_CHAR(a.codigo_pres,'099'),2,3)||'-'||                 								
                   SUBSTR(TO_CHAR(a.codadd_pres,'09'),2,2) ,                 								
                   COD_PREVISION  ,								
	   decode(A.COD_SISTEMA,4,'URG','AMB')             							
             union all                    								
            Select                       								
                  decode(A.COD_SISTEMA,4,'URG','AMB')  TIPO_VENTA,TO_CHAR(pagos.fecha_pago,'DD/MM/YYYY') fecha_Pago,              								
                  a.cod_centro centrocosto_mov,cod_unidad,ID_ATENCION,COD_PROF,--ID_AMBULATORIO,                    								
                   COD_PREVISION Isapre,             								
                   SUBSTR(TO_CHAR(a.grupo_pres,'09'),2,2)||'-'||             								
                   SUBSTR(TO_CHAR(a.tipo_pres,'09'),2,2)||'-'||              								
                  SUBSTR(TO_CHAR(a.codigo_pres,'099'),2,3)||'-'||                 								
                   SUBSTR(TO_CHAR(a.codadd_pres,'09'),2,2) codigo_pres,                  								
                  SUM(DECODE(a.cantidad_pres,0,1,null,1,a.cantidad_pres))  Cant,              								
                  SUM(((afecto_pres*1.19) + exento_pres  )* DECODE(a.cantidad_pres,0,1,null,1,a.cantidad_pres)) Total,             								
                   SUM(afecto_pres * DECODE(cantidad_pres,0,1,null,1,cantidad_pres)) Afecto,                  								
                  SUM(exento_pres * DECODE(cantidad_pres,0,1,null,1,cantidad_pres)) Exento      ,           								
                   SUM(afecto_pres * DECODE(cantidad_pres,0,1,null,1,cantidad_pres)) +               								
                   SUM(exento_pres * DECODE(cantidad_pres,0,1,null,1,cantidad_pres))                 								
             from                        								
                   caj_prestapago a, ap_prestaciones ap, tab_paramet tp,                 								
                   (select correl_proceso_pago * -1 correl_proceso_pago,                 								
                                correl_pago * -1 correl_pago,     								
                               TO_DATE(TO_CHAR(fecha_pago,'dd/mm/yyyy'),'dd/mm/yyyy') fecha_pago  								
                    from caj_pago              								
                    where fecha_pago  >=TO_DATE(:Fecha_inicio,'dd/mm/yyyy')               								
                         and fecha_pago   < TO_DATE(:Fecha_final,'dd/mm/yyyy')            								
                        and MotivoAnulacion_pago is not null           								
                         group by correl_proceso_pago * -1 ,            								
                               correl_pago * -1,      								
                              TO_DATE(TO_CHAR(fecha_pago,'dd/mm/yyyy'),'dd/mm/yyyy')) pagos      								
            where      a.correl_proceso = pagos.correl_proceso_pago               								
              and  a.correl_pago     = pagos.correl_pago          								
             and a.cod_empresa      = 15 								
            and a.codigo_movimiento in (1,2)             								
             and not (a.grupo_pres =99 and a.tipo_pres=99  and a.codigo_pres= 999 and a.codadd_pres=99)                  								
            and a.cod_sucursal     = 1        								
            and    ap.COD_EMPRESA=a.cod_empresa                 								
             and    ap.grupo_PRES = a.GRUPO_PRES                 								
             and    ap.TIPO_PRES = a.TIPO_PRES             								
             and    ap.CODIGO_PRES= a.CODIGO_PRES                								
            and    ap.CODADD_PRES= a.CODADD_PRES                								
            and    a.cod_empresa=tp.cod_empresa                 								
             and    a.cod_centro=tp.cod_item               								
             and    tp.cod_grupo=5    								
--AND     id_atencion=&id_atencion           								
            --aND        COD_CENTRO=15010                 								
             group by                    								
                  TO_CHAR(fecha_pago,'DD/MM/YYYY') ,              								
                  cOD_CENTRO,cod_unidad,iD_ATENCION, COD_PROF,--ID_AMBULATORIO, 								
                   SUBSTR(TO_CHAR(a.grupo_pres,'09'),2,2)||'-'||             								
                   SUBSTR(TO_CHAR(a.tipo_pres,'09'),2,2)||'-'||              								
                  SUBSTR(TO_CHAR(a.codigo_pres,'099'),2,3)||'-'||                 								
                   SUBSTR(TO_CHAR(a.codadd_pres,'09'),2,2),                  								
                  COD_PREVISION ,decode(A.COD_SISTEMA,4,'URG','AMB')              								
             union all                    								
            Select                    								
                  decode(A.COD_SISTEMA,4,'URG','AMB')  TIPO_VENTA, TO_CHAR(fecha_pago,'DD/MM/YYYY') fecha_Pago,                								
                  cod_centro centrocosto_mov,cod_unidad,ID_ATENCION, COD_PROF,--ID_AMBULATORIO,             								
                    COD_PREVISION Isapre,             								
                   SUBSTR(TO_CHAR(a.grupo_pres,'09'),2,2)||'-'||             								
                   SUBSTR(TO_CHAR(a.tipo_pres,'09'),2,2)||'-'||              								
                  SUBSTR(TO_CHAR(a.codigo_pres,'099'),2,3)||'-'||                 								
                   SUBSTR(TO_CHAR(a.codadd_pres,'09'),2,2) codigo_pres,                  								
                   SUM(DECODE(cantidad_pres,0,-1,null,-1,cantidad_pres* -1))  Cant,                  								
                  SUM(((afecto_pres*1.19) + exento_pres  )* DECODE(cantidad_pres,0,-1,null,-1,cantidad_pres* -1)) Total,             								
                   SUM(afecto_pres * DECODE(cantidad_pres,0,-1,null,-1,cantidad_pres*-1)) Afecto,                 								
                   SUM(exento_pres * DECODE(cantidad_pres,0,-1,null,-1,cantidad_pres*-1)) Exento      ,           								
                   SUM(afecto_pres * DECODE(cantidad_pres,0,-1,null,-1,cantidad_pres*-1)) +                  								
                  SUM(exento_pres * DECODE(cantidad_pres,0,-1,null,-1,cantidad_pres*-1))                  								
            from                        								
                   caj_prestapago a, ap_prestaciones ap, tab_paramet tp,                 								
                   (select correl_proceso_pago * -1 correl_proceso_pago,                 								
                                correl_pago * -1 correl_pago,     								
                               TO_DATE(TO_CHAR(fechaanulacion_pago,'YYYYMMDD'),'YYYYMMDD') fecha_pago  								
                    from caj_pago              								
                    where fechaanulacion_pago  >=TO_DATE(:Fecha_inicio,'dd/mm/yyyy')                  								
                        and fechaanulacion_pago   < TO_DATE(:Fecha_final,'dd/mm/yyyy')         								
                         and MotivoAnulacion_pago is not null           								
                         group by correl_proceso_pago * -1 ,            								
                               correl_pago * -1,      								
                              TO_DATE(TO_CHAR(fechaanulacion_pago,'YYYYMMDD'),'YYYYMMDD')) pagos 								
            where a.correl_proceso = pagos.correl_proceso_pago                    								
            and  a.correl_pago = pagos.correl_pago                    								
            and a.cod_empresa = 15            								
            and a.codigo_movimiento in (1,2)                    								
            and not (a.grupo_pres =99 and a.tipo_pres=99  and a.codigo_pres= 999 and a.codadd_pres=99)                  								
            and a.cod_sucursal = 1                  								
            and    ap.COD_EMPRESA=a.cod_empresa                 								
             and    ap.grupo_PRES = a.GRUPO_PRES                 								
             and    ap.TIPO_PRES = a.TIPO_PRES             								
             and    ap.CODIGO_PRES= a.CODIGO_PRES                								
            and    ap.CODADD_PRES= a.CODADD_PRES                								
            and    a.cod_empresa=tp.cod_empresa                 								
             and    a.cod_centro=tp.cod_item               								
             and    tp.cod_grupo=5         								
--AND     id_atencion=&id_atencion        								
            --AND        COD_CENTRO=15010                 								
             group by                    								
                  TO_CHAR(fecha_pago,'DD/MM/YYYY'),               								
                   cOD_CENTRO,cod_unidad,ID_ATENCION,COD_PROF,--ID_AMBULATORIO,  								
                   SUBSTR(TO_CHAR(a.grupo_pres,'09'),2,2)||'-'||             								
                   SUBSTR(TO_CHAR(a.tipo_pres,'09'),2,2)||'-'||              								
                  SUBSTR(TO_CHAR(a.codigo_pres,'099'),2,3)||'-'||                 								
                   SUBSTR(TO_CHAR(a.codadd_pres,'09'),2,2),                  								
                  COD_PREVISION, decode(A.COD_SISTEMA,4,'URG','AMB')								
