*=====================================================================*
/* Paper: Unintended effects of universalizing social pensions
   Authors: Oscar Galvez-Soriano and Raymundo Ramirez */
*=====================================================================*

/* INSTRUCTIONS:

   Before running this program, make sure to run the following programs:
   1_2016.do
   2_2018.do
   3_2020.do
   4_2022.do
   5_2024.do
   
   These programs stored data sets (20XX.dta) in five different folders:
   "C:\Users\Documents\UniversalizationPAM\Data\2016\Bases"
   "C:\Users\Documents\UniversalizationPAM\Data\2018\Bases"
   "C:\Users\Documents\UniversalizationPAM\Data\2020\Bases"
   "C:\Users\Documents\UniversalizationPAM\Data\2022\Bases"
   "C:\Users\Documents\UniversalizationPAM\Data\2024\Bases"
   
   This program, will pull those data sets in one single database named
   "dbaseRemitt.dta". To this purpose, we must define the global "data" in 
   line 30 of this program with the path that corresponds to the user's 
   computer, right before the folders named with the years of the data 
   sets as follows:
   
   gl data="C:\Users\Documents\UniversalizationPAM\Data"
*/
*=====================================================================*
gl data="C:\Users\Oscar Galvez Soriano\Documents\Papers\UniversalizationPAM\Data"
*=====================================================================*
use "$data\2016\Bases\2016.dta", clear
append using "$data\2018\Bases\2018.dta", force
append using "$data\2020\Bases\2020.dta", force
append using "$data\2022\Bases\2022.dta", force
append using "$data\2024\Bases\2024.dta", force

save "$data\dbasePAM16_24.dta", replace
*=====================================================================*

rename ing_pens inc_ret
destring loc_size, replace
drop pam
gen pam=.
replace pam= 1 if inc_pam>0 
replace pam=0 if inc_pam==0
destring etnia, replace
rename etnia indig
recode indig (1=1) (2=0)
label define indig 0 "Non indigenous" 1 "Indigenous"
label values indig indig
label drop discap
rename discap disabled
label define disabled 0 "Without disability" 1 "With disability"
label values disabled disabled

*=====================================================================*
* VARIABLES DE EDUCACIÓN Y MERCADO LABORAL
*=====================================================================*

* ASISTENCIA ESCOLAR
destring asis_esc, replace
recode asis_esc (1=1) (2=0)
rename asis_esc school_at
label define school_at 0 "Not attending school" 1 "Attending school"
label values school_at school_at

* WORK
drop work
gen work=1 if (pea==1 & age>=16)
replace work=0 if (pea==0 | pea==2) & age>=16
label variable work "Employment status"
label define work 0 "Not working" 1 "Working"
label values work work

* INACTIVITY
drop inactive
gen inactive=1 if (school_at==0 & work==0 & age>=16)
replace inactive=0 if(school_at==1 | work==1) & age>=16
label variable inactive "Inactive (not studying and not working)"
label define inactive 0 "Active" 1 "Inactive"
label values inactive inactive

* LABOR FORCE
drop labor
gen labor=1 if  (pea==1 | pea==2) & age>=16
replace labor=0 if pea==0 & age>=16
label variable labor "Labor force participation"
label define labor 0 "Outside labor force" 1 "In labor force"
label values labor labor

gen ind_60_64 = age >= 60 & age < 65
bysort folioviv foliohog: egen n_60_64 = total(ind_60_64)
gen cohab1=.
replace cohab1 =1 if tot_integ!=p65mas | tot_integ!=n_60_64
replace cohab1 = 0 if tot_integ==p65mas | tot_integ==n_60_64

recode main_jobt (1=1) (2 3 .=0)
rename main_jobt subor
label variable subor "Subordinate employment"
label define subor 0 "Non-subordinate worker" 1 "Subordinate worker"
label values subor subor

gen selfemp= subor==0
label variable selfemp "Self-employment"
label define selfemp 0 "Not self-employed" 1 "Self-employed"
label values selfemp selfemp

*=====================================================================*
* CONSTRUCCIÓN DE LA ESTRATEGIA DDD
*=====================================================================*

gen tr = . 
replace tr = 1 if inc_ret >= 1092 
replace tr=0 if inc_ret<1092 

* GENERAMOS EL TRATAMIENTO: ADULTOS MAYORES DE 68 A 70 AÑOS
gen treat=.
replace treat = 1 if inrange(age,68,70)

