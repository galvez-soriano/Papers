*========================================================================*
* English instruction in Mexico and labor market outcomes in the US
*========================================================================*
* Oscar Galvez-Soriano, Maria Padilla, and Camila Morales
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\ogalvez\OneDrive - The University of Chicago\Documents\Papers\IPUMS\Data"
gl doc= "C:\Users\ogalvez\OneDrive - The University of Chicago\Documents\Papers\IPUMS\Doc"

graph set window fontface "Times New Roman"
*========================================================================*
use "$base\ACS22_24.dta", clear
rename birthyr cohort
*Potentially affected cohorts 
keep if cohort>=1995 & cohort<=2010

*All Hispanic
keep if hispan!=0

/* Assign the treatment to individuals who were born in Mexico */
gen treat=bpld==20000 

gen after=cohort>=2000
gen after_treat=after*treat

/* Indicator for individuals who self-report that they speak English well,
very well or they only speak English */ 
gen eng=speakeng>=3 & speakeng<=5
replace eng=0 if speakeng==6

replace inctot=. if inctot==9999999 | inctot==9999998
replace incwage=. if incwage==999999 | incwage==999998

gen lincome=asinh(inctot)
gen lwage=asinh(incwage)
gen work=empstat==1
gen white=race==1
recode labforce (0=.) (1=0) (2=1)
recode sex (2=0)

foreach x in 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 ///
2006 2007 2008 2009 2010 {
gen treat_`x'=0
replace treat_`x'=1 if treat==1 & cohort==`x'
replace treat_`x'=. if treat==.
label var treat_`x' "`x'"
}
replace treat_1999=0

*What we have
reghdfe eng treat_* [aw=perwt] if ((yrimmig>=2009 & bpld==20000) | bpld!=20000) , absorb(bpld cohort year) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) 

*What we have // remove the year of migration restriction 
reghdfe eng treat_* [aw=perwt]  , absorb(bpld cohort year) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) 

*remove the year of migration restriction // control for years in the USA 
reghdfe eng treat_* [aw=perwt]  , absorb(bpld cohort year yrsusa1) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) 


*remove the year of migration restriction // control for years in the USA // only immigrants after 2008
reghdfe eng treat_* [aw=perwt] if yrimmig>2008 , absorb(bpld cohort year yrsusa1) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) 

*remove the year of migration restriction // control for years in the USA // only immigrants after 2008
gen high_school=(educ>=6)

reghdfe high_school treat_* [aw=perwt] if yrimmig>2008 , absorb(bpld cohort year yrsusa1) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Individuals with high school education or more", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) 

*========================================================================*
reghdfe eng treat_* sex [aw=perwt] if age>=20, absorb(bpld cohort year yrimmig#year) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) 

*========================================================================*
reghdfe high_school treat_* sex [aw=perwt] if age>=18, absorb(bpld cohort year yrimmig#year) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Individuals with high school education or more", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) 


gen yrsusa2=yrsusa1 if bpld>5600
replace yrsusa2=age if yrsusa1==0 & bpld<=5600

*========================================================================*
reghdfe high_school treat_* sex [aw=perwt] if age>=18, absorb(bpld cohort year yrimmig#year yrsusa1) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Individuals with high school education or more", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) 

reghdfe eng treat_* sex [aw=perwt] if ((yrimmig>=2009 & bpld==20000) | bpld!=20000) & age>=18, absorb(bpld cohort year yrimmig#year yrsusa2) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) 


reghdfe eng treat_* sex [aw=perwt] if ((yrimmig>=2009 & bpld==20000) | bpld!=20000) & age>=18 & yrimm!=0, absorb(bpld cohort year yrimmig#year yrsusa2) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) 




reghdfe eng treat_* sex [aw=perwt] if ((yrimmig>=2009 & bpld==20000) | bpld!=20000) & age>=14 & yrimm!=0, absorb(bpld cohort year yrimmig#year yrsusa2#year) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) 


reghdfe eng treat_* sex [aw=perwt] if  age>=14 & yrimm!=0, absorb(bpld cohort year yrimmig#year yrsusa2#year) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) 


**All Hispanic immigrants, all migrated after 2008, controls for year of migration, and yrs in the USA 
reghdfe eng treat_* sex [aw=perwt] if  age>=18 & yrimm!=0 & yrimm>=2009, absorb(bpld cohort year yrimmig#year yrsusa1#year) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) 


reghdfe high_school treat_* sex [aw=perwt] if  age>=14 & yrimm!=0, absorb(bpld cohort year yrimmig#year yrsusa2#year) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) 

preserve
keep if year==2024
collapse eng, by(treat cohort)
twoway (line eng cohort if treat==1) (line eng cohort if treat==0, lpattern(dash))
restore

preserve
keep if year==2024
drop if yrimmig>=2009 & bpld==20000
collapse eng, by(treat cohort)
twoway (line eng cohort if treat==1) (line eng cohort if treat==0, lpattern(dash))
restore

preserve
keep if yrimm!=0 & year==2024
collapse eng, by(treat cohort)
twoway (line eng cohort if treat==1) (line eng cohort if treat==0, lpattern(dash))
restore

preserve
keep if yrimm!=0
drop if yrimmig>=2009 & bpld==20000
collapse eng, by(treat cohort)
twoway (line eng cohort if treat==1) (line eng cohort if treat==0)
restore

preserve
keep if yrimm!=0 & year==2024
drop if yrimmig>=2009 & bpld==20000
collapse eng, by(treat cohort)
twoway (line eng cohort if treat==1) (line eng cohort if treat==0)
restore


