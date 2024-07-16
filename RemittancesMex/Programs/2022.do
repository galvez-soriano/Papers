#delimit;
clear;
cap clear;
cap log close;
scalar drop _all;
set mem 1200m;
set more off;

* This program was originally run with Stata 18. The databases should have 
* format *.dta

* This particular program uses the following databases:

*Population: poblacion.dta
*Work: trabajos.dta
*Income: ingresos.dta
*Households: viviendas.dta
*Households SD: hogares.dta
*Households summary: concentradohogar.dta
*Non-monetary income: gastoshogar.dta
*Monetary income: gastospersona.dta

* To run this program you should change the path in the following globals (gl); 

gl data="C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Data\2022\OData";
gl bases="C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Data\2022\Bases";
gl log="C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Data\2022\Log";

log using "$log\Pobreza_22.txt", text replace;
*=====================================================================*
/* Individuals sociodemographic characteristics */;
*=====================================================================*;
use "$data\poblacion.dta", clear;

*Población objetivo: no se incluye a huéspedes ni trabajadores domésticos;
drop if parentesco>="400" & parentesco <"500";
drop if parentesco>="700" & parentesco <"800";

*Año de nacimiento;
gen anac_e=.;
replace anac_e=2022-edad if edad!=.;

label var edad "Edad reportada al momento de la entrevista";
label var anac_e "Año de nacimiento";

*Asistencia escolar (se reporta para personas de 3 años o más);
gen student=asis_esc=="1";

label var student "Enrolled in school";
label define student 0 "No" 1 "Yes";
label value student student;

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
				
gen educ=.;
*No education;
replace educ=0 if (nivelaprob==0);
replace educ=0 if (nivelaprob==1 );
*Elementary school;
replace educ=gradoaprob if nivelaprob==2;
*Middle-school;
replace educ=6+gradoaprob if nivelaprob==3;
*Preparatoria;
replace educ=9+gradoaprob if nivelaprob==4;
*Normal, Carrera tecnica o profesional;
replace educ=12+gradoaprob if nivelaprob==5 | nivelaprob==6 | nivelaprob==7;
*Maestria;
replace educ=16+gradoaprob if nivelaprob==8;
*Doctorado;
replace educ=18+gradoaprob if nivelaprob==9;
label var educ "Years of education";

* Indigenous language speaker;
gen hli=.;
replace hli=1 if hablaind=="1" & edad>=3;
replace hli=0 if hablaind=="2" & edad>=3;

label var hli "Indigenous language speaker";
label define hli 0 "Does not speak IL"
                 1 "Speaks IL";
label value hli hli;

* Use of time;

destring hor_* min_*, replace;
gen time_work=hor_1+(min_1/60);
replace time_work=0 if time_work==.;
gen time_study=hor_2+(min_2/60);
replace time_study=0 if time_study==.;
gen time_repair=hor_5+(min_5/60);
replace time_repair=0 if time_repair==.;
gen time_leisure=hor_8+(min_8/60);
replace time_leisure=0 if time_leisure==.;

keep folioviv foliohog numren edad anac_e student niv_ed  
parentesco hli educ time_work time_study time_repair time_leisure;
sort folioviv foliohog numren;

save "$bases\ic_rezedu22.dta", replace;

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
save "$bases\ocupados22.dta", replace;

use "$data\poblacion.dta", clear;

*Población objetivo: no se incluye a huéspedes ni trabajadores domésticos;
drop if parentesco>="400" & parentesco <"500";
drop if parentesco>="700" & parentesco <"800";

sort folioviv foliohog numren;
merge folioviv foliohog numren using "$bases\ocupados22.dta";
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
label define cuenta 0 "No cuenta" 1 "Sí cuenta";
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

