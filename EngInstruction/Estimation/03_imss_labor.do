*========================================================================*
/* Impact of English instruction on labor mrket outcomes: 
The case of Mexico */
*========================================================================*
* Authors: Oscar Galvez-Soriano, Alejandrina Salcedo and Francisco Cabrera
*========================================================================*
clear
clear mata
clear matrix
set more off
set maxvar 120000
gl base= "F:\T43969_Oscar\Data"
gl doc= "R:\Doc"
*========================================================================*
/* Working with IMSS labor data to study the effect on labor market outcomes
Note: Run after imss_db.do */
*========================================================================*
/* FIGURE 1. Labor market outcomes */
/* Borusyak, Jaravel, and Spiess (2024) */
*========================================================================*
use "$base\dbase_23.dta", clear
drop ps2* ps3* ps4*

sum first_treat
gen last_treat=first_treat==r(max)
forvalues l = 0/4 {
	gen L`l'event=K==`l'
}
forvalues l = 1/5 {
	gen F`l'event=K==-`l'
}
replace F1event=0

graph set window fontface "Times New Roman"
*========================================================================*
/* Panel (a). Formal labor */
*========================================================================*
did_imputation imss cct cohort first_treat, horizons(0/4) pretrend(4) ///
controls(math6) cluster(cct) autos minn(0)

