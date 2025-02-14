*========================================================================*
* English program and earnings
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
clear matrix
clear mata
set maxvar 120000
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Doc"
*========================================================================*
/* APPENDIX */ 
*========================================================================*
use "$base\labor_census20.dta", clear

merge m:1 state using "$data/Papers/main/EngMigration/Data/census1990.dta"
drop if _merge!=3
drop _merge
*========================================================================*
sum first_cohort
gen lastcohort = first_cohort==r(max) // dummy for the latest- or never-treated cohort

forvalues l = 0/7 {
	gen L`l'event = K==`l'
}
forvalues l = 1/6 {
	gen F`l'event = K==-`l'
}
replace F1event=0 // normalize K=-1 to zero

gen dest_amer=.
replace dest_amer=0 if destination_c!=.
replace dest_amer=1 if destination_c>=200 & destination_c<300
replace dest_amer=0 if destination_c==221
replace dest_amer=. if destination_c==999

gen dest_asia=.
replace dest_asia=0 if destination_c!=.
replace dest_asia=1 if (destination_c>=300 & destination_c<400) | ///
(destination_c>=100 & destination_c<200) | (destination_c>=500 & destination_c<600)
replace dest_asia=. if destination_c==999

gen dest_euro=.
replace dest_euro=0 if destination_c!=.
replace dest_euro=1 if (destination_c>=400 & destination_c<500)
replace dest_euro=. if destination_c==999


gen dest_spanish=.
replace dest_spanish=0 if destination_c!=.
replace dest_spanish=1 if (destination_c>=200 & destination_c<=210) | ///
destination_c==212 | (destination_c>=214 & destination_c<=220) | ///
destination_c==222 | (destination_c>=225 & destination_c<=252) | ///
destination_c==415
replace dest_spanish=0 if destination_c==226 | destination_c==244
replace dest_spanish=. if destination_c==999

gen dest_no_spanish=.
replace dest_no_spanish=0 if dest_spanish==1
replace dest_no_spanish=1 if dest_spanish==0
replace dest_no_spanish=0 if destination_c==221
*========================================================================*
/* TWFE */
*========================================================================*
reghdfe dmigrant female rural F*event L*event [aw=factor] ///
, absorb(cohort geo) vce(cluster geo)
estimates store ols_dmigrant

event_plot ols_dmigrant, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating domestically", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_dmigrant.png", replace

reghdfe migrant female rural F*event L*event [aw=factor] ///
, absorb(cohort geo) vce(cluster geo)
estimates store ols_migrant

event_plot ols_migrant, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.02(0.01)0.02, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating abroad", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_migrant.png", replace

reghdfe migra_ret female rural F*event L*event [aw=factor] ///
if migrant==1, absorb(cohort geo) vce(cluster geo)
estimates store ols_rmigrant

event_plot ols_rmigrant, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.4(0.2).4, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of returning to Mexico after migration", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_rmigrant.png", replace

reghdfe dest_us female rural F*event L*event [aw=factor] ///
if migrant==1, absorb(cohort geo) vce(cluster geo)
estimates store ols_usmigrant

event_plot ols_usmigrant, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to the US", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_TWFE_USmigrant.png", replace

reghdfe work female rural F*event L*event [aw=factor] ///
, absorb(cohort geo) vce(cluster geo)
estimates store ols_work

event_plot ols_work, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of working", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_work.png", replace

reghdfe lwage female rural edu F*event L*event [aw=factor] ///
if work==1, absorb(cohort geo) vce(cluster geo)
estimates store ols_wage

event_plot ols_wage, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change of wages (if works)", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_TWFE_wage.png", replace


reghdfe dest_amer female rural F*event L*event [aw=factor] ///
if migrant==1, absorb(cohort geo) vce(cluster geo)
estimates store ols_AMERmigrant

reghdfe dest_asia female rural F*event L*event [aw=factor] ///
if migrant==1, absorb(cohort geo) vce(cluster geo)
estimates store ols_ASIAmigrant

reghdfe dest_euro female rural F*event L*event [aw=factor] ///
if migrant==1, absorb(cohort geo) vce(cluster geo)
estimates store ols_EUROmigrant

