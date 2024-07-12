#delimit;
clear;
cap clear;
cap log close;
scalar drop _all;
set mem 1200m;
set more off;

*Este programa debe ser utilizado con el Software Stata versión 12 o superior. 

Todas las bases de datos de la ENIGH 2018 deben estar en formato *.dta

En este programa se utilizan las siguientes bases, 
renombrándolas de la siguiente forma:

Base de población: poblacion.dta
Base de trabajos: trabajos.dta
Base de ingresos: ingresos.dta
Base de viviendas: viviendas.dta
Base de hogares: hogares.dta
Base de concentrado: concentradohogar.dta
Base de no monetario hogar: gastoshogar.dta
Base de no monetario personas: gastospersona.dta

En este programa se utilizan tres tipos de archivos, los cuales 
están ubicados en las siguientes carpetas:

1) Bases originales: "C:\Pobreza 2018\Bases de datos"
2) Bases generadas: "C:\Pobreza 2018\Bases"
3) Bitácoras: "C:\Pobreza 2018\log"

Para cambiar estas ubicaciones, se modifican los siguientes globals (gl); 

gl data="C:\Pobreza 2018\Bases de datos";
gl bases="C:\Pobreza 2018\Bases";
gl log="C:\Pobreza 2018\Log";


log using "$log\Pobreza_18.txt", text replace;

*********************************************************
*
* PROGRAMA DE CÁLCULO PARA LA MEDICIÓN MULTIDIMENSIONAL DE LA POBREZA* 2018 
*
*********************************************************