estimates store bjs_imss
*========================================================================*
event_plot bjs_imss, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre#) ///
stub_lag(tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
ytitle("Likelihood of working in formal sector", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_imss.png", replace

*========================================================================*
/* Selection */
*========================================================================*
/* Heckman correction */
*heckman lwage F*event L*event i.ncct i.cohort, select(h_eng language6 math6 female n_stud)

reghdfe imss F*event L*event math6 female if first_treat!=1997, absorb(cct cohort) vce(cluster cct)
*quietly probit imss F*event L*event language6 math6 female n_stud i.ncct i.cohort h_eng, vce(cluster cct)
predict imss_hat
gen lambda=normalden(imss_hat)/normal(imss_hat)
sum lambda

*========================================================================*
/* Panel (b). Wages */
*========================================================================*
did_imputation lwage cct cohort first_treat, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0)

estimates store bjs_wage_hc

event_plot bjs_wage_hc, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre#) ///
stub_lag(tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
ytitle("Percentage change of wages", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_wage_hc.png", replace

*========================================================================*
/* Panel (c). Distance */
*========================================================================*
did_imputation ldist cct cohort first_treat, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_dist_hc

event_plot bjs_dist_hc, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre#) ///
stub_lag(tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
ytitle("Percentage change of distance", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_dist_hc.png", replace

*========================================================================*
/* Panel (d). Move state */
*========================================================================*
did_imputation move_state cct cohort first_treat, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_moves_hc

event_plot bjs_moves_hc, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre#) ///
stub_lag(tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
ytitle("Likelihood of moving to a different state", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_moves_hc.png", replace

*========================================================================*
/****************************** MECHANISMS ******************************/
*========================================================================*
/* FIGURE 2. Acquisition of English skills */
/* Exposure to English instruction and English intensive industries */
*========================================================================*
gen heng=eng_dist_edu>=3

did_imputation heng cct cohort first_treat if wage!=., horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_heng

event_plot bjs_heng, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre#) ///
stub_lag(tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.10(0.05)0.10, labs(medium) grid format(%5.2f)) ///
ytitle("Likelihood of working in jobs that require English", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_HighEng.png", replace

*========================================================================*
/* FIGURE 3: Effects on other cognitive abilities */
/* Exposure to English instruction and student achievement */
*========================================================================*
did_imputation language6 cct cohort first_treat if wage!=., horizons(0/3) pretrend(3) ///
controls(lambda) cluster(cct) autos minn(0)

estimates store bjs_ss_w

did_imputation math6 cct cohort first_treat if wage!=., horizons(0/3) pretrend(3) ///
controls(math5 lambda) cluster(cct) autos minn(0)

estimates store bjs_sm_w

event_plot bjs_ss_w bjs_sm_w, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre#) ///
stub_lag(tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.15(0.05)0.15, labs(medium) grid format(%5.2f)) ///
ytitle("Change in test scores (in standard deviations)", size(medium) height(5)) ///
xlabel(-3(1)3, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(order(2 "Spanish" 4 "Mathematics") pos(7) ring(0) col(1) size(small)) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(O) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_TestScoreW_hc.png", replace

*========================================================================*
/* FIGURE 4: Effects on hours of English instruction */
*========================================================================*
/* Produced with do file SchoolCensus.do */

*========================================================================*
/* FIGURE 5: Sustitution accross industries */
*========================================================================*
gen min_util=naics>=2110 & naics<=2213
gen const=naics>=2361 & naics<=2399

gen manu_text_plast=naics>=3130 & naics<=3160 | naics>=3240 & naics<=3260

gen manu_paper_metal=naics>=3210 & naics<=3230 | naics>=3270 & naics<=3320

gen manu_machine=naics==3330 | naics==3360
/*
gen manu_machine=naics>=3330 & naics<=3360
gen manu_alim=naics>=3110 & naics<=3120
gen manu_other=naics>=3370 & naics<=3399
*/

gen tourism=naics==4810 | naics==4870 | naics==5321 | naics==5615 | naics==7120 ///
| naics==7210 | naics==7221

gen other_serv=naics>=4610 & naics<=9399
replace other_serv=0 if tourism==1
*========================================================================*
/* Panel (a). Mining, Utilities and Construction */ 
*========================================================================*
did_imputation min_util cct cohort first_treat if wage!=., horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_minutil_hc

did_imputation const cct cohort first_treat if wage!=., horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_const_hc

event_plot bjs_minutil_hc bjs_const_hc, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre#) ///
stub_lag(tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.03(0.015)0.03, labs(medium) grid format(%5.3f)) ///
ytitle("Likelihood of working in the specified industry", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(order(2 "Mining and Utilities" 4 "Construction" ) pos(11) ring(0) col(1) size(small)) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_MinUtilCons_hc.png", replace

*========================================================================*
/* Panel (b). Textile and plastic / Machinery Manufacturing */ 
*========================================================================*
did_imputation manu_text_plast cct cohort first_treat if wage!=., horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_text_hc

did_imputation manu_machine cct cohort first_treat if wage!=., horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_machine_hc

event_plot bjs_machine_hc bjs_text_hc, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre#) ///
stub_lag(tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.03(0.015)0.03, labs(medium) grid format(%5.3f)) ///
ytitle("Likelihood of working in the specified industry", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(order(2 "Machinery" 4 "Textile and plastic product") pos(11) ring(0) col(1) size(small)) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_TextMachine_hc.png", replace

*========================================================================*
/* Panel (c). Tourism and Other Services */
*========================================================================*
did_imputation tourism cct cohort first_treat if wage!=., horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_tourism_hc

did_imputation other_serv cct cohort first_treat if wage!=., horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_otherSvc_hc

event_plot bjs_tourism_hc bjs_otherSvc_hc, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre#) ///
stub_lag(tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.04(0.02)0.04, labs(medium) grid format(%5.3f)) ///
ytitle("Likelihood of working in the specified industry", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(order(2 "Tourism" 4 "Other Services" ) pos(11) ring(0) col(1) size(small)) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_TourismOtherSvcs_hc.png", replace


*========================================================================*
/************************ Heterogeneous Effects ************************/
*========================================================================*
/* FIGURE 6. Heterogeneity by abilities */
*========================================================================*
/* Panel (a). Wages */
*========================================================================*
replace quart2=. if ability>=3
replace quart3=. if ability==2 | ability==4
replace quart4=. if ability==2 | ability==3

did_imputation lwage cct cohort first_treat if quart2==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) tol(1e-5) maxit(160)

estimates store bjs_wage_hc_q2

did_imputation lwage cct cohort first_treat if quart3==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) tol(1e-5) maxit(160)

estimates store bjs_wage_hc_q3

did_imputation lwage cct cohort first_treat if quart4==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) tol(1e-5) maxit(160)

estimates store bjs_wage_hc_q4

event_plot bjs_wage_hc_q2 bjs_wage_hc_q3 bjs_wage_hc_q4, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre# pre#) ///
stub_lag(tau# tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
ytitle("Percentage change of wages", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(order(2 "Q2" 4 "Q3" 6 "Q4") pos(11) ring(0) col(1) size(small)) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(T) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
lag_opt3(msize(small) msymbol(D) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt3(color(navy) lwidth(medthick))
graph export "$doc\PTA_wage_hc_abil.png", replace

*========================================================================*
/* Panel (b). Distance */
*========================================================================*
did_imputation ldist cct cohort first_treat if quart2==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) tol(1e-5) maxit(160)

estimates store bjs_dist_hc_q2

did_imputation ldist cct cohort first_treat if quart3==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) tol(1e-5) maxit(160)

estimates store bjs_dist_hc_q3

did_imputation ldist cct cohort first_treat if quart4==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) tol(1e-5) maxit(160)

estimates store bjs_dist_hc_q4

event_plot bjs_dist_hc_q2 bjs_dist_hc_q3 bjs_dist_hc_q4, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre# pre#) ///
stub_lag(tau# tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
ytitle("Percentage change of distance", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(T) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
lag_opt3(msize(small) msymbol(D) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt3(color(navy) lwidth(medthick))
graph export "$doc\PTA_dist_hc_abil.png", replace

*========================================================================*
/* Panel (c). Move State */
*========================================================================*
did_imputation move_state cct cohort first_treat if quart2==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) tol(1e-5) maxit(160)

estimates store bjs_move_hc_q2

did_imputation move_state cct cohort first_treat if quart3==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) tol(1e-5) maxit(160)

estimates store bjs_move_hc_q3

did_imputation move_state cct cohort first_treat if quart4==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) tol(1e-5) maxit(160)

estimates store bjs_move_hc_q4

event_plot bjs_move_hc_q2 bjs_move_hc_q3 bjs_move_hc_q4, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre# pre#) ///
stub_lag(tau# tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
ytitle("Likelihood of moving to a different state", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(T) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
lag_opt3(msize(small) msymbol(D) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt3(color(navy) lwidth(medthick))
graph export "$doc\PTA_move_hc_abil.png", replace

*========================================================================*
/************************** Robustness checks ***************************/
*========================================================================*
/* FIGURE 7. Labor market outcomes with Lee bounds */ 
*========================================================================*
/* Trimming control group because treated ones are less likely to show 
in formal sector 

We trim the difference in attrition rates:

tab treat
tab treat if imss==1

dis 258847/980146 // treatment
dis 1128868/5376376 // control

dis .26409025-.2099682
*/

_pctile wage if treat==0, nq(100)
gen lbound=wage>=r(r94) & treat==0 & wage!=.
gen ubound=wage<=r(r6) & treat==0 & wage!=.

*========================================================================*
/* Panel (a). Wages */
*========================================================================*
did_imputation lwage cct cohort first_treat if lbound==0, horizons(0/4) pretrend(4) ///
controls(math6) cluster(cct) autos minn(0)

estimates store bjs_wage_lb

did_imputation lwage cct cohort first_treat if ubound==0 & wage!=., horizons(0/4) pretrend(4) ///
controls(math6) cluster(cct) autos minn(0)

estimates store bjs_wage_ub

event_plot bjs_wage_ub bjs_wage_lb, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre#) ///
stub_lag(tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
ytitle("Percentage change of wages", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(order(2 "Upper bound" 4 "Lower bound" ) pos(11) ring(0) col(1) size(small)) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_wage_lee.png", replace
*========================================================================*
/* Panel (b). Distance */
*========================================================================*
did_imputation ldist cct cohort first_treat if lbound==0, horizons(0/4) pretrend(4) ///
controls(math6) cluster(cct) autos minn(0) 

estimates store bjs_dist_lb

did_imputation ldist cct cohort first_treat if ubound==0, horizons(0/4) pretrend(4) ///
controls(math6) cluster(cct) autos minn(0) 

estimates store bjs_dist_ub

event_plot bjs_dist_ub bjs_dist_lb, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre#) ///
stub_lag(tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
ytitle("Percentage change of distance", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_dist_lee.png", replace

*========================================================================*
/* Panel (c). Move state */
*========================================================================*
did_imputation move_state cct cohort first_treat if lbound==0, horizons(0/4) pretrend(4) ///
controls(math6) cluster(cct) autos minn(0) 

estimates store bjs_moves_lb

did_imputation move_state cct cohort first_treat if ubound==0, horizons(0/4) pretrend(4) ///
controls(math6) cluster(cct) autos minn(0) 

estimates store bjs_moves_ub

event_plot bjs_moves_ub bjs_moves_lb, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre#) ///
stub_lag(tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
ytitle("Likelihood of moving to a different state", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_moves_lee.png", replace

*========================================================================*
/* FIGURE 8. Different measure of exposure (English teachers) */
*========================================================================*
/* Panel (a). Wages */
*========================================================================*
did_imputation lwage cct cohort first_treat2, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0)

estimates store bjs_wage_hcT

event_plot bjs_wage_hcT, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre#) ///
stub_lag(tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
ytitle("Percentage change of wages", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_wage_hcT.png", replace

*========================================================================*
/* Panel (b). Distance */
*========================================================================*
did_imputation ldist cct cohort first_treat2, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_dist_hcT

event_plot bjs_dist_hcT, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre#) ///
stub_lag(tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
ytitle("Percentage change of distance", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_dist_hcT.png", replace

*========================================================================*
/* Panel (c). Move state */
*========================================================================*
did_imputation move_state cct cohort first_treat2, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_moves_hcT

event_plot bjs_moves_hcT, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre#) ///
stub_lag(tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
ytitle("Likelihood of moving to a different state", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_moves_hcT.png", replace

*========================================================================*
/* FIGURE 9: English instruction and enrollment */
*========================================================================*
/* Produced with do file SchoolCensus.do */

*========================================================================*
/* FIGURE XX. Robustness with heterogenous treatment effects */
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
/* Panel (a). Wages */
csdid lwage math6 lambda, time(cohort) gvar(first_treat) ///
method(dripw) vce(cluster cct) long2 wboot seed(6)
estat event, window(-3 5) estore(csdid_wage)

event_plot csdid_wage, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(Tm#) ///
stub_lag(Tp#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
ytitle("Percentage change of wages", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_CS_wage.png", replace

/* Panel (b). Distance */
csdid ldist math6 lambda, time(cohort) gvar(first_treat) ///
method(dripw) vce(cluster cct) long2 wboot seed(6)
estat event, window(-3 5) estore(csdid_dist)

event_plot csdid_dist, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(Tm#) ///
stub_lag(Tp#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
ytitle("Percentage change of distance", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_CS_dist.png", replace

/* Panel (c). Move state */
csdid move_state math6 lambda, time(cohort) gvar(first_treat) ///
method(dripw) vce(cluster cct) long2 wboot seed(6)
estat event, window(-3 5) estore(csdid_moves)

event_plot csdid_moves, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(Tm#) ///
stub_lag(Tp#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
ytitle("Likelihood of moving to a different state", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_CS_moves.png", replace

*========================================================================*
/******************************* Apendix ********************************/
*========================================================================*

*========================================================================*
/* FIGURE A.1: Sorting in main industries */
*========================================================================*
/* Panel (a). Agriculture / Construction and Utilities */
*========================================================================*
did_imputation ag_ea cct cohort first_treat if wage!=., horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_ag_hc

did_imputation cons_ea cct cohort first_treat if wage!=., horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_cons_hc

event_plot bjs_ag_hc bjs_cons_hc, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre#) ///
stub_lag(tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.03(0.015)0.03, labs(medium) grid format(%5.3f)) ///
ytitle("Likelihood of working in the specified industry", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(order(2 "Agriculture" 4 "Construction and Utilities" ) pos(11) ring(0) col(1) size(small)) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_AgCons_hc.png", replace

*========================================================================*
/* Panel (b). Manufacturing / Services */
*========================================================================*
did_imputation manu_ea cct cohort first_treat if wage!=., horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_manu_hc

did_imputation serv_ea cct cohort first_treat if wage!=., horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_serv_hc

event_plot bjs_manu_hc bjs_serv_hc, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre#) ///
stub_lag(tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.05(0.025)0.05, labs(medium) grid format(%5.3f)) ///
ytitle("Likelihood of working in the specified industry", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(order(2 "Manufacturing" 4 "Services" ) pos(11) ring(0) col(1) size(small)) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_ManuServ_hc.png", replace

*========================================================================*
/* FIGURE A.2: Sorting in industries by abilities */
*========================================================================*
/* Panel (a). Agriculture */
*========================================================================*
did_imputation ag_ea cct cohort first_treat if wage!=. & quart2==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_ag_hc_q2

did_imputation ag_ea cct cohort first_treat if wage!=. & quart3==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_ag_hc_q3

did_imputation ag_ea cct cohort first_treat if wage!=. & quart4==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_ag_hc_q4

event_plot bjs_ag_hc_q2 bjs_ag_hc_q3 bjs_ag_hc_q4, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre# pre#) ///
stub_lag(tau# tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.04(0.02)0.04, labs(medium) grid format(%5.2f)) ///
ytitle("Likelihood of working in Agriculture", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(order(2 "Q2" 4 "Q3" 6 "Q4") pos(11) ring(0) col(1) size(small)) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(T) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
lag_opt3(msize(small) msymbol(D) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt3(color(navy) lwidth(medthick))
graph export "$doc\PTA_Ag_hc_abil.png", replace

*========================================================================*
/* Panel (b). Construction and Utilities */
*========================================================================*
did_imputation cons_ea cct cohort first_treat if wage!=. & quart2==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_cons_hc_q2

did_imputation cons_ea cct cohort first_treat if wage!=. & quart3==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_cons_hc_q3

did_imputation cons_ea cct cohort first_treat if wage!=. & quart4==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_cons_hc_q4

event_plot bjs_cons_hc_q2 bjs_cons_hc_q3 bjs_cons_hc_q4, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre# pre#) ///
stub_lag(tau# tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.08(0.04)0.08, labs(medium) grid format(%5.2f)) ///
ytitle("Likelihood of working in Construction", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(T) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
lag_opt3(msize(small) msymbol(D) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt3(color(navy) lwidth(medthick))
graph export "$doc\PTA_Cons_hc_abil.png", replace

*========================================================================*
/* Panel (c). Machinery Manufacturing */ 
*========================================================================*
did_imputation manu_machine cct cohort first_treat if wage!=. & quart2==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0)

estimates store bjs_machine_hc_q2

did_imputation manu_machine cct cohort first_treat if wage!=. & quart3==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0)

estimates store bjs_machine_hc_q3

did_imputation manu_machine cct cohort first_treat if wage!=. & quart4==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0)

estimates store bjs_machine_hc_q4

event_plot bjs_machine_hc_q2 bjs_machine_hc_q3 bjs_machine_hc_q4, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre# pre#) ///
stub_lag(tau# tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.08(0.04)0.08, labs(medium) grid format(%5.2f)) ///
ytitle("Likelihood of working in machinery manufacturing", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(T) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
lag_opt3(msize(small) msymbol(D) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt3(color(navy) lwidth(medthick))
graph export "$doc\PTA_Machine_hc_abil.png", replace

*========================================================================*
/* Panel (d). Textile and plastic product */ 
*========================================================================*
did_imputation manu_text_plast cct cohort first_treat if wage!=. & quart2==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_text_hc_q2

did_imputation manu_text_plast cct cohort first_treat if wage!=. & quart3==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_text_hc_q3

did_imputation manu_text_plast cct cohort first_treat if wage!=. & quart4==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_text_hc_q4

event_plot bjs_text_hc_q2 bjs_text_hc_q3 bjs_text_hc_q4, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre# pre#) ///
stub_lag(tau# tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.08(0.04)0.08, labs(medium) grid format(%5.2f)) ///
ytitle("Likelihood of working in textile/plastic manufacturing", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(T) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
lag_opt3(msize(small) msymbol(D) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt3(color(navy) lwidth(medthick))
graph export "$doc\PTA_Text_hc_abil.png", replace

*========================================================================*
/* Panel (e). Tourism */
*========================================================================*
did_imputation tourism cct cohort first_treat if wage!=. & quart2==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_tourism_hc_q2

did_imputation tourism cct cohort first_treat if wage!=. & quart3==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_tourism_hc_q3

did_imputation tourism cct cohort first_treat if wage!=. & quart4==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_tourism_hc_q4

event_plot bjs_tourism_hc_q2 bjs_tourism_hc_q3 bjs_tourism_hc_q4, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre# pre#) ///
stub_lag(tau# tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.08(0.04)0.08, labs(medium) grid format(%5.2f)) ///
ytitle("Likelihood of working in tourism", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(T) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
lag_opt3(msize(small) msymbol(D) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt3(color(navy) lwidth(medthick))
graph export "$doc\PTA_Tourism_hc_abil.png", replace

*========================================================================*
/* Panel (f). Other Services */
*========================================================================*
did_imputation other_serv cct cohort first_treat if wage!=. & quart2==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_otherSvc_hc_q2

did_imputation other_serv cct cohort first_treat if wage!=. & quart3==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_otherSvc_hc_q3

did_imputation other_serv cct cohort first_treat if wage!=. & quart4==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_otherSvc_hc_q4

event_plot bjs_otherSvc_hc_q2 bjs_otherSvc_hc_q3 bjs_otherSvc_hc_q4, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre# pre#) ///
stub_lag(tau# tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.12(0.06)0.12, labs(medium) grid format(%5.2f)) ///
ytitle("Likelihood of working in other services", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(T) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
lag_opt3(msize(small) msymbol(D) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt3(color(navy) lwidth(medthick))
graph export "$doc\PTA_OtherSvcs_hc_abil.png", replace

*========================================================================*
/* FIGURE XX: English intensive industries by abilities */
*========================================================================*
did_imputation heng cct cohort first_treat if wage!=. & quart2==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_heng_q2

did_imputation heng cct cohort first_treat if wage!=. & quart3==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_heng_q3

did_imputation heng cct cohort first_treat if wage!=. & quart4==1, horizons(0/4) pretrend(4) ///
controls(math6 lambda) cluster(cct) autos minn(0) 

estimates store bjs_heng_q4

event_plot bjs_heng_q2 bjs_heng_q3 bjs_heng_q4, ///
plottype(scatter) ciplottype(rspike) alpha(0.05) ///
stub_lead(pre# pre# pre#) ///
stub_lag(tau# tau# tau#) ///
together noautolegend ///
graph_opt( ///
ylabel(-0.1(0.05)0.10, labs(medium) grid format(%5.2f)) ///
ytitle("Likelihood of working in jobs that require English", size(medium) height(5)) ///
xlabel(-4(1)4, labs(medium)) ///
yline(0, lpattern(solid)) ///
xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
legend(off) ///
) ///
lag_opt1(msize(small) msymbol(O) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt1(color(ltblue) lwidth(medthick)) ///
lag_opt2(msize(small) msymbol(T) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
lag_opt3(msize(small) msymbol(D) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt3(color(navy) lwidth(medthick))
graph export "$doc\PTA_HighEng_abil.png", replace