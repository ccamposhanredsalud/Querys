SELECT 'HOSP' TIPO_VENTA,
  TO_CHAR(A.FECHA_CONTABLE,'DD/MM/YYYY') FECHA_PAGO,
  AI.FECHA_INGRESO,
  AI.FECHA_EGRESO,
  A.COD_CENTRO CENTROCOSTO_MOV,
  generales.tabparamet(15,5,A.COD_CENTRO) Centro_Costo,
  a.cod_unidad,
  generales.unidades(15,1,a.cod_unidad,'DESCRIP') unidad,
  tp.ID_AMBULATORIO,
  tp.rut_paciente || '-' || tp.dv_paciente rut_paciente,
  tp.apepat_paciente || ' ' ||tp.apemat_paciente ||' ' || tp.nombre_paciente nom_paciente,
  TP.FECHA_NAC_PACIENTE,
  A.ID_INGRESO,
  a.COD_PROF,
  generales.profesional(15,a.COD_PROF,'NOMBRE') Profesional,
  a.COD_ISAPRE isapre,
  generales.prevision(15,a.COD_ISAPRE) Nonbre_Isapre,
  A.COD_PLAN,
  generales.nombreplanisapre(15,a.cod_isapre,A.COD_PLAN,'NOMBREPLAN')Nombre_plan
  ,generales.glosageografo(15, TP.COMUNA_PACIENTE,'REGION') REGION
  ,generales.glosageografo(15, TP.COMUNA_PACIENTE,'COMUNA') COMUNA
  ,'CHILE' PAIS,
  A.COD_PRESTACION,
  generales.prestacion(15,A.COD_PRESTACION,'NOMBRE') Prestacion,
  ag.GRUPO_PRES ,
  ag.nombre_grupo,
  at.tipo_pres tipo_pres,
  at.nombre_tipo,
  ap.adicpab_pres guarismo,
  A.TIPO_CONSUMO,
  A.id_protocolo,
  to_char(po.FECHA_INICIO_OCUPPAB,'DD/MM/RRRR hh:mm:ss') FECHA_INICIO_OCUPPAB,
  to_char(po.fecha_termino_ocuppab,'DD/MM/RRRR hh:mm:ss') fecha_termino_ocuppab,
  TRUNC((po.fecha_termino_ocuppab - po.FECHA_INICIO_OCUPPAB) * (60 * 24)) DURACION_MINUTOS,
  nvl(es_paquete,'N') PAQUETE,
  SUM(A.CANT_ATE    *DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) CANT,
  SUM(A.VALOR_TOTAL *A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) TOTAL,
  SUM(A.VALOR_AFECTO*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) AFECTO,
  SUM(A.VALOR_EXENTO*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) EXENTO,
  SUM(A.VALOR_AFECTO*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) + SUM(A.VALOR_EXENTO*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) NETO
FROM INT_VENTA_DEVENGADA A,
  TAB_PARAMET G,
  ap_prestaciones ap,
  gen_isapre GI,
  ADM_INGRESOS AI,
  TAB_PACIENTE TP,
  AP_GRUPO AG,
  AP_TIPO AT,
  PAB_PROTOCOLO_OPERATORIO PO
