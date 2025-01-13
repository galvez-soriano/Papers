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
ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.06 0.06)) recast(connected) ///
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
ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.06 0.06)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_understInd.png", replace

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
ytitle("Likelihood of speaking an Indigenous language", size(medium) height(5)) ///
ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.06 0.06)) recast(connected) ///
legend(off) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_speaksInd_Sex.png", replace


csdid elengua edu rural dmigrant if female==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd_men)

csdid elengua edu rural dmigrant if female==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd_women)

coefplot ///
(csdid_understInd_men, label("Men") connect(l) lpatt(solid) lcol(navy) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(rcap)) offset(0.1)) ///
(csdid_understInd_women, label("Women") connect(l) lpatt(solid) lcol(blue) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of understanding an Indigenous language", size(medium) height(5)) ///
ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.06 0.06)) recast(connected) ///
legend(pos(11) ring(0) col(1) region(lcolor(white)) size(medium)) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_understInd_Sex.png", replace

/* By Context */

csdid hlengua edu dmigrant female if rural==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd_urban)

csdid hlengua edu dmigrant female if rural==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd_rural)

coefplot ///
(csdid_speaksInd_urban, label("Urban") connect(l) lpatt(solid) lcol(navy) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(rcap)) offset(0.1)) ///
(csdid_speaksInd_rural, label("Rural") connect(l) lpatt(solid) lcol(blue) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking an Indigenous language", size(medium) height(5)) ///
ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.06 0.06)) recast(connected) ///
legend(off) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_speaksInd_Context.png", replace


csdid elengua edu female dmigrant if rural==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd_urban)

csdid elengua edu female dmigrant if rural==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd_rural)

coefplot ///
(csdid_understInd_urban, label("Urban") connect(l) lpatt(solid) lcol(navy) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(rcap)) offset(0.1)) ///
(csdid_understInd_rural, label("Rural") connect(l) lpatt(solid) lcol(blue) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of understanding an Indigenous language", size(medium) height(5)) ///
ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.06 0.06)) recast(connected) ///
legend(pos(11) ring(0) col(1) region(lcolor(white)) size(medium)) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_understInd_Context.png", replace


/* By education */

csdid hlengua dmigrant female rural if edu<=9 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd_lowEdu)

csdid hlengua dmigrant female rural if edu>9 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd_highEdu)

coefplot ///
(csdid_speaksInd_lowEdu, label("Low educational attainment") connect(l) lpatt(solid) lcol(navy) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(rcap)) offset(0.1)) ///
(csdid_speaksInd_highEdu, label("High educational attainment") connect(l) lpatt(solid) lcol(blue) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking an Indigenous language", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) recast(connected) ///
legend(off) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_speaksInd_Edu.png", replace

csdid elengua female rural dmigrant if edu<=9 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd_lowEdu)

csdid elengua female rural dmigrant if edu>9 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd_highEdu)

coefplot ///
(csdid_understInd_lowEdu, label("Low educational attainment") connect(l) lpatt(solid) lcol(navy) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(rcap)) offset(0.1)) ///
(csdid_understInd_highEdu, label("High educational attainment") connect(l) lpatt(solid) lcol(blue) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of understanding an Indigenous language", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) recast(connected) ///
legend(pos(11) ring(0) col(1) region(lcolor(white)) size(medium)) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_understInd_Edu.png", replace

/* By income */

csdid hlengua edu dmigrant female rural if wage<=5160 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd_low_wage)

csdid hlengua edu dmigrant female rural if wage>5160 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksInd_high_wage)

coefplot ///
(csdid_speaksInd_low_wage, label("Low income") connect(l) lpatt(solid) lcol(navy) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(rcap)) offset(0.1)) ///
(csdid_speaksInd_high_wage, label("High income") connect(l) lpatt(solid) lcol(blue) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking an Indigenous language", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) recast(connected) ///
legend(off) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_speaksInd_wage.png", replace

csdid elengua edu female rural dmigrant if wage<=5160 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd_low_wage)

csdid elengua edu female rural dmigrant if wage>5160 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understInd_high_wage)

coefplot ///
(csdid_understInd_low_wage, label("Low income") connect(l) lpatt(solid) lcol(navy) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(rcap)) offset(0.1)) ///
(csdid_understInd_high_wage, label("High income") connect(l) lpatt(solid) lcol(blue) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of understanding an Indigenous language", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) recast(connected) ///
legend(pos(11) ring(0) col(1) region(lcolor(white)) size(medium)) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_understInd_wage.png", replace

*========================================================================*
/* FIGURE X. Effects on mobility */
*========================================================================*
csdid dmigrant edu female rural migrant if indigenous==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_dmigrant_NoInd)

csdid dmigrant edu female rural migrant if indigenous==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_dmigrant_Ind)

