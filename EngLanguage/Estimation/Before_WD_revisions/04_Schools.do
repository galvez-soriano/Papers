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
/*  Treatment at municipality level to explore effects on enrollment in 
Indigenous schools */
*========================================================================*
use "$base\SchoolsDB.dta", clear
bysort cct: gen same_school=_N
keep if same_school==10
drop same_school

*========================================================================*
/* FIGURE 10. Mechanisms: School enrollment */
*========================================================================*
/* Public, non-indigenous schools */
csdid total_stud shift total_groups school_supp_exp uniform_exp tuition fts if public==1, ///
time(year) gvar(first_treat) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_nstud)

/* Panel (a) */
event_plot csdid_nstud, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm#) ///
    stub_lag(Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-200(100)200, labs(medium) grid format(%5.0f)) ///
	ytitle("Number of students enrolled in school", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_CS_nstud.png", replace

/* Public, non-indigenous schools */
csdid indig_stud shift total_groups total_stud school_supp_exp uniform_exp tuition fts if public==1, ///
time(year) gvar(first_treat) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_istud)

/* Panel (b) */
event_plot csdid_istud, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm#) ///
    stub_lag(Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
	ytitle("Number of Indigenous students enrolled in school", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_CS_istud.png", replace
*========================================================================*
/* Treatment at the municipality level for Indigenous schools */
*========================================================================*
use "$base\SchoolsDB.dta", clear
bysort cct: gen same_school=_N
keep if same_school==10
drop same_school

gen str geo=state+id_mun
merge m:1 year geo using "$base\dbs_mun.dta", nogen

/* Indigenous schools */
csdid total_stud shift total_groups if indig_school==1, ///
time(year) gvar(first_treat_mun) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_nstud_ind)

/* Panel (c) */
event_plot csdid_nstud_ind, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm#) ///
    stub_lag(Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-100(50)100, labs(medium) grid format(%5.0f)) ///
	ytitle("Number of students enrolled in Indigenous schools", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_CS_nstud_ind.png", replace
