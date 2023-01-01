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
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Stats911\Final_data"
*========================================================================*
/* High School */
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
foreach x in 18 19 20{
use "$data2\20`x'\c_i`x'.dta", clear
keep cv_ent_inmueble cv_mun cv_loc v141 v147 v153 v159 v165 v171
rename cv_ent_inmueble state
rename cv_mun county
rename cv_loc locali
rename v141 stud13
rename v147 stud14
rename v153 stud15
rename v159 stud16
rename v165 stud17
rename v171 stud18

gen year=20`x'
tostring state, replace format(%02.0f) force
tostring county, replace format(%03.0f) force
tostring locali, replace format(%04.0f) force
gen str id_loc=(state+county+locali)
drop state county locali
order id_loc year

collapse (sum) stud* (mean) year, by(id_loc)
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
order id_loc year
collapse (sum) stud* (mean) year, by(id_loc)
save "$base\hsc_`x'.dta", replace
}

use "$base\hsc_18.dta", clear
append using "$base\hsc_19.dta" "$base\hsc_20.dta"
order id_loc year
save "$base\low_enroll_sep.dta", replace
*========================================================================*
/* Census forecasts */
*========================================================================*
