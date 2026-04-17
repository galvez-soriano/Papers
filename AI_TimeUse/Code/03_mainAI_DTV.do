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

destring sinco naics, replace

merge m:1 sinco using "$data/Papers/main/AI_TimeUse/Data/ai_occupations.dta"
drop if _merge==2
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
gen lincome=asinh(lab_inc) // Inverse hyperbolic sine
gen lmoni=asinh(mon_inc)
gen self_emp=main_jobt>=2 & main_jobt!=.
*=====================================================================*
/* Table 1 */
*=====================================================================*
/* Panel A */
*=====================================================================*
eststo clear
*Time use
eststo: reghdfe time_study treat_after hhsize age female indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe t_work treat_after hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe time_leisure treat_after hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe time_other treat_after hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
*Labor outcomes
eststo: reghdfe student treat_after hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe work treat_after hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe inactive treat_after hhsize age female educ indigen i.loc_size if age>=6 & age<=24 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe self_emp treat_after hhsize age female educ indigen i.loc_size if age>=6 & age<=24 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe lincome treat_after hhsize age female educ indigen i.loc_size if age>=6 & age<=24 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe lmoni treat_after hhsize age female educ indigen i.loc_size if age>=6 & age<=24 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
esttab using "$doc\tab1A.tex", r2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0fc %9.3f)) label replace keep(treat_after)
*=====================================================================*
/* Panel B */
*=====================================================================*
eststo clear
*Time use
eststo: reghdfe time_study treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe t_work treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe time_leisure treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe time_other treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
*Labor outcomes
eststo: reghdfe student treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe work treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe inactive treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe self_emp treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe lincome treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe lmoni treat_after hhsize age female educ indigen i.loc_size if age>=25 & age<=54 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
esttab using "$doc\tab1B.tex", r2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N r2, fmt(%9.0fc %9.3f)) label replace keep(treat_after)
*=====================================================================*
/* Panel C */
*=====================================================================*
eststo clear
*Time use
eststo: reghdfe time_study treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe t_work treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe time_leisure treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe time_other treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
*Labor outcomes
eststo: reghdfe student treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe work treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe inactive treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe self_emp treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe lincome treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
eststo: reghdfe lmoni treat_after hhsize age female educ indigen i.loc_size if age>=55 & age<=100 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
esttab using "$doc\tab1C.tex", r2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations) ///
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
/* AI occupations */
*=====================================================================*
sum aioe, d
gen ai_occupa=aioe>r(p90)

sum computer_ai, d
gen comp_occupa=computer_ai>r(p90)

reghdfe lincome treat_20* hhsize age female educ indigen i.loc_size if age>=14 & age<=65 & work==1 & ai_occupa==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store wage_aio
reghdfe lincome treat_20* hhsize age female educ indigen i.loc_size if age>=14 & age<=65 & work==1 & ai_occupa==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store wage_naio

coefplot ///
(wage_aio, offset(-0.1) label(Occupations with high use of AI) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(wage_naio, label(Occupations with low use of AI) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Ln(Income)", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(pos(11) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4))
graph export "$doc\PTA_wageAI.png", replace


reghdfe lincome treat_20* hhsize age female educ indigen i.loc_size if age>=14 & age<=65 & work==1 & comp_occupa==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store wage_comp
reghdfe lincome treat_20* hhsize age female educ indigen i.loc_size if age>=14 & age<=65 & work==1 & comp_occupa==0 [aw=weight], absorb(geo year state#year) vce(cluster geo)
estimates store wage_ncomp

coefplot ///
(wage_comp, offset(-0.1) label(Occupations with high use of computers) msize(small) msymbol(O) mcolor(gs2) ciopt(lc(gs2) recast(gs2)) lc(gs2)) ///
(wage_ncomp, label(Occupations with low use of computers) msize(small) msymbol(T) mcolor(gs8) ciopt(lc(gs8) recast(gs8)) lc(gs8)) ///
, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Ln(Income)", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(pos(11) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4))
graph export "$doc\PTA_wageComp.png", replace

/* Tripple interaction */
foreach x in 16 18 20 22 24{
gen ttreat_20`x'=0
replace ttreat_20`x'=1 if treat==1 & year==20`x' & ai_occupa==1
label var ttreat_20`x' "20`x'"
}
replace ttreat_2022=0

gen after_ai=after*ai_occupa
gen treat_ai=treat*ai_occupa

reghdfe lincome ttreat_20* hhsize age female educ indigen i.loc_size after_ai treat_ai ai_occupa ///
treat_after if age>=14 & age<=65 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)

coefplot , vertical keep(ttreat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Ln(Income)", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4))
graph export "$doc\PTA_wageDDDai.png", replace


foreach x in 16 18 20 22 24{
gen ctreat_20`x'=0
replace ctreat_20`x'=1 if treat==1 & year==20`x' & comp_occupa==1
label var ctreat_20`x' "20`x'"
}
replace ctreat_2022=0

gen after_comp=after*comp_occupa
gen treat_comp=treat*comp_occupa

reghdfe lincome ctreat_20* hhsize age female educ indigen i.loc_size after_comp treat_comp comp_occupa ///
treat_after if age>=14 & age<=65 & work==1 [aw=weight], absorb(geo year state#year) vce(cluster geo)

coefplot , vertical keep(ctreat_20*) yline(0) omitted baselevels ///
xline(4.3, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Ln(Income)", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4))
graph export "$doc\PTA_wageDDDcomp.png", replace

*