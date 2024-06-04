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

sum hrs_exp eng lwage lhwork formal [fw=weight] if cohort>=1984 & cohort<=1994 ///
& paidw==1
sum paidw [fw=weight] if cohort>=1984 & cohort<=1994
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
/* Robustness Checks */
*========================================================================*
/* Leads and lags */
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
*========================================================================*
/* Hours of English instruction */
*========================================================================*
* LAGS
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b1 = e(estimates) \ 0
matrix hrsEng_v1 = e(variances) \ 0

mat rownames hrsEng_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

* LEADS AND LAGS
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(5) placebo(4) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b5 = e(estimates) \ 0
matrix hrsEng_v5 = e(variances) \ 0

mat rownames hrsEng_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1
mat rownames hrsEng_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1

did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b6 = e(estimates) \ 0
matrix hrsEng_v6 = e(variances) \ 0

mat rownames hrsEng_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames hrsEng_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(3) placebo(2) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b7 = e(estimates) \ 0
matrix hrsEng_v7 = e(variances) \ 0

mat rownames hrsEng_b7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1
mat rownames hrsEng_v7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1

/* Graph */
event_plot hrsEng_b1#hrsEng_v1 hrsEng_b5#hrsEng_v5 hrsEng_b6#hrsEng_v6 hrsEng_b7#hrsEng_v7, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Full sample" 4 "Excluding one lead and lag" 6 "Excluding two leads and lags" 8 "Excluding three leads and lags") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_hrsEngSensitivity.png", replace

*========================================================================*
/* English speaking ability */
*========================================================================*
* LAGS
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b1 = e(estimates) \ 0
matrix Eng_v1 = e(variances) \ 0

mat rownames Eng_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

* LEADS AND LAGS
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(5) placebo(4) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b5 = e(estimates) \ 0
matrix Eng_v5 = e(variances) \ 0

mat rownames Eng_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1
mat rownames Eng_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1

did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b6 = e(estimates) \ 0
matrix Eng_v6 = e(variances) \ 0

mat rownames Eng_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames Eng_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(3) placebo(2) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b7 = e(estimates) \ 0
matrix Eng_v7 = e(variances) \ 0

mat rownames Eng_b7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1
mat rownames Eng_v7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1

/* Graph */
event_plot Eng_b1#Eng_v1 Eng_b5#Eng_v5 Eng_b6#Eng_v6 Eng_b7#Eng_v7, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_EngSensitivity.png", replace

*========================================================================*
/* Log of wages */
*========================================================================*
* LAGS
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b1 = e(estimates) \ 0
matrix wage_v1 = e(variances) \ 0

mat rownames wage_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

* LEADS AND LAGS
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(5) placebo(4) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b5 = e(estimates) \ 0
matrix wage_v5 = e(variances) \ 0

mat rownames wage_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1
mat rownames wage_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1

did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b6 = e(estimates) \ 0
matrix wage_v6 = e(variances) \ 0

mat rownames wage_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames wage_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(3) placebo(2) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b7 = e(estimates) \ 0
matrix wage_v7 = e(variances) \ 0

mat rownames wage_b7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1
mat rownames wage_v7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1

/* Graph */
event_plot wage_b1#wage_v1 wage_b5#wage_v5 wage_b6#wage_v6 wage_b7#wage_v7, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_WageSensitivity.png", replace

*========================================================================*
/* Likelihood of working for pay */
*========================================================================*
* LAGS
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b1 = e(estimates) \ 0
matrix paidw_v1 = e(variances) \ 0

mat rownames paidw_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

* LEADS AND LAGS
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(5) placebo(4) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b5 = e(estimates) \ 0
matrix paidw_v5 = e(variances) \ 0

mat rownames paidw_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1
mat rownames paidw_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1

did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b6 = e(estimates) \ 0
matrix paidw_v6 = e(variances) \ 0

mat rownames paidw_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames paidw_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(3) placebo(2) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b7 = e(estimates) \ 0
matrix paidw_v7 = e(variances) \ 0

mat rownames paidw_b7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1
mat rownames paidw_v7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1

/* Graph */
event_plot paidw_b1#paidw_v1 paidw_b5#paidw_v5 paidw_b6#paidw_v6 paidw_b7#paidw_v7, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_PaidSensitivity.png", replace

*========================================================================*
/* Hrs worked */
*========================================================================*
* LAGS
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b1 = e(estimates) \ 0
matrix lhwork_v1 = e(variances) \ 0

mat rownames lhwork_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

* LEADS AND LAGS
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(5) placebo(4) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b5 = e(estimates) \ 0
matrix lhwork_v5 = e(variances) \ 0

mat rownames lhwork_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1
mat rownames lhwork_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1

did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b6 = e(estimates) \ 0
matrix lhwork_v6 = e(variances) \ 0

mat rownames lhwork_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames lhwork_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(3) placebo(2) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b7 = e(estimates) \ 0
matrix lhwork_v7 = e(variances) \ 0

mat rownames lhwork_b7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1
mat rownames lhwork_v7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1

/* Graph */
event_plot lhwork_b1#lhwork_v1 lhwork_b5#lhwork_v5 lhwork_b6#lhwork_v6 lhwork_b7#lhwork_v7, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of hours worked", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick)) 
graph export "$doc\PTA_lsSensitivity.png", replace

*========================================================================*
/* Likelihood of working in formal sector */
*========================================================================*
* LAGS
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b1 = e(estimates) \ 0
matrix formal_v1 = e(variances) \ 0

mat rownames formal_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

* LEADS AND LAGS
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(5) placebo(4) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b5 = e(estimates) \ 0
matrix formal_v5 = e(variances) \ 0

mat rownames formal_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1
mat rownames formal_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1

did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b6 = e(estimates) \ 0
matrix formal_v6 = e(variances) \ 0

mat rownames formal_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames formal_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(3) placebo(2) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b7 = e(estimates) \ 0
matrix formal_v7 = e(variances) \ 0

mat rownames formal_b7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1
mat rownames formal_v7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1

/* Graph */
event_plot formal_b1#formal_v1 formal_b5#formal_v5 formal_b6#formal_v6 formal_b7#formal_v7, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of hours worked", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick)) 
graph export "$doc\PTA_FormalSensitivity.png", replace

*========================================================================*
/* Narrow cohorts */
*========================================================================*
/* Hours of English instruction */
*========================================================================*
did_multiplegt hrs_exp geo cohort had_policy if paidw==1 & cohort>=1985 & cohort<=1995, weight(weight) ///
robust_dynamic dynamic(5) placebo(4) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b5 = e(estimates) \ 0
matrix hrsEng_v5 = e(variances) \ 0

mat rownames hrsEng_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1
mat rownames hrsEng_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1

did_multiplegt hrs_exp geo cohort had_policy if paidw==1 & cohort>=1986 & cohort<=1994, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b6 = e(estimates) \ 0
matrix hrsEng_v6 = e(variances) \ 0

mat rownames hrsEng_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames hrsEng_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

