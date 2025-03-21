
#delimit;
clear;
cap clear;
cap log close;
scalar drop _all;
set mem 400m;
set more off;

*Este programa debe ser utilizado con el Software Stata 
versión 10 o superior. 

Todas las bases de  datos del MCS 2008 deben estar en formato *.dta

En este programa se utilizan las siguientes bases, 
renombrándolas de la siguiente forma:

Base de población: Pobla08.dta
Base de trabajos: trabajos.dta
Base de ingresos: ingresos.dta
Base de hogares: hogares.dta
Base de concentrado: Concen.dta
Base de no monetario E: NomonE.dta
Base de no monetario M: NomonM.dta

En este programa se utilizan tres tipos de archivos, los cuales 
están ubicados en las siguientes carpetas:

1) Bases originales: "C:\Pobreza 2008\MCS"
2) Bases generadas: "C:\Pobreza 2008\Bases"
3) Bitácoras: "C:\Pobreza 2008\log"

Para cambiar estas ubicaciones, se modifican los siguientes
globals (gl); 

gl data="C:\Users\galve\Documents\Papers\Current\Social pension program\Data\2008\MCS";
gl bases="C:\Users\galve\Documents\Papers\Current\Social pension program\Data\2008\Bases";
gl log="C:\Users\galve\Documents\Papers\Current\Social pension program\Data\2014\log";

log using "$log\Pobreza_08.txt", text replace;

*********************************************************
*Parte I Indicadores de Privación Social:
*INDICADOR DE CARENCIA POR REZAGO EDUCATIVO
*********************************************************;

use "$data\Pobla08.dta", clear;

*Población objeto: no se incluye a huéspedes ni trabajadores domésticos;
drop if parentesco>=400 & parentesco <500;
drop if parentesco>=700 & parentesco <800;

*Año de nacimiento;
gen anac_e=.;
replace anac_e=2008-edad if edad!=.;
label var edad "Edad reportada al momento de la entrevista";
label var anac_e "Año de nacimiento";

*Inasistencia a la escuela (se reporta para personas de 3 años o más);
gen inas_esc=.;
replace inas_esc=0 if asis_esc==1;
replace inas_esc=1 if asis_esc==2;
label var inas_esc "Inasistencia a la escuela";
label define inas_esc  0 "Sí asiste" 
                       1 "No asiste";
label value inas_esc inas_esc;

*Nivel educativo;
gen niv_ed=.;
replace niv_ed = 0 if (n_instr161<2) | (n_instr161==2 & n_instr162<6);
replace niv_ed = 1 if  (n_instr161==2 & n_instr162==6) | 
     (n_instr161==3 & n_instr162<3) | 
     (n_instr161==5 | n_instr161==6) & n_instr162<3 & antec_esc==1;
replace niv_ed = 2 if (n_instr161==3 & n_instr162==3) | 
     (n_instr161==4) | 
     (n_instr161==5 & antec_esc==1 & n_instr162>=3) |
     (n_instr161==6 & antec_esc==1 & n_instr162>=3) | 
     (n_instr161==5 & antec_esc>=2 & antec_esc!=.) | 
     (n_instr161==6 & antec_esc>=2 & antec_esc!=.) | 
     (n_instr161>=7 & n_instr161!=.);
label var niv_ed "Nivel educativo";
label define niv_ed  0 "Con primaria incompleta o menos" 
                     1 "Primaria completa o secundaria incompleta"
                     2 "Secundaria completa o mayor nivel educativo";
label value niv_ed niv_ed;

*=====================================================================*
*Years of education;
*=====================================================================*;
destring alfabe asis_esc nivel grado, replace;
recode alfabe(2=0);
recode asis_esc (2=0);
rename n_instr161 nivelaprob;
rename n_instr162 gradoaprob;
gen a_educ=.;
*Ninguno;
replace a_educ=0 if (nivelaprob==0);
*Preescolar;
replace a_educ=0 if (nivelaprob==1 );
*Primaria;
replace a_educ=gradoaprob if nivelaprob==2;
*Secundaria;
replace a_educ=6+gradoaprob if nivelaprob==3;
*Preparatoria;
replace a_educ=9+gradoaprob if nivelaprob==4;
*Normal, Carrera tecnica o profesional;
replace a_educ=12+gradoaprob if nivelaprob==5 | nivelaprob==6 | nivelaprob==7;
*Maestria;
replace a_educ=16+gradoaprob if nivelaprob==8;
*Doctorado;
replace a_educ=18+gradoaprob if nivelaprob==9;
label var a_educ "years of education";

*Indicador de carencia por rezago educativo
*****************************************************************************
Se considera en situación de carencia por rezago educativo 
a la población que cumpla con alguno de los siguientes criterios:

1. Se encuentra entre los 3 y los 15 años y no ha terminado la educación 
obligatoria (secundaria terminada) o no asiste a la escuela.
2. Tiene una edad de 16 años o más, su año de nacimiento aproximado es 1981 
o anterior, y no dispone de primaria completa.
3. Tiene una edad de 16 años o más, su año de nacimiento aproximado es 1982 
en adelante, y no dispone de secundaria completa.	
*****************************************************************************;
				
gen ic_rezedu=.;
replace ic_rezedu=1 if  (edad>=3 & edad<=15) & inas_esc==1 & (niv_ed==0 | niv_ed==1);
replace ic_rezedu=1 if  (edad>=16 & edad!=.) & (anac_e>=1982 & anac_e!=.) 
          & (niv_ed==0 | niv_ed==1);
replace ic_rezedu=1 if  (edad>=16 & edad!=.) & (anac_e<=1981) & (niv_ed==0);
replace ic_rezedu=0 if  (edad>=0 & edad<=2);
replace ic_rezedu=0 if  (edad>=3 & edad<=15) & inas_esc==0;
replace ic_rezedu=0 if  (edad>=3 & edad<=15) & inas_esc==1 & (niv_ed==2);
replace ic_rezedu=0 if  (edad>=16 & edad!=.) & (anac_e>=1982 & anac_e!=.) 
          & (niv_ed==2);
replace ic_rezedu=0 if  (edad>=16 & edad!=.) & (anac_e<=1981) & (niv_ed==1 | niv_ed==2);
label var ic_rezedu "Indicador de carencia por rezago educativo";
label define caren 0 "No presenta carencia"
                       1 "Presenta carencia";
label value ic_rezedu caren ;

*Hablante de lengua indígena;
rename lengua6 hablaind;
gen hli=.;
replace hli=1 if hablaind==1 & edad>=3;
replace hli=0 if hablaind==2 & edad>=3;
label var hli "Hablante de lengua indígena";
label define hli 0 "No habla lengua indígena"
                       1 "Habla lengua indígena";
label value hli hli;

*=====================================================================*;
keep proyecto folioviv foliohog numren edad anac_e inas_esc niv_ed ic_rezedu 
a_educ alfabe asis_esc nivel grado nivelaprob gradoaprob hli hablaind parentesco;
sort proyecto folioviv foliohog numren;
save "$bases\ic_rezedu08.dta", replace;

*********************************************************
*Parte II Indicadores de Privación Social:
*INDICADOR DE CARENCIA POR ACCESO A LOS SERVICIOS DE SALUD
*********************************************************;

*Acceso a servicios de salud por prestaciones laborales;
use "$data\trabajos.dta", clear;

*Tipo de trabajador: identifica la población subordinada e independiente;

*Subordinados;
gen tipo_trab=.;
replace tipo_trab=1 if subor==1;

*Independientes que reciben un pago;
replace tipo_trab=2 if subor==2 & indep==1 & tiene_suel==1;
replace tipo_trab=2 if subor==2 & indep==2 & pago==1;

*Independientes que no reciben un pago;
replace tipo_trab=3 if subor==2 & indep==1 & tiene_suel==2;
replace tipo_trab=3 if subor==2 & indep==2 & (pago==2 | pago==3);

*Ocupación principal o secundaria;
destring numtrab, replace;
recode numtrab (1=1)(2=0), gen (ocupa);

*Distinción de prestaciones en trabajo principal y secundario;
keep proyecto folioviv foliohog numren numtrab tipo_trab  ocupa;
reshape wide tipo_trab ocupa, i(proyecto folioviv foliohog numren) j(numtrab);
label var tipo_trab1 "Tipo de trabajo 1";
label var tipo_trab2 "Tipo de trabajo 2";
label var ocupa1 "Ocupación principal";
recode ocupa2 (0=1)(.=0);
label var ocupa2 "Ocupación secundaria";
label define ocupa   0 "Sin ocupación secundaria" 
                     1 "Con ocupación secundaria";
label value ocupa2 ocupa;

*Identificación de la población trabajadora (toda la que reporta al menos un empleo en la base de trabajos08.dta);
gen trab=1;
label var trab "Población con al menos un empleo";

keep proyecto folioviv foliohog numren trab tipo_trab*  ocupa*;
sort proyecto folioviv foliohog numren;
save "$bases\ocupados08.dta", replace;

use "$data\Pobla08.dta", clear;

*Población objeto: no se incluye a huéspedes ni trabajadores domésticos;
drop if parentesco>=400 & parentesco <500;
drop if parentesco>=700 & parentesco <800;

sort proyecto folioviv foliohog numren;
 
merge proyecto folioviv foliohog numren using "$bases\ocupados08.dta";
tab _merge;
drop _merge;

*PEA (personas de 16 años o más);
gen pea=.;
replace pea=1 if trab==1 & (edad>=16 & edad!=.);
replace pea=2 if bustrab_1==1 & (edad>=16 & edad!=.);
replace pea=0 if (edad>=16 & edad!=.) & bustrab_1==. & 
(bustrab_2==2 | bustrab_3==3 | bustrab_4==4 | bustrab_5==5 | 
bustrab_6==6 | bustrab_7==7);
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
                       2 "No depende de un jefe y tiene asignado un sueldo"
                       3 "No depende de un jefe y no recibe o tiene asignado un sueldo";
label value tipo_trab1 tipo_trab;

*Ocupación secundaria;
replace tipo_trab2=tipo_trab2 if pea==1;
replace tipo_trab2=. if (pea==0 | pea==2);
replace tipo_trab2=. if pea==.;
label value tipo_trab2 tipo_trab;

*Servicios médicos como prestaciones laborales;

*Ocupación principal;
gen smlab1=.;
replace smlab1=1 if ocupa1==1 & atemed==1 & (inst_1==1 | inst_2==2 | 
					inst_3==3 | inst_4==4) & (inscr_1==1);
recode smlab1 (.=0) if ocupa1==1;
label var smlab1 "Servicios médicos por prestación laboral en ocupación principal";
label define smlab 0 "Sin servicios médicos" 
                   1 "Con servicios médicos";
label value smlab1 smlab;

*Ocupación secundaria;
gen smlab2=.;
replace smlab2=1 if ocupa2==1 & atemed==1 & (inst_1==1 | inst_2==2 | 
					inst_3==3 | inst_4==4) & (inscr_1==1);
recode smlab2 (.=0) if ocupa2==1;
label var smlab2 "Servicios médicos por prestación laboral en ocupación secundaria";
label value smlab2 smlab;

