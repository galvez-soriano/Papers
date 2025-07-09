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
/* TABLE 2: Returns to English abilities in Mexico */
*========================================================================*
use "$data/eng_abil.dta", clear
drop if state=="05" | state=="17"
keep if cohort>=1984 & cohort<=1994
keep if biare==1
destring state, replace
*========================================================================*
/* Panel A: Full sample */
*========================================================================*
eststo clear
eststo: reg lwage eng [aw=weight] if paidw==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if ///
paidw==1, vce(cluster geo)
eststo: areg lwage eng female indigenous i.edu [aw=weight] if ///
paidw==1, absorb(cohort) vce(cluster geo)
eststo: areg lwage eng female indigenous i.edu i.cohort married ///
[aw=weight] if paidw==1, absorb(state) vce(cluster geo)
eststo: areg lwage eng female indigenous i.edu i.cohort married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu<12, vce(cluster geo)
eststo: areg lwage eng female indigenous i.edu i.cohort married ///
[aw=weight] if paidw==1 & edu<12, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu>=12, vce(cluster geo)
eststo: areg lwage eng female indigenous i.edu i.cohort married ///
[aw=weight] if paidw==1 & edu>=12, absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_A.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Panel B: Men */
*========================================================================*
eststo clear
eststo: reg lwage eng [aw=weight] if paidw==1 & female==0, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if ///
paidw==1 & female==0, vce(cluster geo)
eststo: areg lwage eng female indigenous i.edu [aw=weight] if ///
paidw==1 & female==0, absorb(cohort) vce(cluster geo)
eststo: areg lwage eng female indigenous i.edu i.cohort married ///
[aw=weight] if paidw==1 & female==0, absorb(state) vce(cluster geo)
eststo: areg lwage eng female indigenous i.edu i.cohort married ///
[aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu<12 & female==0, vce(cluster geo)
eststo: areg lwage eng female indigenous i.edu i.cohort married ///
[aw=weight] if paidw==1 & edu<12 & female==0, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu>=12 & female==0, vce(cluster geo)
eststo: areg lwage eng female indigenous i.edu i.cohort married ///
[aw=weight] if paidw==1 & edu>=12 & female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_B.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Panel C: Women */
*========================================================================*
eststo clear
eststo: reg lwage eng [aw=weight] if paidw==1 & female==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if ///
paidw==1 & female==1, vce(cluster geo)
eststo: areg lwage eng female indigenous i.edu [aw=weight] if ///
paidw==1 & female==1, absorb(cohort) vce(cluster geo)
eststo: areg lwage eng female indigenous i.edu i.cohort married ///
[aw=weight] if paidw==1 & female==1, absorb(state) vce(cluster geo)
eststo: areg lwage eng female indigenous i.edu i.cohort married ///
[aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu<12 & female==1, vce(cluster geo)
eststo: areg lwage eng female indigenous i.edu i.cohort married ///
[aw=weight] if paidw==1 & edu<12 & female==1, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu>=12 & female==1, vce(cluster geo)
eststo: areg lwage eng female indigenous i.edu i.cohort married ///
[aw=weight] if paidw==1 & edu>=12 & female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_C.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Difference in estimate by gender */
*========================================================================*
gen eng_female=eng*female

eststo clear
eststo: reg lwage eng_female eng female [aw=weight] if paidw==1, vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous [aw=weight] if ///
paidw==1, absorb(cohort) vce(cluster geo)
eststo: areg lwage eng_female eng female indigenous i.edu [aw=weight] if ///
paidw==1, absorb(cohort) vce(cluster geo)
eststo: areg lwage eng_female eng female indigenous i.edu i.cohort married ///
[aw=weight] if paidw==1, absorb(state) vce(cluster geo)
eststo: areg lwage eng_female eng female indigenous i.edu i.cohort married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng_female eng female [aw=weight] if paidw==1 & edu<12, vce(cluster geo)
eststo: areg lwage eng_female eng female indigenous i.edu i.cohort married ///
[aw=weight] if paidw==1 & edu<12, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng_female eng female [aw=weight] if paidw==1 & edu>=12, vce(cluster geo)
eststo: areg lwage eng_female eng female indigenous i.edu i.cohort married ///
[aw=weight] if paidw==1 & edu>=12, absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_diff.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(eng_female) replace
/* Difference in estimate by education (female) */
dis (0.548+0.567)/sqrt((0.796^2)+(0.422^2))
*========================================================================*
/* TABLE 3. English programs and robustness in the presence of heterogeneous 
treatment effects */
*========================================================================*
clear
clear matrix
clear mata
set maxvar 120000
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
keep if cohort>=1984 & cohort<=1994
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

tab state, generate(dstate)
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 {
	foreach z in 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 ///
	1993 1994 {
gen c_state`z'_`x'=0
replace c_state`z'_`x'=1 if dstate`x'==1 & cohort==`z'
}
}

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1
*========================================================================*
/* Panel A: Canonical TWFE */
*========================================================================*
destring state, replace
eststo clear
eststo: reghdfe hrs_exp had_policy edu female if cohort>=1984 & cohort<=1994 ///
& paidw==1 [aw=weight], absorb(cohort geo state#cohort) vce(cluster geo)
eststo: reghdfe eng had_policy edu female if cohort>=1984 & cohort<=1994 ///
& paidw==1 [aw=weight], absorb(cohort geo state#cohort) vce(cluster geo)
eststo: reghdfe lwage had_policy i.cohort edu female if cohort>=1984 & cohort<=1994 ///
& paidw==1 [aw=weight], absorb(cohort geo state#cohort) vce(cluster geo)
eststo: reghdfe paidw had_policy edu female if cohort>=1984 & cohort<=1994 ///
[aw=weight], absorb(cohort geo state#cohort) vce(cluster geo)
esttab using "$doc\tab3A.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N r2_a, fmt(%9.0fc %9.3f)) replace

sum hrs_exp eng lwage [aw=weight] if cohort>=1984 & cohort<=1994 ///
& paidw==1
sum paidw [aw=weight] if cohort>=1984 & cohort<=1994
tostring state, replace format(%02.0f) force
*========================================================================*
/* Panel B: Sun and Abraham (2021) */
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

eventstudyinteract hrs_exp had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female state#cohort) ///
vce(cluster geo)
eventstudyinteract eng had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female state#cohort) ///
vce(cluster geo)
eventstudyinteract lwage had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female state#cohort) ///
vce(cluster geo)
eventstudyinteract paidw had_policy [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female state#cohort) ///
vce(cluster geo)
*========================================================================*
/* Panel C: Callaway and SantAnna (2021) */
*========================================================================*
csdid hrs_exp female edu if paidw==1 ///
[iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid eng female edu if paidw==1 ///
[iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid lwage female edu if paidw==1 ///
[iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all 
csdid paidw female edu ///
[iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
*========================================================================*
/* Panel D: de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
clear
clear matrix
clear mata
set maxvar 120000
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
gen engl=hrs_exp>=r(p90)

tab state, generate(dstate)
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 {
	foreach z in 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 ///
	1993 1994 {
gen c_state`z'_`x'=0
replace c_state`z'_`x'=1 if dstate`x'==1 & cohort==`z'
}
}

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

destring geo, replace

did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*) firstdiff_placebo
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*) firstdiff_placebo
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*) firstdiff_placebo
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*) firstdiff_placebo
*========================================================================*
/* Panel E: Borusyak, Jaravel, and Spiess (2023) */
*========================================================================*
keep if cohort>=1984 & cohort<=1994
gen first_cohort=1997
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

gen dmigrant=state!=state5
destring geo state, replace

eststo clear
eststo: did_imputation hrs_exp geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation eng geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation lwage geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation paidw geo cohort first_cohort [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
esttab using "$doc\tab3_D.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Heterogeneous effects) keep(tau) ///
stats(N, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* FIGURE 1. English programs, exposure, English skills, and wages 
To do the pre-trends test, change pretrend(6) for pretrend(2) and
uncomment the "di e(pre_p)" line code */
*========================================================================*
did_imputation hrs_exp geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_hrs
*di  e(pre_p)
did_imputation eng geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_Eng
*di  e(pre_p)
did_imputation lwage geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_wage
*di  e(pre_p)
did_imputation paidw geo cohort first_cohort [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_paid
*di  e(pre_p)
*========================================================================*
/* Panel (a) */
*========================================================================*
event_plot bjs_hrs, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_hrsEng.png", replace
*========================================================================*
/* Panel (b) */
*========================================================================*
event_plot bjs_Eng, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_Eng.png", replace
*========================================================================*
/* Panel (c) */
*========================================================================*
event_plot bjs_wage, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_Wage.png", replace
*========================================================================*
/* Panel (d) */
*========================================================================*
event_plot bjs_paid, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_Paid.png", replace

/* Goodman-Bacon decomposition */
twowayfeweights hrs_exp geo cohort had_policy if paidw==1, type(feTR) ///
weight(weight) controls(female edu c_state*)
twowayfeweights eng geo cohort had_policy if paidw==1, type(feTR) ///
weight(weight) controls(female edu c_state*)
twowayfeweights lwage geo cohort had_policy if paidw==1, type(feTR) ///
weight(weight) controls(female edu c_state*)
twowayfeweights paidw geo cohort had_policy, type(feTR) ///
weight(weight) controls(female edu c_state*)
*========================================================================*
/* Robustness: Domestic migration */
*========================================================================*
did_imputation dmigrant geo cohort first_cohort [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_dmigrant

event_plot bjs_dmigrant, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of moving to a different state", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_DMigrant.png", replace
*========================================================================*
/* Robustness: Selection bias */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)

keep if cohort>=1984 & cohort<=1994
gen first_cohort=1997
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

destring geo state, replace

sum income_hh, d
gen hincome=income_hh>=r(p50)

sum edu_hh, d
gen hpedu=edu_hh>=r(p50)

eststo clear
eststo: did_imputation hrs_exp geo cohort first_cohort if paidw==1 & hincome==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation eng geo cohort first_cohort if paidw==1 & hincome==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation lwage geo cohort first_cohort if paidw==1 & hincome==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation paidw geo cohort first_cohort if hincome==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
esttab using "$doc\tab4_A.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Heterogeneous effects) keep(tau) ///
stats(N, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: did_imputation hrs_exp geo cohort first_cohort if paidw==1 & hpedu==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation eng geo cohort first_cohort if paidw==1 & hpedu==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation lwage geo cohort first_cohort if paidw==1 & hpedu==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation paidw geo cohort first_cohort if hpedu==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
esttab using "$doc\tab4_B.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Heterogeneous effects) keep(tau) ///
stats(N, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: did_imputation hrs_exp geo cohort first_cohort if rural==0 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation eng geo cohort first_cohort if rural==0 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation lwage geo cohort first_cohort if rural==0 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation paidw geo cohort first_cohort if rural==0 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
esttab using "$doc\tab4_C.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Heterogeneous effects) keep(tau) ///
stats(N, fmt(%9.0fc %9.3f)) replace

*========================================================================*
/* Robustness: Treatment at state level */
*========================================================================*
/*use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
keep if cohort>=1984 & cohort<=1994

gen first_cohort=1997
replace first_cohort=1990 if state=="01"
replace first_cohort=1991 if state=="10"
replace first_cohort=1987 if state=="19"
replace first_cohort=1993 if state=="25"
replace first_cohort=1993 if state=="26"
replace first_cohort=1990 if state=="28"

destring state, replace

eststo clear
eststo: did_imputation hrs_exp state cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(state cohort) cluster(geo) autos 
eststo: did_imputation eng state cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(state cohort) cluster(geo) autos 
eststo: did_imputation lwage state cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(state cohort) cluster(geo) autos 
eststo: did_imputation paidw state cohort first_cohort [aw=weight], ///
controls(female edu) fe(state cohort) cluster(geo) autos 
esttab using "$doc\tab4_D.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Heterogeneous effects) keep(tau) ///
stats(N, fmt(%9.0fc %9.3f)) replace

did_imputation hrs_exp state cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(state cohort) cluster(geo) autos minn(0)
estimates store bjs_hrsSTATE
did_imputation eng state cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(state cohort) cluster(geo) autos minn(0)
estimates store bjs_EngSTATE
did_imputation lwage state cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(state cohort) cluster(geo) autos minn(0)
estimates store bjs_wageSTATE
did_imputation paidw state cohort first_cohort [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(state cohort) cluster(geo) autos minn(0)
estimates store bjs_paidSTATE

event_plot bjs_hrsSTATE, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_hrsEngSTATE.png", replace

event_plot bjs_EngSTATE, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_EngSTATE.png", replace

event_plot bjs_wageSTATE, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_WageSTATE.png", replace

event_plot bjs_paidSTATE, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_PaidSTATE.png", replace
*/
*========================================================================*
/* Mechanisms */
*========================================================================*
/* FIGURE 2: Jobs requiring English skills */
*========================================================================*
use "$data/eng_abil.dta", clear
collapse eng [fw=weight], by(sinco2011)
rename eng eng_ocupa
label var eng_ocupa "Distribution of the proportion of English speakers"
sum eng_ocupa, det

graph twoway (hist eng_ocupa, frac ///
xtitle("Distribution of the proportion of English speakers") ///
xlabel(0(0.2)1, labs(medium) grid format(%5.1f)) ///
ytitle("Fraction") ///
ylabel(0(0.2)1, labs(medium) grid format(%5.1f))) ///
(scatteri 0 .156 1 .156, c(l) m(i)), ///
legend(off)
graph export "$doc\histo_eng.png", replace

save "$base/eng_ocupa.dta", replace
*========================================================================*
clear
clear matrix
clear mata

use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
keep if cohort>=1984 & cohort<=1994
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)

tab state, generate(dstate)
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 {
	foreach z in 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 ///
	1993 1994 {
gen c_state`z'_`x'=0
replace c_state`z'_`x'=1 if dstate`x'==1 & cohort==`z'
}
}

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

destring geo, replace

gen first_cohort=1997
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1
destring geo state, replace

merge m:1 sinco2011 using "$base/eng_ocupa.dta", nogen

sum eng_ocupa, d
return list
gen high_eng=eng_ocupa>=r(p90)

did_imputation high_eng geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)

event_plot , ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working in jobs requiring English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_EngJobs.png", replace
*========================================================================*
/* FIGURE 3: Labor force participation and inactive individuals */
*========================================================================*
did_imputation work geo cohort first_cohort if female==0 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_workm
did_imputation work geo cohort first_cohort if female==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_workf
did_imputation work geo cohort first_cohort if edu<12 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_workl

gen inactive=student==0 & work==0

did_imputation inactive geo cohort first_cohort if female==0 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_im
did_imputation inactive geo cohort first_cohort if female==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_if
did_imputation inactive geo cohort first_cohort if edu<12 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_il

did_imputation student geo cohort first_cohort if female==0 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_sm
did_imputation student geo cohort first_cohort if female==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_sf
did_imputation student geo cohort first_cohort if edu<12 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_sl
*========================================================================*
/* Panel (a) */
*========================================================================*
event_plot bjs_workm bjs_workf bjs_workl, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre#) ///
    stub_lag(tau# tau# tau#) ///
    together noautolegend perturb(-0.10 0 0.10) ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of belonging to labor force", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Men" 4 "Women" 6 "Low educational attainment") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_SDD_Work.png", replace
*========================================================================*
/* Panel (b) */
*========================================================================*
event_plot bjs_im bjs_if bjs_il, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre#) ///
    stub_lag(tau# tau# tau#) ///
    together noautolegend perturb(-0.10 0 0.10) ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of being inactive", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_SDD_Inactive.png", replace
*========================================================================*
/* Panel (c) */
*========================================================================*
event_plot bjs_sm bjs_sf bjs_sl, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre#) ///
    stub_lag(tau# tau# tau#) ///
    together noautolegend perturb(-0.10 0 0.10) ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of being a student", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_SDD_Student.png", replace
*========================================================================*
/* FIGURE 4: Effect of English instruction on occupational decisions */
*========================================================================*
sum pact, d
return list

gen phy_act=pact>=r(p75)
replace phy_act=. if paidw!=1

sum communica, d
return list

gen c_abil=communica>=r(p75)
replace c_abil=. if paidw!=1

gen other_abil=c_abil==0 & phy_act==0
replace other_abil=. if c_abil==.

did_imputation phy_act geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)

event_plot , ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working in physically-intensive jobs", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_JobsP.png", replace
*========================================================================*
did_imputation c_abil geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)

event_plot , ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working in jobs requiring communication", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_JobsC.png", replace
*========================================================================*
did_imputation other_abil geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)

event_plot , ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working in jobs requiring other skills", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_JobsO.png", replace
*========================================================================*
/* APPENDIX */
*========================================================================*
/* FIGURE AXXX. */
*========================================================================*
gen informal=formal==0 & work==1

did_imputation informal geo cohort first_cohort [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_informal

event_plot bjs_informal, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of working in the informal sector", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_Informal.png", replace
*========================================================================*
/* TABLE A.4: Occupational decisions */
*========================================================================*
eststo clear
eststo: did_imputation stud geo cohort first_cohort if female==0 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos
eststo: did_imputation work geo cohort first_cohort if female==0 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos
eststo: did_imputation inactive geo cohort first_cohort if female==0 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos
esttab using "$doc\tabA5_A.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Occupational decisions) keep(tau) ///
stats(N, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: did_imputation stud geo cohort first_cohort if female==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos
eststo: did_imputation work geo cohort first_cohort if female==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos
eststo: did_imputation inactive geo cohort first_cohort if female==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos
esttab using "$doc\tabA5_B.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Occupational decisions) keep(tau) ///
stats(N, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: did_imputation stud geo cohort first_cohort if edu<12 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos
eststo: did_imputation work geo cohort first_cohort if edu<12 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos
eststo: did_imputation inactive geo cohort first_cohort if edu<12 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos
esttab using "$doc\tabA5_C.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Occupational decisions) keep(tau) ///
stats(N, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: did_imputation phy_act geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation c_abil geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation other_abil geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
esttab using "$doc\tabA6.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Occupational decisions) keep(tau) ///
stats(N, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Robustness: Selection bias */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)

keep if cohort>=1984 & cohort<=1994
gen first_cohort=1997
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

sum income_hh, d
gen hincome=income_hh>=r(p50)

sum edu_hh, d
gen hpedu=edu_hh>=r(p50)

destring geo state, replace

did_imputation hrs_exp geo cohort first_cohort if paidw==1 & hincome==1 [aw=weight], ///
horizons(0/6) pretrend(6) tol(1e-4) maxit(100) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_hrsHI
did_imputation eng geo cohort first_cohort if paidw==1 & hincome==1 [aw=weight], ///
horizons(0/6) pretrend(6) tol(1e-4) maxit(100) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_EngHI
did_imputation lwage geo cohort first_cohort if paidw==1 & hincome==1 [aw=weight], ///
horizons(0/6) pretrend(6) tol(1e-4) maxit(100) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_wageHI
did_imputation paidw geo cohort first_cohort if hincome==1 [aw=weight], ///
horizons(0/6) pretrend(6) tol(1e-4) maxit(100) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_paidHI

did_imputation hrs_exp geo cohort first_cohort if paidw==1 & hpedu==1 [aw=weight], ///
horizons(0/6) pretrend(6) tol(1e-4) maxit(100) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_hrsHE
did_imputation eng geo cohort first_cohort if paidw==1 & hpedu==1 [aw=weight], ///
horizons(0/6) pretrend(6) tol(1e-4) maxit(100) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_EngHE
did_imputation lwage geo cohort first_cohort if paidw==1 & hpedu==1 [aw=weight], ///
horizons(0/6) pretrend(6) tol(1e-4) maxit(100) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_wageHE
did_imputation paidw geo cohort first_cohort if hpedu==1 [aw=weight], ///
horizons(0/6) pretrend(6) tol(1e-4) maxit(100) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_paidHE

did_imputation hrs_exp geo cohort first_cohort if rural==0 [aw=weight], ///
horizons(0/6) pretrend(6) tol(1e-4) maxit(100) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_hrsURB
did_imputation eng geo cohort first_cohort if rural==0 [aw=weight], ///
horizons(0/6) pretrend(6) tol(1e-4) maxit(100) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_EngURB
did_imputation lwage geo cohort first_cohort if rural==0 [aw=weight], ///
horizons(0/6) pretrend(6) tol(1e-4) maxit(100) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_wageURB
did_imputation paidw geo cohort first_cohort if rural==0 [aw=weight], ///
horizons(0/6) pretrend(6) tol(1e-4) maxit(100) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_paidURB

event_plot bjs_hrsHI bjs_hrsHE bjs_hrsURB, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre#) ///
    stub_lag(tau# tau# tau#) ///
    together noautolegend perturb(-0.10 0 0.10) ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "High-income households (HH)" 4 "HH with high schooling parents" 6 "HH in urban contexts") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_hrsEngSB.png", replace

event_plot bjs_EngHI bjs_EngHE bjs_EngURB, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre#) ///
    stub_lag(tau# tau# tau#) ///
    together noautolegend perturb(-0.10 0 0.10) ///
	graph_opt( ///
	ylabel(-1.4(0.7)1.4, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_EngSB.png", replace

event_plot bjs_wageHI bjs_wageHE bjs_wageURB, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre#) ///
    stub_lag(tau# tau# tau#) ///
    together noautolegend perturb(-0.10 0 0.10) ///
	graph_opt( ///
	ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_WageSB.png", replace

event_plot bjs_paidHI bjs_paidHE bjs_paidURB, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre#) ///
    stub_lag(tau# tau# tau#) ///
    together noautolegend perturb(-0.10 0 0.10) ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_PaidSB.png", replace