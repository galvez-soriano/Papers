*========================================================================*
* English instruction in Mexico and labor market outcomes in the US
*========================================================================*
* Oscar Galvez-Soriano and Hoanh Le
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\IPUMS_Eng\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\IPUMS_Eng\Doc"
*========================================================================*
/*
use "$data/Papers/main/IPUMS_Eng/Data/ipums_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 {
    append using "$data/Papers/main/IPUMS_Eng/Data/ipums_`x'.dta"
}
save "$base\ipums.dta", replace 
*/
*=====================================================================*
use "$base\ipums.dta", clear

rename birthyr cohort
keep if cohort>=1994 & cohort<=2005
keep if hispan!=0

gen treat=bpld==20000
drop if yrimmig<=2002 & bpld==20000
replace treat=. if bpld>5600 & bpld!=20000

gen after=cohort>=2000
gen after_treat=after*treat
gen eng=speakeng>=3
gen lincome=ln(inctot+1)
gen work=empstat==1

foreach x in 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005{
gen treat_`x'=0
replace treat_`x'=1 if treat==1 & cohort==`x'
label var treat_`x' "`x'"
}
replace treat_1999=0

reghdfe eng treat_* [aw=perwt], absorb(bpld cohort) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) 
*graph export "$doc\fig2A.png", replace

areg eng after_treat i.cohort [aw=perwt], absorb(bpld) vce(cluster cluster)

*xtevent eng, policyvar(after_treat) panelvar(bpld) timevar(cohort) repeatedcs window(6) impute(nuchange)

*========================================================================*
reghdfe educ treat_* [aw=perwt], absorb(bpld cohort) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Years of education", size(medium) height(5)) ///
ylabel(-1.2(0.6)1.2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1.2 1.2)) 

*========================================================================*
reghdfe labforce treat_* [aw=perwt], absorb(bpld cohort) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of belonging to labor force", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) 

*========================================================================*
reghdfe work treat_* [aw=perwt], absorb(bpld cohort) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of working", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) 



*========================================================================*
reghdfe lincome treat_* [aw=perwt], absorb(bpld cohort) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Change in income (percent)", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) 