*Contratación voluntaria de servicios médicos;

*Servicios médicos;
gen smcv=.;
replace smcv=1 if atemed==1 & (inst_1==1 | inst_2==2 | inst_3==3 | inst_4==4) 
					& (inscr_6==6) & (edad>=12 & edad<=97);
recode smcv (.=0) if (edad>=12 & edad<=97);
label var smcv "Servicios médicos por contratación voluntaria";
label value smcv cuenta;

*Acceso directo a servicios de salud;
gen sa_dir=.;

*Ocupación principal;
replace sa_dir=1 if tipo_trab1==1 & (smlab1==1);
replace sa_dir=1 if tipo_trab1==2 & (smlab1==1 | smcv==1);
replace sa_dir=1 if tipo_trab1==3 & (smlab1==1 | smcv==1);
*Ocupación secundaria;
replace sa_dir=1 if tipo_trab2==1 & (smlab2==1);
replace sa_dir=1 if tipo_trab2==2 & (smlab2==1 | smcv==1);
replace sa_dir=1 if tipo_trab2==3 & (smlab2==1 | smcv==1 );

*Núcleos familiares;
gen par=.;
replace par=1 if (parentesco>=100 & parentesco<200);
replace par=2 if (parentesco>=200 & parentesco<300);
replace par=3 if (parentesco>=300 & parentesco<400);
replace par=4 if parentesco==601;
replace par=5 if parentesco==615;
recode par (.=6) if  par==.;
label var par "Integrantes que tienen acceso por otros miembros";
label define par       1 "Jefe o jefa del hogar" 
                       2 "Cónyuge del  jefe/a" 
                       3 "Hijo del jefe/a" 
                       4 "Padre o madre del jefe/a"
                       5 "Suegro del jefe/a"
                       6 "Sin parentesco directo";
label value par par;

*Asimismo, se utilizará la información relativa a la asistencia a la escuela;
gen inas_esc=.;
replace inas_esc=0 if asis_esc==1;
replace inas_esc=1 if asis_esc==2;
label var inas_esc "Inasistencia a la escuela";
label define inas_esc  0 "Sí asiste" 
                       1 "No asiste";
label value inas_esc inas_esc;

*Se identifican los principales parentescos respecto a la jefatura del hogar y si dicho miembro
cuenta con acceso directo a servicios de salud;

gen jef=1 if par==1 & sa_dir==1;
replace jef=. if par==1 & sa_dir==1 & (((inst_2==2 | inst_3==3) & inscr_6==6) & (inst_1==. & inst_4==. & inst_5==.)
& (inscr_1==. & inscr_2==. & inscr_3==. & inscr_4==. & inscr_5==. & inscr_7==.));
gen cony=1 if par==2 & sa_dir==1;
replace cony=. if par==2 & sa_dir==1 & (((inst_2==2 | inst_3==3) & inscr_6==6) & (inst_1==. & inst_4==. & inst_5==.)
& (inscr_1==. & inscr_2==. & inscr_3==. & inscr_4==. & inscr_5==. & inscr_7==.));
gen hijo=1 if par==3 & sa_dir==1 ;
replace hijo=. if par==3 & sa_dir==1 & (((inst_2==2 | inst_3==3) & inscr_6==6) & (inst_1==. & inst_4==. & inst_5==.)
& (inscr_1==. & inscr_2==. & inscr_3==. & inscr_4==. & inscr_5==. & inscr_7==.));

egen jef_sa=sum(jef), by(proyecto folioviv foliohog);
egen cony_sa=sum(cony), by(proyecto folioviv foliohog);
replace cony_sa=1 if cony_sa>=1 & cony_sa!=.;
egen hijo_sa=sum(hijo), by(proyecto folioviv foliohog);
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
replace s_salud=1 if atemed==1 & (inst_1==1 | inst_2==2 | inst_3==3 | inst_4==4) 
& (inscr_3==3 | inscr_4==4 | inscr_6==6 | inscr_7==7);
recode s_salud (.=0) if segpop!=. & atemed!=.;
label var s_salud "Servicios médicos por otros núcleos familiares o por contratación propia";
label value s_salud cuenta;

*Indicador de carencia por servicios de salud;
*****************************************************************************
Se considera en situación de carencia por acceso a servicios de salud
a la población que:

1. No se encuentra afiliada o inscrita al Seguro Popular o alguna 
institución que proporcione servicios médicos, ya sea por prestación laboral,
contratación voluntaria o afiliación de un familiar por parentesco directo 
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
replace ic_asalud=0 if segpop==1 | (segpop==2 & atemed==1 & 
(inst_1==1 | inst_2==2 | inst_3==3 | inst_4==4 | inst_5==5)) | segvol_2==2;
recode ic_asalud .=1;
tostring segpop atemed inst_* segvol_*, replace force;
*Instituciones que brindan el servicio de salud;
gen serv_sal=.;
replace serv_sal=0 if segpop=="2" & atemed=="2";
replace serv_sal=1 if segpop=="1";
replace serv_sal=2 if segpop=="2" & atemed=="1" & inst_1=="1";
replace serv_sal=3 if segpop=="2" & atemed=="1" & inst_2=="2";
replace serv_sal=3 if segpop=="2" & atemed=="1" & inst_3=="3";
replace serv_sal=4 if segpop=="2" & atemed=="1" & inst_4=="4";
replace serv_sal=5 if serv_sal==0 & ic_asalud==0;
replace serv_sal=6 if segvol_2=="2";
replace serv_sal=7 if segpop=="2" & atemed=="1" & inst_5=="5";

label var serv_sal "Servicios de salud";
label define serv_sal         0 "No cuenta con servicios médicos" 
                              1 "Seguro Popular" 
                              2 "IMSS" 
                              3 "ISSSTE o ISSSTE estatal" 
                              4 "Pemex, Defensa o Marina" 
                              5 "Otros servicios médicos por seguridad social" 
			      6 "Seguro privado de gastos médicos"
			      7 "Otros";

label var ic_asalud "Indicador de carencia por acceso a servicios de salud";

label define caren  0 "No presenta carencia"
                        1 "Presenta carencia";
label value ic_asalud caren;

save "$bases\ic_asalud08.dta", replace;

use "$data\hogares.dta", clear;
keep proyecto folioviv foliohog disc;

merge m:m proyecto folioviv foliohog using "$bases\ic_asalud08.dta";
drop _merge;
tostring disc, replace force;
*Población con al menos alguna discapacidad, sea física o mental;
gen discap=.;
replace discap=1 if disc=="1";
replace discap=0 if disc=="2";

label var discap "Población con al menos una discapacidad física o mental";
label define discap  0 "No presenta discapacidad"
                        1 "Presenta discapacidad";
label value discap discap;

keep proyecto folioviv foliohog numren sexo serv_sal ic_asalud sa_* *_sa segpop 
atemed inst_* inscr_* segvol_* discap;
sort proyecto folioviv foliohog numren;
save "$bases\ic_asalud08.dta", replace;

*********************************************************
*Parte III Indicadores de Privación social:
*Indicador de carencia por acceso a la seguridad social
*********************************************************;

*Prestaciones laborales;
use "$data\trabajos.dta", clear;

*Tipo de trabajador: identifica la población subordinada e independiente;

*Subordinados;
gen tipo_trab=.;
replace tipo_trab=1 if subor==1;

*Independientes que reciben un pago;
replace tipo_trab=2 if subor==2 & indep==1 & tiene_suel==1;
replace tipo_trab=2 if subor==2 & indep==2 & pago==1;

*Independientes que no reciben un pago;
replace tipo_trab=3 if subor==2 & indep==1 & tiene_suel==2;
replace tipo_trab=3 if subor==2 & indep==2 & (pago==2 | pago==3);

*Prestaciones laborales: incapacidad en caso de enfermedad o maternidad con goce de sueldo y SAR o Afore;
gen inclab=0 if pres_1==.;
replace inclab=1 if pres_1==1;

gen aforlab=0 if pres_8==.;
replace aforlab=1 if pres_8==8;

*Ocupación principal o secundaria;
recode numtrab (1=1)(2=0), gen (ocupa);

*Distinción de prestaciones en trabajo principal y secundario;
keep proyecto folioviv foliohog numren numtrab tipo_trab inclab aforlab ocupa;
reshape wide tipo_trab inclab aforlab ocupa, i(proyecto folioviv foliohog numren) j( numtrab);
label var tipo_trab1 "Tipo de trabajo 1";
label var tipo_trab2 "Tipo de trabajo 2";
label var inclab1 "Incapacidad con goce de sueldo en ocupación principal";
label define cuenta 0 "No cuenta" 
                    1 "Sí cuenta";
label value inclab1 cuenta;
label var inclab2 "Incapacidad con goce de sueldo en ocupación secundaria";
label value inclab2 cuenta;
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

*Identificación de la población trabajadora (toda la que reporta al menos un empleo en la base de trabajos08.dta);
gen trab=1;
label var trab "Población con al menos un empleo";

keep proyecto folioviv foliohog numren trab tipo_trab* inclab* aforlab* ocupa*;
sort proyecto folioviv foliohog numren;
save "$bases\prestaciones08.dta", replace;

*=====================================================================*
*Ingresos por jubilaciones o pensiones;
*=====================================================================*;
use "$data\ingresos.dta", clear;
keep if clave=="P032" | clave=="P033" | clave=="P044" | clave=="P045" | clave=="P042" | clave=="P043" | clave=="P048";
egen ing_pens=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6)  
   if clave=="P032" | clave=="P033";
egen ing_pam=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6) 
   if clave=="P044" | clave=="P045";
egen ing_65mas=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6) 
   if clave=="P044"; 
egen ing_pam_otros=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6) 
   if clave=="P045"; 
egen ing_oportunidades=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6) 
   if clave=="P042";   
egen ing_procampo=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6) 
   if clave=="P043";   
egen ing_otros_psoc=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6) 
   if clave=="P048";
   
recode ing_pens ing_pam ing_65mas ing_pam_otros ing_oportunidades ing_procampo ing_otros_psoc(.=0);
collapse (sum) ing_pens ing_pam ing_65mas ing_pam_otros ing_oportunidades ing_procampo ing_otros_psoc, by(proyecto folioviv foliohog numren);
label var ing_pens "Ingreso promedio mensual por jubilaciones y pensiones";
label var ing_pam "Ingreso promedio mensual por programas de adultos mayores";
label var ing_65mas "Ingreso promedio mensual por programa 65 y mas";
label var ing_pam_otros "Ingreso promedio mensual por otros programas para adultos mayores";
label var ing_oportunidades "Ingreso promedio mensual por oportunidades";
label var ing_procampo "Ingreso promedio mensual por procampo";
label var ing_otros_psoc "Ingreso promedio mensual por otros programas sociales";

sort proyecto folioviv foliohog numren;
save "$bases\pensiones08.dta", replace;
*=====================================================================*

*Construcción del indicador;
use "$data\Pobla08.dta", clear;

*Población objeto:no se incluye a huéspedes ni trabajadores domésticos;
drop if parentesco>=400 & parentesco <500;
drop if parentesco>=700 & parentesco <800;

