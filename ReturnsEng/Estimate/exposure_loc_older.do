*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
/* Working with the School Census (Stats 911) to create a database of 
school's characteristics and exposure to English instruction */
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EngInstruction/Stat911"
*gl data2= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New"
gl base2= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EngInstruction/Data"
gl base= "C:\Users\ogalvez\Documents\EngAbil\Data"
*========================================================================
/* Creating exposure variable at locality level for oder cohorts
The Mexican school census has missing values for some observations at 
locality level. In this section of the do file, I fill in those missings.
First, I add the missing years and then I interpolate the missing 
observations using the mean between two priximate years. */
*========================================================================*
use "$base/exposure_loc.dta", clear

gen year=cohort+11
sort geo year

bysort geo: gen nobs=_n
bysort geo: gen nobs_tot=_N
count
expand 5 if nobs==11 & nobs_tot==11
gen obs=_n
replace year=. if obs>r(N)
replace hrs_exp=. if obs>r(N)
sort geo year
bysort geo: gen count_n=_n
replace year=1981+count_n if year==. & nobs_tot==11
sort geo year
replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==1996
replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==1995
replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==1994
replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==1993
drop nobs nobs_tot obs count_n cohort

gen cohort=year-11

save "$base\exposure_loc_older.dta", replace
*========================================================================*
use "$base\exposure_loc_older.dta", clear

gen check=substr(geo,6,10)
drop if check==""
gen geo_mun=substr(geo,1,5)
collapse (mean) hrs_exp, by(geo_mun cohort)
rename hrs_exp hrs_exp2
save "$base\exposure_mun_older.dta", replace
*========================================================================*
use "$base\exposure_loc_older.dta", clear

gen check=substr(geo,6,10)
drop if check==""
gen state=substr(geo,1,2)
collapse (mean) hrs_exp, by(state cohort)
rename hrs_exp hrs_exp3
replace hrs_exp3=hrs_exp3
save "$base\exposure_state_older.dta", replace