WHERE A.FECHA_CONTABLE >= TO_DATE('01/01/2019','dd/mm/yyyy')
AND A.FECHA_CONTABLE    < TO_DATE('02/01/2019','dd/mm/yyyy')
AND A.CONSUMO_URGENCIA IS NULL
AND A.TIPO_CONSUMO     <> 'HMQ'
AND A.COD_EMPRESA       = 15
AND CODIGO_MOVIMIENTO  IN (100,101,110,111,150,151)
AND a.cod_empresa       =g.cod_empresa
AND a.COD_CENTRO        =G.COD_ITEM
AND G.COD_GRUPO         =5
AND A.COBRO_ISAPRE      ='S'
AND A.COBRO_PACIENTE    ='S'
AND a.cod_empresa       =ap.cod_empresa
AND a.cod_prestacion    =ap.cod_prestacion
AND a.cod_empresa       =GI.cod_empresa
AND a.cod_isapre        =gi.cod_isapre
AND AI.COD_EMPRESA  = A.COD_EMPRESA
AND AI.ID_INGRESO  = A.ID_INGRESO
AND TP.COD_EMPRESA = AI.COD_EMPRESA
AND TP.ID_AMBULATORIO = AI.ID_PACIENTE
and AP.COD_EMPRESA = AG.COD_EMPRESA
AND AP.grupo_pres = AG.GRUPO_PRES
and ap.cod_empresa = at.cod_empresa
and ap.GRUPO_PRES = at.grupo_pres
and ap.tipo_pres = AT.TIPO_PRES
and a.cod_empresa = po.cod_Empresa (+)
and A.ID_PROTOCOLO = po.id_protocolo (+)
GROUP BY TO_CHAR(A.FECHA_CONTABLE,'DD/MM/YYYY'),
  AI.FECHA_INGRESO,
  AI.FECHA_EGRESO,
  A.COD_CENTRO,
  a.cod_unidad,
tp.ID_AMBULATORIO,  
  tp.rut_paciente
,tp.dv_paciente
,tp.apepat_paciente
,tp.apemat_paciente
,tp.nombre_paciente,
TP.FECHA_NAC_PACIENTE,
  A.ID_INGRESO,
  a.COD_PROF,
  a.COD_ISAPRE,
  A.COD_PRESTACION,A.COD_PLAN,TP.COMUNA_PACIENTE,ag.GRUPO_PRES ,
  ag.nombre_grupo,
  at.tipo_pres,
  at.nombre_tipo,ap.adicpab_pres,A.TIPO_CONSUMO,A.id_protocolo,es_paquete,
  FECHA_INICIO_OCUPPAB,fecha_termino_ocuppab
UNION
SELECT 'HOSP' TIPO_VENTA,
  TO_CHAR(A.FECHA_CONTABLE,'DD/MM/YYYY') FECHA_PAGO,
  AI.FECHA_INGRESO,
  AI.FECHA_EGRESO,  
  A.COD_CENTRO CENTROCOSTO_MOV,
  generales.tabparamet(15,5,A.COD_CENTRO) Centro_Costo,
  a.cod_unidad,
  generales.unidades(15,1,a.cod_unidad,'DESCRIP') unidad,
  tp.ID_AMBULATORIO,
  tp.rut_paciente || '-' || tp.dv_paciente rut_paciente,
  tp.apepat_paciente || ' ' ||tp.apemat_paciente ||' ' || tp.nombre_paciente nom_paciente,
  TP.FECHA_NAC_PACIENTE,
  A.ID_INGRESO,
  a.COD_PROF,
  generales.profesional(15,a.COD_PROF,'NOMBRE') Profesional,
  a.COD_ISAPRE isapre,
  generales.prevision(15,a.COD_ISAPRE) Nonbre_Isapre,
  A.COD_PLAN,
  generales.nombreplanisapre(15,a.cod_isapre,A.COD_PLAN,'NOMBREPLAN')Nombre_plan
  ,generales.glosageografo(15, TP.COMUNA_PACIENTE,'REGION') REGION
  ,generales.glosageografo(15, TP.COMUNA_PACIENTE,'COMUNA') COMUNA
  ,'CHILE' PAIS,
  'INSUMOS Y FARMACOS',
  'INSUMOS Y FARMACOS' Prestacion,
  0 GRUPO_PRES ,
  '' nombre_grupo,
  0 tipo_pres,
  '' nombre_tipo,
  0 guarismo,
  A.TIPO_CONSUMO,
  A.id_protocolo,
  to_char(po.FECHA_INICIO_OCUPPAB,'DD/MM/RRRR hh:mm:ss') FECHA_INICIO_OCUPPAB,
  to_char(po.fecha_termino_ocuppab,'DD/MM/RRRR hh:mm:ss') fecha_termino_ocuppab,
  TRUNC((po.fecha_termino_ocuppab - po.FECHA_INICIO_OCUPPAB) * (60 * 24)) DURACION_MINUTOS,
  nvl(es_paquete,'N') PAQUETE,
  SUM(A.CANT_ATE    *DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) CANT,
  SUM(A.VALOR_TOTAL *A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) TOTAL,
  SUM(A.VALOR_AFECTO*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) AFECTO,
  SUM(A.VALOR_EXENTO*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) EXENTO,
  SUM(A.VALOR_AFECTO*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) + SUM(A.VALOR_EXENTO*A.CANT_ATE*DECODE(CODIGO_MOVIMIENTO,100,1,110,1,151,1,-1)) NETO
