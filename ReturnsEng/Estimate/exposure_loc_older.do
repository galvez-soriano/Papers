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
use "$base/d_schools.dta", clear

gen str geo=(state + id_mun + id_loc)
collapse (mean) h_group [fw=total_stud], by(geo year)

rename h_group hrs_exp
replace hrs_exp=0 if hrs_exp==.
drop if year>1999

/* One missing year */
bysort geo: gen nobs=_n
bysort geo: gen nobs_tot=_N
count
expand 2 if nobs==2 & nobs_tot==2
gen obs=_n
replace year=. if obs>r(N)
replace hrs_exp=. if obs>r(N)
sort geo year
bysort geo: egen sum_year=sum(year)
replace year=1997 if year==. & sum_year==3997
replace year=1998 if year==. & sum_year==3996
replace year=1999 if year==. & sum_year==3995

replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==1997 & nobs_tot==2
replace hrs_exp=(hrs_exp[_n-1]+hrs_exp[_n+1])/2 if missing(hrs_exp) & year==1998 & nobs_tot==2
replace hrs_exp=hrs_exp[_n-1]*1.05 if missing(hrs_exp) & year==1999 & nobs_tot==2
drop nobs nobs_tot obs sum_year

/* Two missing years */
bysort geo: gen nobs=_n
bysort geo: gen nobs_tot=_N
count
expand 3 if nobs==1 & nobs_tot==1
gen obs=_n
replace year=. if obs>r(N)
replace hrs_exp=. if obs>r(N)

sort geo year
bysort geo: gen count_obs=_n+1996
gen diff_year=count_obs if year!=count_obs
bysort geo: gen year1997=1 if diff_year==1997
bysort geo: egen y1997=sum(year1997)

replace diff_year=. if year>=1998 & y1997==1
replace year=1997 if count_obs==1998 & year==. & y1997==1
drop year1997 y1997

replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==1998 & year==.
drop count_obs diff_year replace_year

sort geo year
bysort geo: gen count_obs=_n+1996
gen diff_year=count_obs if year!=count_obs
replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==1999 & year==.
sort geo year

replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==1998 & nobs_tot==1
replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==1997 & nobs_tot==1
replace hrs_exp=(hrs_exp[_n-1]+hrs_exp[_n+1])/2 if missing(hrs_exp) & year==1998 & nobs_tot==1
replace hrs_exp=hrs_exp[_n-1]*1.05 if missing(hrs_exp) & year==1999 & nobs_tot==1
replace hrs_exp=hrs_exp[_n-1]*1.05 if missing(hrs_exp) & nobs_tot==1
replace hrs_exp=0 if missing(hrs_exp) & nobs_tot==1
keep geo year hrs_exp

/* Zero missing years */
bysort geo: gen nobs=_n
bysort geo: gen nobs_tot=_N
count
expand 5 if nobs==3 & nobs_tot==3
gen obs=_n
replace year=. if obs>r(N)
replace hrs_exp=. if obs>r(N)
sort geo year
bysort geo: gen count_n=_n
replace year=1989+count_n if year==. & nobs_tot==3
sort geo year
replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==1996
replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==1995
replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==1994
replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==1993
drop nobs nobs_tot obs count_n

gen cohort=year-11
drop year

save "$base\exposure_loc_older.dta", replace
*========================================================================*
use "$base\exposure_loc_older.dta", clear

gen check=substr(geo,6,10)
drop if check==""
gen geo_mun=substr(geo,1,5)
collapse (mean) hrs_exp, by(geo_mun cohort)
rename hrs_exp hrs_exp2
save "$base\exposure_mun_older.dta", replace
