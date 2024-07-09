*========================================================================*
* English program and earnings
*========================================================================*
* Oscar Galvez-Soriano
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
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Doc"
*========================================================================*
/* FIGURE A.3. Event-study graphs */
*========================================================================*
use "$base\labor_census20.dta", clear
drop if state=="05" | state=="17"
*sum hrs_exp, d
*return list
*gen engl=hrs_exp>=r(p90)

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

drop lwage
gen lwage=log(wage+1)
replace wpaid=. if work==0
gen migra_ret=migrant==1 & conact!=.
replace dmigrant=0 if migrant==1

drop if imputed_state==1
replace time_migra=0 if time_migra==. & migra_ret==1
destring geo, replace

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995) & engl==1
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
/* Panel (a). School enrollment */
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid student edu female migrant if cohort>=1984 & cohort<=1994 & dmigrant==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 6) estore(csdid_stud)
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

eventstudyinteract student L*event F*event if cohort>=1984 & cohort<=1994 & dmigrant==0 [aw=factor], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female migrant) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe student F*event L*event edu female migrant [aw=factor] ///
if cohort>=1984 & cohort<=1994 & dmigrant==0, absorb(cohort geo) vce(cluster geo)
estimates store ols_stud
matrix ols_b = e(b)
matrix ols_v = e(V_FE)
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt student geo cohort had_policy if cohort>=1984 & cohort<=1994 & dmigrant==0, weight(factor) ///
robust_dynamic dynamic(6) placebo(5) breps(50) cluster(geo) ///
controls(edu female migrant)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* All in one. Panel (a) */
*========================================================================*
event_plot ols_stud sa_b#sa_v csdid_stud dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend perturb(-.16 -0.06 0.06 0.16) ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of being enrolled in school", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "TWFE" 4 "Sun-Abraham" 6 "Callaway-Sant'Anna" 8 "de Chaisemartin and D'Haultfoeuille") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_All_stud.png", replace
*========================================================================*
/* Panel (b). Formal job */
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid formal_s edu female migrant if cohort>=1984 & cohort<=1994 & dmigrant==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 6) estore(csdid_formal)
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract formal_s L*event F*event if cohort>=1984 & cohort<=1994 & dmigrant==0 [aw=factor], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female migrant) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe formal_s F*event L*event edu female migrant [aw=factor] ///
if cohort>=1984 & cohort<=1994 & dmigrant==0, absorb(cohort geo) vce(cluster geo)
estimates store ols_formal
matrix ols_b = e(b)
matrix ols_v = e(V_FE)
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt formal_s geo cohort had_policy if cohort>=1984 & cohort<=1994 & dmigrant==0, weight(factor) ///
robust_dynamic dynamic(6) placebo(5) breps(50) cluster(geo) ///
controls(edu female migrant)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* All in one. Panel (b) */
*========================================================================*
event_plot ols_formal sa_b#sa_v csdid_formal dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend perturb(-.16 -0.06 0.06 0.16) ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of having a formal job", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_All_formal.png", replace

*========================================================================*
/* Panel (c). Informal job */
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid informal_s edu female migrant if cohort>=1984 & cohort<=1994 & dmigrant==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 6) estore(csdid_informal)
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract informal_s L*event F*event if cohort>=1984 & cohort<=1994 & dmigrant==0 [aw=factor], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female migrant) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe informal_s F*event L*event edu female migrant [aw=factor] ///
if cohort>=1984 & cohort<=1994 & dmigrant==0, absorb(cohort geo) vce(cluster geo)
estimates store ols_informal
matrix ols_b = e(b)
matrix ols_v = e(V_FE)
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt informal_s geo cohort had_policy if cohort>=1984 & cohort<=1994 & dmigrant==0, weight(factor) ///
robust_dynamic dynamic(6) placebo(5) breps(50) cluster(geo) ///
controls(edu female migrant)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* All in one. Panel (c) */
*========================================================================*
event_plot ols_informal sa_b#sa_v csdid_informal dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend perturb(-.16 -0.06 0.06 0.16) ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of having an informal job", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_All_informal.png", replace

*========================================================================*
/* Panel (d). Inactive */
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid inactive edu female migrant if cohort>=1984 & cohort<=1994 & dmigrant==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 6) estore(csdid_inact)
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract inactive L*event F*event if cohort>=1984 & cohort<=1994 & dmigrant==0 [aw=factor], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female migrant) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe inactive F*event L*event edu female migrant [aw=factor] ///
if cohort>=1984 & cohort<=1994 & dmigrant==0, absorb(cohort geo) vce(cluster geo)
estimates store ols_inact
matrix ols_b = e(b)
matrix ols_v = e(V_FE)
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt inactive geo cohort had_policy if cohort>=1984 & cohort<=1994 & dmigrant==0, weight(factor) ///
robust_dynamic dynamic(6) placebo(5) breps(50) cluster(geo) ///
controls(edu female migrant)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* All in one. Panel (d) */
*========================================================================*
event_plot ols_inact sa_b#sa_v csdid_inact dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend perturb(-.16 -0.06 0.06 0.16) ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of being inactive", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_All_inact.png", replace