*Integración de bases;
sort proyecto folioviv foliohog numren;
merge proyecto folioviv foliohog numren using "$bases\prestaciones08.dta";
tab _merge;
drop _merge;

sort proyecto folioviv foliohog numren;
merge proyecto folioviv foliohog numren using "$bases\pensiones08.dta";
tab _merge;
drop _merge;

*PEA (personas de 16 años o más);
gen pea=.;
replace pea=1 if trab==1 & (edad>=16 & edad!=.);
replace pea=2 if bustrab_1==1 & (edad>=16 & edad!=.);
replace pea=0 if (edad>=16 & edad!=.) & bustrab_1==. & 
(bustrab_2==2 | bustrab_3==3 | bustrab_4==4 | bustrab_5==5 | 
bustrab_6==6 | bustrab_7==7);
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
                       2 "No depende de un jefe y tiene asignado un sueldo"
                       3 "No depende de un jefe y no recibe o tiene asignado un sueldo";
label value tipo_trab1 tipo_trab;

*Ocupación secundaria;
replace tipo_trab2=tipo_trab2 if pea==1;
replace tipo_trab2=. if (pea==0 | pea==2);
replace tipo_trab2=. if pea==.;
label value tipo_trab2 tipo_trab;

*Jubilados o pensionados;
gen jub=.;
replace jub=1 if trabajo==2 & bustrab_3==3;
replace jub=1 if ing_pens>0 &  ing_pens!=.;
replace jub=1 if inscr_2==2;
recode jub (.=0);
label var jub "Población pensionada o jubilada";
label define jub 0 "Población no pensionada o jubilada" 
                 1 "Población pensionada o jubilada";
label value jub jub;

*Prestaciones básicas;

*Prestaciones laborales (servicios médicos);

*Ocupación principal;
gen smlab1=.;
replace smlab1=1 if ocupa1==1 & atemed==1 & (inst_1==1 | inst_2==2 | inst_3==3 | inst_4==4) 
& (inscr_1==1);
recode smlab1 (.=0) if ocupa1==1;
label var smlab1 "Servicios médicos por prestación laboral en ocupación principal";
label define smlab 0 "Sin servicios médicos" 
                   1 "Con servicios médicos";
label value smlab1 smlab;

*Ocupación secundaria;
gen smlab2=.;
replace smlab2=1 if ocupa2==1 & atemed==1 & (inst_1==1 | inst_2==2 | inst_3==3 | inst_4==4) 
& (inscr_1==1);
recode smlab2 (.=0) if ocupa2==1;
label var smlab2 "Servicios médicos por prestación laboral en ocupación secundaria";
label value smlab2 smlab;

*Contratación voluntaria: servicios médicos y SAR o Afore;

*Servicios médicos;
gen smcv=.;
replace smcv=1 if atemed==1 & (inst_1==1 | inst_2==2 | inst_3==3 | inst_4==4) 
& (inscr_6==6) & (edad>=12 & edad<=97);
recode smcv (.=0) if (edad>=12 & edad<=97);
label var smcv "Servicios médicos por contratación voluntaria";
label value smcv cuenta;

*SAR o Afore;
gen aforecv=.;
replace aforecv=1 if segvol_1==1 & (edad>=12 & edad!=.);
recode aforecv (.=0) if segvol_1==. &  (edad>=12 & edad!=.);
label var aforecv "SAR o Afore";
label value aforecv cuenta;

*Acceso directo a la seguridad social;

gen ss_dir=.;
*Ocupación principal;
replace ss_dir=1 if tipo_trab1==1 & (smlab1==1 & inclab1==1 & aforlab1==1);
replace ss_dir=1 if tipo_trab1==2 & ((smlab1==1 | smcv==1) & (aforlab1==1 | aforecv==1));
replace ss_dir=1 if tipo_trab1==3 & ((smlab1==1 | smcv==1) & aforecv==1);
*Ocupación secundaria;
replace ss_dir=1 if tipo_trab2==1 & (smlab2==1 & inclab2==1 & aforlab2==1);
replace ss_dir=1 if tipo_trab2==2 & ((smlab2==1 | smcv==1) & (aforlab2==1 | aforecv==1));
replace ss_dir=1 if tipo_trab2==3 & ((smlab2==1 | smcv==1) & aforecv==1);
*Jubilados y pensionados;
replace ss_dir=1 if jub==1;
recode ss_dir (.=0);
label var ss_dir "Acceso directo a la seguridad social";
label define ss_dir   0 "Sin acceso"
                      1 "Con acceso";
label value ss_dir ss_dir;

*Núcleos familiares;
gen par=.;
replace par=1 if (parentesco>=100 & parentesco<200);
replace par=2 if (parentesco>=200 & parentesco<300);
replace par=3 if (parentesco>=300 & parentesco<400);
replace par=4 if parentesco==601;
replace par=5 if parentesco==615;
recode par (.=6) if  par==.;

label var par "Integrantes que tienen acceso por otros miembros";
label define par       1 "Jefe o jefa del hogar" 
                       2 "Cónyuge del  jefe/a" 
                       3 "Hijo del jefe/a" 
                       4 "Padre o madre del jefe/a"
                       5 "Suegro del jefe/a"
                       6 "Sin parentesco directo";
label value par par;

*Asimismo, se utilizará la información relativa a la asistencia a la escuela;
gen inas_esc=.;
replace inas_esc=0 if asis_esc==1;
replace inas_esc=1 if asis_esc==2;
label var inas_esc "Inasistencia a la escuela";
label define inas_esc  0 "Sí asiste" 
                       1 "No asiste";
label value inas_esc inas_esc;

*Se identifican los principales parentescos respecto a la jefatura del hogar y si ese miembro
cuenta con acceso directo;

gen jef=1 if par==1 & ss_dir==1 ;
replace jef=. if par==1 & ss_dir==1 & (((inst_2==2 | inst_3==3) & inscr_6==6) & (inst_1==. & inst_4==. & inst_5==.)
 & (inscr_1==. & inscr_2==. & inscr_3==. & inscr_4==. & inscr_5==. & inscr_7==.));
gen cony=1 if par==2 & ss_dir==1;
replace cony=. if par==2 & ss_dir==1 & (((inst_2==2 | inst_3==3) & inscr_6==6) & (inst_1==. & inst_4==. & inst_5==.)
 & (inscr_1==. & inscr_2==. & inscr_3==. & inscr_4==. & inscr_5==. & inscr_7==.));
gen hijo=1 if par==3 & ss_dir==1 & jub==0;
replace hijo=1 if par==3 & ss_dir==1 & jub==1 & (edad>25 & edad!=.);
replace hijo=. if par==3 & ss_dir==1 & (((inst_2==2 | inst_3==3) & inscr_6==6) & (inst_1==. & inst_4==. & inst_5==.)
 & (inscr_1==. & inscr_2==. & inscr_3==. & inscr_4==. & inscr_5==. & inscr_7==.));
 
egen jef_ss=sum(jef), by(proyecto folioviv foliohog);
egen cony_ss=sum(cony), by(proyecto folioviv foliohog);
replace cony_ss=1 if cony_ss>=1 & cony_ss!=.;
egen hijo_ss=sum(hijo), by(proyecto folioviv foliohog);
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
replace s_salud=1 if atemed==1 & (inst_1==1 | inst_2==2 | inst_3==3 | inst_4==4) 
& (inscr_3==3 | inscr_4==4 | inscr_6==6 | inscr_7==7);
recode s_salud (.=0) if segpop!=. & atemed!=.;
label var s_salud "Servicios médicos por otros núcleos familiares o por contratación propia";
label value s_salud cuenta;

*=====================================================================*
*Programas sociales de pensiones para adultos mayores;
*=====================================================================*;
gen pam=. ;
replace pam=1 if (edad>=70 & edad!=.) & ing_65mas>0 & ing_65mas!=.;
recode pam (.=0) if (edad>=70 & edad!=.) ;
label var pam "Programa de adultos mayores";
label define pam 0 "No recibe" 
                 1 "Recibe";
label value pam pam;

gen sesentaycinco_mas=.;
replace sesentaycinco_mas=1 if (edad>=65 & edad!=.) & ing_65mas>0 & ing_65mas!=.;
recode sesentaycinco_mas (.=0) if (edad>=65 & edad!=.) ;
label var sesentaycinco_mas "Programa 65 y mas";
label define sesentaycinco_mas 0 "No recibe" 
                   1 "Recibe";
label value sesentaycinco_mas sesentaycinco_mas;

gen pam_otros=.;
replace pam_otros=1 if ing_pam_otros>0 & ing_pam_otros!=.;
replace pam_otros=0 if ing_pam_otros==0 & ing_pam_otros!=.;
label var pam_otros "Otros programas de adultos mayores";
label define pam_otros 0 "No recibe" 
                   1 "Recibe";
label value pam_otros pam_otros;

gen oportunidades=.;
replace oportunidades=1 if ing_oportunidades>0 & ing_oportunidades!=.;
replace oportunidades=0 if ing_oportunidades==0 & ing_oportunidades!=.;
label var oportunidades "Oportunidades";
label define oportunidades 0 "No recibe" 
                   1 "Recibe";
label value oportunidades oportunidades;

gen procampo=.;
replace procampo=1 if ing_procampo>0 & ing_procampo!=.;
replace procampo=0 if ing_procampo==0 & ing_procampo!=.;
label var procampo "Procampo";
label define procampo 0 "No recibe" 
                   1 "Recibe";
label value procampo procampo;

gen otros_psoc=.;
replace otros_psoc=1 if ing_otros_psoc>0 & ing_otros_psoc!=.;
replace otros_psoc=0 if ing_procampo==0 & ing_procampo!=.;
label var otros_psoc "Otros programas sociales";
label define otros_psoc 0 "No recibe" 
                   1 "Recibe";
label value otros_psoc otros_psoc;

*Indicador de carencia por acceso a la seguridad social;
************************************************************************
No se considera en situación de carencia por acceso a la seguridad social
a la población que:
1. Disponga de acceso directo a la seguridad social,
2. Cuente con parentesco directo con alguna persona dentro del hogar
que tenga acceso directo,
3. Reciba servicios médicos por parte de algún familiar dentro o
fuera del hogar, por muerte del asegurado o por contratación propia, o,
4. Reciba ingresos por parte de un programa de adultos mayores. 

Se considera en situación de carencia por acceso a la seguridad social
aquella población:

1. En cualquier otra situación.
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
*=====================================================================*
*Programa de adultos mayores;
*=====================================================================*;
replace ic_segsoc=0 if pam==1;
recode ic_segsoc (.=1);
label var ic_segsoc "Indicador de carencia por acceso a la seguridad social";
label define caren 0 "Con acceso"
                       1 "Sin acceso";
label value ic_segsoc caren;