coefplot ///
(csdid_dmigrant_NoInd, label("Non-indigenous") connect(l) lpatt(solid) lcol(navy) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(rcap)) offset(0.1)) ///
(csdid_dmigrant_Ind, label("Indigenous") connect(l) lpatt(solid) lcol(blue) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of migrating domestically", size(medium) height(5)) ///
ylabel(-0.6(0.3)0.6, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.6 0.6)) recast(connected) ///
legend(pos(5) ring(0) col(1) region(lcolor(white)) size(medium)) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_dmigrant.png", replace

*========================================================================*
/* FIGURE X. Effect by tourism industries */
*========================================================================*
rename actividades_c naics
gen tourism=naics==4810 | naics==4870 | naics==5321 | naics==5615 | naics==7120 ///
| naics==7210 | naics==7221

csdid tourism edu female rural migrant if indigenous==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_Tour_NoInd)

csdid tourism edu female rural migrant if indigenous==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_Tour_Ind)

coefplot ///
(csdid_Tour_NoInd, label("Non-indigenous") connect(l) lpatt(solid) lcol(navy) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(rcap)) offset(0.1)) ///
(csdid_Tour_Ind, label("Indigenous") connect(l) lpatt(solid) lcol(blue) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of working in tourism industry", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) recast(connected) ///
legend(pos(5) ring(0) col(1) region(lcolor(white)) size(medium)) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_tourism.png", replace

*========================================================================*
/* FIGURE X. Exposure to English instruction */
*========================================================================*
/*
csdid hrs_exp2 edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_expEng)

coefplot csdid_expEng, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Change in exposure to English instruction (hours)", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_expEng.png", replace
*/


*========================================================================*
/* Robustness */
*========================================================================*
/* FIGURE 11. Removing one state at a time */
*========================================================================*
csdid hlengua edu rural female dmigrant if state!="01" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksIndAGS)

csdid hlengua edu rural female dmigrant if state!="10" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksIndDGO)

csdid hlengua edu rural female dmigrant if state!="19" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksIndNL)

csdid hlengua edu rural female dmigrant if state!="25" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksIndSIN)

csdid hlengua edu rural female dmigrant if state!="26" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksIndSON)

csdid hlengua edu rural female dmigrant if state!="28" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksIndTAM)

coefplot ///
(csdid_speaksIndAGS, label("Without Aguascalientes") connect(l) lpatt(solid) lcol(navy) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(rcap)) offset(0.1)) ///
(csdid_speaksIndDGO, label("Without Durango") connect(l) lpatt(solid) lcol(blue) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(csdid_speaksIndNL, label("Without Nuevo Leon") connect(l) lpatt(solid) lcol(midblue) msymbol(T) mcolor(midblue) ciopt(lc(midblue) recast(rcap))) ///
(csdid_speaksIndSIN, label("Without Sinaloa") connect(l) lpatt(solid) lcol(ltblue) msymbol(D) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(csdid_speaksIndSON, label("Without Sonora") connect(l) lpatt(solid) lcol(ebblue) msymbol(X) mcolor(ebblue) ciopt(lc(ebblue) recast(rcap))) ///
(csdid_speaksIndTAM, label("Without Tamaulipas") connect(l) lpatt(solid) lcol(emidblue) msymbol(Oh) mcolor(emidblue) ciopt(lc(emidblue) recast(rcap))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
perturb(-0.25 -.15 -0.05 0.05 0.15 0.25) ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking an Indigenous language", size(medium) height(5)) ///
ylabel(-0.05(0.025)0.05, labs(medium) grid format(%5.3f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.05 0.05)) recast(connected) ///
legend(pos(11) ring(0) col(1) region(lcolor(white)) size(medium)) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_speaksIndStates.png", replace


csdid elengua edu rural female dmigrant if state!="01" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understIndAGS)

csdid elengua edu rural female dmigrant if state!="10" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understIndDGO)

csdid elengua edu rural female dmigrant if state!="19" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understIndNL)

csdid elengua edu rural female dmigrant if state!="25" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understIndSIN)

csdid elengua edu rural female dmigrant if state!="26" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understIndSON)

csdid elengua edu rural female dmigrant if state!="28" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understIndTAM)