gen s_salud=.;
replace s_salud=1 if atemed=="1" & (inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4") 
					 & (inscr_3=="3" | inscr_4=="4" | inscr_6=="6" | inscr_7=="7");
recode s_salud (.=0) if pop_insabi!=" " & atemed!=" ";

label var s_salud "Servicios médicos por otros núcleos familiares o por contratación propia";
label value s_salud cuenta;

keep folioviv foliohog numren sexo sa_* *_sa pop_insabi atemed inst_* inscr_* 
segvol_*;
sort folioviv foliohog numren;
save "$bases\ic_asalud22.dta", replace;

*********************************************************;
use "$data\trabajos.dta", clear;

keep if id_trabajo=="1";
gen formal=pres_26==" ";
replace formal=0 if (pres_7=="1" | pres_9=="1" | pres_12=="1" | pres_13=="1"
| pres_16=="1" | pres_19=="1" | pres_21=="1" | pres_22=="1" | pres_25=="1") 
& (pres_1!="1" & pres_2!="1" & pres_3!="1" & pres_4!="1" & pres_5!="1" & 
pres_6!="1" & pres_14!="1");

keep folioviv foliohog numren formal htrab sinco scian;
sort folioviv foliohog numren;
save "$bases\labor.dta", replace;

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

*Ahorro para el retiro o pensión para la vejez (SAR, Afore);
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
save "$bases\prestaciones22.dta", replace;

*Ingresos por jubilaciones, pensiones y programas de adultos mayores;
use "$data\ingresos.dta", clear;

keep if clave=="P032" | clave=="P033" | clave=="P104" | clave=="P045" ;

*Se deflactan los ingresos por jubilaciones, pensiones y programas de adultos 
mayores de acuerdo con el mes de levantamiento;
scalar	dic21 = 0.9475376203;
scalar	ene22 = 0.9531433002;
scalar	feb22 = 0.9610510246;
scalar	mar22 = 0.9705661414;
scalar	abr22 = 0.9758164180;
scalar	may22 = 0.9775368933;
scalar	jun22 = 0.9857919437;
scalar	jul22 = 0.9930938669;
scalar	ago22 = 1.0000000000;
scalar	sep22 = 1.0062034038;
scalar	oct22 = 1.0118979346;
scalar	nov22 = 1.0177217030;
scalar	dic22 = 1.0216069077;

destring mes_*, replace;
replace ing_6=ing_6/feb22 if mes_6==2;
replace ing_6=ing_6/mar22 if mes_6==3;
replace ing_6=ing_6/abr22 if mes_6==4;
replace ing_6=ing_6/may22 if mes_6==5;

replace ing_5=ing_5/mar22 if mes_5==3;
replace ing_5=ing_5/abr22 if mes_5==4;
replace ing_5=ing_5/may22 if mes_5==5;
replace ing_5=ing_5/jun22 if mes_5==6;

replace ing_4=ing_4/abr22 if mes_4==4;
replace ing_4=ing_4/may22 if mes_4==5;
replace ing_4=ing_4/jun22 if mes_4==6;
replace ing_4=ing_4/jul22 if mes_4==7;

replace ing_3=ing_3/may22 if mes_3==5;
replace ing_3=ing_3/jun22 if mes_3==6;
replace ing_3=ing_3/jul22 if mes_3==7;
replace ing_3=ing_3/ago22 if mes_3==8;

replace ing_2=ing_2/jun22 if mes_2==6;
replace ing_2=ing_2/jul22 if mes_2==7;
replace ing_2=ing_2/ago22 if mes_2==8;
replace ing_2=ing_2/sep22 if mes_2==9;

replace ing_1=ing_1/jul22 if mes_1==7;
replace ing_1=ing_1/ago22 if mes_1==8;
replace ing_1=ing_1/sep22 if mes_1==9;
replace ing_1=ing_1/oct22 if mes_1==10;

egen ing_pens=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6) 
			  if clave=="P032" | clave=="P033";
egen ing_pam=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6) 
              if clave=="P104" | clave=="P045";
recode ing_pens ing_pam (.=0);

collapse (sum) ing_pens ing_pam, by(folioviv foliohog numren);

