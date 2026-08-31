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
/*
use "$data/Papers/main/EngLanguage/Data/labor_census20_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 {
    append using "$data/Papers/main/EngMigration/Data/labor_census20_`x'.dta"
}
save "$base\labor_census20.dta", replace 
*/
*========================================================================*
use "$base\labor_census20.dta", clear
drop if state=="05" | state=="17"
keep if migrant==0
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

gen first_cohort=0
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

destring geo, replace
*========================================================================*
/* FIGURE 1. Language abilities */
*========================================================================*
replace elengua=1 if hlengua==1
csdid elengua edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd)

/* Panel (a) */
event_plot csdid_understInd, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm#) ///
    stub_lag(Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of understanding an Indigenous language", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_CS_understInd.png", replace

csdid hlengua edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd)

/* Panel (b) */
event_plot csdid_speaksInd, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm#) ///
    stub_lag(Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of speaking an Indigenous language", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_CS_speaksInd.png", replace
*========================================================================*
/* ====================== Heterogeneous effects ======================= */
*========================================================================*
/* FIGURE 2. Language abilities by regional context */
*========================================================================*
csdid elengua edu female dmigrant if rural==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd_urban)

csdid elengua edu female dmigrant if rural==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd_rural)

/* Panel (a) */
event_plot csdid_understInd_urban csdid_understInd_rural, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm# Tm#) ///
    stub_lag(Tp# Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of understanding an Indigenous language", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Urban" 4 "Rural") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
	lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_CS_understInd_Context.png", replace

csdid hlengua edu dmigrant female if rural==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd_urban)

csdid hlengua edu dmigrant female if rural==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd_rural)

/* Panel (b) */
event_plot csdid_speaksInd_urban csdid_speaksInd_rural, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm# Tm#) ///
    stub_lag(Tp# Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of speaking an Indigenous language", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
	lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_CS_speaksInd_Context.png", replace
*========================================================================*
/* FIGURE 3. Language abilities by educational attainment */
*========================================================================*
csdid elengua female rural dmigrant if edu<=9 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd_lowEdu)

csdid elengua female rural dmigrant if edu>9 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd_highEdu)

/* Panel (a) */
event_plot csdid_understInd_lowEdu csdid_understInd_highEdu, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm# Tm#) ///
    stub_lag(Tp# Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of understanding an Indigenous language", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Low educational attainment" 4 "High educational attainment") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
	lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_CS_understInd_Edu.png", replace

csdid hlengua dmigrant female rural if edu<=9 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd_lowEdu)

csdid hlengua dmigrant female rural if edu>9 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd_highEdu)

/* Panel (b) */
event_plot csdid_speaksInd_lowEdu csdid_speaksInd_highEdu, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm# Tm#) ///
    stub_lag(Tp# Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of speaking an Indigenous language", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
	lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_CS_speaksInd_Edu.png", replace
*========================================================================*
/* FIGURE 4. Language abilities by income */
*========================================================================*
csdid elengua edu female rural dmigrant if wage<=5160 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd_low_wage)

csdid elengua edu female rural dmigrant if wage>5160 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd_high_wage)

/* Panel (a) */
event_plot csdid_understInd_low_wage csdid_understInd_high_wage, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm# Tm#) ///
    stub_lag(Tp# Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of understanding an Indigenous language", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Low income" 4 "High income") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
	lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_CS_understInd_wage.png", replace

csdid hlengua edu dmigrant female rural if wage<=5160 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd_low_wage)

csdid hlengua edu dmigrant female rural if wage>5160 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd_high_wage)

/* Panel (b) */
event_plot csdid_speaksInd_low_wage csdid_speaksInd_high_wage, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm# Tm#) ///
    stub_lag(Tp# Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of speaking an Indigenous language", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
	lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_CS_speaksInd_wage.png", replace
*========================================================================*
/* FIGURE 5. Language abilities by sex */
*========================================================================*
csdid elengua edu rural dmigrant if female==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd_women)

csdid elengua edu rural dmigrant if female==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd_men)

/* Panel (a) */
event_plot csdid_understInd_women csdid_understInd_men, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm# Tm#) ///
    stub_lag(Tp# Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of understanding an Indigenous language", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Women" 4 "Men") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
	lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_CS_understInd_Sex.png", replace

csdid hlengua edu rural dmigrant if female==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd_women)

csdid hlengua edu rural dmigrant if female==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd_men)

/* Panel (b) */
event_plot csdid_speaksInd_women csdid_speaksInd_men, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm# Tm#) ///
    stub_lag(Tp# Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of speaking an Indigenous language", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
	lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_CS_speaksInd_Sex.png", replace
*========================================================================*
/* FIGURE 6. Mechanism: Indigenous identity */
*========================================================================*
csdid indigenous edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_indig)

event_plot csdid_indig, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm#) ///
    stub_lag(Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of self-identifying as Indigenous", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_CS_indig.png", replace
*========================================================================*
/* FIGURE 7. Mechanism: Mobility */
*========================================================================*
csdid dmigrant edu female rural migrant if indigenous==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
*estat all, window(-4 6)
estat event, window(-4 6) estore(csdid_dmigrant_Ind)

csdid dmigrant edu female rural migrant if indigenous==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
*estat all, window(-4 6)
estat event, window(-4 6) estore(csdid_dmigrant_NoInd)

event_plot csdid_dmigrant_Ind csdid_dmigrant_NoInd, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm# Tm#) ///
    stub_lag(Tp# Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.6(0.3)0.6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating domestically", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Indigenous" 4 "Non-indigenous") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
	lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_CS_dmigrant.png", replace
*========================================================================*
/* FIGURE 8. Mechanism: Tourism industry */
*========================================================================*
rename actividades_c naics
gen tourism=naics==4810 | naics==4870 | naics==5321 | naics==5615 | naics==7120 ///
| naics==7210 | naics==7221

csdid tourism edu female rural migrant if indigenous==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_Tour_Ind)

csdid tourism edu female rural migrant if indigenous==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_Tour_NoInd)