did_multiplegt hrs_exp geo cohort had_policy if paidw==1 & cohort>=1987 & cohort<=1993, weight(weight) ///
robust_dynamic dynamic(3) placebo(2) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b7 = e(estimates) \ 0
matrix hrsEng_v7 = e(variances) \ 0

mat rownames hrsEng_b7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1
mat rownames hrsEng_v7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1

/* Graph */
event_plot hrsEng_b1#hrsEng_v1 hrsEng_b5#hrsEng_v5 hrsEng_b6#hrsEng_v6 hrsEng_b7#hrsEng_v7, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Full sample" 4 "Excluding one old and young cohorts" 6 "Excluding two old and young cohorts" 8 "Excluding three old and young cohorts") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_hrsEngCohorts.png", replace

*========================================================================*
/* English speaking ability */
*========================================================================*
did_multiplegt eng geo cohort had_policy if paidw==1 & cohort>=1985 & cohort<=1995, weight(weight) ///
robust_dynamic dynamic(5) placebo(4) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b5 = e(estimates) \ 0
matrix Eng_v5 = e(variances) \ 0

mat rownames Eng_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1
mat rownames Eng_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1

did_multiplegt eng geo cohort had_policy if paidw==1 & cohort>=1986 & cohort<=1994, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b6 = e(estimates) \ 0
matrix Eng_v6 = e(variances) \ 0

mat rownames Eng_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames Eng_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

did_multiplegt eng geo cohort had_policy if paidw==1 & cohort>=1987 & cohort<=1993, weight(weight) ///
robust_dynamic dynamic(3) placebo(2) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b7 = e(estimates) \ 0
matrix Eng_v7 = e(variances) \ 0

mat rownames Eng_b7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1
mat rownames Eng_v7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1

/* Graph */
event_plot Eng_b1#Eng_v1 Eng_b5#Eng_v5 Eng_b6#Eng_v6 Eng_b7#Eng_v7, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_EngCohorts.png", replace

*========================================================================*
/* Log of wages */
*========================================================================*
did_multiplegt lwage geo cohort had_policy if paidw==1 & cohort>=1985 & cohort<=1995, weight(weight) ///
robust_dynamic dynamic(5) placebo(4) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b5 = e(estimates) \ 0
matrix wage_v5 = e(variances) \ 0

mat rownames wage_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1
mat rownames wage_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1

did_multiplegt lwage geo cohort had_policy if paidw==1 & cohort>=1986 & cohort<=1994, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b6 = e(estimates) \ 0
matrix wage_v6 = e(variances) \ 0

mat rownames wage_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames wage_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

did_multiplegt lwage geo cohort had_policy if paidw==1 & cohort>=1987 & cohort<=1993, weight(weight) ///
robust_dynamic dynamic(3) placebo(2) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b7 = e(estimates) \ 0
matrix wage_v7 = e(variances) \ 0

mat rownames wage_b7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1
mat rownames wage_v7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1

/* Graph */
event_plot wage_b1#wage_v1 wage_b5#wage_v5 wage_b6#wage_v6 wage_b7#wage_v7, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_WageCohorts.png", replace

*========================================================================*
/* Likelihood of working for pay */
*========================================================================*
did_multiplegt paidw geo cohort had_policy if cohort>=1985 & cohort<=1995, weight(weight) ///
robust_dynamic dynamic(5) placebo(4) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b5 = e(estimates) \ 0
matrix paidw_v5 = e(variances) \ 0

mat rownames paidw_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1
mat rownames paidw_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1

did_multiplegt paidw geo cohort had_policy if cohort>=1986 & cohort<=1994, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b6 = e(estimates) \ 0
matrix paidw_v6 = e(variances) \ 0

mat rownames paidw_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames paidw_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

did_multiplegt paidw geo cohort had_policy if cohort>=1987 & cohort<=1993, weight(weight) ///
robust_dynamic dynamic(3) placebo(2) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b7 = e(estimates) \ 0
matrix paidw_v7 = e(variances) \ 0

mat rownames paidw_b7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1
mat rownames paidw_v7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1

/* Graph */
event_plot paidw_b1#paidw_v1 paidw_b5#paidw_v5 paidw_b6#paidw_v6 paidw_b7#paidw_v7, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_PaidCohorts.png", replace

*========================================================================*
/* Hrs worked */
*========================================================================*
did_multiplegt lhwork geo cohort had_policy if paidw==1 & cohort>=1985 & cohort<=1995, weight(weight) ///
robust_dynamic dynamic(5) placebo(4) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b5 = e(estimates) \ 0
matrix lhwork_v5 = e(variances) \ 0

mat rownames lhwork_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1
mat rownames lhwork_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1

did_multiplegt lhwork geo cohort had_policy if paidw==1 & cohort>=1986 & cohort<=1994, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b6 = e(estimates) \ 0
matrix lhwork_v6 = e(variances) \ 0

mat rownames lhwork_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames lhwork_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

did_multiplegt lhwork geo cohort had_policy if paidw==1 & cohort>=1987 & cohort<=1993, weight(weight) ///
robust_dynamic dynamic(3) placebo(2) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b7 = e(estimates) \ 0
matrix lhwork_v7 = e(variances) \ 0

mat rownames lhwork_b7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1
mat rownames lhwork_v7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1

/* Graph */
event_plot lhwork_b1#lhwork_v1 lhwork_b5#lhwork_v5 lhwork_b6#lhwork_v6 lhwork_b7#lhwork_v7, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of hours worked", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick)) 
graph export "$doc\PTA_lsCohorts.png", replace

*========================================================================*
/* Likelihood of working in formal sector */
*========================================================================*
did_multiplegt formal geo cohort had_policy if paidw==1 & cohort>=1985 & cohort<=1995, weight(weight) ///
robust_dynamic dynamic(5) placebo(4) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b5 = e(estimates) \ 0
matrix formal_v5 = e(variances) \ 0

mat rownames formal_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1
mat rownames formal_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_1

did_multiplegt formal geo cohort had_policy if paidw==1 & cohort>=1986 & cohort<=1994, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b6 = e(estimates) \ 0
matrix formal_v6 = e(variances) \ 0

mat rownames formal_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames formal_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

did_multiplegt formal geo cohort had_policy if paidw==1 & cohort>=1987 & cohort<=1993, weight(weight) ///
robust_dynamic dynamic(3) placebo(2) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b7 = e(estimates) \ 0
matrix formal_v7 = e(variances) \ 0

mat rownames formal_b7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1
mat rownames formal_v7 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_1

/* Graph */
event_plot formal_b1#formal_v1 formal_b5#formal_v5 formal_b6#formal_v6 formal_b7#formal_v7, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of hours worked", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick)) 
graph export "$doc\PTA_FormalCohorts.png", replace

*========================================================================*
/* TABLE XXX. Sensitivity changing the treatment and comparison groups */
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

gen sstates=state=="31" | state=="23" | state=="04" | state=="07" | ///
state=="27" | state=="20" | state=="30" | state=="12" | state=="21" | ///
state=="17" | state=="29" | state=="16" | state=="15" | state=="09" | ///
state=="13" | state=="06" | state=="22"