label var ing_pens "Ingreso promedio mensual por jubilaciones y pensiones";
label var ing_pam "Ingreso promedio mensual por programas de adultos mayores";

sort  folioviv foliohog numren;
save "$bases\pensiones22.dta", replace;

*Construcción del indicador;
use "$data\poblacion.dta", clear;

*Población objetivo: no se incluye a huéspedes ni trabajadores domésticos;
drop if parentesco>="400" & parentesco <"500";
drop if parentesco>="700" & parentesco <"800";

*Integración de bases;
sort  folioviv foliohog numren;
merge  folioviv foliohog numren using "$bases\prestaciones22.dta";
tab _merge;
drop _merge;

sort  folioviv foliohog numren;
merge  folioviv foliohog numren using "$bases\pensiones22.dta";
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
la vejez (SAR o Afore);

*Servicios médicos;
gen smcv=.;
replace smcv=1 if atemed=="1" & (inst_1=="1" | inst_2=="2" | inst_3=="3" | inst_4=="4") 
				  & (inscr_6=="6") & (edad>=12 & edad!=.);
recode smcv (.=0) if (edad>=12 & edad!=.);

label var smcv "Servicios médicos por contratación voluntaria";
label value smcv cuenta;

*Ahorro para el retiro o pensión para la vejez (SAR o Afore);
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

gen s_salud=.;
replace s_salud=1 if atemed=="1" & (inst_1=="1" | inst_2=="2" | inst_3=="3" |
					 inst_4=="4") & (inscr_3=="3" | inscr_4=="4" | inscr_6=="6" 
					 | inscr_7=="7");
					 
recode s_salud (.=0) if pop_insabi!=" " & atemed!=" ";

label var s_salud "Servicios médicos por otros núcleos familiares o por contratación propia";
label value s_salud cuenta;

*Programas sociales de pensiones para adultos mayores;

*Valor monetario de las líneas de pobreza extrema por ingresos rural y urbana;
scalar	lp1_urb	= 2086.21;
scalar	lp1_rur = 1600.18;

scalar lp_pam = (lp1_urb + lp1_rur)/2;

gen pam=.;
replace pam=1 if (edad>=65 & edad!=.) & ing_pam>=lp_pam & ing_pam!=.;

recode pam (.=0) if (edad>=65 & edad!=.) ;

label var pam "Social Pension Program (PAM)";
label define pam 0 "No" 
                 1 "Yes";
label value pam pam;

keep folioviv foliohog numren tipo_trab* aforlab* smlab*
		   smcv aforecv pea jub ss_dir par jef_ss cony_ss hijo_ss s_salud 
		   pam ing_pam;
sort folioviv foliohog numren;
save "$bases\ic_segsoc22.dta", replace;

*Remittances;

use "$data\concentradohogar.dta", clear;
keep  folioviv foliohog remesas;
sort  folioviv foliohog;
save "$bases\remittances.dta", replace;

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

*Definición de los deflactores 2022 ;

scalar	dic21 = 0.9475376203 ;
scalar	ene22 = 0.9531433002 ;
scalar	feb22 = 0.9610510246 ;
scalar	mar22 = 0.9705661414 ;
scalar	abr22 = 0.9758164180 ;
scalar	may22 = 0.9775368933 ;
scalar	jun22 = 0.9857919437 ;
scalar	jul22 = 0.9930938669 ;
scalar	ago22 = 1.0000000000 ;
scalar	sep22 = 1.0062034038 ;
scalar	oct22 = 1.0118979346 ;
scalar	nov22 = 1.0177217030 ;
scalar	dic22 = 1.0216069077 ;

destring mes_*, replace;
replace ing_6=ing_6/feb22 if mes_6==2;
replace ing_6=ing_6/mar22 if mes_6==3;
replace ing_6=ing_6/abr22 if mes_6==4;
replace ing_6=ing_6/may22 if mes_6==5;

