*========================================================================*
/* This do file cleans the Stats 911 database to construct an enrollment 
data for my JMP */
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Stats911\Media\Bases"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Stats911\Final_data"
*========================================================================*
/* High School */
*========================================================================*
use "$data\2017\hs_general_i17.dta", clear
keep entidad municipio localidad ms156 ms163 ms170 ms177
rename entidad state
rename municipio county
rename localidad locali 
rename ms156 stud10
rename ms163 stud11
rename ms170 stud12
rename ms177 stud13
gen year=2017
gen str id_loc=(state+county+locali)
drop state county locali
order id_loc year
save "$base\hs_gral_17.dta", replace
*========================================================================*
use "$data\2017\hs_tech_i17.dta", clear
keep entidad municipio localidad ms175 ms182 ms189 ms196 ms203
rename entidad state
rename municipio county
rename localidad locali 
rename ms175 stud10
rename ms182 stud11
rename ms189 stud12
rename ms196 stud13
rename ms203 stud14
gen year=2017
gen str id_loc=(state+county+locali)
drop state county locali
order id_loc year
save "$base\hs_tech_17.dta", replace

append using "$base\hs_gral_17.dta"
replace stud13=0 if stud13==.
replace stud14=0 if stud14==.
collapse (sum) stud* (mean) year, by(id_loc)
save "$base\hs_17.dta", replace
*========================================================================*
/* 2018-2020 */
*========================================================================*
foreach x in 18 19 20{
use "$data\20`x'\hs_general_i`x'.dta", clear
keep cv_ent_inmueble cv_mun cv_loc v369 v376 v383 v390
rename cv_ent_inmueble state
rename cv_mun county
rename cv_loc locali
rename v369 stud10
rename v376 stud11
rename v383 stud12
rename v390 stud13
gen year=20`x'
destring state county locali, replace
tostring state, replace format(%02.0f) force
tostring county, replace format(%03.0f) force
tostring locali, replace format(%04.0f) force
gen str id_loc=(state+county+locali)
drop state county locali
order id_loc year
save "$base\hs_gral_`x'.dta", replace
*========================================================================*
use "$data\20`x'\hs_tech_i`x'.dta", clear
keep cv_ent_inmueble cv_mun cv_loc v437 v444 v451 v458 v465
rename cv_ent_inmueble state
rename cv_mun county
rename cv_loc locali
rename v437 stud10
rename v444 stud11
rename v451 stud12
rename v458 stud13
rename v465 stud14
gen year=20`x'
tostring county, replace
drop if county=="NULL"
destring state county locali, replace
tostring state, replace format(%02.0f) force
tostring county, replace format(%03.0f) force
tostring locali, replace format(%04.0f) force
gen str id_loc=(state+county+locali)
drop state county locali
order id_loc year
save "$base\hs_tech_`x'.dta", replace

append using "$base\hs_gral_`x'.dta"
replace stud13=0 if stud13==.
replace stud14=0 if stud14==.
collapse (sum) stud* (mean) year, by(id_loc)
save "$base\hs_`x'.dta", replace
}
*========================================================================*
/* College */
*========================================================================*
