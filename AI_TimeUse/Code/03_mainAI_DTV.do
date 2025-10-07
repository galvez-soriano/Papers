*=====================================================================*
/* Paper: AI and labor productivity 
   Authors: Oscar Galvez-Soriano and Ornella Darova */
*=====================================================================*
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\AI_Productivity\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\AI_Productivity\Doc"
*=====================================================================*
/*
use "$data/Papers/main/AI_TimeUse/Data/dbaseAI_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14 {
    append using "$data/Papers/main/AI_TimeUse/Data/dbaseAI_`x'.dta"
}
save "$base\dbaseAI.dta", replace 
*/
*=====================================================================*
use "$base\dbaseAI.dta", clear

graph set window fontface "Times New Roman"

merge m:1 geo using "$data/Papers/main/AI_TimeUse/Data/exposureCoverage.dta"
keep if _merge==3
drop _merge

gen after=year>=2024
gen treat_after=treat*after
label variable treat_after "Treat $\times$ After"
gen paidwork=work==1 & lab_inc>0 & lab_inc!=.

foreach x in 16 18 20 22 24{
gen treat_20`x'=0
replace treat_20`x'=1 if treat==1 & year==20`x'
label var treat_20`x' "20`x'"
}
replace treat_2022=0

gen t_work=time_work
replace t_work=hrs_work if t_work==0 & hrs_work!=.
gen time_other= 168-(t_work + time_study + time_leisure)
gen lincome=ln(lab_inc+1)
*=====================================================================*
/* Table 1 */
*=====================================================================*
/* Panel A */
*=====================================================================*
eststo clear
eststo: reghdfe time_study treat_after hhsize age female indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe t_work treat_after hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe time_leisure treat_after hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe time_other treat_after hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
esttab using "$doc\tab1A.tex", r2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0fc %9.3f)) label replace keep(treat_after)
*=====================================================================*
/* Panel B */
*=====================================================================*
eststo clear
eststo: reghdfe time_study treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe t_work treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe time_leisure treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe time_other treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
esttab using "$doc\tab1B.tex", r2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0fc %9.3f)) label replace keep(treat_after)
*=====================================================================*
/* Panel C */
*=====================================================================*
eststo clear
eststo: reghdfe time_study treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe t_work treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe time_leisure treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe time_other treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
esttab using "$doc\tab1C.tex", r2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0fc %9.3f)) label replace keep(treat_after)
*=====================================================================*
/* Table 2 */
*=====================================================================*
/* Panel A */
*=====================================================================*
eststo clear
eststo: reghdfe student treat_after hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe work treat_after hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe inactive treat_after hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe lincome treat_after hhsize age female educ indigen i.loc_size if age>=6 & age<=24 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
esttab using "$doc\tab2A.tex", r2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0fc %9.3f)) label replace keep(treat_after)
*=====================================================================*
/* Panel B */
*=====================================================================*
eststo clear
eststo: reghdfe student treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe work treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe inactive treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe lincome treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
esttab using "$doc\tab2B.tex", r2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0fc %9.3f)) label replace keep(treat_after)
*=====================================================================*
/* Panel C */
*=====================================================================*
eststo clear
eststo: reghdfe student treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe work treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe inactive treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe lincome treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
esttab using "$doc\tab2C.tex", r2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0fc %9.3f)) label replace keep(treat_after)
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
graph export "$doc\PTA_tstudy.png", replace


reghdfe t_work treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
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
graph export "$doc\PTA_twork.png", replace

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
graph export "$doc\PTA_tleisure.png", replace


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
graph export "$doc\PTA_tother.png", replace

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
graph export "$doc\PTA_student.png", replace


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
graph export "$doc\PTA_work.png", replace


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
graph export "$doc\PTA_inactive.png", replace


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
graph export "$doc\PTA_income.png", replace