event_plot ols_AMERmigrant ols_EUROmigrant ols_ASIAmigrant, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event F#event) ///
    stub_lag(L#event L#event L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to indicated countries", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Americas" 4 "Europe" 6 "Asia") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(S) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt3(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_TWFE_DESTmigrant.png", replace


reghdfe dest_spanish female rural F*event L*event [aw=factor] ///
if migrant==1, absorb(cohort geo) vce(cluster geo)
estimates store ols_SPANISHmigrant

reghdfe dest_no_spanish female rural F*event L*event [aw=factor] ///
if migrant==1, absorb(cohort geo) vce(cluster geo)
estimates store ols_NoSPANISHmigrant

event_plot ols_SPANISHmigrant ols_NoSPANISHmigrant, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event) ///
    stub_lag(L#event L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to indicated countries", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Hispanic countries" 4 "Non-Hispanic countries") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_TWFE_SPANISHmigrant.png", replace

*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract dmigrant L*event F*event [aw=factor], ///
absorb(geo cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix dm_b = e(b_iw)
matrix dm_v = e(V_iw)

event_plot dm_b#dm_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating domestically", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_SA_dmigrant.png", replace

eventstudyinteract migrant L*event F*event [aw=factor], ///
absorb(geo cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix m_b = e(b_iw)
matrix m_v = e(V_iw)

event_plot m_b#m_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.02(0.01)0.02, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating abroad", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_SA_migrant.png", replace

eventstudyinteract migra_ret L*event F*event [aw=factor] if migrant==1, ///
absorb(geo cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix mr_b = e(b_iw)
matrix mr_v = e(V_iw)

event_plot mr_b#mr_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.4(0.2).4, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of returning to Mexico after migration", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_SA_rmigrant.png", replace

eventstudyinteract dest_us L*event F*event [aw=factor] if migrant==1, ///
absorb(geo cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix us_b = e(b_iw)
matrix us_v = e(V_iw)

event_plot us_b#us_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to the US", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_SA_USmigrant.png", replace

eventstudyinteract work L*event F*event [aw=factor], ///
absorb(geo cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix work_b = e(b_iw)
matrix work_v = e(V_iw)

event_plot work_b#work_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of working", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_SA_work.png", replace

eventstudyinteract lwage L*event F*event [aw=factor] if work==1, ///
absorb(geo cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural edu) vce(cluster geo)

matrix wage_b = e(b_iw)
matrix wage_v = e(V_iw)

event_plot wage_b#wage_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change of wages (if works)", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_SA_wage.png", replace


eventstudyinteract dest_amer L*event F*event [aw=factor] if migrant==1, ///
absorb(geo cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix amer_b = e(b_iw)
matrix amer_v = e(V_iw)

eventstudyinteract dest_asia L*event F*event [aw=factor] if migrant==1, ///
absorb(geo cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix asia_b = e(b_iw)
matrix asia_v = e(V_iw)

eventstudyinteract dest_euro L*event F*event [aw=factor] if migrant==1, ///
absorb(geo cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix euro_b = e(b_iw)
matrix euro_v = e(V_iw)

event_plot amer_b#amer_v euro_b#euro_v asia_b#asia_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event F#event) ///
    stub_lag(L#event L#event L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to indicated countries", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Americas" 4 "Europe" 6 "Asia") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(S) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt3(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_SA_DESTmigrant.png", replace


eventstudyinteract dest_spanish L*event F*event [aw=factor] if migrant==1, ///
absorb(geo cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix spa_b = e(b_iw)
matrix spa_v = e(V_iw)

eventstudyinteract dest_no_spanish L*event F*event [aw=factor] if migrant==1, ///
absorb(geo cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix nspa_b = e(b_iw)
matrix nspa_v = e(V_iw)

event_plot spa_b#spa_v nspa_b#nspa_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event) ///
    stub_lag(L#event L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to indicated countries", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Hispanic countries" 4 "Non-Hispanic countries") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_SA_SPANISHmigrant.png", replace

*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt dmigrant geo cohort D, weight(factor) ///
robust_dynamic dynamic(7) placebo(5) breps(50) cluster(geo) ///
controls(female rural)

matrix dm_b = e(estimates) 
matrix dm_v = e(variances)

matrix dm_b = dm_b \ 0
matrix dm_v=dm_v \ 0

mat rownames dm_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dm_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

event_plot dm_b#dm_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_#) ///
    stub_lag(Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating domestically", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_dCD_dmigrant.png", replace

did_multiplegt migrant geo cohort D, weight(factor) ///
robust_dynamic dynamic(7) placebo(5) breps(50) cluster(geo) ///
controls(female rural)

matrix m_b = e(estimates) 
matrix m_v = e(variances)

matrix m_b=m_b \ 0
matrix m_v=m_v \ 0

mat rownames m_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames m_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

event_plot m_b#m_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_#) ///
    stub_lag(Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.02(0.01)0.02, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating abroad", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_dCD_migrant.png", replace

did_multiplegt migra_ret geo cohort D if migrant==1, weight(factor) ///
robust_dynamic dynamic(7) placebo(5) breps(50) cluster(geo) ///
controls(female rural)

matrix rm_b = e(estimates) 
matrix rm_v = e(variances)

matrix rm_b=rm_b \ 0
matrix rm_v=rm_v \ 0

mat rownames rm_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames rm_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

event_plot rm_b#rm_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_#) ///
    stub_lag(Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of returning to Mexico after migration", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_dCD_rmigrant.png", replace

did_multiplegt dest_us geo cohort D if migrant==1, weight(factor) ///
robust_dynamic dynamic(7) placebo(5) breps(50) cluster(geo) ///
controls(female rural)

matrix us_b = e(estimates) 
matrix us_v = e(variances)

matrix us_b=us_b \ 0
matrix us_v=us_v \ 0

mat rownames us_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames us_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

event_plot us_b#us_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_#) ///
    stub_lag(Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to the US", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_dCD_USmigrant.png", replace

did_multiplegt work geo cohort D, weight(factor) ///
robust_dynamic dynamic(7) placebo(5) breps(50) cluster(geo) ///
controls(female rural)

matrix work_b = e(estimates) 
matrix work_v = e(variances)

matrix work_b=work_b \ 0
matrix work_v=work_v \ 0

mat rownames work_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames work_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

event_plot work_b#work_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_#) ///
    stub_lag(Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of working", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_dCD_work.png", replace

did_multiplegt lwage geo cohort D if work==1, weight(factor) ///
robust_dynamic dynamic(7) placebo(5) breps(50) cluster(geo) ///
controls(female rural edu)

matrix wage_b = e(estimates) 
matrix wage_v = e(variances)

matrix wage_b=wage_b \ 0
matrix wage_v=wage_v \ 0

mat rownames wage_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

event_plot wage_b#wage_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_#) ///
    stub_lag(Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change of wages (if works)", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_dCD_wage.png", replace


did_multiplegt dest_amer geo cohort D if migrant==1, weight(factor) ///
robust_dynamic dynamic(7) placebo(5) breps(50) cluster(geo) ///
controls(female rural)

matrix amer_b = e(estimates) 
matrix amer_v = e(variances)

matrix amer_b=amer_b \ 0
matrix amer_v=amer_v \ 0

mat rownames amer_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames amer_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt dest_asia geo cohort D if migrant==1, weight(factor) ///
robust_dynamic dynamic(7) placebo(5) breps(50) cluster(geo) ///
controls(female rural)

matrix asia_b = e(estimates) 
matrix asia_v = e(variances)

matrix asia_b=asia_b \ 0
matrix asia_v=asia_v \ 0

mat rownames asia_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames asia_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt dest_euro geo cohort D if migrant==1, weight(factor) ///
robust_dynamic dynamic(7) placebo(5) breps(50) cluster(geo) ///
controls(female rural)

matrix euro_b = e(estimates) 
matrix euro_v = e(variances)

matrix euro_b=euro_b \ 0
matrix euro_v=euro_v \ 0

mat rownames euro_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames euro_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

event_plot amer_b#amer_v euro_b#euro_v asia_b#asia_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to indicated countries", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Americas" 4 "Europe" 6 "Asia") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(S) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt3(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_dCD_DESTmigrant.png", replace

did_multiplegt dest_spanish geo cohort D if migrant==1, weight(factor) ///
robust_dynamic dynamic(7) placebo(5) breps(50) cluster(geo) ///
controls(female rural)

matrix spa_b = e(estimates) 
matrix spa_v = e(variances)

matrix spa_b=spa_b \ 0
matrix spa_v=spa_v \ 0

mat rownames spa_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames spa_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt dest_no_spanish geo cohort D if migrant==1, weight(factor) ///
robust_dynamic dynamic(7) placebo(5) breps(50) cluster(geo) ///
controls(female rural)

matrix nspa_b = e(estimates) 
matrix nspa_v = e(variances)

matrix nspa_b=nspa_b \ 0
matrix nspa_v=nspa_v \ 0

mat rownames nspa_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames nspa_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Effect_7 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

event_plot spa_b#spa_v nspa_b#nspa_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to indicated countries", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Hispanic countries" 4 "Non-Hispanic countries") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_dCD_SPANISHmigrant.png", replace

*========================================================================*
/* Borusyak, Jaravel, and Spiess (2024) */
*========================================================================*
did_imputation dmigrant geo cohort first_cohort ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort) autos minn(0)

estimates store bjs_dm

event_plot bjs_dm, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating domestically", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_dmigrant.png", replace

did_imputation migrant geo cohort first_cohort ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort) autos minn(0)

estimates store bjs_m

event_plot bjs_m, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.02(0.01)0.02, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating abroad", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_migrant.png", replace

did_imputation migra_ret geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort) autos minn(0)

estimates store bjs_mr

event_plot bjs_mr, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.4(0.2).4, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of returning to Mexico after migration", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_rmigrant.png", replace

did_imputation dest_us geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort) autos minn(0)

estimates store bjs_us

event_plot bjs_us, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to the US", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_BJS_USmigrant.png", replace

did_imputation work geo cohort first_cohort ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort) autos minn(0)

estimates store bjs_work

event_plot bjs_work, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of working", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_work.png", replace

did_imputation lwage geo cohort first_cohort if work==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural edu) cluster(geo) fe(geo cohort) autos minn(0)

estimates store bjs_wage

event_plot bjs_wage, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change of wages (if works)", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_BJS_wage.png", replace


did_imputation dest_amer geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort) autos minn(0)

estimates store bjs_amer

did_imputation dest_euro geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort) autos minn(0)

estimates store bjs_euro

did_imputation dest_asia geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort) autos minn(0)

estimates store bjs_asia

event_plot bjs_amer bjs_euro bjs_asia, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre#) ///
    stub_lag(tau# tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to indicated countries", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Americas" 4 "Europe" 6 "Asia") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(S) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt3(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_BJS_DESTmigrant.png", replace


did_imputation dest_spanish geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort) autos minn(0)

estimates store bjs_spa

did_imputation dest_no_spanish geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort) autos minn(0)

estimates store bjs_nspa

event_plot bjs_spa bjs_nspa, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre#) ///
    stub_lag(tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to indicated countries", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Hispanic countries" 4 "Non-Hispanic countries") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_BJS_SPANISHmigrant.png", replace

*========================================================================*
/* 1990 census variables x cohort FE */
*========================================================================*
/* TWFE */
*========================================================================*
reghdfe dmigrant female rural F*event L*event [aw=factor] ///
, absorb(cohort geo h_tot#cohort eap_emp#cohort migra_rat#cohort) vce(cluster geo)
estimates store ols_dmigrantC90

event_plot ols_dmigrantC90, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating domestically", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_dmigrantC90.png", replace

reghdfe migrant female rural F*event L*event [aw=factor] ///
, absorb(cohort geo h_tot#cohort eap_emp#cohort migra_rat#cohort) vce(cluster geo)
estimates store ols_migrantC90

event_plot ols_migrantC90, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.02(0.01)0.02, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating abroad", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_migrantC90.png", replace

reghdfe dest_us female rural F*event L*event [aw=factor] ///
if migrant==1, absorb(cohort geo h_tot#cohort eap_emp#cohort migra_rat#cohort) vce(cluster geo)
estimates store ols_usmigrantC90

event_plot ols_usmigrantC90, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to the US", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_TWFE_USmigrantC90.png", replace

reghdfe work female rural F*event L*event [aw=factor] ///
, absorb(cohort geo h_tot#cohort eap_emp#cohort migra_rat#cohort) vce(cluster geo)
estimates store ols_workC90

event_plot ols_workC90, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of working", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_workC90.png", replace

reghdfe lwage female rural edu F*event L*event [aw=factor] ///
if work==1, absorb(cohort geo h_tot#cohort eap_emp#cohort migra_rat#cohort) vce(cluster geo)
estimates store ols_wageC90

event_plot ols_wageC90, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change of wages (if works)", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_TWFE_wageC90.png", replace


reghdfe dest_amer female rural F*event L*event [aw=factor] ///
if migrant==1, absorb(cohort geo h_tot#cohort eap_emp#cohort migra_rat#cohort) vce(cluster geo)
estimates store ols_AMERmigrantC90

reghdfe dest_asia female rural F*event L*event [aw=factor] ///
if migrant==1, absorb(cohort geo h_tot#cohort eap_emp#cohort migra_rat#cohort) vce(cluster geo)
estimates store ols_ASIAmigrantC90

reghdfe dest_euro female rural F*event L*event [aw=factor] ///
if migrant==1, absorb(cohort geo h_tot#cohort eap_emp#cohort migra_rat#cohort) vce(cluster geo)
estimates store ols_EUROmigrantC90

event_plot ols_AMERmigrantC90 ols_EUROmigrantC90 ols_ASIAmigrantC90, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event F#event) ///
    stub_lag(L#event L#event L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to indicated countries", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Americas" 4 "Europe" 6 "Asia") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(S) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt3(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_TWFE_DESTmigrantC90.png", replace


reghdfe dest_spanish female rural F*event L*event [aw=factor] ///
if migrant==1, absorb(cohort geo h_tot#cohort eap_emp#cohort migra_rat#cohort) vce(cluster geo)
estimates store ols_SPANISHmigrantC90

reghdfe dest_no_spanish female rural F*event L*event [aw=factor] ///
if migrant==1, absorb(cohort geo h_tot#cohort eap_emp#cohort migra_rat#cohort) vce(cluster geo)
estimates store ols_NoSPANISHmigrantC90

event_plot ols_SPANISHmigrantC90 ols_NoSPANISHmigrantC90, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event) ///
    stub_lag(L#event L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to indicated countries", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Hispanic countries" 4 "Non-Hispanic countries") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_TWFE_SPANISHmigrantC90.png", replace

*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract dmigrant L*event F*event [aw=factor], ///
absorb(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix dm_b = e(b_iw)
matrix dm_v = e(V_iw)

event_plot dm_b#dm_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating domestically", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_SA_dmigrantC90.png", replace

eventstudyinteract migrant L*event F*event [aw=factor], ///
absorb(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix m_b = e(b_iw)
matrix m_v = e(V_iw)

event_plot m_b#m_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.02(0.01)0.02, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating abroad", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_SA_migrantC90.png", replace

eventstudyinteract dest_us L*event F*event [aw=factor] if migrant==1, ///
absorb(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix us_b = e(b_iw)
matrix us_v = e(V_iw)

event_plot us_b#us_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to the US", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_SA_USmigrantC90.png", replace

eventstudyinteract work L*event F*event [aw=factor], ///
absorb(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix work_b = e(b_iw)
matrix work_v = e(V_iw)

event_plot work_b#work_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of working", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_SA_workC90.png", replace

eventstudyinteract lwage L*event F*event [aw=factor] if work==1, ///
absorb(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural edu) vce(cluster geo)

matrix wage_b = e(b_iw)
matrix wage_v = e(V_iw)

event_plot wage_b#wage_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change of wages (if works)", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_SA_wageC90.png", replace


eventstudyinteract dest_amer L*event F*event [aw=factor] if migrant==1, ///
absorb(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix amer_b = e(b_iw)
matrix amer_v = e(V_iw)

eventstudyinteract dest_asia L*event F*event [aw=factor] if migrant==1, ///
absorb(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix asia_b = e(b_iw)
matrix asia_v = e(V_iw)

eventstudyinteract dest_euro L*event F*event [aw=factor] if migrant==1, ///
absorb(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix euro_b = e(b_iw)
matrix euro_v = e(V_iw)

event_plot amer_b#amer_v euro_b#euro_v asia_b#asia_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event F#event) ///
    stub_lag(L#event L#event L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to indicated countries", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Americas" 4 "Europe" 6 "Asia") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(S) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt3(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_SA_DESTmigrantC90.png", replace


eventstudyinteract dest_spanish L*event F*event [aw=factor] if migrant==1, ///
absorb(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix spa_b = e(b_iw)
matrix spa_v = e(V_iw)

eventstudyinteract dest_no_spanish L*event F*event [aw=factor] if migrant==1, ///
absorb(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) cohort(first_cohort) control_cohort(lastcohort) ///
covariates(female rural) vce(cluster geo)

matrix nspa_b = e(b_iw)
matrix nspa_v = e(V_iw)

event_plot spa_b#spa_v nspa_b#nspa_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event) ///
    stub_lag(L#event L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to indicated countries", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Hispanic countries" 4 "Non-Hispanic countries") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_SA_SPANISHmigrantC90.png", replace

*========================================================================*
/* Borusyak, Jaravel, and Spiess (2024) */
*========================================================================*
did_imputation dmigrant geo cohort first_cohort ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) autos minn(0)

estimates store bjs_dmC90

event_plot bjs_dmC90, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating domestically", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_dmigrantC90.png", replace

did_imputation migrant geo cohort first_cohort ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) autos minn(0)

estimates store bjs_mC90

event_plot bjs_mC90, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.02(0.01)0.02, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating abroad", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_migrantC90.png", replace

did_imputation dest_us geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) autos minn(0)

estimates store bjs_usC90

event_plot bjs_usC90, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to the US", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_BJS_USmigrantC90.png", replace

did_imputation work geo cohort first_cohort ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) autos minn(0)

estimates store bjs_workC90

event_plot bjs_workC90, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of working", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_workC90.png", replace

did_imputation lwage geo cohort first_cohort if work==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural edu) cluster(geo) fe(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) autos minn(0)

estimates store bjs_wageC90

event_plot bjs_wageC90, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change of wages (if works)", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_BJS_wageC90.png", replace


did_imputation dest_amer geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) autos minn(0)

estimates store bjs_amerC90

did_imputation dest_euro geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) autos minn(0)

estimates store bjs_euroC90

did_imputation dest_asia geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) autos minn(0)

estimates store bjs_asiaC90

event_plot bjs_amerC90 bjs_euroC90 bjs_asiaC90, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre#) ///
    stub_lag(tau# tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to indicated countries", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Americas" 4 "Europe" 6 "Asia") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(S) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt3(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_BJS_DESTmigrantC90.png", replace


did_imputation dest_spanish geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) autos minn(0)

estimates store bjs_spaC90

did_imputation dest_no_spanish geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo) fe(geo cohort h_tot#cohort eap_emp#cohort migra_rat#cohort) autos minn(0)

estimates store bjs_nspaC90

event_plot bjs_spaC90 bjs_nspaC90, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre#) ///
    stub_lag(tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to indicated countries", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Hispanic countries" 4 "Non-Hispanic countries") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_BJS_SPANISHmigrantC90.png", replace


























*========================================================================*
/* Double clustering - Borusyak, Jaravel, and Spiess (2024) */
*========================================================================*
did_imputation dmigrant geo cohort first_cohort ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo cohort) fe(geo cohort) autos minn(0)

estimates store bjs_dm1

event_plot bjs_dm1, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating domestically", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_dmigrant1.png", replace

did_imputation migrant geo cohort first_cohort ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo cohort) fe(geo cohort) autos minn(0)

estimates store bjs_m1

event_plot bjs_m1, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.02(0.01)0.02, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating abroad", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_migrant1.png", replace

did_imputation dest_us geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo cohort) fe(geo cohort) autos minn(0)

estimates store bjs_us1

event_plot bjs_us1, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to the US", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_BJS_USmigrant1.png", replace

did_imputation work geo cohort first_cohort ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo cohort) fe(geo cohort) autos minn(0)

estimates store bjs_work1

event_plot bjs_work1, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of working", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_work1.png", replace

did_imputation lwage geo cohort first_cohort if work==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural edu) cluster(geo cohort) fe(geo cohort) autos minn(0)

estimates store bjs_wage1

event_plot bjs_wage1, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change of wages (if works)", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_BJS_wage1.png", replace


did_imputation dest_amer geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo cohort) fe(geo cohort) autos minn(0)

estimates store bjs_amer1

did_imputation dest_euro geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo cohort) fe(geo cohort) autos minn(0)

estimates store bjs_euro1

did_imputation dest_asia geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo cohort) fe(geo cohort) autos minn(0)

estimates store bjs_asia1

event_plot bjs_amer1 bjs_euro1 bjs_asia1, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre#) ///
    stub_lag(tau# tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to indicated countries", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Americas" 4 "Europe" 6 "Asia") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(S) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt3(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_BJS_DESTmigrant1.png", replace


did_imputation dest_spanish geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo cohort) fe(geo cohort) autos minn(0)

estimates store bjs_spa1

did_imputation dest_no_spanish geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/7) pretrend(6) ///
controls(female rural) cluster(geo cohort) fe(geo cohort) autos minn(0)

estimates store bjs_nspa1

event_plot bjs_spa1 bjs_nspa1, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre#) ///
    stub_lag(tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to indicated countries", size(medium) height(5)) ///
	xlabel(-6(1)7) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Hispanic countries" 4 "Non-Hispanic countries") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_BJS_SPANISHmigrant1.png", replace