coefplot ///
(csdid_understIndAGS, label("Without Aguascalientes") connect(l) lpatt(solid) lcol(navy) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(rcap)) offset(0.1)) ///
(csdid_understIndDGO, label("Without Durango") connect(l) lpatt(solid) lcol(blue) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(csdid_understIndNL, label("Without Nuevo Leon") connect(l) lpatt(solid) lcol(midblue) msymbol(T) mcolor(midblue) ciopt(lc(midblue) recast(rcap))) ///
(csdid_understIndSIN, label("Without Sinaloa") connect(l) lpatt(solid) lcol(ltblue) msymbol(D) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(csdid_understIndSON, label("Without Sonora") connect(l) lpatt(solid) lcol(ebblue) msymbol(X) mcolor(ebblue) ciopt(lc(ebblue) recast(rcap))) ///
(csdid_understIndTAM, label("Without Tamaulipas") connect(l) lpatt(solid) lcol(emidblue) msymbol(Oh) mcolor(emidblue) ciopt(lc(emidblue) recast(rcap))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of understanding an Indigenous language", size(medium) height(5)) ///
ylabel(-0.05(0.025)0.05, labs(medium) grid format(%5.3f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.05 0.05)) recast(connected) ///
legend(pos(11) ring(0) col(1) region(lcolor(white)) size(medium)) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_understIndStates.png", replace


csdid indigenous edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_indigAGS)

csdid indigenous edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_indigDGO)

csdid indigenous edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_indigNL)

csdid indigenous edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_indigSIN)

csdid indigenous edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_indigSON)

csdid indigenous edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_indigTAM)

coefplot ///
(csdid_indigAGS, label("Without Aguascalientes") connect(l) lpatt(solid) lcol(navy) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(rcap)) offset(0.1)) ///
(csdid_indigDGO, label("Without Durango") connect(l) lpatt(solid) lcol(blue) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(csdid_indigNL, label("Without Nuevo Leon") connect(l) lpatt(solid) lcol(midblue) msymbol(T) mcolor(midblue) ciopt(lc(midblue) recast(rcap))) ///
(csdid_indigSIN, label("Without Sinaloa") connect(l) lpatt(solid) lcol(ltblue) msymbol(D) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(csdid_indigSON, label("Without Sonora") connect(l) lpatt(solid) lcol(ebblue) msymbol(X) mcolor(ebblue) ciopt(lc(ebblue) recast(rcap))) ///
(csdid_indigTAM, label("Without Tamaulipas") connect(l) lpatt(solid) lcol(emidblue) msymbol(Oh) mcolor(emidblue) ciopt(lc(emidblue) recast(rcap))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of self-identifying as Indigenous", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.05 0.05)) recast(connected) ///
legend(pos(11) ring(0) col(1) region(lcolor(white)) size(medium)) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_indigStates.png", replace

*========================================================================*
/* FIGURE X. Different controls */
*========================================================================*
csdid hlengua [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaks1)

csdid hlengua edu female [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaks2)

csdid hlengua edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaks3)


csdid elengua [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_underst1)

csdid elengua edu female [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_underst2)

csdid elengua edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_underst3)


csdid indigenous [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_indig1)

csdid indigenous edu female [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_indig2)

csdid indigenous edu rural female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_indig3)

esttab csdid_speaks1 csdid_speaks2 csdid_speaks3 csdid_underst1 csdid_underst2 ///
csdid_underst3 csdid_indig1 csdid_indig2 csdid_indig3

esttab csdid_speaks1 csdid_speaks2 csdid_speaks3 csdid_underst1 csdid_underst2 ///
csdid_underst3 csdid_indig1 csdid_indig2 csdid_indig3 using "$doc\tab1.tex", ///
cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) ///
title(Robustness: different controls) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace


*========================================================================*
/* FIGURE X. Comparison only with Northern states */
*========================================================================*
csdid hlengua edu rural female dmigrant if state=="01" | state=="02" | ///
state=="03" | state=="05" | state=="08" | state=="10" | state=="11" | ///
state=="14" | state=="18" | state=="19" | state=="22" | state=="24" | ///
state=="25" | state=="26" | state=="28" | state=="32" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_speaksIndNS)

coefplot csdid_speaksInd, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking an Indigenous language", size(medium) height(5)) ///
ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.06 0.06)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_speaksIndNS.png", replace

csdid elengua edu rural female dmigrant if state=="01" | state=="02" | ///
state=="03" | state=="05" | state=="08" | state=="10" | state=="11" | ///
state=="14" | state=="18" | state=="19" | state=="22" | state=="24" | ///
state=="25" | state=="26" | state=="28" | state=="32" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_understIndNS)

coefplot csdid_understInd, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of understanding an Indigenous language", size(medium) height(5)) ///
ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.06 0.06)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_understIndNS.png", replace

csdid indigenous edu rural female dmigrant if state=="01" | state=="02" | ///
state=="03" | state=="05" | state=="08" | state=="10" | state=="11" | ///
state=="14" | state=="18" | state=="19" | state=="22" | state=="24" | ///
state=="25" | state=="26" | state=="28" | state=="32" [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_indigNS)

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
graph export "$doc\PTA_CS_indigNS.png", replace

/*
if state=="01" | state=="02" | state=="03" | state=="05" | state=="08" ///
| state=="10" | state=="11" | state=="14" | state=="18" | state=="19" ///
| state=="22" | state=="24" | state=="25" | state=="26" | state=="28" ///
| state=="32"
*/
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