keep proyecto folioviv foliohog numren tipo_trab*  inclab*  aforlab* smlab* smcv 
aforecv pea jub ss_dir par jef_ss cony_ss hijo_ss s_salud pam ing_pens ing_pam 
ing_65mas sesentaycinco_mas ing_pam_otros ing_oportunidades ing_procampo 
ing_otros_psoc pam_otros oportunidades procampo otros_psoc  ic_segsoc hor_1 
min_1 hor_2 min_2 hor_3 min_3 hor_4 min_4 hor_5 min_5 edocony segsoc ss_aa ss_mm;

sort proyecto folioviv foliohog numren;

save "$bases\ic_segsoc08.dta", replace;

***********************************************************
*Parte IV Indicadores de Privación social:
*Indicador de carencia por calidad y espacios de la vivienda
***********************************************************;

*Material de construcción de la vivienda;

use "$data\hogares.dta", clear;
sort proyecto folioviv foliohog;
save "$data\hogares.dta", replace;
use "$data\Concen.dta", clear;
sort proyecto folioviv foliohog;
merge proyecto folioviv foliohog using "$data\hogares.dta";
tab _merge;
drop _merge;
*=====================================================================*;
destring pisos techos pared p65mas n_ocup pering perocu transfer remesa esp_hog, replace;
rename n_ocup ocupados;
rename pering percep_ing;
rename perocu perc_ocupa;
rename remesa remesas;
rename esp_hog transf_hog;
*=====================================================================*;

*Material de los pisos de la vivienda;
recode pisos (-1=.);
egen icv_pisos=sum(pisos), by(proyecto folioviv);
recode icv_pisos (0=.);
recode icv_pisos (2 3 4 5 6=0) (1=1);

*Material de los techos de la vivienda;
egen icv_techos=sum(techos), by(proyecto folioviv);
recode icv_techos (0=.);
recode icv_techos (3 4 5 6 7 8 9=0) (1 2=1);

*Material de muros en la vivienda;
egen icv_muros=sum(pared), by(proyecto folioviv);
recode icv_muros (0=.);
recode icv_muros (6 7 8=0) (1 2 3 4 5=1);

*Espacios en la vivienda (hacinamiento);

*Número de residentes en la vivienda;
egen num_ind=sum(tot_resi), by(proyecto folioviv);
recode num_ind (0=.);

*Número de cuartos en la vivienda;
egen num_cua=sum(cuart), by(proyecto folioviv);
recode num_cua (0=.);

*Índice de hacinamiento;
gen cv_hac=num_ind/num_cua;

*Indicador de carencia por hacinamiento;
gen icv_hac=.;
replace icv_hac=1 if cv_hac>2.5 & cv_hac!=.;
replace icv_hac=0 if cv_hac<=2.5;

label var icv_pisos "Indicador de carencia del material de piso de la vivienda";
label define caren     0 "Sin carencia"
                       1 "Con carencia";
label value icv_pisos caren;

label var icv_techos "Indicador de carencia por material de techos de la vivienda";
label value icv_techos caren;

label var icv_muros "Indicador de carencia del material de muros de la vivienda";
label value icv_muros caren;

label var icv_hac "Indicador de carencia por índice de hacinamiento de la vivienda";
label value icv_hac caren;

*Indicador de carencia por calidad y espacios de la vivienda;
********************************************************************************
Se considera en situación de carencia por calidad y espacios 
de la vivienda a la población que:

1. Presente carencia en cualquiera de los subindicadores de esta dimensión

No se considera en situación de carencia por rezago calidad y espacios 
de la vivienda a la población que:

1. Habite en una vivienda sin carencia en todos los subindicadores
de esta dimensión
********************************************************************************;

gen ic_cv=.;
replace ic_cv=1 if icv_pisos==1 | icv_techos==1 | icv_muros==1 | icv_hac==1;
replace ic_cv=0 if icv_pisos==0 & icv_techos==0 & icv_muros==0 & icv_hac==0;
replace ic_cv=. if icv_pisos==. | icv_techos==. | icv_muros==. | icv_hac==.;
label var ic_cv "Indicador de carencia por calidad y espacios de la vivienda";
label value ic_cv caren;
sort proyecto folioviv foliohog;
*=====================================================================*;
keep proyecto folioviv foliohog icv_pisos icv_techos icv_muros icv_hac ic_cv 
clase_hog p65mas ocupados percep_ing perc_ocupa transfer remesas transf_hog;
save "$bases\ic_cev08.dta", replace;
 
************************************************************************
*Parte V Indicadores de Privación Social:
*Indicador de carencia por acceso a los servicios básicos de la vivienda
*************************************************************************;

use "$data\hogares.dta", clear;

*Disponibilidad de agua;
egen isb_agua=sum(agua13), by(proyecto folioviv);
recode isb_agua (0=.);
recode isb_agua (1 2=0) (3 4 5 6 7=1);

*Drenaje;
egen isb_dren=sum(drenaje), by(proyecto folioviv);
recode isb_dren (0=.);
recode isb_dren (1 2=0) (3 4 5=1);

*Electricidad;
egen isb_luz=sum(elect), by(proyecto folioviv);
recode isb_luz (0=.);
recode isb_luz (1 2 3 4=0) (5=1);


*Combustible;
recode combus (-1=.);
recode estufa (-1=.);
egen combus1=sum(combus), by(proyecto folioviv);
egen estufa1=sum(estufa_chimenea), by(proyecto folioviv);
replace estufa1=1 if estufa1>0 & estufa1!=.;

recode combus1 (0=.);
gen isb_combus=0 if (combus1==1 | combus1==2) | (combus1>=5) & combus1!=.;
replace isb_combus=0 if (combus1==3 | combus1==4) & estufa1==1 & estufa1!=.;
replace isb_combus=1 if (combus1==3 | combus1==4) & estufa1==0 & estufa1!=.;

label var isb_agua "Indicador de carencia de acceso al agua";
label define caren 0 "Sin carencia"
                      1 "Con carencia";
label value isb_agua caren;
label var isb_dren "Indicador de carencia de servicio de drenaje";
label value isb_dren caren;
label var isb_luz "Indicador de carencia de servicios de electricidad";
label value isb_luz caren;
label var isb_combus "Indicador de carencia de servicios de combustible";
label value isb_combus caren;

*Indicador de carencia por acceso a los servicios básicos en la vivienda;
********************************************************************************
Se considera en situación de carencia por servicios básicos en la vivienda 
a la población que:

1. Presente carencia en cualquiera de los subindicadores de esta dimensión

No se considera en situación de carencia por  servicios básicos en la vivienda
a la población que:

1. Habite en una vivienda sin carencia en todos los subindicadores
de esta dimensión
********************************************************************************;

gen ic_sbv=.;
replace ic_sbv=1 if (isb_agua==1 | isb_dren==1 | isb_luz==1 | isb_combus==1);
replace ic_sbv=0 if isb_agua==0 & isb_dren==0 & isb_luz==0 & isb_combus==0;
replace ic_sbv=. if (isb_agua==. | isb_dren==. | isb_luz==. | isb_combus==.);
label var ic_sbv "Indicador de carencia de acceso a servicios básicos de la vivienda";
label value ic_sbv caren;

sort proyecto folioviv foliohog;
keep proyecto folioviv foliohog isb_agua isb_dren isb_luz ic_sbv isb_combus;
save "$bases\ic_sbv08.dta", replace;

**********************************************************************
*Parte VI Indicadores de Privación Social:
*Indicador de carencia por acceso a la alimentación
**********************************************************************;
use "$data\Pobla08.dta", clear;
 
*Población objeto: no se incluye a huéspedes ni trabajadores domésticos;
drop if parentesco>=400 & parentesco <500;
drop if parentesco>=700 & parentesco <800;

*Indicador de hogares con menores de 18 años;
gen men=1 if edad>=0 & edad<=17;
collapse (sum) men, by(proyecto folioviv foliohog);

gen id_men=.;
replace id_men=1 if men>=1 & men!=.;
replace id_men=0 if men==0;
label var id_men "Hogares con población de 0 a 17 años de edad";
label define id_men 0 "Sin población de 0 a 17 años"
                    1 "Con población de 0 a 17 años";
label value id_men id_men;

sort proyecto folioviv foliohog;
keep proyecto folioviv foliohog id_men;
save "$bases\menores08.dta", replace;

use "$data\hogares.dta", clear;

* SEIS PREGUNTAS PARA HOGARES SIN POBLACIÓN MENOR A 18 AÑOS;
recode alim1 (2=0) (1=1), gen (ia_1ad);
recode alim2 (2=0) (1=1), gen (ia_2ad);
recode alim3 (2=0) (1=1), gen (ia_3ad);
recode alim4 (2=0) (1=1), gen (ia_4ad);
recode alim5 (2=0) (1=1), gen (ia_5ad);
recode alim6 (2=0) (1=1), gen (ia_6ad);

* SEIS PREGUNTAS PARA HOGARES CON POBLACIÓN MENOR A 18 AÑOS;
recode alim7 (2=0) (1=1), gen (ia_7men);
recode alim8 (2=0) (1=1), gen (ia_8men);
recode alim9 (2=0) (1=1), gen (ia_9men);
recode alim10 (2=0) (1=1), gen (ia_10men);
recode alim11 (2=0) (1=1), gen (ia_11men);
recode alim12 (2=0) (1=1), gen (ia_12men);

label var ia_1ad "Algún adulto tuvo una alimentación basada en muy poca variedad de alimentos";
label define si_no 1 "Sí" 0 "No";
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

*Construcción de la escala de inseguridad alimentaria;
sort proyecto folioviv foliohog;
merge proyecto folioviv foliohog using "$bases\menores08.dta";
tab _merge;
drop _merge;

*Escala para hogares sin menores de 18 años;
gen tot_iaad=.;
replace tot_iaad=ia_1ad + ia_2ad + ia_3ad +ia_4ad + ia_5ad+ ia_6ad if id_men==0;
label var tot_iaad "Escala de IA para hogares sin menores de 18 años";

*Escala para hogares con menores de 18 años;
gen tot_iamen=.;
replace tot_iamen=ia_1ad + ia_2ad + ia_3ad +ia_4ad + ia_5ad+ ia_6ad+ia_7men + ia_8men + ia_9men+ia_10men + ia_11men+ia_12men if id_men==1;
label var tot_iamen "Escala IA para hogares con menores de 18 años ";

gen ins_ali=.;
replace ins_ali=0 if tot_iaad==0 | tot_iamen==0;
replace ins_ali=1 if (tot_iaad==1 | tot_iaad==2) | (tot_iamen==1 | tot_iamen==2 |tot_iamen==3);
replace ins_ali=2 if  (tot_iaad==3 | tot_iaad==4) | (tot_iamen==4 | tot_iamen==5 |tot_iamen==6 |tot_iamen==7);
replace ins_ali=3 if (tot_iaad==5 | tot_iaad==6) | (tot_iamen>=8 & tot_iamen!=.) ;

label var  ins_ali "Grado de inseguridad alimentaria";
label define  ins_ali 0 "Seguridad alimentaria"
                      1 "Inseguridad alimentaria leve"
                      2 "Inseguridad alimentaria moderada"
                      3 "Inseguridad alimentaria severa";
label value ins_ali ins_ali;

*Indicador de carencia por acceso a la alimentación;
***********************************************************************
Se considera en situación de carencia por acceso a la alimentación 
a la población en hogares que:

