*========================================================================*
* State English programs and labor market outcomes
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Doc"
*========================================================================*
/* You are going to run everything including lines 17-21 for the first 
time because those lines of the code save the database in your computer.
However, the subsequent times you won't need to run those specific lines 
again. */
*========================================================================*
use "$data/Papers/main/EngMigration/Data/labor_census20_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 {
    append using "$data/Papers/main/EngMigration/Data/labor_census20_`x'.dta"
}
save "$base\labor_census20.dta", replace 

use "$base\labor_census20.dta", clear
drop if state=="05" | state=="17"
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
drop lwage
gen lwage=log(wage+1)
replace wpaid=. if work==0
gen migra_ret=migrant==1 & conact!=.

gen migra_states=0
replace migra_states=1 if state=="01" | state=="08" | state=="10" ///
| state=="11" | state=="12" | state=="13" | state=="16" | state=="18" ///
| state=="20" | state=="22" | state=="32"

gen spolicy=state=="01" | state=="10" | state=="19" | state=="25" ///
 | state=="26" | state=="28"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1
*========================================================================*
/* Regression for main results: Sun and Abraham (2021) */
*========================================================================*
gen first_cohort=0
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

destring geo, replace

gen tgroup=first_cohort
replace tgroup=. if state!="01" & state!="10" & state!="19" & state!="25" ///
& state!="26" & state!="28"
gen cgroup=tgroup==.

eventstudyinteract student had_policy if cohort>=1981 & cohort<=1996 ///
[aw=factor], absorb(geo cohort) cohort(tgroup) control_cohort(cgroup) ///
covariates(rural female migrant edu) ///
vce(cluster geo)
eventstudyinteract formal_s had_policy if cohort>=1981 & cohort<=1996 ///
[aw=factor], absorb(geo cohort) cohort(tgroup) control_cohort(cgroup) ///
covariates(rural female migrant edu) ///
vce(cluster geo)
eventstudyinteract informal_s had_policy if cohort>=1981 & cohort<=1996 ///
[aw=factor], absorb(geo cohort) cohort(tgroup) control_cohort(cgroup) ///
covariates(rural female migrant edu) ///
vce(cluster geo)
eventstudyinteract inactive had_policy if cohort>=1981 & cohort<=1996 ///
[aw=factor], absorb(geo cohort) cohort(tgroup) control_cohort(cgroup) ///
covariates(rural female migrant edu) ///
vce(cluster geo)
eventstudyinteract work had_policy if cohort>=1981 & cohort<=1996 ///
[aw=factor], absorb(geo cohort) cohort(tgroup) control_cohort(cgroup) ///
covariates(rural female migrant edu) ///
vce(cluster geo)
eventstudyinteract wpaid had_policy if cohort>=1981 & cohort<=1996 ///
[aw=factor], absorb(geo cohort) cohort(tgroup) control_cohort(cgroup) ///
covariates(rural female migrant edu) ///
vce(cluster geo)
eventstudyinteract lwage had_policy if work==1 & cohort>=1981 & cohort<=1996 ///
[aw=factor], absorb(geo cohort) cohort(tgroup) control_cohort(cgroup) ///
covariates(rural female migrant edu) ///
vce(cluster geo)
eventstudyinteract lwage had_policy if wpaid==1 & cohort>=1981 & cohort<=1996 ///
[aw=factor], absorb(geo cohort) cohort(tgroup) control_cohort(cgroup) ///
covariates(rural female migrant edu) ///
vce(cluster geo)

/* The results from these regressions are the ones I want you to copy and paste
in my Overleaf document, in Table 3, panel B. 

For each regression, you will copy the coefficient, the SE, observations, and 
the adjusted R2. Please also make sure to include the stars (*) that denote 
the significance level. Thank you! */