*De acuerdo con los Lineamientos y criterios generales para la definición, identificación y medición de la pobreza (2018) que se pueden consultar en el Diario Oficial de la Federación (https://www.dof.gob.mx/nota_detalle.php?codigo=5542421&fecha=30/10/2018) y la Metodología para la medición multidimensional de la pobreza en México, tercera edición (https://www.coneval.org.mx/InformesPublicaciones/InformesPublicaciones/Documents/Metodologia-medicion-multidimensional-3er-edicion.pdf).

*********************************************************
*Parte I Indicadores de carencias sociales:
*INDICADOR DE REZAGO EDUCATIVO
*********************************************************;

use "$data\poblacion.dta", clear;

*Población objetivo: no se incluye a huéspedes ni trabajadores domésticos;
drop if parentesco>="400" & parentesco <"500";
drop if parentesco>="700" & parentesco <"800";

*Año de nacimiento;
gen anac_e=.;
replace anac_e=2018-edad if edad!=.;

label var edad "Edad reportada al momento de la entrevista";
label var anac_e "Año de nacimiento";

*Inasistencia escolar (se reporta para personas de 3 años o más);
gen inas_esc=.;
replace inas_esc=0 if asis_esc=="1";
replace inas_esc=1 if asis_esc=="2";

label var inas_esc "Inasistencia a la escuela";
label define inas_esc  0 "Sí asiste" 
										 1 "No asiste";
label value inas_esc inas_esc;

*Nivel educativo;
destring nivelaprob gradoaprob antec_esc, replace;
gen niv_ed=.;
replace niv_ed=0 if (nivelaprob<2) | (nivelaprob==2 & gradoaprob<6);
replace niv_ed=1 if (nivelaprob==2 & gradoaprob==6) | 
					(nivelaprob==3 & gradoaprob<3) | 
					(nivelaprob==5 | nivelaprob==6) & gradoaprob<3 & antec_esc==1;
replace niv_ed=2 if (nivelaprob==3 & gradoaprob==3) | 
					(nivelaprob==4 & gradoaprob<3) |
					(nivelaprob==5 & antec_esc==1 & gradoaprob>=3) |
					(nivelaprob==5 & antec_esc==2 & gradoaprob<3) |	 
					(nivelaprob==6 & antec_esc==1 & gradoaprob>=3) |
					(nivelaprob==6 & antec_esc==2 & gradoaprob<3);		
replace niv_ed=3 if (nivelaprob==4 & gradoaprob>=3) |
					(nivelaprob==5 & antec_esc==2 & gradoaprob>=3) | 
					(nivelaprob==5 & antec_esc>=3 & antec_esc!=.) |
					(nivelaprob==6 & antec_esc>=3 & antec_esc!=.) |	
					(nivelaprob==6 & antec_esc==2 & gradoaprob>=3) |
					(nivelaprob>=7 & nivelaprob!=.);

label var niv_ed "Nivel educativo";
label define niv_ed  0 "Con primaria incompleta o menos" 
                     1 "Primaria completa o secundaria incompleta"
					 2 "Secundaria completa o media superior incompleta"
					 3 "Media superior completa o mayor nivel educativo";
label value niv_ed niv_ed;


*Indicador de rezago educativo
*****************************************************************************
Se considera en situación de rezago educativo 
a la población que cumpla con alguno de los siguientes criterios:

1. Tiene de tres a 21 años, no cuenta con la educación
	obligatoria y no asiste a un centro de educación formal.
2. Tiene 22 años o más, nació a partir del año 1998 y no ha terminado 
	la educación obligatoria (media superior).
3. Tiene 16 años o más, nació entre 1982 y 1997, y no cuenta con el
nivel de educación obligatorio vigente en el momento en que debía
haberlo cursado (secundaria completa).
4. Tiene 16 años o más, nació antes de 1982 y no cuenta con el nivel
de educación obligatorio vigente en el momento en que debía haberlo
cursado (primaria completa).
	
*****************************************************************************;
				
gen ic_rezedu=.;
replace ic_rezedu=1 if anac_e>=1998 & (edad>=3 & edad <=21) & inas_esc==1 & niv_ed<3;
replace ic_rezedu=1 if (anac_e>=1982 & anac_e<=1997) & edad>=16 & niv_ed<2;
replace ic_rezedu=1 if anac_e<=1981 & edad>=16 & niv_ed==0;
replace ic_rezedu=1 if anac_e>=1998 & edad>=22 & niv_ed<3;
replace ic_rezedu=0 if edad>=0 & edad<=2;
replace ic_rezedu=0 if anac_e>=1998 & (edad>=3 & edad<=21) & inas_esc==0;
replace ic_rezedu=0 if niv_ed==3;
replace ic_rezedu=0 if (anac_e>=1982 & anac_e<=1997) & edad>=16 & (niv_ed>=2 & niv_ed!=.);
replace ic_rezedu=0 if anac_e<=1981 & edad>=16 & (niv_ed>=1 & niv_ed!=.);

label var ic_rezedu "Indicador de rezago educativo";
label define caren 0 "No presenta carencia"
									1 "Presenta carencia";
label value ic_rezedu caren ;


*Hablante de lengua indígena;
gen hli=.;
replace hli=1 if hablaind=="1" & edad>=3;
replace hli=0 if hablaind=="2" & edad>=3;

label var hli "Hablante de lengua indígena";
label define hli 0 "No habla lengua indígena"
                 1 "Habla lengua indígena";
label value hli hli;

keep folioviv foliohog numren edad anac_e inas_esc niv_ed ic_rezedu parentesco hli ;
sort folioviv foliohog numren;
save "$bases\ic_rezedu18.dta", replace;



************************************************************************
*Parte II Indicadores de carencias sociales:
*INDICADOR DE CARENCIA POR ACCESO A LOS SERVICIOS DE SALUD
***********************************************************************;

*Acceso a servicios de salud por prestaciones laborales;
use "$data\trabajos.dta", clear;

*Tipo de trabajador: identifica la población subordinada e independiente;

*Subordinados;
gen tipo_trab=.;
replace tipo_trab=1 if subor=="1";

*Independientes que reciben un pago;
replace tipo_trab=2 if subor=="2" & indep=="1" & tiene_suel=="1";
replace tipo_trab=2 if subor=="2" & indep=="2" & pago=="1";

*Independientes que no reciben un pago;
replace tipo_trab=3 if subor=="2" & indep=="1" & tiene_suel=="2";
replace tipo_trab=3 if subor=="2" & indep=="2" & (pago=="2" | pago=="3");

*Ocupación principal o secundaria;
destring id_trabajo, replace;
recode id_trabajo (1=1)(2=0), gen (ocupa);

*Distinción de prestaciones en trabajo principal y secundario;
keep folioviv foliohog numren id_trabajo tipo_trab  ocupa;
reshape wide tipo_trab ocupa, i(folioviv foliohog numren) j(id_trabajo);
label var tipo_trab1 "Tipo de trabajo 1";
label var tipo_trab2 "Tipo de trabajo 2";
label var ocupa1 "Ocupación principal";
recode ocupa2 (0=1)(.=0);

label var ocupa2 "Ocupación secundaria";
label define ocupa 0 "Sin ocupación secundaria" 
                   1 "Con ocupación secundaria";
label value ocupa2 ocupa;

*Identificación de la población trabajadora (toda la que reporta al menos un empleo en la base de trabajos.dta);
gen trab=1;
label var trab "Población con al menos un empleo";

keep folioviv foliohog numren trab tipo_trab* ocupa*;
sort folioviv foliohog numren;
save "$bases\ocupados18.dta", replace;


use "$data\poblacion.dta", clear;

*Población objetivo: no se incluye a huéspedes ni trabajadores domésticos;
drop if parentesco>="400" & parentesco <"500";
drop if parentesco>="700" & parentesco <"800";

sort folioviv foliohog numren;
merge folioviv foliohog numren using "$bases\ocupados18.dta";
tab _merge;
drop _merge;

*PEA (personas de 16 años o más);
gen pea=.;
replace pea=1 if trab==1 & (edad>=16 & edad!=.);
replace pea=2 if (act_pnea1=="1" | act_pnea2=="1") & (edad>=16 & edad!=.);
replace pea=0 if (edad>=16 & edad!=.) & (act_pnea1!="1" & act_pnea2!="1") & 
				 ((act_pnea1>="2" & act_pnea1<="6") | (act_pnea2>="2" & 
				  act_pnea2<="6")) & pea==.;

label var pea "Población económicamente activa";
label define pea 0 "PNEA" 
                 1 "PEA: ocupada" 
                 2 "PEA: desocupada";
label value pea pea;


*Tipo de trabajo;
*Ocupación principal;
replace tipo_trab1=tipo_trab1 if pea==1;
replace tipo_trab1=. if (pea==0 | pea==2);
replace tipo_trab1=. if pea==.;

label define tipo_trab 1 "Depende de un patrón, jefe o superior"
                       2 "No depende de un jefe y recibe o tiene asignado un sueldo"
                       3 "No depende de un jefe y no recibe o no tiene asignado un sueldo";
label value tipo_trab1 tipo_trab;

*Ocupación secundaria;
replace tipo_trab2=tipo_trab2 if pea==1;
replace tipo_trab2=. if (pea==0 | pea==2);
replace tipo_trab2=. if pea==.;
label value tipo_trab2 tipo_trab;


*Servicios médicos por prestación laboral ;

*Ocupación principal;
gen smlab1=.;
replace smlab1=1 if ocupa1==1 & atemed=="1" & (inst_1=="1" | inst_2=="2" | 
					inst_3=="3" | inst_4=="4") & (inscr_1=="1");
recode smlab1 (.=0) if ocupa1==1;

label var smlab1 "Servicios médicos por prestación laboral en ocupación principal";
label define smlab 0 "Sin servicios médicos" 
                   1 "Con servicios médicos";
label value smlab1 smlab;

*Ocupación secundaria;
gen smlab2=.;
replace smlab2=1 if ocupa2==1 & atemed=="1" & (inst_1=="1" | inst_2=="2" | 
					inst_3=="3" | inst_4=="4") & (inscr_1=="1");
recode smlab2 (.=0) if ocupa2==1;

label var smlab2 "Servicios médicos por prestación laboral en ocupación secundaria";
label value smlab2 smlab;


*Contratación voluntaria de servicios médicos;
gen smcv=.;
replace smcv=1 if atemed=="1" & (inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4") 
				  & (inscr_6=="6") & (edad>=12 & edad!=.);
recode smcv (.=0) if (edad>=12 & edad!=.);

label var smcv "Servicios médicos por contratación voluntaria";
label define cuenta 0 "No cuenta" 
									   1 "Sí cuenta";
label value smcv cuenta;


*Acceso directo a servicios de salud;
gen sa_dir=.;
*Ocupación principal;
replace sa_dir=1 if tipo_trab1==1 & smlab1==1;
replace sa_dir=1 if tipo_trab1==2 & (smlab1==1 | smcv==1);
replace sa_dir=1 if tipo_trab1==3 & (smlab1==1 | smcv==1);
*Ocupación secundaria;
replace sa_dir=1 if tipo_trab2==1 & smlab2==1;
replace sa_dir=1 if tipo_trab2==2 & (smlab2==1 | smcv==1);
replace sa_dir=1 if tipo_trab2==3 & (smlab2==1 | smcv==1 );

recode sa_dir (.=0);

label var sa_dir "Acceso directo a servicios de salud";
label define sa_dir 0 "Sin acceso"
                    1 "Con acceso";
label value sa_dir sa_dir;

*Núcleos familiares;
gen par=.;
replace par=1 if (parentesco>="100" & parentesco<"200");
replace par=2 if (parentesco>="200" & parentesco<"300");
replace par=3 if (parentesco>="300" & parentesco<"400");
replace par=4 if parentesco=="601";
replace par=5 if parentesco=="615";
recode par (.=6);

label var par "Integrantes que tienen acceso por otros miembros";
label define par 1 "Jefe o jefa del hogar" 
                 2 "Cónyuge del  jefe/a" 
                 3 "Hijo del jefe/a" 
                 4 "Padre o Madre del jefe/a"
                 5 "Suegro del jefe/a"
                 6 "Sin parentesco directo";
label value par par;

*Asimismo, se utilizará la información relativa a la asistencia a la escuela;
gen inas_esc=.;
replace inas_esc=0 if asis_esc=="1";
replace inas_esc=1 if asis_esc=="2";

label var inas_esc "Inasistencia a la escuela";
label define inas_esc  0 "Sí asiste" 
                       1 "No asiste";
label value inas_esc inas_esc;

*En primer lugar se identifican los principales parentescos respecto a la 
jefatura del hogar y si ese miembro cuenta con acceso directo;

gen jef=1 if par==1 & sa_dir==1;
replace jef=. if par==1 & sa_dir==1 & (((inst_2=="2" | inst_3=="3") & inscr_6=="6")
				 & (inst_1==" " & inst_4==" " & inst_6==" ") & (inscr_1==" " & 
				 inscr_2==" " & inscr_3==" " & inscr_4==" " & inscr_5==" " & 
				 inscr_7==" "));
gen cony=1 if par==2 & sa_dir==1;
replace cony=. if par==2 & sa_dir==1 & (((inst_2=="2" | inst_3=="3") & inscr_6=="6")
				 & (inst_1==" " & inst_4==" "  & inst_6==" ") & (inscr_1==" " &
				 inscr_2==" " & inscr_3==" " & inscr_4==" " & inscr_5==" " &
				 inscr_7==" "));
gen hijo=1 if par==3 & sa_dir==1  ;
replace hijo=. if par==3 & sa_dir==1 & (((inst_2=="2" | inst_3=="3") & inscr_6=="6")
				 & (inst_1==" " & inst_4==" " & inst_6==" ") & (inscr_1==" " &
				 inscr_2==" " & inscr_3==" " & inscr_4==" " & inscr_5==" " & 
				 inscr_7==" "));

egen jef_sa=sum(jef), by(folioviv foliohog);
egen cony_sa=sum(cony), by(folioviv foliohog);
replace cony_sa=1 if cony_sa>=1 & cony_sa!=.;
egen hijo_sa=sum(hijo), by(folioviv foliohog);
replace hijo_sa=1 if hijo_sa>=1 & hijo_sa!=.;

label var jef_sa "Acceso directo a servicios de salud de la jefatura del hogar";
label value jef_sa cuenta;
label var cony_sa "Acceso directo a servicios de salud del cónyuge de la jefatura del hogar";
label value cony_sa cuenta;
label var hijo_sa "Acceso directo a servicios de salud de hijos(as) de la jefatura del hogar";
label value hijo_sa cuenta;

*Otros núcleos familiares: se identifica a la población con acceso a servicios de salud
mediante otros núcleos familiares a través de la afiliación
o inscripción a servicios de salud por algún familiar dentro o 
fuera del hogar, muerte del asegurado o por contratación propia;

gen s_salud=.;
replace s_salud=1 if atemed=="1" & (inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4") 
					 & (inscr_3=="3" | inscr_4=="4" | inscr_6=="6" | inscr_7=="7");
recode s_salud (.=0) if segpop!=" " & atemed!=" ";

label var s_salud "Servicios médicos por otros núcleos familiares o por contratación propia";
label value s_salud cuenta;


*Indicador de carencia por acceso a los servicios de salud;
*****************************************************************************
Se considera en situación de carencia por acceso a los servicios de salud
a la población que:

1. No se encuentra inscrita al Seguro Popular o afiliada a alguna institución 
	por prestación laboral, contratación voluntaria o afiliación de un 
	familiar por parentesco directo a recibir servicios médicos por alguna
	institución que los preste como: las instituciones de seguridad social 
	(IMSS, ISSSTE federal o estatal, Pemex, Ejército o Marina), los servicios 
	médicos privados, u otra institución médica.

*****************************************************************************;

*Indicador de carencia por acceso a los servicios de salud;
gen ic_asalud=.;
*Acceso directo;
replace ic_asalud=0 if sa_dir==1;
*Parentesco directo: jefatura;
replace ic_asalud=0 if par==1 & cony_sa==1;
replace ic_asalud=0 if par==1 & pea==0 & hijo_sa==1;
*Parentesco directo: cónyuge;
replace ic_asalud=0 if par==2 & jef_sa==1;
replace ic_asalud=0 if par==2 & pea==0 & hijo_sa==1;
*Parentesco directo: descendientes;
replace ic_asalud=0 if par==3 & edad<16 & jef_sa==1;
replace ic_asalud=0 if par==3 & edad<16 & cony_sa==1;
replace ic_asalud=0 if par==3 & (edad>=16 & edad<=25) & inas_esc==0 & jef_sa==1;
replace ic_asalud=0 if par==3 & (edad>=16 & edad<=25) & inas_esc==0 & cony_sa==1;
*Parentesco directo: ascendientes;
replace ic_asalud=0 if par==4 & pea==0 & jef_sa==1;
replace ic_asalud=0 if par==5 & pea==0 & cony_sa==1;
*Otros núcleos familiares;
replace ic_asalud=0 if s_salud==1;
*Acceso reportado;
replace ic_asalud=0 if segpop=="1" | (segpop=="2" & atemed=="1" & (inst_1=="1" |
					   inst_2=="2" | inst_3=="3" | inst_4=="4" | inst_5=="5" | 
					   inst_6=="6")) | segvol_2=="2";
recode ic_asalud .=1;

label var ic_asalud "Indicador de carencia por acceso a servicios de salud";
label define caren 0 "No presenta carencia"
                   1 "Presenta carencia";
label value ic_asalud caren;

keep folioviv foliohog numren sexo sa_* *_sa segpop atemed inst_* inscr_* segvol_* ic_asalud ;
sort folioviv foliohog numren;
save "$bases\ic_asalud18.dta", replace;



*********************************************************
*Parte III Indicadores de carencias sociales:
*INDICADOR DE CARENCIA POR ACCESO A LA SEGURIDAD SOCIAL
*********************************************************;

*Prestaciones laborales;
use "$data\trabajos.dta", clear;

*Tipo de trabajador: identifica la población subordinada e independiente;

*Subordinados;
gen tipo_trab=.;
replace tipo_trab=1 if subor=="1";

*Independientes que reciben un pago;
replace tipo_trab=2 if subor=="2" & indep=="1" & tiene_suel=="1";
replace tipo_trab=2 if subor=="2" & indep=="2" & pago=="1";

*Independientes que no reciben un pago;
replace tipo_trab=3 if subor=="2" & indep=="1" & tiene_suel=="2";
replace tipo_trab=3 if subor=="2" & indep=="2" & (pago=="2" | pago=="3");

*Ahorro para el retiro o pensión para la vejez (SAR, Afore, Haber de retiro);
gen aforlab=0 if pres_8==" ";
replace aforlab=1 if pres_8=="08";

*Ocupación principal o secundaria;
destring id_trabajo, replace;
recode id_trabajo (1=1)(2=0), gen (ocupa);

*Distinción de prestaciones en trabajo principal y secundario;
keep  folioviv foliohog numren id_trabajo tipo_trab aforlab ocupa;
reshape wide tipo_trab aforlab ocupa, 
			 i( folioviv foliohog numren) j( id_trabajo);
			 
label var tipo_trab1 "Tipo de trabajo 1";
label var tipo_trab2 "Tipo de trabajo 2";
label define cuenta 0 "No cuenta" 
                    1 "Sí cuenta";
label var aforlab1 "Ocupación principal: SAR o Afore";
label value aforlab1 cuenta;
label var aforlab2 "Ocupación secundaria: SAR o Afore";
label value aforlab2 cuenta;
label var ocupa1 "Ocupación principal";

recode ocupa2 (0=1)(.=0);
label var ocupa2 "Ocupación secundaria";
label define ocupa   0 "Sin ocupación secundaria" 
                     1 "Con ocupación secundaria";
label value ocupa2 ocupa;

*Identificación de la población trabajadora (toda la que reporta al menos un 
empleo en la base de trabajos.dta);
gen trab=1;
label var trab "Población con al menos un empleo";

keep folioviv foliohog numren trab tipo_trab* aforlab* ocupa*;
sort folioviv foliohog numren;
save "$bases\prestaciones18.dta", replace;


*Ingresos por jubilaciones, pensiones y programas de adultos mayores;
use "$data\ingresos.dta", clear;

keep if clave=="P032" | clave=="P033" | clave=="P044" | clave=="P045" ;

*Se deflactan los ingresos por jubilaciones, pensiones y programas de adultos 
mayores de acuerdo con el mes de levantamiento;
scalar	dic17	=	0.9779174759	;
scalar	ene18	=	0.9831130806	;
scalar	feb18	=	0.9868584015	;
scalar	mar18	=	0.9900505212	;
scalar	abr18	=	0.9866939363	;
scalar	may18	=	0.9850941386	;
scalar	jun18	=	0.9888992649	;
scalar	jul18	=	0.9941995294	;
scalar	ago18	=	1.0000000000	;
scalar	sep18	=	1.0042291924	;
scalar	oct18	=	1.0094335868	;
scalar	nov18	=	1.0180213350	;
scalar	dic18	=	1.0251562313	;

destring mes_*, replace;
replace ing_6=ing_6/feb18 if mes_6==2;
replace ing_6=ing_6/mar18 if mes_6==3;
replace ing_6=ing_6/abr18 if mes_6==4;
replace ing_6=ing_6/may18 if mes_6==5;

replace ing_5=ing_5/mar18 if mes_5==3;
replace ing_5=ing_5/abr18 if mes_5==4;
replace ing_5=ing_5/may18 if mes_5==5;
replace ing_5=ing_5/jun18 if mes_5==6;

replace ing_4=ing_4/abr18 if mes_4==4;
replace ing_4=ing_4/may18 if mes_4==5;
replace ing_4=ing_4/jun18 if mes_4==6;
replace ing_4=ing_4/jul18 if mes_4==7;

replace ing_3=ing_3/may18 if mes_3==5;
replace ing_3=ing_3/jun18 if mes_3==6;
replace ing_3=ing_3/jul18 if mes_3==7;
replace ing_3=ing_3/ago18 if mes_3==8;

replace ing_2=ing_2/jun18 if mes_2==6;
replace ing_2=ing_2/jul18 if mes_2==7;
replace ing_2=ing_2/ago18 if mes_2==8;
replace ing_2=ing_2/sep18 if mes_2==9;

replace ing_1=ing_1/jul18 if mes_1==7;
replace ing_1=ing_1/ago18 if mes_1==8;
replace ing_1=ing_1/sep18 if mes_1==9;
replace ing_1=ing_1/oct18 if mes_1==10;

egen ing_pens=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6) 
			  if clave=="P032" | clave=="P033";
egen ing_pam=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6) 
              if clave=="P044" | clave=="P045";
recode ing_pens ing_pam (.=0);

collapse (sum) ing_pens ing_pam, by(folioviv foliohog numren);

label var ing_pens "Ingreso promedio mensual por jubilaciones y pensiones";
label var ing_pam "Ingreso promedio mensual por programas de adultos mayores";

sort  folioviv foliohog numren;
save "$bases\pensiones18.dta", replace;


*Construcción del indicador;
use "$data\poblacion.dta", clear;

*Población objetivo: no se incluye a huéspedes ni trabajadores domésticos;
drop if parentesco>="400" & parentesco <"500";
drop if parentesco>="700" & parentesco <"800";

*Integración de bases;
sort  folioviv foliohog numren;
merge  folioviv foliohog numren using "$bases\prestaciones18.dta";
tab _merge;
drop _merge;

sort  folioviv foliohog numren;
merge  folioviv foliohog numren using "$bases\pensiones18.dta";
tab _merge;
drop _merge;

*PEA (personas de 16 años o más);
gen pea=.;
replace pea=1 if trab==1 & (edad>=16 & edad!=.);
replace pea=2 if (act_pnea1=="1" | act_pnea2=="1") & (edad>=16 & edad!=.);
replace pea=0 if (edad>=16 & edad!=.) & (act_pnea1!="1" & act_pnea2!="1") & 
				 ((act_pnea1>="2" & act_pnea1<="6") | (act_pnea2>="2" & 
				 act_pnea2<="6")) & pea==.;

label var pea "Población económicamente activa";
label define pea 0 "PNEA" 
                 1 "PEA: ocupada" 
                 2 "PEA: desocupada";
label value pea pea;

*Tipo de trabajo;
*Ocupación principal;
replace tipo_trab1=tipo_trab1 if pea==1;
replace tipo_trab1=. if (pea==0 | pea==2);
replace tipo_trab1=. if pea==.;

label define tipo_trab 1"Depende de un patrón, jefe o superior"
                       2 "No depende de un jefe y recibe o tiene asignado un sueldo"
                       3 "No depende de un jefe y no recibe o no tiene asignado un sueldo";
label value tipo_trab1 tipo_trab;


*Ocupación secundaria;
replace tipo_trab2=tipo_trab2 if pea==1;
replace tipo_trab2=. if (pea==0 | pea==2);
replace tipo_trab2=. if pea==.;

label value tipo_trab2 tipo_trab;

*Jubilados o pensionados;
gen jub=.;
replace jub=1 if trabajo_mp=="2" & (act_pnea1=="2" | act_pnea2=="2");
replace jub=1 if ing_pens>0 & ing_pens!=.;
replace jub=1 if inscr_2=="2";
recode jub (.=0);

label var jub "Población pensionada o jubilada";
label define jub 0 "Población no pensionada o jubilada" 
                 1 "Población pensionada o jubilada";
label value jub jub;


*Prestaciones básicas;

*Prestaciones laborales (Servicios médicos);

*Ocupación principal;
gen smlab1=.;
replace smlab1=1 if ocupa1==1 & atemed=="1" & (inst_1=="1" | inst_2=="2" | 
					inst_3=="3" | inst_4=="4") & (inscr_1=="1");
recode smlab1 (.=0) if ocupa1==1;
label var smlab1 "Servicios médicos por prestación laboral en ocupación principal";
label define smlab 0 "Sin servicios médicos" 
                   1 "Con servicios médicos";
label value smlab1 smlab;

*Ocupación secundaria;
gen smlab2=.;
replace smlab2=1 if ocupa2==1 & atemed=="1" & (inst_1=="1" | inst_2=="2" | 
					inst_3=="3" | inst_4=="4") & (inscr_1=="1");
recode smlab2 (.=0) if ocupa2==1;
label var smlab2 "Servicios médicos por prestación laboral en ocupación secundaria";
label value smlab2 smlab;


*Contratación voluntaria: servicios médicos y ahorro para el retiro o pensión para 
la vejez (SAR, Afore, Haber de retiro);

*Servicios médicos;
gen smcv=.;
replace smcv=1 if atemed=="1" & (inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4") 
				  & (inscr_6=="6") & (edad>=12 & edad!=.);
recode smcv (.=0) if (edad>=12 & edad!=.);

label var smcv "Servicios médicos por contratación voluntaria";
label value smcv cuenta;

*Ahorro para el retiro o pensión para la vejez (SAR, Afore, Haber de retiro);
gen aforecv=.;
replace aforecv=1 if segvol_1=="1" & (edad>=12 & edad!=.);
recode aforecv (.=0) if segvol_1==" " & (edad>=12 & edad!=.);

label var aforecv "SAR o Afore";
label value aforecv cuenta;


*Acceso directo a seguridad social;

gen ss_dir=.;
*Ocupación principal;
replace ss_dir=1 if tipo_trab1==1 & smlab1==1;
replace ss_dir=1 if tipo_trab1==2 & ((smlab1==1 | smcv==1) & (aforlab1==1 | aforecv==1));
replace ss_dir=1 if tipo_trab1==3 & ((smlab1==1 | smcv==1) & aforecv==1);
*Ocupación secundaria;
replace ss_dir=1 if tipo_trab2==1 & smlab2==1;
replace ss_dir=1 if tipo_trab2==2 & ((smlab2==1 | smcv==1) & (aforlab2==1 | aforecv==1));
replace ss_dir=1 if tipo_trab2==3 & ((smlab2==1 | smcv==1) & aforecv==1);
*Jubilados y pensionados;
replace ss_dir=1 if jub==1;
recode ss_dir (.=0);

label var ss_dir "Acceso directo a la seguridad social";
label define ss_dir 0 "Sin acceso"
                    1 "Con acceso";
label value ss_dir ss_dir;

*Núcleos familiares;
gen par=.;
replace par=1 if (parentesco>="100" & parentesco<"200");
replace par=2 if (parentesco>="200" & parentesco<"300");
replace par=3 if (parentesco>="300" & parentesco<"400");
replace par=4 if parentesco=="601";
replace par=5 if parentesco=="615";
recode par (.=6) if  par==.;
label var par "Integrantes que tienen acceso por otros miembros";
label define par 1 "Jefe o jefa del hogar" 
                 2 "Cónyuge del  jefe/a" 
                 3 "Hijo del jefe/a" 
                 4 "Padre o Madre del jefe/a"
                 5 "Suegro del jefe/a"
                 6 "Sin parentesco directo";
label value par par;

*Asimismo, se utilizará la información relativa a la asistencia a la escuela;
gen inas_esc=.;
replace inas_esc=0 if asis_esc=="1";
replace inas_esc=1 if asis_esc=="2";
label var inas_esc "Inasistencia a la escuela";
label define inas_esc 0 "Sí asiste" 
                      1 "No asiste";
label value inas_esc inas_esc;

*En primer lugar se identifican los principales parentescos respecto a la jefatura del hogar y si ese miembro
cuenta con acceso directo;

gen jef=1 if par==1 & ss_dir==1 ;
replace jef=. if par==1 & ss_dir==1 & (((inst_2=="2" | inst_3=="3") & inscr_6=="6")
			     & (inst_1==" " & inst_4==" "  & inst_6==" ") & (inscr_1==" " & 
				 inscr_2==" " & inscr_3==" " & inscr_4==" " & inscr_5==" " &
				 inscr_7==" "));
gen cony=1 if par==2 & ss_dir==1;
replace cony=. if par==2 & ss_dir==1 & (((inst_2=="2" | inst_3=="3") & inscr_6=="6")
				 & (inst_1==" " & inst_4==" "  & inst_6==" ") & (inscr_1==" " &
				 inscr_2==" " & inscr_3==" " & inscr_4==" " & inscr_5==" " &
				 inscr_7==" "));
gen hijo=1 if par==3 & ss_dir==1 & jub==0;
replace hijo=1 if par==3 & ss_dir==1 & jub==1 & (edad>25 & edad!=.);
replace hijo=. if par==3 & ss_dir==1 & (((inst_2=="2" | inst_3=="3") & inscr_6=="6")
				 & (inst_1==" " & inst_4==" " & inst_6==" ") & (inscr_1==" " & 
				 inscr_2==" " & inscr_3==" " & inscr_4==" " & inscr_5==" " &
				 inscr_7==" "));

egen jef_ss=sum(jef), by( folioviv foliohog);
egen cony_ss=sum(cony), by( folioviv foliohog);
replace cony_ss=1 if cony_ss>=1 & cony_ss!=.;
egen hijo_ss=sum(hijo), by( folioviv foliohog);
replace hijo_ss=1 if hijo_ss>=1 & hijo_ss!=.;

label var jef_ss "Acceso directo a la seguridad social de la jefatura del hogar";
label value jef_ss cuenta;
label var cony_ss "Acceso directo a la seguridad social de cónyuge de la jefatura del hogar";
label value cony_ss cuenta;
label var hijo_ss "Acceso directo a la seguridad social de hijos(as) de la jefatura del hogar";
label value hijo_ss cuenta;

*Otros núcleos familiares: se identifica a la población con acceso a la seguridad
social mediante otros núcleos familiares a través de la afiliación
o inscripción a servicios de salud por algún familiar dentro o 
fuera del hogar, muerte del asegurado o por contratación propia;

gen s_salud=.;
replace s_salud=1 if atemed=="1" & (inst_1=="1" | inst_2=="2" | inst_3=="3" |
					 inst_4=="4") & (inscr_3=="3" | inscr_4=="4" | inscr_6=="6" 
					 | inscr_7=="7");
					 
recode s_salud (.=0) if segpop!=" " & atemed!=" ";

label var s_salud "Servicios médicos por otros núcleos familiares o por contratación propia";
label value s_salud cuenta;


*Programas sociales de pensiones para adultos mayores;

*Se identifica a las personas de 65 años o más que reciben un programa para adultos mayores
si el monto recibido es mayor o igual al promedio de la línea de pobreza extrema 
por ingresos rural y urbana; 

*Valor monetario de las líneas de pobreza extrema por ingresos rural y urbana;
scalar lp1_urb = 1544.07;
scalar lp1_rur = 1164.75;

scalar lp_pam = (lp1_urb + lp1_rur)/2;

gen pam=.;
replace pam=1 if (edad>=65 & edad!=.) & ing_pam>=lp_pam & ing_pam!=.;

recode pam (.=0) if (edad>=65 & edad!=.) ;

label var pam "Programa de adultos mayores";
label define pam 0 "No recibe" 
                 1 "Recibe";
label value pam pam;

*Indicador de carencia por acceso a la seguridad social
************************************************************************

Se encuentra en situación de carencia por acceso a la seguridad social
a la población que:
1. No disponga de acceso directo a la seguridad social.
2. No cuente con parentesco directo con alguna persona dentro del hogar
	que tenga acceso directo.
3. No recibe servicios médicos por parte de algún familiar dentro o
	fuera del hogar, por muerte del asegurado o por contratación propia.
4. No recibe ingreso por parte de un programa de adultos mayores donde el
	monto sea mayor o igual al valor promedio de la canasta alimentaria 
	rural y urbana. 

***********************************************************************;

*Indicador de carencia por acceso a la seguridad social;
gen ic_segsoc=.;
*Acceso directo;
replace ic_segsoc=0 if ss_dir==1;
*Parentesco directo: jefatura;
replace ic_segsoc=0 if par==1 & cony_ss==1;
replace ic_segsoc=0 if par==1 & pea==0 & hijo_ss==1;
*Parentesco directo: cónyuge;
replace ic_segsoc=0 if par==2 & jef_ss==1;
replace ic_segsoc=0 if par==2 & pea==0 & hijo_ss==1;
*Parentesco directo: descendientes;
replace ic_segsoc=0 if par==3 & edad<16 & jef_ss==1;
replace ic_segsoc=0 if par==3 & edad<16 & cony_ss==1;
replace ic_segsoc=0 if par==3 & (edad>=16 & edad<=25) & inas_esc==0 & jef_ss==1;
replace ic_segsoc=0 if par==3 & (edad>=16 & edad<=25) & inas_esc==0 & cony_ss==1;
*Parentesco directo: ascendientes;
replace ic_segsoc=0 if par==4 & pea==0 & jef_ss==1;
replace ic_segsoc=0 if par==5 & pea==0 & cony_ss==1;
*Otros núcleos familiares;
replace ic_segsoc=0 if s_salud==1;
*Programa de adultos mayores;
replace ic_segsoc=0 if pam==1;
recode ic_segsoc (.=1);

label var ic_segsoc "Indicador de carencia por acceso a la seguridad social";
label define caren 0 "No presenta carencia"
							        1 "Presenta carencia";
label value ic_segsoc caren;

keep folioviv foliohog numren tipo_trab* aforlab* smlab*
		   smcv aforecv pea jub ss_dir par jef_ss cony_ss hijo_ss s_salud pam ing_pam
        	ic_segsoc ;
sort folioviv foliohog numren;
save "$bases\ic_segsoc18.dta", replace;



***********************************************************
*Parte IV Indicadores de carencias sociales:
*INDICADOR DE CARENCIA POR CALIDAD Y ESPACIOS DE LA VIVIENDA
***********************************************************;

*Material de construcción de la vivienda;

use "$data\viviendas.dta", clear;
sort folioviv;
save "$bases\viviendas.dta", replace;
use "$data\concentradohogar.dta", clear;
sort folioviv ;
merge folioviv using "$bases\viviendas.dta";
tab _merge;
drop _merge;


*Material de los pisos de la vivienda;
destring mat_pisos, gen(icv_pisos) force;

recode icv_pisos (0=.);
recode icv_pisos (2 3=0) (1=1);


*Material de los techos de la vivienda;
destring mat_techos, gen(icv_techos) force;

recode icv_techos (0=.);
recode icv_techos (3 4 5 6 7 8 9 10=0) (1 2=1);


*Material de muros en la vivienda;
destring mat_pared, gen(icv_muros) force;

recode icv_muros (0=.);
recode icv_muros (6 7 8=0) (1 2 3 4 5=1);


*Espacios en la vivienda (Hacinamiento);

*Número de residentes en la vivienda;
rename tot_resid num_ind;

*Número de cuartos en la vivienda;
rename num_cuarto num_cua;

*Índice de hacinamiento;
gen cv_hac=num_ind/num_cua;

*Indicador de carencia por hacinamiento;
gen icv_hac=.;
replace icv_hac=1 if cv_hac>2.5 & cv_hac!=.;
replace icv_hac=0 if cv_hac<=2.5;


label var icv_pisos "Indicador de carencia por material de piso de la vivienda";
label define caren 0 "Sin carencia"
                                    1 "Con carencia";
label value icv_pisos caren;
label var icv_techos "Indicador de carencia por material de techos de la vivienda";
label value icv_techos caren;
label var icv_muros "Indicador de carencia por material de muros de la vivienda";
label value icv_muros caren;
label var icv_hac "Indicador de carencia por hacinamiento en la vivienda";
label value icv_hac caren;


*Indicador de carencia por calidad y espacios de la vivienda;
********************************************************************************
Se considera en situación de carencia por calidad y espacios 
de la vivienda a las personas que residan en viviendas
que presenten, al menos, una de las siguientes características:

1. El material de los pisos de la vivienda es de tierra
2. El material del techo de la vivienda es de lámina de cartón o desechos.
3. El material de los muros de la vivienda es de embarro o bajareque, de
carrizo, bambú o palma, de lámina de cartón, metálica o asbesto, o
material de desecho.
4. La razón de personas por cuarto (hacinamiento) es mayor que 2.5.

********************************************************************************;

gen ic_cv=.;
replace ic_cv=1 if icv_pisos==1 | icv_techos==1 | icv_muros==1 | icv_hac==1;
replace ic_cv=0 if icv_pisos==0 & icv_techos==0 & icv_muros==0 & icv_hac==0;
replace ic_cv=. if icv_pisos==. | icv_techos==. | icv_muros==. | icv_hac==.;
label var ic_cv "Indicador de carencia por calidad y espacios de la vivienda";
label value ic_cv caren;
sort  folioviv foliohog;
keep  folioviv foliohog icv_pisos icv_techos icv_muros icv_hac ic_cv;
save "$bases\ic_cev18.dta", replace;
  
 
 
************************************************************************
*Parte V Indicadores de carencias sociales:
*INDICADOR DE CARENCIA POR ACCESO A LOS SERVICIOS BÁSICOS EN LA VIVIENDA
************************************************************************;

use "$data\concentradohogar.dta", clear;
keep folioviv foliohog;
sort folioviv ;
merge folioviv using "$bases\viviendas.dta";
tab _merge;
drop _merge;


*Disponibilidad de agua;
destring disp_agua, gen(isb_agua);
recode isb_agua (0=.);
recode isb_agua (1 2=0) (3 4 5 6 7=1);
replace isb_agua=0 if procaptar==1 & disp_agua=="4";


*Drenaje;
destring drenaje, gen(isb_dren);
recode isb_dren (0=.);
recode isb_dren (1 2=0) (3 4 5=1);


*Electricidad;
destring disp_elect, gen(isb_luz);
recode isb_luz (0=.);
recode isb_luz (1 2 3 4=0) (5=1);


*Combustible;
destring combustible, gen(combus) force;
destring estufa_chi, gen(estufa);
recode combus (0=.) (-1=.);
recode estufa (-1=.);
gen isb_combus=0 if combus>=3 & combus<=6;
replace isb_combus=0 if (combus==1 | combus==2) & estufa==1;
replace isb_combus=1 if (combus==1 | combus==2) & estufa==2;

label var isb_agua "Indicador de carencia por acceso al agua";
label define caren 0 "Sin carencia"
                                    1 "Con carencia";
label value isb_agua caren;
label var isb_dren "Indicador de carencia por servicio de drenaje";
label value isb_dren caren;
label var isb_luz "Indicador de carencia por servicios de electricidad";
label value isb_luz caren;
label var isb_combus "Indicador de carencia por combustible para cocinar";
label value isb_combus caren;


*Indicador de carencia por acceso a los servicios básicos en la vivienda;
********************************************************************************
Se considera en situación de carencia por servicios básicos en la vivienda 
a las personas que residan en viviendas que presenten, al menos, 
una de las siguientes características:

1. El agua se obtiene de un pozo, río, lago, arroyo, pipa, o bien, el agua 
	entubada la adquieren por acarreo de otra vivienda, o de la llave
	pública o hidrante.
2. No cuentan con servicio de drenaje o el desagüe tiene conexión a
	una tubería que va a dar a un río, lago, mar, barranca o grieta.
2. No disponen de energía eléctrica.
3. El combustible que se usa para cocinar o calentar los alimentos es
	leña o carbón sin chimenea.

********************************************************************************;

gen ic_sbv=.;
replace ic_sbv=1 if (isb_agua==1 | isb_dren==1 | isb_luz==1 | isb_combus==1);
replace ic_sbv=0 if isb_agua==0 & isb_dren==0 & isb_luz==0 & isb_combus==0;
replace ic_sbv=. if (isb_agua==. | isb_dren==. | isb_luz==. | isb_combus==.);

label var ic_sbv "Indicador de carencia por acceso a servicios básicos en la vivienda";
label value ic_sbv caren;

sort folioviv foliohog;
keep folioviv foliohog isb_agua isb_dren isb_luz isb_combus ic_sbv;
save "$bases\ic_sbv18.dta", replace;



**********************************************************************
*Parte VI Indicadores de carencias sociales:
*INDICADOR DE CARENCIA POR ACCESO A LA ALIMENTACIÓN NUTRITIVA Y DE CALIDAD
**********************************************************************;

use "$data\poblacion.dta", clear;
 
*Población objetivo: no se incluye a huéspedes ni trabajadores domésticos;
drop if parentesco>="400" & parentesco <"500";
drop if parentesco>="700" & parentesco <"800";

*Indicador de hogares con menores de 18 años;
gen men=1 if edad>=0 & edad<=17;
collapse (sum) men, by( folioviv foliohog);

gen id_men=.;
replace id_men=1 if men>=1 & men!=.;
replace id_men=0 if men==0;

label var id_men "Hogares con población de 0 a 17 años de edad";
label define id_men 0 "Sin población de 0 a 17 años"
                    1 "Con población de 0 a 17 años";
label value id_men id_men;

sort folioviv foliohog;
keep folioviv foliohog id_men;
save "$bases\menores18.dta", replace;


use "$data\hogares.dta", clear;

* Parte 1. Grado de Inseguridad Alimentaria (IA);
	
destring acc_alim*, replace;

*Seis preguntas para hogares sin población menor a 18 años;
recode acc_alim4 (2=0) (1=1) (.=0), gen (ia_1ad);
recode acc_alim5 (2=0) (1=1) (.=0), gen (ia_2ad);
recode acc_alim6 (2=0) (1=1) (.=0), gen (ia_3ad);
recode acc_alim2 (2=0) (1=1) (.=0), gen (ia_4ad);
recode acc_alim7 (2=0) (1=1) (.=0), gen (ia_5ad);
recode acc_alim8 (2=0) (1=1) (.=0), gen (ia_6ad);

*Seis preguntas para hogares con población menor a 18 años;
recode acc_alim11 (2=0) (1=1) (.=0), gen (ia_7men);
recode acc_alim12 (2=0) (1=1) (.=0), gen (ia_8men);
recode acc_alim13 (2=0) (1=1) (.=0), gen (ia_9men);
recode acc_alim14 (2=0) (1=1) (.=0), gen (ia_10men);
recode acc_alim15 (2=0) (1=1) (.=0), gen (ia_11men);
recode acc_alim16 (2=0) (1=1) (.=0), gen (ia_12men);

label var ia_1ad "Algún adulto tuvo una alimentación basada en muy poca variedad de alimentos";
label define si_no 0 "No" 
				                  1 "Sí";
label value ia_1ad si_no;

label var ia_2ad "Algún adulto dejó de desayunar, comer o cenar";
label var ia_3ad "Algún adulto comió menos de lo que debía comer";
label var ia_4ad "El hogar se quedó sin comida";
label var ia_5ad "Algún adulto sintió hambre pero no comió";
label var ia_6ad "Algún adulto solo comió una vez al día o dejó de comer todo un día";
label var ia_7men "Alguien de 0 a 17 años tuvo una alimentación basada en muy poca variedad de alimentos";
label var ia_8men "Alguien de 0 a 17 años comió menos de lo que debía";
label var ia_9men "Se tuvo que disminuir la cantidad servida en las comidas a alguien de 0 a 17 años";
label var ia_10men "Alguien de 0 a 17 años sintió hambre pero no comió";
label var ia_11men "Alguien de 0 a 17 años se acostó con hambre";
label var ia_12men "Alguien de 0 a 17 años comió una vez al día o dejó de comer todo un día";

forvalues i=2(1)6 {;
label value ia_`i'ad si_no;
};

forvalues i=7(1)12 {;
label value ia_`i'men si_no;
};


*Construcción de la escala de IA;
sort folioviv foliohog;
merge folioviv foliohog using "$bases\menores18.dta";
tab _merge;
drop _merge;

*Escala para hogares sin menores de 18 años;
gen tot_iaad=.;
replace tot_iaad=ia_1ad + ia_2ad + ia_3ad + ia_4ad + ia_5ad+ ia_6ad if id_men==0;
label var tot_iaad "Escala de IA para hogares sin menores de 18 años";

*Escala para hogares con menores de 18 años;
gen tot_iamen=.;
replace tot_iamen=ia_1ad + ia_2ad + ia_3ad + ia_4ad + ia_5ad + ia_6ad + ia_7men + ia_8men + ia_9men + ia_10men + ia_11men + ia_12men if id_men==1;
label var tot_iamen "Escala de IA para hogares con menores de 18 años ";

*Grado de IA;
gen ins_ali=.;
replace ins_ali=0 if tot_iaad==0 | tot_iamen==0;
replace ins_ali=1 if (tot_iaad==1 | tot_iaad==2) | (tot_iamen==1 | tot_iamen==2 |tot_iamen==3);
replace ins_ali=2 if  (tot_iaad==3 | tot_iaad==4) | (tot_iamen==4 | tot_iamen==5 |tot_iamen==6 |tot_iamen==7);
replace ins_ali=3 if (tot_iaad==5 | tot_iaad==6) | (tot_iamen>=8 & tot_iamen!=.) ;

label var ins_ali "Grado de Inseguridad Alimentaria";
label define ins_ali 0 "Seguridad alimentaria"
							  1 "Inseguridad alimentaria leve"
							  2 "Inseguridad alimentaria moderada"
							  3 "Inseguridad alimentaria severa";
label value ins_ali ins_ali;

*Se genera el indicador de carencia por acceso a la alimentación que
considera en situación de carencia a la población en hogares que 
presenten Inseguridad Alimentaria moderada o severa;

gen ic_ali=.;
replace ic_ali=1 if ins_ali==2 | ins_ali==3;
replace ic_ali=0 if ins_ali==0 | ins_ali==1;
label var ic_ali "Indicador de carencia por acceso a la alimentación";
label define caren 0 "Sin carencia"
				   1 "Con carencia";
label value ic_ali caren;


* Parte 2. Limitación en el consumo de alimentos;

*Se considera el número de días que se consumieron cada uno de los 12 grupos 
de alimentos por el ponderador utilizado por el Programa Mundial de Alimentos (PMA) 
de las Naciones Unidas:

Grupo 1: (maíz, avena, arroz, sorgo, mijo, pan y otros cereales) y 
				(yuca, papas, camotes y otros tubérculos)
Grupo 2: frijoles, chícharos, cacahuates, nueces
Grupo 3: vegetales y hojas
Grupo 4: frutas
Grupo 5: carne de res, cabra, aves, cerdo, huevos y pescado
Grupo 6: leche, yogur y otros lácteos
Grupo 7: azúcares y productos azucarados
Grupo 8: aceites, grasas y mantequilla
Grupo 9: especias, té, café, sal, polvo de pescado, pequeñas cantidades de 
			    leche para el té
		 
El ponderador para el Grupo 1 es 2, para el Grupo 2 es 3, para el Grupo 3 y 4 
es 1, para el Grupo 5 y Grupo 6 es 4, para el Grupo 7 y 8 es 0.5, y para el 
Grupo 9 es 0; 

egen cpond1=rowmax(alim17_1 alim17_2);
replace cpond1=cpond1*2;

gen cpond3= alim17_3*1;  

gen cpond4= alim17_4*1;  

egen cpond5=rowmax(alim17_5-alim17_7);
replace cpond5=cpond5*4;

gen cpond8=alim17_8*3; 

gen cpond9=alim17_9*4;  

gen cpond10=alim17_10*0.5;

gen cpond11=alim17_11*0.5;

gen cpond12=alim17_12*0;  


*Puntaje total de consumo ponderado de alimentos, indica el número ponderado 
de grupos de alimentos que se consumieron en los últimos siete días;

egen tot_cpond = rowtotal(cpond*);

*Se categoriza la dieta consumida en los hogares;
gen dch=.;
replace dch=1 if tot_cpond>=0 & tot_cpond<=28;
replace dch=2 if tot_cpond>28 & tot_cpond<=42;
replace dch=3 if tot_cpond>42 & tot_cpond!=.;

lab var dch "Dieta consumida en los hogares";
lab def lab_dch 1 "Pobre"
				2 "Limítrofe"
				3 "Aceptable";
lab val dch lab_dch;

gen lca=.;
replace lca=1 if dch==1 | dch==2;
replace lca=0 if dch==3;

lab var lca "Limitación en el consumo de alimentos";
lab def lca 0 "No limitado"
			1 "Limitado";
lab val lca lca;



*Indicador de carencia por acceso a la alimentación nutritiva y de calidad;
***********************************************************************
Se considera en situación de carencia por acceso a la alimentación 
nutritiva y de calidad a la población en hogares que presenten,
 al menos, una de las siguientes características:

1. Grado de inseguridad alimentaria moderada o severa. 
2. Limitación en el consumo de alimentos.

***********************************************************************;
	
*Se considera que un hogar es carente cuando presenta alguna de las dos subcarencias;
gen ic_ali_nc=.;
replace ic_ali_nc=0 if ic_ali==0 & lca==0;
replace ic_ali_nc=1 if (ic_ali==1 | lca==1) & (ic_ali!=. & lca!=.);
lab var ic_ali_nc "Indicador de carencia por acceso a la alimentación nutritiva y de calidad";
lab val ic_ali_nc caren;

sort folioviv foliohog;
keep folioviv foliohog id_men ia_* tot_iaad tot_iamen ins_ali dch lca ic_ali ic_ali_nc;
save "$bases\ic_ali18.dta", replace;



*********************************************************
*Parte VII 
*Bienestar económico (ingresos)
*********************************************************;

*Para la construcción del ingreso corriente del hogar es necesario utilizar
información sobre la condición de ocupación y los ingresos de los individuos.
Se utiliza la información contenida en la base trabajos.dta para 
identificar a la población ocupada que declara tener como prestación laboral aguinaldo, 
ya sea por su trabajo principal o secundario, a fin de incorporar los ingresos por este 
concepto en la medición;

*Creación del ingreso monetario deflactado a pesos de agosto del 2018;

*Ingresos;
use "$data\trabajos.dta", clear;

keep folioviv foliohog numren id_trabajo pres_2;
destring pres_2 id_trabajo, replace;
reshape wide pres_2, i( folioviv foliohog numren) j(id_trabajo);

gen trab=1;
label var trab "Población con al menos un empleo";

gen aguinaldo1=.;
replace aguinaldo1=1 if pres_21==2;
recode aguinaldo1 (.=0);

gen aguinaldo2=.;
replace aguinaldo2=1 if pres_22==2 ;
recode aguinaldo2 (.=0);

label var aguinaldo1 "Aguinaldo trabajo principal";
label define aguinaldo 0 "No dispone de aguinaldo"
                       1 "Dispone de aguinaldo";
label value aguinaldo1 aguinaldo;
label var aguinaldo2 "Aguinaldo trabajo secundario";
label value aguinaldo2 aguinaldo;

keep folioviv foliohog numren aguinaldo1 aguinaldo2 trab;
sort folioviv foliohog numren;
save "$bases\aguinaldo.dta", replace;


*Ahora se incorpora a la base de ingresos;

use "$data\ingresos.dta", clear;
sort  folioviv foliohog numren;

merge folioviv foliohog numren using "$bases\aguinaldo.dta";
tab _merge;
drop _merge;

sort  folioviv foliohog numren;

drop if (clave=="P009" & aguinaldo1!=1);
drop if (clave=="P016" & aguinaldo2!=1);

*Una vez realizado lo anterior, se procede a deflactar el ingreso recibido
por los hogares a precios de agosto de 2018. Para ello, se utilizan las 
variables meses, las cuales toman los valores 2 a 10 e indican el mes en
que se recibió el ingreso respectivo;

*Definición de los deflactores 2018 ;

scalar	dic17	=	0.9779174759	;
scalar	ene18	=	0.9831130806	;
scalar	feb18	=	0.9868584015	;
scalar	mar18	=	0.9900505212	;
scalar	abr18	=	0.9866939363	;
scalar	may18	=	0.9850941386	;
scalar	jun18	=	0.9888992649	;
scalar	jul18	=	0.9941995294	;
scalar	ago18	=	1.0000000000	;
scalar	sep18	=	1.0042291924	;
scalar	oct18	=	1.0094335868	;
scalar	nov18	=	1.0180213350	;
scalar	dic18	=	1.0251562313	;

destring mes_*, replace;
replace ing_6=ing_6/feb18 if mes_6==2;
replace ing_6=ing_6/mar18 if mes_6==3;
replace ing_6=ing_6/abr18 if mes_6==4;
replace ing_6=ing_6/may18 if mes_6==5;

replace ing_5=ing_5/mar18 if mes_5==3;
replace ing_5=ing_5/abr18 if mes_5==4;
replace ing_5=ing_5/may18 if mes_5==5;
replace ing_5=ing_5/jun18 if mes_5==6;

replace ing_4=ing_4/abr18 if mes_4==4;
replace ing_4=ing_4/may18 if mes_4==5;
replace ing_4=ing_4/jun18 if mes_4==6;
replace ing_4=ing_4/jul18 if mes_4==7;

replace ing_3=ing_3/may18 if mes_3==5;
replace ing_3=ing_3/jun18 if mes_3==6;
replace ing_3=ing_3/jul18 if mes_3==7;
replace ing_3=ing_3/ago18 if mes_3==8;

replace ing_2=ing_2/jun18 if mes_2==6;
replace ing_2=ing_2/jul18 if mes_2==7;
replace ing_2=ing_2/ago18 if mes_2==8;
replace ing_2=ing_2/sep18 if mes_2==9;

replace ing_1=ing_1/jul18 if mes_1==7;
replace ing_1=ing_1/ago18 if mes_1==8;
replace ing_1=ing_1/sep18 if mes_1==9;
replace ing_1=ing_1/oct18 if mes_1==10;


*Se deflactan las claves P008 y P015 (Reparto de utilidades) 
y, P009 y P016 (aguinaldo)
con los deflactores de mayo a agosto 2018 
y de diciembre de 2017 a agosto 2018, 
respectivamente, y se obtiene el promedio mensual.;

replace ing_1=(ing_1/may18)/12 if clave=="P008" | clave=="P015";
replace ing_1=(ing_1/dic17)/12 if clave=="P009" | clave=="P016";

recode ing_2 ing_3 ing_4 ing_5 ing_6 (0=.) if clave=="P008" | clave=="P009" |
											  clave=="P015" | clave=="P016";

*Una vez deflactado, se procede a obtener el 
ingreso mensual promedio en los últimos seis meses para 
cada persona y tipo de ingreso con base en la clave del mismo;

egen double ing_mens=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6);

*Para obtener el ingreso corriente monetario, se seleccionan 
las claves de ingreso correspondientes;

gen double ing_mon=ing_mens if (clave>="P001" & clave<="P009") | (clave>="P011" & clave<="P016") 
                             | (clave>="P018" & clave<="P048") | (clave>="P067" & clave<="P081");

*Para obtener el ingreso laboral, se seleccionan 
las claves de ingreso correspondientes;
gen double ing_lab=ing_mens if (clave>="P001" & clave<="P009") | (clave>="P011" & clave<="P016") 
                             | (clave>="P018" & clave<="P022") | (clave>="P067" & clave<="P081");

*Para obtener el ingreso por rentas, se seleccionan 
las claves de ingreso correspondientes;
gen double ing_ren=ing_mens if (clave>="P023" & clave<="P031");

*Para obtener el ingreso por transferencias, se seleccionan 
las claves de ingreso correspondientes;
gen double ing_tra=ing_mens if (clave>="P032" & clave<="P048");

							 
*Se estima el total de ingresos de cada hogar;
collapse (sum) ing_mon ing_lab ing_ren ing_tra, by( folioviv foliohog);

label var ing_mon "Ingreso corriente monetario del hogar";
label var ing_lab "Ingreso corriente monetario laboral";
label var ing_ren "Ingreso corriente monetario por rentas";
label var ing_tra "Ingreso corriente monetario por transferencias";
							 
sort folioviv foliohog;
save "$bases\ingreso_deflactado18.dta", replace;


*********************************************************

Creación del ingreso no monetario deflactado a pesos de 
agosto del 2018

*********************************************************;

*No Monetario;

use "$data\gastoshogar.dta", clear;
gen base=1;
append using "$data\gastospersona.dta";
recode base (.=2);

replace frecuencia=frec_rem if base==2;

label var base "Origen del monto";
label define base 1 "Monto del hogar"
                  2 "Monto de personas";
label value base base;

*En el caso de la información de gasto no monetario, para 
deflactar se utiliza la decena de levantamiento de la 
encuesta, la cual se encuentra en la octava posición del 
folio de la vivienda. En primer lugar se obtiene una variable que 
identifique la decena de levantamiento;

gen decena=real(substr(folioviv,8,1));

*Definición de los deflactores;		
		
*Rubro 1.1 semanal, Alimentos;			
scalar d11w07=	0.9906215592	;	
scalar d11w08=	1.0000000000	;	
scalar d11w09=	1.0021335715	;	
scalar d11w10=	1.0009625881	;	
scalar d11w11=	1.0162349906	;	
			
*Rubro 1.2 semanal, Bebidas alcohólicas y tabaco;			
scalar d12w07=	0.9929559081	;	
scalar d12w08=	1.0000000000	;	
scalar d12w09=	1.0002782111	;	
scalar d12w10=	1.0044712499	;	
scalar d12w11=	1.0062100693	;	
			
*Rubro 2 trimestral, Vestido, calzado y accesorios;			
scalar d2t05=	0.9974670850	;	
scalar d2t06=	0.9976705878	;	
scalar d2t07=	0.9999272255	;	
scalar d2t08=	1.0037367202	;	
			
*Rubro 3 mensual, Viviendas;			
scalar d3m07=	0.9975063146	;	
scalar d3m08=	1.0000000000	;	
scalar d3m09=	1.0064969411	;	
scalar d3m10=	1.0203890181	;	
scalar d3m11=	1.0357880660	;	
			
*Rubro 4.2 mensual, Accesorios y artículos de limpieza para el hogar;			
scalar d42m07=	0.9969590689	;	
scalar d42m08=	1.0000000000	;	
scalar d42m09=	1.0062455176	;	
scalar d42m10=	1.0097318511	;	
scalar d42m11=	1.0152502191	;	
			
*Rubro 4.2 trimestral, Accesorios y artículos de limpieza para el hogar;			
scalar d42t05=	0.9970058252	;	
scalar d42t06=	0.9982729377	;	
scalar d42t07=	1.0010681955	;	
scalar d42t08=	1.0053257896	;	
			
*Rubro 4.1 semestral, Muebles y aparatos dómesticos;			
scalar d41s02=	0.9950791231	;	
scalar d41s03=	0.9959679327	;	
scalar d41s04=	0.9953169083	;	
scalar d41s05=	0.9945351946	;	
			
*Rubro 5.1 trimestral, Salud;			
scalar d51t05=	0.9943651361	;	
scalar d51t06=	0.9976866864	;	
scalar d51t07=	1.0005160773	;	
scalar d51t08=	1.0031614187	;	
			
*Rubro 6.1.1 semanal, Transporte público urbano;			
scalar d611w07=	0.9971371343	;	
scalar d611w08=	1.0000000000	;	
scalar d611w09=	1.0011964108	;	
scalar d611w10=	1.0021036889	;	
scalar d611w11=	1.0029910269	;	
			
*Rubro 6 mensual, Transporte;			
scalar d6m07=	0.9907109317	;	
scalar d6m08=	1.0000000000	;	
scalar d6m09=	1.0075554497	;	
scalar d6m10=	1.0160640178	;	
scalar d6m11=	1.0177816167	;	
			
*Rubro 6 semestral, Transporte;			
scalar d6s02=	0.9734980861	;	
scalar d6s03=	0.9802718956	;	
scalar d6s04=	0.9871309575	;	
scalar d6s05=	0.9951830819	;	
			
*Rubro 7 mensual, Educación y esparcimiento;			
scalar d7m07=	0.9983986795	;	
scalar d7m08=	1.0000000000	;	
scalar d7m09=	1.0080940547	;	
scalar d7m10=	1.0114274878	;	
scalar d7m11=	1.0122658363	;	
			
*Rubro 2.3 mensual, Accesorios y cuidados del vestido;			
scalar d23m07=	0.9968755865	;	
scalar d23m08=	1.0000000000	;	
scalar d23m09=	1.0037180280	;	
scalar d23m10=	1.0063495544	;	
scalar d23m11=	1.0067383027	;	
			
*Rubro 2.3 trimestral,  Accesorios y cuidados del vestido;			
scalar d23t05=	0.9985573641	;	
scalar d23t06=	0.9991234941	;	
scalar d23t07=	1.0001978715	;	
scalar d23t08=	1.0033558608	;	
			
*INPC semestral;			
scalar dINPCs02=	0.9886326320	;	
scalar dINPCs03=	0.9908228984	;	
scalar dINPCs04=	0.9931860103	;	
scalar dINPCs05=	0.9969759520	;	


*Una vez definidos los deflactores, se seleccionan los rubros;

gen double gasnomon=gas_nm_tri/3;

gen esp=1 if tipo_gasto=="G4";
gen reg=1 if tipo_gasto=="G5";
replace reg=1 if tipo_gasto=="G6";
drop if tipo_gasto=="G2" | tipo_gasto=="G3" | tipo_gasto=="G7";

*Control para la frecuencia de los regalos recibidos por el hogar;
drop if ((frecuencia>="5" & frecuencia<="6") | frecuencia==" " | frecuencia=="0") & base==1 & tipo_gasto=="G5";

*Control para la frecuencia de los regalos recibidos por persona;
drop if (frecuencia=="9" | frecuencia==" ") & base==2 & tipo_gasto=="G5";


*Gasto no monetario en Alimentos deflactado (semanal) ;

gen ali_nm=gasnomon if (clave>="A001" & clave<="A222") | 
					   (clave>="A242" & clave<="A247");

replace ali_nm=ali_nm/d11w08 if decena==1;
replace ali_nm=ali_nm/d11w08 if decena==2;
replace ali_nm=ali_nm/d11w08 if decena==3;
replace ali_nm=ali_nm/d11w09 if decena==4;
replace ali_nm=ali_nm/d11w09 if decena==5;
replace ali_nm=ali_nm/d11w09 if decena==6;
replace ali_nm=ali_nm/d11w10 if decena==7;
replace ali_nm=ali_nm/d11w10 if decena==8;
replace ali_nm=ali_nm/d11w10 if decena==9;
replace ali_nm=ali_nm/d11w11 if decena==0;

*Gasto no monetario en Alcohol y tabaco deflactado (semanal);

gen alta_nm=gasnomon if (clave>="A223" & clave<="A241");

replace alta_nm=alta_nm/d12w08 if decena==1;
replace alta_nm=alta_nm/d12w08 if decena==2;
replace alta_nm=alta_nm/d12w08 if decena==3;
replace alta_nm=alta_nm/d12w09 if decena==4;
replace alta_nm=alta_nm/d12w09 if decena==5;
replace alta_nm=alta_nm/d12w09 if decena==6;
replace alta_nm=alta_nm/d12w10 if decena==7;
replace alta_nm=alta_nm/d12w10 if decena==8;
replace alta_nm=alta_nm/d12w10 if decena==9;
replace alta_nm=alta_nm/d12w11 if decena==0;

*Gasto no monetario en Vestido y calzado deflactado (trimestral);

gen veca_nm=gasnomon if (clave>="H001" & clave<="H122") | 
						(clave=="H136");

replace veca_nm=veca_nm/d2t05 if decena==1;
replace veca_nm=veca_nm/d2t05 if decena==2;
replace veca_nm=veca_nm/d2t06 if decena==3;
replace veca_nm=veca_nm/d2t06 if decena==4;
replace veca_nm=veca_nm/d2t06 if decena==5;
replace veca_nm=veca_nm/d2t07 if decena==6;
replace veca_nm=veca_nm/d2t07 if decena==7;
replace veca_nm=veca_nm/d2t07 if decena==8;
replace veca_nm=veca_nm/d2t08 if decena==9;
replace veca_nm=veca_nm/d2t08 if decena==0;

*Gasto no monetario en viviendas y servicios de conservación deflactado (mensual);

gen viv_nm=gasnomon if (clave>="G001" & clave<="G016") | (clave>="R001" &
						clave<="R004") | clave=="R013";

replace viv_nm=viv_nm/d3m07 if decena==1;
replace viv_nm=viv_nm/d3m07 if decena==2;
replace viv_nm=viv_nm/d3m08 if decena==3;
replace viv_nm=viv_nm/d3m08 if decena==4;
replace viv_nm=viv_nm/d3m08 if decena==5;
replace viv_nm=viv_nm/d3m09 if decena==6;
replace viv_nm=viv_nm/d3m09 if decena==7;
replace viv_nm=viv_nm/d3m09 if decena==8;
replace viv_nm=viv_nm/d3m10 if decena==9;
replace viv_nm=viv_nm/d3m10 if decena==0;

*Gasto no monetario en Artículos de limpieza deflactado (mensual);

gen lim_nm=gasnomon if (clave>="C001" & clave<="C024");

replace lim_nm=lim_nm/d42m07 if decena==1;
replace lim_nm=lim_nm/d42m07 if decena==2;
replace lim_nm=lim_nm/d42m08 if decena==3;
replace lim_nm=lim_nm/d42m08 if decena==4;
replace lim_nm=lim_nm/d42m08 if decena==5;
replace lim_nm=lim_nm/d42m09 if decena==6;
replace lim_nm=lim_nm/d42m09 if decena==7;
replace lim_nm=lim_nm/d42m09 if decena==8;
replace lim_nm=lim_nm/d42m10 if decena==9;
replace lim_nm=lim_nm/d42m10 if decena==0;

*Gasto no monetario en Cristalería y blancos deflactado (trimestral);

gen cris_nm=gasnomon if (clave>="I001" & clave<="I026");

replace cris_nm=cris_nm/d42t05 if decena==1;
replace cris_nm=cris_nm/d42t05 if decena==2;
replace cris_nm=cris_nm/d42t06 if decena==3;
replace cris_nm=cris_nm/d42t06 if decena==4;
replace cris_nm=cris_nm/d42t06 if decena==5;
replace cris_nm=cris_nm/d42t07 if decena==6;
replace cris_nm=cris_nm/d42t07 if decena==7;
replace cris_nm=cris_nm/d42t07 if decena==8;
replace cris_nm=cris_nm/d42t08 if decena==9;
replace cris_nm=cris_nm/d42t08 if decena==0;

*Gasto no monetario en Enseres domésticos y muebles deflactado (semestral);

gen ens_nm=gasnomon if (clave>="K001" & clave<="K037");

replace ens_nm=ens_nm/d41s02 if decena==1;
replace ens_nm=ens_nm/d41s02 if decena==2;
replace ens_nm=ens_nm/d41s03 if decena==3;
replace ens_nm=ens_nm/d41s03 if decena==4;
replace ens_nm=ens_nm/d41s03 if decena==5;
replace ens_nm=ens_nm/d41s04 if decena==6;
replace ens_nm=ens_nm/d41s04 if decena==7;
replace ens_nm=ens_nm/d41s04 if decena==8;
replace ens_nm=ens_nm/d41s05 if decena==9;
replace ens_nm=ens_nm/d41s05 if decena==0;

*Gasto no monetario en Salud deflactado (trimestral);

gen sal_nm=gasnomon if (clave>="J001" & clave<="J072");

replace sal_nm=sal_nm/d51t05 if decena==1;
replace sal_nm=sal_nm/d51t05 if decena==2;
replace sal_nm=sal_nm/d51t06 if decena==3;
replace sal_nm=sal_nm/d51t06 if decena==4;
replace sal_nm=sal_nm/d51t06 if decena==5;
replace sal_nm=sal_nm/d51t07 if decena==6;
replace sal_nm=sal_nm/d51t07 if decena==7;
replace sal_nm=sal_nm/d51t07 if decena==8;
replace sal_nm=sal_nm/d51t08 if decena==9;
replace sal_nm=sal_nm/d51t08 if decena==0;

*Gasto no monetario en Transporte público deflactado (semanal);

gen tpub_nm=gasnomon if (clave>="B001" & clave<="B007");

replace tpub_nm=tpub_nm/d611w08 if decena==1;
replace tpub_nm=tpub_nm/d611w08 if decena==2;
replace tpub_nm=tpub_nm/d611w08 if decena==3;
replace tpub_nm=tpub_nm/d611w09 if decena==4;
replace tpub_nm=tpub_nm/d611w09 if decena==5;
replace tpub_nm=tpub_nm/d611w09 if decena==6;
replace tpub_nm=tpub_nm/d611w10 if decena==7;
replace tpub_nm=tpub_nm/d611w10 if decena==8;
replace tpub_nm=tpub_nm/d611w10 if decena==9;
replace tpub_nm=tpub_nm/d611w11 if decena==0;


*Gasto no monetario en Transporte foráneo deflactado (semestral);

gen tfor_nm=gasnomon if (clave>="M001" & clave<="M018") | 
						(clave>="F007" & clave<="F014");

replace tfor_nm=tfor_nm/d6s02 if decena==1;
replace tfor_nm=tfor_nm/d6s02 if decena==2;
replace tfor_nm=tfor_nm/d6s03 if decena==3;
replace tfor_nm=tfor_nm/d6s03 if decena==4;
replace tfor_nm=tfor_nm/d6s03 if decena==5;
replace tfor_nm=tfor_nm/d6s04 if decena==6;
replace tfor_nm=tfor_nm/d6s04 if decena==7;
replace tfor_nm=tfor_nm/d6s04 if decena==8;
replace tfor_nm=tfor_nm/d6s05 if decena==9;
replace tfor_nm=tfor_nm/d6s05 if decena==0;

*Gasto no monetario en Comunicaciones deflactado (mensual);

gen com_nm=gasnomon if (clave>="F001" & clave<="F006") | (clave>="R005" &
						clave<="R008") | (clave>="R010" & clave<="R011");

replace com_nm=com_nm/d6m07 if decena==1;
replace com_nm=com_nm/d6m07 if decena==2;
replace com_nm=com_nm/d6m08 if decena==3;
replace com_nm=com_nm/d6m08 if decena==4;
replace com_nm=com_nm/d6m08 if decena==5;
replace com_nm=com_nm/d6m09 if decena==6;
replace com_nm=com_nm/d6m09 if decena==7;
replace com_nm=com_nm/d6m09 if decena==8;
replace com_nm=com_nm/d6m10 if decena==9;
replace com_nm=com_nm/d6m10 if decena==0;

*Gasto no monetario en Educación y recreación deflactado (mensual);

gen edre_nm=gasnomon if (clave>="E001" & clave<="E034") | (clave>="H134" &
						 clave<="H135") | (clave>="L001" & clave<="L029") | 
						(clave>="N003" & clave<="N005") | clave=="R009";

replace edre_nm=edre_nm/d7m07 if decena==1;
replace edre_nm=edre_nm/d7m07 if decena==2;
replace edre_nm=edre_nm/d7m08 if decena==3;
replace edre_nm=edre_nm/d7m08 if decena==4;
replace edre_nm=edre_nm/d7m08 if decena==5;
replace edre_nm=edre_nm/d7m09 if decena==6;
replace edre_nm=edre_nm/d7m09 if decena==7;
replace edre_nm=edre_nm/d7m09 if decena==8;
replace edre_nm=edre_nm/d7m10 if decena==9;
replace edre_nm=edre_nm/d7m10 if decena==0;

*Gasto no monetario en Educación básica deflactado (mensual);

gen edba_nm=gasnomon if (clave>="E002" & clave<="E003") | (clave>="H134" &
						 clave<="H135");

replace edba_nm=edba_nm/d7m07 if decena==1;
replace edba_nm=edba_nm/d7m07 if decena==2;
replace edba_nm=edba_nm/d7m08 if decena==3;
replace edba_nm=edba_nm/d7m08 if decena==4;
replace edba_nm=edba_nm/d7m08 if decena==5;
replace edba_nm=edba_nm/d7m09 if decena==6;
replace edba_nm=edba_nm/d7m09 if decena==7;
replace edba_nm=edba_nm/d7m09 if decena==8;
replace edba_nm=edba_nm/d7m10 if decena==9;
replace edba_nm=edba_nm/d7m10 if decena==0;

*Gasto no monetario en Cuidado personal deflactado (mensual);

gen cuip_nm=gasnomon if (clave>="D001" & clave<="D026") | (clave=="H132");

replace cuip_nm=cuip_nm/d23m07 if decena==1;
replace cuip_nm=cuip_nm/d23m07 if decena==2;
replace cuip_nm=cuip_nm/d23m08 if decena==3;
replace cuip_nm=cuip_nm/d23m08 if decena==4;
replace cuip_nm=cuip_nm/d23m08 if decena==5;
replace cuip_nm=cuip_nm/d23m09 if decena==6;
replace cuip_nm=cuip_nm/d23m09 if decena==7;
replace cuip_nm=cuip_nm/d23m09 if decena==8;
replace cuip_nm=cuip_nm/d23m10 if decena==9;
replace cuip_nm=cuip_nm/d23m10 if decena==0;

*Gasto no monetario en Accesorios personales deflactado (trimestral);

gen accp_nm=gasnomon if (clave>="H123" & clave<="H131") | (clave=="H133");

replace accp_nm=accp_nm/d23t05 if decena==1;
replace accp_nm=accp_nm/d23t05 if decena==2;
replace accp_nm=accp_nm/d23t06 if decena==3;
replace accp_nm=accp_nm/d23t06 if decena==4;
replace accp_nm=accp_nm/d23t06 if decena==5;
replace accp_nm=accp_nm/d23t07 if decena==6;
replace accp_nm=accp_nm/d23t07 if decena==7;
replace accp_nm=accp_nm/d23t07 if decena==8;
replace accp_nm=accp_nm/d23t08 if decena==9;
replace accp_nm=accp_nm/d23t08 if decena==0;

*Gasto no monetario en Otros gastos y transferencias deflactado (semestral);

gen otr_nm=gasnomon if (clave>="N001" & clave<="N002") | (clave>="N006" &
						clave<="N016") | (clave>="T901" & clave<="T915") |
					   (clave=="R012");

replace otr_nm=otr_nm/dINPCs02 if decena==1;
replace otr_nm=otr_nm/dINPCs02 if decena==2;
replace otr_nm=otr_nm/dINPCs03 if decena==3;
replace otr_nm=otr_nm/dINPCs03 if decena==4;
replace otr_nm=otr_nm/dINPCs03 if decena==5;
replace otr_nm=otr_nm/dINPCs04 if decena==6;
replace otr_nm=otr_nm/dINPCs04 if decena==7;
replace otr_nm=otr_nm/dINPCs04 if decena==8;
replace otr_nm=otr_nm/dINPCs05 if decena==9;
replace otr_nm=otr_nm/dINPCs05 if decena==0;

*Gasto no monetario en Regalos Otorgados deflactado;

gen reda_nm=gasnomon if (clave>="T901" & clave<="T915") | (clave=="N013");

replace reda_nm=reda_nm/dINPCs02 if decena==1;
replace reda_nm=reda_nm/dINPCs02 if decena==2;
replace reda_nm=reda_nm/dINPCs03 if decena==3;
replace reda_nm=reda_nm/dINPCs03 if decena==4;
replace reda_nm=reda_nm/dINPCs03 if decena==5;
replace reda_nm=reda_nm/dINPCs04 if decena==6;
replace reda_nm=reda_nm/dINPCs04 if decena==7;
replace reda_nm=reda_nm/dINPCs04 if decena==8;
replace reda_nm=reda_nm/dINPCs05 if decena==9;
replace reda_nm=reda_nm/dINPCs05 if decena==0;

save "$bases\ingresonomonetario_def18.dta", replace;


*Construcción de la base de pagos en especie a partir de la base 
de gasto no monetario;

keep if esp==1;

collapse (sum) *_nm, by(folioviv foliohog);

rename  ali_nm ali_nme;
rename  alta_nm alta_nme;
rename  veca_nm veca_nme;
rename  viv_nm viv_nme;
rename  lim_nm lim_nme;
rename  cris_nm cris_nme;
rename  ens_nm ens_nme;
rename  sal_nm sal_nme;
rename  tpub_nm tpub_nme;
rename  tfor_nm tfor_nme;
rename  com_nm com_nme; 
rename  edre_nm edre_nme;
rename  edba_nm edba_nme;
rename  cuip_nm cuip_nme;
rename  accp_nm accp_nme;
rename  otr_nm otr_nme;
rename  reda_nm reda_nme;

sort folioviv foliohog;
save "$bases\esp_def18.dta", replace;
use "$bases\ingresonomonetario_def18.dta", clear;

*Construcción de base de regalos a partir de la base no monetaria ;

keep if reg==1;

collapse (sum) *_nm, by(folioviv foliohog);

rename  ali_nm ali_nmr;
rename  alta_nm alta_nmr;
rename  veca_nm veca_nmr;
rename  viv_nm viv_nmr;
rename  lim_nm lim_nmr;
rename  cris_nm cris_nmr;
rename  ens_nm ens_nmr;
rename  sal_nm sal_nmr;
rename  tpub_nm tpub_nmr;
rename  tfor_nm tfor_nmr;
rename  com_nm com_nmr; 
rename  edre_nm edre_nmr;
rename  edba_nm edba_nmr;
rename  cuip_nm cuip_nmr;
rename  accp_nm accp_nmr;
rename  otr_nm otr_nmr;
rename  reda_nm reda_nmr;

sort folioviv foliohog;
save "$bases\reg_def18.dta", replace;




*********************************************************

Construcción del ingreso corriente total

*********************************************************;

use "$data\concentradohogar.dta", clear;
keep folioviv foliohog tam_loc factor_np tot_integ est_dis upm ubica_geo;

*El 28 de julio de 2021, el INEGI reemplazó las bases publicadas de Viviendas y 
Concentradohogar de la ENIGH 2018, ya que se incorporó la variable factor_np, la cual 
reporta el factor de expansión construido a partir de la actualización en las estimaciones 
de población que genera el Marco de Muestreo de Viviendas del INEGI, por lo que, se 
renombra para homogenizar el nombre de la variable entre los años;

rename factor_np factor;

*Incorporación de la base de ingreso monetario deflactado;
sort folioviv foliohog;

merge folioviv foliohog using "$bases\ingreso_deflactado18.dta";
tab _merge;
drop _merge;

*Incorporación de la base de ingreso no monetario deflactado: pago en especie;
sort folioviv foliohog;

merge folioviv foliohog using "$bases\esp_def18.dta";
tab _merge;
drop _merge;

*Incorporación de la base de ingreso no monetario deflactado: regalos en especie;
sort folioviv foliohog;

merge folioviv foliohog using "$bases\reg_def18.dta";
tab _merge;
drop _merge;

gen rururb=1 if tam_loc=="4";
replace rururb=0 if tam_loc<="3";

label define rururb 1 "Rural" 
                    0 "Urbano";
label value rururb rururb;

egen double pago_esp=rsum(ali_nme alta_nme veca_nme viv_nme lim_nme ens_nme 
						  cris_nme sal_nme tpub_nme tfor_nme com_nme edre_nme
						  cuip_nme accp_nme otr_nme);

egen double reg_esp=rsum(ali_nmr alta_nmr veca_nmr viv_nmr lim_nmr ens_nmr 
						  cris_nmr sal_nmr tpub_nmr tfor_nmr com_nmr edre_nmr
						  cuip_nmr accp_nmr otr_nmr);

egen double nomon=rsum(pago_esp reg_esp);

egen double ict=rsum(ing_mon nomon);

label var ict "Ingreso corriente total";
label var nomon "Ingreso corriente no monetario";
label var pago_esp "Ingreso corriente no monetario pago especie";
label var reg_esp "Ingreso corriente no monetario regalos especie";

sort folioviv foliohog;
save "$bases\ingresotot18.dta", replace;


***********************************************************

Construcción del tamaño de hogar con economías de escala
y escalas de equivalencia

***********************************************************;

use "$data\poblacion.dta", clear;

*Población objetivo: no se incluye a huéspedes ni trabajadores domésticos;
drop if parentesco>="400" & parentesco <"500";
drop if parentesco>="700" & parentesco <"800";

*Total de integrantes del hogar;
gen ind=1;
egen tot_ind=sum(ind), by (folioviv foliohog);


*************************
*Escalas de equivalencia*
*************************;

gen n_05=.;
replace n_05=1 if edad>=0 & edad<=5;
recode n_05 (.=0) if edad!=.;

gen n_6_12=0;
replace n_6_12=1 if edad>=6 & edad<=12;
recode n_6_12 (.=0) if edad!=.;

gen n_13_18=0;
replace n_13_18=1 if edad>=13 & edad<=18;
recode n_13_18 (.=0) if edad!=.;

gen n_19=0;
replace n_19=1 if edad>=19 & edad!=.;
recode n_19 (.=0) if edad!=.;

gen tamhogesc=n_05*.7031;
replace tamhogesc=n_6_12*.7382 if n_6_12==1;
replace tamhogesc=n_13_18*.7057 if n_13_18==1;
replace tamhogesc=n_19*.9945 if n_19==1 ;
replace tamhogesc=1 if tot_ind==1;

collapse (sum) tamhogesc, by(folioviv foliohog);

sort folioviv foliohog;
save "$bases\tamhogesc18.dta", replace;



*************************************************************************

*Bienestar económico

*************************************************************************;

use "$bases\ingresotot18.dta", clear;

*Incorporación de la información sobre el tamaño del hogar ajustado;

merge folioviv foliohog using "$bases\tamhogesc18.dta";
tab _merge;
drop _merge;

*Información per cápita;

gen double ictpc= ict/tamhogesc;

label var ictpc "Ingreso corriente total per capita";




*************************************************************************

*Indicadores de Bienestar económico 

*************************************************************************
LP I: Valor monetario de la canasta alimentaria 

LP II: Valor monetario de la canasta alimentaria más el valor monetario de la canasta
no alimentaria (ver Anexo A del documento metodológico)

En este programa se construyen los indicadores de bienestar económico
mediante las 2 líneas definidas por CONEVAL, denominándolas:

lp1 : Línea de Pobreza Extrema por Ingresos (LPEI)
lp2 : Línea de Pobreza por Ingresos (LPI)

Para más información, se sugiere consultar el documento metodológico de Construcción
de las líneas de pobreza por ingresos. Disponible en:
https://www.coneval.org.mx/InformesPublicaciones/InformesPublicaciones/Documents/Lineas_pobreza.pdf
************************************************************************;

*Línea de pobreza extrema por ingresos (LPEI);

*Valor monetario de la canasta alimentaria;

scalar lp1_urb = 1544.07;
scalar lp1_rur = 1164.75;

*Se identifica a los hogares bajo lp1;
gen plp_e=1 if ictpc<lp1_urb & rururb==0;
replace plp_e=0 if ictpc>=lp1_urb & rururb==0 & ictpc!=.;
replace plp_e=1 if ictpc<lp1_rur & rururb==1;
replace plp_e=0 if ictpc>=lp1_rur & rururb==1 & ictpc!=.;


*Línea de pobreza por ingresos (LPI);

*Valor monetario de la canasta alimentaria más el valor monetario de la canasta no alimentaria;

scalar lp2_urb = 3325.40;
scalar lp2_rur = 2316.57;

*Se identifica a los hogares bajo lp2;
gen plp=1 if (ictpc<lp2_urb & rururb==0);
replace plp=0 if (ictpc>=lp2_urb & rururb==0) & ictpc!=.;
replace plp=1 if (ictpc<lp2_rur & rururb==1);
replace plp=0 if (ictpc>=lp2_rur & rururb==1) & ictpc!=.;

label var factor "Factor de expansión";
label var tam_loc "Tamaño de la localidad";
label var rururb "Identificador de localidades rurales";
label var tot_integ "Total de integrantes del hogar";
label var tamhogesc "Tamaño de hogar ajustado";
label var ict "Ingreso corriente total del hogar";
label var ictpc "Ingreso corriente total per cápita";
label var plp_e "Población con ingreso menor a la línea de pobreza extrema por ingresos";
label var plp "Población con ingreso menor a la línea de pobreza por ingresos";

keep folioviv foliohog factor tam_loc rururb tamhogesc ict ictpc plp_e plp 
	 est_dis upm ubica_geo tot_integ ing_mon ing_lab ing_ren ing_tra nomon 
	 pago_esp reg_esp; 
sort folioviv foliohog;
save "$bases\p_ingresos18.dta", replace;




************************************************************************

*Parte VIII Pobreza multidimensional

************************************************************************;


**************************
Integración de las bases*
*************************;

use "$bases\ic_rezedu18.dta", clear;

merge folioviv foliohog numren using "$bases\ic_asalud18.dta";
tab _merge;
drop _merge;
sort folioviv foliohog numren;

merge folioviv foliohog numren using "$bases\ic_segsoc18.dta";
tab _merge;
drop _merge;
sort folioviv foliohog;

merge folioviv foliohog using "$bases\ic_cev18.dta";
tab _merge;
drop _merge;
sort folioviv foliohog;

merge folioviv foliohog using "$bases\ic_sbv18.dta";
tab _merge;
drop _merge;
sort folioviv foliohog;

merge folioviv foliohog using "$bases\ic_ali18.dta";
tab _merge;
drop _merge;
sort folioviv foliohog;

merge folioviv foliohog using "$bases\p_ingresos18.dta";
tab _merge;
drop _merge;

duplicates drop folioviv foliohog numren, force;

gen ent=real(substr(folioviv,1,2));

recode ing_* (.=0) if ictpc!=0 | ing_mon==.;

label var ent "Identificador de la entidad federativa";
label define ent 
1	"Aguascalientes"
2	"Baja California"
3	"Baja California Sur"
4	"Campeche"
5	"Coahuila de Zaragoza"
6	"Colima"
7	"Chiapas"
8	"Chihuahua"
9	"Ciudad de México"
10	"Durango"
11	"Guanajuato"
12	"Guerrero"
13	"Hidalgo"
14	"Jalisco"
15	"México"
16	"Michoacán de Ocampo"
17	"Morelos"
18	"Nayarit"
19	"Nuevo León"
20	"Oaxaca"
21	"Puebla"
22	"Querétaro"
23	"Quintana Roo"
24	"San Luis Potosí"
25	"Sinaloa"
26	"Sonora"
27	"Tabasco"
28	"Tamaulipas"
29	"Tlaxcala"
30	"Veracruz de Ignacio de la Llave"
31	"Yucatán"
32	"Zacatecas";
label value ent ent;


****************************
*Índice de Privación Social
****************************;

egen i_privacion=rsum(ic_rezedu ic_asalud ic_segsoc ic_cv ic_sbv ic_ali_nc);
replace i_privacion=. if ic_rezedu==. | ic_asalud==. | ic_segsoc==. | 
						 ic_cv==. | ic_sbv==. | ic_ali_nc==.;

label var i_privacion "Índice de Privación Social";


***************************
*Pobreza multidimensional
***************************;

*Pobreza;
gen pobreza=1 if plp==1 & (i_privacion>=1 & i_privacion!=.);
replace pobreza=0 if (plp==0 | i_privacion==0) & (plp!=. & i_privacion!=.);

label var pobreza "Pobreza";
label define pobreza 0 "No pobre" 
                     1 "Pobre";
label value pobreza pobreza;

*Pobreza extrema;
gen pobreza_e=1 if plp_e==1 & (i_privacion>=3 & i_privacion!=.);
replace pobreza_e=0 if (plp_e==0 | i_privacion<3) & (plp_e!=. & i_privacion!=.);

label var pobreza_e "Pobreza extrema";
label define pobreza_e 0 "No pobre extremo" 
                       1 "Pobre extremo";
label value pobreza_e pobreza_e;

*Pobreza moderada;
gen pobreza_m=1 if pobreza==1 & pobreza_e==0;
replace pobreza_m=0 if pobreza==0 | (pobreza==1 & pobreza_e==1);

label var pobreza_m "Pobreza moderada";
label define pobreza_m 0 "No pobre moderado" 
                       1 "Pobre moderado";
label value pobreza_m pobreza_m;


*******************************
*Población vulnerable
*******************************;

*Vulnerables por carencias;
gen vul_car=cond(plp==0 & (i_privacion>=1 & i_privacion!=.),1,0);
replace vul_car=. if pobreza==.;
label var vul_car "Población vulnerable por carencias";
label define vul 0 "No vulnerable" 
                 1 "Vulnerable";
label value vul_car vul;

*Vulnerables por ingresos;
gen vul_ing=cond(plp==1 & i_privacion==0,1,0);
replace vul_ing=. if pobreza==.;
label var vul_ing "Población vulnerable por ingresos";
label value vul_ing vul;


****************************************************
*Población no pobre y no vulnerable
****************************************************;

gen no_pobv=cond(plp==0 & i_privacion==0,1,0);
replace no_pobv=. if pobreza==.;

label var no_pobv "Población no pobre y no vulnerable";
label define no_pobv 0 "Pobre o vulnerable" 
					 1 "No pobre y no vulnerable";
label value no_pobv no_pobv;


***********************************
*Población con carencias sociales 
***********************************;

gen carencias=cond(i_privacion>=1 & i_privacion!=.,1,0);
replace carencias=. if pobreza==.;

label var carencias "Población con al menos una carencia";
label define carencias 0 "Población sin carencias" 
					   1 "Población con al menos una carencia";
label value carencias carencias;

gen carencias3=cond(i_privacion>=3 & i_privacion!=.,1,0);
replace carencias3=. if pobreza==.;

label var carencias3 "Población con tres o más carencias";
label define carencias3 0 "Población con menos de tres carencias" 
						1 "Población con al menos tres o más carencias";
label value carencias3 carencias3;


************
*Cuadrantes
************;

gen cuadrantes=.;
replace cuadrantes=1 if plp==1 & (i_privacion>=1 & i_privacion!=.);
replace cuadrantes=2 if plp==0 & (i_privacion>=1 & i_privacion!=.);
replace cuadrantes=3 if plp==1 & i_privacion==0;
replace cuadrantes=4 if plp==0 & i_privacion==0;

label var cuadrantes "Cuadrantes de bienestar económico y derechos sociales";
label define cuadrantes 1 "Pobres"
						2 "Vulnerables por carencias" 
						3 "Vulnerables por ingresos"
						4 "No pobres y no vulnerables";
label value cuadrantes cuadrantes;


**************************************************
*Profundidad en el espacio del bienestar económico
**************************************************;

*FGT (a=1);

*Distancia normalizada del ingreso respecto a la línea de pobreza por ingresos;
gen prof1=(lp2_rur-ictpc)/(lp2_rur) if rururb==1 & plp==1;
replace prof1=(lp2_urb-ictpc)/(lp2_urb) if rururb==0 & plp==1;
recode prof1 (.=0) if ictpc!=.;

label var prof1 "Índice FGT con alfa igual a 1 (línea de pobreza por ingresos)";

*Distancia normalizada del ingreso respecto a la línea pobreza extrema por ingresos;
gen prof_e1=(lp1_rur-ictpc)/(lp1_rur) if rururb==1 & plp_e==1;
replace prof_e1=(lp1_urb-ictpc)/(lp1_urb) if rururb==0 & plp_e==1;
recode prof_e1 (.=0) if ictpc!=.;

label var prof_e1 "Índice FGT con alfa igual a 1 (línea de pobreza extrema por ingresos)";


************************************
*Profundidad de la privación social
************************************;

gen profun=i_privacion/6;
label var profun "Profundidad de la privación social";


***********************************
*Intensidad de la privación social
***********************************;

*Intensidad de la privación social: pobres;
gen int_pob=profun*pobreza;

label var int_pob "Intensidad de la privación social: en situación de pobreza";

*Intensidad de la privación social: pobres extremos;
gen int_pobe=profun*pobreza_e;

label var int_pobe "Intensidad de la privación social: en situación de pobreza extrema";

*Intensidad de la privación social: población vulnerable por carencias;
gen int_vulcar=profun*vul_car;

label var int_vulcar "Intensidad de la privación social: población vulnerable por carencias";

*Intensidad de la privación social: población carenciada;
gen int_caren=profun*carencias;

label var int_caren "Intensidad de la privación social: población con carencias sociales";

keep 	folioviv foliohog numren est_dis upm
		factor tam_loc rururb ent ubica_geo edad sexo parentesco 
		ic_rezedu anac_e inas_esc niv_ed
		ic_asalud  ic_segsoc sa_dir ss_dir s_salud par jef_ss cony_ss hijo_ss pea jub pam ing_pam
		ic_cv icv_pisos icv_muros icv_techos icv_hac
		ic_sbv isb_agua isb_dren isb_luz isb_combus
		ic_ali_nc id_men tot_iaad tot_iamen ins_ali ic_ali lca dch
		plp_e plp 
		pobreza pobreza_e pobreza_m vul_car vul_ing no_pobv i_privacion carencias carencias3 cuadrantes 
		prof1 prof_e1 profun int_pob int_pobe int_vulcar int_caren 
		tamhogesc ictpc ict ing_mon ing_lab ing_ren ing_tra nomon pago_esp reg_esp 
		hli;
		
order 	folioviv foliohog numren est_dis upm
		factor tam_loc rururb ent ubica_geo edad sexo parentesco 
		ic_rezedu anac_e inas_esc niv_ed
		ic_asalud  ic_segsoc sa_dir ss_dir s_salud par jef_ss cony_ss hijo_ss pea jub pam ing_pam
		ic_cv icv_pisos icv_muros icv_techos icv_hac
		ic_sbv isb_agua isb_dren isb_luz isb_combus
		ic_ali_nc id_men tot_iaad tot_iamen ins_ali ic_ali lca dch
		plp_e plp 
		pobreza pobreza_e pobreza_m vul_car vul_ing no_pobv i_privacion carencias carencias3 cuadrantes 
		prof1 prof_e1 profun int_pob int_pobe int_vulcar int_caren 
		tamhogesc ictpc ict ing_mon ing_lab ing_ren ing_tra nomon pago_esp reg_esp 
		hli;
		
			
label var sexo "Sexo";
label var parentesco "Parentesco con el jefe del hogar";
label var est_dis "Estrato de diseño";
label var upm "Unidad primaria de muestreo";
label var ubica_geo "Ubicación geográfica";

sort folioviv foliohog numren;
save "$bases\pobreza_18.dta", replace;




********************************************************
*Cuadros resultado
********************************************************;
di "TABULADOS BÁSICOS";


********************************************************
* RESULTADOS A NIVEL NACIONAL
********************************************************;
tabstat pobreza pobreza_m pobreza_e vul_car vul_ing no_pobv carencias carencias3 ic_rezedu ic_asalud 
ic_segsoc ic_cv ic_sbv ic_ali_nc plp_e plp [w=factor] if pobreza!=., stats(mean sum) format(%15.8gc) c(s);


********************************************************************************
* PORCENTAJE Y NÚMERO DE PERSONAS POR INDICADOR DE POBREZA, ENTIDAD FEDERATIVA
********************************************************************************;
tabstat pobreza pobreza_m pobreza_e vul_car vul_ing no_pobv [w=factor] if pobreza!=., 
stats(mean sum) format(%11.6gc) by(ent);


*********************************************************************************
* PORCENTAJE Y NÚMERO DE PERSONAS CON CARENCIAS SOCIALES, ENTIDAD FEDERATIVA
*********************************************************************************;
tabstat ic_rezedu ic_asalud ic_segsoc ic_cv ic_sbv ic_ali_nc carencias carencias3 plp_e plp [w=factor] if pobreza!=., 
stats(mean sum) format(%11.6gc) by(ent);


***************************************************************************************************
* NOTA: LOS CUADROS ANTERIORES SE PUEDEN RECUPERAR DEL ARCHIVO LOG
***************************************************************************************************;

log close;