1. Presenten inseguridad alimentaria moderada o severa

No se considera en situación de carencia por acceso a la alimentación 
a la población que:

1. No presente inseguridad alimentaria o un grado de inseguridad 
alimentaria leve;
***********************************************************************;
gen ic_ali=.;
replace ic_ali=1 if ins_ali==2 | ins_ali==3;
replace ic_ali=0 if ins_ali==0 | ins_ali==1;
label var ic_ali "Indicador de carencia por acceso a la alimentación";
label define caren 1 "Con carencia"
                    0 "Sin carencia";
label value ic_ali caren;

sort proyecto folioviv foliohog;
keep proyecto folioviv foliohog id_men ia_* tot_iaad tot_iamen ins_ali ic_ali;
save "$bases\ic_ali08.dta", replace;

*********************************************************
*Parte VII 
*Bienestar (ingresos)
*********************************************************;

*Para la construcción del ingreso corriente del hogar es necesario utilizar
información sobre la condición de ocupación y los ingresos de los individuos.
Se utiliza la información contenida en la base "$bases\trabajo.dta" para 
identificar a la población ocupada que declara tener como prestación laboral aguinaldo, 
ya sea por su trabajo principal o secundario, a fin de incorporar los ingresos por este 
concepto en la medición;

*Creación del ingreso monetario deflactado a pesos de agosto del 2008;

*Ingresos;

use "$data\trabajos.dta", clear;

keep proyecto folioviv foliohog numren numtrab pres_2;
reshape wide pres_2, i(proyecto folioviv foliohog numren) j( numtrab);

gen trab=1;

label var trab "Población con al menos un empleo";

gen aguinaldo=.;
replace aguinaldo=1 if pres_21==2 | pres_22==2;
recode aguinaldo (.=0);

label var aguinaldo "Aguinaldo";
label define aguinaldo 0 "No dispone de aguinaldo"
                       1 "Dispone de aguinaldo";
label value aguinaldo aguinaldo;

keep proyecto folioviv foliohog numren aguinaldo trab;

sort proyecto folioviv foliohog numren ;

save "$bases\aguinaldo.dta", replace;

*Ahora se incorpora a la base de ingresos;

use "$data\ingresos.dta", clear;

sort proyecto folioviv foliohog numren;

merge proyecto folioviv foliohog numren using "$bases\aguinaldo.dta";

tab _merge;
drop _merge;

sort proyecto folioviv foliohog numren;

drop if (clave=="P009" & aguinaldo!=1);

*Una vez realizado lo anterior, se procede a deflactar el ingreso recibido
por los hogares a precios de agosto de 2008. Para ellos se utilizan las 
variables meses, las cuales toman los valores 2 a 10 e indican el mes en
que se recibió el ingreso respectivo;

*Definición de los deflactores 2008;

scalar dic07	=	0.969037000	;
scalar ene08	=	0.973529049	;
scalar feb08	=	0.976423103	;
scalar mar08	=	0.983500031	;
scalar abr08	=	0.985738100	;
scalar may08	=	0.984673088	;
scalar jun08	=	0.988747916	;
scalar jul08	=	0.994258196	;
scalar ago08	=	1.000000000	;
scalar sep08	=	1.006814534	;
scalar oct08	=	1.013675372	;
scalar nov08	=	1.025197567	;
scalar dic08	=	1.032297648	;

replace ing_6=ing_6/feb08 if mes_6==2;
replace ing_6=ing_6/mar08 if mes_6==3;
replace ing_6=ing_6/abr08 if mes_6==4;
replace ing_6=ing_6/may08 if mes_6==5;

replace ing_5=ing_5/mar08 if mes_5==3;
replace ing_5=ing_5/abr08 if mes_5==4;
replace ing_5=ing_5/may08 if mes_5==5;
replace ing_5=ing_5/jun08 if mes_5==6;

replace ing_4=ing_4/abr08 if mes_4==4;
replace ing_4=ing_4/may08 if mes_4==5;
replace ing_4=ing_4/jun08 if mes_4==6;
replace ing_4=ing_4/jul08 if mes_4==7;

replace ing_3=ing_3/may08 if mes_3==5;
replace ing_3=ing_3/jun08 if mes_3==6;
replace ing_3=ing_3/jul08 if mes_3==7;
replace ing_3=ing_3/ago08 if mes_3==8;

replace ing_2=ing_2/jun08 if mes_2==6;
replace ing_2=ing_2/jul08 if mes_2==7;
replace ing_2=ing_2/ago08 if mes_2==8;
replace ing_2=ing_2/sep08 if mes_2==9;

replace ing_1=ing_1/jul08 if mes_1==7;
replace ing_1=ing_1/ago08 if mes_1==8;
replace ing_1=ing_1/sep08 if mes_1==9;
replace ing_1=ing_1/oct08 if mes_1==10;

*Se deflacta la claves P008(Reparto de utilidades) 
y P009 (aguinaldo)
con los deflactores de mayo a agosto 2008 
y de dicembre de 2007 a agosto 2008, 
respectivamente, y se obtiene el promedio mensual.;

replace ing_1=(ing_1/may08)/12 if clave=="P008";
replace ing_1=(ing_1/dic07)/12 if clave=="P009";

recode ing_2 ing_3 ing_4 ing_5 ing_6 (0=.) if clave=="P008" | clave=="P009";

*Una vez realizada la deflactación, se procede a obtener el 
ingreso mensual promedio en los últimos seis meses, para 
cada persona y clave de ingreso;

egen double ing_mens=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6);

*Para obtener el ingreso corriente monetario, se seleccionan 
las claves de ingreso correspondientes;

gen double ing_mon=ing_mens if (clave>="P001" & clave<="P009") | (clave>="P011" & clave<="P013") 
                             | (clave>="P015" & clave<="P018") | (clave>="P020" & clave<="P045") 
                             | (clave=="P063") | (clave>="P067" & clave<="P080");

*Para obtener el ingreso laboral, se seleccionan 
las claves de ingreso correspondientes;
gen double ing_lab=ing_mens if (clave>="P001" & clave<="P009") | (clave>="P011" & clave<="P013") 
                             | (clave>="P015" & clave<="P018") | (clave>="P020" & clave<="P022")
							 | (clave=="P063") | (clave>="P067" & clave<="P080");

*Para obtener el ingreso por rentas, se seleccionan 
las claves de ingreso correspondientes;
gen double ing_ren=ing_mens if (clave>="P023" & clave<="P031");

*Para obtener el ingreso por transferencias, se seleccionan 
las claves de ingreso correspondientes;
gen double ing_tra=ing_mens if (clave>="P032" & clave<="P045");
													 
*Se estima el total de ingresos de cada  hogar;

collapse (sum) ing_mon ing_lab ing_ren ing_tra, by(proyecto folioviv foliohog);

label var ing_mon "Ingreso corriente monetario del hogar";
label var ing_lab "Ingreso corriente monetario laboral";
label var ing_ren "Ingreso corriente monetario por rentas";
label var ing_tra "Ingreso corriente monetario por transferencias";

sort proyecto folioviv foliohog;

save "$bases\ingreso_deflactado08.dta", replace;

*********************************************************
Creación del ingreso no monetario deflactado a pesos de 
agosto del 2008.
*********************************************************;

*No Monetario;

use "$data\NomonE.dta", clear;

sort proyecto folioviv foliohog;

save "$bases\NomonEf08.dta", replace;

use "$data\NomonM.dta", clear;

rename frec frecu;

sort proyecto folioviv foliohog;

save "$bases\NomonMf08.dta", replace;

use "$bases\NomonEf08.dta", clear;
merge proyecto folioviv foliohog using "$bases\NomonMf08.dta";
tab _merge;
drop _merge;

save "$bases\nomonetario08.dta", replace;

use "$bases\nomonetario08.dta", clear;

*En el caso de la información de gasto no monetario, para 
deflactar se utiliza la decena de levantamiento de la 
encuesta, la cual se encuentra en la tercera posición del 
folio de la vivienda. En primer lugar se obtiene una variable que 
identifique la decena de levantamiento;

gen decena=real(substr(folioviv,3,1));

*Definición de los deflactores;

*Rubro 1.1 semanal, Alimentos;

scalar d11w07=	0.992849335	;
scalar d11w08=	1.000000000	;
scalar d11w09=	1.007547538	;
scalar d11w10=	1.013695578	;
scalar d11w11=	1.031951707	;

*Rubro 1.2 semanal, Bebidas alcohólicas y tabaco;

scalar d12w07=	0.9932201	;
scalar d12w08=	1.000000000	;
scalar d12w09=	1.004577412	;
scalar d12w10=	1.006356646	;
scalar d12w11=	1.009037254	;

*Rubro 2 trimestral, Ropa, calzado y accesorios;

scalar d2t05	=	0.995665531	;
scalar d2t06	=	0.996958756	;
scalar d2t07	=	0.999047098	;
scalar d2t08	=	1.002728766	;

*Rubro 3 mensual, Vivienda;

scalar d3m07	=	0.9958319	;
scalar d3m08	=	1	;
scalar d3m09	=	1.0030142	;
scalar d3m10	=	1.0168688	;
scalar d3m11	=	1.0365948	;

*Rubro 4.2 mensual, Accesorios y artículos de limpieza para el hogar;

scalar d42m07	=	0.991289243	;
scalar d42m08	=	1	;
scalar d42m09	=	1.013674952	;
scalar d42m10	=	1.02126174	;
scalar d42m11	=	1.027860798	;

*Rubro 4.2 trimestral, Accesorios y artículos de limpieza para el hogar;

scalar d42t05	=	0.984148069	;
scalar d42t06	=	0.992234399	;
scalar d42t07	=	1.001654732	;
scalar d42t08	=	1.011645564	;

*Rubro 4.1 semestral, Muebles y aparatos dómesticos;

scalar d41s02	=	0.992557573	;
scalar d41s03	=	0.995164752	;
scalar d41s04	=	0.996819338	;
scalar d41s05	=	0.998708459	;

*Rubro 5.1 trimestral, Salud;

scalar d51t05	=	0.996679643	;
scalar d51t06	=	0.998782369	;
scalar d51t07	=	1.000350038	;
scalar d51t08	=	1.00260528	;

*Rubro 6.1.1 semanal, Transporte público urbano;

scalar d611w07	=	0.980054808	;
scalar d611w08	=	1	;
scalar d611w09	=	1.016238497	;
scalar d611w10	=	1.020556684	;
scalar d611w11	=	1.027320837	;

*Rubro 6 mensual, Transporte;

scalar d6m07	=	0.990822285	;
scalar d6m08	=	1	;
scalar d6m09	=	1.007629278	;
scalar d6m10	=	1.014032711	;
scalar d6m11	=	1.019274815	;

*Rubro 6 semestral, Transporte;

scalar d6s02	=	0.979756067	;
scalar d6s03	=	0.985035808	;
scalar d6s04	=	0.990415013	;
scalar d6s05	=	0.996299612	;

*Rubro 7 mensual, Educación y esparcimiento;