replace ing_5=ing_5/mar22 if mes_5==3;
replace ing_5=ing_5/abr22 if mes_5==4;
replace ing_5=ing_5/may22 if mes_5==5;
replace ing_5=ing_5/jun22 if mes_5==6;

replace ing_4=ing_4/abr22 if mes_4==4;
replace ing_4=ing_4/may22 if mes_4==5;
replace ing_4=ing_4/jun22 if mes_4==6;
replace ing_4=ing_4/jul22 if mes_4==7;

replace ing_3=ing_3/may22 if mes_3==5;
replace ing_3=ing_3/jun22 if mes_3==6;
replace ing_3=ing_3/jul22 if mes_3==7;
replace ing_3=ing_3/ago22 if mes_3==8;

replace ing_2=ing_2/jun22 if mes_2==6;
replace ing_2=ing_2/jul22 if mes_2==7;
replace ing_2=ing_2/ago22 if mes_2==8;
replace ing_2=ing_2/sep22 if mes_2==9;

replace ing_1=ing_1/jul22 if mes_1==7;
replace ing_1=ing_1/ago22 if mes_1==8;
replace ing_1=ing_1/sep22 if mes_1==9;
replace ing_1=ing_1/oct22 if mes_1==10;

replace ing_1=(ing_1/may22)/12 if clave=="P008" | clave=="P015";
replace ing_1=(ing_1/dic21)/12 if clave=="P009" | clave=="P016";

recode ing_2 ing_3 ing_4 ing_5 ing_6 (0=.) if clave=="P008" | clave=="P009" |
											  clave=="P015" | clave=="P016";

egen double ing_mens=rmean(ing_1 ing_2 ing_3 ing_4 ing_5 ing_6);

gen double ing_mon=ing_mens if (clave>="P001" & clave<="P009") | (clave>="P011" & clave<="P016") 
                             | (clave>="P018" & clave<="P048") | (clave>="P067" & clave<="P081") 
			     | (clave>="P101" & clave<="P108");
*Para obtener el ingreso laboral, se seleccionan 
las claves de ingreso correspondientes;
gen double ing_lab=ing_mens if (clave>="P001" & clave<="P009") | (clave>="P011" & clave<="P016") 
                             | (clave>="P018" & clave<="P022") | (clave>="P067" & clave<="P081");

*Para obtener el ingreso por rentas, se seleccionan 
las claves de ingreso correspondientes;
gen double ing_ren=ing_mens if (clave>="P023" & clave<="P031");

*Para obtener el ingreso por transferencias, se seleccionan 
las claves de ingreso correspondientes;
gen double ing_tra=ing_mens if (clave>="P032" & clave<="P048") | (clave>="P101" & clave<="P108"); 

*Se estima el total de ingresos de cada hogar;
collapse (sum) ing_mon ing_lab ing_ren ing_tra, by( folioviv foliohog);

label var ing_mon "Ingreso corriente monetario del hogar";
label var ing_lab "Ingreso corriente monetario laboral";
label var ing_ren "Ingreso corriente monetario por rentas";
label var ing_tra "Ingreso corriente monetario por transferencias";
							 
sort folioviv foliohog;
save "$bases\ingreso_deflactado22.dta", replace;

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

gen decena=real(substr(folioviv,8,1));

*Definición de los deflactores;		
		
*Rubro 1.1 semanal, Alimentos;		
scalar d11w07 =	0.9869825057 ;
scalar d11w08 =	1.0000000000 ;
scalar d11w09 =	1.0130754464 ;
scalar d11w10 =	1.0178275200 ;
scalar d11w11 =	1.0207468579 ;

*Rubro 1.2 semanal, Bebidas alcohólicas y tabaco;		
scalar d12w07 =	0.9923340135 ;
scalar d12w08 =	1.0000000000 ;
scalar d12w09 =	1.0035071112 ;
scalar d12w10 =	1.0111808568 ;
scalar d12w11 =	1.0131982216 ;

