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

did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*)
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*)

did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*)
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*)
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
/* FIGURE 1. English programs, exposure, English skills, and wages */
*========================================================================*
did_imputation hrs_exp geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_hrs
did_imputation eng geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_Eng
did_imputation lwage geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_wage
did_imputation paidw geo cohort first_cohort [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_paid
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
/* Mechanisms */
*========================================================================*
/* Figure 3: Jobs requiring English skills */
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
/* Figure 4: Labor force participation and inactive individuals */
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
*========================================================================*
/* Panel (a) */
*========================================================================*
event_plot bjs_workm bjs_workf bjs_workl, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre#) ///
    stub_lag(tau# tau# tau#) ///
    together noautolegend ///
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
    together noautolegend ///
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
/* Figure 5: Effect of English instruction on occupational decisions */
*========================================================================*
sum pact, d
return list

gen phy_act=pact>=r(p75)
replace phy_act=. if paidw!=1

sum communica, d
return list

gen c_abil=communica>=r(p75)
replace c_abil=. if paidw!=1

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
/*
graph twoway (hist pact, frac ///
xtitle("O*NET score for physically demanding jobs") ///
ytitle("Fraction")) ///
(scatteri 0 73 0.2 73, c(l) m(i)), ///
legend(off)
graph export "$doc\histo_physical.png", replace
*/
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
/*
graph twoway (hist communica, frac ///
xtitle("O*NET score for jobs requiring communication") ///
ytitle("Fraction")) ///
(scatteri 0 62 0.2 62, c(l) m(i)), ///
legend(off)
graph export "$doc\histo_communica.png", replace
*/
*========================================================================*
/* Table: Looking within occupations */
*========================================================================*
destring sinco, replace
gen occup=.
replace occup=1 if (sinco>6101 & sinco<=6131) | (sinco>6201 & sinco<=6231) ///
| sinco==6999
replace occup=2 if (sinco>=9111 & sinco<=9899) 
replace occup=3 if sinco==6311 | (sinco>=8111 & sinco<=8199) | (sinco>=8211 ///
& sinco<=8212) | (sinco>=8311 & sinco<=8999)
replace occup=4 if (sinco>=7111 & sinco<=7135) | (sinco>=7211 & sinco<=7223) ///
| (sinco>=7311 & sinco<=7353) | (sinco>=7411 & sinco<=7412) | (sinco>=7511 & ///
sinco<=7517) | (sinco>=7611 & sinco<=7999)
replace occup=5 if (sinco>=5111 & sinco<=5116) | (sinco>=5211 & sinco<=5254) ///
| (sinco>=5311 & sinco<=5314) | (sinco>=5411 & sinco<=5999)
replace occup=6 if sinco==4111 | (sinco>=4211 & sinco<=4999)
replace occup=7 if (sinco>=3111 & sinco<=3142) | (sinco>=3211 & sinco<=3999)
replace occup=8 if (sinco>=2111 & sinco<=2625) | (sinco>=2631 & sinco<=2639) ///
| (sinco>=2641 & sinco<=2992)
replace occup=9 if (sinco>=1111 & sinco<=1999) | sinco==2630 ///
| sinco==2630 | sinco==2640 | sinco==3101 | sinco==3201 | sinco==4201 ///
| sinco==5101 | sinco==5201 | sinco==5301 | sinco==5401 | sinco==6101 ///
| sinco==6201 | sinco==7101 | sinco==7201 | sinco==7301 | sinco==7401 ///
| sinco==7501 | sinco==7601 | sinco==8101 | sinco==8201 | sinco==8301
replace occup=10 if sinco==980

label define occup 1 "Farming" 2 "Elem occupations" 3 "Machine operators" ///
4 "Crafts" 5 "Customer service" 6 "Sales" 7 "Clerical support" ///
8 "Pro/Tech" 9 "Managerial" 10 "Abroad" 
label values occup occup

gen farm=occup==1
gen elem=occup==2
gen machine=occup==3
gen crafts=occup==4
gen cserv=occup==5
gen sales=occup==6
gen clerk=occup==7
gen protech=occup==8
gen manage=occup==9
gen abroad=occup==10

eststo clear
eststo: did_imputation farm geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation elem geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation machine geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation crafts geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation cserv geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation sales geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation clerk geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation protech geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation manage geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
eststo: did_imputation abroad geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos 
esttab using "$doc\tab.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Heterogeneous effects) keep(tau) ///
stats(N, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Figure 7: Effect of English instruction on subjective well-being */
*========================================================================*
gen dsgral=sgral>=9
gen dssocial=ssocial>=9
gen dssdl=ssd_living>=9
gen dsachiev=sachiev>=9
gen dsfp=sfuture_perspect>=9
gen dsleissure=sleissure>=9
gen dseact=secon_activity>=9
*========================================================================*
did_imputation dseact geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_sea
did_imputation dsachiev geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_achiev
*========================================================================*
/* Panel (a) */
*========================================================================*
event_plot bjs_sea, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of being satisfied with economic activity", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_SatisEA.png", replace
*========================================================================*
/* Panel (b) */
*========================================================================*
event_plot bjs_achiev, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of being satisfied with achievements", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_SatisAchiev.png", replace

*========================================================================*
/* Figure 8: School Enrollment */
*========================================================================*
did_imputation stud geo cohort first_cohort if age<=24 [aw=weight], ///
horizons(0/6) pretrend(3) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_s24
did_imputation stud geo cohort first_cohort if age<=25 [aw=weight], ///
horizons(0/6) pretrend(4) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_s25
did_imputation stud geo cohort first_cohort if age<=26 [aw=weight], ///
horizons(0/6) pretrend(5) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_s26

event_plot bjs_s24 bjs_s25 bjs_s26, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre#) ///
    stub_lag(tau# tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of being enrolled in school", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "age<25" 4 "age<26" 6 "age<27") pos(11) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\fig_edu_enroll.png", replace

