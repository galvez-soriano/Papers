*========================================================================*
* English instruction in Mexico and labor market outcomes in the US
*========================================================================*
* Oscar Galvez-Soriano, Maria Padilla, and Camila Morales
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\OneDrive - The University of Chicago\Documents\Papers\IPUMS\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\OneDrive - The University of Chicago\Documents\Papers\IPUMS\Doc"

graph set window fontface "Times New Roman"
*========================================================================*
/*
use "$data/Papers/main/IPUMS_Eng/Data/ipums_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 {
    append using "$data/Papers/main/IPUMS_Eng/Data/ipums_`x'.dta"
}
save "$base\ipums.dta", replace 
*/
*=====================================================================*
use "$base\ACS22_24.dta", clear
// use "$base\ACS24.dta", clear

rename birthyr cohort
keep if cohort>=1995 & cohort<=2010
keep if hispan!=0
gen age_migra=age-(year-yrimmig)
replace age_migra=0 if age_migra<0

/* Creating first cohort treated variable */
gen first_cohort=2000 if bpld==20000
replace first_cohort=2004 if bpld==30020
replace first_cohort=2017 if bpld==30015
replace first_cohort=2011 if bpld==30030
replace first_cohort=2001 if bpld==50040
replace first_cohort=2001 if bpld==50000
replace first_cohort=2011 if bpld==50100
replace first_cohort=2018 if bpld==51800
replace first_cohort=2013 if bpld==46547
replace first_cohort=2021 if bpld==54000
replace first_cohort=2013 if bpld==54200
replace first_cohort=2004 if bpld==43400
replace first_cohort=2002 if bpld==42100
replace first_cohort=2016 if bpld==43600
replace first_cohort=2009 if bpld==45500
replace first_cohort=2026 if first_cohort==.
replace first_cohort=. if bpld<=5600

/* Removing from the treatment the indiviuals who migrated to the US
when they were kids because they did no have exposure to the policy
and because they had exposure to the English language in the US. The policy 
started as a trial stage in 2009, but expanded for three years until 2011 */
drop if yrimmig<2009 & bpld==20000
drop if yrimmig<2010 & bpld==20000 & cohort==2004
drop if yrimmig<2011 & bpld==20000 & cohort==2005
drop if yrimmig<2012 & bpld==20000 & cohort==2006
drop if yrimmig<2013 & bpld==20000 & cohort==2007
drop if yrimmig<2014 & bpld==20000 & cohort==2008
drop if yrimmig<2015 & bpld==20000 & cohort==2009
drop if yrimmig<2016 & bpld==20000 & cohort==2010

/* Indicator for individuals who self-report that they speak English well,
very well or they only speak English */ 
gen eng=speakeng>=3 & speakeng<=5
replace eng=0 if speakeng==6

replace inctot=. if inctot==9999999 | inctot==9999998
replace incwage=. if incwage==999999 | incwage==999998

gen lincome=asinh(inctot)
gen lwage=asinh(incwage)
gen work=empstat==1
gen white=race==1
recode labforce (0=.) (1=0) (2=1)
recode sex (2=0)
*============================================================*
sum first_cohort
gen last_cohort = first_cohort==r(max) // dummy for the latest- or never-treated cohort

gen K=cohort-first_cohort
tab K
/* Define the leads and lags as the min and max values -1, respectively */
forvalues l = 0/9 {
	gen L`l'event = K==`l'
}
forvalues l = 1/8 {
	gen F`l'event = K==-`l'
}
gen L10event=K>=10
replace F1event=0 // normalize K=-1 to zero

*============================================================*
/* TWFE estimation */ 
*============================================================*
/* English speaking abilities */
reghdfe eng F*event L*event [aw=perwt] if first_cohort!=., ///
absorb(bpld year yrimmig#cohort) vce(cluster cluster)
estimates store ols_eng

event_plot ols_eng, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-8(1)10, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\figEng_vsImmigrants.png", replace
*========================================================================*
/* Education */
reghdfe educ F*event L*event [aw=perwt] if first_cohort!=., ///
absorb(bpld year yrimmig#cohort) vce(cluster cluster)
estimates store ols_edu

event_plot ols_edu, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Years of education", size(medium) height(5)) ///
	xlabel(-8(1)10, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\figEdu_vsImmigrants.png", replace

*========================================================================*
/* Work */
drop L10event L9event L8event L7event F8event F7event F6event

reghdfe work F*event L*event educ sex [aw=perwt] if first_cohort!=., ///
absorb(bpld year yrimmig#cohort) vce(cluster cluster)
estimates store ols_work

event_plot ols_work, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of working", size(medium) height(5)) ///
	xlabel(-5(1)6, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\figWork_vsImmigrants.png", replace

*========================================================================*
/* Wages */
reghdfe lwage F*event L*event educ sex [aw=perwt] if first_cohort!=. & work==1, ///
absorb(bpld year yrimmig#cohort) vce(cluster cluster)
estimates store ols_wage

event_plot ols_wage, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Change in wages (percent)", size(medium) height(5)) ///
	xlabel(-5(1)6, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\figWages_vsImmigrants.png", replace

*========================================================================*
/* Borusyak, Jaravel, and Spiess (2024) */
*========================================================================*
/* English speaking abilities */
did_imputation eng bpld cohort first_cohort [aw=perwt] if first_cohort!=., ///
horizons(0/10) pretrend(8) cluster(cluster) fe(bpld year yrimmig#cohort) autos minn(0)
estimates store bjs_eng

event_plot bjs_eng, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-8(1)10, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_eng.png", replace

/* Education */
did_imputation educ bpld cohort first_cohort [aw=perwt] if first_cohort!=., ///
horizons(0/10) pretrend(8) cluster(cluster) fe(bpld year yrimmig#cohort) autos minn(0)
estimates store bjs_edu

event_plot bjs_edu, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Years of education", size(medium) height(5)) ///
	xlabel(-8(1)10, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_edu.png", replace

/* Work */
did_imputation work bpld cohort first_cohort [aw=perwt] if first_cohort!=., ///
horizons(0/6) pretrend(5) cluster(cluster) fe(bpld year yrimmig#cohort) ///
controls(educ sex) autos minn(0)
estimates store bjs_work

event_plot bjs_work, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of working", size(medium) height(5)) ///
	xlabel(-5(1)6, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_work.png", replace

/* Wages */
did_imputation lwage bpld cohort first_cohort [aw=perwt] if first_cohort!=. & work==1, ///
horizons(0/6) pretrend(5) cluster(cluster) fe(bpld year yrimmig#cohort) ///
controls(educ sex) autos minn(0)
estimates store bjs_wage

event_plot bjs_wage, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Change in wages (percent)", size(medium) height(5)) ///
	xlabel(-5(1)6, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_wage.png", replace