*=====================================================================*
/* Heterogeneity */
*=====================================================================*
/* Figure 3. Young individuals' time use (by sex) */
*=====================================================================*
reghdfe time_study treat_20* hhsize age educ indigen i.loc_size if age>=6 & age<=24 & female==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store stime_women
reghdfe time_study treat_20* hhsize age educ indigen i.loc_size if age>=6 & age<=24 & female==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store stime_men

coefplot ///
(stime_women, offset(-0.1) label(Women) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(stime_men, label(Men) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent studying (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(pos(11) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) 
graph export "$doc\PTA_tystudySex.png", replace

reghdfe t_work treat_20* hhsize age educ indigen i.loc_size if age>=6 & age<=24 & female==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store ywtime_women
reghdfe t_work treat_20* hhsize age educ indigen i.loc_size if age>=6 & age<=24 & female==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store ywtime_men

coefplot ///
(ywtime_women, offset(-0.1) label(Women) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(ywtime_men, label(Men) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent working (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) 
graph export "$doc\PTA_tyworkSex.png", replace

reghdfe time_leisure treat_20* hhsize age educ indigen i.loc_size if age>=6 & age<=24 & female==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store yltime_women
reghdfe time_leisure treat_20* hhsize age educ indigen i.loc_size if age>=6 & age<=24 & female==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store yltime_men

coefplot ///
(yltime_women, offset(-0.1) label(Women) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(yltime_men, label(Men) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in leisure (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) 
graph export "$doc\PTA_tyleisureSex.png", replace

reghdfe time_other treat_20* hhsize age educ indigen i.loc_size if age>=6 & age<=24 & female==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store yotime_women
reghdfe time_other treat_20* hhsize age educ indigen i.loc_size if age>=6 & age<=24 & female==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store yotime_men

coefplot ///
(yotime_women, offset(-0.1) label(Women) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(yotime_men, label(Men) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in other chores (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) 
graph export "$doc\PTA_tyotherSex.png", replace
*=====================================================================*
/* Figure 4. Young individuals' time use (by ethnicity) */
*=====================================================================*
reghdfe time_study treat_20* hhsize age female educ i.loc_size if age>=6 & age<=24 & indigen==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store stime_ind
reghdfe time_study treat_20* hhsize age female educ i.loc_size if age>=6 & age<=24 & indigen==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store stime_nonind

coefplot ///
(stime_ind, offset(-0.1) label(Indigenous) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(stime_nonind, label(Non-indigenous) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent studying (hours)", size(medium) height(5)) ///
ylabel(-8(4)8, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(pos(12) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-8 8)) 
graph export "$doc\PTA_tystudyInd.png", replace

reghdfe t_work treat_20* hhsize age female educ i.loc_size if age>=6 & age<=24 & indigen==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store ywtime_ind
reghdfe t_work treat_20* hhsize age female educ i.loc_size if age>=6 & age<=24 & indigen==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store ywtime_nonind

coefplot ///
(ywtime_ind, offset(-0.1) label(Indigenous) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(ywtime_nonind, label(Non-indigenous) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent working (hours)", size(medium) height(5)) ///
ylabel(-8(4)8, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-8 8)) 
graph export "$doc\PTA_tyworkInd.png", replace

reghdfe time_leisure treat_20* hhsize age female educ i.loc_size if age>=6 & age<=24 & indigen==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store yltime_ind
reghdfe time_leisure treat_20* hhsize age female educ i.loc_size if age>=6 & age<=24 & indigen==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store yltime_nonind

coefplot ///
(yltime_ind, offset(-0.1) label(Indigenous) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(yltime_nonind, label(Non-indigenous) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in leisure (hours)", size(medium) height(5)) ///
ylabel(-8(4)8, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-8 8)) 
graph export "$doc\PTA_tyleisureInd.png", replace

reghdfe time_other treat_20* hhsize age female educ i.loc_size if age>=6 & age<=24 & indigen==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store yotime_ind
reghdfe time_other treat_20* hhsize age female educ i.loc_size if age>=6 & age<=24 & indigen==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store yotime_nonind

coefplot ///
(yotime_ind, offset(-0.1) label(Indigenous) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(yotime_nonind, label(Non-indigenous) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in other chores (hours)", size(medium) height(5)) ///
ylabel(-8(4)8, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-8 8)) 
graph export "$doc\PTA_tyotherInd.png", replace
*=====================================================================*
/* Figure 5. Young individuals' time use (by context) */
*=====================================================================*
reghdfe time_study treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=24 & rururb==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store stime_rural
reghdfe time_study treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=24 & rururb==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store stime_urban

coefplot ///
(stime_rural, offset(-0.1) label(Rural) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(stime_urban, label(Urban) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent studying (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(pos(11) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) 
graph export "$doc\PTA_tystudyRU.png", replace

reghdfe t_work treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=24 & rururb==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store ywtime_rural
reghdfe t_work treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=24 & rururb==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store ywtime_urban

coefplot ///
(ywtime_rural, offset(-0.1) label(Rural) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(ywtime_urban, label(Urban) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent working (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) 
graph export "$doc\PTA_tyworkRU.png", replace

reghdfe time_leisure treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=24 & rururb==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store yltime_rural
reghdfe time_leisure treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=24 & rururb==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store yltime_urban

coefplot ///
(yltime_rural, offset(-0.1) label(Rural) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(yltime_urban, label(Urban) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in leisure (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) 
graph export "$doc\PTA_tyleisureRU.png", replace

reghdfe time_other treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=24 & rururb==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store yotime_rural
reghdfe time_other treat_20* hhsize age female educ indigen i.loc_size if age>=6 & age<=24 & rururb==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store yotime_urban

coefplot ///
(yotime_rural, offset(-0.1) label(Rural) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(yotime_urban, label(Urban) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in other chores (hours)", size(medium) height(5)) ///
ylabel(-6(3)6, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-6 6)) 
graph export "$doc\PTA_tyotherRU.png", replace
*=====================================================================*
/* Figure 6. Adults' time use (by sex) */
*=====================================================================*
reghdfe t_work treat_20* hhsize age educ indigen i.loc_size if age>=25 & age<=54 & female==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store awtime_women
reghdfe t_work treat_20* hhsize age educ indigen i.loc_size if age>=25 & age<=54 & female==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store awtime_men

coefplot ///
(awtime_women, offset(-0.1) label(Women) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(awtime_men, label(Men) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent working (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(pos(11) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) 
graph export "$doc\PTA_taworkSex.png", replace

reghdfe time_leisure treat_20* hhsize age educ indigen i.loc_size if age>=25 & age<=54 & female==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store altime_women
reghdfe time_leisure treat_20* hhsize age educ indigen i.loc_size if age>=25 & age<=54 & female==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store altime_men

coefplot ///
(altime_women, offset(-0.1) label(Women) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(altime_men, label(Men) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in leisure (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) 
graph export "$doc\PTA_taleisureSex.png", replace

reghdfe time_other treat_20* hhsize age educ indigen i.loc_size if age>=25 & age<=54 & female==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store aotime_women
reghdfe time_other treat_20* hhsize age educ indigen i.loc_size if age>=25 & age<=54 & female==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store aotime_men

coefplot ///
(aotime_women, offset(-0.1) label(Women) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(aotime_men, label(Men) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in other chores (hours)", size(medium) height(5)) ///
ylabel(-6(3)6, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-6 6)) 
graph export "$doc\PTA_taotherSex.png", replace
*=====================================================================*
/* Figure 7. Adults' time use (by context) */
*=====================================================================*
reghdfe t_work treat_20* hhsize age female educ indigen i.loc_size if age>=25 & age<=54 & rururb==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store awtime_rural
reghdfe t_work treat_20* hhsize age female educ indigen i.loc_size if age>=25 & age<=54 & rururb==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store awtime_urban

coefplot ///
(awtime_rural, offset(-0.1) label(Rural) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(awtime_urban, label(Urban) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent working (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(pos(7) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) 
graph export "$doc\PTA_taworkRU.png", replace

reghdfe time_leisure treat_20* hhsize age female educ indigen i.loc_size if age>=25 & age<=54 & rururb==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store altime_rural
reghdfe time_leisure treat_20* hhsize age female educ indigen i.loc_size if age>=25 & age<=54 & rururb==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store altime_urban

coefplot ///
(altime_rural, offset(-0.1) label(Rural) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(altime_urban, label(Urban) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in leisure (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) 
graph export "$doc\PTA_taleisureRU.png", replace

reghdfe time_other treat_20* hhsize age female educ indigen i.loc_size if age>=25 & age<=54 & rururb==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store aotime_rural
reghdfe time_other treat_20* hhsize age female educ indigen i.loc_size if age>=25 & age<=54 & rururb==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store aotime_urban

coefplot ///
(aotime_rural, offset(-0.1) label(Rural) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(aotime_urban, label(Urban) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in other chores (hours)", size(medium) height(5)) ///
ylabel(-6(3)6, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-6 6)) 
graph export "$doc\PTA_taotherRU.png", replace
*=====================================================================*
/* Figure 8. Adults' time use (by ethnicity) */
*=====================================================================*
reghdfe t_work treat_20* hhsize age female educ i.loc_size if age>=25 & age<=54 & indigen==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store awtime_ind
reghdfe t_work treat_20* hhsize age female educ i.loc_size if age>=25 & age<=54 & indigen==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store awtime_nonind

coefplot ///
(awtime_ind, offset(-0.1) label(Indigenous) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(awtime_nonind, label(Non-indigenous) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent working (hours)", size(medium) height(5)) ///
ylabel(-8(4)8, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(pos(7) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-8 8)) 
graph export "$doc\PTA_taworkInd.png", replace

reghdfe time_leisure treat_20* hhsize age female educ i.loc_size if age>=25 & age<=54 & indigen==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store altime_ind
reghdfe time_leisure treat_20* hhsize age female educ i.loc_size if age>=25 & age<=54 & indigen==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store altime_nonind

coefplot ///
(altime_ind, offset(-0.1) label(Indigenous) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(altime_nonind, label(Non-indigenous) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in leisure (hours)", size(medium) height(5)) ///
ylabel(-8(4)8, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-8 8)) 
graph export "$doc\PTA_taleisureInd.png", replace

reghdfe time_other treat_20* hhsize age female educ i.loc_size if age>=25 & age<=54 & indigen==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store aotime_ind
reghdfe time_other treat_20* hhsize age female educ i.loc_size if age>=25 & age<=54 & indigen==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store aotime_nonind

coefplot ///
(aotime_ind, offset(-0.1) label(Indigenous) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(aotime_nonind, label(Non-indigenous) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in other chores (hours)", size(medium) height(5)) ///
ylabel(-8(4)8, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-8 8)) 
graph export "$doc\PTA_taotherInd.png", replace
*=====================================================================*
/* Figure 9. Elderlies' time use (by sex) */
*=====================================================================*
reghdfe t_work treat_20* hhsize age educ indigen i.loc_size if age>=55 & age<=100 & female==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store ewtime_women
reghdfe t_work treat_20* hhsize age educ indigen i.loc_size if age>=55 & age<=100 & female==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store ewtime_men

coefplot ///
(ewtime_women, offset(-0.1) label(Women) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(ewtime_men, label(Men) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent working (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(pos(11) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) 
graph export "$doc\PTA_teworkSex.png", replace

reghdfe time_leisure treat_20* hhsize age educ indigen i.loc_size if age>=55 & age<=100 & female==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store eltime_women
reghdfe time_leisure treat_20* hhsize age educ indigen i.loc_size if age>=55 & age<=100 & female==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store eltime_men

coefplot ///
(eltime_women, offset(-0.1) label(Women) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(eltime_men, label(Men) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in leisure (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) 
graph export "$doc\PTA_teleisureSex.png", replace

reghdfe time_other treat_20* hhsize age educ indigen i.loc_size if age>=55 & age<=100 & female==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store eotime_women
reghdfe time_other treat_20* hhsize age educ indigen i.loc_size if age>=55 & age<=100 & female==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store eotime_men

coefplot ///
(eotime_women, offset(-0.1) label(Women) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(eotime_men, label(Men) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in other chores (hours)", size(medium) height(5)) ///
ylabel(-6(3)6, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-6 6)) 
graph export "$doc\PTA_teotherSex.png", replace
*=====================================================================*
/* Figure 10. Elderlies' time use (by ethnicity) */
*=====================================================================*
reghdfe t_work treat_20* hhsize age female educ i.loc_size if age>=55 & age<=100 & indigen==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store ewtime_ind
reghdfe t_work treat_20* hhsize age female educ i.loc_size if age>=55 & age<=100 & indigen==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store ewtime_nonind

coefplot ///
(ewtime_ind, offset(-0.1) label(Indigenous) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(ewtime_nonind, label(Non-indigenous) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent working (hours)", size(medium) height(5)) ///
ylabel(-8(4)8, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(pos(7) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-8 8)) 
graph export "$doc\PTA_teworkInd.png", replace

reghdfe time_leisure treat_20* hhsize age female educ i.loc_size if age>=55 & age<=100 & indigen==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store eltime_ind
reghdfe time_leisure treat_20* hhsize age female educ i.loc_size if age>=55 & age<=100 & indigen==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store eltime_nonind

coefplot ///
(eltime_ind, offset(-0.1) label(Indigenous) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(eltime_nonind, label(Non-indigenous) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in leisure (hours)", size(medium) height(5)) ///
ylabel(-8(4)8, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-8 8)) 
graph export "$doc\PTA_teleisureInd.png", replace

reghdfe time_other treat_20* hhsize age female educ i.loc_size if age>=55 & age<=100 & indigen==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store eotime_ind
reghdfe time_other treat_20* hhsize age female educ i.loc_size if age>=55 & age<=100 & indigen==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store eotime_nonind

coefplot ///
(eotime_ind, offset(-0.1) label(Indigenous) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(eotime_nonind, label(Non-indigenous) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in other chores (hours)", size(medium) height(5)) ///
ylabel(-8(4)8, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-8 8)) 
graph export "$doc\PTA_teotherInd.png", replace

*=====================================================================*
/* Figure 11. Elderlies' time use (by context) */
*=====================================================================*
reghdfe t_work treat_20* hhsize age female educ indigen i.loc_size if age>=55 & age<=100 & rururb==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store ewtime_rural
reghdfe t_work treat_20* hhsize age female educ indigen i.loc_size if age>=55 & age<=100 & rururb==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store ewtime_urban

coefplot ///
(ewtime_rural, offset(-0.1) label(Rural) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(ewtime_urban, label(Urban) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent working (hours)", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(pos(7) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) 
graph export "$doc\PTA_teworkRU.png", replace

reghdfe time_leisure treat_20* hhsize age female educ indigen i.loc_size if age>=55 & age<=100 & rururb==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store eltime_rural
reghdfe time_leisure treat_20* hhsize age female educ indigen i.loc_size if age>=55 & age<=100 & rururb==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store eltime_urban

coefplot ///
(eltime_rural, offset(-0.1) label(Rural) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(eltime_urban, label(Urban) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in leisure (hours)", size(medium) height(5)) ///
ylabel(-8(4)8, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-8 8)) 
graph export "$doc\PTA_teleisureRU.png", replace

reghdfe time_other treat_20* hhsize age female educ indigen i.loc_size if age>=55 & age<=100 & rururb==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store eotime_rural
reghdfe time_other treat_20* hhsize age female educ indigen i.loc_size if age>=55 & age<=100 & rururb==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store eotime_urban

coefplot ///
(eotime_rural, offset(-0.1) label(Rural) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(eotime_urban, label(Urban) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time spent in other chores (hours)", size(medium) height(5)) ///
ylabel(-8(4)8, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-8 8)) 
graph export "$doc\PTA_teotherRU.png", replace

