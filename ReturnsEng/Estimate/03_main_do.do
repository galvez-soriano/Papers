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
keep if cohort>=1984 & cohort<=1996
keep if biare==1
destring state, replace
*========================================================================*
/* Panel A: Full sample */
*========================================================================*
eststo clear
eststo: reg lwage eng [aw=weight] if paidw==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if age>=18 ///
& age<=65 & paidw==1, vce(cluster geo)
eststo: reghdfe lwage eng female indigenous [aw=weight] if ///
paidw==1, absorb(cohort edu) vce(cluster geo)
eststo: reghdfe lwage eng female indigenous married ///
[aw=weight] if paidw==1, absorb(cohort state edu) vce(cluster geo)
eststo: reghdfe lwage eng female indigenous married ///
[aw=weight] if paidw==1, absorb(cohort geo edu state#cohort) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu<12, vce(cluster geo)
eststo: reghdfe lwage eng female indigenous married ///
[aw=weight] if paidw==1 & edu<12, absorb(cohort geo edu state#cohort) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu>=12, vce(cluster geo)
eststo: reghdfe lwage eng female indigenous married ///
[aw=weight] if paidw==1 & edu>=12, absorb(cohort geo edu state#cohort) vce(cluster geo)
esttab using "$doc\tab3_A.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Panel B: Men */
*========================================================================*
eststo clear
eststo: reg lwage eng [aw=weight] if paidw==1 & female==0, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if ///
paidw==1 & female==0, vce(cluster geo)
eststo: reghdfe lwage eng female indigenous [aw=weight] if ///
paidw==1 & female==0, absorb(cohort edu) vce(cluster geo)
eststo: reghdfe lwage eng female indigenous married ///
[aw=weight] if paidw==1 & female==0, absorb(cohort state edu) vce(cluster geo)
eststo: reghdfe lwage eng female indigenous married ///
[aw=weight] if paidw==1 & female==0, absorb(cohort geo edu state#cohort) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu<12 & female==0, vce(cluster geo)
eststo: reghdfe lwage eng female indigenous married ///
[aw=weight] if paidw==1 & edu<12 & female==0, absorb(cohort geo edu state#cohort) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu>=12 & female==0, vce(cluster geo)
eststo: reghdfe lwage eng female indigenous married ///
[aw=weight] if paidw==1 & edu>=12 & female==0, absorb(cohort geo edu state#cohort) vce(cluster geo)
esttab using "$doc\tab3_B.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Panel C: Women */
*========================================================================*
eststo clear
eststo: reg lwage eng [aw=weight] if paidw==1 & female==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if ///
paidw==1 & female==1, vce(cluster geo)
eststo: reghdfe lwage eng female indigenous [aw=weight] if ///
paidw==1 & female==1, absorb(cohort edu) vce(cluster geo)
eststo: reghdfe lwage eng female indigenous married ///
[aw=weight] if paidw==1 & female==1, absorb(cohort state edu) vce(cluster geo)
eststo: reghdfe lwage eng female indigenous married ///
[aw=weight] if paidw==1 & female==1, absorb(cohort geo edu state#cohort) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu<12 & female==1, vce(cluster geo)
eststo: reghdfe lwage eng female indigenous married ///
[aw=weight] if paidw==1 & edu<12 & female==1, absorb(cohort geo edu state#cohort) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu>=12 & female==1, vce(cluster geo)
eststo: reghdfe lwage eng female indigenous married ///
[aw=weight] if paidw==1 & edu>=12 & female==1, absorb(cohort geo edu state#cohort) vce(cluster geo)
esttab using "$doc\tab3_C.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Difference in estimate by gender */
*========================================================================*
gen eng_female=eng*female
gen cohort_fem=cohort*female
gen edu_fem=edu*female
gen state_fem=state*female
gen geo_fem=geo*female

eststo clear
eststo: reg lwage eng_female eng female [aw=weight] if paidw==1, vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous [aw=weight] if ///
paidw==1, absorb(cohort cohort_fem) vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous [aw=weight] if ///
paidw==1, absorb(cohort cohort_fem edu edu_fem) vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous married ///
[aw=weight] if paidw==1, absorb(cohort cohort_fem edu edu_fem state state_fem) vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous married ///
[aw=weight] if paidw==1, absorb(cohort cohort_fem edu edu_fem geo geo_fem state#cohort) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng_female eng female [aw=weight] if paidw==1 & edu<12, vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous married ///
[aw=weight] if paidw==1 & edu<12, absorb(cohort cohort_fem edu edu_fem geo geo_fem state#cohort) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng_female eng female [aw=weight] if paidw==1 & edu>=12, vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous married ///
[aw=weight] if paidw==1 & edu>=12, absorb(cohort cohort_fem edu edu_fem geo geo_fem state#cohort) vce(cluster geo)
esttab using "$doc\tab3_diff.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(eng_female) replace
/* Difference in estimate by education (female) */
dis (0.840+0.379)/sqrt((0.741^2)+(0.329))
*========================================================================*
/* TABLE 3. Effect of English programs on labor market outcomes */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

destring state, replace
*========================================================================*
/* Panel A: Full sample */ 
*========================================================================*
eststo clear
eststo: areg hrs_exp had_policy i.cohort ///
[aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg eng had_policy i.cohort ///
[aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg lwage had_policy i.cohort ///
[aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg paidw had_policy i.cohort ///
[aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
esttab using "$doc\tab_SDDa.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Panel B: Older individuals who work for pay */ 
*========================================================================*
eststo clear
eststo: areg hrs_exp had_policy i.cohort if cohort>=1984 & cohort<=1994 ///
& paidw==1 [aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg eng had_policy i.cohort if cohort>=1984 & cohort<=1994 ///
& paidw==1 [aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg lwage had_policy i.cohort if cohort>=1984 & cohort<=1994 ///
& paidw==1 [aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg paidw had_policy i.cohort if cohort>=1984 & cohort<=1994 ///
[aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg lhwork had_policy i.cohort if cohort>=1984 & cohort<=1994 ///
& paidw==1 [aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg formal had_policy i.cohort if cohort>=1984 & cohort<=1994 ///
& paidw==1 [aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
esttab using "$doc\tab_SDDb.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Panel C: Older individuals who work for pay (with controls) */ 
*========================================================================*
eststo clear
eststo: areg hrs_exp had_policy i.cohort edu female if cohort>=1984 & cohort<=1994 ///
& paidw==1 [aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg eng had_policy i.cohort edu female if cohort>=1984 & cohort<=1994 ///
& paidw==1 [aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg lwage had_policy i.cohort edu female if cohort>=1984 & cohort<=1994 ///
& paidw==1 [aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg paidw had_policy i.cohort edu female if cohort>=1984 & cohort<=1994 ///
[aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg lhwork had_policy i.cohort edu female if cohort>=1984 & cohort<=1994 ///
& paidw==1 [aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg formal had_policy i.cohort edu female if cohort>=1984 & cohort<=1994 ///
& paidw==1 [aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
esttab using "$doc\tab_SDDc.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* TABLE 4. English programs and robustness in the presence of heterogeneous 
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

/*tab state, generate(dstate)
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 {
	foreach z in 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 ///
	1993 1994 {
gen c_state`z'_`x'=0
replace c_state`z'_`x'=1 if dstate`x'==1 & cohort==`z'
}
}*/

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1
*========================================================================*
/* Panel A: Canonical TWFE with OLS */
*========================================================================*
/* Comes from Panel C of Table 3 */

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
cohort(tgroup) control_cohort(cgroup) covariates(edu female) ///
vce(cluster geo)
eventstudyinteract eng had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female) ///
vce(cluster geo)
eventstudyinteract lwage had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female) ///
vce(cluster geo)
eventstudyinteract paidw had_policy [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female) ///
vce(cluster geo)
eventstudyinteract lhwork had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female) ///
vce(cluster geo)
eventstudyinteract formal had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female) ///
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
csdid lhwork female edu if paidw==1 ///
[iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid formal female edu if paidw==1 ///
[iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
*========================================================================*
/* Panel D: Borusyak, Jaravel, and Spiess (2023) */
*========================================================================*
replace first_cohort=1997 if first_cohort==0
did_imputation hrs_exp geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort) cluster(geo) autos
did_imputation eng geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort) cluster(geo) autos
did_imputation lwage geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort) cluster(geo) autos
did_imputation paidw geo cohort first_cohort [aw=weight], ///
controls(female edu) fe(geo cohort) cluster(geo) autos
did_imputation lhwork geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort) cluster(geo) autos
did_imputation formal geo cohort first_cohort if paidw==1 [aw=weight], ///
controls(female edu) fe(geo cohort) cluster(geo) autos
*========================================================================*
/* Panel E: de Chaisemartin and D'Haultfoeuille (2020) */
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
gen lhwork=log(hrs_work)

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
controls(female edu)
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(2) cluster(geo) ///
controls(female edu)
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu)
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu)
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu)
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu)
/* Goodman-Bacon decomposition */
twowayfeweights hrs_exp geo cohort had_policy if paidw==1, type(feTR) ///
weight(weight) controls(female edu)
twowayfeweights eng geo cohort had_policy if paidw==1, type(feTR) ///
weight(weight) controls(female edu)
twowayfeweights lwage geo cohort had_policy if paidw==1, type(feTR) ///
weight(weight) controls(female edu)
twowayfeweights paidw geo cohort had_policy, type(feTR) ///
weight(weight) controls(female edu)
twowayfeweights lhwork geo cohort had_policy if paidw==1, type(feTR) ///
weight(weight) controls(female edu)
twowayfeweights formal geo cohort had_policy if paidw==1, type(feTR) ///
weight(weight) controls(female edu)
*========================================================================*
/* Wooldridge (2021) 

I cannot use this method because I have an unbalanced pooled cross
sectional data */
*========================================================================*
*hdidregress aipw (lwage) (had_policy), group(geo) time(cohort)

*========================================================================*
/* Robustness Check: Narrow cohorts */
*========================================================================*
keep if cohort>=1985 & cohort<=1995

csdid hrs_exp female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid eng female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid lwage edu female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all 
csdid paidw female indigenous married educ* [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid lhwork female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid formal female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
*========================================================================*
/* Robustness Check: All states */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
*drop if state=="05" | state=="17"
keep if cohort>=1981 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

gen first_cohort=0
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23{
gen educ`x'=edu==`x'
}

csdid hrs_exp female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid eng female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid lwage edu female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all 
csdid paidw female indigenous married educ* [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid lhwork female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid formal female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
*========================================================================*
/* Mechanisms */
*========================================================================*
/* Figure 4: Effect of English instruction on occupational decisions */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1
keep if cohort>=1981 & cohort<=1996

destring geo, replace
gen first_cohort=0
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23{
gen educ`x'=edu==`x'
}

sum pact, d
return list

gen phy_act=pact>=r(p75)
replace phy_act=. if paidw!=1

sum communica, d
return list

gen c_abil=communica>=r(p75)
replace c_abil=. if paidw!=1

csdid phy_act female indigenous married educ*  if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot seed(6) vce(cluster geo) long2
estat event, window(-5 8) estore(phys)
coefplot phys, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in physically-intensive jobs", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD_PhysicalOccup.png", replace

csdid phy_act female indigenous married educ* if paidw==1 & edu<12 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot vce(cluster geo) long2
estat event, window(-5 8) estore(phys_low)

csdid phy_act female indigenous married educ* if paidw==1 & edu>=12 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot vce(cluster geo) long2
estat event, window(-5 8) estore(phys_high)

coefplot ///
(phys_low, offset(0.05) label("Low educational attainment") connect(l) lc(gs14) msymbol(O) mcolor(gs14) ciopt(lc(gs14) recast(rcap connected))) ///
(phys_high, offset(-0.05) label("High educational attainment") connect(l) lc(dknavy) msymbol(O) mcolor(dknavy) ciopt(lc(dknavy) recast(rcap connected))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in physically-demanding jobs", size(medium) height(5)) ///
ylabel(-2(.5)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend( off ) ///
ysc(r(-2 2)) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD_PhysicalOccup_Educa.png", replace
/*
graph twoway (hist pact, frac ///
xtitle("O*NET score for physically demanding jobs") ///
ytitle("Fraction")) ///
(scatteri 0 73 0.2 73, c(l) m(i)), ///
legend(off)
graph export "$doc\histo_physical.png", replace
*/
*========================================================================*

csdid c_abil female indigenous married educ*  if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot seed(6) vce(cluster geo) long2
estat event, window(-5 8) estore(c_abil)
coefplot c_abil, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in jobs requiring communication", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD_Communica.png", replace

csdid c_abil female indigenous married educ* if paidw==1 & edu<12 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot vce(cluster geo) long2
estat event, window(-5 8) estore(c_abil_low)

csdid c_abil female indigenous married educ* if paidw==1 & edu>=12 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot vce(cluster geo) long2
estat event, window(-5 8) estore(c_abil_high)

coefplot ///
(c_abil_low, offset(0.05) label("Low educational attainment") connect(l) lc(gs14) msymbol(O) mcolor(gs14) ciopt(lc(gs14) recast(rcap connected))) ///
(c_abil_high, offset(-0.05) label("High educational attainment") connect(l) lc(dknavy) msymbol(O) mcolor(dknavy) ciopt(lc(dknavy) recast(rcap connected))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in jobs requiring communication", size(medium) height(5)) ///
ylabel(-2(.5)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ///
legend( pos(5) ring(0) col(1) region(lcolor(white)) size(medium) ) ///
ysc(r(-2 2)) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD_Communica_Educa.png", replace
/*
graph twoway (hist communica, frac ///
xtitle("O*NET score for jobs requiring communication") ///
ytitle("Fraction")) ///
(scatteri 0 62 0.2 62, c(l) m(i)), ///
legend(off)
graph export "$doc\histo_communica.png", replace
*/
*========================================================================*
/* Figure 5: Effect of English instruction on subjective well-being */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1
keep if cohort>=1981 & cohort<=1996

destring geo, replace
gen first_cohort=0
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23{
gen educ`x'=edu==`x'
}

gen dsgral=sgral>=9
gen dssocial=ssocial>=9
gen dssdl=ssd_living>=9
gen dsachiev=sachiev>=9
gen dsfp=sfuture_perspect>=9
gen dsleissure=sleissure>=9
gen dseact=secon_activity>=9

csdid dssdl female indigenous married educ*  if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot seed(6) vce(cluster geo) long2
estat event, window(-5 8) estore(dssdl)
coefplot dssdl, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of being satisfied with standard of living", size(medium) height(5)) ///
ylabel(-1(0.5)1.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1.5)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD_SatisSDLiving.png", replace

csdid dssdl female indigenous married educ* if paidw==1 & edu<12 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot vce(cluster geo) long2
estat event, window(-5 8) estore(dssdl_low)

csdid dssdl female indigenous married educ* if paidw==1 & edu>=12 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot vce(cluster geo) long2
estat event, window(-5 8) estore(dssdl_high)

coefplot ///
(dssdl_low, offset(0.05) label("Low educational attainment") connect(l) lc(gs14) msymbol(O) mcolor(gs14) ciopt(lc(gs14) recast(rcap connected))) ///
(dssdl_high, offset(-0.05) label("High educational attainment") connect(l) lc(dknavy) msymbol(O) mcolor(dknavy) ciopt(lc(dknavy) recast(rcap connected))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of being satisfied with standard of living", size(medium) height(5)) ///
ylabel(-1.5(.5)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend( off ) ///
ysc(r(-1.5 2)) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD_SatisSDLiving_Educa.png", replace

*========================================================================*
csdid dsachiev female indigenous married educ*  if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot seed(6) vce(cluster geo) long2
estat event, window(-5 8) estore(dsachiev)
coefplot dsachiev, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of being satisfied with achievements", size(medium) height(5)) ///
ylabel(-1(0.5)1.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1.5)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD_SatisAchiev.png", replace

csdid dsachiev female indigenous married educ* if paidw==1 & edu<12 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot vce(cluster geo) long2
estat event, window(-5 8) estore(dsachiev_low)

csdid dsachiev female indigenous married educ* if paidw==1 & edu>=12 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot vce(cluster geo) long2
estat event, window(-5 8) estore(dsachiev_high)

coefplot ///
(dsachiev_low, offset(0.05) label("Low educational attainment") connect(l) lc(gs14) msymbol(O) mcolor(gs14) ciopt(lc(gs14) recast(rcap connected))) ///
(dsachiev_high, offset(-0.05) label("High educational attainment") connect(l) lc(dknavy) msymbol(O) mcolor(dknavy) ciopt(lc(dknavy) recast(rcap connected))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of being satisfied with achievements", size(medium) height(5)) ///
ylabel(-1.5(.5)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend( pos(5) ring(0) col(1) region(lcolor(white)) size(medium) ) ///
ysc(r(-1.5 2)) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD_SatisAchiev_Educa.png", replace
*========================================================================*
/* Figure 6: School Enrollment */
*========================================================================*
use "$data/eng_abil.dta", clear
grstyle init
grstyle set plain, horizontal
keep if biare==1
drop if state=="05" | state=="17"
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
keep if cohort>=1981 & cohort<=1996

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1
keep if cohort>=1981 & cohort<=1996

merge m:1 age using "$data/cumm_enroll_15.dta", nogen

destring geo, replace
gen first_cohort=0
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23{
gen educ`x'=edu==`x'
}

eststo clear
csdid stud female indigenous married educ* if age<=23 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat simple, estore(age23)
csdid stud female indigenous married educ* if age<=24 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat simple, estore(age24)
csdid stud female indigenous married educ* if age<=25 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat simple, estore(age25)
csdid stud female indigenous married educ* if age<=26 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat simple, estore(age26)
csdid stud female indigenous married educ* if age<=27 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat simple, estore(age27)
csdid stud female indigenous married educ* if age<=28 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat simple, estore(age28)
csdid stud female indigenous married educ* if age<=29 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat simple, estore(age29)
csdid stud female indigenous married educ* if age<=30 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat simple, estore(age30)

coefplot ///
age23 age24 age25 age26 age27 age28 age29 age30, ///
keep(ATT) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
xtitle("Likelihood of being enrolled in school", size(medium) height(5)) ///
xlabel(-.1(0.1).3, labs(medium) format(%5.2f)) scheme(s2mono) ///
legend( pos(5) ring(0) col(1) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(95) legend(off)
graph save "$doc\graphSDDenroll",replace
graph export "$doc\graphSDDenroll.png", replace

graph hbar (mean) enroll if age>=23 & age<=30, over(age) scheme(s2mono) ///
graphregion(color(white)) ytitle("School enrollment", size(medium) height(5)) ///
ylabel(0(0.1).3, labs(medium) format(%5.2f) nogrid)
graph save "$doc\graph_enroll",replace
graph export "$doc\graph_enroll.png", replace

graph combine "$doc\graphSDDenroll" "$doc\graph_enroll", ///
graphregion(color(white) margin()) cols(2) imargin(1 1.2 1.2 1) scale(0.9)
graph export "$doc\fig_edu_enroll.png", replace

*========================================================================*
/* Figure X: Jobs requiring English skills */
*========================================================================*
use "$data/eng_abil.dta", clear
collapse eng [fw=weight], by(sinco2011)
rename eng eng_ocupa
label var eng_ocupa "Distribution of the proportion of English speakers"
/*
graph twoway (hist eng_ocupa, frac ///
xtitle("Distribution of the proportion of English speakers") ///
ytitle("Fraction")) ///
(scatteri 0 .058 1 .058, c(l) m(i)), ///
legend(off)
graph export "$doc\histo_eng.png", replace
*/
save "$base/eng_ocupa.dta", replace
*========================================================================*
use "$data/eng_abil.dta", clear
merge m:1 sinco2011 using "$base/eng_ocupa.dta", nogen

grstyle init
grstyle set plain, horizontal
keep if biare==1
drop if state=="05" | state=="17"
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
keep if cohort>=1981 & cohort<=1996

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1
keep if cohort>=1981 & cohort<=1996

destring geo, replace
gen first_cohort=0
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23{
gen educ`x'=edu==`x'
}

sum eng_ocupa, d
return list
gen high_eng=eng_ocupa>=r(p90)

csdid high_eng female indigenous married educ*  if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot seed(6) vce(cluster geo) long2
estat event, window(-5 8) estore(high_eng)
coefplot high_eng, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in jobs requiring English", size(medium) height(5)) ///
ylabel(-1(0.5)1.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1.5)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD_EngJobs.png", replace

csdid high_eng female indigenous married educ* if paidw==1 & edu<12 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot vce(cluster geo) long2
estat event, window(-5 8) estore(high_eng_low)

csdid high_eng female indigenous married educ* if paidw==1 & edu>=12 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot vce(cluster geo) long2
estat event, window(-5 8) estore(high_eng_high)

coefplot ///
(high_eng_low, offset(0.05) label("Low educational attainment") connect(l) lc(gs14) msymbol(O) mcolor(gs14) ciopt(lc(gs14) recast(rcap connected))) ///
(high_eng_high, offset(-0.05) label("High educational attainment") connect(l) lc(dknavy) msymbol(O) mcolor(dknavy) ciopt(lc(dknavy) recast(rcap connected))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in jobs requiring English", size(medium) height(5)) ///
ylabel(-1.5(.5)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend( pos(5) ring(0) col(1) region(lcolor(white)) size(medium)) ///
ysc(r(-1.5 2)) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD_EngJobs_Edu.png", replace