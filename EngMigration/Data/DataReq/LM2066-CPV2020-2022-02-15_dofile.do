*========================================================================*
* English program and labor market outcomes. Proyect LM 2066
*========================================================================*
* Oscar Galvez-Soriano / 2020 Census
*========================================================================*
clear
set more off
/* 
Nota: Reemplazar en la línea 11 el directorio de la carpeta donde está la base de datos
*/
gl data= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Census\Census_sample2020"
*========================================================================*
use "$data\Censo2020_CPV_CB_Personas_ejemplo_dta.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

keep ent mun edad asisten conact

destring asisten conact, replace

rename edad age
rename asisten student
recode student (3=0) (9=.)
replace student=1 if conact==50
gen str geo=(ent+mun)
drop ent mun conact
order geo 

gen cohort=.
replace cohort=1997 if age==23
replace cohort=1998 if age==22
replace cohort=1999 if age==21
replace cohort=2000 if age==20
replace cohort=2001 if age==19
replace cohort=2002 if age==18
label var cohort "Age cohorts"
drop if cohort==.
replace student=0 if student==.

gen tot_pop=1
collapse (sum) student tot_pop, by(geo cohort)

gen p_stud=student/tot_pop

keep geo p_stud tot_pop cohort
save "$data\LM2066-CPV2020-2022-02-15_result_base.dta", replace
