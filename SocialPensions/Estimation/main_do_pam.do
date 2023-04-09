*=====================================================================*
* Main do file
*=====================================================================*
set more off
gl base="https://raw.githubusercontent.com/galvez-soriano/Papers/main/SocialPensions/Data"
gl data="C:\Users\ogalvezs\Documents\SocialPensions\Data"
gl doc="C:\Users\ogalvezs\Documents\SocialPensions\Doc"
*=====================================================================*
* Downloading data from my GitHub website
*=====================================================================*
/*use "$base/dbase1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14{
    append using "$base/dbase`x'.dta"
}
save "$data\dbase65.dta", replace*/
*=====================================================================*
/* Table 1: Summary statistics */
*=====================================================================*
*reg dep_var treat if year==(Before or After) & ss_dir==0 [aw=factor], vce(cluster folioviv)
/*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"

reg l_inc treat if year==2014 & ss_dir==0 & cohab==0 [aw=factor], vce(cluster ubica_geo)
reg poor treat if year==2014 & ss_dir==0 & cohab==0 [aw=factor], vce(cluster ubica_geo)
reg epoor treat if year==2014 & ss_dir==0 & cohab==0 [aw=factor], vce(cluster ubica_geo)
reg labor treat if year==2014 & ss_dir==0 & cohab==0 [aw=factor], vce(cluster ubica_geo)
reg hwork treat if year==2014 & ss_dir==0 & cohab==0 [aw=factor], vce(cluster ubica_geo)
reg poor_health treat if year==2014 & ss_dir==0 & cohab==0 [aw=factor], vce(cluster ubica_geo)
reg weight_h treat if year==2014 & ss_dir==0 & cohab==0 [aw=factor], vce(cluster ubica_geo)

reg disabil treat if year==2014 & ss_dir==0 & cohab==0 [aw=factor], vce(cluster ubica_geo)
reg gender treat if year==2014 & ss_dir==0 & cohab==0 [aw=factor], vce(cluster ubica_geo)
reg howner treat if year==2014 & ss_dir==0 & cohab==0 [aw=factor], vce(cluster ubica_geo)
reg hli treat if year==2014 & ss_dir==0 & cohab==0 [aw=factor], vce(cluster ubica_geo)
reg rural treat if year==2014 & ss_dir==0 & cohab==0 [aw=factor], vce(cluster ubica_geo)
reg educ treat if year==2014 & ss_dir==0 & cohab==0 [aw=factor], vce(cluster ubica_geo)
reg tamhogesc treat if year==2014 & ss_dir==0 & cohab==0 [aw=factor], vce(cluster ubica_geo)
reg lremitt treat if year==2014 & ss_dir==0 & cohab==0 [aw=factor], vce(cluster ubica_geo)
reg cohab treat if year==2014 & ss_dir==0 & cohab==0 [aw=factor], vce(cluster ubica_geo) 

tab fbusiness if year==2014 & age>=11 & age<=17
*/
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
/* Main Results (TABLE 2). DiD estimations */
*=====================================================================*
* Dependent variable: Take up tamhogesc
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
* Dependent variable: Income per capita
eststo: areg l_inc after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
* Dependent variable: Poverty. Welfare and minimum welfare lines
eststo: areg poor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
* Dependent variable: Labor
eststo: areg labor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
/* Dependent variable: Health
eststo: areg poor_health after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg weight_h after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
*/
esttab using "$doc\tab2.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab2}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
* Robustness checks: DiD estimations
*=====================================================================*
* Narrowed age groups
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=67
bysort folioviv foliohog: replace treat=0 if age>=63 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat tamhogesc educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
/*eststo: areg poor_health after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg weight_h after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
*/
esttab using "$doc\tab2.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab2}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
* Different control group
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=71 & age<=74
*bysort folioviv foliohog: replace treat=. if tcheck==1 
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
/*eststo: areg poor_health after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg weight_h after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
*/
esttab using "$doc\tab2.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab2}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
/* Including individuals 65 years old */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=65 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
/*eststo: areg poor_health after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg weight_h after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
*/
esttab using "$doc\tab2.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(DiD estimations ///
(\autoref{eq:1})\label{tab2}) keep(after_treat) stats(N ar2, fmt(%9.0fc %9.3f)) replace
*=====================================================================* 
* Figure 2. Parallel trend assumption 2008-2014
*=====================================================================*
* graph set window fontface "Times New Roman"
use "$data\dbase65.dta", clear
replace ubica_geo=substr(ubica_geo,1,5)
* Modify the treatment variable to affect only memeber of all hh.
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"