*Rubro 2 trimestral, Vestido, calzado y accesorios;		
scalar d2t05 = 0.9899050815 ;
scalar d2t06 = 0.9941003723 ;
scalar d2t07 = 0.9997465345 ;
scalar d2t08 = 1.0083352270 ;

*Rubro 3 mensual, viviendas;		
scalar d3m07 = 0.9998142481 ;
scalar d3m08 = 1.0000000000 ;
scalar d3m09 = 0.9978682753 ;
scalar d3m10 = 1.0031577830 ;
scalar d3m11 = 1.0197073965 ;

*Rubro 4.2 mensual, Accesorios y artículos de limpieza para el hogar;		
scalar d42m07=	0.9894769136;
scalar d42m08=	1.0000000000;
scalar d42m09=	1.0086286240;
scalar d42m10=	1.0182083142;
scalar d42m11=	1.0237613131;
	
*Rubro 4.2 trimestral, Accesorios y artículos de limpieza para el hogar;		
scalar d42t05=	0.9787953163;
scalar d42t06=	0.9897197934;
scalar d42t07=	0.9993685126;
scalar d42t08=	1.0089456461;
		
*Rubro 4.1 semestral, Muebles y aparatos domésticos;		
scalar d41s02=	1.0003069312;
scalar d41s03=	0.9993861376;
scalar d41s04=	0.9992122603;
scalar d41s05=	0.9991442214;
		
*Rubro 5.1 trimestral, Salud;		
scalar d51t05=	0.9909917367;
scalar d51t06=	0.9954834527;
scalar d51t07=	0.9994564693;
scalar d51t08=	1.0030487384;
		
*Rubro 6.1.1 semanal, Transporte público urbano;		
scalar d611w07=	0.9963207274;
scalar d611w08=	1.0000000000;
scalar d611w09=	1.0034865488;
scalar d611w10=	1.0052385833;
scalar d611w11=	1.0064912880;
		
*Rubro 6 mensual, Transporte;		
scalar d6m07=	0.9987845893;
scalar d6m08=	1.0000000000;
scalar d6m09=	1.0001664946;
scalar d6m10=	1.0057274150;
scalar d6m11=	1.0076837268;
		
*Rubro 6 semestral, Transporte;		
scalar d6s02=	0.9808628306;
scalar d6s03=	0.9879901879;
scalar d6s04=	0.9927380596;
scalar d6s05=	0.9969378864;

*Rubro 7 mensual, Educación y esparcimiento;		
scalar d7m07=	0.9961413091;
scalar d7m08=	1.0000000000;
scalar d7m09=	1.0095233900;
scalar d7m10=	1.0144128271;
scalar d7m11=	1.0174522069;
		
*Rubro 2.3 mensual, Accesorios y cuidados del vestido;		
scalar d23m07=	0.9952443607;
scalar d23m08=	1.0000000000;
scalar d23m09=	1.0081869233;
scalar d23m10=	1.0108184343;
scalar d23m11=	1.0072323555;
		
*Rubro 2.3 trimestral, Accesorios y cuidados del vestido;		
scalar d23t05=	0.9914948875;
scalar d23t06=	0.9956428139;
scalar d23t07=	1.0011437613;
scalar d23t08=	1.0063351192;
		
*INPC semestral;		
scalar	dINPCs02 =	0.9773093813;
scalar	dINPCs03 =	0.9838008772;
scalar	dINPCs04 =	0.9897404209;
scalar	dINPCs05 =	0.9957540070;

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

save "$bases\ingresonomonetario_def22.dta", replace;

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
save "$bases\esp_def22.dta", replace;
use "$bases\ingresonomonetario_def22.dta", clear;

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
save "$bases\reg_def22.dta", replace;

*********************************************************;

use "$data\concentradohogar.dta", clear;
keep folioviv foliohog tam_loc factor tot_integ est_dis upm ubica_geo;



