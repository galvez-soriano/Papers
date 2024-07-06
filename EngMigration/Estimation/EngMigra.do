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
*sum hrs_exp2, d
*return list
*gen engl=hrs_exp2>=r(p90)
drop lwage
gen lwage=log(wage+1)
replace wpaid=. if work==0
gen migra_ret=migrant==1 & conact!=.
replace dmigrant=0 if migrant==1

drop if imputed_state==1

/*tabstat migrant [fw=factor], by(state)
gen nmigra_states=state=="03" | state=="04" | state=="15" | state=="23" | state=="27"

gen migra_states=0
replace migra_states=1 if state=="01" | state=="08" | state=="10" ///
| state=="11" | state=="12" | state=="13" | state=="16" | state=="18" ///
| state=="20" | state=="22" | state=="32"

gen spolicy=state=="01" | state=="10" | state=="19" | state=="25" ///
 | state=="26" | state=="28"
*/

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
/*
order geo cohort had_policy
sort geo cohort
keep if cohort>=1984 & cohort<=1996
*/
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
eststo: reghdfe work had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe wpaid had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe lwage had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & work==1, absorb(cohort geo) vce(cluster geo)
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
eststo: reghdfe work had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe wpaid had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==0, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe lwage had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & work==1 & female==0, absorb(cohort geo) vce(cluster geo)
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
eststo: reghdfe work had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==1, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe wpaid had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & female==1, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe lwage had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & work==1 & female==1, absorb(cohort geo) vce(cluster geo)
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
eststo: reghdfe work had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & edu<12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe wpaid had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & edu<12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe lwage had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & work==1 & edu<12, absorb(cohort geo) vce(cluster geo)
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
eststo: reghdfe work had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & edu>=12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe wpaid had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & edu>=12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe lwage had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & work==1 & edu>=12, absorb(cohort geo) vce(cluster geo)
eststo: reghdfe lwage had_policy edu female migrant [aw=factor] if cohort>=1984 & cohort<=1994 & dmigrant==0 & wpaid==1 & edu>=12, absorb(cohort geo) vce(cluster geo)
esttab using "$doc\tabA1e.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2_a, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(had_policy) replace

sum student formal_s informal_s inactive work [fw=factor] if cohort>=1981 & cohort<=1996
sum wpaid lwage [fw=factor] if work==1 & cohort>=1981 & cohort<=1996
sum lwage [fw=factor] if wpaid==1 & cohort>=1981 & cohort<=1996

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
*========================================================================*
/* Figure 2. Even study graphs */
*========================================================================*
gen first_cohort=0
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

bysort geo cohort: gen treat2 = cohort == (first_cohort - 8)
bysort geo cohort: gen treat3 = cohort == (first_cohort - 7)
bysort geo cohort: gen treat4 = cohort == (first_cohort - 6)
bysort geo cohort: gen treat5 = cohort == (first_cohort - 5)
bysort geo cohort: gen treat6 = cohort == (first_cohort - 4)
bysort geo cohort: gen treat7 = cohort == (first_cohort - 3)
bysort geo cohort: gen treat8 = cohort == (first_cohort - 2)
bysort geo cohort: gen treat9 = cohort == (first_cohort - 1)
bysort geo cohort: gen treat10 = cohort == first_cohort
bysort geo cohort: gen treat11 = cohort == (first_cohort + 1)
bysort geo cohort: gen treat12 = cohort == (first_cohort + 2)
bysort geo cohort: gen treat13 = cohort == (first_cohort + 3)
bysort geo cohort: gen treat14 = cohort == (first_cohort + 4)
bysort geo cohort: gen treat15 = cohort == (first_cohort + 5)
bysort geo cohort: gen treat16 = cohort == (first_cohort + 6)
bysort geo cohort: gen treat17 = cohort == (first_cohort + 7)
bysort geo cohort: gen treat18 = cohort == (first_cohort + 8)

replace treat9=0

label var treat2 "-8"
label var treat3 "-7"
label var treat4 "-6"
label var treat5 "-5"
label var treat6 "-4"
label var treat7 "-3"
label var treat8 "-2"
label var treat9 "-1"
foreach x in 0 1 2 3 4 5 6 7 8 {
	label var treat1`x' "`x'"
}

