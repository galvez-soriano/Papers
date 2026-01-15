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
drop if age==.
drop pam
gen pam=.
replace pam= 1 if inc_pam>0
replace pam=0 if inc_pam==0
destring etnia, replace
rename etnia indig
recode indig (1=1) (2=0)
label drop discap
rename discap disabled
label define discap 0 "Without disability" 1 "With disability"

*GENERAMOS LA VARIABLE DE COHABITACIÓN CON PERSONAS DE 65 Y MÁS AÑOS E INTEGRANTES TOTATLES DEL HOGAR
gen cohab1=.
replace cohab1 =1 if tot_integ!=p65mas
replace cohab1 = 0 if tot_integ==p65mas


*GENERAMOS LA VARIABLE DE SUBORDINADO CON BASE EN EL EMPLEO PRINCIPAL
recode main_jobt (1=1) (2 3 .=0)
rename main_jobt subor

*GENERAMOS LA VARIABLE DE AUTOEMPLEADOS
gen selfemp= subor==0

*MANTENEMOS LAS EDADES DE INTERÉS (62-64 Y 68-70 AÑOS).

keep if inrange(age, 62, 70)

drop if inrange(age, 65, 67)

*GENERAMOS LA TERCERA DIMENSIÓN QUE LLAMAREMOS ´tr'
gen tr = . 
replace tr=1 if inc_ret>=1092
replace tr=0 if inc_ret<1092

*GENERAMOS EL TRATAMIENTO: ADULTOS MAYORES DE 68 A 70 AÑOS.
gen treat=.
replace treat = 1 if inrange(age,68,70)

*Y EL CONTROL: ADULTOS DE 62 A 64 AÑOS.
replace treat = 0 if inrange(age,62,64)

*GENERAMOS LA VARIABLE AFTER QUE SON LOS PERIODOS POSTERIORES A LA IMPLEMENTACIÓN DE LA POLÍTICA: 2020 A 2024.
gen after =.
replace after = 1 if inlist(year, 2020,2022,2024)
replace	after = 0 if inlist(year,2016,2018)

*GENERAMOS LAS INTERACCIONES ENTRE LAS DIMENSIONES: TRATAMIENTO, AFTER Y TR.
gen int1 =treat*after
gen int2=treat*tr
gen int3=after*tr


*LOGARITMO DEL INGRESO
gen l_inc=ln(ictpc+1)
replace l_inc=0 if l_inc<0

*MANTENEMOS LAS VARIABLES DE INTERÉS
keep geo state year weight cohab1 age female pam inc_pam poor epoor work treat after int1 int2 int3 tr pam l_inc rururb loc_size subor ictpc tot_integ p65mas selfemp educ indig ss_dir indig disabled num_auto num_suv num_pickup num_moto num_bici        num_tvd num_dvd num_licua num_tosta num_micro num_refri num_estuf num_lavad num_planc   num_aspir num_compu num_impre num_juego acc_piso acc_techo acc_muro wealth

*PERCENTILES PONDERADOS
pctile pval = ictpc [aw=weight], nq(100)

* SE GUARDAN PERCENTILES
scalar p25 = pval[25]
scalar p50 = pval[50]
scalar p75 = pval[75]
scalar p99 = pval[99]

* GENERAMOS DUMMIES PARA LOS PERCENTILES
gen quartile = .
replace quartile = 1 if ictpc <= p25
replace quartile = 2 if ictpc > p25 & ictpc <= p50
replace quartile = 3 if ictpc > p50 & ictpc <= p75
replace quartile = 4 if ictpc > p75
label define qlbl 1 "Q1 (≤25%)" 2 "Q2 (25–50%)" 3 "Q3 (50–75%)" 4 "Q4 (>75%)"
label values quartile qlbl

*GENERAMOS LOS DUMMIES DE LOS MUNICIPIOS DE LA FRONTERA NORTE
replace geo = substr(geo, 1, 5) if year == 2016 & substr(geo, 6, 4) == "0000"

local fn_muns "02001 02002 02005 02003 02004 26002 26004 26017 26019 26070 26039 26043 26048 26055 26059 26060 08005 08015 08028 08035 08037 08042 08052 08053 05002 05012 05013 05014 05022 05023 05025 05038 19005 28007 28014 28015 28022 28024 28025 28027 28032 28033 28040"


gen border = 0
foreach m of local fn_muns {
    replace border = 1 if geo == "`m'"
}


save "$data\dbasePAM.dta", replace
*=====================================================================*
/*use "$data\dbasePAM.dta", clear
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
save "$data\dbasePAM_11.dta", replace*/

*=====================================================================*