FROM INT_VENTA_DEVENGADA A,
  TAB_PARAMET G,
  gen_isapre GI,
  ADM_INGRESOS AI,
  TAB_PACIENTE TP,
  PAB_PROTOCOLO_OPERATORIO PO
WHERE A.FECHA_CONTABLE >= TO_DATE('01/01/2019','dd/mm/yyyy')
AND A.FECHA_CONTABLE    < TO_DATE('02/01/2019','dd/mm/yyyy')
AND A.CONSUMO_URGENCIA IS NULL
AND A.TIPO_CONSUMO     <> 'HMQ'
AND A.COD_EMPRESA       = 15
AND CODIGO_MOVIMIENTO  IN (100,101,110,111,150,151)
AND a.cod_empresa       =g.cod_empresa
AND a.COD_CENTRO        =G.COD_ITEM
AND G.COD_GRUPO         =5
AND A.COBRO_ISAPRE      ='S'
AND A.COBRO_PACIENTE    ='S'
AND A.COD_PRODUCTO      > 0
AND a.cod_empresa       =GI.cod_empresa
AND a.cod_isapre        =gi.cod_isapre
AND AI.COD_EMPRESA  = A.COD_EMPRESA
AND AI.ID_INGRESO  = A.ID_INGRESO
AND TP.COD_EMPRESA = AI.COD_EMPRESA
AND TP.ID_AMBULATORIO = AI.ID_PACIENTE
and a.cod_empresa = po.cod_Empresa (+)
and A.ID_PROTOCOLO = po.id_protocolo (+)
GROUP BY TO_CHAR(A.FECHA_CONTABLE,'DD/MM/YYYY'),
  AI.FECHA_INGRESO,
  AI.FECHA_EGRESO,
  A.COD_CENTRO,
  a.cod_unidad,
 tp.ID_AMBULATORIO,
 tp.rut_paciente
,tp.dv_paciente
,tp.apepat_paciente
,tp.apemat_paciente
,tp.nombre_paciente  ,
TP.FECHA_NAC_PACIENTE,
  A.ID_INGRESO,
  a.COD_PROF,
  a.COD_ISAPRE,A.COD_PLAN,TP.COMUNA_PACIENTE,A.TIPO_CONSUMO,A.id_protocolo,es_paquete
  ,FECHA_INICIO_OCUPPAB,fecha_termino_ocuppab
