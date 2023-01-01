*========================================================================*
/* This do file cleans the Stats 911 database to construct an enrollment 
data for my JMP */
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Stats911\Media\Bases"
gl data2= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Stats911\Superior\Bases"
gl data3= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\CONAPO"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Stats911\Final_data"
*========================================================================*
/* High School */
*========================================================================*
foreach x in 18 19 20{
use "$data\20`x'\hs_general_i`x'.dta", clear
keep cv_ent_inmueble cv_mun v369 v376 v383 v390
rename cv_ent_inmueble state
rename cv_mun county
*rename cv_loc locali
rename v369 stud10
rename v376 stud11
rename v383 stud12
rename v390 stud13
gen year=20`x'
destring state county, replace
tostring state, replace format(%02.0f) force
tostring county, replace format(%03.0f) force
gen str mun=(state+county)
drop state county
order mun year
save "$base\hs_gral_`x'.dta", replace
*========================================================================*
use "$data\20`x'\hs_tech_i`x'.dta", clear
keep cv_ent_inmueble cv_mun v437 v444 v451 v458 v465
rename cv_ent_inmueble state
rename cv_mun county
rename v437 stud10
rename v444 stud11
rename v451 stud12
rename v458 stud13
rename v465 stud14
gen year=20`x'
tostring county, replace
drop if county=="NULL"
destring state county, replace
tostring state, replace format(%02.0f) force
tostring county, replace format(%03.0f) force
gen str mun=(state+county)
drop state county
order mun year
save "$base\hs_tech_`x'.dta", replace

append using "$base\hs_gral_`x'.dta"
replace stud13=0 if stud13==.
replace stud14=0 if stud14==.
collapse (sum) stud* (mean) year, by(mun)
save "$base\hs_`x'.dta", replace
}
*========================================================================*
/* College */
*========================================================================*
foreach x in 18 19 20{
use "$data2\20`x'\c_i`x'.dta", clear
keep cv_ent_inmueble cv_mun v141 v147 v153 v159 v165 v171
rename cv_ent_inmueble state
rename cv_mun county
rename v141 stud13
rename v147 stud14
rename v153 stud15
rename v159 stud16
rename v165 stud17
rename v171 stud18

gen year=20`x'
tostring state, replace format(%02.0f) force
tostring county, replace format(%03.0f) force
gen str mun=(state+county)
drop state county
order mun year

collapse (sum) stud* (mean) year, by(mun)
save "$base\c_`x'.dta", replace
}
*========================================================================*
/* High School - College */
*========================================================================*
foreach x in 18 19 20{
use "$base\hs_`x'.dta", clear
append using "$base\c_`x'.dta"

replace stud15=0 if stud15==.
replace stud16=0 if stud16==.
replace stud17=0 if stud17==.
replace stud18=0 if stud18==.
order mun year
collapse (sum) stud* (mean) year, by(mun)
save "$base\hsc_`x'.dta", replace
}

use "$base\hsc_18.dta", clear
append using "$base\hsc_19.dta" "$base\hsc_20.dta"
order mun year
save "$base\low_enroll_sep.dta", replace
*========================================================================*
/* Census forecasts */
*========================================================================*
use "$data3\conapo_forecast1.dta", clear
keep clave sexo year edad_quin pob
rename clave mun
rename sexo sex
rename edad_quin five_y
rename pob pop
tostring mun, replace format(%05.0f) force
keep if five_y=="pobm_15_19"
collapse (sum) pop, by(mun year)
keep if year>=2018 & year<=2020
save "$base\conapo1.dta", replace
*========================================================================*
use "$data3\conapo_forecast2.dta", clear
keep clave sexo year edad_quin pob
rename clave mun
rename sexo sex
rename edad_quin five_y
rename pob pop
tostring mun, replace format(%05.0f) force
keep if five_y=="pobm_15_19"
collapse (sum) pop, by(mun year)
keep if year>=2018 & year<=2020
save "$base\conapo2.dta", replace
*========================================================================*
append using "$base\conapo1.dta"
sort mun year
save "$base\conapo.dta", replace
*========================================================================*
/* Final database */
*========================================================================*
use "$base\low_enroll_sep.dta", clear
merge m:m mun year using "$base\conapo.dta"

drop if _merge==1
drop _merge

gen ns=stud10+stud11+stud12+stud13+stud14
drop stud*
replace ns=0 if ns==.
sort mun year
gen p_stud_sep=ns/pop
save "$base\enroll_sep.dta", replace