*Incorporación de la base de ingreso monetario deflactado;
sort folioviv foliohog;

merge folioviv foliohog using "$bases\ingreso_deflactado22.dta";
tab _merge;
drop _merge;

*Incorporación de la base de ingreso no monetario deflactado: pago en especie;
sort folioviv foliohog;

merge folioviv foliohog using "$bases\esp_def22.dta";
tab _merge;
drop _merge;

*Incorporación de la base de ingreso no monetario deflactado: regalos en especie;
sort folioviv foliohog;

merge folioviv foliohog using "$bases\reg_def22.dta";
tab _merge;
drop _merge;

gen rururb=1 if tam_loc=="4";
replace rururb=0 if tam_loc<="3";

label define rururb 1 "Rural" 
                    0 "Urban";
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
save "$bases\ingresotot22.dta", replace;

***********************************************************;

use "$data\poblacion.dta", clear;

*Población objetivo: no se incluye a huéspedes ni trabajadores domésticos;
drop if parentesco>="400" & parentesco <"500";
drop if parentesco>="700" & parentesco <"800";

*Total de integrantes del hogar;
gen ind=1;
egen tot_ind=sum(ind), by (folioviv foliohog);

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
save "$bases\tamhogesc22.dta", replace;

*************************************************************************;

use "$bases\ingresotot22.dta", clear;

*Incorporación de la información sobre el tamaño del hogar ajustado;

merge folioviv foliohog using "$bases\tamhogesc22.dta";
tab _merge;
drop _merge;

*Información per cápita;

gen double ictpc= ict/tamhogesc;

label var ictpc "Ingreso corriente total per capita";

*Línea de pobreza extrema por ingresos (LPEI);

*Valor monetario de la canasta alimentaria;

scalar lp1_urb = 2086.21;
scalar lp1_rur = 1600.18;

*Se identifica a los hogares bajo lp1;
gen plp_e=1 if ictpc<lp1_urb & rururb==0;
replace plp_e=0 if ictpc>=lp1_urb & rururb==0 & ictpc!=.;
replace plp_e=1 if ictpc<lp1_rur & rururb==1;
replace plp_e=0 if ictpc>=lp1_rur & rururb==1 & ictpc!=.;

label define plp_e 	0 "Población con ingreso igual o mayor a la LPEI" 
					1 "Población con ingreso inferior a la LPEI";
label value plp_e plp_e;

*Línea de pobreza por ingresos (LPI);

*Valor monetario de la canasta alimentaria más el valor monetario de la canasta no alimentaria;

scalar lp2_urb = 4158.35;
scalar lp2_rur = 2970.76;

*Se identifica a los hogares bajo lp2;
gen plp=1 if (ictpc<lp2_urb & rururb==0);
replace plp=0 if (ictpc>=lp2_urb & rururb==0) & ictpc!=.;
replace plp=1 if (ictpc<lp2_rur & rururb==1);
replace plp=0 if (ictpc>=lp2_rur & rururb==1) & ictpc!=.;

label define plp 	0 "Población con ingreso igual o mayor a la LPI" 
					1 "Población con ingreso inferior a la LPI";
label value plp plp;

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
save "$bases\p_ingresos22.dta", replace;

use "$bases\ic_rezedu22.dta", clear;

merge folioviv foliohog numren using "$bases\ic_asalud22.dta";
tab _merge;
drop _merge;
sort folioviv foliohog numren;

merge folioviv foliohog numren using "$bases\ic_segsoc22.dta";
tab _merge;
drop _merge;
sort folioviv foliohog;

merge folioviv foliohog using "$bases\labor.dta";
tab _merge;
drop _merge;
sort folioviv foliohog;

merge folioviv foliohog using "$bases\remittances.dta";
tab _merge;
drop _merge;
sort folioviv foliohog;

merge folioviv foliohog using "$bases\p_ingresos22.dta";
tab _merge;
drop _merge;

duplicates drop folioviv foliohog numren, force;