UNION
SELECT DECODE(A.COD_SISTEMA,4,'URG','AMB') TIPO_VENTA,
  TO_CHAR(fecha_pago,'DD/MM/YYYY') fecha_Pago,
  NULL FECHA_INGRESO,
  NULL FECHA_EGRESO,
  cod_centro centrocosto_mov,
  generales.tabparamet(15,5,COD_CENTRO) Centro_Costo,
  cod_unidad,
  generales.unidades(15,1,cod_unidad,'DESCRIP') unidad,
  pac.ID_AMBULATORIO,
  pac.rut_paciente || '-' || pac.dv_paciente rut_paciente,
  pac.apepat_paciente || ' ' ||pac.apemat_paciente ||' ' || pac.nombre_paciente nom_paciente,
  PAC.FECHA_NAC_PACIENTE,
  ID_ATENCION,
  COD_PROF, --ID_AMBULATORIO,
  generales.profesional(15,COD_PROF,'NOMBRE') Profesional,
  COD_PREVISION Isapre,
  generales.prevision(15,a.COD_PREVISION) Nonbre_Isapre,
  '' COD_PLAN,
  '' Nombre_plan
  ,generales.glosageografo(15, pac.COMUNA_PACIENTE,'REGION') REGION
  ,generales.glosageografo(15, pac.COMUNA_PACIENTE,'COMUNA') COMUNA
  ,'CHILE' PAIS  ,
  SUBSTR(TO_CHAR(a.grupo_pres,'09'),2,2)
  ||'-'
  || SUBSTR(TO_CHAR(a.tipo_pres,'09'),2,2)
  ||'-'
  || SUBSTR(TO_CHAR(a.codigo_pres,'099'),2,3)
  ||'-'
  || SUBSTR(TO_CHAR(a.codadd_pres,'09'),2,2) codigo_pres ,
  generales.prestacion(15,SUBSTR(TO_CHAR(a.grupo_pres,'09'),2,2)  ||'-'  || SUBSTR(TO_CHAR(a.tipo_pres,'09'),2,2)  ||'-'  || SUBSTR(TO_CHAR(a.codigo_pres,'099'),2,3)||'-'|| SUBSTR(TO_CHAR(a.codadd_pres,'09'),2,2),'NOMBRE') Prestacion,
  ag.GRUPO_PRES ,
  ag.nombre_grupo,
  at.tipo_pres tipo_pres,
  at.nombre_tipo,
  0 guarismo,
  '' TIPO_CONSUMO,
  0 id_protocolo,  
  null FECHA_INICIO_OCUPPAB,
  null fecha_termino_ocuppab,
  NULL DURACION_MINUTOS,
  '' PAQUETE,
  SUM(DECODE(cantidad_pres,0,1,NULL,1,cantidad_pres)) Cant,
  SUM(((round(afecto_pres*1.19)) + exento_pres )* DECODE(cantidad_pres,0,1,NULL,1,cantidad_pres)) Total,
  SUM(afecto_pres  * DECODE(cantidad_pres,0,1,NULL,1,cantidad_pres)) Afecto,
  SUM(exento_pres  * DECODE(cantidad_pres,0,1,NULL,1,cantidad_pres)) Exento ,
  SUM(afecto_pres  * DECODE(cantidad_pres,0,1,NULL,1,cantidad_pres)) + SUM(exento_pres * DECODE(cantidad_pres,0,1,NULL,1,cantidad_pres)) Neto
FROM caj_prestapago a,
  ap_prestaciones ap,
  tab_paramet tp,
  tab_paciente pac,
  (SELECT correl_proceso_pago,
    correl_pago,
    TO_DATE(TO_CHAR(fecha_pago,'dd/mm/yyyy'),'dd/mm/yyyy') fecha_pago
  FROM caj_pago
  WHERE fecha_pago >=TO_DATE('01/01/2019','dd/mm/yyyy')
  AND fecha_pago    < TO_DATE('02/01/2019','dd/mm/yyyy')
  GROUP BY correl_proceso_pago,
    correl_pago,
    TO_DATE(TO_CHAR(fecha_pago,'dd/mm/yyyy'),'dd/mm/yyyy')
  ) pagos,
    AP_GRUPO AG,
  AP_TIPO AT
