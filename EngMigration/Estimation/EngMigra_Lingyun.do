*========================================================================*
* English program and earnings
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
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 {
    append using "$data/Papers/main/EngMigration/Data/labor_census20_`x'.dta"
}
save "$base\labor_census20.dta", replace 
*/
use "$base\labor_census20.dta", clear
drop if state=="05" | state=="17"
drop lwage
gen lwage=log(wage+1)
replace wpaid=. if work==0
gen migra_ret=migrant==1 & conact!=.
replace dmigrant=0 if migrant==1

drop if imputed_state==1

sum hrs_exp2 if state=="01" & cohort>=1990 & cohort<=1996, d
return list
gen engl=hrs_exp2>=r(p50) & state=="01"
sum hrs_exp2 if state=="10" & cohort>=1991 & cohort<=1996, d
return list
replace engl=1 if hrs_exp2>=r(p50) & state=="10"
sum hrs_exp2 if state=="19" & cohort>=1987 & cohort<=1996, d
return list
replace engl=1 if hrs_exp2>=r(p50) & state=="19"
sum hrs_exp2 if state=="25" & cohort>=1993 & cohort<=1996, d
return list
replace engl=1 if hrs_exp2>=r(p50) & state=="25"
sum hrs_exp2 if state=="26" & cohort>=1993 & cohort<=1996, d
return list
replace engl=1 if hrs_exp2>=r(p50) & state=="26"
sum hrs_exp2 if state=="28" & cohort>=1990 & cohort<=1996, d
return list
replace engl=1 if hrs_exp2>=r(p50) & state=="28"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1
*========================================================================*
/* TABLE A.1. Regression for main results: Domestic labor market */
*========================================================================*
/* Panel A: Full sample */
*========================================================================*
eststo clear
eststo: reghdfe student had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe formal_s had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe informal_s had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe inactive had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe labor had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe wpaid had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe lwage had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & labor==1, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe lwage had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & wpaid==1, absorb(cohort geo) vce(cluster geo)
esttab using "$doc\tabA1a.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2_a, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(had_policy) replace
*========================================================================*
/* Panel B: Men */
*========================================================================*
eststo clear
eststo: reghdfe student had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe formal_s had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe informal_s had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe inactive had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe labor had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe wpaid had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe lwage had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & labor==1 & female==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe lwage had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & wpaid==1 & female==0, absorb(cohort geo) vce(cluster geo)
esttab using "$doc\tabA1b.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2_a, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(had_policy) replace
*========================================================================*
/* Panel C: Women */
*========================================================================*
eststo clear
eststo: reghdfe student had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==1, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe formal_s had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==1, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe informal_s had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==1, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe inactive had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==1, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe labor had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==1, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe wpaid had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==1, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe lwage had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & labor==1 & female==1, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe lwage had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & wpaid==1 & female==1, absorb(cohort geo) vce(cluster geo)
esttab using "$doc\tabA1c.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2_a, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(had_policy) replace
*========================================================================*
/* Panel D: Low educational attainment */
*========================================================================*
eststo clear
eststo: reghdfe student had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & edu<12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe formal_s had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & edu<12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe informal_s had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & edu<12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe inactive had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & edu<12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe labor had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & edu<12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe wpaid had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & edu<12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe lwage had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & labor==1 & edu<12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe lwage had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & wpaid==1 & edu<12, absorb(cohort geo) vce(cluster geo)
esttab using "$doc\tabA1d.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2_a, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(had_policy) replace
*========================================================================*
/* Panel E: High educational attainment */
*========================================================================*
eststo clear
eststo: reghdfe student had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & edu>=12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe formal_s had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & edu>=12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe informal_s had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & edu>=12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe inactive had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & edu>=12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe labor had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & edu>=12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe wpaid had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & edu>=12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe lwage had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & labor==1 & edu>=12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe lwage had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & wpaid==1 & edu>=12, absorb(cohort geo) vce(cluster geo)
esttab using "$doc\tabA1e.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2_a, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(had_policy) replace

sum student formal_s informal_s inactive labor [fw=factor] if cohort>=1981 & cohort<=1994
sum wpaid lwage [fw=factor] if labor==1 & cohort>=1981 & cohort<=1994
sum lwage [fw=factor] if wpaid==1 & cohort>=1981 & cohort<=1994

*========================================================================*
/* TABLE A.2. Regression for main results: Migration analysis */
*========================================================================*
replace time_migra=0 if time_migra==. & migra_ret==1
*========================================================================*
/* Panel A: Full sample */
*========================================================================*
eststo clear
eststo: reghdfe dmigrant had_policy female migrant [aw=factor] if cohort>=1984 & cohort<=1994, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe migrant had_policy female [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe migra_ret had_policy female [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & migrant==1, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe dest_us had_policy female [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & migrant==1, absorb(cohort geo) vce(cluster geo)
esttab using "$doc\tabA2a.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2_a, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(had_policy) replace
*========================================================================*
/* Panel B: Men */
*========================================================================*
eststo clear
eststo: reghdfe dmigrant had_policy female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & female==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe migrant had_policy female [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe migra_ret had_policy female [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & migrant==1 & female==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe dest_us had_policy female [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & migrant==1 & female==0, absorb(cohort geo) vce(cluster geo)
esttab using "$doc\tabA2b.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2_a, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(had_policy) replace
*========================================================================*
/* Panel C: Women */
*========================================================================*
eststo clear
eststo: reghdfe dmigrant had_policy female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & female==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe migrant had_policy female [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe migra_ret had_policy female [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & migrant==1 & female==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe dest_us had_policy female [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & migrant==1 & female==0, absorb(cohort geo) vce(cluster geo)
esttab using "$doc\tabA2c.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2_a, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(had_policy) replace

sum dmigrant [fw=factor] if cohort>=1984 & cohort<=1994
sum migrant [fw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0
sum migra_ret dest_us [fw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & migrant==1