event_plot csdid_Tour_Ind csdid_Tour_NoInd, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm# Tm#) ///
    stub_lag(Tp# Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of working in tourism industry", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Indigenous" 4 "Non-indigenous") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
	lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_CS_tourism.png", replace
*========================================================================*
/* FIGURE 9. Mechanism: Cognitive abilities in schools with indigenous 
students */
*========================================================================*
/* Produced with the do file "03_Test_scores.do" */

*========================================================================*
/* FIGURE 10. Mechanism: School enrollment */
*========================================================================*
/* Produced with the do file "test_scores.do" */

*========================================================================*
/* ============================ Robustness ============================ */
*========================================================================*
/* FIGURE 11. Comparison only with Northern states */
*========================================================================*
csdid elengua edu rural female dmigrant if state=="01" | state=="02" | ///
state=="03" | state=="05" | state=="08" | state=="10" | state=="11" | ///
state=="14" | state=="18" | state=="19" | state=="22" | state=="24" | ///
state=="25" | state=="26" | state=="28" | state=="32" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understIndNS)

/* Panel (a) */
event_plot csdid_understIndNS, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm#) ///
    stub_lag(Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of understanding an Indigenous language", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_CS_understIndNS.png", replace

csdid hlengua edu rural female dmigrant if state=="01" | state=="02" | ///
state=="03" | state=="05" | state=="08" | state=="10" | state=="11" | ///
state=="14" | state=="18" | state=="19" | state=="22" | state=="24" | ///
state=="25" | state=="26" | state=="28" | state=="32" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksIndNS)

/* Panel (b) */
event_plot csdid_speaksIndNS, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm#) ///
    stub_lag(Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of speaking an Indigenous language", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_CS_speaksIndNS.png", replace

csdid indigenous edu rural female dmigrant if state=="01" | state=="02" | ///
state=="03" | state=="05" | state=="08" | state=="10" | state=="11" | ///
state=="14" | state=="18" | state=="19" | state=="22" | state=="24" | ///
state=="25" | state=="26" | state=="28" | state=="32" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_indigNS)

/* Panel (c) */
event_plot csdid_indigNS, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm#) ///
    stub_lag(Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of self-identifying as Indigenous", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_CS_indigNS.png", replace
*========================================================================*
/* FIGURE 12. Robustness: Estimates with two different estimation methods */
*========================================================================*
replace first_cohort=1995 if first_cohort==0
gen K = cohort-first_cohort

gen tgroup=first_cohort
replace tgroup=. if state!="01" & state!="10" & state!="19" & state!="25" ///
& state!="26" & state!="28"
gen cgroup=tgroup==.

forvalues l = 0/6 {
	gen L`l'event = K==`l'
}
forvalues l = 1/5 {
	gen F`l'event = K==-`l'
}
replace F1event=0 // normalize K=-1 to zero

csdid elengua edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd)

eventstudyinteract elengua L*event F*event [aw=factor], ///
absorb(geo cohort) cohort(tgroup) control_cohort(cgroup) ///
covariates(edu rural female dmigrant) vce(cluster geo)

matrix sa_b_ui = e(b_iw)
matrix sa_v_ui = e(V_iw)

event_plot csdid_understInd sa_b_ui#sa_v_ui, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm# F#event) ///
    stub_lag(Tp# L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of understanding an Indigenous language", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Callaway-Sant'Anna" 4 "Sun-Abraham") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
	lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_CS_SA_UInd.png", replace

csdid hlengua edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd)

eventstudyinteract hlengua L*event F*event [aw=factor], ///
absorb(geo cohort) cohort(tgroup) control_cohort(cgroup) ///
covariates(edu rural female dmigrant) vce(cluster geo)

matrix sa_b_si = e(b_iw)
matrix sa_v_si = e(V_iw)

event_plot csdid_speaksInd sa_b_si#sa_v_si, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm# F#event) ///
    stub_lag(Tp# L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of speaking an Indigenous language", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
	lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_CS_SA_SInd.png", replace

csdid indigenous edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_Ind)

eventstudyinteract indigenous L*event F*event [aw=factor], ///
absorb(geo cohort) cohort(tgroup) control_cohort(cgroup) ///
covariates(edu rural female dmigrant) vce(cluster geo)

matrix sa_b_ii = e(b_iw)
matrix sa_v_ii = e(V_iw)

event_plot csdid_Ind sa_b_ii#sa_v_ii, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm# F#event) ///
    stub_lag(Tp# L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of self-identifying as Indigenous", size(medium) height(5)) ///
	xlabel(-5(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
	lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_CS_SA_IInd.png", replace
*========================================================================*
/* FIGURE 13. Robustness: Estimates using the 2010 Population Census */
*========================================================================*
/* Produced with the do file "05_CensusDBind_2010.do" */

*========================================================================*
/* ============================== TABLES ============================== */
*========================================================================*
/* TABLE 2. English instruction and Indigenous language */
*========================================================================*
csdid elengua if edu!=. [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat all, window(-4 6) estore(csdid_underst1)

csdid elengua edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat all, window(-4 6) estore(csdid_underst2)

csdid hlengua if edu!=. [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat all, window(-4 6) estore(csdid_speaks1)

csdid hlengua edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat all, window(-4 6) estore(csdid_speaks2)

csdid indigenous if edu!=. [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat all, window(-4 6) estore(csdid_indig1)

csdid indigenous edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat all, window(-4 6) estore(csdid_indig2)
*========================================================================*
/* End of do-file */
*========================================================================*
