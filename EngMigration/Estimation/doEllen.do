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
/*
use "$data/Papers/main/EngMigration/Data/labor_census20_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 {
    append using "$data/Papers/main/EngMigration/Data/labor_census20_`x'.dta"
}
save "$base\labor_census20.dta", replace 
*/
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
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

*========================================================================*
/* TABLE 2. Regression for main results: Migration analysis */
*========================================================================*
replace time_migra=0 if time_migra==. & migra_ret==1
*========================================================================*
/* TABLE 2. Panel A */
*========================================================================*
eststo clear
eststo: areg dmigrant had_policy rural female i.cohort [aw=factor] if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
eststo: areg migrant had_policy rural female i.cohort [aw=factor] if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
eststo: areg migra_ret had_policy rural female i.cohort if migrant==1 & cohort>=1981 & cohort<=1996 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg dest_us had_policy rural female edu i.cohort if migra_ret==1 & cohort>=1981 & cohort<=1996 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg time_migra had_policy rural female edu i.cohort if migra_ret==1 & cohort>=1981 & cohort<=1996 [aw=factor], absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_migra.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(had_policy) replace
*========================================================================*
/* TABLE 2. Panel B */
*========================================================================*
eststo clear
eststo: areg migrant had_policy rural female i.cohort [aw=factor] if cohort>=1981 & cohort<=1996 & female==0, absorb(geo) vce(cluster geo)
eststo: areg migra_ret had_policy rural female i.cohort if migrant==1 & cohort>=1981 & cohort<=1996 & female==0 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg dest_us had_policy rural female edu i.cohort if migra_ret==1 & cohort>=1981 & cohort<=1996 & female==0 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg time_migra had_policy rural female edu i.cohort if migra_ret==1 & cohort>=1981 & cohort<=1996 & female==0 [aw=factor], absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_migra_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(had_policy) replace
*========================================================================*
/* TABLE 2. Panel C */
*========================================================================*
eststo clear
eststo: areg migrant had_policy rural female i.cohort [aw=factor] if cohort>=1981 & cohort<=1996 & female==1, absorb(geo) vce(cluster geo)
eststo: areg migra_ret had_policy rural female i.cohort if migrant==1 & cohort>=1981 & cohort<=1996 & female==1 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg dest_us had_policy rural female edu i.cohort if migra_ret==1 & cohort>=1981 & cohort<=1996 & female==1 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg time_migra had_policy rural female edu i.cohort if migra_ret==1 & cohort>=1981 & cohort<=1996 & female==1 [aw=factor], absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_migra_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(had_policy) replace

*========================================================================*
/* TABLE 3. Panel C */
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
destring geo, replace

did_multiplegt student geo cohort had_policy if cohort>=1981 & cohort<=1996, ///
weight(factor) robust_dynamic dynamic(6) placebo(5) breps(50) cluster(geo) controls(rural female migrant edu)
did_multiplegt formal_s geo cohort had_policy if cohort>=1981 & cohort<=1996, ///
weight(factor) robust_dynamic dynamic(6) placebo(5) breps(50) cluster(geo) controls(rural female migrant edu)
did_multiplegt informal_s geo cohort had_policy if cohort>=1981 & cohort<=1996, ///
weight(factor) robust_dynamic dynamic(6) placebo(5) breps(50) cluster(geo) controls(rural female migrant edu)
did_multiplegt inactive geo cohort had_policy if cohort>=1981 & cohort<=1996, ///
weight(factor) robust_dynamic dynamic(6) placebo(5) breps(50) cluster(geo) controls(rural female migrant edu)
did_multiplegt work geo cohort had_policy if cohort>=1981 & cohort<=1996, ///
weight(factor) robust_dynamic dynamic(6) placebo(5) breps(50) cluster(geo) controls(rural female migrant edu)
did_multiplegt wpaid geo cohort had_policy if cohort>=1981 & cohort<=1996, ///
weight(factor) robust_dynamic dynamic(6) placebo(5) breps(50) cluster(geo) controls(rural female migrant edu)
did_multiplegt lwage geo cohort had_policy if work==1 & cohort>=1981 & cohort<=1996, ///
weight(factor) robust_dynamic dynamic(6) placebo(5) breps(50) cluster(geo) controls(rural female migrant edu)
did_multiplegt lwage geo cohort had_policy if wpaid==1 & cohort>=1981 & cohort<=1996, ///
weight(factor) robust_dynamic dynamic(6) placebo(5) breps(50) cluster(geo) controls(rural female migrant edu)

/* The results from these regressions are the ones I want you to copy and paste
in my Overleaf document, in Table 3, panel B. 

For each regression, you will copy the coefficient, the SE, observations, and 
the adjusted R2. Please also make sure to include the stars (*) that denote 
the significance level. Thank you! */