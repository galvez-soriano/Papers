*========================================================================*
* English program and labor market outcomes. Proyect LM 2066
*========================================================================*
* Oscar Galvez-Soriano / 2000 Census
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Census\Census_sample2000"
*========================================================================*
use "$data\Censo2000_Personas.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

keep entidad municipio localidad sexo edad
destring sexo edad, replace

rename entidad state
rename sexo female00
recode female00 (1=0) (2=1)
rename edad age
gen str id_loc=(state+municipio+localidad)
drop state municipio localidad
order id_loc

gen cohort=.
replace cohort=1997 if age==3
replace cohort=1998 if age==2
replace cohort=1999 if age==1
replace cohort=2000 if age==0
label var cohort "Age cohorts"
keep if cohort!=.

gen tot_pop00=1
collapse (sum) tot_pop00 (mean) female00, by(id_loc cohort)
save "$data\LM2066-CPV2000-2021-01-17_result_base2.dta", replace