*========================================================================*
/* Panel (e). Labor force participation */
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid labor edu female migrant if cohort>=1984 & cohort<=1994 & dmigrant==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 6) estore(csdid_lf)
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract labor L*event F*event if cohort>=1984 & cohort<=1994 & dmigrant==0 [aw=factor], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female migrant) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe labor F*event L*event edu female migrant [aw=factor] ///
if cohort>=1984 & cohort<=1994 & dmigrant==0, absorb(cohort geo) vce(cluster geo)
estimates store ols_lf
matrix ols_b = e(b)
matrix ols_v = e(V_FE)
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt labor geo cohort had_policy if cohort>=1984 & cohort<=1994 & dmigrant==0, weight(factor) ///
robust_dynamic dynamic(6) placebo(5) breps(50) cluster(geo) ///
controls(edu female migrant)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* All in one. Panel (e) */
*========================================================================*
event_plot ols_lf sa_b#sa_v csdid_lf dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend perturb(-.16 -0.06 0.06 0.16) ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of participating in labor force", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_All_lf.png", replace

*========================================================================*
/* Panel (f). Wages */
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid lwage edu female migrant if cohort>=1984 & cohort<=1994 & dmigrant==0 & wpaid==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 6) estore(csdid_wage)
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract lwage L*event F*event if cohort>=1984 & cohort<=1994 & dmigrant==0 & wpaid==1 [aw=factor], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(edu female migrant) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe lwage F*event L*event edu female migrant [aw=factor] ///
if cohort>=1984 & cohort<=1994 & dmigrant==0 & wpaid==1, absorb(cohort geo) vce(cluster geo)
estimates store ols_wage
matrix ols_b = e(b)
matrix ols_v = e(V_FE)
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt lwage geo cohort had_policy if cohort>=1984 & cohort<=1994 & dmigrant==0 & wpaid==1, weight(factor) ///
robust_dynamic dynamic(6) placebo(5) breps(50) cluster(geo) ///
controls(edu female migrant)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* All in one. Panel (f) */
*========================================================================*
event_plot ols_wage sa_b#sa_v csdid_wage dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend perturb(-.16 -0.06 0.06 0.16) ///
	graph_opt( ///
	ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change of wages (if works for pay)", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_All_wage.png", replace

*========================================================================*
/* FIGURE A.4. Event-study graphs */
*========================================================================*
/* Panel (a). Domestic migration */
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid dmigrant female migrant if cohort>=1984 & cohort<=1994 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 6) estore(csdid_dmigrant)
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract dmigrant L*event F*event if cohort>=1984 & cohort<=1994 [aw=factor], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(female migrant) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe dmigrant F*event L*event female migrant [aw=factor] ///
if cohort>=1984 & cohort<=1994, absorb(cohort geo) vce(cluster geo)
estimates store ols_dmigrant
matrix ols_b = e(b)
matrix ols_v = e(V_FE)
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt dmigrant geo cohort had_policy if cohort>=1984 & cohort<=1994, weight(factor) ///
robust_dynamic dynamic(6) placebo(5) breps(50) cluster(geo) ///
controls(female migrant)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* All in one. Panel (a) */
*========================================================================*
event_plot ols_dmigrant sa_b#sa_v csdid_dmigrant dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend perturb(-.16 -0.06 0.06 0.16) ///
	graph_opt( ///
	ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrate domestically", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(order(2 "TWFE" 4 "Sun-Abraham" 6 "Callaway-Sant'Anna" 8 "de Chaisemartin and D'Haultfoeuille") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_All_dmigrant.png", replace

*========================================================================*
/* Panel (b). Likelihood of migrating abroad */
*========================================================================*
clear matrix
clear mata
eststo clear
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid migrant female if cohort>=1984 & cohort<=1994 & dmigrant==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 6) estore(csdid_migrant)
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract migrant L*event F*event if dmigrant==0 & cohort>=1984 & ///
cohort<=1994 [aw=factor], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(female) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe migrant F*event L*event female [aw=factor] ///
if cohort>=1984 & cohort<=1994 & dmigrant==0, absorb(cohort geo) vce(cluster geo)
estimates store ols_migrant
matrix ols_b = e(b)
matrix ols_v = e(V_FE)
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt migrant geo cohort had_policy if dmigrant==0 & ///
cohort>=1984 & cohort<=1994 , weight(factor) ///
robust_dynamic dynamic(6) placebo(5) breps(50) cluster(geo) ///
controls(female)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* All in one. Panel (b) */
*========================================================================*
event_plot ols_migrant sa_b#sa_v csdid_migrant dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend perturb(-.16 -0.06 0.06 0.16) ///
	graph_opt( ///
	ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating abroad", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_All_migrant.png", replace

*========================================================================*
/* Panel (c). Likelihood of returning to Mexico after migration */
*========================================================================*
clear matrix
clear mata
eststo clear
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid migra_ret female if cohort>=1984 & cohort<=1994 & dmigrant==0 & migrant==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 6) estore(csdid_rmigrant)
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract migra_ret L*event F*event if dmigrant==0 & migrant==1 & cohort>=1984 & ///
cohort<=1994 [aw=factor], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(female) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe migra_ret F*event L*event female [aw=factor] ///
if cohort>=1984 & cohort<=1994 & dmigrant==0 & migrant==1, absorb(cohort geo) vce(cluster geo)
estimates store ols_rmigrant
matrix ols_b = e(b)
matrix ols_v = e(V_FE)
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt migra_ret geo cohort had_policy if dmigrant==0 & migrant==1 & ///
cohort>=1984 & cohort<=1994 , weight(factor) ///
robust_dynamic dynamic(6) placebo(2) breps(50) cluster(geo) ///
controls(female)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_1
*========================================================================*
/* All in one. Panel (c) */
*========================================================================*
event_plot ols_rmigrant sa_b#sa_v csdid_rmigrant dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend perturb(-.16 -0.06 0.06 0.16) ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of returning to Mexico after migration", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_All_rmigrant.png", replace

