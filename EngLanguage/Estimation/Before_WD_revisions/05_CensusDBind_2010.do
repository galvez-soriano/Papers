*========================================================================*
* English program and language skills
*========================================================================*
/* Oscar Galvez-Soriano and Ornella Darova */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngLanguage\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngLanguage\Doc"
*========================================================================*
use "$base\personas2010.dta", clear
keep ent mun id_viv id_per factor sexo edad asisten escoacum ///
res05edo_c res05pai_c mun05otr_c conact ingtrmen hortra acttrab_c ///
tam_loc lnacedo_c peretn hlengua hespanol clengua

rename id_per id
tostring id_viv, replace format(%012.0f) force
rename ent state
rename sexo female
recode female (1=0) (3=1)
rename edad age
rename asisten student
recode student (3=0) (9=.)
replace student=1 if conact==50
rename escoacum edu
replace edu=. if edu==99
rename res05edo_c state5
rename mun05otr_c mun5
gen work=conact<=30

rename ingtrmen wage
replace wage=. if wage==999999
rename hortra hrs_w
replace hrs_w=. if hrs_w==999

gen rural=tam_loc==1
destring state5, replace
replace state5=. if state5>32
tostring state5, replace format(%02.0f) force
tostring mun5, replace format(%03.0f) force
gen str geo=(state5+mun5)
replace geo="." if mun5=="."

rename lnacedo_c countryborn

gen indigenous=peretn==1
drop peretn

recode hlengua (3=0) (9=.)
recode hespanol (3=0) (9=.)
recode clengua (3=0) (9=.)

save "$base\census10.dta", replace
*========================================================================*
use "$base\census10.dta", clear

gen cohort=.
replace cohort=2010-age
keep if cohort>=1984 & cohort<=1994
label var cohort "Cohorts"

gen wpaid=wage>0 & work==1 & wage!=.

gen lwage=log(wage) if wpaid==1
gen age2=age^2

tostring state, replace format(%02.0f) force
tostring mun, replace format(%03.0f) force
replace geo=(state+mun) if geo=="."
replace geo=(state+mun) if geo==""

save "$base\labor_census10.dta", replace
*========================================================================* 
use "$base\labor_census10.dta", clear

gen str geo_mun = state5 + mun5

merge m:1 geo_mun cohort using "$data/Papers/main/EngMigration/Data/exposure_mun.dta"
drop if _merge==2
drop _merge

merge m:1 state cohort using "$data/Papers/main/EngMigration/Data/exposure_state.dta"
drop if _merge!=3

rename hrs_exp2 hrs_exp 
replace hrs_exp=hrs_exp3 if hrs_exp==.
drop _merge hrs_exp3

gen imputed_state=geo=="."
drop if imputed_state==1
drop geo imputed_state
gen str geo=(state+mun)
order geo

replace work=. if conact==30
gen labor=conact<=30

gen dmigrant=geo!=geo_mun

save "$base\labor_census10.dta", replace
*========================================================================* 
/* Exposure variable check */
*========================================================================* 
use "$base\labor_census10.dta", clear

collapse hrs_exp, by(geo cohort)
rename hrs_exp hrs_exp2
save "$base\exp_mun_cohort.dta", replace
merge 1:m geo cohort using "$base\labor_census10.dta", nogen

order geo cohort hrs_exp hrs_exp2
save "$base\labor_census10.dta", replace
*=========================================================================* 
/* Keeping only individuals likely to be treated */
*=========================================================================* 
use "$base\labor_census10.dta", clear
destring state5, replace

drop if state=="05" | state=="17"
drop lwage
gen lwage=log(wage+1)
replace wpaid=. if work==0

drop countryborn state5 mun5 conact
destring geo, replace

save "$base\labor_census10.dta", replace
*========================================================================*
use "$base\labor_census10.dta", clear

sum hrs_exp2 if state=="01" & cohort>=1990 & cohort<=1996, d
gen engl=hrs_exp2>=r(p75) & state=="01"
sum hrs_exp2 if state=="10" & cohort>=1991 & cohort<=1996, d
replace engl=1 if hrs_exp2>=r(p75) & state=="10"
sum hrs_exp2 if state=="19" & cohort>=1987 & cohort<=1996, d
replace engl=1 if hrs_exp2>=r(p75) & state=="19"
sum hrs_exp2 if state=="25" & cohort>=1993 & cohort<=1996, d
replace engl=1 if hrs_exp2>=r(p75) & state=="25"
sum hrs_exp2 if state=="26" & cohort>=1993 & cohort<=1996, d
replace engl=1 if hrs_exp2>=r(p75) & state=="26"
sum hrs_exp2 if state=="28" & cohort>=1990 & cohort<=1996, d
replace engl=1 if hrs_exp2>=r(p75) & state=="28"

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

*========================================================================*
/* FIGURE 13. Robustness: Estimates using the 2010 Population Census */
*========================================================================*
replace clengua=1 if hlengua==1
csdid clengua edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understIndC10)

/* Panel (a) */
event_plot csdid_understIndC10, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm#) ///
    stub_lag(Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of understanding an Indigenous language", size(medium) height(5)) ///
	xlabel(-5(1)4) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_CS_understIndC10.png", replace

csdid hlengua edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksIndC10)

/* Panel (b) */
event_plot csdid_speaksIndC10, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm#) ///
    stub_lag(Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of speaking an Indigenous language", size(medium) height(5)) ///
	xlabel(-5(1)4) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_CS_speaksIndC10.png", replace

csdid indigenous edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_indigC10)

/* Panel (c) */
event_plot csdid_indigC10, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Tm#) ///
    stub_lag(Tp#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of self-identifying as Indigenous", size(medium) height(5)) ///
	xlabel(-5(1)4) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_CS_indigC10.png", replace