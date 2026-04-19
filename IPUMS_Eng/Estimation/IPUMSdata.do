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
/*
use "$data/Papers/main/IPUMS_Eng/Data/ipums_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 {
    append using "$data/Papers/main/IPUMS_Eng/Data/ipums_`x'.dta"
}
save "$base\ipums.dta", replace 
*/
*=====================================================================*
// use "$base\ACS22_24.dta", clear
use "$base\ACS24.dta", clear

rename birthyr cohort
keep if cohort>=1995 & cohort<=2010
keep if hispan!=0
keep if year==2024
/* 
1. Remove US-born Hispanics 
2. Exposed cohorts. Is 1999 treated? No, the policy did not affect this cohort
3. Exposure to the policy by cohort using the school census
4. Add 2023 ACS 
*/

/* Assign the treatment to individuals who were born in Mexico */
gen treat=bpld==20000 
/* Removing from the treatment the indiviuals who migrated to the US
when they were kids because they did no have exposure to the policy
and because they had exposure to the English language in the US. The policy started as a trial stage in 2009, but expanded for three years until 2011 */
drop if yrimmig<2009 & bpld==20000
/* Removing immigrants from other countries different from Mexico */
replace treat=. if bpld>5600 & bpld!=20000
// replace treat=. if bpld<=5600
/* Individuals who were born in 2000 or later, are likely to be exposed to
the policy, older individuals were not exposed to it */ 
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


*========================================================================*
reghdfe eng treat_* [aw=perwt], absorb(bpld cohort) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) 
graph export "$doc\figEng.png", replace

areg eng after_treat i.cohort [aw=perwt], absorb(bpld) vce(cluster cluster)

*========================================================================*
reghdfe educ treat_* [aw=perwt], absorb(bpld cohort) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Years of education", size(medium) height(5)) ///
ylabel(-2(1)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-2 2)) 
graph export "$doc\figEdu.png", replace
*========================================================================*
drop treat_2007 treat_2008 treat_2009 treat_2010

reghdfe labforce treat_* [aw=perwt], absorb(bpld cohort) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of belonging to labor force", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) 

*========================================================================*
reghdfe work treat_* educ sex [aw=perwt], absorb(bpld cohort) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of working", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) 
graph export "$doc\figWork.png", replace

*========================================================================*
reghdfe lincome treat_* [aw=perwt], absorb(bpld cohort) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Change in income (percent)", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) 

*========================================================================*
reghdfe lwage treat_* educ sex [aw=perwt] if work==1, absorb(bpld cohort) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Change in wages (percent)", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) 
graph export "$doc\figWages.png", replace