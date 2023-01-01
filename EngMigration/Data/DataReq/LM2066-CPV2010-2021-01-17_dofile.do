*========================================================================*
* English program and labor market outcomes. Proyect LM 2066
*========================================================================*
* Oscar Galvez-Soriano / 2010 Census
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Census\Census_sample2010"
*========================================================================*
use "$data\Censo2010_Personas.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

keep ent mun loc sexo edad res05edo_c res05pai_c
destring sexo edad res05pai_c, replace

rename ent state
rename sexo female10
recode female10 (1=0) (3=1)
rename edad age
rename res05edo_c state5
rename res05pai_c country5
gen migrant5=country5==221
replace state5=state if state5>"32" | (state5==" " & country5==.)
destring state5, replace
tostring state5, replace format(%02.0f) force
gen str id_loc=(state+mun+loc)
drop mun loc country5
order id_loc state5

gen cohort=.
replace cohort=1997 if age==13
replace cohort=1998 if age==12
replace cohort=1999 if age==11
replace cohort=2000 if age==10
replace cohort=2001 if age==9
replace cohort=2002 if age==8
label var cohort "Age cohorts"
keep if cohort!=.

gen nomigrant10=state==state5
gen tot_pop10=1
collapse (sum) tot_pop10 nomigrant10 (mean) female10, by(id_loc cohort)
save "$data\LM2066-CPV2010-2021-01-17_result_base2.dta", replace