gen ent=real(substr(folioviv,1,2));

recode ing_* (.=0) if ictpc!=0 | ing_mon==.;

label define ent 
1	"Aguascalientes"
2	"Baja California"
3	"Baja California Sur"
4	"Campeche"
5	"Coahuila"
6	"Colima"
7	"Chiapas"
8	"Chihuahua"
9	"Ciudad de Mexico"
10	"Durango"
11	"Guanajuato"
12	"Guerrero"
13	"Hidalgo"
14	"Jalisco"
15	"Mexico"
16	"Michoacan"
17	"Morelos"
18	"Nayarit"
19	"Nuevo Leon"
20	"Oaxaca"
21	"Puebla"
22	"Querétaro"
23	"Quintana Roo"
24	"San Luis Potosi"
25	"Sinaloa"
26	"Sonora"
27	"Tabasco"
28	"Tamaulipas"
29	"Tlaxcala"
30	"Veracruz"
31	"Yucatan"
32	"Zacatecas";
label value ent ent;

keep 	folioviv foliohog numren est_dis upm 
		factor tam_loc rururb ent ubica_geo edad sexo parentesco educ
		time_work time_study time_repair time_leisure
		formal htrab sinco scian remesas
		anac_e student 
		pea pam ing_pam
		plp_e plp 
		tamhogesc ictpc ict
		hli;
		
order 	folioviv foliohog numren est_dis upm 
		factor tam_loc rururb ent ubica_geo edad sexo parentesco educ
		time_work time_study time_repair time_leisure
		formal htrab sinco scian remesas
		anac_e student 
		pea pam ing_pam
		plp_e plp 
		tamhogesc ictpc ict
		hli;
			
label var sexo "Female";
label var parentesco "Relatives";
label var est_dis "Sample design";
label var upm "Main sampling unit";
label var ubica_geo "Municipality";

gen year=2022;
label var year "Year"

label var folioviv "House ID";
label var foliohog "Household ID";
label var numren "Individual ID";
rename factor weight;
label var weight "Sample weight";
rename tam_loc loc_size;
label var loc_size "Locality size";
destring loc_size, replace;
label define loc_size 1 "More than 100,000 inhabitants" 
                      2 "Between 15,000 and 99,999 inhabitants"
                      3 "Between 2,500 and 14,999 inhabitants"
                      4 "Less than 2,500 inhabitants";
label value loc_size loc_size;
label var rururb "Rural";
rename ent state;
label var state "ID state";
rename ubica_geo locality_id;
rename edad age;
label var age "Age (years)";
rename sexo female;
destring female, replace ;
recode female (1=0) (2=1);
label define female 1 "Female" 0 "Male";
label value female female;
rename parentesco relatives;
label var time_work "Time spent working";
label var time_study "Time spent studying";
label var time_repair "Time spent repairing home";
label var time_leisure "Leisure time";
label var formal "Has a formal job";
rename htrab hrs_work;
label var hrs_work "Hours working";
label var sinco "SINCO code";
rename scian naics;
label var naics "NAICS code";
rename remesas remit;
label var remit "Remittances";
rename anac_e cohort;
label var cohort "Birth cohort";
gen labor=pea>=1;
label var labor "Labor force participation";
gen work=pea==1;
label var work "Employed";
gen unempl=pea==2;
label var unempl "Unemployed";
gen inactive=pea==0;
label var inactive "Inactive";
drop pea;
rename ing_pam inc_pam;
gen epoor=plp_e==1;
label var epoor "Individual in extreme poverty";
drop plp_e;
gen poor=plp==1;
label var poor "Individual in poverty";
drop plp;
rename tamhogesc hh_size;
label var hh_size "HH size in equivalence scale";
label var ictpc "Income per capita";
label var ict "Total HH income";

order folioviv foliohog numren est_dis upm year;

sort folioviv foliohog numren;
save "$bases\2022.dta", replace;

log close;
