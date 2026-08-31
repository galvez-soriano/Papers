*========================================================================*
* English program and language skills
*========================================================================*
* Oscar Galvez-Soriano and Ornella Darova
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngLanguage\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngLanguage\Doc"
*========================================================================*
/* Effect on test scores */
*========================================================================*
use "$base\ENLACE_0613.dta", clear

keep if grade==5

sum s_spa
gen ss=(s_spa-r(mean))/r(sd)
label var ss "Language"
sum s_math
gen sm=(s_math-r(mean))/r(sd)
label var sm "Math"

collapse ss sm treat first_treat gender n_students rural fts indig_school sind shift, by(cct year)

*========================================================================*
/* FIGURE 9. Mechanism: Cognitive abilities in schools with indigenous 
students */
*========================================================================*
csdid ss gender n_students rural fts indig_school shift if sind==1, ///
time(year) gvar(first_treat) method(dripw) vce(cluster cct) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_ss5_ind)

csdid sm gender n_students rural fts indig_school shift if sind==1, ///
time(year) gvar(first_treat) method(dripw) vce(cluster cct) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_sm5_ind)

/* Panel (a) */
event_plot csdid_ss5_ind csdid_sm5_ind, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm# Tm#) ///
    stub_lag(Tp# Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1.6(0.8)1.6, labs(medium) grid format(%5.2f)) ///
	ytitle("Test score (standard deviations)", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Spanish" 4 "Mathematics") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
	lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_CS_ts5_ind.png", replace
*========================================================================*
use "$base\ENLACE_0613.dta", clear

keep if grade==6

sum s_spa
gen ss=(s_spa-r(mean))/r(sd)
label var ss "Language"
sum s_math
gen sm=(s_math-r(mean))/r(sd)
label var sm "Math"

collapse ss sm treat first_treat gender n_students rural sind fts indig_school shift, by(cct year)

csdid ss gender n_students rural fts indig_school shift if sind==1, ///
time(year) gvar(first_treat) method(dripw) vce(cluster cct) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_ss6_ind)

csdid sm gender n_students rural fts indig_school shift if sind==1, ///
time(year) gvar(first_treat) method(dripw) vce(cluster cct) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_sm6_ind)

/* Panel (b) */
event_plot csdid_ss6_ind csdid_sm6_ind, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm# Tm#) ///
    stub_lag(Tp# Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1.6(0.8)1.6, labs(medium) grid format(%5.2f)) ///
	ytitle("Test score (standard deviations)", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
	lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_CS_ts6_ind.png", replace
