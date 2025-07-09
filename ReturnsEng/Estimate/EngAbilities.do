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
/*gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

gen first_cohort=1997
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1
destring geo state, replace

did_imputation eng geo_mun cohort first_cohort [aw=fac], ///
controls(female) fe(geo_mun cohort state#cohort) cluster(geo_mun) autos minn(0)


did_imputation eng geo_mun cohort first_cohort [aw=fac], ///
horizons(0/2) pretrend(1) controls(female) fe(geo_mun cohort state#cohort) ///
cluster(geo_mun) autos minn(0)
*/
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

/*replace engl=0 if first_treat>1994
sum hrs_exp if engl==1, d
replace engl=1 if hrs_exp>=r(p75) & first_treat>1994
drop ftreat ncount first_treat

sort geo_mun cohort

gen ftreat=.
bysort geo_mun: gen ncount=_n if engl!=0
bysort geo_mun: replace ftreat=cohort if ncount[_n-1]==. & ncount[_n+1]>ncount & ncount!=.
bysort geo_mun: egen first_treat = total(ftreat)
*/
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

gen i_cl=internet>=3
gen w_cl=ms_word>=3
gen e_cl=ms_excel>=3

merge m:1 geo_mun cohort using "$base/hsg_exp.dta", nogen

destring state, replace

did_imputation eng geo_mun cohort first_cohort [aw=fac], ///
controls(female) fe(geo_mun cohort state#cohort) cluster(geo_mun) autos minn(0)

did_imputation s_eng geo_mun cohort first_cohort [aw=fac], ///
controls(female) fe(geo_mun cohort state#cohort) cluster(geo_mun) autos minn(0)
/*
did_imputation w_eng geo_mun cohort first_cohort [aw=fac], ///
controls(female) fe(geo_mun cohort state#cohort) cluster(geo_mun) autos minn(0)

did_imputation r_eng geo_mun cohort first_cohort [aw=fac], ///
controls(female) fe(geo_mun cohort state#cohort) cluster(geo_mun) autos minn(0)


did_imputation computer geo_mun cohort first_cohort [aw=fac], ///
controls(female) fe(geo_mun cohort state#cohort) cluster(geo_mun) autos minn(0)

did_imputation i_cl geo_mun cohort first_cohort [aw=fac], ///
controls(female) fe(geo_mun cohort state#cohort) cluster(geo_mun) autos minn(0)

did_imputation w_cl geo_mun cohort first_cohort [aw=fac], ///
controls(female) fe(geo_mun cohort state#cohort) cluster(geo_mun) autos minn(0)
*/
did_imputation e_cl geo_mun cohort first_cohort [aw=fac], ///
controls(female) fe(geo_mun cohort state#cohort) cluster(geo_mun) autos minn(0)


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

/*
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
	ytitle("Likelihood of writting in English", size(medium) height(5)) ///
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
	ytitle("Likelihood of reading in English", size(medium) height(5)) ///
	xlabel(-1(1)1) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_BJS_readEngHS.png", replace


did_imputation computer geo_mun cohort first_cohort [aw=fac], ///
horizons(0/1) pretrend(1) controls(female) fe(geo_mun cohort state#cohort) ///
cluster(geo_mun) autos minn(0)

estimates store bjs_cl_hs

event_plot bjs_cl_hs, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.5(0.25).5, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of computer literacy", size(medium) height(5)) ///
	xlabel(-1(1)1) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_BJS_CLEngHS.png", replace
*/

did_imputation e_cl geo_mun cohort first_cohort [aw=fac], ///
horizons(0/1) pretrend(1) controls(female) fe(geo_mun cohort state#cohort) ///
cluster(geo_mun) autos minn(0)

estimates store bjs_ecl_hs

event_plot bjs_ecl_hs, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.8(0.4).8, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of being proficient in Excel", size(medium) height(5)) ///
	xlabel(-1(1)1) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_BJS_ExcelEngHS.png", replace

*========================================================================*
/* By sex */
*========================================================================*

did_imputation eng geo_mun cohort first_cohort [aw=fac] if female==1, ///
horizons(0/1) pretrend(1) fe(geo_mun cohort state#cohort) ///
cluster(geo_mun) autos minn(0)

estimates store bjs_eng_hs_women

did_imputation eng geo_mun cohort first_cohort [aw=fac] if female==0, ///
horizons(0/1) pretrend(1) fe(geo_mun cohort state#cohort) ///
cluster(geo_mun) autos minn(0)

estimates store bjs_eng_hs_men

event_plot bjs_eng_hs_women bjs_eng_hs_men, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre#) ///
    stub_lag(tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.8(0.4).8, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of having any knowledge of English", size(medium) height(5)) ///
	xlabel(-1(1)1) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Women" 4 "Men") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_BJS_knowEngHSsex.png", replace


did_imputation s_eng geo_mun cohort first_cohort [aw=fac] if female==1, ///
horizons(0/1) pretrend(1) fe(geo_mun cohort state#cohort) ///
cluster(geo_mun) autos minn(0)

estimates store bjs_seng_hs_women

did_imputation s_eng geo_mun cohort first_cohort [aw=fac] if female==0, ///
horizons(0/1) pretrend(1) fe(geo_mun cohort state#cohort) ///
cluster(geo_mun) autos minn(0)

estimates store bjs_seng_hs_men

event_plot bjs_seng_hs_women bjs_seng_hs_men, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre#) ///
    stub_lag(tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.8(0.4).8, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-1(1)1) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Women" 4 "Men") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_BJS_speakEngHSsex.png", replace

did_imputation e_cl geo_mun cohort first_cohort [aw=fac] if female==1, ///
horizons(0/1) pretrend(1) fe(geo_mun cohort state#cohort) ///
cluster(geo_mun) autos minn(0)

estimates store bjs_ecl_hs_women

did_imputation e_cl geo_mun cohort first_cohort [aw=fac] if female==0, ///
horizons(0/1) pretrend(1) fe(geo_mun cohort state#cohort) ///
cluster(geo_mun) autos minn(0)

estimates store bjs_ecl_hs_men

event_plot bjs_ecl_hs_women bjs_ecl_hs_men, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre#) ///
    stub_lag(tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.8(0.4).8, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of being proficient in Excel", size(medium) height(5)) ///
	xlabel(-1(1)1) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "Women" 4 "Men") pos(7) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick))
graph export "$doc\PTA_BJS_ExcelEngHSsex.png", replace