foreach x in 08 10 12 14{
gen treat_20`x'=0
replace treat_20`x'=1 if treat==1 & year==20`x'
label var treat_20`x' "20`x'"
}
replace treat_2012=0
* Dependent variable: Poverty
areg poor treat_20* treat i.year rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store poverty
areg epoor treat_20* treat i.year rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store xpoverty 

coefplot (poverty, label(Poverty) offset(-.03)) (xpoverty, ciopt(lc(black) ///
recast(rcap)) label(Extreme poverty) offset(.03) m(T) mcolor(white) mlcolor(black)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of living in (extreme) poverty", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.20, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) text(-0.21 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph2.png", replace 
* Dependent variable: Income per capita
areg l_inc treat_20* treat i.year rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of income (/100)", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(-0.525 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph3.png", replace 
* Dependent variable: Labor mkt outcomes
areg labor treat_20* treat i.year rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of belonging to labor force", size(medium) height(5)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.3 0.3)) text(-0.315 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph4.png", replace

areg hwork treat_20* treat i.year rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Number of hours worked", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(-10.55 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph5.png", replace 
* Dependent variable: Health   
eststo clear
areg poor_health treat_20* i.year treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store phealth
areg weight_h treat_20* i.year treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store weight

coefplot (phealth, label(Sickness) offset(-.03)) (weight, ciopt(lc(black) ///
recast(rcap)) label(Visit to health center) offset(.03) m(T) mcolor(white) mlcolor(black)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of the outcome", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.20, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) text(-0.21 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph6.png", replace 
*=====================================================================*
/* Figure A.4. PAM effect on younger labor supply */
*=====================================================================*
use "$data\dbase65.dta", clear
* Modify the treatment variable to affect only memeber of all hh.
foreach x in 08 10 12 14{
gen treat_20`x'=0
replace treat_20`x'=1 if treat_hh==1 & year==20`x'
label var treat_20`x' "20`x'"
}
replace treat_2012=0
rename tcheck cohab
replace labor=0 if hwork==.
gen ages=.
replace ages=1 if age>=6 & age<=10
replace ages=2 if age>=11 & age<=17
replace ages=3 if age>=18 & age<=54
replace ages=4 if age>=55

/*merge m:m folioviv foliohog numren using "$data\fbusiness.dta"
keep if _merge==3
drop _merge
tab fbusiness if treat_2014==1 & age>=11 & age<=17 & labor==1 */
* Dependent variable: Labor force participation
/* Women */
eststo clear
eststo: areg labor treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==2 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw1
eststo: areg labor treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==3 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw2
/* Men */
eststo: areg labor treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==2 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw3
eststo: areg labor treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==3 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw4

coefplot (labw1, label(Girls (11-17)) offset(-.09) msym(D) mcolor(gs13) ciopts(recast(rcap) color(gs13))) /// 
(labw3, label(Boys (11-17)) offset(-.03) msym(S) mcolor(gs11) ciopts(recast(rcap) color(gs11))) ///
(labw2, label(Prime-age adult (women, 18-54)) offset(0.03) msym(Dh) mcolor(gs8) ciopts(recast(rcap) color(gs8))) ///
(labw4, label(Prime-age adult (men, 18-54)) offset(0.09) msym(Sh) mcolor(gs3) ciopts(recast(rcap) color(gs3))), ///
vertical keep(treat_20*) yline(0, lcolor(black)) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of belonging to labor force", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.50, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white))) ///
graphregion(color(white)) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(-0.53 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph7.png", replace

* Dependent variable: Labor supply
/* Women */
eststo clear
eststo: areg hwork treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==2 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw1
eststo: areg hwork treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==3 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw2
/* Men */
eststo: areg hwork treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==2 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw3
eststo: areg hwork treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==3 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw4

coefplot (labw1, label(Young women (11-17)) offset(-.09) msym(D) mcolor(gs13) ciopts(recast(rcap) color(gs13))) /// 
(labw3, label(Young men (11-17)) offset(-.03) msym(S) mcolor(gs11) ciopts(recast(rcap) color(gs11))) ///
(labw2, label(Prime-age adult (women, 18-54)) offset(0.03) msym(Dh) mcolor(gs8) ciopts(recast(rcap) color(gs8))) ///
(labw4, label(Prime-age adult (men, 18-54)) offset(0.09) msym(Sh) mcolor(gs3) ciopts(recast(rcap) color(gs3))), ///
vertical keep(treat_20*) yline(0, lcolor(black)) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Number of hours worked", size(medium) height(5)) ///
ylabel(-20(10)20, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-20 20)) text(-21 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph8.png", replace

/* Indigenous */
* Dependent variable: Labor force participation
eststo clear
eststo: areg labor treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==2 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw1
eststo: areg labor treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==3 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw2

coefplot (labw1, label(Adolescents (11-17)) offset(-.03)) ///
(labw2, label(Prime-age adults (18-54)) offset(0.03) ciopt(lc(black) recast(rcap)) ///
m(T) mcolor(white) mlcolor(black)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of belong to labor force", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white))) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(-1.05 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph9.png", replace  

* Dependent variable: Labor supply
eststo clear
eststo: areg hwork treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==2 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw1
eststo: areg hwork treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==3 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw2

coefplot (labw1, label(Young individuals (11-17)) offset(-.03)) ///
(labw2, label(Prime-age adults (18-54)) offset(0.03) ciopt(lc(black) recast(rcap)) ///
m(T) mcolor(white) mlcolor(black)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Number of hours worked", size(medium) height(5)) ///
ylabel(-60(30)60, labs(medium) grid format(%5.0f)) ///
legend(off) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-60 60)) text(-63 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph10.png", replace
*=====================================================================*
/* TABLE 3.
Heterogenous effects: DiD estimations */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
/* Women and men */
*Women
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
/*eststo: areg poor_health after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg weight_h after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)*/
esttab using "$doc\table_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
title(Women) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*Men
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
/*eststo: areg poor_health after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg weight_h after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)*/
esttab using "$doc\table_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
title(Women) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*Gender differential effect
gen inter_fem=after_treat*gender
gen after_fem=after*gender
gen treat_fem=treat*gender

eststo clear
eststo: areg pam inter_fem after_fem treat_fem after_treat after treat educ ///
gender hli i.age cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc inter_fem after_fem treat_fem after_treat after treat educ ///
gender hli i.age cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor inter_fem after_fem treat_fem after_treat after treat educ ///
gender hli i.age cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor inter_fem after_fem treat_fem after_treat after treat educ ///
gender hli i.age cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor inter_fem after_fem treat_fem after_treat after treat educ ///
gender hli i.age cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork inter_fem after_fem treat_fem after_treat after treat educ ///
gender hli i.age cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
esttab using "$doc\table_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(inter_fem) replace
*=====================================================================*
/* Indigenous */
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
/*eststo: areg poor_health after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg weight_h after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)*/
esttab using "$doc\table_ind.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
title(Indigenous) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
/* Non-Indigenous */
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
/*eststo: areg poor_health after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg weight_h after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster ubica_geo)*/
esttab using "$doc\table_non_ind.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
title(Non-Indigenous) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*Ethnicity differential effect
gen inter_hli=after_treat*hli
gen after_hli=after*hli
gen treat_hli=treat*hli

eststo clear
eststo: areg pam inter_hli after_hli treat_hli after_treat after treat educ ///
gender hli i.age cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc inter_hli after_hli treat_hli after_treat after treat educ ///
gender hli i.age cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor inter_hli after_hli treat_hli after_treat after treat educ ///
gender hli i.age cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor inter_hli after_hli treat_hli after_treat after treat educ ///
gender hli i.age cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor inter_hli after_hli treat_hli after_treat after treat educ ///
gender hli i.age cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork inter_hli after_hli treat_hli after_treat after treat educ ///
gender hli i.age cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
esttab using "$doc\table_ethnic.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(inter_hli) replace
*=====================================================================*
/* Rural v Urban: 
tam_loc=1: inhabitants>=100,000
tam_loc=2: 15,000<=inhabitants<=99,999
tam_loc=3: 2,500<=inhabitants<=14,999
tam_loc=4: inhabitants<2,500 */
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==4 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==4 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==4 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==4 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==4 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==4 [aw=factor], absorb(state) vce(cluster ubica_geo)
/*eststo: areg poor_health after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & tam_loc==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg weight_h after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & tam_loc==1 [aw=factor], absorb(state) vce(cluster ubica_geo)*/
esttab using "$doc\tab3.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab3}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*Differential effects by locality size
gen rur_surb=tam_loc==3
replace rur_surb=. if tam_loc<=2
gen rur_murb=tam_loc==2
replace rur_murb=. if tam_loc==1 | tam_loc==3
gen rur_burb=tam_loc==1
replace rur_burb=. if tam_loc==2 | tam_loc==3

gen inter_rur=after_treat*rur_surb
gen after_rur=after*rur_surb
gen treat_rur=treat*rur_surb

eststo clear
eststo: areg pam inter_rur after_rur treat_rur rur_surb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc inter_rur after_rur treat_rur rur_surb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor inter_rur after_rur treat_rur rur_surb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor inter_rur after_rur treat_rur rur_surb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor inter_rur after_rur treat_rur rur_surb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork inter_rur after_rur treat_rur rur_surb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
esttab using "$doc\tab3.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(inter_rur) replace

replace inter_rur=after_treat*rur_murb
replace after_rur=after*rur_murb
replace treat_rur=treat*rur_murb

eststo clear
eststo: areg pam inter_rur after_rur treat_rur rur_murb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc inter_rur after_rur treat_rur rur_murb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor inter_rur after_rur treat_rur rur_murb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor inter_rur after_rur treat_rur rur_murb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor inter_rur after_rur treat_rur rur_murb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork inter_rur after_rur treat_rur rur_murb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
esttab using "$doc\tab3.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(inter_rur) replace

replace inter_rur=after_treat*rur_burb
replace after_rur=after*rur_burb
replace treat_rur=treat*rur_burb

eststo clear
eststo: areg pam inter_rur after_rur treat_rur rur_burb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc inter_rur after_rur treat_rur rur_burb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor inter_rur after_rur treat_rur rur_burb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor inter_rur after_rur treat_rur rur_burb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor inter_rur after_rur treat_rur rur_burb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork inter_rur after_rur treat_rur rur_burb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
esttab using "$doc\tab3.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(inter_rur) replace

gen urb_murb=tam_loc==2
replace urb_murb=. if tam_loc==4 | tam_loc==1
gen urb_burb=tam_loc==1
replace urb_burb=. if tam_loc==4 | tam_loc==2

gen inter_urb=after_treat*urb_murb
gen after_urb=after*urb_murb
gen treat_urb=treat*urb_murb

eststo clear
eststo: areg pam inter_urb after_urb treat_urb urb_murb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc inter_urb after_urb treat_urb urb_murb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor inter_urb after_urb treat_urb urb_murb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor inter_urb after_urb treat_urb urb_murb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor inter_urb after_urb treat_urb urb_murb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork inter_urb after_urb treat_urb urb_murb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
esttab using "$doc\tab3.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(inter_urb) replace

replace inter_urb=after_treat*urb_burb
replace after_urb=after*urb_burb
replace treat_urb=treat*urb_burb

eststo clear
eststo: areg pam inter_urb after_urb treat_urb urb_burb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc inter_urb after_urb treat_urb urb_burb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor inter_urb after_urb treat_urb urb_burb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor inter_urb after_urb treat_urb urb_burb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor inter_urb after_urb treat_urb urb_burb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork inter_urb after_urb treat_urb urb_burb after_treat after treat educ ///
gender hli i.age cohab if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
esttab using "$doc\tab3.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(inter_urb) replace
*=====================================================================*
/* TABLE 5.
IV Estimation. LATE*/
*=====================================================================* 
use "$data\dbase65.dta", clear

keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"

/* Structural Equation */
eststo clear
eststo: areg poor pam after treat rural educ gender hli cohab ///
i.age i.tam_loc if ss_dir==0 & after_treat!=. [aw=factor], ///
absorb(state) vce(cluster ubica_geo)
/* First Stage Equation */
eststo: areg pam after_treat after treat rural educ gender hli cohab ///
i.age i.tam_loc if ss_dir==0 [aw=factor], ///
absorb(state) vce(cluster ubica_geo)
/* Reduced Form Equation */
eststo: areg poor after_treat after treat rural educ gender hli cohab ///
i.age i.tam_loc if ss_dir==0 & pam!=. [aw=factor], ///
absorb(state) vce(cluster ubica_geo)
/* IV estimation */
eststo: ivregress 2sls poor (pam=after_treat) after treat rural educ gender hli cohab ///
i.state i.age i.tam_loc if ss_dir==0 [aw=factor], vce(cluster ubica_geo)
esttab using "$doc\tab5.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(IV ///
\label{tab5}) keep(pam after_treat) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace
/*ivreg2 poor (pam=after_treat) after treat rural educ gender hli cohab ///
i.state i.age i.tam_loc if ss_dir==0 [aw=factor], robust*/

/* Structural Equation */
eststo clear
eststo: areg epoor pam after treat rural educ gender hli cohab ///
i.age i.tam_loc if ss_dir==0 & after_treat!=. [aw=factor], ///
absorb(state) vce(cluster ubica_geo)
/* First Stage Equation */
eststo: areg pam after_treat after treat rural educ gender hli cohab ///
i.age i.tam_loc if ss_dir==0 [aw=factor], ///
absorb(state) vce(cluster ubica_geo)
/* Reduced Form Equation */
eststo: areg epoor after_treat after treat rural educ gender hli cohab ///
i.age i.tam_loc if ss_dir==0 & pam!=. [aw=factor], ///
absorb(state) vce(cluster ubica_geo)
/* IV estimation */
eststo: ivregress 2sls epoor (pam=after_treat) after treat rural educ gender hli cohab ///
i.state i.age i.tam_loc if ss_dir==0 [aw=factor], vce(cluster ubica_geo)
esttab using "$doc\tab5.tex", cells(b(star fmt(%9.3f)) se(par)) title(IV ///
\label{tab5}) keep(pam after_treat) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace
/*ivreg2 epoor (pam=after_treat) after treat rural educ gender hli cohab ///
i.state i.age i.tam_loc if ss_dir==0 [aw=factor], robust*/
*=====================================================================*
/* Cummulative income functions */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen ictpc_pam=ictpc-ing_65mas
label var ictpc_pam "Income excluding PAM"

drop if ictpc>1000000
gen lictpc=log(ictpc) if pam==1 & year==2014
gen lictpc_pam=log(ictpc_pam) if pam==1 & year==2014
/*
/* All rural */
cumul lictpc [fw=factor] if rural==1, gen(income)
cumul lictpc_pam [fw=factor] if rural==1, gen(inc_pam)
sort folioviv foliohog
set obs 440050
replace year = 2014 in 440050
replace income = 0 in 440050
replace inc_pam = 0 in 440050
replace ictpc_pam = 0 in 440050
replace lictpc = 0 in 440050
replace rural = 1 in 440050
replace gender = 0 in 440050
twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11), sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11), sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ///
legend(order(1 "Income excluding PAM" 2 "Total Income" ) pos(10) ring(0) col(1)) ///
xline(7.38, lstyle(grid) lpattern(dash_dot) lcolor(midgreen)) ///
text(1.08 7.1 "PL", color(midgreen) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(6.76, lstyle(grid) lpattern(shortdash) lcolor(midgreen)) ///
text(.68 4.1 "Food-based PL", color(midgreen) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph_distA.png", replace
/* All urban */
drop income inc_pam
cumul lictpc [fw=factor] if rural==0, gen(income)
cumul lictpc_pam [fw=factor] if rural==0, gen(inc_pam)
sort folioviv foliohog
replace lictpc = 0 in 1
replace lictpc_pam = 0 in 1
replace income = 0 in 1
replace inc_pam = 0 in 1
replace hli = 1 in 1
replace rural = 0 in 1
twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11), sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11), sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ///
legend(order(1 "Income excluding PAM" 2 "Total Income" ) pos(10) ring(0) col(1)) ///
xline(7.84, lstyle(grid) lpattern(dash_dot) lcolor(blue)) ///
text(1.08 7.6 "PL", color(blue) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(7.12, lstyle(grid) lpattern(shortdash) lcolor(blue)) ///
text(.68 4.4 "Food-based PL", color(blue) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph_distB.png", replace
*/
/* Men rural */
cumul lictpc [fw=factor] if gender==0 & rural==1, gen(income)
cumul lictpc_pam [fw=factor] if gender==0 & rural==1, gen(inc_pam)

sort folioviv foliohog
set obs 440050
replace year = 2014 in 440050
replace income = 0 in 440050
replace inc_pam = 0 in 440050
replace ictpc_pam = 0 in 440050
replace lictpc = 0 in 440050
replace rural = 1 in 440050
replace gender = 0 in 440050

twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11) & gender==0, sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11) & gender==0, sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ///
legend(order(1 "Income excluding PAM" 2 "Total Income" ) pos(10) ring(0) ///
col(1) region(lcolor(white))) ///
xline(7.38, lstyle(grid) lpattern(dash_dot) lcolor(gs8)) ///
text(1.08 7.1 "PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(6.76, lstyle(grid) lpattern(shortdash) lcolor(gs8)) ///
text(.68 4.1 "Food-based PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph_dist_men_r.png", replace 

/* Men urban */
drop income inc_pam
cumul lictpc [fw=factor] if gender==0 & rural==0, gen(income)
cumul lictpc_pam [fw=factor] if gender==0 & rural==0, gen(inc_pam)
sort folioviv foliohog
replace lictpc = 0 in 1
replace lictpc_pam = 0 in 1
replace income = 0 in 1
replace inc_pam = 0 in 1
replace hli = 1 in 1
replace rural = 0 in 1

twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11) & gender==0, sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11) & gender==0, sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium) ) ///
graphregion(color(white)) scheme(s2mono) ///
legend(off) ///
xline(7.84, lstyle(grid) lpattern(dash_dot) lcolor(gs8)) ///
text(1.08 7.6 "PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(7.12, lstyle(grid) lpattern(shortdash) lcolor(gs8)) ///
text(0.68 4.4 "Food-based PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph_dist_men_u.png", replace 

/* Women rural */
drop income inc_pam
cumul lictpc [fw=factor] if gender==1 & rural==1, gen(income)
cumul lictpc_pam [fw=factor] if gender==1 & rural==1, gen(inc_pam)
sort folioviv foliohog
replace income = 0 in 1
replace inc_pam = 0 in 1
replace lictpc = 0 in 1
replace lictpc_pam = 0 in 1
replace gender = 1 in 1
replace rural = 1 in 1

twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11) & gender==1, sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11) & gender==1, sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ///
legend(off) ///
xline(7.38, lstyle(grid) lpattern(dash_dot) lcolor(gs8)) ///
text(1.08 7.1 "PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(6.76, lstyle(grid) lpattern(shortdash) lcolor(gs8)) ///
text(.68 4.1 "Food-based PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph_dist_women_r.png", replace 

/* Women urban */
drop income inc_pam
cumul lictpc [fw=factor] if gender==1 & rural==0, gen(income)
cumul lictpc_pam [fw=factor] if gender==1 & rural==0, gen(inc_pam)
sort folioviv foliohog
replace income = 0 in 1
replace inc_pam = 0 in 1
replace ictpc_pam = 0 in 1
replace lictpc = 0 in 1
replace lictpc_pam = 0 in 1
replace rural = 0 in 1

twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11) & gender==1, sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11) & gender==1, sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium) ) ///
graphregion(color(white)) scheme(s2mono) ///
legend(off) ///
xline(7.84, lstyle(grid) lpattern(dash_dot) lcolor(gs8)) ///
text(1.08 7.6 "PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(7.12, lstyle(grid) lpattern(shortdash) lcolor(gs8)) ///
text(0.68 4.4 "Food-based PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph_dist_women_u.png", replace 

/* Indigenous rural */
drop income inc_pam
cumul lictpc [fw=factor] if hli==1 & rural==1, gen(income)
cumul lictpc_pam [fw=factor] if hli==1 & rural==1, gen(inc_pam)
sort folioviv foliohog
replace income = 0 in 1
replace inc_pam = 0 in 1
replace lictpc = 0 in 1
replace lictpc_pam = 0 in 1
replace gender = 1 in 1
replace rural = 1 in 1

twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11) & hli==1, sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11) & hli==1, sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ///
legend(off) ///
xline(7.38, lstyle(grid) lpattern(dash_dot) lcolor(gs8)) ///
text(1.08 7.1 "PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(6.76, lstyle(grid) lpattern(shortdash) lcolor(gs8)) ///
text(.68 4.1 "Food-based PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph_dist_ind_r.png", replace 

/* Indigenous urban */
drop income inc_pam
cumul lictpc [fw=factor] if hli==1 & rural==0, gen(income)
cumul lictpc_pam [fw=factor] if hli==1 & rural==0, gen(inc_pam)
sort folioviv foliohog
replace income = 0 in 1
replace inc_pam = 0 in 1
replace ictpc_pam = 0 in 1
replace lictpc = 0 in 1
replace lictpc_pam = 0 in 1
replace rural = 0 in 1

twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11) & hli==1, sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11) & hli==1, sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium) ) ///
graphregion(color(white)) scheme(s2mono) ///
legend(off) ///
xline(7.84, lstyle(grid) lpattern(dash_dot) lcolor(gs8)) ///
text(1.08 7.6 "PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(7.12, lstyle(grid) lpattern(shortdash) lcolor(gs8)) ///
text(0.68 4.4 "Food-based PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph_dist_ind_u.png", replace

/************ Hypothesized cash transfer ************/
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
drop if ss_dir!=0
gen ictpc_pam=ictpc-ing_65mas
label var ictpc_pam "Income excluding PAM"
gen income_hip=ictpc
replace income_hip=ictpc+580 if treat_hh==1 & pam!=1
label var income_hip "Income with PAM (full compliance)"

drop if ictpc>1000000
gen lictpc=log(ictpc) if treat==1 & year==2014
gen lictpc_pam=log(ictpc_pam) if treat==1 & year==2014
gen lictpc_hip=log(income_hip) if treat==1 & year==2014

/*** Rural ***/
cumul lictpc [fw=factor] if rural==1, gen(income)
cumul lictpc_pam [fw=factor] if rural==1, gen(inc_pam)
cumul lictpc_hip [fw=factor] if rural==1, gen(inc_hip)

sort folioviv foliohog
set obs 440050
replace year = 2014 in 440050
replace income = 0 in 440050
replace inc_pam = 0 in 440050
replace ictpc_pam = 0 in 440050
replace income_hip = 0 in 440050
replace lictpc = 0 in 440050
replace rural = 1 in 440050

twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11), sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11), sort || line inc_hip ///
lictpc_hip if (lictpc>=0 & lictpc<=11), sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ///
legend(order(1 "Income excluding PAM" 2 "Total Income" 3 "Hypothesized Income with PAM") ///
pos(10) ring(0) col(1) region(lcolor(white))) ///
xline(7.38, lstyle(grid) lpattern(dash_dot) lcolor(gs8)) ///
text(1.08 7.1 "PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(6.76, lstyle(grid) lpattern(shortdash) lcolor(gs8)) ///
text(.68 4.1 "Food-based PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph_dist_r.png", replace 

/*** Urban ***/
drop income inc_pam inc_hip
cumul lictpc [fw=factor] if rural==0, gen(income)
cumul lictpc_pam [fw=factor] if rural==0, gen(inc_pam)
cumul lictpc_hip [fw=factor] if rural==0, gen(inc_hip)
sort folioviv foliohog
replace lictpc = 0 in 1
replace lictpc_pam = 0 in 1
replace income = 0 in 1
replace inc_pam = 0 in 1
replace hli = 1 in 1
replace rural = 0 in 1

twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11), sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11), sort || line inc_hip ///
lictpc_hip if (lictpc>=0 & lictpc<=11), sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium) ) ///
graphregion(color(white)) scheme(s2mono) ///
legend(off) ///
xline(7.84, lstyle(grid) lpattern(dash_dot) lcolor(gs8)) ///
text(1.08 7.6 "PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(7.12, lstyle(grid) lpattern(shortdash) lcolor(gs8)) ///
text(0.68 4.4 "Food-based PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph_dist_u.png", replace
*=====================================================================* 
/* TABLE 4.
Social pensions and labor market outcomes (subordinate and self-employment) */
*=====================================================================* 
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================* 
/* Self-employment */
gen selfemp=indep==1
*Full sample
eststo clear
eststo: areg selfemp after_treat after treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
*Men
eststo: areg selfemp after_treat after treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
*Women
eststo: areg selfemp after_treat after treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
*Indigenous
eststo: areg selfemp after_treat after treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
esttab using "$doc\tab_self.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
title(Paid full) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) /// 
label replace keep(after_treat)
*=====================================================================* 
/* Anticipation effects */
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=63 & age<=64
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=62
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"

* Full sample
eststo clear
eststo: areg labor after_treat after treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
*Men
eststo: areg labor after_treat after treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
* Women
eststo: areg labor after_treat after treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
* Indigenous
eststo: areg labor after_treat after treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
esttab using "$doc\tab_anticip.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
title(DiD estimations\label{tab3}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
/* End of do file */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
/* Main Results (TABLE 1). DiD estimations */
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 & cohab!=1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 & cohab!=1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 & cohab!=1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 & cohab!=1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 & cohab!=1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 & cohab!=1 [aw=factor], absorb(state) vce(cluster ubica_geo)
esttab using "$doc\tab1.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab3}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
* Robustness checks: DiD estimations
*=====================================================================*
* Narrowed age groups
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=67
bysort folioviv foliohog: replace treat=0 if age>=63 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat tamhogesc educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
/*eststo: areg poor_health after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg weight_h after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
*/
esttab using "$doc\tab1.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab3}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
* Different control group
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=71 & age<=74
*bysort folioviv foliohog: replace treat=. if tcheck==1 
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
/*eststo: areg poor_health after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg weight_h after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
*/
esttab using "$doc\tab1.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab3}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
/* Including individuals 65 years old */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=65 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
/*eststo: areg poor_health after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg weight_h after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
*/
esttab using "$doc\tab1.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(DiD estimations ///
(\autoref{eq:1})\label{tab1}) keep(after_treat) stats(N ar2, fmt(%9.0fc %9.3f)) replace
*=====================================================================* 
* Parallel trend assumption 2008-2014
*=====================================================================*
* graph set window fontface "Times New Roman"
use "$data\dbase65.dta", clear
replace ubica_geo=substr(ubica_geo,1,5)
* Modify the treatment variable to affect only memeber of all hh.
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"

foreach x in 08 10 12 14{
gen treat_20`x'=0
replace treat_20`x'=1 if treat==1 & year==20`x'
label var treat_20`x' "20`x'"
}
replace treat_2012=0
* Dependent variable: Poverty
areg poor treat_20* treat i.year rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store poverty
areg epoor treat_20* treat i.year rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store xpoverty 

coefplot (poverty, label(Poverty) offset(-.03)) (xpoverty, ciopt(lc(black) ///
recast(rcap)) label(Extreme poverty) offset(.03) m(T) mcolor(white) mlcolor(black)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of living in (extreme) poverty", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.20, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) text(-0.21 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph2.png", replace 
* Dependent variable: Income per capita
areg l_inc treat_20* treat i.year rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of income (/100)", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(-0.525 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph3.png", replace 
* Dependent variable: Labor mkt outcomes
areg labor treat_20* treat i.year rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of belonging to labor force", size(medium) height(5)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.3 0.3)) text(-0.315 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph4.png", replace

areg hwork treat_20* treat i.year rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Number of hours worked", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(-10.55 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph5.png", replace 
* Dependent variable: Health   
eststo clear
areg poor_health treat_20* i.year treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store phealth
areg weight_h treat_20* i.year treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store weight

coefplot (phealth, label(Sickness) offset(-.03)) (weight, ciopt(lc(black) ///
recast(rcap)) label(Visit to health center) offset(.03) m(T) mcolor(white) mlcolor(black)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of the outcome", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.20, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) text(-0.21 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph6.png", replace
*=====================================================================*
* Tabulates by locality size	
*=====================================================================*
/* tam_loc>2 for localities<15,000; tam_loc==2 for 15,000<localities<100,000; 
tam_loc>1 for localities<100,000; and tam_loc==1 localities>100,000 */
*=====================================================================*
use "$data\dbase65.dta", clear

tabstat pam [fw=factor] if year==2008, stats(mean) by(tam_loc)
tabstat pam [fw=factor] if year==2010, stats(mean) by(tam_loc)
tabstat pam [fw=factor] if year==2012, stats(mean) by(tam_loc)
tabstat pam [fw=factor] if year==2014, stats(mean) by(tam_loc)

tabstat ing_65mas [fw=factor] if year==2008 & pam==1, stats(mean) by(tam_loc)
tabstat ing_65mas [fw=factor] if year==2010 & pam==1, stats(mean) by(tam_loc)
tabstat ing_65mas [fw=factor] if year==2012 & pam==1, stats(mean) by(tam_loc)
tabstat ing_65mas [fw=factor] if year==2014 & pam==1, stats(mean) by(tam_loc)

tabstat pam [fw=factor] if year==2008 & state!=9, stats(mean) by(tam_loc)
tabstat pam [fw=factor] if year==2010 & state!=9, stats(mean) by(tam_loc)
tabstat pam [fw=factor] if year==2012 & state!=9, stats(mean) by(tam_loc)
tabstat pam [fw=factor] if year==2014 & state!=9, stats(mean) by(tam_loc)

tabstat ing_65mas [fw=factor] if year==2008 & pam==1 & state!=9, stats(mean) by(tam_loc)
tabstat ing_65mas [fw=factor] if year==2010 & pam==1 & state!=9, stats(mean) by(tam_loc)
tabstat ing_65mas [fw=factor] if year==2012 & pam==1 & state!=9, stats(mean) by(tam_loc)
tabstat ing_65mas [fw=factor] if year==2014 & pam==1 & state!=9, stats(mean) by(tam_loc)
