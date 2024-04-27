*========================================================================*
/* English skills and labor market outcomes in Mexico */
*========================================================================*
/* Author: Oscar Galvez-Soriano */
*========================================================================*
/* Before running my do file, you may need to install the following 
packages 

ssc install catplot, replace
ssc install estout, replace
ssc install grstyle, replace
ssc install spmap, replace
ssc install boottest, replace
ssc install csdid, replace
ssc install drdid, replace
ssc install reghdfe, replace
ssc install eventstudyinteract, replace
ssc install did_multiplegt, replace
ssc install avar, replace
ssc install ftools, replace
ssc install coefplot
ssc install event_plot, replace
grstyle init
grstyle set plain, horizontal

*/

clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/ReturnsEng/Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\ReturnsEng\Doc"
*========================================================================*
/* FIGURE X. Event-study graphs */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)
destring geo, replace

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
/* Panel (a). Hours of English */
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid hrs_exp edu female if paidw==1 & cohort>=1984 & cohort<=1994 [iw=weight], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-6 6) estore(csdid_hrsEng)

coefplot csdid_hrsEng, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CSdid_hrsEng.png", replace
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
gen tgroup=first_cohort
replace tgroup=. if state!="01" & state!="10" & state!="19" & state!="25" ///
& state!="26" & state!="28"
gen cgroup=tgroup==.

gen K = cohort-first_cohort

sum first_cohort
gen lastcohort = first_cohort==r(max) // dummy for the latest- or never-treated cohort
forvalues l = 0/6 {
	gen L`l'event = K==`l'
}
forvalues l = 1/6 {
	gen F`l'event = K==-`l'
}
replace F1event=0 // normalize K=-1 to zero

eventstudyinteract hrs_exp L*event F*event if paidw==1 & cohort>=1984 & cohort<=1994 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)

event_plot e(b_iw)#e(V_iw), plottype(scatter) ciplottype(rspike) ///
graph_opt(xtitle("Cohorts since policy intervention") ///
yline(0, lp(solid) lc(black)) ///
xline(-0.5, lc(ltblue)) ///
ytitle("Weekly hours of English instruction") xlabel(-6(1)6)) ///
stub_lag(L#event) stub_lead(F#event) 
graph export "$doc\PTA_SAdid_hrsEng.png", replace
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe hrs_exp F*event L*event female edu [aw=weight] ///
if cohort>=1984 & cohort<=1994 & paidw==1, absorb(cohort geo) vce(cluster geo)
estimates store ols_hrsEng
matrix ols_b = e(b)
matrix ols_v = e(V_FE)

coefplot, vertical keep(F*event L*event) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected)
graph export "$doc\PTA_OLSdid_hrsEng.png", replace
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

graph export "$doc\PTA_CDdid_hrsEng.png", replace
*========================================================================*
/* All in one. Panel (a) */
*========================================================================*
event_plot ols_hrsEng sa_b#sa_v csdid_hrsEng dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "TWFE" 4 "Sun-Abraham" 6 "Callaway-Sant'Anna" 8 "de Chaisemartin and D'Haultfoeuille") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(medlarge) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(medium) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(medlarge) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(medium) msymbol(D) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt4(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_All_hrsEng.png", replace

*========================================================================*
/* Panel (b). Likelihood of speaking English */
*========================================================================*
clear matrix
clear mata
eststo clear
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid eng edu female if paidw==1 & cohort>=1984 & cohort<=1994 [iw=weight], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-6 6) estore(csdid_Eng)

coefplot csdid_Eng, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CSdid_Eng.png", replace
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract eng L*event F*event if paidw==1 & cohort>=1984 & cohort<=1994 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)