destring geo, replace

*========================================================================*
/* Changes in comparison group */
*========================================================================*
/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b1 = e(estimates) \ 0
matrix hrsEng_v1 = e(variances) \ 0

mat rownames hrsEng_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt hrs_exp geo cohort had_policy if paidw==1 & sstates==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b3 = e(estimates) \ 0
matrix hrsEng_v3 = e(variances) \ 0

mat rownames hrsEng_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b1 = e(estimates) \ 0
matrix Eng_v1 = e(variances) \ 0

mat rownames Eng_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt eng geo cohort had_policy if paidw==1 & sstates==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b3 = e(estimates) \ 0
matrix Eng_v3 = e(variances) \ 0

mat rownames Eng_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b1 = e(estimates) \ 0
matrix wage_v1 = e(variances) \ 0

mat rownames wage_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt lwage geo cohort had_policy if paidw==1 & sstates==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b3 = e(estimates) \ 0
matrix wage_v3 = e(variances) \ 0

mat rownames wage_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b1 = e(estimates) \ 0
matrix paidw_v1 = e(variances) \ 0

mat rownames paidw_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt paidw geo cohort had_policy if sstates==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b3 = e(estimates) \ 0
matrix paidw_v3 = e(variances) \ 0

mat rownames paidw_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hrs worked */
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b1 = e(estimates) \ 0
matrix lhwork_v1 = e(variances) \ 0

mat rownames lhwork_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt lhwork geo cohort had_policy if paidw==1 & sstates==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b3 = e(estimates) \ 0
matrix lhwork_v3 = e(variances) \ 0

mat rownames lhwork_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b1 = e(estimates) \ 0
matrix formal_v1 = e(variances) \ 0

mat rownames formal_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt formal geo cohort had_policy if paidw==1 & sstates==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b3 = e(estimates) \ 0
matrix formal_v3 = e(variances) \ 0

mat rownames formal_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

*========================================================================*
/* With Morelos and Coahuila */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
*drop if state=="05" | state=="17"
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

/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b2 = e(estimates) \ 0
matrix hrsEng_v2 = e(variances) \ 0

mat rownames hrsEng_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b2 = e(estimates) \ 0
matrix Eng_v2 = e(variances) \ 0

mat rownames Eng_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b2 = e(estimates) \ 0
matrix wage_v2 = e(variances) \ 0

mat rownames wage_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b2 = e(estimates) \ 0
matrix paidw_v2 = e(variances) \ 0

mat rownames paidw_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hrs worked */
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b2 = e(estimates) \ 0
matrix lhwork_v2 = e(variances) \ 0

mat rownames lhwork_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b2 = e(estimates) \ 0
matrix formal_v2 = e(variances) \ 0

mat rownames formal_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hours of English instruction */
event_plot hrsEng_b1#hrsEng_v1 hrsEng_b2#hrsEng_v2 hrsEng_b3#hrsEng_v3, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Original sample" 4 "Including Morelos and Coahila" 6 "Excluding southern states") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick))
graph export "$doc\PTA_hrsEngStates.png", replace

/* English speaking ability */
event_plot Eng_b1#Eng_v1 Eng_b2#Eng_v2 Eng_b3#Eng_v3, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick))
graph export "$doc\PTA_EngStates.png", replace

/* Log of wages */
event_plot wage_b1#wage_v1 wage_b2#wage_v2 wage_b3#wage_v3, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_WageStates.png", replace

/* Likelihood of working for pay */
event_plot paidw_b1#paidw_v1 paidw_b2#paidw_v2 paidw_b3#paidw_v3, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick))
graph export "$doc\PTA_PaidStates.png", replace

/* Hrs worked */
event_plot lhwork_b1#lhwork_v1 lhwork_b2#lhwork_v2 lhwork_b3#lhwork_v3, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of hours worked", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_lsStates.png", replace

/* Likelihood of working in formal sector */
event_plot formal_b1#formal_v1 formal_b2#formal_v2 formal_b3#formal_v3, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of hours worked", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_FormalStates.png", replace

*========================================================================*
/* TABLE XXX. Sensitivity changing the treatment and comparison groups */
*========================================================================*
clear
clear matrix
clear mata
set maxvar 120000
*========================================================================*
/* Changes in treatment group */
*========================================================================*
/* Aguascalientes */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17" | state=="01"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

gen had_policy=0 
*replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

destring geo, replace

/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b1 = e(estimates) \ 0
matrix hrsEng_v1 = e(variances) \ 0

mat rownames hrsEng_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames hrsEng_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b1 = e(estimates) \ 0
matrix Eng_v1 = e(variances) \ 0

mat rownames Eng_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames Eng_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b1 = e(estimates) \ 0
matrix wage_v1 = e(variances) \ 0

mat rownames wage_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames wage_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b1 = e(estimates) \ 0
matrix paidw_v1 = e(variances) \ 0

mat rownames paidw_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames paidw_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

	/* Hrs worked */
	did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
	robust_dynamic dynamic(3) placebo(3) breps(100) cluster(geo) ///
	controls(female edu) 

matrix lhwork_b1 = e(estimates) \ 0
matrix lhwork_v1 = e(variances) \ 0

mat rownames lhwork_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames lhwork_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b1 = e(estimates) \ 0
matrix formal_v1 = e(variances) \ 0

mat rownames formal_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames formal_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
*========================================================================*
/* Durango */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17" | state=="10"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
*replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

destring geo, replace

/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b2 = e(estimates) \ 0
matrix hrsEng_v2 = e(variances) \ 0

mat rownames hrsEng_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b2 = e(estimates) \ 0
matrix Eng_v2 = e(variances) \ 0

mat rownames Eng_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b2 = e(estimates) \ 0
matrix wage_v2 = e(variances) \ 0

mat rownames wage_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b2 = e(estimates) \ 0
matrix paidw_v2 = e(variances) \ 0

mat rownames paidw_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hrs worked */
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b2 = e(estimates) \ 0
matrix lhwork_v2 = e(variances) \ 0

mat rownames lhwork_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b2 = e(estimates) \ 0
matrix formal_v2 = e(variances) \ 0

mat rownames formal_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* Nuevo Leon */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17" | state=="19"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
*replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

destring geo, replace

/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b3 = e(estimates) \ 0
matrix hrsEng_v3 = e(variances) \ 0

mat rownames hrsEng_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b3 = e(estimates) \ 0
matrix Eng_v3 = e(variances) \ 0

mat rownames Eng_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b3 = e(estimates) \ 0
matrix wage_v3 = e(variances) \ 0

mat rownames wage_b3= Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b3 = e(estimates) \ 0
matrix paidw_v3 = e(variances) \ 0

mat rownames paidw_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hrs worked */
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b3 = e(estimates) \ 0
matrix lhwork_v3 = e(variances) \ 0

mat rownames lhwork_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b3 = e(estimates) \ 0
matrix formal_v3 = e(variances) \ 0

mat rownames formal_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* Sinaloa */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17" | state=="25"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
*replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

destring geo, replace

