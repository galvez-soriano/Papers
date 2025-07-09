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
use "$data/hsg_data.dta", clear

destring cd_a, replace
rename ent state
gen female=sex=="2"
destring eda, replace
gen cohort=2012-eda

gen eng=p19=="1"
destring p20_1, gen (eng_read)
destring p20_2, gen (eng_write)
destring p20_3, gen (eng_speak)
gen computer=p21=="1"
destring p22_1, gen (internet)
destring p22_2, gen (ms_word)
destring p22_4, gen (ms_excel)
gen stud=p23=="1"

replace eng_read=0 if eng_read==. & eng==0 
replace eng_write=0 if eng_write==. & eng==0
replace eng_speak=0 if eng_speak==. & eng==0
replace internet=0 if internet==. & computer==0
replace ms_word=0 if ms_word==. & computer==0
replace ms_excel=0 if ms_excel==. & computer==0

keep state cd_a cohort female eng eng_read eng_speak eng_write fac computer internet ms_word ms_excel stud

merge m:m state cd_a using "$base\enilems12\enoe_mun_city.dta"
drop if _merge!=3
drop _merge

gen str geo_mun=state+mun
order cd_a state mun geo_mun cohort

merge m:1 geo_mun cohort using "$data/exposure_mun.dta"
rename hrs_exp2 hrs_exp
drop if _merge==2

rename _merge merge3
merge m:1 state cohort using "$data/exposure_state.dta"
replace hrs_exp=hrs_exp3 if merge3==1 & hrs_exp==.
drop if _merge==2
drop merge3 hrs_exp3 _merge

sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)

save "$base/hsg_fdata.dta", replace

*========================================================================*
use "$base/hsg_fdata.dta", clear

collapse hrs_exp [fw=fac], by(geo_mun cohort)
sum hrs_exp, d
gen engl=hrs_exp>=r(p90)

bysort geo_mun: replace engl=1 if engl[_n-1]==1 & engl[_n+1]==1 & engl==0
bysort geo_mun: replace engl=1 if engl[_n-1]==1 & engl==0 & cohort==1994
bysort geo_mun: replace engl=0 if engl[_n-1]==0 & engl[_n+1]==0 & engl==1

gen ftreat=.
bysort geo_mun: gen ncount=_n if engl!=0
bysort geo_mun: replace ftreat=cohort if ncount[_n-1]==. & ncount[_n+1]>ncount & ncount!=. // this identifies the first treated cohort but exclude never treated
bysort geo_mun: egen first_treat = total(ftreat) // assigning the value of the first treated cohort to all observations within a municipality

rename first_treat first_cohort
keep geo_mun cohort first_cohort

replace first_cohort = 1995 if first_cohort==0
gen K = cohort-first_cohort
gen D = K>=0 & first_cohort!=.

save "$base/hsg_exp.dta", replace

*========================================================================*
use "$base/hsg_fdata.dta", clear

gen s_eng=eng_speak>=2
gen w_eng=eng_write>=2
gen r_eng=eng_read>=2

merge m:1 geo_mun cohort using "$base/hsg_exp.dta", nogen

destring state, replace
*========================================================================*
/* Table 4. English skills among high school graduates */
*========================================================================*
eststo clear
eststo: did_imputation eng geo_mun cohort first_cohort [aw=fac], ///
controls(female) fe(geo_mun cohort state#cohort) cluster(geo_mun) autos minn(0)
eststo: did_imputation s_eng geo_mun cohort first_cohort [aw=fac], ///
controls(female) fe(geo_mun cohort state#cohort) cluster(geo_mun) autos minn(0)
eststo: did_imputation w_eng geo_mun cohort first_cohort [aw=fac], ///
controls(female) fe(geo_mun cohort state#cohort) cluster(geo_mun) autos minn(0)
eststo: did_imputation r_eng geo_mun cohort first_cohort [aw=fac], ///
controls(female) fe(geo_mun cohort state#cohort) cluster(geo_mun) autos minn(0)
esttab using "$doc\tab4.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English skills among high school graduates) keep(tau) ///
stats(N, fmt(%9.0fc %9.3f)) replace

*========================================================================*
/* Figure AXX. English skills among high school graduates */
*========================================================================*
did_imputation eng geo_mun cohort first_cohort [aw=fac], ///
horizons(0/1) pretrend(1) controls(female) fe(geo_mun cohort state#cohort) ///
cluster(geo_mun) autos minn(0)

estimates store bjs_eng_hs

event_plot bjs_eng_hs, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.8(0.4).8, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of having any knowledge of English", size(medium) height(5)) ///
	xlabel(-1(1)1) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_BJS_knowEngHS.png", replace


did_imputation s_eng geo_mun cohort first_cohort [aw=fac], ///
horizons(0/1) pretrend(1) controls(female) fe(geo_mun cohort state#cohort) ///
cluster(geo_mun) autos minn(0)

estimates store bjs_seng_hs

event_plot bjs_seng_hs, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.8(0.4).8, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-1(1)1) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_BJS_speakEngHS.png", replace

did_imputation w_eng geo_mun cohort first_cohort [aw=fac], ///
horizons(0/1) pretrend(1) controls(female) fe(geo_mun cohort state#cohort) ///
cluster(geo_mun) autos minn(0)

estimates store bjs_weng_hs

event_plot bjs_weng_hs, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.8(0.4).8, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of writing English", size(medium) height(5)) ///
	xlabel(-1(1)1) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_BJS_writeEngHS.png", replace


did_imputation r_eng geo_mun cohort first_cohort [aw=fac], ///
horizons(0/1) pretrend(1) controls(female) fe(geo_mun cohort state#cohort) ///
cluster(geo_mun) autos minn(0)

estimates store bjs_reng_hs

event_plot bjs_reng_hs, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.8(0.4).8, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of reading English", size(medium) height(5)) ///
	xlabel(-1(1)1) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_BJS_readEngHS.png", replace