WHERE a.correl_proceso = pagos.correl_proceso_pago
AND a.correl_pago      = pagos.correl_pago
AND a.CORREL_PAGO      >0
AND a.cod_empresa      = 15
AND codigo_movimiento IN (1,2)
AND NOT (a.grupo_pres  =99
AND a.tipo_pres        =99
AND a.codigo_pres      = 999
AND a.codadd_pres      =99)
AND a.cod_sucursal     = 1
and a.grupo_pres <> 60
AND ap.COD_EMPRESA     =a.cod_empresa
AND ap.grupo_PRES      = a.GRUPO_PRES
AND ap.TIPO_PRES       = a.TIPO_PRES
AND ap.CODIGO_PRES     = a.CODIGO_PRES
AND ap.CODADD_PRES     = a.CODADD_PRES
AND a.cod_empresa      =tp.cod_empresa
AND a.cod_centro       =tp.cod_item
AND tp.cod_grupo       =5
and a.cod_empresa = pac.cod_empresa
and a.id_ambulatorio = pac.id_ambulatorio
and AP.COD_EMPRESA = AG.COD_EMPRESA
AND AP.grupo_pres = AG.GRUPO_PRES
and ap.cod_empresa = at.cod_empresa
and ap.GRUPO_PRES = at.grupo_pres
and ap.tipo_pres = AT.TIPO_PRES
GROUP BY DECODE(A.COD_SISTEMA,4,'URG','AMB'),TO_CHAR(fecha_pago,'DD/MM/YYYY') ,
  a.cod_centro,
  cod_unidad,
pac.ID_AMBULATORIO,  
pac.rut_paciente
,pac.dv_paciente
,pac.apepat_paciente
,pac.apemat_paciente
,pac.nombre_paciente,
PAC.FECHA_NAC_PACIENTE,

  ID_ATENCION,
  COD_PROF, --ID_AMBULATORIO,
  SUBSTR(TO_CHAR(a.grupo_pres,'09'),2,2)
  ||'-'
  || SUBSTR(TO_CHAR(a.tipo_pres,'09'),2,2)
  ||'-'
  || SUBSTR(TO_CHAR(a.codigo_pres,'099'),2,3)
  ||'-'
  || SUBSTR(TO_CHAR(a.codadd_pres,'09'),2,2) ,
  COD_PREVISION,pac.COMUNA_PACIENTE ,ag.GRUPO_PRES ,
  ag.nombre_grupo,
  at.tipo_pres,
  at.nombre_tipo
UNION ALL
SELECT DECODE(A.COD_SISTEMA,4,'URG','AMB') TIPO_VENTA,
  TO_CHAR(pagos.fecha_pago,'DD/MM/YYYY') fecha_Pago,
  NULL FECHA_INGRESO,
  NULL FECHA_EGRESO,
  a.cod_centro centrocosto_mov,
  generales.tabparamet(15,5,A.COD_CENTRO) Centro_Costo,
  cod_unidad,
  generales.unidades(15,1,cod_unidad,'DESCRIP') unidad,
  pac.ID_AMBULATORIO,
  pac.rut_paciente || '-' || pac.dv_paciente rut_paciente,
  pac.apepat_paciente || ' ' ||pac.apemat_paciente ||' ' || pac.nombre_paciente nom_paciente,
  PAC.FECHA_NAC_PACIENTE,
  ID_ATENCION,
  COD_PROF, --ID_AMBULATORIO,
  generales.profesional(15,COD_PROF,'NOMBRE') Profesional,
  COD_PREVISION Isapre,
  generales.prevision(15,a.COD_PREVISION) Nonbre_Isapre,  
  '' COD_PLAN,
  '' Nombre_plan
  ,generales.glosageografo(15, pac.COMUNA_PACIENTE,'REGION') REGION
  ,generales.glosageografo(15, pac.COMUNA_PACIENTE,'COMUNA') COMUNA
  ,'CHILE' PAIS  ,
  SUBSTR(TO_CHAR(a.grupo_pres,'09'),2,2)
  ||'-'
  || SUBSTR(TO_CHAR(a.tipo_pres,'09'),2,2)
  ||'-'
  || SUBSTR(TO_CHAR(a.codigo_pres,'099'),2,3)
  ||'-'
  || SUBSTR(TO_CHAR(a.codadd_pres,'09'),2,2) codigo_pres,
  generales.prestacion(15,SUBSTR(TO_CHAR(a.grupo_pres,'09'),2,2)  ||'-'  || SUBSTR(TO_CHAR(a.tipo_pres,'09'),2,2)  ||'-'  || SUBSTR(TO_CHAR(a.codigo_pres,'099'),2,3)||'-'|| SUBSTR(TO_CHAR(a.codadd_pres,'09'),2,2),'NOMBRE') Prestacion,
  ag.GRUPO_PRES ,
  ag.nombre_grupo,
  at.tipo_pres tipo_pres,
  at.nombre_tipo,
  0 guarismo,
  '' TIPO_CONSUMO,
  0 id_protocolo,  
  null FECHA_INICIO_OCUPPAB,
  null fecha_termino_ocuppab,  
  NULL DURACION_MINUTOS,
  '' PAQUETE,
  SUM(DECODE(a.cantidad_pres,0,1,NULL,1,a.cantidad_pres)) Cant,
  SUM(((round(afecto_pres*1.19)) + exento_pres )* DECODE(a.cantidad_pres,0,1,NULL,1,a.cantidad_pres)) Total,
  SUM(afecto_pres  * DECODE(cantidad_pres,0,1,NULL,1,cantidad_pres)) Afecto,
  SUM(exento_pres  * DECODE(cantidad_pres,0,1,NULL,1,cantidad_pres)) Exento ,
  SUM(afecto_pres  * DECODE(cantidad_pres,0,1,NULL,1,cantidad_pres)) + SUM(exento_pres * DECODE(cantidad_pres,0,1,NULL,1,cantidad_pres))
