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
/* FIGURE X. Effect of English programs */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
keep if cohort>=1981 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)
destring state, replace
destring geo, replace
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23{
gen educ`x'=edu==`x'
}

gen Ei=1997
replace Ei=1990 if state=="01" & engl==1
replace Ei=1991 if state=="10" & engl==1
replace Ei=1987 if state=="19" & engl==1
replace Ei=1993 if state=="25" & engl==1
replace Ei=1993 if state=="26" & engl==1
replace Ei=1990 if state=="28" & engl==1

*bysort geo (cohort): replace Ei = Ei[1]
gen K = cohort-Ei				// "relative time", i.e. the number periods since treated (could be missing if never-treated)
gen D = K>=0 & Ei!=. 			// treatment indicator
*========================================================================*
/* 
Estimation with did_imputation of Borusyak et al. (2021) 
Note: I need to figure out how to include a reference (omitted) period
*/
*========================================================================*
did_imputation hrs_exp geo cohort Ei if paidw==1, fe(geo cohort edu female state#cohort) controls(indigenous married) cluster(geo) autosample allhorizons pretrend(6) minn(0) wtr(weight)
event_plot, default_look graph_opt(xtitle("Cohorts since policy intervention") ytitle("Weekly hours of English instruction") ///
xlabel(-6(1)9))

estimates store bjs // storing the estimates for later
*========================================================================*
/* Estimation with did_multiplegt of de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt hrs_exp geo cohort D if paidw==1, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(female indigenous married educ*)
*event_plot e(estimates)#e(variances), default_look graph_opt(xtitle("Cohorts since policy intervention") ytitle("Weekly hours of English instruction") ///
*xlabel(-6(1)6)) stub_lag(Effect_#) stub_lead(Placebo_#) together

matrix dcdh_b = e(estimates) // storing the estimates for later
matrix dcdh_v = e(variances)
*========================================================================*
/* Estimation with csdid of Callaway and Sant'Anna (2020) */
*========================================================================*
gen gvar = cond(Ei==., 0, Ei) // group variable as required for the csdid command
csdid Y, ivar(i) time(t) gvar(gvar) notyet
estat event, estore(cs) // this produces and stores the estimates at the same time
event_plot cs, default_look graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") xlabel(-14(1)5) ///
	title("Callaway and Sant'Anna (2020)")) stub_lag(Tp#) stub_lead(Tm#) together

// Estimation with eventstudyinteract of Sun and Abraham (2020)
sum Ei
gen lastcohort = Ei==r(max) // dummy for the latest- or never-treated cohort
forvalues l = 0/5 {
	gen L`l'event = K==`l'
}
forvalues l = 1/14 {
	gen F`l'event = K==-`l'
}
drop F1event // normalize K=-1 (and also K=-15) to zero
eventstudyinteract Y L*event F*event, vce(cluster i) absorb(i t) cohort(Ei) control_cohort(lastcohort)
event_plot e(b_iw)#e(V_iw), default_look graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") xlabel(-14(1)5) ///
	title("Sun and Abraham (2020)")) stub_lag(L#event) stub_lead(F#event) together

matrix sa_b = e(b_iw) // storing the estimates for later
matrix sa_v = e(V_iw)

// TWFE OLS estimation (which is correct here because of treatment effect homogeneity). Some groups could be binned.
reghdfe Y F*event L*event, a(i t) cluster(i)
event_plot, default_look stub_lag(L#event) stub_lead(F#event) together graph_opt(xtitle("Days since the event") ytitle("OLS coefficients") xlabel(-14(1)5) ///
	title("OLS"))

estimates store ols // saving the estimates for later

// Construct the vector of true average treatment effects by the number of periods since treatment
matrix btrue = J(1,6,.)
matrix colnames btrue = tau0 tau1 tau2 tau3 tau4 tau5
qui forvalues h = 0/5 {
	sum tau if K==`h'
	matrix btrue[1,`h'+1]=r(mean)
}

// Combine all plots using the stored estimates
event_plot btrue# bjs dcdh_b#dcdh_v cs sa_b#sa_v ols, ///
	stub_lag(tau# tau# Effect_# Tp# L#event L#event) stub_lead(pre# pre# Placebo_# Tm# F#event F#event) plottype(scatter) ciplottype(rcap) ///
	together perturb(-0.325(0.13)0.325) trimlead(5) noautolegend ///
	graph_opt(title("Event study estimators in a simulated panel (300 units, 15 periods)", size(medlarge)) ///
		xtitle("Periods since the event") ytitle("Average causal effect") xlabel(-5(1)5) ylabel(0(1)3) ///
		legend(order(1 "True value" 2 "Borusyak et al." 4 "de Chaisemartin-D'Haultfoeuille" ///
				6 "Callaway-Sant'Anna" 8 "Sun-Abraham" 10 "OLS") rows(3) region(style(none))) ///
	/// the following lines replace default_look with something more elaborate
		xline(-0.5, lcolor(gs8) lpattern(dash)) yline(0, lcolor(gs8)) graphregion(color(white)) bgcolor(white) ylabel(, angle(horizontal)) ///
	) ///
	lag_opt1(msymbol(+) color(cranberry)) lag_ci_opt1(color(cranberry)) ///
	lag_opt2(msymbol(O) color(cranberry)) lag_ci_opt2(color(cranberry)) ///
	lag_opt3(msymbol(Dh) color(navy)) lag_ci_opt3(color(navy)) ///
	lag_opt4(msymbol(Th) color(forest_green)) lag_ci_opt4(color(forest_green)) ///
	lag_opt5(msymbol(Sh) color(dkorange)) lag_ci_opt5(color(dkorange)) ///
	lag_opt6(msymbol(Oh) color(purple)) lag_ci_opt6(color(purple)) 
graph export "five_estimators_example.png", replace
*========================================================================*
/* TABLE 4. Effect of English programs (staggered DiD) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
keep if cohort>=1981 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

tab state, generate(dstate)
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 {
gen c_state`x'=dstate`x'*cohort
}

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1
*========================================================================*
/* Full sample (staggered DiD) */ 
*========================================================================*
eststo clear
eststo: areg hrs_exp had_policy i.cohort i.edu female indigenous married c_state* ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg eng had_policy i.cohort i.edu cohort female indigenous married c_state* ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg lwage had_policy i.cohort i.edu female indigenous married c_state* ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg paidw had_policy i.cohort i.edu female indigenous married c_state* ///
[aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg lhwork had_policy i.cohort i.edu female indigenous married c_state* ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg formal had_policy i.cohort i.edu female indigenous married c_state* ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
esttab using "$doc\tab_StaggDD.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
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

eventstudyinteract hrs_exp had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)

event_plot e(b_iw)#e(V_iw), default_look graph_opt(xtitle("Cohorts since policy intervention") ///
ytitle("Weekly hours of English instruction") xlabel(-6(1)6)) ///
stub_lag(L#event) stub_lead(F#event) together

eventstudyinteract eng had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)
eventstudyinteract lwage had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)
eventstudyinteract paidw had_policy [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)
eventstudyinteract lhwork had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)
eventstudyinteract formal had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)

*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
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
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*

did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(female indigenous married educ*)
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(female indigenous married educ*)
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(female indigenous married educ*)
did_multiplegt paidw geo cohort had_policy, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(female indigenous married educ*)
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(female indigenous married educ*)
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) controls(female indigenous married educ*)

*========================================================================*
/* Wooldridge (2021) */
*========================================================================*
gen treat=first_cohort>0
hdidregress twfe (bmi medu i.girl i.sports) (hhabit), group(schools) time(year)
hdidregress twfe (lwage female indigenous married edu) (treat), group(geo) time(cohort)

*========================================================================*
/* Borusyak, Jaravel, and Spiess (2023) */
*========================================================================*

did_imputation lwage id cohort had_policy, fe(geo cohort) cluster(geo)