scalar d7m07	=	0.996539589	;
scalar d7m08	=	1	;
scalar d7m09	=	1.018093842	;
scalar d7m10	=	1.020146628	;
scalar d7m11	=	1.023013196	;

*Rubro 2.3 mensual, Accesorios y cuidados del vestido;

scalar d23m07	=	1.008233945	;
scalar d23m08	=	1	;
scalar d23m09	=	0.998860856	;
scalar d23m10	=	1.007889908	;
scalar d23m11	=	1.012568807	;

*Rubro 2.3 trimestral,  Accesorios y cuidados del vestido;

scalar d23t05	=	1.004801223	;
scalar d23t06	=	1.00401631	;
scalar d23t07	=	1.002364934	;
scalar d23t08	=	1.002250255	;

*INPC semestral;

scalar dINPCs02	=	0.985556739	;
scalar dINPCs03	=	0.989486222	;
scalar dINPCs04	=	0.993371972	;
scalar dINPCs05	=	0.998028184	;

*Una vez definidos los deflactores, se seleccionan los rubros;

gen double gasnomon=apo_tri/3;

gen esp=1 if tipogasto==2;
gen reg=1 if tipogasto==3;
replace reg=1 if tipogasto==4;
drop if tipogasto==1 ;

*Control para la frecuencia de los regalos recibidos, para no monetario ENIGH;
drop if ((frecu>=5 & frecu<=6) | frecu==.) & proyecto=="2" & tipogasto==3;

*Para no monetario MCS;

drop if ((frecu>=11 & frecu<=12) | frecu==.) & proyecto=="1" & tipogasto==3;

*Gasto en Alimentos deflactado (semanal) ;

gen ali_nm=gasnomon if (clave>="A001" & clave<="A222") | 
(clave>="A242" & clave<="A247");

replace ali_nm=ali_nm/d11w08 if decena==0;
replace ali_nm=ali_nm/d11w08 if decena==1;
replace ali_nm=ali_nm/d11w08 if decena==2;
replace ali_nm=ali_nm/d11w09 if decena==3;
replace ali_nm=ali_nm/d11w09 if decena==4;
replace ali_nm=ali_nm/d11w09 if decena==5;
replace ali_nm=ali_nm/d11w10 if decena==6;
replace ali_nm=ali_nm/d11w10 if decena==7;
replace ali_nm=ali_nm/d11w10 if decena==8;
replace ali_nm=ali_nm/d11w11 if decena==9;

*Gasto en Alcohol y tabaco deflactado (semanal);

gen alta_nm=gasnomon if (clave>="A223" & clave<="A241");

replace alta_nm=alta_nm/d12w08 if decena==0;
replace alta_nm=alta_nm/d12w08 if decena==1;
replace alta_nm=alta_nm/d12w08 if decena==2;
replace alta_nm=alta_nm/d12w09 if decena==3;
replace alta_nm=alta_nm/d12w09 if decena==4;
replace alta_nm=alta_nm/d12w09 if decena==5;
replace alta_nm=alta_nm/d12w10 if decena==6;
replace alta_nm=alta_nm/d12w10 if decena==7;
replace alta_nm=alta_nm/d12w10 if decena==8;
replace alta_nm=alta_nm/d12w11 if decena==9;

*Gasto en Vestido y calzado deflactado (trimestral);

gen veca_nm=gasnomon if (clave>="H001" & clave<="H122") | 
(clave=="H136");

replace veca_nm=veca_nm/d2t05 if decena==0;
replace veca_nm=veca_nm/d2t05 if decena==1;
replace veca_nm=veca_nm/d2t06 if decena==2;
replace veca_nm=veca_nm/d2t06 if decena==3;
replace veca_nm=veca_nm/d2t06 if decena==4;
replace veca_nm=veca_nm/d2t07 if decena==5;
replace veca_nm=veca_nm/d2t07 if decena==6;
replace veca_nm=veca_nm/d2t07 if decena==7;
replace veca_nm=veca_nm/d2t08 if decena==8;
replace veca_nm=veca_nm/d2t08 if decena==9;

*Gasto en Vivienda y servicios de conservación deflactado (mensual);

gen viv_nm=gasnomon if (clave>="G001" & clave<="G022");

replace viv_nm=viv_nm/d3m07 if decena==0;
replace viv_nm=viv_nm/d3m07 if decena==1;
replace viv_nm=viv_nm/d3m08 if decena==2;
replace viv_nm=viv_nm/d3m08 if decena==3;
replace viv_nm=viv_nm/d3m08 if decena==4;
replace viv_nm=viv_nm/d3m09 if decena==5;
replace viv_nm=viv_nm/d3m09 if decena==6;
replace viv_nm=viv_nm/d3m09 if decena==7;
replace viv_nm=viv_nm/d3m10 if decena==8;
replace viv_nm=viv_nm/d3m10 if decena==9;

*Gasto en Artículos de limpieza deflactado (mensual);

gen lim_nm=gasnomon if (clave>="C001" & clave<="C024");

replace lim_nm=lim_nm/d42m07 if decena==0;
replace lim_nm=lim_nm/d42m07 if decena==1;
replace lim_nm=lim_nm/d42m08 if decena==2;
replace lim_nm=lim_nm/d42m08 if decena==3;
replace lim_nm=lim_nm/d42m08 if decena==4;
replace lim_nm=lim_nm/d42m09 if decena==5;
replace lim_nm=lim_nm/d42m09 if decena==6;
replace lim_nm=lim_nm/d42m09 if decena==7;
replace lim_nm=lim_nm/d42m10 if decena==8;
replace lim_nm=lim_nm/d42m10 if decena==9;

*Gasto en Cristalería y blancos deflactado (trimestral);

gen cris_nm=gasnomon if (clave>="I001" & clave<="I026");

replace cris_nm=cris_nm/d42t05 if decena==0;
replace cris_nm=cris_nm/d42t05 if decena==1;
replace cris_nm=cris_nm/d42t06 if decena==2;
replace cris_nm=cris_nm/d42t06 if decena==3;
replace cris_nm=cris_nm/d42t06 if decena==4;
replace cris_nm=cris_nm/d42t07 if decena==5;
replace cris_nm=cris_nm/d42t07 if decena==6;
replace cris_nm=cris_nm/d42t07 if decena==7;
replace cris_nm=cris_nm/d42t08 if decena==8;
replace cris_nm=cris_nm/d42t08 if decena==9;

*Gasto en Enseres domésticos y muebles deflactado (semestral);

gen ens_nm=gasnomon if (clave>="K001" & clave<="K036");

replace ens_nm=ens_nm/d41s02 if decena==0;
replace ens_nm=ens_nm/d41s02 if decena==1;
replace ens_nm=ens_nm/d41s03 if decena==2;
replace ens_nm=ens_nm/d41s03 if decena==3;
replace ens_nm=ens_nm/d41s03 if decena==4;
replace ens_nm=ens_nm/d41s04 if decena==5;
replace ens_nm=ens_nm/d41s04 if decena==6;
replace ens_nm=ens_nm/d41s04 if decena==7;
replace ens_nm=ens_nm/d41s05 if decena==8;
replace ens_nm=ens_nm/d41s05 if decena==9;

*Gasto en Salud deflactado (trimestral);

gen sal_nm=gasnomon if (clave>="J001" & clave<="J072");

replace sal_nm=sal_nm/d51t05 if decena==0;
replace sal_nm=sal_nm/d51t05 if decena==1;
replace sal_nm=sal_nm/d51t06 if decena==2;
replace sal_nm=sal_nm/d51t06 if decena==3;
replace sal_nm=sal_nm/d51t06 if decena==4;
replace sal_nm=sal_nm/d51t07 if decena==5;
replace sal_nm=sal_nm/d51t07 if decena==6;
replace sal_nm=sal_nm/d51t07 if decena==7;
replace sal_nm=sal_nm/d51t08 if decena==8;
replace sal_nm=sal_nm/d51t08 if decena==9;

*Gasto en Transporte público deflactado (semanal);

gen tpub_nm=gasnomon if (clave>="B001" & clave<="B007");

replace tpub_nm=tpub_nm/d611w08 if decena==0;
replace tpub_nm=tpub_nm/d611w08 if decena==1;
replace tpub_nm=tpub_nm/d611w08 if decena==2;
replace tpub_nm=tpub_nm/d611w09 if decena==3;
replace tpub_nm=tpub_nm/d611w09 if decena==4;
replace tpub_nm=tpub_nm/d611w09 if decena==5;
replace tpub_nm=tpub_nm/d611w10 if decena==6;
replace tpub_nm=tpub_nm/d611w10 if decena==7;
replace tpub_nm=tpub_nm/d611w10 if decena==8;
replace tpub_nm=tpub_nm/d611w11 if decena==9;

*Gasto en Transporte foráneo deflactado (semestral);

gen tfor_nm=gasnomon if (clave>="M001" & clave<="M018") | 
(clave>="F010" & clave<="F017");

replace tfor_nm=tfor_nm/d6s02 if decena==0;
replace tfor_nm=tfor_nm/d6s02 if decena==1;
replace tfor_nm=tfor_nm/d6s03 if decena==2;
replace tfor_nm=tfor_nm/d6s03 if decena==3;
replace tfor_nm=tfor_nm/d6s03 if decena==4;
replace tfor_nm=tfor_nm/d6s04 if decena==5;
replace tfor_nm=tfor_nm/d6s04 if decena==6;
replace tfor_nm=tfor_nm/d6s04 if decena==7;
replace tfor_nm=tfor_nm/d6s05 if decena==8;
replace tfor_nm=tfor_nm/d6s05 if decena==9;

*Gasto en Comunicaciones deflactado (mensual);

gen com_nm=gasnomon if (clave>="F001" & clave<="F009");

replace com_nm=com_nm/d6m07 if decena==0;
replace com_nm=com_nm/d6m07 if decena==1;
replace com_nm=com_nm/d6m08 if decena==2;
replace com_nm=com_nm/d6m08 if decena==3;
replace com_nm=com_nm/d6m08 if decena==4;
replace com_nm=com_nm/d6m09 if decena==5;
replace com_nm=com_nm/d6m09 if decena==6;
replace com_nm=com_nm/d6m09 if decena==7;
replace com_nm=com_nm/d6m10 if decena==8;
replace com_nm=com_nm/d6m10 if decena==9;

*Gasto en Educación y recreación deflactado (mensual);

gen edre_nm=gasnomon if (clave>="E001" & clave<="E033") | 
(clave>="H134" & clave<="H135") | (clave>="L001" & 
clave<="L029") | (clave>="N003" & clave<="N005");

replace edre_nm=edre_nm/d7m07 if decena==0;
replace edre_nm=edre_nm/d7m07 if decena==1;
replace edre_nm=edre_nm/d7m08 if decena==2;
replace edre_nm=edre_nm/d7m08 if decena==3;
replace edre_nm=edre_nm/d7m08 if decena==4;
replace edre_nm=edre_nm/d7m09 if decena==5;
replace edre_nm=edre_nm/d7m09 if decena==6;
replace edre_nm=edre_nm/d7m09 if decena==7;
replace edre_nm=edre_nm/d7m10 if decena==8;
replace edre_nm=edre_nm/d7m10 if decena==9;