event_plot e(b_iw)#e(V_iw), plottype(scatter) ciplottype(rspike) ///
graph_opt(xtitle("Cohorts since policy intervention") ///
yline(0, lp(solid) lc(black)) ///
xline(-0.5, lc(ltblue)) ///
ytitle("Likelihood of speaking English") xlabel(-6(1)6)) ///
stub_lag(L#event) stub_lead(F#event) 
graph export "$doc\PTA_SAdid_Eng.png", replace
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe eng F*event L*event female edu [aw=weight] ///
if cohort>=1984 & cohort<=1994 & paidw==1, absorb(cohort geo) vce(cluster geo)
estimates store ols_Eng
matrix ols_b = e(b)
matrix ols_v = e(V_FE)

coefplot, vertical keep(F*event L*event) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected)
graph export "$doc\PTA_OLSdid_Eng.png", replace
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

graph export "$doc\PTA_CDdid_Eng.png", replace
*========================================================================*
/* All in one. Panel (b) */
*========================================================================*
event_plot ols_Eng sa_b#sa_v csdid_Eng dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(medlarge) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(medium) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(medlarge) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(medium) msymbol(D) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt4(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_All_Eng.png", replace

*========================================================================*
/* Panel (c). Likelihood of working for pay */
*========================================================================*
clear matrix
clear mata
eststo clear
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid paidw edu female if cohort>=1984 & cohort<=1994 [iw=weight], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-6 6) estore(csdid_paid)

coefplot csdid_paid, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working for pay", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CSdid_paid.png", replace
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract paidw L*event F*event if cohort>=1984 & cohort<=1994 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)

event_plot e(b_iw)#e(V_iw), plottype(scatter) ciplottype(rspike) ///
graph_opt(xtitle("Cohorts since policy intervention") ///
yline(0, lp(solid) lc(black)) ///
xline(-0.5, lc(ltblue)) ///
ytitle("Likelihood of working for pay") xlabel(-6(1)6)) ///
stub_lag(L#event) stub_lead(F#event) 
graph export "$doc\PTA_SAdid_paid.png", replace
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe paidw F*event L*event female edu [aw=weight] ///
if cohort>=1984 & cohort<=1994, absorb(cohort geo) vce(cluster geo)
estimates store ols_paid
matrix ols_b = e(b)
matrix ols_v = e(V_FE)

coefplot, vertical keep(F*event L*event) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working for pay", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected)
graph export "$doc\PTA_OLSdid_paid.png", replace
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

graph export "$doc\PTA_CDdid_paid.png", replace
*========================================================================*
/* All in one. Panel (c) */
*========================================================================*
event_plot ols_paid sa_b#sa_v csdid_paid dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(medlarge) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(medium) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(medlarge) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(medium) msymbol(D) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt4(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_All_paid.png", replace

*========================================================================*
/* Panel (d). Log of wages */
*========================================================================*
clear matrix
clear mata
eststo clear
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid lwage edu female if paidw==1 & cohort>=1984 & cohort<=1994 [iw=weight], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-6 6) estore(csdid_wage)

coefplot csdid_wage, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Percentage change in wages", size(medium) height(5)) ///
ylabel(-5(2.5)5, labs(medium) grid format(%5.1f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-5 5)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CSdid_wages.png", replace
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract lwage L*event F*event if paidw==1 & cohort>=1984 & cohort<=1994 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)

event_plot e(b_iw)#e(V_iw), plottype(scatter) ciplottype(rspike) ///
graph_opt(xtitle("Cohorts since policy intervention") ///
yline(0, lp(solid) lc(black)) ///
xline(-0.5, lc(ltblue)) ///
ytitle("Percentage change in wages") xlabel(-6(1)6)) ///
stub_lag(L#event) stub_lead(F#event) 
graph export "$doc\PTA_SAdid_wages.png", replace
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe lwage F*event L*event female edu [aw=weight] ///
if cohort>=1984 & cohort<=1994 & paidw==1, absorb(cohort geo) vce(cluster geo)
estimates store ols_wages
matrix ols_b = e(b)
matrix ols_v = e(V_FE)

coefplot, vertical keep(F*event L*event) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Percentage change of wages", size(medium) height(5)) ///
ylabel(-5(2.5)5, labs(medium) grid format(%5.1f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-5 5)) recast(connected)
graph export "$doc\PTA_OLSdid_wages.png", replace
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

graph export "$doc\PTA_CDdid_wages.png", replace
*========================================================================*
/* Borusyak, Jaravel, and Spiess (2024) */
*========================================================================*
/*replace first_cohort=1997 if first_cohort==0

did_imputation lwage geo cohort first_cohort if paidw==1 & ///
cohort>=1984 & cohort<=1994 [aw=weight], horizons(0/6) pretrend(6) ///
controls(female edu) cluster(geo) autos minn(0)

event_plot, default_look graph_opt(xtitle("Cohorts since policy intervention") ///
ytitle("Percentage change of wages") xlabel(-6(1)6))*/
*========================================================================*
/* All in One */
*========================================================================*
event_plot ols_wages sa_b#sa_v csdid_wage dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(medlarge) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(medium) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(medlarge) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(medium) msymbol(D) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt4(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_All_wages.png", replace

*========================================================================*
/* Panel (e). Percentage change of hours worked */
*========================================================================*
clear matrix
clear mata
eststo clear
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid lhwork edu female if cohort>=1984 & cohort<=1994 [iw=weight], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-6 6) estore(csdid_ls)

