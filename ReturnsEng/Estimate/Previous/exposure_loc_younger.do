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
gl data2= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New"
gl base2= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EngInstruction/Data"
gl base= "C:\Users\galve\Documents\Papers\Current\Returns to Eng Mex\Data"
*========================================================================
/* Creating exposure variable at locality level for oder cohorts
The Mexican school census has missing values for some observations at 
locality level. In this section of the do file, I fill in those missings.
First, I add the missing years and then I interpolate the missing 
observations using the mean between two priximate years. */
*========================================================================*
use "$data2/d_schools.dta", clear

gen str geo=(state + id_mun + id_loc)
collapse (mean) h_group [fw=total_stud], by(geo year)

rename h_group hrs_exp
replace hrs_exp=0 if hrs_exp==.
drop if year<2008

/* One missing year */
bysort geo: gen nobs=_n
bysort geo: gen nobs_tot=_N
count
expand 2 if nobs==5 & nobs_tot==5
gen obs=_n
replace year=. if obs>r(N)
replace hrs_exp=. if obs>r(N)
sort geo year
bysort geo: egen sum_year=sum(year)
replace year=2008 if year==. & sum_year==10055
replace year=2009 if year==. & sum_year==10054
replace year=2010 if year==. & sum_year==10053
replace year=2011 if year==. & sum_year==10052
replace year=2012 if year==. & sum_year==10051
replace year=2013 if year==. & sum_year==10050
sort geo year

replace hrs_exp=hrs_exp[_n+1] if missing(hrs_exp) & year==2008
replace hrs_exp=(hrs_exp[_n-1]+hrs_exp[_n+1])/2 if missing(hrs_exp) & year!=2008 & year!=2013
replace hrs_exp=hrs_exp[_n-1] if missing(hrs_exp) & year==2013
drop nobs nobs_tot obs sum_year

/* Two missing years */
bysort geo: gen nobs=_n
bysort geo: gen nobs_tot=_N
count
expand 3 if nobs==4 & nobs_tot==4
gen obs=_n
replace year=. if obs>r(N)
replace hrs_exp=. if obs>r(N)

sort geo year
bysort geo: gen count_obs=_n+2007
gen diff_year=count_obs if year!=count_obs
bysort geo: gen year2008=1 if diff_year==2008
bysort geo: egen y2008=sum(year2008)

replace diff_year=. if year>=2009 & y2008==1
replace year=2008 if count_obs==2012 & year==. & y2008==1
drop year2008 y2008

replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==2012 & year==.
drop count_obs diff_year replace_year

sort geo year
bysort geo: gen count_obs=_n+2007
gen diff_year=count_obs if year!=count_obs
replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==2013 & year==.
sort geo year

replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & hrs_exp[_n-1]==. & year==2009 & nobs_tot==4
replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==2008 & nobs_tot==4
replace hrs_exp=(hrs_exp[_n-1]+hrs_exp[_n+1])/2 if missing(hrs_exp) & year>2008 & year<2012 & nobs_tot==4
replace hrs_exp=hrs_exp[_n-1]*1.05 if missing(hrs_exp) & year>=2008 & nobs_tot==4
keep geo year hrs_exp

/* Three missing years */
bysort geo: gen nobs=_n
bysort geo: gen nobs_tot=_N
count
expand 4 if nobs==3 & nobs_tot==3
gen obs=_n
replace year=. if obs>r(N)
replace hrs_exp=. if obs>r(N)

sort geo year




save "$base\exposure_loc_young.dta", replace
*========================================================================*
use "$base\exposure_loc_young.dta", clear

gen check=substr(geo,6,10)
drop if check==""
gen geo_mun=substr(geo,1,5)
collapse (mean) hrs_exp, by(geo_mun cohort)
rename hrs_exp hrs_exp2
save "$base\exposure_mun_young.dta", replace
