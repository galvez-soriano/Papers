*=====================================================================*
/* Paper: AI and labor productivity 
   Authors: Oscar Galvez-Soriano and Ornella Darova */
*=====================================================================*
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\AI_Productivity\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\AI_Productivity\Doc"
*=====================================================================*
/*
use "$data/Papers/main/RemittancesMex/Data/dbaseRemitt_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 {
    append using "$data/Papers/main/RemittancesMex/Data/dbaseRemitt_`x'.dta"
}
save "$base\dbaseRemitt.dta", replace 
*/
*=====================================================================*
use "$base\dbaseAI.dta", clear

graph set window fontface "Times New Roman"

merge m:1 geo using "$base\exposureCoverage2.dta"
keep if _merge==3
drop _merge
rename treat_top treat

gen after=year>=2024
gen treat_after=treat*after
gen paidwork=work==1 & lab_inc>0 & lab_inc!=.

foreach x in 16 18 20 22 24{
gen treat_20`x'=0
replace treat_20`x'=1 if treat==1 & year==20`x'
label var treat_20`x' "20`x'"
}
replace treat_2022=0

gen t_work=time_work
replace t_work=hrs_work if t_work==0 & hrs_work!=.

*=====================================================================*
/* Figure 1 */
*=====================================================================*
reghdfe time_study treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store young_s
reghdfe time_study treat_20* hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store adult_s
reghdfe time_study treat_20* hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store elderly_s

coefplot ///
(young_s, offset(-0.1) label(Young individuals (6-24)) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(adult_s, label(Prime age adults (25-54)) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
(elderly_s, offset(0.1) label(Elderlies (55-100)) msize(small) msymbol(S) mcolor(gs12) ciopt(lc(gs12) recast(gs12)) lc(gs12)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent studying (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(pos(11) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) 
graph export "$doc\PTA_tstudyR.png", replace


reghdfe t_work treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=25 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store young_w
reghdfe t_work treat_20* hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store adult_w
reghdfe t_work treat_20* hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store elderly_w

coefplot ///
(young_w, offset(-0.1) label(Young individuals (6-24)) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(adult_w, label(Prime age adults (25-54)) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
(elderly_w, offset(0.1) label(Elderlies (55-100)) msize(small) msymbol(S) mcolor(gs12) ciopt(lc(gs12) recast(gs12)) lc(gs12)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent working (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4))
graph export "$doc\PTA_tworkR.png", replace

reghdfe time_leisure treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store young_l
reghdfe time_leisure treat_20* hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store adult_l
reghdfe time_leisure treat_20* hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store elderly_l

coefplot ///
(young_l, offset(-0.1) label(Young individuals (6-24)) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(adult_l, label(Prime age adults (25-54)) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
(elderly_l, offset(0.1) label(Elderlies (55-100)) msize(small) msymbol(S) mcolor(gs12) ciopt(lc(gs12) recast(gs12)) lc(gs12)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in leisure (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4))
graph export "$doc\PTA_tleisureR.png", replace

gen time_other= 168-(t_work + time_study + time_leisure)

reghdfe time_other treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store young_o
reghdfe time_other treat_20* hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store adult_o
reghdfe time_other treat_20* hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store elderly_o

coefplot ///
(young_o, offset(-0.1) label(Young individuals (6-24)) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(adult_o, label(Prime age adults (25-54)) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
(elderly_o, offset(0.1) label(Elderlies (55-100)) msize(small) msymbol(S) mcolor(gs12) ciopt(lc(gs12) recast(gs12)) lc(gs12)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in other chores (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4))
graph export "$doc\PTA_totherR.png", replace

*=====================================================================*
/* Figure 2 */
*=====================================================================*
reghdfe student treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store young_stud
reghdfe student treat_20* hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store adult_stud
reghdfe student treat_20* hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store elderly_stud

coefplot ///
(young_stud, offset(-0.1) label(Young individuals (6-24)) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(adult_stud, label(Prime age adults (25-54)) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
(elderly_stud, offset(0.1) label(Elderlies (55-100)) msize(small) msymbol(S) mcolor(gs12) ciopt(lc(gs12) recast(gs12)) lc(gs12)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being enrolled in school", size(medium) height(5)) ///
ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(pos(11) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.06 0.06))
graph export "$doc\PTA_studentR.png", replace


reghdfe work treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store young_work
reghdfe work treat_20* hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store adult_work
reghdfe work treat_20* hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store elderly_work

coefplot ///
(young_work, offset(-0.1) label(Young individuals (6-24)) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(adult_work, label(Prime age adults (25-54)) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
(elderly_work, offset(0.1) label(Elderlies (55-100)) msize(small) msymbol(S) mcolor(gs12) ciopt(lc(gs12) recast(gs12)) lc(gs12)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being employed", size(medium) height(5)) ///
ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.06 0.06))
graph export "$doc\PTA_workR.png", replace


reghdfe inactive treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store young_inact
reghdfe inactive treat_20* hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store adult_inact
reghdfe inactive treat_20* hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store elderly_inact

coefplot ///
(young_inact, offset(-0.1) label(Young individuals (6-24)) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(adult_inact, label(Prime age adults (25-54)) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
(elderly_inact, offset(0.1) label(Elderlies (55-100)) msize(small) msymbol(S) mcolor(gs12) ciopt(lc(gs12) recast(gs12)) lc(gs12)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being inactive", size(medium) height(5)) ///
ylabel(-0.06(0.03)0.06, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.06 0.06))
graph export "$doc\PTA_inactiveR.png", replace


gen lincome=ln(lab_inc+1)
reghdfe lincome treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=24 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store young_wage
reghdfe lincome treat_20* hhsize age female educ indigen i.loc_size if age>=25 & age<=54 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store adult_wage
reghdfe lincome treat_20* hhsize age female educ indigen i.loc_size if age>=55 & age<=100 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store elderly_wage

coefplot ///
(young_wage, offset(-0.1) label(Young individuals (6-24)) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(adult_wage, label(Prime age adults (25-54)) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
(elderly_wage, offset(0.1) label(Elderlies (55-100)) msize(small) msymbol(S) mcolor(gs12) ciopt(lc(gs12) recast(gs12)) lc(gs12)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Ln(Income)", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4))
graph export "$doc\PTA_incomeR.png", replace