FROM caj_prestapago a,
  ap_prestaciones ap,
  tab_paramet tp,
  tab_paciente pac,
  (SELECT correl_proceso_pago * -1 correl_proceso_pago,
    correl_pago               * -1 correl_pago,
    TO_DATE(TO_CHAR(fecha_pago,'dd/mm/yyyy'),'dd/mm/yyyy') fecha_pago
  FROM caj_pago
  WHERE fecha_pago    >=TO_DATE('01/01/2019','dd/mm/yyyy')
  AND fecha_pago      < TO_DATE('02/01/2019','dd/mm/yyyy')
  AND MotivoAnulacion_pago IS NOT NULL
  GROUP BY correl_proceso_pago * -1 ,
    correl_pago                * -1,
    TO_DATE(TO_CHAR(fecha_pago,'dd/mm/yyyy'),'dd/mm/yyyy')
  ) pagos, AP_GRUPO AG,
  AP_TIPO AT
WHERE a.correl_proceso   = pagos.correl_proceso_pago
AND a.correl_pago        = pagos.correl_pago
AND a.cod_empresa        = 15
AND a.codigo_movimiento IN (1,2)
AND NOT (a.grupo_pres    =99
       AND a.tipo_pres          =99
       AND a.codigo_pres        = 999
       AND a.codadd_pres        =99)
AND a.cod_sucursal       = 1
AND ap.COD_EMPRESA       =a.cod_empresa
AND ap.grupo_PRES        = a.GRUPO_PRES
AND ap.TIPO_PRES         = a.TIPO_PRES
AND ap.CODIGO_PRES       = a.CODIGO_PRES
AND ap.CODADD_PRES       = a.CODADD_PRES
and a.grupo_pres <> 60
AND a.cod_empresa        =tp.cod_empresa
AND a.cod_centro         =tp.cod_item
AND tp.cod_grupo         =5
and a.cod_empresa = pac.cod_empresa
and a.id_ambulatorio = pac.id_ambulatorio
and AP.COD_EMPRESA = AG.COD_EMPRESA
AND AP.grupo_pres = AG.GRUPO_PRES
and ap.cod_empresa = at.cod_empresa
and ap.GRUPO_PRES = at.grupo_pres
and ap.tipo_pres = AT.TIPO_PRES
GROUP BY TO_CHAR(fecha_pago,'DD/MM/YYYY') ,
  cOD_CENTRO,
  cod_unidad,
  iD_ATENCION,
  pac.ID_AMBULATORIO,