/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b4 = e(estimates) \ 0
matrix hrsEng_v4 = e(variances) \ 0

mat rownames hrsEng_b4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b4 = e(estimates) \ 0
matrix Eng_v4 = e(variances) \ 0

mat rownames Eng_b4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b4 = e(estimates) \ 0
matrix wage_v4 = e(variances) \ 0

mat rownames wage_b4= Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b4 = e(estimates) \ 0
matrix paidw_v4 = e(variances) \ 0

mat rownames paidw_b4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hrs worked */
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b4 = e(estimates) \ 0
matrix lhwork_v4 = e(variances) \ 0

mat rownames lhwork_b4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b4 = e(estimates) \ 0
matrix formal_v4 = e(variances) \ 0

mat rownames formal_b4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

*========================================================================*
/* Sonora */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17" | state=="26"
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
*replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

destring geo, replace

/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b5 = e(estimates) \ 0
matrix hrsEng_v5 = e(variances) \ 0

mat rownames hrsEng_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b5 = e(estimates) \ 0
matrix Eng_v5 = e(variances) \ 0

mat rownames Eng_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b5 = e(estimates) \ 0
matrix wage_v5 = e(variances) \ 0

mat rownames wage_b5= Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b5 = e(estimates) \ 0
matrix paidw_v5 = e(variances) \ 0

mat rownames paidw_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hrs worked */
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b5 = e(estimates) \ 0
matrix lhwork_v5 = e(variances) \ 0

mat rownames lhwork_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b5 = e(estimates) \ 0
matrix formal_v5 = e(variances) \ 0

mat rownames formal_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* Tamaulipas */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17" | state=="28"
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
*replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

destring geo, replace

/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b6 = e(estimates) \ 0
matrix hrsEng_v6 = e(variances) \ 0

mat rownames hrsEng_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b6 = e(estimates) \ 0
matrix Eng_v6 = e(variances) \ 0

mat rownames Eng_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b6 = e(estimates) \ 0
matrix wage_v6 = e(variances) \ 0

mat rownames wage_b6= Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b6 = e(estimates) \ 0
matrix paidw_v6 = e(variances) \ 0

mat rownames paidw_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hrs worked */
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b6 = e(estimates) \ 0
matrix lhwork_v6 = e(variances) \ 0

mat rownames lhwork_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b6 = e(estimates) \ 0
matrix formal_v6 = e(variances) \ 0

mat rownames formal_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

*========================================================================*
/* FIGURE XX:  */
*========================================================================*
/* Hours of English instruction */
event_plot hrsEng_b1#hrsEng_v1 hrsEng_b2#hrsEng_v2 hrsEng_b3#hrsEng_v3 hrsEng_b4#hrsEng_v4 hrsEng_b5#hrsEng_v5 hrsEng_b6#hrsEng_v6, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Excluding Aguascalientes" 4 "Excluding Durango" 6 "Excluding Nuevo Leon" 8 "Excluding Sinaloa" 10 "Excluding Sonora" 12 "Excluding Tamaulipas") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(dkgreen) mlcolor(dkgreen) mlwidth(thin)) lag_ci_opt4(color(dkgreen) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(+) mfcolor(midgreen) mlcolor(midgreen) mlwidth(thin)) lag_ci_opt5(color(midgreen) lwidth(medthick)) ///
	lag_opt6(msize(small) msymbol(X) mfcolor(green) mlcolor(green) mlwidth(thin)) lag_ci_opt6(color(green) lwidth(medthick))
graph export "$doc\PTA_hrsEngTStates.png", replace

/* English speaking ability */
event_plot Eng_b1#Eng_v1 Eng_b2#Eng_v2 Eng_b3#Eng_v3 Eng_b4#Eng_v4 Eng_b5#Eng_v5 Eng_b6#Eng_v6, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(dkgreen) mlcolor(dkgreen) mlwidth(thin)) lag_ci_opt4(color(dkgreen) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(+) mfcolor(midgreen) mlcolor(midgreen) mlwidth(thin)) lag_ci_opt5(color(midgreen) lwidth(medthick)) ///
	lag_opt6(msize(small) msymbol(X) mfcolor(green) mlcolor(green) mlwidth(thin)) lag_ci_opt6(color(green) lwidth(medthick))
graph export "$doc\PTA_EngTStates.png", replace

/* Log of wages */
event_plot wage_b1#wage_v1 wage_b2#wage_v2 wage_b3#wage_v3 wage_b4#wage_v4 wage_b5#wage_v5 wage_b6#wage_v6, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(dkgreen) mlcolor(dkgreen) mlwidth(thin)) lag_ci_opt4(color(dkgreen) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(+) mfcolor(midgreen) mlcolor(midgreen) mlwidth(thin)) lag_ci_opt5(color(midgreen) lwidth(medthick)) ///
	lag_opt6(msize(small) msymbol(X) mfcolor(green) mlcolor(green) mlwidth(thin)) lag_ci_opt6(color(green) lwidth(medthick))
graph export "$doc\PTA_WageTStates.png", replace

/* Likelihood of working for pay */
event_plot paidw_b1#paidw_v1 paidw_b2#paidw_v2 paidw_b3#paidw_v3 paidw_b4#paidw_v4 paidw_b5#paidw_v5 paidw_b6#paidw_v6, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(dkgreen) mlcolor(dkgreen) mlwidth(thin)) lag_ci_opt4(color(dkgreen) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(+) mfcolor(midgreen) mlcolor(midgreen) mlwidth(thin)) lag_ci_opt5(color(midgreen) lwidth(medthick)) ///
	lag_opt6(msize(small) msymbol(X) mfcolor(green) mlcolor(green) mlwidth(thin)) lag_ci_opt6(color(green) lwidth(medthick))
graph export "$doc\PTA_PaidTStates.png", replace

/* Hrs worked */
event_plot lhwork_b1#lhwork_v1 lhwork_b2#lhwork_v2 lhwork_b3#lhwork_v3 lhwork_b4#lhwork_v4 lhwork_b5#lhwork_v5 lhwork_b6#lhwork_v6, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of hours worked", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(dkgreen) mlcolor(dkgreen) mlwidth(thin)) lag_ci_opt4(color(dkgreen) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(+) mfcolor(midgreen) mlcolor(midgreen) mlwidth(thin)) lag_ci_opt5(color(midgreen) lwidth(medthick)) ///
	lag_opt6(msize(small) msymbol(X) mfcolor(green) mlcolor(green) mlwidth(thin)) lag_ci_opt6(color(green) lwidth(medthick))
graph export "$doc\PTA_lsTStates.png", replace

/* Likelihood of working in formal sector */
event_plot formal_b1#formal_v1 formal_b2#formal_v2 formal_b3#formal_v3 formal_b4#formal_v4 formal_b5#formal_v5 formal_b6#formal_v6, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of hours worked", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(dkgreen) mlcolor(dkgreen) mlwidth(thin)) lag_ci_opt4(color(dkgreen) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(+) mfcolor(midgreen) mlcolor(midgreen) mlwidth(thin)) lag_ci_opt5(color(midgreen) lwidth(medthick)) ///
	lag_opt6(msize(small) msymbol(X) mfcolor(green) mlcolor(green) mlwidth(thin)) lag_ci_opt6(color(green) lwidth(medthick))
