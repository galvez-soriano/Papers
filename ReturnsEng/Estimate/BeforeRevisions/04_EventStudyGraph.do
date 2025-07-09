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
/* FIGURE 3. Event-study graphs */
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

tab state, generate(dstate)
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 {
	foreach z in 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 ///
	1993 1994 {
gen c_state`z'_`x'=0
replace c_state`z'_`x'=1 if dstate`x'==1 & cohort==`z'
}
}

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
estat event, window(-5 6) estore(csdid_hrsEng)
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

destring state, replace

eventstudyinteract hrs_exp L*event F*event if paidw==1 & cohort>=1984 & cohort<=1994 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female state#cohort) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)

test (F2event=0) (F3event=0) (F4event=0) (F5event=0) (F6event=0)
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe hrs_exp F*event L*event female edu [aw=weight] ///
if cohort>=1984 & cohort<=1994 & paidw==1, absorb(cohort geo state#cohort) vce(cluster geo)
estimates store ols_hrsEng
matrix ols_b = e(b)
matrix ols_v = e(V_FE)

test (F2event=0) (F3event=0) (F4event=0) (F5event=0) (F6event=0)
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* Borusyak, Jaravel, and Spiess (2024) */
*========================================================================*
replace first_cohort=1997 if first_cohort==0

did_imputation hrs_exp geo cohort first_cohort if paidw==1 & ///
cohort>=1984 & cohort<=1994 [aw=weight], horizons(0/6) pretrend(6) ///
controls(female edu) cluster(geo) fe(geo cohort state#cohort) autos minn(0)

event_plot, default_look graph_opt(xtitle("Cohorts since policy intervention") ///
ytitle("Weekly hours of English instruction") xlabel(-6(1)6))

estimates store bjs
*========================================================================*
/* All in one. Panel (a) */
*========================================================================*
/*event_plot ols_hrsEng sa_b#sa_v csdid_hrsEng dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend perturb(-.16 -0.06 0.06 0.16) ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "TWFE" 4 "Sun-Abraham" 6 "Callaway-Sant'Anna" 8 "de Chaisemartin and D'Haultfoeuille") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_All_hrsEng.png", replace
*/
event_plot ols_hrsEng sa_b#sa_v csdid_hrsEng dcdh_b#dcdh_v bjs, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_# pre#) ///
    stub_lag(L#event L#event Tp# Effect_# tau#) ///
    together noautolegend perturb(-.20 -0.10 0 0.10 0.20) ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "TWFE" 4 "Sun-Abraham" 6 "Callaway-Sant'Anna" 8 "de Chaisemartin and D'Haultfoeuille" 10 "Borusyak et. al") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt4(color(ltblue) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(X) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt5(color(ebblue) lwidth(medthick)) 
graph export "$doc\PTA_All_hrsEng.png", replace

*========================================================================*
/* Panel (b). Likelihood of speaking English */
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

tab state, generate(dstate)
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 {
	foreach z in 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 ///
	1993 1994 {
gen c_state`z'_`x'=0
replace c_state`z'_`x'=1 if dstate`x'==1 & cohort==`z'
}
}

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
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid eng edu female if paidw==1 & cohort>=1984 & cohort<=1994 [iw=weight], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 6) estore(csdid_Eng)
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

destring state, replace

eventstudyinteract eng L*event F*event if paidw==1 & cohort>=1984 & cohort<=1994 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female state#cohort) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe eng F*event L*event female edu [aw=weight] ///
if cohort>=1984 & cohort<=1994 & paidw==1, absorb(cohort geo state#cohort) vce(cluster geo)
estimates store ols_Eng
matrix ols_b = e(b)
matrix ols_v = e(V_FE)
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* Borusyak, Jaravel, and Spiess (2024) */
*========================================================================*
replace first_cohort=1997 if first_cohort==0

did_imputation eng geo cohort first_cohort if paidw==1 & ///
cohort>=1984 & cohort<=1994 [aw=weight], horizons(0/6) pretrend(6) ///
controls(female edu) cluster(geo) fe(geo cohort state#cohort) autos minn(0)

event_plot, default_look graph_opt(xtitle("Cohorts since policy intervention") ///
ytitle("Weekly hours of English instruction") xlabel(-6(1)6))

estimates store bjs
*========================================================================*
/* All in one. Panel (b) */
*========================================================================*
/*event_plot ols_Eng sa_b#sa_v csdid_Eng dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_All_Eng.png", replace*/

event_plot ols_Eng sa_b#sa_v csdid_Eng dcdh_b#dcdh_v bjs, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_# pre#) ///
    stub_lag(L#event L#event Tp# Effect_# tau#) ///
    together noautolegend perturb(-.20 -0.10 0 0.10 0.20) ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt4(color(ltblue) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(X) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt5(color(ebblue) lwidth(medthick)) 
graph export "$doc\PTA_All_Eng.png", replace

*========================================================================*
/* Panel (c). Likelihood of working for pay */
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

tab state, generate(dstate)
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 {
	foreach z in 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 ///
	1993 1994 {
gen c_state`z'_`x'=0
replace c_state`z'_`x'=1 if dstate`x'==1 & cohort==`z'
}
}

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
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid paidw edu female if cohort>=1984 & cohort<=1994 [iw=weight], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 6) estore(csdid_paid)
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

destring state, replace

eventstudyinteract paidw L*event F*event if cohort>=1984 & cohort<=1994 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female state#cohort) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe paidw F*event L*event female edu [aw=weight] ///
if cohort>=1984 & cohort<=1994, absorb(cohort geo state#cohort) vce(cluster geo)
estimates store ols_paid
matrix ols_b = e(b)
matrix ols_v = e(V_FE)
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* Borusyak, Jaravel, and Spiess (2024) */
*========================================================================*
replace first_cohort=1997 if first_cohort==0

did_imputation paidw geo cohort first_cohort if ///
cohort>=1984 & cohort<=1994 [aw=weight], horizons(0/6) pretrend(6) ///
controls(female edu) cluster(geo) fe(geo cohort state#cohort) autos minn(0)

event_plot, default_look graph_opt(xtitle("Cohorts since policy intervention") ///
ytitle("Likelihood of working for pay") xlabel(-6(1)6))

estimates store bjs
*========================================================================*
/* All in one. Panel (c) */
*========================================================================*
/*event_plot ols_paid sa_b#sa_v csdid_paid dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_All_paid.png", replace
*/
event_plot ols_paid sa_b#sa_v csdid_paid dcdh_b#dcdh_v bjs, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_# pre#) ///
    stub_lag(L#event L#event Tp# Effect_# tau#) ///
    together noautolegend perturb(-.20 -0.10 0 0.10 0.20) ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt4(color(ltblue) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(X) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt5(color(ebblue) lwidth(medthick)) 
graph export "$doc\PTA_All_paid.png", replace
*========================================================================*
/* Panel (d). Log of wages */
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

tab state, generate(dstate)
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 {
	foreach z in 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 ///
	1993 1994 {
gen c_state`z'_`x'=0
replace c_state`z'_`x'=1 if dstate`x'==1 & cohort==`z'
}
}

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
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid lwage edu female if paidw==1 & cohort>=1984 & cohort<=1994 [iw=weight], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 6) estore(csdid_wage)
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

destring state, replace

eventstudyinteract lwage L*event F*event if paidw==1 & cohort>=1984 & cohort<=1994 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female state#cohort) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe lwage F*event L*event female edu [aw=weight] ///
if cohort>=1984 & cohort<=1994 & paidw==1, absorb(cohort geo state#cohort) vce(cluster geo)
estimates store ols_wages
matrix ols_b = e(b)
matrix ols_v = e(V_FE)
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu c_state*)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* All in One */
*========================================================================*
/*event_plot ols_wages sa_b#sa_v csdid_wage dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_All_wages.png", replace
*/
event_plot ols_wages sa_b#sa_v csdid_wage dcdh_b#dcdh_v bjs, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_# pre#) ///
    stub_lag(L#event L#event Tp# Effect_# tau#) ///
    together noautolegend perturb(-.20 -0.10 0 0.10 0.20) ///
	graph_opt( ///
	ylabel(-10(5)10, labs(medium) grid format(%5.1f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt4(color(ltblue) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(X) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt5(color(ebblue) lwidth(medthick)) 
graph export "$doc\PTA_All_wages.png", replace