pac.rut_paciente
,pac.dv_paciente
,pac.apepat_paciente
,pac.apemat_paciente
,pac.nombre_paciente,
PAC.FECHA_NAC_PACIENTE,
  COD_PROF, --ID_AMBULATORIO,
  SUBSTR(TO_CHAR(a.grupo_pres,'09'),2,2)
  ||'-'
  || SUBSTR(TO_CHAR(a.tipo_pres,'09'),2,2)
  ||'-'
  || SUBSTR(TO_CHAR(a.codigo_pres,'099'),2,3)
  ||'-'
  || SUBSTR(TO_CHAR(a.codadd_pres,'09'),2,2),
  COD_PREVISION ,
  DECODE(A.COD_SISTEMA,4,'URG','AMB'),pac.COMUNA_PACIENTE,
  ag.GRUPO_PRES ,
  ag.nombre_grupo,
  at.tipo_pres,
  at.nombre_tipo
UNION ALL
SELECT DECODE(A.COD_SISTEMA,4,'URG','AMB') TIPO_VENTA,
  TO_CHAR(fecha_pago,'DD/MM/YYYY') fecha_Pago,
  NULL FECHA_INGRESO,
  NULL FECHA_EGRESO,  
  cod_centro centrocosto_mov,
  generales.tabparamet(15,5,COD_CENTRO) Centro_Costo,  
  cod_unidad,
  generales.unidades(15,1,cod_unidad,'DESCRIP') unidad,
  pac.ID_AMBULATORIO,
  pac.rut_paciente || '-' || pac.dv_paciente rut_paciente,
  pac.apepat_paciente || ' ' ||pac.apemat_paciente ||' ' || pac.nombre_paciente nom_paciente,
  PAC.FECHA_NAC_PACIENTE,
  ID_ATENCION,
  COD_PROF, --ID_AMBULATORIO,
  generales.profesional(15,COD_PROF,'NOMBRE') Profesional,
  COD_PREVISION Isapre,
  generales.prevision(15,a.COD_PREVISION) Nonbre_Isapre,  
  '' COD_PLAN,
  '' Nombre_plan  
  ,generales.glosageografo(15, PAC.COMUNA_PACIENTE,'REGION') REGION
  ,generales.glosageografo(15, PAC.COMUNA_PACIENTE,'COMUNA') COMUNA
  ,'CHILE' PAIS ,
  SUBSTR(TO_CHAR(a.grupo_pres,'09'),2,2)
  ||'-'
  || SUBSTR(TO_CHAR(a.tipo_pres,'09'),2,2)
  ||'-'
  || SUBSTR(TO_CHAR(a.codigo_pres,'099'),2,3)
  ||'-'
  || SUBSTR(TO_CHAR(a.codadd_pres,'09'),2,2) codigo_pres,
  generales.prestacion(15,SUBSTR(TO_CHAR(a.grupo_pres,'09'),2,2)  ||'-'  || SUBSTR(TO_CHAR(a.tipo_pres,'09'),2,2)  ||'-'  || SUBSTR(TO_CHAR(a.codigo_pres,'099'),2,3)||'-'|| SUBSTR(TO_CHAR(a.codadd_pres,'09'),2,2),'NOMBRE') Prestacion,  
  ag.GRUPO_PRES ,
  ag.nombre_grupo,
  at.tipo_pres tipo_pres,
  at.nombre_tipo,  
  0 guarismo,
  '' TIPO_CONSUMO,
  0 id_protocolo,
  null FECHA_INICIO_OCUPPAB,
  null fecha_termino_ocuppab,  
  NULL DURACION_MINUTOS,  
  '' PAQUETE,  
  SUM(DECODE(cantidad_pres,0,-1,NULL,-1,cantidad_pres* -1)) Cant,
  SUM(((round(afecto_pres*1.19)) + exento_pres )* DECODE(cantidad_pres,0,-1,NULL,-1,cantidad_pres* -1)) Total,
  SUM(afecto_pres            * DECODE(cantidad_pres,0,-1,NULL,-1,cantidad_pres*-1)) Afecto,
  SUM(exento_pres            * DECODE(cantidad_pres,0,-1,NULL,-1,cantidad_pres*-1)) Exento ,
  SUM(afecto_pres            * DECODE(cantidad_pres,0,-1,NULL,-1,cantidad_pres*-1)) + SUM(exento_pres * DECODE(cantidad_pres,0,-1,NULL,-1,cantidad_pres*-1))
