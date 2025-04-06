*========================================================================*
/* English skills and labor market outcomes in Mexico */
*========================================================================*
/* Author: Oscar Galvez-Soriano */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/ReturnsEng/Data"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\ReturnsEng\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\ReturnsEng\Doc"
*========================================================================*
use "$data/hsg_data.dta", clear

destring cd_a, replace
rename ent state
gen female=sex=="2"
destring eda, replace
gen cohort=2012-eda

gen eng=p19=="1"
destring p20_1, gen (eng_read)
destring p20_2, gen (eng_write)
destring p20_3, gen (eng_speak)

keep state cd_a cohort female eng eng_read eng_speak eng_write fac

merge m:m state cd_a using "$base\enilems12\enoe_mun_city.dta"
drop if _merge!=3
drop _merge

gen str geo_mun=state+mun
order cd_a state mun geo_mun cohort

merge m:1 geo_mun cohort using "$data/exposure_mun.dta"
rename hrs_exp2 hrs_exp
drop if _merge==2

rename _merge merge3
merge m:1 state cohort using "$data/exposure_state.dta"
replace hrs_exp=hrs_exp3 if merge3==1 & hrs_exp==.
drop if _merge==2
drop merge3 hrs_exp3 _merge

sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)

save "$base/hsg_fdata.dta", replace

*========================================================================*
gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

gen first_cohort=1997
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1
destring geo state, replace

did_imputation eng geo_mun cohort first_cohort [aw=fac], ///
controls(female) fe(geo_mun cohort state#cohort) cluster(geo_mun) autos minn(0)


did_imputation eng geo_mun cohort first_cohort [aw=fac], ///
horizons(0/2) pretrend(1) controls(female) fe(geo_mun cohort state#cohort) ///
cluster(geo_mun) autos minn(0)

*========================================================================*
use "$base/hsg_fdata.dta", clear

collapse hrs_exp [fw=fac], by(geo_mun cohort)
sum hrs_exp, d
gen engl=hrs_exp>=r(p90)

bysort geo_mun: replace engl=1 if engl[_n-1]==1 & engl[_n+1]==1 & engl==0
bysort geo_mun: replace engl=1 if engl[_n-1]==1 & engl==0 & cohort==1994
bysort geo_mun: replace engl=0 if engl[_n-1]==0 & engl[_n+1]==0 & engl==1

gen ftreat=.
bysort geo_mun: gen ncount=_n if engl!=0
bysort geo_mun: replace ftreat=cohort if ncount[_n-1]==. & ncount[_n+1]>ncount & ncount!=. // this identifies the first treated cohort but exclude never treated
bysort geo_mun: egen first_treat = total(ftreat) // assigning the value of the first treated cohort to all observations within a municipality

replace engl=0 if first_treat>1994
sum hrs_exp if engl==1, d
replace engl=1 if hrs_exp>=r(p75) & first_treat>1994
drop ftreat ncount first_treat

sort geo_mun cohort

gen ftreat=.
bysort geo_mun: gen ncount=_n if engl!=0
bysort geo_mun: replace ftreat=cohort if ncount[_n-1]==. & ncount[_n+1]>ncount & ncount!=.
bysort geo_mun: egen first_treat = total(ftreat)

rename first_treat first_cohort
keep geo_mun cohort first_cohort

replace first_cohort = 1995 if first_cohort==0
gen K = cohort-first_cohort
gen D = K>=0 & first_cohort!=.

save "$base/hsg_exp.dta", replace

*========================================================================*
use "$base/hsg_fdata.dta", clear

merge m:1 geo_mun cohort using "$data/hsg_exp.dta", nogen
destring state, replace

did_imputation eng geo_mun cohort first_cohort [aw=fac], ///
controls(female) fe(geo_mun cohort state#cohort) cluster(geo_mun) autos minn(0)


did_imputation eng geo_mun cohort first_cohort [aw=fac], ///
horizons(0/2) pretrend(1) controls(female) fe(geo_mun cohort state#cohort) ///
cluster(geo_mun) autos minn(0)