* GENERAMOS EL GRUPO DE CONTROL: ADULTOS DE 62 A 64 AÑOS
replace treat = 0 if inrange(age,62,64)

* GENERAMOS EL PERIODO POSTERIOR A LA UNIVERSALIZACIÓN
gen after =.

* PERIODO POST-POLÍTICA
replace after = 1 if inlist(year, 2020,2022,2024)

* PERIODO PRE-POLÍTICA
replace after = 0 if inlist(year,2016,2018)

* INTERACCIONES DEL DDD
gen int1 =treat*after
gen int2=treat*tr
gen int3=after*tr

*======================================================*
* CUARTILES DE INGRESO 
*======================================================*
gen quartile = .
pctile pval = ictpc [fw=weight] if inrange(age,62,64) | inrange(age,68,70), nq(100)
scalar p25 = pval[25]
scalar p50 = pval[50]
scalar p75 = pval[75]
replace quartile = 1 if ictpc <= p25
replace quartile = 2 if ictpc > p25 & ictpc <= p50
replace quartile = 3 if ictpc > p50 & ictpc <= p75
replace quartile = 4 if ictpc > p75

label define qlbl ///
    1 "Q1 (≤25%)" ///
    2 "Q2 (25–50%)" ///
    3 "Q3 (50–75%)" ///
    4 "Q4 (>75%)", replace

label values quartile qlbl

*=====================================================================*
* ROBUSTNESS CHECK
*=====================================================================*

* GENERAMOS UNA DEFINICIÓN ALTERNATIVA DEL GRUPO TRATADO
gen treat2=.

* TRATAMIENTO ALTERNATIVO: ADULTOS DE 71 A 73 AÑOS
replace treat2=1 if inrange(age,71,73)

* GRUPO DE CONTROL ALTERNATIVO: ADULTOS DE 62 A 64 AÑOS
replace treat2=0 if inrange(age,62,64)

* INTERACCIONES PARA LA ESPECIFICACIÓN ALTERNATIVA
gen int12 =treat2*after
gen int22=treat2*tr
gen int32=after*tr

*=====================================================================*
* TRANSFORMACIÓN DE INGRESO
*=====================================================================*

* GENERAMOS EL LOGARITMO DEL INGRESO PER CÁPITA
gen l_inc=ln(ictpc+1)
replace l_inc=0 if l_inc<0

*=====================================================================*
* SELECCIÓN DE VARIABLES DE INTERÉS
*=====================================================================*

keep foliohog folioviv geo state year weight cohab1 age female pam inc_pam poor epoor work treat after int1 int2 int3 tr pam l_inc rururb loc_size subor ictpc tot_integ p65mas selfemp educ indig ss_dir indig disabled num_auto num_suv num_pickup num_moto num_bici num_tvd num_dvd num_licua num_tosta num_micro num_refri num_estuf num_lavad num_planc num_aspir num_compu num_impre num_juego acc_piso acc_techo acc_muro wealth int12 int22 int32 treat2 school_at cereales_monh carnes_monh pescado_monh leche_monh huevo_monh aceites_monh tuberculo_monh verduras_monh frutas_monh azucar_monh cafe_monh especias_monh otros_alim_monh noalcohol_monh tabaco_monh alcohol_monh vestido_monh calzado_monh kinder_monh primaria_monh secu_monh prepa_monh universidad_monh posgrado_monh cuip_monh accp_monh cris_monh ens_monh  med_monh educ_basica_monh educ_media_monh educ_superior_monh vestido17_monh calzado17_monh labor time_work inactive ing_lab quartile 

*=====================================================================*
* MUNICIPIOS DE LA FRONTERA NORTE
*=====================================================================*

* HOMOLOGAMOS EL IDENTIFICADOR GEOGRÁFICO PARA 2016
replace geo = substr(geo, 1, 5) if year == 2016 & substr(geo, 6, 4) == "0000"

* LISTA DE MUNICIPIOS DE LA FRONTERA NORTE
local fn_muns "02001 02002 02005 02003 02004 26002 26004 26017 26019 26070 26039 26043 26048 26055 26059 26060 08005 08015 08028 08035 08037 08042 08052 08053 05002 05012 05013 05014 05022 05023 05025 05038 19005 28007 28014 28015 28022 28024 28025 28027 28032 28033 28040"

* GENERAMOS INDICADOR DE MUNICIPIO FRONTERIZO
gen border = 0

