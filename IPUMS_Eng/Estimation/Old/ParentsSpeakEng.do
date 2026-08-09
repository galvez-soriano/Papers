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
// gl base= "C:\Users\Oscar Galvez Soriano\OneDrive - The University of Chicago\Documents\Papers\IPUMS\Data"
// gl doc= "C:\Users\Oscar Galvez Soriano\OneDrive - The University of Chicago\Documents\Papers\IPUMS\Doc"

graph set window fontface "Times New Roman"
*========================================================================*
/* Spillover effects */
*========================================================================*
use "$base\ACS12_24.dta", clear
rename birthyr cohort

keep if year>=2022
*All Hispanic
keep if hispan!=0

/* Assign the treatment to individuals who were born in Mexico */
gen treat=bpld==20000 

/* Create cohort treatment at the household level */
gen child_t=1 if (relate==3 | relate==4) & (cohort>=1995 & cohort<=2010)
bysort serial: egen num_ec=sum(child_t)
gen sample_hh=1 if famsize>num_ec & num_ec!=0 & num_ec!=. 
drop if cohort>2010
bysort serial: egen cohort_t=max(cohort)

gen after=cohort_t>=2000
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
gen schooling=educd
recode schooling (2=0) (11=0) (12=0) (14=1) (15=2) (16=3) (17=4) (22=5) ///
(23=6) (25=7) (26=8) (30=9) (40=10) (50=11) (61=12) (63=12) (64=12) (65=13) ///
(71=14) (81=15) (101=16) (114=17) (115=19) (116=22)
gen high_school=(educ>=6)
gen college=(educ>=7)
gen private=schltype==3

gen yrsusa2=yrsusa1 if bpld>5600
replace yrsusa2=age if yrsusa1==0 & bpld<=5600

foreach x in 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 ///
2006 2007 2008 2009 2010 {
gen treat_`x'=0
replace treat_`x'=1 if treat==1 & cohort_t==`x'
replace treat_`x'=. if treat==.
label var treat_`x' "`x'"
}
replace treat_1999=0
 
/* English skills */
reghdfe eng treat_* [aw=perwt] if yrimm!=0 & yrimm>2008 & age>=30, absorb(age bpld cohort_t year yrimmig#cohort_t#year) vce(cluster cluster)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) xlabel(, angle(90) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) 
graph export "$doc\figEng_ImmigrantsP.png", replace

reghdfe eng after_treat [aw=perwt] if yrimm!=0 & yrimm>2008, absorb(age bpld cohort_t year yrimmig#cohort_t#year) vce(cluster cluster)