FROM caj_prestapago a,
  ap_prestaciones ap,
  tab_paramet tp,
  tab_paciente pac,
  (SELECT correl_proceso_pago * -1 correl_proceso_pago,
    correl_pago               * -1 correl_pago,
    TO_DATE(TO_CHAR(fechaanulacion_pago,'YYYYMMDD'),'YYYYMMDD') fecha_pago
  FROM caj_pago
  WHERE fechaanulacion_pago >=TO_DATE('01/01/2019','dd/mm/yyyy')
  AND fechaanulacion_pago   < TO_DATE('02/01/2019','dd/mm/yyyy')
  AND MotivoAnulacion_pago  IS NOT NULL
  GROUP BY correl_proceso_pago * -1 ,
    correl_pago                * -1,
    TO_DATE(TO_CHAR(fechaanulacion_pago,'YYYYMMDD'),'YYYYMMDD')
  ) pagos,  AP_GRUPO AG,
  AP_TIPO AT
WHERE a.correl_proceso   = pagos.correl_proceso_pago
AND a.correl_pago        = pagos.correl_pago
AND a.cod_empresa        = 15
AND a.codigo_movimiento IN (1,2)
AND NOT (a.grupo_pres    =99
AND a.tipo_pres          =99
AND a.codigo_pres        = 999
AND a.codadd_pres        =99)
AND a.cod_sucursal       = 1
AND ap.COD_EMPRESA       =a.cod_empresa
and a.grupo_pres <> 60
AND ap.grupo_PRES        = a.GRUPO_PRES
AND ap.TIPO_PRES         = a.TIPO_PRES
AND ap.CODIGO_PRES       = a.CODIGO_PRES
AND ap.CODADD_PRES       = a.CODADD_PRES
AND a.cod_empresa        =tp.cod_empresa
AND a.cod_centro         =tp.cod_item
AND tp.cod_grupo         =5
and a.cod_empresa = pac.cod_empresa
and a.id_ambulatorio = pac.id_ambulatorio
and AP.COD_EMPRESA = AG.COD_EMPRESA
AND AP.grupo_pres = AG.GRUPO_PRES
and ap.cod_empresa = at.cod_empresa
and ap.GRUPO_PRES = at.grupo_pres
and ap.tipo_pres = AT.TIPO_PRES
GROUP BY TO_CHAR(fecha_pago,'DD/MM/YYYY'),
  cOD_CENTRO,
  cod_unidad,
 pac.ID_AMBULATORIO,
 pac.rut_paciente
,pac.dv_paciente
,pac.apepat_paciente
,pac.apemat_paciente
,pac.nombre_paciente,
PAC.FECHA_NAC_PACIENTE,
  ID_ATENCION,
  COD_PROF, --ID_AMBULATORIO,
  SUBSTR(TO_CHAR(a.grupo_pres,'09'),2,2)
  ||'-'
  || SUBSTR(TO_CHAR(a.tipo_pres,'09'),2,2)
  ||'-'
  || SUBSTR(TO_CHAR(a.codigo_pres,'099'),2,3)
  ||'-'
  || SUBSTR(TO_CHAR(a.codadd_pres,'09'),2,2),
  COD_PREVISION,
  DECODE(A.COD_SISTEMA,4,'URG','AMB'),pac.COMUNA_PACIENTE,
  ag.GRUPO_PRES ,
  ag.nombre_grupo,
  at.tipo_pres,
  at.nombre_tipo;