drop treat2 treat3 treat17 treat18
/*
reghdfe hlengua treat* edu female migrant if cohort>=1984 & cohort<=1994 [aw=factor], absorb(cohort geo) vce(cluster geo)

coefplot, ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking an indigenous language", size(medium) height(5)) ///
ylabel(-0.04(0.02)0.04, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(off) ///
ysc(r(-0.04 0.04)) recast(connected)
graph export "$doc\PTA_speakIndLang.png", replace
*/
reghdfe student treat* if cohort>=1984 & cohort<=1994 & dmigrant==0 ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store stud_ss
reghdfe student treat* edu female migrant if cohort>=1984 & cohort<=1994 & dmigrant==0 ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store stud_ssc

coefplot ///
(stud_ss, label(Sample without controls) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(ltblue)) lc(ltblue)) ///
(stud_ssc, offset(-0.1) label(Sample with controls) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being enrolled in school", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(pos(5) ring(0) col(1) region(lcolor(white)) size(medium)) ///
ysc(r(-0.1 0.1)) recast(connected)
graph export "$doc\PTA_SDD1.png", replace

reghdfe formal_s treat* if cohort>=1984 & cohort<=1994 & dmigrant==0 ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store formal_ss
reghdfe formal_s treat* edu female migrant if cohort>=1984 & cohort<=1994 & dmigrant==0 ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store formal_ssc

coefplot ///
(formal_ss, label(Sample without controls) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(ltblue)) lc(ltblue)) ///
(formal_ssc, offset(-0.1) label(Sample with controls) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having a formal job", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(off) ///
ysc(r(-0.1 0.1)) recast(connected)
graph export "$doc\PTA_SDD2.png", replace

reghdfe informal_s treat* if cohort>=1984 & cohort<=1994 & dmigrant==0 ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store informal_ss
reghdfe informal_s treat* edu female migrant if cohort>=1984 & cohort<=1994 & dmigrant==0 ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store informal_ssc

coefplot ///
(informal_ss, label(Sample without controls) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(ltblue)) lc(ltblue)) ///
(informal_ssc, offset(-0.1) label(Sample with controls) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having an informal job", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(off) ///
ysc(r(-0.1 0.1)) recast(connected)
graph export "$doc\PTA_SDD3.png", replace

reghdfe inactive treat* if cohort>=1984 & cohort<=1994 & dmigrant==0 ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store inactive_ss
reghdfe inactive treat* edu female migrant if cohort>=1984 & cohort<=1994 & dmigrant==0 ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store inactive_ssc

coefplot ///
(inactive_ss, label(Sample without controls) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(ltblue)) lc(ltblue)) ///
(inactive_ssc, offset(-0.1) label(Sample with controls) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being inactive", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(off) ///
ysc(r(-0.1 0.1)) recast(connected)
graph export "$doc\PTA_SDD4.png", replace

reghdfe work treat* if cohort>=1984 & cohort<=1994 & dmigrant==0 ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store work_ss
reghdfe work treat* edu female migrant if cohort>=1984 & cohort<=1994 & dmigrant==0 ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store work_ssc

coefplot ///
(work_ss, label(Sample without controls) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(ltblue)) lc(ltblue)) ///
(work_ssc, offset(-0.1) label(Sample with controls) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being employed", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(off) ///
ysc(r(-0.1 0.1)) recast(connected)
graph export "$doc\PTA_SDD5.png", replace

reghdfe lwage treat* if cohort>=1984 & cohort<=1994 & dmigrant==0 ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store wage_ss
reghdfe lwage treat* edu female migrant if cohort>=1984 & cohort<=1994 & dmigrant==0 ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store wage_ssc

coefplot ///
(wage_ss, label(Sample without controls) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(ltblue)) lc(ltblue)) ///
(wage_ssc, offset(-0.1) label(Sample with controls) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(off) ///
ysc(r(-0.5 0.5)) recast(connected)
graph export "$doc\PTA_SDD6.png", replace

*========================================================================*
/* Figure 3. Even study graphs */
*========================================================================*
*replace time_migra=0 if time_migra==. & migra_ret==1

reghdfe dmigrant treat* if cohort>=1984 & cohort<=1994 ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store dmigrant_ss
reghdfe dmigrant treat* female migrant if cohort>=1984 & cohort<=1994 ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store dmigrant_ssc

coefplot ///
(dmigrant_ss, label(Sample without controls) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(ltblue)) lc(ltblue)) ///
(dmigrant_ssc, offset(-0.1) label(Sample with controls) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being a domestic migrant", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(pos(5) ring(0) col(1) region(lcolor(white)) size(medium)) ///
ysc(r(-0.2 0.2)) recast(connected)
graph export "$doc\PTA_SDD7.png", replace
*========================================================================*
reghdfe migrant treat* if cohort>=1984 & cohort<=1994 & dmigrant==0 ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store migrant_ss
reghdfe migrant treat* female if cohort>=1984 & cohort<=1994 & dmigrant==0 ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store migrant_ssc

coefplot ///
(migrant_ss, label(Sample without controls) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(ltblue)) lc(ltblue)) ///
(migrant_ssc, offset(-0.1) label(Sample with controls) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being an international migrant", size(medium) height(5)) ///
ylabel(-0.04(0.02)0.04, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(off) ///
ysc(r(-0.04 0.04)) recast(connected)
graph export "$doc\PTA_SDD8.png", replace

reghdfe migra_ret treat* if cohort>=1984 & cohort<=1994 & migrant==1 & dmigrant==0  ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store migrar_ss
reghdfe migra_ret treat* female if cohort>=1984 & cohort<=1994 & migrant==1 & dmigrant==0  ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store migrar_ssc

coefplot ///
(migrar_ss, label(Sample without controls) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(ltblue)) lc(ltblue)) ///
(migrar_ssc, offset(-0.1) label(Sample with controls) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of returning to Mexico after migration", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(off) ///
ysc(r(-1 1)) recast(connected)
graph export "$doc\PTA_SDD9.png", replace

reghdfe dest_us treat* if cohort>=1984 & cohort<=1994 & migrant==1 & dmigrant==0  ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store destus_ss
reghdfe dest_us treat* female if cohort>=1984 & cohort<=1994 & migrant==1 & dmigrant==0  ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store destus_ssc

coefplot ///
(destus_ss, label(Sample without controls) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(ltblue)) lc(ltblue)) ///
(destus_ssc, offset(-0.1) label(Sample with controls) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of migrating to the US", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(off) ///
ysc(r(-1 1)) recast(connected)
graph export "$doc\PTA_SDD10.png", replace
/*
reghdfe time_migra treat* if cohort>=1984 & cohort<=1994 & migrant==1 & dmigrant==0  ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store tmigra_ss
reghdfe time_migra treat* female if cohort>=1984 & cohort<=1994 & migrant==1 & dmigrant==0  ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store tmigra_ssc

coefplot ///
(tmigra_ss, label(Sample without controls) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(ltblue)) lc(ltblue)) ///
(tmigra_ssc, offset(-0.1) label(Sample with controls) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Migration length (months)", size(medium) height(5)) ///
ylabel(-30(15)30, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(off) ///
ysc(r(-30 30)) recast(connected)
graph export "$doc\PTA_SDD11.png", replace
*/
*========================================================================*
/* Freyaldenhoven, Hansen, and Shapiro (2019) */
*========================================================================*

destring geo, replace
/*
xtevent migrant if cohort>=1984 & cohort<=1994 & dmigrant==0 [aw=factor], ///
repeatedcs policyvar(had_policy) panelvar(geo) timevar(cohort) window(6) impute(nuchange)

xteventplot, ///
    xtitle("Cohorts since policy intervention") ///
    ytitle("Likelihood of being an international migrant") ///
    ylabel(-0.005(0.0025)0.005) ///
    xlabel(, angle(vertical)) ///
    scatterplotopts(recast(connected) msymbol(circle))
graph export "PTA_SDD8b.png", replace
*/
xtevent dmigrant female migrant if cohort>=1984 & cohort<=1994 [aw=factor], ///
repeatedcs policyvar(had_policy) panelvar(geo) timevar(cohort) window(5) ///
impute(nuchange) vce(cluster geo)

xteventplot, ///
    xtitle("Cohorts since policy intervention") ///
    ytitle("Likelihood of being a domestic migrant") ///
    ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.1f)) ///
    xlabel(-6(1)6, angle(vertical)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
    scatterplotopts(recast(connected) msymbol(O) mcolor(navy) lc(navy)) ///
	ciplotopts(lc(navy) recast(rcap)) noprepval nopostpval
graph export "$doc\PTA_SDD7b.png", replace

xtevent migrant female if cohort>=1984 & cohort<=1994 & dmigrant==0 [aw=factor], ///
repeatedcs policyvar(had_policy) panelvar(geo) timevar(cohort) window(5) ///
impute(nuchange) vce(cluster geo) 

xteventplot, ///
    xtitle("Cohorts since policy intervention") ///
    ytitle("Likelihood of being an international migrant") ///
    ylabel(-0.03(0.015)0.03, labs(medium) grid format(%5.3f)) ///
    xlabel(-6(1)6, angle(vertical)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
    scatterplotopts(recast(connected) msymbol(O) mcolor(navy) lc(navy)) ///
	ciplotopts(lc(navy) recast(rcap)) noprepval nopostpval
graph export "$doc\PTA_SDD8b.png", replace

xtevent migra_ret female if cohort>=1984 & cohort<=1994 & dmigrant==0 & migrant==1 [aw=factor], ///
repeatedcs policyvar(had_policy) panelvar(geo) timevar(cohort) window(5) ///
impute(nuchange) vce(cluster geo) 

xteventplot, ///
    xtitle("Cohorts since policy intervention") ///
    ytitle("Likelihood of returning to Mexico after migration") ///
    ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
    xlabel(-6(1)6, angle(vertical)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
    scatterplotopts(recast(connected) msymbol(O) mcolor(navy) lc(navy)) ///
	ciplotopts(lc(navy) recast(rcap)) noprepval nopostpval
graph export "$doc\PTA_SDD9b.png", replace

xtevent dest_us female if cohort>=1984 & cohort<=1994 & dmigrant==0 & migrant==1 [aw=factor], ///
repeatedcs policyvar(had_policy) panelvar(geo) timevar(cohort) window(5) ///
impute(nuchange) vce(cluster geo) 

xteventplot, ///
    xtitle("Cohorts since policy intervention") ///
    ytitle("LLikelihood of migrating to the US") ///
    ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
    xlabel(-6(1)6, angle(vertical)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
    scatterplotopts(recast(connected) msymbol(O) mcolor(navy) lc(navy)) ///
	ciplotopts(lc(navy) recast(rcap)) noprepval nopostpval
graph export "$doc\PTA_SDD10b.png", replace















*========================================================================*
/* Sun and Abraham (2021) */
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

destring state, replace

eventstudyinteract migrant had_policy if cohort>=1984 & cohort<=1994 & ///
dmigrant==0 [aw=factor], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(female) ///
vce(cluster geo)

*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid migrant female if cohort>=1984 & cohort<=1994 & ///
dmigrant==0 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all

*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt dmigrant geo cohort had_policy if cohort>=1984 & cohort<=1994, ///
weight(factor) robust_dynamic dynamic(6) placebo(5) breps(30) ///
cluster(geo) controls(female)

did_multiplegt migrant geo cohort had_policy if cohort>=1984 & cohort<=1994 & ///
dmigrant==0, weight(factor) robust_dynamic dynamic(6) placebo(5) breps(30) ///
cluster(geo) controls(female)

did_multiplegt migra_ret geo cohort had_policy if cohort>=1984 & cohort<=1994 & ///
dmigrant==0 & migrant==1, weight(factor) robust_dynamic dynamic(6) placebo(3) breps(30) ///
cluster(geo) controls(female)

did_multiplegt dest_us geo cohort had_policy if cohort>=1984 & cohort<=1994 & ///
dmigrant==0 & migrant==1, weight(factor) robust_dynamic dynamic(6) placebo(3) breps(30) ///
cluster(geo) controls(female)

sum dmigrant [fw=factor] if cohort>=1984 & cohort<=1994
sum migrant [fw=factor] if dmigrant==0 & cohort>=1984 & cohort<=1994
sum migra_ret dest_us [fw=factor] if dmigrant==0 & migrant==1 & cohort>=1984 & cohort<=1994
*========================================================================*
/* Panel B: Men */
*========================================================================*
did_multiplegt dmigrant geo cohort had_policy if cohort>=1984 & cohort<=1994 & ///
female==0, weight(factor) robust_dynamic dynamic(6) placebo(5) breps(30) ///
cluster(geo) 

did_multiplegt migrant geo cohort had_policy if cohort>=1984 & cohort<=1994 & ///
dmigrant==0 & female==0, weight(factor) robust_dynamic dynamic(6) placebo(5) ///
breps(30) cluster(geo) 

did_multiplegt migra_ret geo cohort had_policy if cohort>=1984 & cohort<=1994 & ///
dmigrant==0 & migrant==1 & female==0, weight(factor) robust_dynamic dynamic(6) ///
placebo(3) breps(30) cluster(geo) 

did_multiplegt dest_us geo cohort had_policy if cohort>=1984 & cohort<=1994 & ///
dmigrant==0 & migrant==1 & female==0, weight(factor) robust_dynamic dynamic(6) ///
placebo(3) breps(30) cluster(geo) 

sum dmigrant if cohort>=1984 & cohort<=1994 & female==0
sum migrant if dmigrant==0 & cohort>=1984 & cohort<=1994 & female==0
sum migra_ret dest_us if dmigrant==0 & migrant==1 & cohort>=1984 & cohort<=1994 & female==0
*========================================================================*
/* Panel C: Women */
*========================================================================*
did_multiplegt dmigrant geo cohort had_policy if cohort>=1984 & cohort<=1994 & ///
female==1, weight(factor) robust_dynamic dynamic(6) placebo(5) breps(30) ///
cluster(geo) 

did_multiplegt migrant geo cohort had_policy if cohort>=1984 & cohort<=1994 & ///
dmigrant==0 & female==1, weight(factor) robust_dynamic dynamic(6) placebo(5) ///
breps(30) cluster(geo) 

did_multiplegt migra_ret geo cohort had_policy if cohort>=1984 & cohort<=1994 & ///
dmigrant==0 & migrant==1 & female==1, weight(factor) robust_dynamic dynamic(6) ///
placebo(3) breps(30) cluster(geo) 

did_multiplegt dest_us geo cohort had_policy if cohort>=1984 & cohort<=1994 & ///
dmigrant==0 & migrant==1 & female==1, weight(factor) robust_dynamic dynamic(6) ///
placebo(3) breps(30) cluster(geo) 

sum dmigrant if cohort>=1984 & cohort<=1994 & female==1
sum migrant if dmigrant==0 & cohort>=1984 & cohort<=1994 & female==1
sum migra_ret dest_us if dmigrant==0 & migrant==1 & cohort>=1984 & cohort<=1994 & female==1

*========================================================================*
/* Borusyak, Jaravel, and Spiess (2023) */
*========================================================================*
replace first_cohort=1997 if first_cohort==0
did_imputation migrant geo cohort first_cohort if dmigrant==0 [aw=factor], ///
controls(female) fe(geo cohort) cluster(geo) autos















*========================================================================*
/* Event study graphs: Callaway and SantAnna (2021) */ 
*========================================================================*
destring geo, replace

csdid student rural female migrant edu if cohort>=1981 & cohort<=1996 & dmigrant==0 ///
[iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 8) estore(student)

coefplot student, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of being enrolled in school", size(medium) height(5)) ///
ylabel(-0.20(0.10)0.20, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.20 0.20)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD1.png", replace

csdid formal_s rural female migrant edu if cohort>=1981 & cohort<=1996 & dmigrant==0 ///
[iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 8) estore(formal_s)

coefplot formal_s, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of having a formal job", size(medium) height(5)) ///
ylabel(-0.2(0.10)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD2.png", replace

csdid informal_s rural female migrant edu if cohort>=1981 & cohort<=1996 & dmigrant==0 ///
[iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 8) estore(informal_s)

coefplot informal_s, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of having an informal job", size(medium) height(5)) ///
ylabel(-0.2(0.10)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD3.png", replace

csdid inactive rural female migrant edu if cohort>=1981 & cohort<=1996 & dmigrant==0 ///
[iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 8) estore(inactive)

coefplot inactive, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of being inactive", size(medium) height(5)) ///
ylabel(-0.2(0.10)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD4.png", replace

csdid work rural female migrant edu if cohort>=1981 & cohort<=1996 & dmigrant==0 ///
[iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 8) estore(work)

coefplot work, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of being employed", size(medium) height(5)) ///
ylabel(-0.2(0.10)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD5.png", replace

csdid lwage rural female migrant edu if cohort>=1981 & cohort<=1996 & work==1 & dmigrant==0 ///
[iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 8) estore(lwage)

coefplot lwage, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Percentage change of wages", size(medium) height(5)) ///
ylabel(-0.5(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD6.png", replace






*========================================================================*
/* Regression for main results: Callaway and SantAnna (2021) */
*========================================================================*
csdid student rural female migrant edu if cohort>=1981 & cohort<=1996 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid formal_s rural female migrant edu if cohort>=1981 & cohort<=1996 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid informal_s rural female migrant edu if cohort>=1981 & cohort<=1996 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all 
csdid inactive rural female migrant edu if cohort>=1981 & cohort<=1996 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid work rural female migrant edu if cohort>=1981 & cohort<=1996 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid wpaid rural female migrant edu if cohort>=1981 & cohort<=1996 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid lwage rural female migrant edu if work==1 & cohort>=1981 & cohort<=1996 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid lwage rural female migrant edu if wpaid==1 & cohort>=1981 & cohort<=1996 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
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


*========================================================================*
/* Event study graphs: Callaway and SantAnna (2021) */
*========================================================================*
csdid migrant rural female if cohort>=1981 & cohort<=1996 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 8) estore(migrant)

coefplot migrant, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of migrate abroad", size(medium) height(5)) ///
ylabel(-0.05(0.025)0.05, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.05 0.05)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD7.png", replace

csdid migra_ret rural female if migrant==1 & cohort>=1981 & cohort<=1996 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 8) estore(migra_ret)

coefplot migra_ret, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of returning to Mexico after migration", size(medium) height(5)) ///
ylabel(-0.8(0.4)0.8, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.8 0.8)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD8.png", replace

csdid dest_us rural female if migra_ret==1 & cohort>=1981 & cohort<=1996 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 8) estore(dest_us)

coefplot dest_us, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of migrating to the US", size(medium) height(5)) ///
ylabel(-2(1)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-2 1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD9.png", replace

csdid time_migra rural female if migra_ret==1 & cohort>=1981 & cohort<=1996 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 8) estore(time_migra)

coefplot time_migra, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Migration length  (months)", size(medium) height(5)) ///
ylabel(-40(20)40, labs(medium) grid format(%5.0f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-40 40)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD10.png", replace
*========================================================================*
/* Regression for main results: Migration analysis
Callaway and SantAnna (2021) */
*========================================================================*
csdid migrant rural female if cohort>=1981 & cohort<=1996 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid migra_ret rural female if migrant==1 & cohort>=1981 & cohort<=1996 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid dest_us rural female if migra_ret==1 & cohort>=1981 & cohort<=1996 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid time_migra rural female if migra_ret==1 & cohort>=1981 & cohort<=1996 [iw=factor], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all

sum migrant [fw=factor] if cohort>=1981 & cohort<=1996
sum migra_ret lwage [fw=factor] if migrant==1 & cohort>=1981 & cohort<=1996
sum dest_us time_migra [fw=factor] if migra_ret==1 & cohort>=1981 & cohort<=1996
*========================================================================*
/* Are English speaker migrants less likely to return? No, women are more 
likely to return. Explore why. */
*========================================================================*

areg migra_ret had_policy rural female i.cohort if migrant==1 & female==0 [aw=factor], absorb(geo) vce(cluster geo)
areg migra_ret had_policy rural female i.cohort if migrant==1 & female==1 [aw=factor], absorb(geo) vce(cluster geo)


/* Do English programs affect migration at the state level? */

areg migra_states had_policy rural female edu spolicy [aw=factor], absorb(cohort) vce(cluster geo)


areg migrant had_policy rural female edu i.cohort if migra_states==1 [aw=factor], absorb(geo) vce(cluster geo)
*========================================================================*
/* Length of migration */
*========================================================================*

replace time_migra=0 if time_migra==. & migra_ret==1

areg time_migra had_policy rural female edu i.cohort if migra_ret==1 [aw=factor], absorb(geo) vce(cluster geo)
areg time_migra had_policy rural female edu i.cohort if migra_ret==1 & female==1 [aw=factor], absorb(geo) vce(cluster geo)
areg time_migra had_policy rural female edu i.cohort if migra_ret==1 & female==0 [aw=factor], absorb(geo) vce(cluster geo)

*========================================================================*
/* Diversification */
*========================================================================*

areg dest_us had_policy rural edu female i.cohort if migra_ret==1 & female==1 [aw=factor], absorb(geo) vce(cluster geo)
areg dest_us had_policy rural edu female i.cohort if migra_ret==1 & female==0 [aw=factor], absorb(geo) vce(cluster geo)

*========================================================================*
/* Timing of migration */
*========================================================================*



*========================================================================*
/* Jobs classifications */
*========================================================================*
use "$data\census20.dta", clear

merge m:m geo cohort using "$base\exposure_mun.dta"
drop if _merge!=3
drop _merge
replace actividades_c=. if actividades_c==9999

merge m:m geo using "$base\p_stud.dta"
drop _merge

drop if geo=="19041"

gen econ_act=.
replace econ_act=1 if actividades_c<=1199
replace econ_act=2 if (actividades_c>1199 & actividades_c<=2399) | ///
(actividades_c>4699 & actividades_c<=4930)
replace econ_act=3 if actividades_c>2399 & actividades_c<=3399
replace econ_act=4 if actividades_c>3399 & actividades_c<=4699
replace econ_act=5 if (actividades_c>5399 & actividades_c<=5622) | ///
(actividades_c>7223 & actividades_c<=8140) | (actividades_c>5199 & actividades_c<=5399)
replace econ_act=6 if (actividades_c>5622 & actividades_c<=6299) | ///
(actividades_c>8140 & actividades_c!=.)
replace econ_act=7 if (actividades_c>6299 & actividades_c<=7223) | ///
(actividades_c>4930 & actividades_c<=5199)

label define econ_act 1 "Agriculture" 2 "Construction" 3 "Manufactures" 4 "Commerce" ///
5 "Professionals" 6 "Government" 7 "Hospitality and Entertainment"
label values econ_act econ_act

gen ag_ea=1 if econ_act==1
replace ag_ea=0 if econ_act!=1 & econ_act!=.
gen cons_ea=1 if econ_act==2
replace cons_ea=0 if econ_act!=2 & econ_act!=.
gen manu_ea=1 if econ_act==3
replace manu_ea=0 if econ_act!=3 & econ_act!=.
gen comm_ea=1 if econ_act==4
replace comm_ea=0 if econ_act!=4 & econ_act!=.
gen pro_ea=1 if econ_act==5
replace pro_ea=0 if econ_act!=5 & econ_act!=.
gen gov_ea=1 if econ_act==6
replace gov_ea=0 if econ_act!=6 & econ_act!=.
gen hosp_ea=1 if econ_act==7
replace hosp_ea=0 if econ_act!=7 & econ_act!=.

gen occup=.
replace occup=1 if ocupacion_c>=610 & ocupacion_c<=699
replace occup=2 if ocupacion_c>=411 & ocupacion_c<=499
replace occup=3 if ocupacion_c>=510 & ocupacion_c<=541
replace occup=4 if ocupacion_c>=710 & ocupacion_c<=799
replace occup=5 if ocupacion_c>=911 & ocupacion_c<=989
replace occup=6 if ocupacion_c>=810 & ocupacion_c<=899
replace occup=7 if ocupacion_c>=111 & ocupacion_c<=399

label define occup 1 "Agriculture" 2 "Commerce" ///
3 "Services" 4 "Crafts" 5 "Manual work" ///
6 "Skilled job" 7 "Professional" 
label values occup occup

gen ag_o=1 if occup==1
replace ag_o=0 if occup!=1 & occup!=.
gen com_o=1 if occup==2
replace com_o=0 if occup!=2 & occup!=.
gen ser_o=1 if occup==3
replace ser_o=0 if occup!=3 & occup!=.
gen cft_o=1 if occup==4
replace cft_o=0 if occup!=4 & occup!=.
gen man_o=1 if occup==5
replace man_o=0 if occup!=5 & occup!=.
gen skil_o=1 if occup==6
replace skil_o=0 if occup!=6 & occup!=.
gen prof_o=1 if occup==7
replace prof_o=0 if occup!=7 & occup!=.
*======== Economic activities ========*
/* Full sample */
eststo clear
eststo: areg ag_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Low enrollment sample */
eststo clear
eststo: areg ag_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_low.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Men */
eststo clear
eststo: areg ag_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Women */
eststo clear
eststo: areg ag_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
*============ Occupations ============*
/* Full sample */
eststo clear
eststo: areg ag_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg man_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg skil_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Low enrollment sample */
eststo clear
eststo: areg ag_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg man_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg skil_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup_low.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Men */
eststo clear
eststo: areg ag_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg man_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg skil_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Women */
eststo clear
eststo: areg ag_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg man_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg skil_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
*========================================================================*
/* Table occupations and Multinomial Logit */
*========================================================================*
tab occup [fw=factor]
table occup [fw=factor], c(mean edu mean wage mean formal)

*set mat 11000
destring state, replace
eststo clear
* All
eststo: mlogit occup hrs_exp rural female age formal i.cohort i.state [aw=factor], vce(cluster geo) base(5) rrr
* Men
eststo: mlogit occup hrs_exp rural female age formal i.cohort i.state if female==0 [aw=factor], vce(cluster geo) base(5) rrr
* Female
eststo: mlogit occup hrs_exp rural female age formal i.cohort i.state if female==1 [aw=factor], vce(cluster geo) base(5) rrr
* Formal
eststo: mlogit occup hrs_exp rural female age formal i.cohort i.state if formal==1 [aw=factor], vce(cluster geo) base(5) rrr
* Informal
eststo: mlogit occup hrs_exp rural female age formal i.cohort i.state if formal==0 [aw=factor], vce(cluster geo) base(5) rrr
esttab using "$doc\tab_occup_multi_logit.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(Census estimations) ///
keep(hrs_exp) replace

/*quietly mlogit occup hrs_exp rural female age i.cohort i.geo [aw=factor], vce(cluster geo) base(5) rrr
estimates table, keep(hrs_exp)*/

*========================================================================*
/* Indigenous regressions */
*========================================================================*
gen uilanguage=hlengua==1 | elengua==1

areg indigenous had_policy rural female migrant edu i.cohort [aw=factor] if cohort>=1981 & cohort<=1996 & dmigrant==0, absorb(geo) vce(cluster geo)
areg hlengua had_policy rural female migrant edu i.cohort [aw=factor] if cohort>=1981 & cohort<=1996 & dmigrant==0, absorb(geo) vce(cluster geo)
areg elengua had_policy rural female migrant edu i.cohort [aw=factor] if cohort>=1981 & cohort<=1996 & dmigrant==0, absorb(geo) vce(cluster geo)
areg uilanguage had_policy rural female migrant edu i.cohort [aw=factor] if cohort>=1981 & cohort<=1996 & dmigrant==0, absorb(geo) vce(cluster geo)

areg hlengua had_policy rural female migrant edu i.cohort [aw=factor] if cohort>=1981 & cohort<=1996 & dmigrant==0 & female==0, absorb(geo) vce(cluster geo)
areg hlengua had_policy rural female migrant edu i.cohort [aw=factor] if cohort>=1981 & cohort<=1996 & dmigrant==0 & female==1, absorb(geo) vce(cluster geo)