*========================================================================*
/* Panel (d). Likelihood of migrating to the US */
*========================================================================*
clear matrix
clear mata
eststo clear
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid dest_us female if cohort>=1984 & cohort<=1994 & dmigrant==0 & migrant==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 6) estore(csdid_usmigrant)
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract dest_us L*event F*event if dmigrant==0 & migrant==1 & cohort>=1984 & ///
cohort<=1994 [aw=factor], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(female) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe dest_us F*event L*event female [aw=factor] ///
if cohort>=1984 & cohort<=1994 & dmigrant==0 & migrant==1, absorb(cohort geo) vce(cluster geo)
estimates store ols_usmigrant
matrix ols_b = e(b)
matrix ols_v = e(V_FE)
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt dest_us geo cohort had_policy if dmigrant==0 & migrant==1 & ///
cohort>=1984 & cohort<=1994 , weight(factor) ///
robust_dynamic dynamic(6) placebo(2) breps(50) cluster(geo) ///
controls(female)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_1
*========================================================================*
/* All in one. Panel (d) */
*========================================================================*
event_plot ols_usmigrant sa_b#sa_v csdid_usmigrant dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend perturb(-.16 -0.06 0.06 0.16) ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to the US", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_All_USmigrant.png", replace

*========================================================================*
/* Panel (e). Migration length (months) */
*========================================================================*
clear matrix
clear mata
eststo clear
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid time_migra female if cohort>=1984 & cohort<=1994 & dmigrant==0 & migrant==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 6) estore(csdid_tmigrant)
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
eventstudyinteract time_migra L*event F*event if dmigrant==0 & migrant==1 & cohort>=1984 & ///
cohort<=1994 [aw=factor], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(female) ///
vce(cluster geo)

matrix sa_b = e(b_iw)
matrix sa_v = e(V_iw)
*========================================================================*
/* Traditional staggered DiD using OLS */
*========================================================================*
reghdfe time_migra F*event L*event female [aw=factor] ///
if cohort>=1984 & cohort<=1994 & dmigrant==0 & migrant==1, absorb(cohort geo) vce(cluster geo)
estimates store ols_tmigrant
matrix ols_b = e(b)
matrix ols_v = e(V_FE)
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt time_migra geo cohort had_policy if dmigrant==0 & migrant==1 & ///
cohort>=1984 & cohort<=1994 , weight(factor) ///
robust_dynamic dynamic(1) placebo(1) breps(50) cluster(geo) ///
controls(female)

matrix dcdh_b = e(estimates) 
matrix dcdh_v = e(variances)

matrix dcdh_b = dcdh_b \ 0
matrix dcdh_v=dcdh_v \ 0

mat rownames dcdh_b = Effect_0 Effect_1 Average Placebo_2 Placebo_1
mat rownames dcdh_v = Effect_0 Effect_1 Average Placebo_2 Placebo_1
*========================================================================*
/* All in one. Panel (e) */
*========================================================================*
event_plot ols_tmigrant sa_b#sa_v csdid_tmigrant dcdh_b#dcdh_v, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event F#event Tm# Placebo_#) ///
    stub_lag(L#event L#event Tp# Effect_#) ///
    together noautolegend perturb(-.16 -0.06 0.06 0.16) ///
	graph_opt( ///
	ylabel(-30(15)30, labs(medium) grid format(%5.1f)) ///
	ytitle("Migration length (months)", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ebblue) mlcolor(ebblue) mlwidth(thin)) lag_ci_opt4(color(ebblue) lwidth(medthick))
graph export "$doc\PTA_All_Tmigrant.png", replace