* IDENTIFICAMOS LOS MUNICIPIOS PERTENECIENTES A LA FRONTERA NORTE
foreach m of local fn_muns {
    replace border = 1 if geo == "`m'"
}

*=====================================================================*
* ETIQUETAS DE VARIABLES
*=====================================================================*

* ASIGNAMOS ETIQUETAS DESCRIPTIVAS A VARIABLES PRINCIPALES
label var pam "PAM take-up"
label var l_inc "Ln(income)"
label var poor "Poverty"
label var epoor "Extreme poverty"
label var work "Employment"
label var female "Female"
label var educ "Education"
label var indig "Indigenous"
label var cohab1 "Cohabitation"

*=====================================================================*
* TRANSFORMACIÓN LOGARÍTMICA DE VARIABLES MONETARIAS Y DE TIEMPO
*=====================================================================*

* APLICAMOS LA TRANSFORMACIÓN ln(1+x) A VARIABLES DE GASTO,
* CONSUMO, EDUCACIÓN, TIEMPO E INGRESO LABORAL
foreach var in ///
cereales_monh carnes_monh pescado_monh leche_monh huevo_monh aceites_monh tuberculo_monh verduras_monh frutas_monh azucar_monh cafe_monh especias_monh otros_alim_monh noalcohol_monh tabaco_monh alcohol_monh vestido_monh calzado_monh kinder_monh primaria_monh secu_monh prepa_monh universidad_monh posgrado_monh med_monh educ_basica_monh educ_media_monh educ_superior_monh vestido17_monh calzado17_monh {

    * TRANSFORMAMOS CADA VARIABLE A LOGARITMO
    replace `var' = ln(1 + `var')

}

*=====================================================================*
* IDENTIFICACIÓN DE HOGARES CON ADULTOS MAYORES Y JÓVENES
*=====================================================================*

* IDENTIFICAMOS PERSONAS EN LAS EDADES DE TRATAMIENTO O CONTROL
gen head = (inrange(age,62,64) | inrange(age,68,70))

* IDENTIFICAMOS JÓVENES DE 0 A 25 AÑOS EN EL HOGAR
gen young = inrange(age,0,25) 

* IDENTIFICAMOS SI EL HOGAR TIENE AL MENOS UNA PERSONA EN EDADES DE INTERÉS
bysort folioviv foliohog: egen h1 = max(head)

* IDENTIFICAMOS SI EL HOGAR TIENE AL MENOS UN JOVEN DE 0 A 25 AÑOS
bysort folioviv foliohog: egen y1 = max(young)

* GENERAMOS INDICADOR DE HOGARES CON ADULTO MAYOR Y JOVEN
gen hy = .

* HOGARES CON ADULTO MAYOR Y AL MENOS UN JOVEN
replace hy = 1 if h1==1 & y1==1

* HOGARES CON ADULTO MAYOR Y SIN JÓVENES
replace hy = 0 if h1==1 & y1==0

*=====================================================================*
* IDENTIFICACIÓN DE HOGARES CON PERSONAS EN EDADES ESCOLARES
*=====================================================================*

* IDENTIFICAMOS PERSONAS DE 6 A 18 AÑOS
gen age618  = inrange(age,6,18)

* IDENTIFICAMOS PERSONAS DE 19 A 30 AÑOS
gen age1930 = inrange(age,19,30)

* IDENTIFICAMOS SI EN EL HOGAR HAY AL MENOS UNA PERSONA DE 6 A 18 AÑOS
bysort folioviv foliohog: egen age_618  = max(age618)

* IDENTIFICAMOS SI EN EL HOGAR HAY AL MENOS UNA PERSONA DE 19 A 30 AÑOS
bysort folioviv foliohog: egen age_1930 = max(age1930)

* GUARDAMOS LA BASE INTERMEDIA PARA EL ANÁLISIS
save "$data\dbasePAM.dta", replace


/*
use "$data\dbasePAM.dta", clear

local start=0
local end=0

foreach x in 1 2 3 4 5 6 7 8 9 10 {

	use "$data\dbasePAM.dta", clear

	local start=`end'+1
	local end=104387*`x'

	keep in `start'/`end'

	save "$data\dbasePAM_`x'.dta", replace
}

use "$data\dbasePAM.dta", clear

keep in 1043871/l

save "$data\dbasePAM_11.dta", replace
*/