graph export "$doc\PTA_FormalTStates.png", replace

*========================================================================*
/* FIGURE XXX: State trends */
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

tab state, generate(dstate)
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 {
	foreach z in 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 ///
	1995 1996 {
gen c_state`z'_`x'=0
replace c_state`z'_`x'=1 if dstate`x'==1 & cohort==`z'
}
}

destring geo, replace

/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b1 = e(estimates) \ 0
matrix hrsEng_v1 = e(variances) \ 0

mat rownames hrsEng_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*) 

matrix hrsEng_b2 = e(estimates) \ 0
matrix hrsEng_v2 = e(variances) \ 0

mat rownames hrsEng_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b1 = e(estimates) \ 0
matrix Eng_v1 = e(variances) \ 0

mat rownames Eng_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*) 

matrix Eng_b2 = e(estimates) \ 0
matrix Eng_v2 = e(variances) \ 0

mat rownames Eng_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b1 = e(estimates) \ 0
matrix wage_v1 = e(variances) \ 0

mat rownames wage_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*) 

matrix wage_b2 = e(estimates) \ 0
matrix wage_v2 = e(variances) \ 0

mat rownames wage_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b1 = e(estimates) \ 0
matrix paidw_v1 = e(variances) \ 0

mat rownames paidw_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*) 

matrix paidw_b2 = e(estimates) \ 0
matrix paidw_v2 = e(variances) \ 0

mat rownames paidw_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hrs worked */
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b1 = e(estimates) \ 0
matrix lhwork_v1 = e(variances) \ 0

mat rownames lhwork_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*) 

matrix lhwork_b2 = e(estimates) \ 0
matrix lhwork_v2 = e(variances) \ 0

mat rownames lhwork_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b1 = e(estimates) \ 0
matrix formal_v1 = e(variances) \ 0

mat rownames formal_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*) 

matrix formal_b2 = e(estimates) \ 0
matrix formal_v2 = e(variances) \ 0

mat rownames formal_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hours of English instruction */
event_plot hrsEng_b1#hrsEng_v1 hrsEng_b2#hrsEng_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Original estimates" 4 "Including state by cohort FE") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_hrsEngFE.png", replace

/* English speaking ability */
event_plot Eng_b1#Eng_v1 Eng_b2#Eng_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_EngFE.png", replace

/* Log of wages */
event_plot wage_b1#wage_v1 wage_b2#wage_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-4(4)12, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) 
graph export "$doc\PTA_WageFE.png", replace

/* Likelihood of working for pay */
event_plot paidw_b1#paidw_v1 paidw_b2#paidw_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_PaidFE.png", replace

/* Hrs worked */
event_plot lhwork_b1#lhwork_v1 lhwork_b2#lhwork_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(2)6, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of hours worked", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_lsFE.png", replace

/* Likelihood of working in formal sector */
event_plot formal_b1#formal_v1 formal_b2#formal_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of hours worked", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) 
graph export "$doc\PTA_FormalFE.png", replace

*========================================================================*
/* Mechanisms */
*========================================================================*
/* Figure X: Jobs requiring English skills */
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
use "$data/eng_abil.dta", clear
merge m:1 sinco2011 using "$base/eng_ocupa.dta", nogen
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

tab state, generate(dstate)
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 {
	foreach z in 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 ///
	1995 1996 {
gen c_state`z'_`x'=0
replace c_state`z'_`x'=1 if dstate`x'==1 & cohort==`z'
}
}

destring geo, replace
sum eng_ocupa, d
return list
gen high_eng=eng_ocupa>=r(p90)

did_multiplegt high_eng geo cohort had_policy if paidw==1 & edu<12, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*) 

matrix heng_b1 = e(estimates) \ 0
matrix heng_v1 = e(variances) \ 0

mat rownames heng_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames heng_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt high_eng geo cohort had_policy if paidw==1 & edu>=12, weight(weight) ///
robust_dynamic dynamic(5) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*)

matrix heng_b2 = e(estimates) \ 0
matrix heng_v2 = e(variances) \ 0

mat rownames heng_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames heng_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in jobs requiring English skills */
event_plot heng_b1#heng_v1 heng_b2#heng_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-3(3)6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of working in jobs requiring English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Low educational attainment" 4 "High educational attainment") pos(11) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_EngJobs.png", replace

did_multiplegt high_eng geo cohort had_policy if paidw==1 & female==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu c_state*) 

matrix seng_b1 = e(estimates) \ 0
matrix seng_v1 = e(variances) \ 0

mat rownames seng_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames seng_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt high_eng geo cohort had_policy if paidw==1 & female==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu c_state*)

matrix seng_b2 = e(estimates) \ 0
matrix seng_v2 = e(variances) \ 0

mat rownames seng_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames seng_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in jobs requiring English skills */
event_plot seng_b1#seng_v1 seng_b2#seng_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of working in jobs requiring English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Men" 4 "Women") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_EngJobsS.png", replace
*========================================================================*
/* Figure 4: Effect of English instruction on occupational decisions */
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

destring geo, replace

tab state, generate(dstate)
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 {
	foreach z in 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 ///
	1995 1996 {
gen c_state`z'_`x'=0
replace c_state`z'_`x'=1 if dstate`x'==1 & cohort==`z'
}
}

sum pact, d
return list

gen phy_act=pact>=r(p75)
replace phy_act=. if paidw!=1

sum communica, d
return list

gen c_abil=communica>=r(p75)
replace c_abil=. if paidw!=1

did_multiplegt phy_act geo cohort had_policy if paidw==1 & edu<12, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*) 

matrix pa_b1 = e(estimates) \ 0
matrix pa_v1 = e(variances) \ 0

mat rownames pa_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames pa_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt phy_act geo cohort had_policy if paidw==1 & edu>=12, weight(weight) ///
robust_dynamic dynamic(5) placebo(5) breps(100) cluster(geo) ///
controls(female edu  c_state*) 

matrix pa_b2 = e(estimates) \ 0
matrix pa_v2 = e(variances) \ 0

mat rownames pa_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames pa_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in physically-intensive jobs */
event_plot pa_b1#pa_v1 pa_b2#pa_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-4(2)4, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of working in physically-intensive jobs", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Low educational attainment" 4 "High educational attainment") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_JobsEdu.png", replace

did_multiplegt phy_act geo cohort had_policy if paidw==1 & female==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu c_state*) 

matrix spa_b1 = e(estimates) \ 0
matrix spa_v1 = e(variances) \ 0

mat rownames spa_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames spa_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt phy_act geo cohort had_policy if paidw==1 & female==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu c_state*)

matrix spa_b2 = e(estimates) \ 0
matrix spa_v2 = e(variances) \ 0

mat rownames spa_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames spa_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in physically-intensive jobs */
event_plot spa_b1#spa_v1 spa_b2#spa_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-3(3)6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of working in physically-intensive jobs", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Men" 4 "Women") pos(11) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_JobsS.png", replace

/*
graph twoway (hist pact, frac ///
xtitle("O*NET score for physically demanding jobs") ///
ytitle("Fraction")) ///
(scatteri 0 73 0.2 73, c(l) m(i)), ///
legend(off)
graph export "$doc\histo_physical.png", replace
*/
*========================================================================*
did_multiplegt c_abil geo cohort had_policy if paidw==1 & edu<12, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*) 

matrix ca_b1 = e(estimates) \ 0
matrix ca_v1 = e(variances) \ 0

mat rownames ca_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames ca_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt c_abil geo cohort had_policy if paidw==1 & edu>=12, weight(weight) ///
robust_dynamic dynamic(5) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*) 

matrix ca_b2 = e(estimates) \ 0
matrix ca_v2 = e(variances) \ 0

mat rownames ca_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames ca_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in jobs requiring communication skills */
event_plot ca_b1#ca_v1 ca_b2#ca_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-4(2)4, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of working in jobs requiring communication", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Low educational attainment" 4 "High educational attainment") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_JobsCEdu.png", replace

did_multiplegt c_abil geo cohort had_policy if paidw==1 & female==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu c_state*) 

matrix sca_b1 = e(estimates) \ 0
matrix sca_v1 = e(variances) \ 0

mat rownames sca_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames sca_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt c_abil geo cohort had_policy if paidw==1 & female==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu c_state*)

matrix sca_b2 = e(estimates) \ 0
matrix sca_v2 = e(variances) \ 0

mat rownames sca_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames sca_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in jobs requiring communication skills */
event_plot sca_b1#sca_v1 sca_b2#sca_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-3(3)6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of working in jobs requiring communication", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Men" 4 "Women") pos(11) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_JobsCS.png", replace

/*
graph twoway (hist communica, frac ///
xtitle("O*NET score for jobs requiring communication") ///
ytitle("Fraction")) ///
(scatteri 0 62 0.2 62, c(l) m(i)), ///
legend(off)
graph export "$doc\histo_communica.png", replace
*/
*========================================================================*
/* Effect on labor supply */
*========================================================================*

did_multiplegt work geo cohort had_policy if edu<12, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(c_state* female edu)

matrix we_b1 = e(estimates) \ 0
matrix we_v1 = e(variances) \ 0

mat rownames we_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames we_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt work geo cohort had_policy if edu>=12, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(c_state* female edu)

matrix we_b2 = e(estimates) \ 0
matrix we_v2 = e(variances) \ 0

mat rownames we_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames we_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working */
event_plot we_b1#we_v1 we_b2#we_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-3(3)6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of working", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Low educational attainment" 4 "High educational attainment") pos(11) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_WorkEdu.png", replace

did_multiplegt work geo cohort had_policy if female==0, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(c_state* edu)

matrix ws_b1 = e(estimates) \ 0
matrix ws_v1 = e(variances) \ 0

mat rownames ws_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames ws_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt work geo cohort had_policy if female==1, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(c_state* edu)

matrix ws_b2 = e(estimates) \ 0
matrix ws_v2 = e(variances) \ 0

mat rownames ws_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames ws_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working */
event_plot ws_b1#ws_v1 ws_b2#ws_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-3(3)6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of working", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Men" 4 "Women") pos(11) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_WorkS.png", replace
*========================================================================*
/* Figure 5: Effect of English instruction on subjective well-being */
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

destring geo, replace

tab state, generate(dstate)
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 {
	foreach z in 1984 1985 1986 1987 1988 1989 1990 1991 1992 1993 1994 ///
	1995 1996 {
gen c_state`z'_`x'=0
replace c_state`z'_`x'=1 if dstate`x'==1 & cohort==`z'
}
}

gen dsgral=sgral>=9
gen dssocial=ssocial>=9
gen dssdl=ssd_living>=9
gen dsachiev=sachiev>=9
gen dsfp=sfuture_perspect>=9
gen dsleissure=sleissure>=9
gen dseact=secon_activity>=9
/*
did_multiplegt dsfp geo cohort had_policy if paidw==1 & edu<12, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu female c_state*)

matrix efp_b1 = e(estimates) \ 0
matrix efp_v1 = e(variances) \ 0

mat rownames efp_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames efp_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt dsfp geo cohort had_policy if paidw==1 & edu>=12, weight(weight) ///
robust_dynamic dynamic(5) placebo(5) breps(100) cluster(geo) ///
controls(edu female c_state*)

matrix efp_b2 = e(estimates) \ 0
matrix efp_v2 = e(variances) \ 0

mat rownames efp_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames efp_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of being satisfied with future perspective */
event_plot efp_b1#efp_v1 efp_b2#efp_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(2)4, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of being satisfied with future perspective", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Low educational attainment" 4 "High educational attainment") pos(11) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_SatisFP_Educa.png", replace

*========================================================================*
did_multiplegt dsfp geo cohort had_policy if paidw==1 & female==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu female c_state*)

matrix sfp_b1 = e(estimates) \ 0
matrix sfp_v1 = e(variances) \ 0

mat rownames sfp_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames sfp_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt dsfp geo cohort had_policy if paidw==1 & female==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu female c_state*)

matrix sfp_b2 = e(estimates) \ 0
matrix sfp_v2 = e(variances) \ 0

mat rownames sfp_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames sfp_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of being satisfied with future perspective */
event_plot sfp_b1#sfp_v1 sfp_b2#sfp_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(2)4, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of being satisfied with future perspective", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Men" 4 "Women") pos(11) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_SatisFP_Sex.png", replace
*/
*========================================================================*
did_multiplegt dseact geo cohort had_policy if paidw==1 & edu<12, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu female c_state*)

matrix eea_b1 = e(estimates) \ 0
matrix eea_v1 = e(variances) \ 0

mat rownames eea_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames eea_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt dseact geo cohort had_policy if paidw==1 & edu>=12, weight(weight) ///
robust_dynamic dynamic(5) placebo(5) breps(100) cluster(geo) ///
controls(edu female c_state*)

matrix eea_b2 = e(estimates) \ 0
matrix eea_v2 = e(variances) \ 0

mat rownames eea_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames eea_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of being satisfied with economic activity */
event_plot eea_b1#eea_v1 eea_b2#eea_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-3(3)6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of being satisfied with economic activity", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Low educational attainment" 4 "High educational attainment") pos(11) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_SatisEA_Educa.png", replace

*========================================================================*
did_multiplegt dseact geo cohort had_policy if paidw==1 & female==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu female c_state*)

matrix sea_b1 = e(estimates) \ 0
matrix sea_v1 = e(variances) \ 0

mat rownames sea_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames sea_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt dseact geo cohort had_policy if paidw==1 & female==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu female c_state*)

matrix sea_b2 = e(estimates) \ 0
matrix sea_v2 = e(variances) \ 0

mat rownames sea_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames sea_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of being satisfied with economic activity */
event_plot sea_b1#sea_v1 sea_b2#sea_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-3(3)6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of being satisfied with economic activity", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Men" 4 "Women") pos(11) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_SatisEA_Sex.png", replace

*========================================================================*
did_multiplegt dssdl geo cohort had_policy if paidw==1 & edu<12, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu female c_state*)

matrix esdl_b1 = e(estimates) \ 0
matrix esdl_v1 = e(variances) \ 0

mat rownames esdl_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames esdl_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt dssdl geo cohort had_policy if paidw==1 & edu>=12, weight(weight) ///
robust_dynamic dynamic(5) placebo(5) breps(100) cluster(geo) ///
controls(edu female c_state*)

matrix esdl_b2 = e(estimates) \ 0
matrix esdl_v2 = e(variances) \ 0

mat rownames esdl_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames esdl_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of being satisfied with standard of living */
event_plot esdl_b1#esdl_v1 esdl_b2#esdl_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-4(2)4, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of being satisfied with standard of living", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Low educational attainment" 4 "High educational attainment") pos(11) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_SatisSDLiving_Educa.png", replace
*========================================================================*

did_multiplegt dssdl geo cohort had_policy if paidw==1 & female==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu c_state*)

matrix ssdl_b1 = e(estimates) \ 0
matrix ssdl_v1 = e(variances) \ 0

mat rownames ssdl_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames ssdl_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt dssdl geo cohort had_policy if paidw==1 & female==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu c_state*)

matrix ssdl_b2 = e(estimates) \ 0
matrix ssdl_v2 = e(variances) \ 0

mat rownames ssdl_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames ssdl_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of being satisfied with standard of living */
event_plot ssdl_b1#ssdl_v1 ssdl_b2#ssdl_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-4(2)4, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of being satisfied with standard of living", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Men" 4 "Women") pos(11) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_SatisSDLiving_Sex.png", replace
*========================================================================*

did_multiplegt dsachiev geo cohort had_policy if paidw==1 & edu<12, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu female c_state*)

matrix each_b1 = e(estimates) \ 0
matrix each_v1 = e(variances) \ 0

mat rownames each_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames each_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt dsachiev geo cohort had_policy if paidw==1 & edu>=12, weight(weight) ///
robust_dynamic dynamic(5) placebo(5) breps(100) cluster(geo) ///
controls(edu female c_state*)

matrix each_b2 = e(estimates) \ 0
matrix each_v2 = e(variances) \ 0

mat rownames each_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames each_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of being satisfied with achievements */
event_plot each_b1#each_v1 each_b2#each_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(2)4, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of being satisfied with achievements", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Low educational attainment" 4 "High educational attainment") pos(11) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_SatisAchiev_Educa.png", replace

*========================================================================*
did_multiplegt dsachiev geo cohort had_policy if paidw==1 & female==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu c_state*)

matrix sach_b1 = e(estimates) \ 0
matrix sach_v1 = e(variances) \ 0

mat rownames sach_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames sach_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt dsachiev geo cohort had_policy if paidw==1 & female==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(edu c_state*)

matrix sach_b2 = e(estimates) \ 0
matrix sach_v2 = e(variances) \ 0

mat rownames sach_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames sach_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of being satisfied with achievements */
event_plot ssdl_b1#ssdl_v1 ssdl_b2#ssdl_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(2)4, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of being satisfied with achievements", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Men" 4 "Women") pos(11) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_SatisAchiev_Sex.png", replace

*========================================================================*
/* Figure 6: School Enrollment */
*========================================================================*
use "$data/eng_abil.dta", clear
grstyle init
grstyle set plain, horizontal
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

merge m:1 age using "$data/cumm_enroll_15.dta", nogen

destring geo, replace

did_multiplegt stud geo cohort had_policy if age<=23, weight(weight) ///
robust_dynamic dynamic(2) placebo(1) breps(100) cluster(geo) ///
controls(edu female)

matrix es_b1 = e(estimates) \ 0
matrix es_v1 = e(variances) \ 0

mat rownames es_b1 = Effect_0 Effect_1 Effect_2 Average Placebo_2 Placebo_1
mat rownames es_v1 = Effect_0 Effect_1 Effect_2 Average Placebo_2 Placebo_1

did_multiplegt stud geo cohort had_policy if age<=25, weight(weight) ///
robust_dynamic dynamic(2) placebo(1) breps(100) cluster(geo) ///
controls(edu female)

matrix es_b2 = e(estimates) \ 0
matrix es_v2 = e(variances) \ 0

mat rownames es_b2 = Effect_0 Effect_1 Effect_2 Average Placebo_2 Placebo_1
mat rownames es_v2 = Effect_0 Effect_1 Effect_2 Average Placebo_2 Placebo_1

did_multiplegt stud geo cohort had_policy if age<=27, weight(weight) ///
robust_dynamic dynamic(2) placebo(1) breps(100) cluster(geo) ///
controls(edu female)

matrix es_b3 = e(estimates) \ 0
matrix es_v3 = e(variances) \ 0

mat rownames es_b3 = Effect_0 Effect_1 Effect_2 Average Placebo_2 Placebo_1
mat rownames es_v3 = Effect_0 Effect_1 Effect_2 Average Placebo_2 Placebo_1

did_multiplegt stud geo cohort had_policy if age<=29, weight(weight) ///
robust_dynamic dynamic(2) placebo(1) breps(100) cluster(geo) ///
controls(edu female)

matrix es_b4 = e(estimates) \ 0
matrix es_v4 = e(variances) \ 0

mat rownames es_b4 = Effect_0 Effect_1 Effect_2 Average Placebo_2 Placebo_1
mat rownames es_v4 = Effect_0 Effect_1 Effect_2 Average Placebo_2 Placebo_1

/* Likelihood of being enrolled in school */
event_plot es_b1#es_v1 es_b2#es_v2 es_b3#es_v3 es_b4#es_v4, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.3(0.3)0.6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of being enrolled in school", size(medium) height(5)) ///
	xlabel(-2(1)2) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "age<24" 4 "age<26" 6 "age<28" 8 "age<30") pos(11) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(dkgreen) mlcolor(dkgreen) mlwidth(thin)) lag_ci_opt4(color(dkgreen) lwidth(medthick))
graph export "$doc\fig_edu_enroll.png", replace

*========================================================================*
did_multiplegt stud geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(2) placebo(1) breps(100) cluster(geo) ///
controls(edu female)

matrix des_b1 = e(estimates) \ 0
matrix des_v1 = e(variances) \ 0

mat rownames des_b1 = Effect_0 Effect_1 Effect_2 Average Placebo_2 Placebo_1
mat rownames des_v1 = Effect_0 Effect_1 Effect_2 Average Placebo_2 Placebo_1

did_multiplegt stud geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(3) placebo(1) breps(100) cluster(geo) ///
controls(edu female)

matrix des_b2 = e(estimates) \ 0
matrix des_v2 = e(variances) \ 0

mat rownames des_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_1
mat rownames des_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_1

did_multiplegt stud geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(4) placebo(1) breps(100) cluster(geo) ///
controls(edu female)

matrix des_b3 = e(estimates) \ 0
matrix des_v3 = e(variances) \ 0

mat rownames des_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_1
mat rownames des_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_1

did_multiplegt stud geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(5) placebo(1) breps(100) cluster(geo) ///
controls(edu female)

matrix des_b4 = e(estimates) \ 0
matrix des_v4 = e(variances) \ 0

mat rownames des_b4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_1
mat rownames des_v4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_1

did_multiplegt stud geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(1) breps(100) cluster(geo) ///
controls(edu female)

matrix des_b5 = e(estimates) \ 0
matrix des_v5 = e(variances) \ 0

mat rownames des_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_1
mat rownames des_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_1

/* Likelihood of being enrolled in school */
event_plot des_b1#des_v1 des_b2#des_v2 des_b3#des_v3 des_b4#des_v4 des_b5#des_v5, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.6(0.3)0.6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of being enrolled in school", size(medium) height(5)) ///
	xlabel(-2(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(dkgreen) mlcolor(dkgreen) mlwidth(thin)) lag_ci_opt4(color(dkgreen) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(+) mfcolor(green) mlcolor(green) mlwidth(thin)) lag_ci_opt5(color(green) lwidth(medthick))
graph export "$doc\fig_edu_enroll2.png", replace

*========================================================================*
did_multiplegt stud geo cohort had_policy if edu<12, weight(weight) ///
robust_dynamic dynamic(6) placebo(1) breps(100) cluster(geo) ///
controls(edu)

matrix dses_b1 = e(estimates) \ 0
matrix dses_v1 = e(variances) \ 0

mat rownames dses_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_1
mat rownames dses_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_1

did_multiplegt stud geo cohort had_policy if edu>=12, weight(weight) ///
robust_dynamic dynamic(6) placebo(1) breps(100) cluster(geo) ///
controls(edu)

matrix dses_b2 = e(estimates) \ 0
matrix dses_v2 = e(variances) \ 0

mat rownames dses_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_1
mat rownames dses_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_1

/* Likelihood of being enrolled in school */
event_plot dses_b1#dses_v1 dses_b2#dses_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of being enrolled in school", size(medium) height(5)) ///
	xlabel(-2(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Low educational attainment" 4 "High educational attainment") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\fig_edu_enroll3.png", replace

*========================================================================*
/* Effect on industries */
*========================================================================*
destring scian, replace
gen econ_act=.
replace econ_act=1 if (scian>=1110 & scian<=1199)
replace econ_act=2 if (scian>1199 & scian<=2399) | ///
(scian>4699 & scian<=4930)
replace econ_act=3 if scian>2399 & scian<=3399
replace econ_act=4 if scian>3399 & scian<=4699
replace econ_act=5 if (scian>5399 & scian<=5622) | ///
(scian>7223 & scian<=8140) | (scian>5199 & scian<=5399)
replace econ_act=6 if (scian>5622 & scian<=6299) | ///
(scian>8140 & scian!=.)
replace econ_act=7 if (scian>6299 & scian<=7223) | ///
(scian>4930 & scian<=5199)

label define econ_act 1 "Agriculture" 2 "Construction" 3 "Manufactures" 4 "Commerce" ///
5 "Professionals" 6 "Government" 7 "Hospitality and Entertainment"
label values econ_act econ_act

gen ag_ea=econ_act==1 
replace ag_ea=. if econ_act==.
gen cons_ea=econ_act==2 
replace cons_ea=. if econ_act==.
gen manu_ea=econ_act==3 
replace manu_ea=. if econ_act==.
gen comm_ea=econ_act==4 
replace comm_ea=. if econ_act==.
gen pro_ea=econ_act==5 
replace pro_ea=. if econ_act==.
gen gov_ea=econ_act==6 
replace gov_ea=. if econ_act==.
gen hosp_ea=econ_act==7 
replace hosp_ea=. if econ_act==.

did_multiplegt ag_ea geo cohort had_policy if paidw==1 & edu<12, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(c_state* female edu)

matrix eag_b1 = e(estimates) \ 0
matrix eag_v1 = e(variances) \ 0

mat rownames eag_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames eag_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt ag_ea geo cohort had_policy if paidw==1 & edu>=12, weight(weight) robust_dynamic dynamic(5) placebo(5) breps(100) cluster(geo) controls(c_state* female edu)

matrix eag_b2 = e(estimates) \ 0
matrix eag_v2 = e(variances) \ 0

mat rownames eag_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames eag_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
/* Likelihood of working in agriculture */
event_plot eag_b1#eag_v1 eag_b2#eag_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(2)4, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of working in agriculture", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Low educational attainment" 4 "High educational attainment") pos(11) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_AgE.png", replace
*========================================================================*
did_multiplegt cons_ea geo cohort had_policy if paidw==1 & edu<12, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(c_state* female edu)

matrix econs_b1 = e(estimates) \ 0
matrix econs_v1 = e(variances) \ 0

mat rownames econs_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames econs_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt cons_ea geo cohort had_policy if paidw==1 & edu>=12, weight(weight) robust_dynamic dynamic(5) placebo(5) breps(100) cluster(geo) controls(c_state* female edu)

matrix econs_b2 = e(estimates) \ 0
matrix econs_v2 = e(variances) \ 0

mat rownames econs_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames econs_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in construction */
event_plot econs_b1#econs_v1 econs_b2#econs_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(2)4, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of working in construction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_ConsE.png", replace
*========================================================================*
did_multiplegt manu_ea geo cohort had_policy if paidw==1 & edu<12, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(c_state* female edu)

matrix emanu_b1 = e(estimates) \ 0
matrix emanu_v1 = e(variances) \ 0

mat rownames emanu_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames emanu_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt manu_ea geo cohort had_policy if paidw==1 & edu>=12, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(c_state* female edu)

matrix emanu_b2 = e(estimates) \ 0
matrix emanu_v2 = e(variances) \ 0

mat rownames emanu_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames emanu_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in manufacturing */
event_plot emanu_b1#emanu_v1 emanu_b2#emanu_v2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(2)4, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of working in manufacturing", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt2(color(navy) lwidth(medthick))
graph export "$doc\PTA_SDD_ManuE.png", replace
*========================================================================*
did_multiplegt comm_ea geo cohort had_policy if paidw==1 & edu<12, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(c_state* female edu)


did_multiplegt comm_ea geo cohort had_policy if paidw==1 & edu<12, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(c_state* female edu)
*========================================================================*
did_multiplegt pro_ea geo cohort had_policy if paidw==1 & edu<12, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(c_state* female edu)


did_multiplegt pro_ea geo cohort had_policy if paidw==1 & edu<12, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(c_state* female edu)
*========================================================================*
did_multiplegt gov_ea geo cohort had_policy if paidw==1 & edu<12, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(c_state* female edu)


did_multiplegt gov_ea geo cohort had_policy if paidw==1 & edu<12, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(c_state* female edu)
*========================================================================*
did_multiplegt hosp_ea geo cohort had_policy if paidw==1 & edu<12, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(c_state* female edu)


did_multiplegt hosp_ea geo cohort had_policy if paidw==1 & edu<12, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(c_state* female edu)