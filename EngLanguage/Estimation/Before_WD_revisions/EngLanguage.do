*========================================================================*
* English program and language abilities
*========================================================================*
* Oscar Galvez-Soriano
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

keep if cohort>=1984 & cohort<=1994

destring geo, replace
*========================================================================*
/* FIGURE 1. Language abilities */
*========================================================================*
csdid hlengua edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd)

coefplot csdid_speaksInd, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking an Indigenous language", size(medium) height(5)) ///
ylabel(-0.05(0.025)0.05, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.05 0.05)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_speaksInd.png", replace

replace elengua=1 if hlengua==1
csdid elengua edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd)

coefplot csdid_understInd, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of understanding an Indigenous language", size(medium) height(5)) ///
ylabel(-0.05(0.025)0.05, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.05 0.05)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_understInd.png", replace

csdid hespanol edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksSpa)

coefplot csdid_speaksSpa, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking Spanish language", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_speaksSpa.png", replace

*========================================================================*
/* FIGURE 2. Indigenous identity */
*========================================================================*
csdid indigenous edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_indig)

coefplot csdid_indig, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of self-identifying as Indigenous", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_indig.png", replace

*========================================================================*
/* FIGURE 3. Heterogeneous effects */
*========================================================================*
/* By sex */
csdid hlengua edu rural dmigrant if female==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd_men)

csdid hlengua edu rural dmigrant if female==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd_women)

coefplot ///
(csdid_speaksInd_men, label("Men") connect(l) lpatt(solid) lcol(navy) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(rcap)) offset(0.1)) ///
(csdid_speaksInd_women, label("Women") connect(l) lpatt(solid) lcol(blue) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking an Indigenous language)", size(medium) height(5)) ///
ylabel(-0.05(0.025)0.05, labs(medium) grid format(%5.2f)) ///
xtitle("Years since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.05 0.05)) recast(connected) ///
legend(pos(11) ring(0) col(1) region(lcolor(white)) size(medium)) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_speaksInd_Sex.png", replace


replace elengua=1 if hlengua==1
csdid elengua edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd)

coefplot csdid_understInd, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of understanding an Indigenous language", size(medium) height(5)) ///
ylabel(-0.05(0.025)0.05, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.05 0.05)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_understInd.png", replace

csdid hespanol edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksSpa)

coefplot csdid_speaksSpa, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking Spanish language", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_speaksSpa.png", replace





*========================================================================*
/* End of do-file */
*========================================================================*

















*========================================================================*
tostring state, replace format(%02.0f) force
gen tgroup=first_cohort
replace tgroup=. if state!="01" & state!="10" & state!="19" & state!="25" ///
& state!="26" & state!="28"
gen cgroup=tgroup==.

gen K = cohort-first_cohort

sum first_cohort
gen lastcohort = first_cohort==r(max) // dummy for the latest- or never-treated cohort
forvalues l = 0/7 {
	gen L`l'event = K==`l'
}
forvalues l = 1/6 {
	gen F`l'event = K==-`l'
}
replace F1event=0 // normalize K=-1 to zero
destring state, replace

eventstudyinteract hlengua L*event F*event if dmigrant==0 [aw=factor], ///
absorb(geo cohort) cohort(tgroup) control_cohort(cgroup) ///
covariates(edu female rural migrant) vce(cluster geo)

*========================================================================*
reghdfe hlengua F*event L*event edu female rural migrant [aw=factor] ///
if dmigrant==0, absorb(cohort geo) vce(cluster geo)

*========================================================================*
did_multiplegt hlengua geo cohort had_policy if dmigrant==0, weight(factor) ///
robust_dynamic dynamic(7) placebo(5) breps(50) cluster(geo) ///
controls(edu female migrant rural)

*========================================================================*
replace first_cohort=1997 if first_cohort==0

did_imputation hlengua geo cohort first_cohort if dmigrant==0 ///
[aw=factor], horizons(0/6) pretrend(6) ///
controls(edu female migrant rural) cluster(geo) fe(geo cohort) autos minn(0)