*Gasto en Educación básica deflactado (mensual);

gen edba_nm=gasnomon if (clave>="E002" & clave<="E003") | 
(clave>="H134" & clave<="H135");

replace edba_nm=edba_nm/d7m07 if decena==0;
replace edba_nm=edba_nm/d7m07 if decena==1;
replace edba_nm=edba_nm/d7m08 if decena==2;
replace edba_nm=edba_nm/d7m08 if decena==3;
replace edba_nm=edba_nm/d7m08 if decena==4;
replace edba_nm=edba_nm/d7m09 if decena==5;
replace edba_nm=edba_nm/d7m09 if decena==6;
replace edba_nm=edba_nm/d7m09 if decena==7;
replace edba_nm=edba_nm/d7m10 if decena==8;
replace edba_nm=edba_nm/d7m10 if decena==9;

*Gasto en Cuidado personal deflactado (mensual);

gen cuip_nm=gasnomon if (clave>="D001" & clave<="D026") | 
(clave=="H132");

replace cuip_nm=cuip_nm/d23m07 if decena==0;
replace cuip_nm=cuip_nm/d23m07 if decena==1;
replace cuip_nm=cuip_nm/d23m08 if decena==2;
replace cuip_nm=cuip_nm/d23m08 if decena==3;
replace cuip_nm=cuip_nm/d23m08 if decena==4;
replace cuip_nm=cuip_nm/d23m09 if decena==5;
replace cuip_nm=cuip_nm/d23m09 if decena==6;
replace cuip_nm=cuip_nm/d23m09 if decena==7;
replace cuip_nm=cuip_nm/d23m10 if decena==8;
replace cuip_nm=cuip_nm/d23m10 if decena==9;

*Gasto en Accesorios personales deflactado (trimestral);

gen accp_nm=gasnomon if (clave>="H123" & clave<="H131") | 
(clave=="H133");

replace accp_nm=accp_nm/d23t05 if decena==0;
replace accp_nm=accp_nm/d23t05 if decena==1;
replace accp_nm=accp_nm/d23t06 if decena==2;
replace accp_nm=accp_nm/d23t06 if decena==3;
replace accp_nm=accp_nm/d23t06 if decena==4;
replace accp_nm=accp_nm/d23t07 if decena==5;
replace accp_nm=accp_nm/d23t07 if decena==6;
replace accp_nm=accp_nm/d23t07 if decena==7;
replace accp_nm=accp_nm/d23t08 if decena==8;
replace accp_nm=accp_nm/d23t08 if decena==9;

*Gasto en Otros gastos y transferencias deflactado (semestral);

gen otr_nm=gasnomon if (clave>="N001" & clave<="N002") | 
(clave>="N006" & clave<="N016") | (clave>="T901" & 
clave<="T914");

replace otr_nm=otr_nm/dINPCs02 if decena==0;
replace otr_nm=otr_nm/dINPCs02 if decena==1;
replace otr_nm=otr_nm/dINPCs03 if decena==2;
replace otr_nm=otr_nm/dINPCs03 if decena==3;
replace otr_nm=otr_nm/dINPCs03 if decena==4;
replace otr_nm=otr_nm/dINPCs04 if decena==5;
replace otr_nm=otr_nm/dINPCs04 if decena==6;
replace otr_nm=otr_nm/dINPCs04 if decena==7;
replace otr_nm=otr_nm/dINPCs05 if decena==8;
replace otr_nm=otr_nm/dINPCs05 if decena==9;

*Gasto en Regalos Otorgados deflactado;

gen reda_nm=gasnomon if (clave>="T901" & clave<="T914") | (clave=="N013");

replace reda_nm=reda_nm/dINPCs02 if decena==1;
replace reda_nm=reda_nm/dINPCs03 if decena==2;
replace reda_nm=reda_nm/dINPCs03 if decena==3;
replace reda_nm=reda_nm/dINPCs03 if decena==4;
replace reda_nm=reda_nm/dINPCs04 if decena==5;
replace reda_nm=reda_nm/dINPCs04 if decena==6;
replace reda_nm=reda_nm/dINPCs04 if decena==7;
replace reda_nm=reda_nm/dINPCs05 if decena==8;
replace reda_nm=reda_nm/dINPCs05 if decena==9;

save "$bases\ingresonomonetario_def08.dta", replace;

use "$bases\ingresonomonetario_def08.dta", clear;

*Construcción de la base de pagos en especie a partir de la base 
de gasto no monetario;

keep if esp==1;

collapse (sum) *_nm, by(proyecto folioviv foliohog);

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

sort proyecto folioviv foliohog;

save "$bases\esp_def08.dta", replace;

use "$bases\ingresonomonetario_def08.dta", clear;

*Construcción de base de regalos a partir de la base no 
monetaria ;

keep if reg==1;

collapse (sum) *_nm, by(proyecto folioviv foliohog);

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

sort proyecto folioviv foliohog;

save "$bases\reg_def08.dta", replace;

*********************************************************
Construcción del ingreso corriente total
*********************************************************;

use "$data\Concen.dta", clear;
rename estrato tam_loc;
keep proyecto folioviv foliohog tam_loc factor tam_hog est_dis upm ubica_geo;

*Incorporación de la base de ingreso monetario deflactado;

sort proyecto folioviv foliohog;

merge proyecto folioviv foliohog using "$bases\ingreso_deflactado08.dta";
tab _merge;
drop _merge;

*Incorporación de la base de ingreso no monetario deflactado: pago en especie;

sort proyecto folioviv foliohog;

merge proyecto folioviv foliohog using "$bases\esp_def08.dta";
tab _merge;
drop _merge;

*Incorporación de la base de ingreso no monetario deflactado: regalos en especie;

sort proyecto folioviv foliohog;

merge proyecto folioviv foliohog using "$bases\reg_def08.dta";
tab _merge;
drop _merge;

gen rururb=1 if tam_loc==4;
replace rururb=0 if tam_loc<=3;
label define rururb 1 "Rural" 
                    0 "Urbano";
label value rururb rururb;

egen double pago_esp=rsum(ali_nme alta_nme veca_nme 
viv_nme lim_nme ens_nme cris_nme sal_nme 
tpub_nme tfor_nme com_nme edre_nme cuip_nme 
accp_nme otr_nme);

egen double reg_esp=rsum(ali_nmr alta_nmr veca_nmr 
viv_nmr lim_nmr ens_nmr cris_nmr sal_nmr 
tpub_nmr tfor_nmr com_nmr edre_nmr cuip_nmr 
accp_nmr otr_nmr);

egen double nomon=rsum(pago_esp reg_esp);

egen double ict=rsum(ing_mon nomon);

label var ict "Ingreso corriente total";
label var nomon "Ingreso corriente no monetario";
label var pago_esp "Ingreso corriente no monetario pago especie";
label var reg_esp "Ingreso corriente no monetario regalos especie";

sort proyecto folioviv foliohog;

save "$bases\ingresotot08.dta", replace;

***********************************************************
Construcción del tamaño de hogar con economías de escala
y escalas de equivalencia
***********************************************************;

use "$data\Pobla08.dta", clear;
*Población objeto: no se incluye a huéspedes ni trabajadores domésticos;

drop if parentesco>=400 & parentesco <500;
drop if parentesco>=700 & parentesco <800;

*Total de integrantes del hogar;
gen ind=1;
egen tot_ind=sum(ind), by (proyecto folioviv foliohog);

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
recode n_05 (.=0) if edad!=.;

gen tamhogesc=n_05*.7031;
replace tamhogesc=n_6_12*.7382 if n_6_12==1;
replace tamhogesc=n_13_18*.7057 if n_13_18==1;
replace tamhogesc=n_19*.9945 if n_19==1 ;
replace tamhogesc=1 if tot_ind==1;

collapse (sum)  tamhogesc, by(proyecto folioviv foliohog);

sort proyecto folioviv foliohog;

save "$bases\tamhogesc08.dta", replace;

*******************************************************
Bienestar por ingresos
*******************************************************;

use "$bases\ingresotot08.dta", clear;

*Incorporación de la información sobre el tamaño del hogar ajustado;

merge proyecto folioviv foliohog using "$bases\tamhogesc08.dta";
tab _merge;
drop _merge;

*Información per capita;

gen double ictpc= ict/tamhogesc;

label var  ictpc "Ingreso corriente total per cápita";

**********************************************
Indicador de Bienestar por ingresos
**********************************************

LP I: Valor de la canasta para bienestar mínimo

LP II: Valor de la canasta alimentaria más el valor de la canasta
no alimentaria (ver Anexo A del documento metodológico)

En este programa se construyen los indicadores de bienestar por ingresos
mediante las 2 líneas definidas por CONEVAL , denominándoles:

lp1 : Línea de Bienestar Mínimo
lp2 : Línea de Bienestar

**********************************************;
*Bienestar mínimo;

*Valor de la canasta básica;

scalar lp1_urb = 874.63;
scalar lp1_rur = 613.80;

*Se identifica a los hogares bajo LP1;

gen  plb_m=1 if ictpc<lp1_urb & rururb==0;
replace plb_m=0 if ictpc>=lp1_urb & rururb==0 & ictpc!=.;
replace plb_m=1 if ictpc<lp1_rur & rururb==1;
replace plb_m=0 if ictpc>=lp1_rur & rururb==1 & ictpc!=.;

*Bienestar;

scalar lp2_urb = 1921.74;
scalar lp2_rur = 1202.80;

gen  plb=1 if (ictpc<lp2_urb & rururb==0);
replace plb=0 if (ictpc>=lp2_urb & rururb==0) & ictpc!=.;

replace plb=1 if (ictpc<lp2_rur & rururb==1);
replace plb=0 if (ictpc>=lp2_rur & rururb==1) & ictpc!=.;

label var factor "Factor de expansión";
label var tam_loc "Tamaño de la localidad";
label var rururb "Identificador de localidades rurales";
label var tam_hog "Total de integrantes del hogar";
label var tamhogesc "Tamaño de hogar ajustado";
label var ict "Ingreso corriente total del hogar";
label var ictpc "Ingreso corriente total per cápita";
label var plb_m "Población con ingreso menor a la línea de bienestar mínimo";
label var plb "Población con ingreso menor a la línea de bienestar";

keep proyecto folioviv foliohog factor tam_loc
rururb tamhogesc ict ictpc plb_m plb est_dis upm ubica_geo tam_hog 
ing_mon ing_lab ing_ren ing_tra nomon pago_esp reg_esp;  

sort proyecto folioviv foliohog;

save "$bases\p_ingresos08.dta", replace;

*********************************************************
Parte VIII Pobreza 
*********************************************************;

**************************
Integración de las bases*
*************************;

use "$bases\ic_rezedu08.dta", clear;

merge proyecto folioviv foliohog numren using "$bases\ic_asalud08.dta";
tab _merge;
drop _merge;
sort proyecto folioviv foliohog numren;

merge proyecto folioviv foliohog numren using "$bases\ic_segsoc08.dta";
tab _merge;
drop _merge;
sort proyecto folioviv foliohog;

