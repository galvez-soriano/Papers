*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
/* Robustness checks using Mexican school census */
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl base= "C:\Users\T43969\Documents\EngInstruction\Data"
gl doc= "C:\Users\T43969\Documents\EngInstruction"
*========================================================================*
/* Did the NEPBE affect enrollment in private schools? */
*========================================================================*
use "$base\d_schools.dta", clear
keep if year>=2006 & year<=2011

/*egen cct2= group(cct)
duplicates drop
xtset cct2 year*/

gen wnstud=log(total_stud)

areg wnstud h_group year i.year rural school_supp_exp uniform_exp tuition /// 
if public==0 & year>=2006 & year<=2011, absorb(cct) vce(cluster cct)

/************* Pre-trends analysis *************/
use "$base\d_schools.dta", clear
graph set window fontface "Times New Roman"
foreach x in 2006 2007 2008 2009 2010 2011{
gen eng_`x'=0
label var eng_`x' "`x'"
replace eng_`x'=h_group if year==`x'
}
replace eng_2008=0
gen wnstud=log(total_stud)

areg wnstud eng_* year i.year rural school_supp_exp uniform_exp tuition /// 
if public==0 & year>=2006 & year<=2011, absorb(cct) vce(cluster cct)
coefplot, vertical keep(eng_*) yline(0) omitted baselevels ///
xline(3.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change in total number of students", size(medium) height(5)) ///
ylabel(-0.01(0.005)0.01, labs(medium) grid format(%5.3f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.01 0.01)) text(0.012 3 "NEPBE", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\nstudU_pta.png", replace
*========================================================================*
/* Did the NEPBE affect other school inputs? */
*========================================================================*
use "$base\d_schools.dta", clear
keep if year>=2006 & year<=2011

foreach x in teach_elem teach_midle teach_high teach_colle teach_mast teach_phd{
	replace `x'=0 if `x'==.
}
gen telem=log(teach_elem+1)
gen tmid=log(teach_midle+1)
gen thigh=log(teach_high+1)
gen tcolle=log(teach_colle+1)
gen tmast=log(teach_mast+1)
gen tphd=log(teach_phd+1)

areg telem h_group year i.year rural total_stud if public==1 & shift==1 & fts!=1, absorb(cct) vce(cluster cct)
areg tmid h_group year i.year rural total_stud if public==1 & shift==1 & fts!=1, absorb(cct) vce(cluster cct)
areg thigh h_group year i.year rural total_stud if public==1 & shift==1 & fts!=1, absorb(cct) vce(cluster cct)
areg tcolle h_group year i.year rural total_stud if public==1 & shift==1 & fts!=1, absorb(cct) vce(cluster cct)

/************* Pre-trends analysis *************/
graph set window fontface "Times New Roman"
keep if year>=2006 & year<=2011
foreach x in 2006 2007 2008 2009 2010 2011{
gen eng_`x'=0
label var eng_`x' "`x'"
replace eng_`x'=h_group if year==`x'
}
replace eng_2008=0

areg telem eng_* year i.year rural total_stud if public==1 & shift==1 & fts!=1, absorb(cct) vce(cluster cct)
coefplot, vertical keep(eng_*) yline(0) omitted baselevels ///
xline(3.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of teachers", size(medium) height(5)) ///
ylabel(-0.01(0.005)0.01, labs(medium) grid format(%5.3f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.01 0.01)) text(0.012 3 "NEPBE", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\telem_pta.png", replace

areg tmid eng_* year i.year rural total_stud if public==1 & shift==1 & fts!=1, absorb(cct) vce(cluster cct)
coefplot, vertical keep(eng_*) yline(0) omitted baselevels ///
xline(3.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of teachers", size(medium) height(5)) ///
ylabel(-0.01(0.005)0.01, labs(medium) grid format(%5.3f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.01 0.01)) text(0.012 3 "NEPBE", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\tmid_pta.png", replace

areg thigh eng_* year i.year rural total_stud if public==1 & shift==1 & fts!=1, absorb(cct) vce(cluster cct)
coefplot, vertical keep(eng_*) yline(0) omitted baselevels ///
xline(3.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of teachers", size(medium) height(5)) ///
ylabel(-0.01(0.005)0.01, labs(medium) grid format(%5.3f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.01 0.01)) text(0.012 3 "NEPBE", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\thigh_pta.png", replace

areg tcolle eng_* year i.year rural total_stud if public==1 & shift==1 & fts!=1, absorb(cct) vce(cluster cct)
coefplot, vertical keep(eng_*) yline(0) omitted baselevels ///
xline(3.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of teachers", size(medium) height(5)) ///
ylabel(-0.01(0.005)0.01, labs(medium) grid format(%5.3f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.01 0.01)) text(0.012 3 "NEPBE", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\tcolle_pta.png", replace

*========================================================================*
/* The following is not part of the estimations. Just playing around */
*========================================================================*
use "$base\d_schools.dta", clear
keep if year>=2006 & year<=2011
gen tschool=.
replace tschool=1 if h_group>0 & year==2009
replace tschool=1 if h_group>0 & year==2010
replace tschool=1 if h_group>0 & year==2011
replace tschool=0 if tschool==.

collapse tschool, by(cct)
replace tschool=1 if tschool>0
save "$base\tschools.dta", replace
*========================================================================*
use "$base\d_schools.dta", clear
merge m:m cct using "$base\tschools.dta"
keep if year>=2006 & year<=2011

gen treat=public==1 
replace treat=. if tschool==0
label var treat "Treat"
gen after=year>=2009
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
/* DiD estimations */
*=====================================================================*
* Dependent variable: Exposure
eststo clear
areg h_group after_treat treat i.year, absorb(cct) vce(cluster cct)

*=====================================================================*
/* PTA */
*=====================================================================*
graph set window fontface "Times New Roman"
foreach x in 2006 2007 2008 2009 2010 2011{
gen treat_`x'=0
replace treat_`x'=1 if treat==1 & year==`x'
label var treat_`x' "`x'"
}
replace treat_2008=0

areg h_group treat_* treat i.year, absorb(cct) vce(cluster cct)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(3.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Expopsure to English instruction", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Years", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) text(0.12 3 "NEPBE", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\exp_pta.png", replace