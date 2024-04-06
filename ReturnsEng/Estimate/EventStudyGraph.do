*========================================================================*
/* English skills and labor market outcomes in Mexico */
*========================================================================*
/* Author: Oscar Galvez-Soriano */
*========================================================================*
/* Before running my do file, you may need to install the following 
packages 

ssc install catplot, replace
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
grstyle init
grstyle set plain, horizontal

*/
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/ReturnsEng/Data"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\ReturnsEng\Data"
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
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23{
gen educ`x'=edu==`x'
}
/*
tab state, generate(dstate)
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 {
	foreach z in 1981 1982 1983 1984 1985 1986 1987 1988 1989 1990 1991 1992 ///
	1993 1994 1995 1996 {
gen c_state`z'_`x'=0
replace c_state`z'_`x'=1 if dstate`x'==1 & cohort==`z'
}
}
*/
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
/* Traditional staggered DiD using OLS */
*========================================================================*
bysort geo cohort: gen treat2 = cohort == (first_cohort - 8)
bysort geo cohort: gen treat3 = cohort == (first_cohort - 7)
bysort geo cohort: gen treat4 = cohort == (first_cohort - 6)
bysort geo cohort: gen treat5 = cohort == (first_cohort - 5)
bysort geo cohort: gen treat6 = cohort == (first_cohort - 4)
bysort geo cohort: gen treat7 = cohort == (first_cohort - 3)
bysort geo cohort: gen treat8 = cohort == (first_cohort - 2)
bysort geo cohort: gen treat9 = cohort == (first_cohort - 1)
bysort geo cohort: gen treat10 = cohort == first_cohort
bysort geo cohort: gen treat11 = cohort == (first_cohort + 1)
bysort geo cohort: gen treat12 = cohort == (first_cohort + 2)
bysort geo cohort: gen treat13 = cohort == (first_cohort + 3)
bysort geo cohort: gen treat14 = cohort == (first_cohort + 4)
bysort geo cohort: gen treat15 = cohort == (first_cohort + 5)
bysort geo cohort: gen treat16 = cohort == (first_cohort + 6)
bysort geo cohort: gen treat17 = cohort == (first_cohort + 7)
bysort geo cohort: gen treat18 = cohort == (first_cohort + 8)

replace treat9=0

label var treat2 "-8"
label var treat3 "-7"
label var treat4 "-6"
label var treat5 "-5"
label var treat6 "-4"
label var treat7 "-3"
label var treat8 "-2"
label var treat9 "-1"
foreach x in 0 1 2 3 4 5 6 7 8 {
	label var treat1`x' "`x'"
}

drop treat2 treat3
destring state, replace

areg paidw treat* i.cohort i.edu female indigenous married state#cohort ///
[aw=weight] if cohort>=1981 & cohort<=1996 , absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Percentage change of wages", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) recast(connected)
graph export "$doc\PTA_OLSdid.png", replace
*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
csdid lwage edu female indigenous married educ* c_state* if paidw==1 [iw=weight], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 8) estore(lwage)

coefplot lwage, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Percentage change in wages", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CSdid.png", replace
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
gen tgroup=first_cohort
replace tgroup=. if state!=1 & state!=10 & state!=19 & state!=25 ///
& state!=26 & state!=28
gen cgroup=tgroup==.

gen K = cohort-first_cohort

sum first_cohort
gen lastcohort = first_cohort==r(max) // dummy for the latest- or never-treated cohort
forvalues l = 0/8 {
	gen L`l'event = K==`l'
}
forvalues l = 1/6 {
	gen F`l'event = K==-`l'
}
drop F1event // normalize K=-1 (and also K=-15) to zero

eventstudyinteract lwage L*event F*event if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married state#cohort) ///
vce(cluster geo)

event_plot e(b_iw)#e(V_iw), plottype(scatter) ciplottype(rspike) ///
graph_opt(xtitle("Cohorts since policy intervention") ///
yline(0, lp(solid) lc(black)) ///
xline(-0.5, lc(ltblue)) ///
ytitle("Percentage change in wages") xlabel(-6(1)8)) ///
stub_lag(L#event) stub_lead(F#event) 
graph export "$doc\PTA_SAdid.png", replace
*========================================================================*
/* de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female indigenous married educ*)
graph export "$doc\PTA_CDdid.png", replace


*========================================================================*
/* Wooldridge (2021) */
*========================================================================*



*========================================================================*
/* Borusyak, Jaravel, and Spiess (2023) */
*========================================================================*