merge proyecto folioviv foliohog using "$bases\ic_cev08.dta";
tab _merge;
drop _merge;
sort proyecto folioviv foliohog;

merge proyecto folioviv foliohog using "$bases\ic_sbv08.dta";
tab _merge;
drop _merge;
sort proyecto folioviv foliohog;

merge proyecto folioviv foliohog using "$bases\ic_ali08.dta";
tab _merge;
drop _merge;
sort proyecto folioviv foliohog;

merge proyecto folioviv foliohog using "$bases\p_ingresos08.dta";
tab _merge;
drop _merge;

duplicates drop proyecto folioviv foliohog numren, force;

gen ent=real(substr(folioviv,1,2));

recode ing_* (.=0) if ictpc!=0 | ing_mon==.;

label var ent "Identificador de la entidad federativa";

label define ent 
1	"Aguascalientes"
2	"Baja California"
3	"Baja California Sur"
4	"Campeche"
5	"Coahuila"
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
16	"Michoacán"
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
30	"Veracruz"
31	"Yucatán"
32	"Zacatecas";
label value ent ent;

****************************
*Índice de Privación Social
****************************;

egen i_privacion=rsum(ic_rezedu ic_asalud ic_segsoc ic_cv ic_sbv ic_ali);
replace i_privacion=. if ic_rezedu==. | ic_asalud==. | ic_segsoc==. | 
ic_cv==. | ic_sbv==. | ic_ali==.;

label var i_privacion "Índice de Privación Social";

***************************
*Pobreza 
***************************;

*Pobreza;
gen pobreza=1 if plb==1 & (i_privacion>=1 & i_privacion!=.);
replace pobreza=0 if (plb==0 | i_privacion==0) & (plb!=. & i_privacion!=.);
label var pobreza "Pobreza";
label define pobreza 0 "No pobre" 
                     1 "Pobre";
label value pobreza pobreza;

*Pobreza extrema;
gen pobreza_e=1 if plb_m==1 & (i_privacion>=3 & i_privacion!=.);
replace pobreza_e=0 if (plb_m==0 | i_privacion<3) & (plb_m!=. & i_privacion!=.);
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
gen vul_car=cond(plb==0 & (i_privacion>=1 & i_privacion!=.),1,0);
replace vul_car=. if pobreza==.;
label var vul_car "Población vulnerable por carencias";
label define vul 0 "No vulnerable" 
                     1 "Vulnerable";
label value vul_car vul;

*Vulnerables por ingresos;
gen vul_ing=cond(plb==1 & i_privacion==0,1,0);
replace vul_ing=. if pobreza==.;
label var vul_ing "Población vulnerable por ingresos";
label value vul_ing vul;

****************************************************
*Población no pobre y no vulnerable
****************************************************;

gen no_pobv=cond(plb==0 & i_privacion==0,1,0);
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
label define carencias  0 "Población sin carencias" 
						1 "Población con carencias";
label value carencias carencias;

gen carencias3=cond(i_privacion>=3 & i_privacion!=.,1,0);
replace carencias3=. if pobreza==.;
label var carencias3 "Población con tres o más carencias";
label define carencias3 0 "Población con menos de tres carencias" 
						1 "Población con tres o más carencias";
label value carencias3 carencias3;

************
*Cuadrantes
************;

gen cuadrantes=.;
replace cuadrantes=1 if plb==1 & (i_privacion>=1 & i_privacion!=.);
replace cuadrantes=2 if plb==0 & (i_privacion>=1 & i_privacion!=.);
replace cuadrantes=3 if plb==1 & i_privacion==0;
replace cuadrantes=4 if plb==0 & i_privacion==0;
label var cuadrantes "Cuadrantes de Bienestar y Derechos sociales";
label define cuadrantes 1 "Pobres"
						2 "Vulnerables por carencias" 
						3 "Vulnerables por ingresos"
						4 "No pobres y no vulnerables";
label value cuadrantes cuadrantes;

*****************************************
*Profundidad en el espacio del bienestar
*****************************************;

*FGT (a=1);

*Distancia normalizada del ingreso respecto a la línea de bienestar;
gen prof_b1=(lp2_rur-ictpc)/(lp2_rur) if rururb==1 & plb==1;
replace prof_b1=(lp2_urb-ictpc)/(lp2_urb) if rururb==0 & plb==1;
recode prof_b1 (.=0) if ictpc!=.;
label var prof_b1 "Índice FGT con alfa igual a 1 (línea de bienestar)";

*Distancia normalizada del ingreso respecto a la línea de bienestar mínimo;
gen prof_bm1=(lp1_rur-ictpc)/(lp1_rur) if rururb==1 & plb_m==1;
replace prof_bm1=(lp1_urb-ictpc)/(lp1_urb) if rururb==0 & plb_m==1;
recode prof_bm1 (.=0) if ictpc!=.;
label var prof_bm1 "Índice FGT con alfa igual a 1 (línea de bienestar mínimo)";

*FGT (a=2);

*Distancia normalizada del ingreso respecto a la línea de bienestar;
gen prof_b2=[(lp2_rur-ictpc)/(lp2_rur)]^2 if rururb==1 & plb==1;
replace prof_b2=[(lp2_urb-ictpc)/(lp2_urb)]^2 if rururb==0 & plb==1;
recode prof_b2 (.=0) if ictpc!=.;
label var prof_b2 "Indice FGT con alfa igual a 2 (linea de bienestar)";

*Distancia normalizada del ingreso respecto a la línea de bienestar mínimo;
gen prof_bm2=[(lp1_rur-ictpc)/(lp1_rur)]^2 if rururb==1 & plb_m==1;
replace prof_bm2=[(lp1_urb-ictpc)/(lp1_urb)]^2 if rururb==0 & plb_m==1;
recode prof_bm2 (.=0) if ictpc!=.;
label var prof_bm2 "Indice FGT con alfa igual a 2 (linea de bienestar minimo)";

************************************
*Profundidad de la privación social
************************************;

gen profun=i_privacion/6;
label var profun "Profundidad de la privación social";

***********************************
*Intensidad de la privación social
***********************************;

*Población pobre;
gen int_pob=profun*pobreza;
label var int_pob "Intensidad de la privación social: pobres";

*Población pobre extrema;
gen int_pobe=profun*pobreza_e;
label var int_pobe "Intensidad de la privación social: pobres extremos";

*Población vulnerable por carencias;
gen int_vulcar=profun*vul_car;
label var int_vulcar "Intensidad de la privación social: población vulnerable por carencias";

*Población carenciada;
gen int_caren=profun*carencias;
label var int_caren "Intensidad de la privación social: población carenciada";

keep proyecto folioviv foliohog numren factor tam_loc rururb ent ubica_geo 
edad sexo tamhogesc parentesco ic_rezedu anac_e inas_esc niv_ed a_educ alfabe 
asis_esc nivel grado nivelaprob gradoaprob ic_asalud serv_sal ic_segsoc segsoc 
ss_aa ss_mm ss_dir pea par jef_ss cony_ss hijo_ss s_salud pam ing_pens ing_pam 
ing_65mas sesentaycinco_mas ing_pam_otros ic_cv icv_pisos icv_muros icv_techos 
icv_hac clase_hog p65mas ocupados percep_ing perc_ocupa transfer remesas transf_hog 
ic_sbv isb_agua isb_dren isb_luz isb_combus ic_ali id_men tot_iaad tot_iamen ins_ali 
plb_m plb ictpc est_dis upm i_privacion pobreza pobreza_e pobreza_m  vul_car 
vul_ing no_pobv carencias carencias3 cuadrantes prof_b1 prof_bm1 prof_b2 prof_bm2 
profun int_pob int_pobe int_vulcar int_caren ict ing_mon ing_lab ing_ren ing_tra 
nomon pago_esp reg_esp hli discap edocony;
		
label var sexo "Sexo";
label var parentesco "Parentesco con el jefe del hogar";
label var est_dis "Estrato de diseño";
label var upm "Unidad primaria de muestreo";
label var ubica_geo "Ubicación geográfica";

sort proyecto folioviv foliohog numren;

save "$bases\pobreza_08.dta", replace;

*=====================================================================*
* Year of sample
*=====================================================================*;
gen year=2008;
label var year "Year of sample";

order proyecto folioviv foliohog numren year factor tam_loc rururb ent ubica_geo 
edad sexo tamhogesc parentesco ic_rezedu anac_e inas_esc niv_ed a_educ alfabe 
asis_esc nivel grado nivelaprob gradoaprob ic_asalud serv_sal ic_segsoc segsoc 
ss_aa ss_mm ss_dir pea par jef_ss cony_ss hijo_ss s_salud pam ing_pens ing_pam 
ing_65mas sesentaycinco_mas ing_pam_otros ic_cv icv_pisos icv_muros icv_techos 
icv_hac clase_hog p65mas ocupados percep_ing perc_ocupa transfer remesas transf_hog 
ic_sbv isb_agua isb_dren isb_luz isb_combus ic_ali id_men tot_iaad tot_iamen ins_ali 
plb_m plb ictpc est_dis upm i_privacion pobreza pobreza_e pobreza_m  vul_car 
vul_ing no_pobv carencias carencias3 cuadrantes prof_b1 prof_bm1 prof_b2 prof_bm2 
profun int_pob int_pobe int_vulcar int_caren ict ing_mon ing_lab ing_ren ing_tra 
nomon pago_esp reg_esp hli discap;	

sort proyecto folioviv foliohog numren;

destring edocony, replace;
recode edocony (2=7);
recode edocony (3=2);
recode edocony (4=3);
recode edocony (5=4);
recode edocony (6=5);		
recode edocony (7=6);		
tostring edocony, replace;

destring tam_loc, replace;		
label define tam_loc 

1 "Localities with 100,000 and more inhabitants"
2 "Localities with 15,000 and 99,999 inhabitants"
3 "Localities with 2,500 and 14,999 inhabitants"
4 "Localities with less than 2,500 inhabitants";
		
label value tam_loc tam_loc;	

*Tiempo total (meses) que contribuyo a la seguridad social*; 
gen cont_ss=.;
label var cont_ss "contribucion total a la SS en meses";
replace cont_ss=ss_mm if ss_aa==0;
replace cont_ss=ss_mm + ss_aa*12 if ss_aa!=0;
replace cont_ss=. if ss_mm==. & ss_aa==.;
		
sort proyecto folioviv foliohog numren;		

save "$bases\65 y mas_2008.dta", replace;

use "$data\hogares.dta", clear;
rename ten27 tenencia;
keep proyecto folioviv tenencia;
sort proyecto folioviv;
merge m:m proyecto folioviv using "$bases\65 y mas_2008.dta";
drop _merge;
save "$bases\65 y mas_2008.dta", replace;

use "$data\Trabajos.dta", clear;
keep proyecto folioviv foliohog numren htrab;
sort proyecto folioviv foliohog numren;
merge m:m proyecto folioviv foliohog numren using "$bases\65 y mas_2008.dta";
drop _merge;
save "$bases\65 y mas_2008.dta", replace;

log close;