coefplot csdid_ls, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Percentage change of hours worked", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CSdid_ls.png", replace
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract lhwork L*event F*event if cohort>=1984 & cohort<=1994 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)

event_plot e(b_iw)#e(V_iw), plottype(scatter) ciplottype(rspike) ///
graph_opt(xtitle("Cohorts since policy intervention") ///
yline(0, lp(solid) lc(black)) ///
xline(-0.5, lc(ltblue)) ///
ytitle("Percentage change of hours worked") xlabel(-6(1)6)) ///
stub_lag(L#event) stub_lead(F#event) 
graph export "$doc\PTA_SAdid_ls.png", replace
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe lhwork F*event L*event female edu [aw=weight] ///
if cohort>=1984 & cohort<=1994, absorb(cohort geo) vce(cluster geo)
estimates store ols_ls
matrix ols_b = e(b)
matrix ols_v = e(V_FE)

coefplot, vertical keep(F*event L*event) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Percentage change of hours worked", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected)
graph export "$doc\PTA_OLSdid_ls.png", replace
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt lhwork geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

graph export "$doc\PTA_CDdid_ls.png", replace
*========================================================================*
/* All in one. Panel (e) */
*========================================================================*
event_plot ols_ls sa_b#sa_v csdid_ls dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of hours worked", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(medlarge) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(medium) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(medlarge) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(medium) msymbol(D) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt4(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_All_ls.png", replace

*========================================================================*
/* Panel (f). Likelihood of working in formal sector */
*========================================================================*
clear matrix
clear mata
eststo clear
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid formal edu female if cohort>=1984 & cohort<=1994 [iw=weight], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-6 6) estore(csdid_formal)

coefplot csdid_formal, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in formal sector", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CSdid_formal.png", replace
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract formal L*event F*event if cohort>=1984 & cohort<=1994 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)

event_plot e(b_iw)#e(V_iw), plottype(scatter) ciplottype(rspike) ///
graph_opt(xtitle("Cohorts since policy intervention") ///
yline(0, lp(solid) lc(black)) ///
xline(-0.5, lc(ltblue)) ///
ytitle("Likelihood of working in formal sector") xlabel(-6(1)6)) ///
stub_lag(L#event) stub_lead(F#event) 
graph export "$doc\PTA_SAdid_formal.png", replace
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe formal F*event L*event female edu [aw=weight] ///
if cohort>=1984 & cohort<=1994, absorb(cohort geo) vce(cluster geo)
estimates store ols_formal
matrix ols_b = e(b)
matrix ols_v = e(V_FE)

coefplot, vertical keep(F*event L*event) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in formal sector", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected)
graph export "$doc\PTA_OLSdid_formal.png", replace
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt formal geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

graph export "$doc\PTA_CDdid_formal.png", replace
*========================================================================*
/* All in one. Panel (f) */
*========================================================================*
event_plot ols_formal sa_b#sa_v csdid_formal dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working in formal sector", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(medlarge) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(medium) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(medlarge) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(medium) msymbol(D) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt4(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_All_formal.png", replace