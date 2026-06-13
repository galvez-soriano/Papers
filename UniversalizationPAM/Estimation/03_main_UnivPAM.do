*=====================================================================*
/* Paper: Unintended effects of universalizing social pensions
   Authors: Oscar Galvez-Soriano and Raymundo Ramirez */
*=====================================================================*
clear all
set more off

gl rd="C:\Users\Oscar Galvez Soriano\Documents\Papers\UniversalizationPAM\Data"
gl gr="C:\Users\Oscar Galvez Soriano\Documents\Papers\UniversalizationPAM\Doc"
*=================================================================================*
use "$rd\dbasePAM.dta", clear
*=====================================================================*

*=====================================================================*
/* Table 1: Summary statistics */
*=====================================================================*
eststo clear
eststo control_B: quietly estpost sum pam l_inc poor epoor work female ///
educ indig cohab1 rururb [aw=weight] if after==0 & treat==0 ///
& tr==0
eststo treat_B: quietly estpost sum pam l_inc poor epoor work female ///
educ indig cohab1 rururb [aw=weight] if after==0 & treat==1 ///
& tr==0
eststo control_A: quietly estpost sum pam l_inc poor epoor work female ///
educ indig cohab1 rururb [aw=weight] if after==1 & treat==0 ///
& tr==0
eststo treat_A: quietly estpost sum pam l_inc poor epoor work female ///
educ indig cohab1 rururb [aw=weight] if after==1 & treat==1 ///
& tr==0
eststo control_BP: quietly estpost sum pam l_inc poor epoor work female ///
educ indig cohab1 rururb [aw=weight] if after==0 & treat==0 ///
& tr==1
eststo treat_BP: quietly estpost sum pam l_inc poor epoor work female ///
educ indig cohab1 rururb [aw=weight] if after==0 & treat==1 ///
& tr==1
eststo control_AP: quietly estpost sum pam l_inc poor epoor work female ///
educ indig cohab1 rururb [aw=weight] if after==1 & treat==0 ///
& tr==1
eststo treat_AP: quietly estpost sum pam l_inc poor epoor work female ///
educ indig cohab1 rururb [aw=weight] if after==1 & treat==1 ///
& tr==1
eststo diff: quietly estpost ttest pam l_inc poor epoor work female ///
educ indig cohab1 rururb, by(treat) unequal 
esttab control_B treat_B control_A treat_A control_BP treat_BP control_AP treat_AP diff using "$gr\tab1.tex", ///
cells("mean(pattern(1 1 1 1 1 1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 0 0 0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace

/* Notes:

Fill in the last column of the table with the actual DDD estimate using
the following code for each variable y:
gen ddd=after*tr*treat
reg y ddd int1 int2 int3 treat tr after [aw=weight], vce(cluster geo)

Standard errors are clustered at the municipality level. To obtain the SE use 
the following code for each case:
reg y treat if after==(0,1) & tr==(0,1) [aw=weight], vce(cluster geo)
*/
*=====================================================================*
/* Table 2: The impact of the 2019 PAM expansion */
*=====================================================================*
/* Panel A. Combined effects: increment in cash transfer and 
universalization among elder without a contributory pension */
*=====================================================================*
eststo clear
eststo: areg pam int1 i.age i.year educ female indig ///
cohab1 i.loc_size if tr==0 [aw=weight], absorb(state) vce(cluster geo)
* Dependent variable: Income per capita
eststo: areg l_inc int1 i.age i.year educ female indig ///
cohab1 i.loc_size if tr==0 [aw=weight], absorb(state) vce(cluster geo)
* Dependent variable: Poverty. Welfare and minimum welfare lines
eststo: areg poor int1 i.age i.year educ female indig ///
cohab1 i.loc_size if tr==0 [aw=weight], absorb(state) vce(cluster geo)
eststo: areg epoor int1 i.age i.year educ female indig ///
cohab1 i.loc_size if tr==0 [aw=weight], absorb(state) vce(cluster geo)
* Dependent variable: Labor
eststo: areg work int1 i.age i.year educ female indig ///
cohab1 i.loc_size if tr==0 [aw=weight], absorb(state) vce(cluster geo)

esttab using "$gr\tab2A.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DDD estimations ///
(\autoref{eq:1})\label{tab2A}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(int1)
*=====================================================================*
/* Panel B. Combined effects: increment in cash transfer and 
universalization among elder with a contributory pension */
*=====================================================================*
eststo clear
eststo: areg pam int1 i.age i.year educ female indig ///
cohab1 i.loc_size if tr==1 [aw=weight], absorb(state) vce(cluster geo)
* Dependent variable: Income per capita
eststo: areg l_inc int1 i.age i.year educ female indig ///
cohab1 i.loc_size if tr==1 [aw=weight], absorb(state) vce(cluster geo)
* Dependent variable: Poverty. Welfare and minimum welfare lines
eststo: areg poor int1 i.age i.year educ female indig ///
cohab1 i.loc_size if tr==1 [aw=weight], absorb(state) vce(cluster geo)
eststo: areg epoor int1 i.age i.year educ female indig ///
cohab1 i.loc_size if tr==1 [aw=weight], absorb(state) vce(cluster geo)
* Dependent variable: Labor
eststo: areg work int1 i.age i.year educ female indig ///
cohab1 i.loc_size if tr==1 [aw=weight], absorb(state) vce(cluster geo)

esttab using "$gr\tab2B.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DDD estimations ///
(\autoref{eq:1})\label{tab2B}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(int1)
*=====================================================================*
/* Panel C. Isolating the universalization effects */
*=====================================================================*
gen ddd=after*tr*treat
* Dependent variable: Take up
eststo clear
eststo: areg pam ddd int1 int2 int3 treat tr i.year educ female indig i.age ///
cohab1 i.loc_size [aw=weight], absorb(state) vce(cluster geo)
* Dependent variable: Income per capita
eststo: areg l_inc ddd int1 int2 int3 treat tr i.year educ female indig i.age ///
cohab1 i.loc_size [aw=weight], absorb(state) vce(cluster geo)
* Dependent variable: Poverty. Welfare and minimum welfare lines
eststo: areg poor ddd int1 int2 int3 treat tr i.year educ female indig i.age ///
cohab1 i.loc_size [aw=weight], absorb(state) vce(cluster geo)
eststo: areg epoor ddd int1 int2 int3 treat tr i.year educ female indig i.age ///
cohab1 i.loc_size  [aw=weight], absorb(state) vce(cluster geo)
* Dependent variable: Labor
eststo: areg work ddd int1 int2 int3 treat tr i.year educ female indig i.age ///
cohab1 i.loc_size  [aw=weight], absorb(state) vce(cluster geo)

esttab using "$gr\tab2C.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DDD estimations ///
(\autoref{eq:1})\label{tab2C}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(ddd)

*=================================================================================*
                               /*DiD*/
*=================================================================================*
foreach x in 16 18 20 22 24 {
	gen treat_20`x'=0
    replace treat_20`x'=1 if treat==1 & year==20`x'
    label var treat_20`x' "20`x'"
}
replace treat_2018 = 0


/*PT Poverty/Extreme Poverty*/

eststo clear

eststo poverty_tr1: reg poor ///
    treat_20* treat after ///
    i.year i.age i.state i.loc_size ///
    state#year educ cohab1 female indig ///
    if tr==1 [aw=weight], vce(cluster geo)

eststo epoverty_tr1: reg epoor ///
    treat_20* treat after ///
    i.year i.age i.state i.loc_size ///
    state#year educ cohab1 female indig ///
    if tr==1 [aw=weight], vce(cluster geo)


eststo poverty_tr0: reg poor ///
    treat_20* treat after ///
    i.year i.age i.state i.loc_size ///
    state#year educ cohab1 female indig ///
    if tr==0 [aw=weight], vce(cluster geo)

eststo epoverty_tr0: reg epoor ///
    treat_20* treat after ///
    i.year i.age i.state i.loc_size ///
    state#year educ cohab1 female indig ///
    if tr==0 [aw=weight], vce(cluster geo)

coefplot ///
(poverty_tr1,  msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.20)) ///
(poverty_tr0,  msymbol(d) mcolor(cranberry) ciopts(recast(rcap) lcolor(cranberry)) offset(-0.05)) ///
(epoverty_tr1, msymbol(s) mcolor(gs10) ciopts(recast(rcap) lcolor(gs10)) offset(0.05)) ///
(epoverty_tr0, msymbol(t) mcolor("255 150 150") ciopts(recast(rcap) lcolor("255 150 150")) offset(0.20)), ///
vertical keep(treat_20*) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being in poverty", size(medsmall)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) ///
xlabel(, labs(medium)) ///
graphregion(color(white)) ///
scheme(s2mono) ///
ysc(r(-0.2 0.2)) ///
text(-0.218 2.24 "Jan 2019", size(small) place(se) nobox just(left)) ///
legend(order(2 "With Contributory pension - Poverty" ///
             4 "Without contributory pension - Poverty" ///
             6 "With Contributory pension - Extreme Poverty" ///
             8 "Without contributory pension - Extreme Poverty") ///
       pos(1) ring(0) col(1) size(vsmall))

graph export "$gr\DiD_poverty.png", replace

/*PT work*/

eststo clear

eststo work_tr1: reg work ///
    treat_20* treat after ///
    i.year i.age i.state i.loc_size ///
    state#year educ cohab1 female indig ///
    if tr==1 [aw=weight], vce(cluster geo)

eststo work_tr0: reg work ///
    treat_20* treat after ///
    i.year i.age i.state i.loc_size ///
    state#year educ cohab1 female indig ///
    if tr==0 [aw=weight], vce(cluster geo)

coefplot ///
(work_tr1, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(work_tr0, msymbol(d) mcolor(gs8)  ciopts(recast(rcap) lcolor(gs8))  offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of working", size(medium) height(5)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.3 0.3)) text(-0.31 2.08 "Jan 2019", ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "With Contributory Pension" 4 "Without Contributory Pension") cols(1) pos(1) ring(0) size(small))

graph export "$gr\DiD_work.png", replace

/*Income*/

eststo clear

eststo inc_tr1: reg l_inc ///
    treat_20* treat after ///
    i.year i.age i.state i.loc_size ///
    state#year educ cohab1 female indig ///
    if tr==1 [aw=weight], vce(cluster geo)

eststo inc_tr0: reg l_inc ///
    treat_20* treat after ///
    i.year i.age i.state i.loc_size ///
    state#year educ cohab1 female indig ///
    if tr==0 [aw=weight], vce(cluster geo)

coefplot ///
(inc_tr1, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(inc_tr0, msymbol(d) mcolor(gs8)  ciopts(recast(rcap) lcolor(gs8))  offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of income", size(medium) height(5)) ///
ylabel(-0.4(0.20)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) text(-0.415 2.08 "Jan 2019", ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "With Contributory Pension" 4 "Without Contributory Pension") cols(1) pos(4) ring(0) size(small))

graph export "$gr\DiD_income.png", replace


/*PT PAM*/

eststo clear

eststo pam_tr1: reg pam ///
    treat_20* treat after ///
    i.year i.age i.state i.loc_size ///
    state#year educ cohab1 female indig ///
    if tr==1 [aw=weight], vce(cluster geo)

eststo pam_tr0: reg pam ///
    treat_20* treat after ///
    i.year i.age i.state i.loc_size ///
    state#year educ cohab1 female indig ///
    if tr==0 [aw=weight], vce(cluster geo)

coefplot ///
(pam_tr1, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(pam_tr0, msymbol(d) mcolor(gs8)  ciopts(recast(rcap) lcolor(gs8))  offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of receiving PAM", size(medium) height(5)) ///
ylabel(-0.8(0.4)0.8, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.8 0.8)) text(-0.825 2.08 "Jan 2019", ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "With Contributory Pension" 4 "Without Contributory Pension") cols(1) pos(4) ring(0) size(small))

graph export "$gr\DiD_PAM.png", replace

/*PT INDEP*/

reg selfemp treat_20* treat after i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being self-employed", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) text(-0.208 2.09 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$gr\DiD_self.png", replace 


*=================================================================================*
                               /*TRIPLE DIFFERENCE*/
*=================================================================================*
drop treat_20*
foreach x in 16 18 20 22 24 {
	gen treat_20`x'=0
    replace treat_20`x'=1 if treat==1 & year==20`x' & tr==1
    label var treat_20`x' "20`x'"
}
replace treat_2018 = 0
*=================================================================================*
                               /*DDD BASE*/
*=================================================================================*

/*PT Poverty/Extreme Poverty*/

eststo poverty: reg poor treat_20* treat int1 int2 int3 after tr i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

eststo epoverty: reg epoor treat_20* treat int1 int2 int3 after tr i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot ///
(poverty, msymbol(o) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(-0.20)) ///
(epoverty, msymbol(d) mcolor("gs8")  ciopts(recast(rcap) lcolor("gs8"))  offset(-0.08)), ///
vertical keep(treat_20*) ///
byopts(cols(2) title("Likelihood of being in poverty")) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being in poverty", size(medsmall)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-0.2 0.2)) ///
text(-0.218 2.24 "Jan 2019", size(small) place(se) nobox just(left)) ///
legend(order(2 "Poverty" 4 "Extreme Poverty") pos(1) ring(0) col(1))
graph export "$gr\1EPOV_POV.png", replace

/*PT work*/

reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of working", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) text(-0.208 2.09 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$gr\1WORK.png", replace 

/*PT Income*/

reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle(" Percentage change of income", size(medium) height(5)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.3 0.3)) text(-0.31 2.09 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$gr\1INCOME.png", replace 

/*PAM*/

reg pam treat_20* int1 int2 int3 treat tr i.year after i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of receiving PAM", size(medium) height(5)) ///
ylabel(-0.6(0.3)0.6, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.6 0.6)) text(-0.623 2.09 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$gr\1PAM.png", replace 

/*TIME WORK*/

reg time_work treat_20* int1 int2 int3 treat tr i.year after i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Change in hours worked", size(medium) height(5)) ///
ylabel(-7(3.5)7, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-7 7)) text(-7.3 2.1 "Jan 2019", ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$gr\1TIMEWORK.png", replace 

/*TIME LEISURE*/

reg time_leisure treat_20* int1 int2 int3 treat tr i.year after i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Change in leisure hours", size(medium) height(5)) ///
ylabel(-5(2.5)5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-5 5)) text(-5.2 2.1 "Jan 2019", ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$gr\1TIMELEISURE.png", replace 

/*TOTAL EXPENDITURE*/

reg gasto_total treat_20* int1 int2 int3 treat tr i.year after i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of total expenditure", size(medium) height(5)) ///
ylabel(-0.6(0.3)0.6, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.6 0.6)) text(-0.623 2.09 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$gr\1TOTALEXPENDITURE.png", replace 


*============================*
*  PAM: 4 cuartiles en 1 fig
*============================*
eststo clear

eststo q1_pam: reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ female cohab1 indig if quartile==1 [aw=weight], vce(cluster geo)
eststo q2_pam: reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ female cohab1 indig if quartile==2 [aw=weight], vce(cluster geo)
eststo q3_pam: reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ female cohab1 indig if quartile==3 [aw=weight], vce(cluster geo)
eststo q4_pam: reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ female cohab1 indig if quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_pam, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_pam, msymbol(d) mcolor("gs10")  ciopts(recast(rcap) lcolor("gs10"))  offset(-0.08)) ///
(q3_pam, msymbol(s) mcolor("gs7")  ciopts(recast(rcap) lcolor("gs7"))  offset(0.08))  ///
(q4_pam, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) ///
byopts(cols(2) title("Likelihood of receiving PAM")) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of receiving PAM", size(medsmall)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-1 1)) ///
text(-1.08 2.264 "Jan 2019", size(small) place(se) nobox just(left)) ///
legend(order(2 "Q1" 4 "Q2" 6 "Q3" 8 "Q4") pos(4) ring(0) col(2) size(small))
graph export "$gr\2PAM_Q.png", replace

*============================*
*  TIME WORK: 4 cuartiles en 1 fig
*============================*

eststo clear

eststo q1_timework: reg time_work treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ female cohab1 indig if quartile==1 [aw=weight], vce(cluster geo)
eststo q2_timework: reg time_work treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ female cohab1 indig if quartile==2 [aw=weight], vce(cluster geo)
eststo q3_timework: reg time_work treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ female cohab1 indig if quartile==3 [aw=weight], vce(cluster geo)
eststo q4_timework: reg time_work treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ female cohab1 indig if quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_timework, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_timework, msymbol(d) mcolor("gs10")  ciopts(recast(rcap) lcolor("gs10"))  offset(-0.08)) ///
(q3_timework, msymbol(s) mcolor("gs7")  ciopts(recast(rcap) lcolor("gs7"))  offset(0.08))  ///
(q4_timework, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) ///
byopts(cols(2) title("Change in hours worked")) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Change in hours worked", size(medsmall)) ///
ylabel(-18(9)18, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-18 18)) ///
text(-19.5 2.264 "Jan 2019", size(small) place(se) nobox just(left)) legend(off) 
graph export "$gr\2TIMEWORK_Q.png", replace


*==============================*
*  WORK: 4 cuartiles en 1 fig
*==============================*
eststo clear

eststo q1_work: reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if quartile==1 [aw=weight], vce(cluster geo)
eststo q2_work: reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if quartile==2 [aw=weight], vce(cluster geo)
eststo q3_work: reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if quartile==3 [aw=weight], vce(cluster geo)
eststo q4_work: reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_work, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_work, msymbol(d) mcolor("gs10")  ciopts(recast(rcap) lcolor("gs10"))  offset(-0.08)) ///
(q3_work, msymbol(s) mcolor("gs7")  ciopts(recast(rcap) lcolor("gs7"))  offset(0.08))  ///
(q4_work, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of working", size(medsmall)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-0.5 0.5)) ///
text(-0.54 2.265 "Jan 2019", size(small) place(se) nobox just(left)) legend(off) 
graph export "$gr\2WORK_Q.png", replace

*==============================*
*  INACTIVE: 4 cuartiles en 1 fig
*==============================*

eststo clear

eststo q1_inactive: reg inactive treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if quartile==1 [aw=weight], vce(cluster geo)
eststo q2_inactive: reg inactive treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if quartile==2 [aw=weight], vce(cluster geo)
eststo q3_inactive: reg inactive treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if quartile==3 [aw=weight], vce(cluster geo)
eststo q4_inactive: reg inactive treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_inactive, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_inactive, msymbol(d) mcolor("gs10")  ciopts(recast(rcap) lcolor("gs10"))  offset(-0.08)) ///
(q3_inactive, msymbol(s) mcolor("gs7")  ciopts(recast(rcap) lcolor("gs7"))  offset(0.08))  ///
(q4_inactive, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being inactive", size(medsmall)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-0.5 0.5)) ///
text(-0.54 2.265 "Jan 2019", size(small) place(se) nobox just(left)) legend(off) 
graph export "$gr\2INACTIVE_Q.png", replace

*=================================================================================*
*=================================================================================*

                           
						   /*DDD SELF-EMPLOYED*/
						   
*=================================================================================*
*=================================================================================*

/*PT INDEP*/

reg selfemp treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being self-employed", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) text(-0.208 2.09 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$gr\3SELF-EMP.png", replace 


*=================================================================================*
*=================================================================================*

                           
						   /*DDD POBLACIÓN RURAL-URBANA*/
						   
*=================================================================================*
*=================================================================================*

* ==========================================================================
* COMPARACIÓN: Poverty y Extreme Poverty - Rural vs. Urbano
* ==========================================================================

eststo clear
eststo rur_pov: reg poor treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if rururb==1 [aw=weight], vce(cluster geo)
eststo rur_epov: reg epoor treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if rururb==1 [aw=weight], vce(cluster geo)
eststo urb_pov: reg poor treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if rururb==0 [aw=weight], vce(cluster geo)
eststo urb_epov: reg epoor treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if rururb==0 [aw=weight], vce(cluster geo)

coefplot ///
(urb_pov,  msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.20)) ///
(rur_pov,  msymbol(d) mcolor(cranberry) ciopts(recast(rcap) lcolor(cranberry)) offset(-0.05)) ///
(urb_epov, msymbol(s) mcolor(gs10) ciopts(recast(rcap) lcolor(gs10)) offset(0.05)) ///
(rur_epov, msymbol(t) mcolor("255 150 150") ciopts(recast(rcap) lcolor("255 150 150")) offset(0.20)), ///
vertical keep(treat_20*) ///
byopts(cols(2) title("Poverty & Extreme Poverty: Urban vs. Rural")) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being in poverty", size(medsmall)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-0.3 0.3)) ///
text(-0.325 2.25 "Jan 2019", size(small) place(se) nobox just(left)) ///
legend(order(2 "Urban Poverty" 4 "Rural Poverty" 6 "Urban Extreme Poverty" 8 "Rural Extreme Poverty") pos(1) ring(0) col(2) size(small))
graph export "$gr\4POV_RURURB.png", replace


* ==========================================================================
* COMPARACIÓN: Work - Rural vs. Urbano
* ==========================================================================

eststo clear
eststo rur_work: reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if rururb==1 [aw=weight], vce(cluster geo)
eststo urb_work: reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if rururb==0 [aw=weight], vce(cluster geo)

coefplot ///
(rur_work, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(urb_work, msymbol(d) mcolor(gs8)  ciopts(recast(rcap) lcolor(gs8))  offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of working", size(medium) height(5)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.3 0.3)) text(-0.31 2.08 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "Rural" 4 "Urban") cols(1) pos(1) ring(0) size(small))
graph export "$gr\4WORK_RURURB.png", replace


* ==========================================================================
* COMPARACIÓN: Income - Rural vs. Urbano
* ==========================================================================

eststo clear
eststo rur_inc: reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if rururb==1 [aw=weight], vce(cluster geo)
eststo urb_inc: reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if rururb==0 [aw=weight], vce(cluster geo)

coefplot ///
(rur_inc, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(urb_inc, msymbol(d) mcolor(gs8) ciopts(recast(rcap) lcolor(gs8)) offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle(" Percentage change of income", size(medium) height(5)) ///
ylabel(-0.8(0.4)0.8, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.8 0.8)) text(-0.823 2.09 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "Rural" 4 "Urban") cols(2) pos(1) ring(0) size(small))
graph export "$gr\4INCOME_RURURB.png", replace

* ==========================================================================
* COMPARACIÓN: PAM - Rural vs. Urbano
* ==========================================================================

eststo clear
eststo rur_pam: reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if rururb==1 [aw=weight], vce(cluster geo)
eststo urb_pam: reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if rururb==0 [aw=weight], vce(cluster geo)

coefplot ///
(rur_pam, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(urb_pam, msymbol(d) mcolor(gs8) ciopts(recast(rcap) lcolor(gs8)) offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of receiving PAM", size(medium) height(5)) ///
ylabel(-0.6(0.3)0.6, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.3 0.3)) text(-0.62 2.09 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "Rural" 4 "Urban") cols(2) pos(4) ring(0) size(small))
graph export "$gr\4PAM_RURURB.png", replace

*=================================================================================*
*=================================================================================*

                           
						   /*DDD COHABITACIÓN*/
						   
*=================================================================================*
*=================================================================================*

* ==========================================================================
* POVERTY / EXTREME POVERTY - Cohab vs No Cohab
* ==========================================================================
eststo clear
eststo pov_cohab:  reg poor  treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size indig if cohab1==1 [aw=weight], vce(cluster geo)
eststo pov_nocoh:  reg poor  treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size indig if cohab1==0  [aw=weight], vce(cluster geo)
eststo epov_cohab: reg epoor treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size indig if cohab1==1 [aw=weight], vce(cluster geo)
eststo epov_nocoh: reg epoor treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size indig if cohab1==0 [aw=weight], vce(cluster geo)

coefplot ///
(pov_cohab,  msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.20)) ///
(pov_nocoh,  msymbol(d) mcolor(cranberry) ciopts(recast(rcap) lcolor(cranberry)) offset(-0.05)) ///
(epov_cohab, msymbol(s) mcolor(gs10) ciopts(recast(rcap) lcolor(gs10)) offset(0.05)) ///
(epov_nocoh, msymbol(t) mcolor("255 150 150") ciopts(recast(rcap) lcolor("255 150 150")) offset(0.20)), ///
vertical keep(treat_20*) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of living in poverty", size(medsmall)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-0.3 0.3)) ///
text(-0.325 2.24 "Jan 2019", size(small) place(se) nobox just(left)) ///
legend(order(2 "Living with younger members Poverty" 4 "Only elderly Poverty" 6 "Living with younger members Extreme Poverty" 8 "Only elderly Extreme Poverty") pos(1) ring(0) col(2) size(vsmall))
graph export "$gr\5POV_COHAB.png", replace

* ==========================================================================
* WORK - Cohab vs No Cohab
* ==========================================================================

eststo clear
eststo work_cohab:  reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size indig if cohab1==1 [aw=weight], vce(cluster geo)
eststo work_nocoh:  reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size indig if cohab1==0 [aw=weight], vce(cluster geo)

coefplot ///
(work_cohab, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(work_nocoh, msymbol(d) mcolor(gs8)  ciopts(recast(rcap) lcolor(gs8))  offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of working", size(medium) height(5)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.3 0.3)) text(-0.31 2.08 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "Living with younger members" 4 "Only elderly") cols(1) pos(1) ring(0) size(small))
graph export "$gr\5WORK_COHAB.png", replace

* ==========================================================================
* INCOME - Cohab vs No Cohab
* ==========================================================================

eststo clear
eststo inc_cohab:  reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size indig if cohab1==1 [aw=weight], vce(cluster geo)
eststo inc_nocoh:  reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size indig if cohab1==0 [aw=weight], vce(cluster geo)

coefplot ///
(inc_cohab, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(inc_nocoh, msymbol(d) mcolor(gs8) ciopts(recast(rcap) lcolor(gs8)) offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle(" Percentage change of income", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(-0.515 2.07 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "Living with younger members" 4 "Only elderly") cols(1) pos(1) ring(0) size(small))
graph export "$gr\5INCOME_COHAB.png", replace


* ==========================================================================
* PAM - Cohab vs No Cohab
* ==========================================================================

eststo clear
eststo pam_cohab:  reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size indig if cohab1==1 [aw=weight], vce(cluster geo)
eststo pam_nocoh:  reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size indig if cohab1==0 [aw=weight], vce(cluster geo)

coefplot ///
(pam_cohab, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(pam_nocoh, msymbol(d) mcolor(gs8) ciopts(recast(rcap) lcolor(gs8)) offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of receiving PAM", size(medium) height(5)) ///
ylabel(-0.6(0.3)0.6, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.6 0.6)) text(-0.62 2.07 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "Living with younger members" 4 "Only elderly") cols(1) pos(4) ring(0) size(small))
graph export "$gr\5PAM_COHAB.png", replace

*=================================================================================*
*=================================================================================*

                           
						   /*DDD INDIGENOUS*/
						   
*=================================================================================*
*=================================================================================*

* ==========================================================================
* POVERTY / EXTREME POVERTY - Indigenous vs No Indigenous
* ==========================================================================
eststo clear
eststo pov_indig:  reg poor  treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if indig==1 [aw=weight], vce(cluster geo)
eststo pov_noindig:  reg poor  treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if indig==0  [aw=weight], vce(cluster geo)
eststo epov_indig: reg epoor treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if indig==1 [aw=weight], vce(cluster geo)
eststo epov_noindig: reg epoor treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if indig==0 [aw=weight], vce(cluster geo)

coefplot ///
(pov_indig,  msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.20)) ///
(pov_noindig,  msymbol(d) mcolor(cranberry) ciopts(recast(rcap) lcolor(cranberry)) offset(-0.05)) ///
(epov_indig, msymbol(s) mcolor(gs10) ciopts(recast(rcap) lcolor(gs10)) offset(0.05)) ///
(epov_noindig, msymbol(t) mcolor("255 150 150") ciopts(recast(rcap) lcolor("255 150 150")) offset(0.20)), ///
vertical keep(treat_20*) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of living in poverty", size(medsmall)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ysc(r(-0.3 0.3)) ///
text(-0.325 2.24 "Jan 2019", size(small) place(se) nobox just(left)) ///
legend(order(2 "Indigenous Poverty" 4 "Non-Indigenous Poverty" 6 "Indigenous Extreme Poverty" 8 "Non-Indigenous Extreme Poverty") pos(1) ring(0) col(2) size(vsmall))
graph export "$gr\6POV_INDIG.png", replace

* ==========================================================================
* WORK - Indig vs No Indig
* ==========================================================================

eststo clear
eststo work_indig:  reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if indig==1 [aw=weight], vce(cluster geo)
eststo work_noindig:  reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if indig==0 [aw=weight], vce(cluster geo)

coefplot ///
(work_indig, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(work_noindig, msymbol(d) mcolor(gs8)  ciopts(recast(rcap) lcolor(gs8))  offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of working", size(medium) height(5)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.3 0.3)) text(-0.31 2.08 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "Indigenous" 4 "Non-indigenous") cols(1) pos(1) ring(0) size(small))
graph export "$gr\6WORK_INDIG.png", replace

* ==========================================================================
* INCOME - Indig vs No Indig
* ==========================================================================

eststo clear
eststo inc_indig:    reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if indig==1 [aw=weight], vce(cluster geo)
eststo inc_noindig:  reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if indig==0 [aw=weight], vce(cluster geo)

coefplot ///
(inc_indig, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(inc_noindig, msymbol(d) mcolor(gs8) ciopts(recast(rcap) lcolor(gs8)) offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle(" Percentage change of income", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(-0.515 2.07 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "Indigenous" 4 "Non-indigenous") cols(1) pos(1) ring(0) size(small))
graph export "$gr\6INCOME_INDIG.png", replace


* ==========================================================================
* PAM - Indig vs No Indig
* ==========================================================================

eststo clear
eststo pam_indig:    reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if indig==1 [aw=weight], vce(cluster geo)
eststo pam_noindig:  reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if indig==0 [aw=weight], vce(cluster geo)

coefplot ///
(pam_indig, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(pam_noindig, msymbol(d) mcolor(gs8) ciopts(recast(rcap) lcolor(gs8)) offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of receiving PAM", size(medium) height(5)) ///
ylabel(-0.6(0.3)0.6, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.6 0.6)) text(-0.62 2.07 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "Indigenous" 4 "Non-indigenous") cols(1) pos(4) ring(0) size(small))
graph export "$gr\6PAM_INDIG.png", replace


*=================================================================================*
*=================================================================================*

                           
						   /*DDD DISABLED*/
						   
*=================================================================================*
*=================================================================================*

* ==========================================================================
* POVERTY / EXTREME POVERTY - Disabled vs No Disabled
* ==========================================================================
eststo clear
eststo pov_disabled:  reg poor  treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if disabled==1 [aw=weight], vce(cluster geo)
eststo pov_nodisabled:  reg poor  treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if disabled==0  [aw=weight], vce(cluster geo)
eststo epov_disabled: reg epoor treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if disabled==1 [aw=weight], vce(cluster geo)
eststo epov_nodisabled: reg epoor treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if disabled==0 [aw=weight], vce(cluster geo)

coefplot ///
(pov_disabled,  msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.20)) ///
(pov_nodisabled,  msymbol(d) mcolor(cranberry) ciopts(recast(rcap) lcolor(cranberry)) offset(-0.05)) ///
(epov_disabled, msymbol(s) mcolor(gs10) ciopts(recast(rcap) lcolor(gs10)) offset(0.05)) ///
(epov_nodisabled, msymbol(t) mcolor("255 150 150") ciopts(recast(rcap) lcolor("255 150 150")) offset(0.20)), ///
vertical keep(treat_20*) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of living in poverty", size(medsmall)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ysc(r(-0.3 0.3)) ///
text(-0.325 2.24 "Jan 2019", size(small) place(se) nobox just(left)) ///
legend(order(2 "With disability Poverty" 4 "Without disability Poverty" 6 "With disability Extreme Poverty" 8 "Without disability Extreme Poverty") pos(1) ring(0) col(2) size(vsmall))
graph export "$gr\7POV_disabled.png", replace

* ==========================================================================
* WORK - disabled vs No disabled
* ==========================================================================

eststo clear
eststo work_disabled:  reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if disabled==1 [aw=weight], vce(cluster geo)
eststo work_nodisabled:  reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if disabled==0 [aw=weight], vce(cluster geo)

coefplot ///
(work_disabled, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(work_nodisabled, msymbol(d) mcolor(gs8)  ciopts(recast(rcap) lcolor(gs8))  offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of working", size(medium) height(5)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.3 0.3)) text(-0.31 2.08 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "With disability" 4 "Without disability") cols(1) pos(1) ring(0) size(small))
graph export "$gr\7WORK_disabled.png", replace

* ==========================================================================
* INCOME - disabled vs No disabled
* ==========================================================================

eststo clear
eststo inc_disabled:    reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if disabled==1 [aw=weight], vce(cluster geo)
eststo inc_nodisabled:  reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if disabled==0 [aw=weight], vce(cluster geo)

coefplot ///
(inc_disabled, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(inc_nodisabled, msymbol(d) mcolor(gs8) ciopts(recast(rcap) lcolor(gs8)) offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle(" Percentage change of income", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(-0.515 2.07 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "With disability" 4 "Without disability") cols(1) pos(1) ring(0) size(small))
graph export "$gr\7INCOME_disabled.png", replace


* ==========================================================================
* PAM - disabled vs No disabled
* ==========================================================================

eststo clear
eststo pam_disabled:    reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if disabled==1 [aw=weight], vce(cluster geo)
eststo pam_nodisabled:  reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if disabled==0 [aw=weight], vce(cluster geo)

coefplot ///
(pam_disabled, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(pam_nodisabled, msymbol(d) mcolor(gs8) ciopts(recast(rcap) lcolor(gs8)) offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of receiving PAM", size(medium) height(5)) ///
ylabel(-0.6(0.3)0.6, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.6 0.6)) text(-0.62 2.07 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "With disability" 4 "Without disability") cols(1) pos(4) ring(0) size(small))
graph export "$gr\7PAM_disabled.png", replace

*==================================================================================*
*==================================================================================*
		
							/*WEALTH*/
							
*==================================================================================*
*==================================================================================*

eststo clear

reg wealth treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wealth", size(medium) height(5)) ///
ylabel(-0.03(0.015)0.03, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.03 0.03)) text(-0.031 2.09 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$gr\8Wealth.png", replace 


eststo clear

eststo q1_wealth: reg wealth treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if quartile==1 [aw=weight], vce(cluster geo)
eststo q2_wealth: reg wealth treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if quartile==2 [aw=weight], vce(cluster geo)
eststo q3_wealth: reg wealth treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if quartile==3 [aw=weight], vce(cluster geo)
eststo q4_wealth: reg wealth treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_wealth, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_wealth, msymbol(d) mcolor("gs10")  ciopts(recast(rcap) lcolor("gs10"))  offset(-0.08)) ///
(q3_wealth, msymbol(s) mcolor("gs7")  ciopts(recast(rcap) lcolor("gs7"))  offset(0.08))  ///
(q4_wealth, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) ///
yline(0) omitted baselevels ///
xline(2, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wealth", size(medsmall)) ///
ylabel(-0.05(0.025)0.05, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-0.05 0.05)) ///
legend(order(2 "Q1" 4 "Q2" 6 "Q3" 8 "Q4") pos(1) ring(0) col(2) size(small))
graph export "$gr\8Wealth_Q.png", replace


*=================================================================================*
*=================================================================================*

                           
						   /*DDD BORDER*/
						   
*=================================================================================*
*=================================================================================*

* ==========================================================================
* POVERTY / EXTREME POVERTY - Border vs No Border
* ==========================================================================
eststo clear
eststo pov_border:  reg poor  treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if border==1 [aw=weight], vce(cluster geo)
eststo pov_noborder:  reg poor  treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if border==0  [aw=weight], vce(cluster geo)
eststo epov_border: reg epoor treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if border==1 [aw=weight], vce(cluster geo)
eststo epov_noborder: reg epoor treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if border==0 [aw=weight], vce(cluster geo)

coefplot ///
(pov_border,  msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.20)) ///
(pov_noborder,  msymbol(d) mcolor(cranberry) ciopts(recast(rcap) lcolor(cranberry)) offset(-0.05)) ///
(epov_border, msymbol(s) mcolor(gs10) ciopts(recast(rcap) lcolor(gs10)) offset(0.05)) ///
(epov_noborder, msymbol(t) mcolor("255 150 150") ciopts(recast(rcap) lcolor("255 150 150")) offset(0.20)), ///
vertical keep(treat_20*) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of living in poverty", size(medsmall)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ysc(r(-0.5 0.5)) ///
text(-0.535 2.24 "Jan 2019", size(small) place(se) nobox just(left)) ///
legend(order(2 "Northern Border Poverty" 4 "Non-Northern Border Poverty" 6 "Northern Border Extreme Poverty" 8 "Non-Northern Border Extreme Poverty") pos(1) ring(0) col(2) size(vsmall))
graph export "$gr\9POV_border.png", replace

* ==========================================================================
* WORK - border vs No border
* ==========================================================================

eststo clear
eststo work_border:  reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if border==1 [aw=weight], vce(cluster geo)
eststo work_noborder:  reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if border==0 [aw=weight], vce(cluster geo)

coefplot ///
(work_border, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(work_noborder, msymbol(d) mcolor(gs8)  ciopts(recast(rcap) lcolor(gs8))  offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of working", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(-0.51 2.08 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "Northern border municipalities" 4 "Non-Northern Border municipalities") cols(1) pos(1) ring(0) size(small))
graph export "$gr\9WORK_border.png", replace

* ==========================================================================
* INCOME - border vs No border
* ==========================================================================

eststo clear
eststo inc_border:    reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if border==1 [aw=weight], vce(cluster geo)
eststo inc_noborder:  reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if border==0 [aw=weight], vce(cluster geo)

coefplot ///
(inc_border, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(inc_noborder, msymbol(d) mcolor(gs8) ciopts(recast(rcap) lcolor(gs8)) offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle(" Percentage change of income", size(medium) height(5)) ///
ylabel(-0.8(0.4)0.8, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) text(-0.815 2.07 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "Northern border municipalities" 4 "Non-Northern Border municipalities") cols(1) pos(1) ring(0) size(small))
graph export "$gr\9INCOME_border.png", replace


* ==========================================================================
* PAM - border vs No border
* ==========================================================================

eststo clear
eststo pam_border:    reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if border==1 [aw=weight], vce(cluster geo)
eststo pam_noborder:  reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size cohab1 if border==0 [aw=weight], vce(cluster geo)

coefplot ///
(pam_border, msymbol(o) mcolor(black) ciopts(recast(rcap) lcolor(black)) offset(-0.08)) ///
(pam_noborder, msymbol(d) mcolor(gs8) ciopts(recast(rcap) lcolor(gs8)) offset(0.08)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of receiving PAM", size(medium) height(5)) ///
ylabel(-0.6(0.3)0.6, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.6 0.6)) text(-0.62 2.07 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
legend(order(2 "Northern border municipalities" 4 "Non-Northern Border municipalities") cols(1) pos(4) ring(0) size(small))
graph export "$gr\9PAM_border.png", replace

*=================================================================================*

                               /*OTROS ANÁLISIS*/
							   
*=================================================================================*


*======================================*
*  CEREALES: 4 cuartiles en 1 fig
*======================================*
eststo clear

eststo q1_cereales: reg cereales_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==1 [aw=weight], vce(cluster geo)
eststo q2_cereales: reg cereales_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==2 [aw=weight], vce(cluster geo)
eststo q3_cereales: reg cereales_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==3 [aw=weight], vce(cluster geo)
eststo q4_cereales: reg cereales_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_cereales, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_cereales, msymbol(d) mcolor("gs10") ciopts(recast(rcap) lcolor("gs10")) offset(-0.08)) ///
(q3_cereales, msymbol(s) mcolor("gs7") ciopts(recast(rcap) lcolor("gs7")) offset(0.08)) ///
(q4_cereales, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change in monthly cereal expenditure", size(medsmall)) ///
ylabel(-2.5(1.25)2.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-1 1)) ///
text(-2.7 2.264 "Jan 2019", size(small) place(se) nobox just(left)) ///
legend(order(2 "Q1" 4 "Q2" 6 "Q3" 8 "Q4") pos(1) ring(0) col(2) size(small))
graph export "$gr\1HY_CEREALES_Q.png", replace

*======================================*
*  CARNES: 4 cuartiles en 1 fig
*======================================*
eststo clear

eststo q1_carnes: reg carnes_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==1 [aw=weight], vce(cluster geo)
eststo q2_carnes: reg carnes_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==2 [aw=weight], vce(cluster geo)
eststo q3_carnes: reg carnes_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==3 [aw=weight], vce(cluster geo)
eststo q4_carnes: reg carnes_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_carnes, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_carnes, msymbol(d) mcolor("gs10") ciopts(recast(rcap) lcolor("gs10")) offset(-0.08)) ///
(q3_carnes, msymbol(s) mcolor("gs7") ciopts(recast(rcap) lcolor("gs7")) offset(0.08)) ///
(q4_carnes, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change in monthly meat expenditure", size(medsmall)) ///
ylabel(-2.5(1.25)2.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-1 1)) ///
text(-2.7 2.264 "Jan 2019", size(small) place(se) nobox just(left)) legend(off)
graph export "$gr\2HY_CARNES_Q.png", replace

*======================================*
*  HUEVO: 4 cuartiles en 1 fig
*======================================*
eststo clear

eststo q1_huevo: reg huevo_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==1 [aw=weight], vce(cluster geo)
eststo q2_huevo: reg huevo_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==2 [aw=weight], vce(cluster geo)
eststo q3_huevo: reg huevo_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==3 [aw=weight], vce(cluster geo)
eststo q4_huevo: reg huevo_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_huevo, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_huevo, msymbol(d) mcolor("gs10") ciopts(recast(rcap) lcolor("gs10")) offset(-0.08)) ///
(q3_huevo, msymbol(s) mcolor("gs7") ciopts(recast(rcap) lcolor("gs7")) offset(0.08)) ///
(q4_huevo, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change in monthly egg expenditure", size(medsmall)) ///
ylabel(-4.5(2.25)4.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-1 1)) ///
text(-4.9 2.264 "Jan 2019", size(small) place(se) nobox just(left)) legend(off)
graph export "$gr\5HY_HUEVO_Q.png", replace

*======================================*
*  TUBERCULOS: 4 cuartiles en 1 fig
*======================================*
eststo clear

eststo q1_tuberculo: reg tuberculo_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==1 [aw=weight], vce(cluster geo)
eststo q2_tuberculo: reg tuberculo_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==2 [aw=weight], vce(cluster geo)
eststo q3_tuberculo: reg tuberculo_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==3 [aw=weight], vce(cluster geo)
eststo q4_tuberculo: reg tuberculo_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_tuberculo, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_tuberculo, msymbol(d) mcolor("gs10") ciopts(recast(rcap) lcolor("gs10")) offset(-0.08)) ///
(q3_tuberculo, msymbol(s) mcolor("gs7") ciopts(recast(rcap) lcolor("gs7")) offset(0.08)) ///
(q4_tuberculo, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change in monthly root vegeatables expenditure", size(medsmall)) ///
ylabel(-4.5(2.25)4.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-1 1)) ///
text(-4.9 2.264 "Jan 2019", size(small) place(se) nobox just(left)) legend(off) 
graph export "$gr\7HY_TUBERCULO_Q.png", replace


*======================================*
*  VERDURAS: 4 cuartiles en 1 fig
*======================================*
eststo clear

eststo q1_verduras: reg verduras_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==1 [aw=weight], vce(cluster geo)
eststo q2_verduras: reg verduras_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==2 [aw=weight], vce(cluster geo)
eststo q3_verduras: reg verduras_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==3 [aw=weight], vce(cluster geo)
eststo q4_verduras: reg verduras_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_verduras, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_verduras, msymbol(d) mcolor("gs10") ciopts(recast(rcap) lcolor("gs10")) offset(-0.08)) ///
(q3_verduras, msymbol(s) mcolor("gs7") ciopts(recast(rcap) lcolor("gs7")) offset(0.08)) ///
(q4_verduras, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change in monthly vegeatables expenditure", size(medsmall)) ///
ylabel(-4.5(2.25)4.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-1 1)) ///
text(-4.9 2.264 "Jan 2019", size(small) place(se) nobox just(left)) legend(off) 
graph export "$gr\8HY_VERDURAS_Q.png", replace

*======================================*
*  AZUCAR: 4 cuartiles en 1 fig
*======================================*
eststo clear

eststo q1_azucar: reg azucar_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==1 [aw=weight], vce(cluster geo)
eststo q2_azucar: reg azucar_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==2 [aw=weight], vce(cluster geo)
eststo q3_azucar: reg azucar_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==3 [aw=weight], vce(cluster geo)
eststo q4_azucar: reg azucar_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_azucar, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_azucar, msymbol(d) mcolor("gs10") ciopts(recast(rcap) lcolor("gs10")) offset(-0.08)) ///
(q3_azucar, msymbol(s) mcolor("gs7") ciopts(recast(rcap) lcolor("gs7")) offset(0.08)) ///
(q4_azucar, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change in monthly sugar expenditure", size(medsmall)) ///
ylabel(-4.5(2.25)4.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-1 1)) ///
text(-4.9 2.264 "Jan 2019", size(small) place(se) nobox just(left)) legend(off) 
graph export "$gr\10HY_AZUCAR_Q.png", replace

*======================================*
*  CALZADO
*======================================*
eststo clear
eststo q1_calzado: reg calzado_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==1 [aw=weight], vce(cluster geo)
eststo q2_calzado: reg calzado_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==2 [aw=weight], vce(cluster geo)
eststo q3_calzado: reg calzado_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==3 [aw=weight], vce(cluster geo)
eststo q4_calzado: reg calzado_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_calzado, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_calzado, msymbol(d) mcolor("gs10") ciopts(recast(rcap) lcolor("gs10")) offset(-0.08)) ///
(q3_calzado, msymbol(s) mcolor("gs7") ciopts(recast(rcap) lcolor("gs7")) offset(0.08)) ///
(q4_calzado, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change in monthly footwear expenditure", size(medsmall)) ///
ylabel(-4.8(2.4)4.8, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-1 1)) ///
text(-5.2 2.264 "Jan 2019", size(small) place(se) nobox just(left)) legend(off) 
graph export "$gr\14HY_CALZADO_Q.png", replace


*======================================*
*  MEDICAMENTOS Y SALUD
*======================================*
eststo clear

eststo q1_med: reg med_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==1 [aw=weight], vce(cluster geo)
eststo q2_med: reg med_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==2 [aw=weight], vce(cluster geo)
eststo q3_med: reg med_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==3 [aw=weight], vce(cluster geo)
eststo q4_med: reg med_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if hy==1 & quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_med, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_med, msymbol(d) mcolor("gs10") ciopts(recast(rcap) lcolor("gs10")) offset(-0.08)) ///
(q3_med, msymbol(s) mcolor("gs7") ciopts(recast(rcap) lcolor("gs7")) offset(0.08)) ///
(q4_med, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change in monthly medicine expenditure", size(medsmall)) ///
ylabel(-4.8(2.4)4.8, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-1 1)) ///
text(-5.2 2.264 "Jan 2019", size(small) place(se) nobox just(left)) ///
legend(order(2 "Q1" 4 "Q2" 6 "Q3" 8 "Q4") pos(1) ring(0) col(2) size(small))
graph export "$gr\15HY_MED_Q.png", replace


*======================================*
*  EDUCACION SUPERIOR
*======================================*
eststo clear

eststo q1_educsup: reg educ_superior_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_1930==1 & quartile==1 [aw=weight], vce(cluster geo)
eststo q2_educsup: reg educ_superior_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_1930==1 & quartile==2 [aw=weight], vce(cluster geo)
eststo q3_educsup: reg educ_superior_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_1930==1 & quartile==3 [aw=weight], vce(cluster geo)
eststo q4_educsup: reg educ_superior_monh treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_1930==1 & quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_educsup, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_educsup, msymbol(d) mcolor("gs10") ciopts(recast(rcap) lcolor("gs10")) offset(-0.08)) ///
(q3_educsup, msymbol(s) mcolor("gs7") ciopts(recast(rcap) lcolor("gs7")) offset(0.08)) ///
(q4_educsup, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Change in monthly higher education expenditure (%)", size(medsmall)) ///
ylabel(-4.8(2.4)4.8, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-1 1)) ///
text(-5.2 2.264 "Jan 2019", size(small) place(se) nobox just(left)) legend(off)
graph export "$gr\18HY_EDUCSUP_Q.png", replace

*======================================*
*  SCHOOL ATTENDANCE - 6-18
*======================================*
eststo clear

eststo q1_school: reg school_at treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_618==1 & quartile==1 [aw=weight], vce(cluster geo)
eststo q2_school: reg school_at treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_618==1 & quartile==2 [aw=weight], vce(cluster geo)
eststo q3_school: reg school_at treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_618==1 & quartile==3 [aw=weight], vce(cluster geo)
eststo q4_school: reg school_at treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_618==1 & quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_school, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_school, msymbol(d) mcolor("gs10") ciopts(recast(rcap) lcolor("gs10")) offset(-0.08)) ///
(q3_school, msymbol(s) mcolor("gs7") ciopts(recast(rcap) lcolor("gs7")) offset(0.08)) ///
(q4_school, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of attending school", size(medsmall)) ///
ylabel(-0.25(0.125)0.25, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-0.25 0.25)) ///
text(-0.275 2.264 "Jan 2019", size(small) place(se) nobox just(left)) legend(off) 
graph export "$gr\19HY_SCHOOLATT_618.png", replace

*======================================*
*  SCHOOL ATTENDANCE - 19-30
*======================================*
eststo clear

eststo q1_school: reg school_at treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_1930==1 & quartile==1 [aw=weight], vce(cluster geo)
eststo q2_school: reg school_at treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_1930==1 & quartile==2 [aw=weight], vce(cluster geo)
eststo q3_school: reg school_at treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_1930==1 & quartile==3 [aw=weight], vce(cluster geo)
eststo q4_school: reg school_at treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_1930==1 & quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_school, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_school, msymbol(d) mcolor("gs10") ciopts(recast(rcap) lcolor("gs10")) offset(-0.08)) ///
(q3_school, msymbol(s) mcolor("gs7") ciopts(recast(rcap) lcolor("gs7")) offset(0.08)) ///
(q4_school, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of attending school", size(medsmall)) ///
ylabel(-0.25(0.125)0.25, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-0.25 0.25)) ///
text(-0.275 2.264 "Jan 2019", size(small) place(se) nobox just(left)) legend(off) 
graph export "$gr\19HY_SCHOOLATT_1930.png", replace


*======================================*
*  Labor - 6-18
*======================================*
eststo clear

eststo q1_pea12: reg labor treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_618==1 & quartile==1 [aw=weight], vce(cluster geo)
eststo q2_pea12: reg labor treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_618==1 & quartile==2 [aw=weight], vce(cluster geo)
eststo q3_pea12: reg labor treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_618==1 & quartile==3 [aw=weight], vce(cluster geo)
eststo q4_pea12: reg labor treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_618==1 & quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_pea12, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_pea12, msymbol(d) mcolor("gs10") ciopts(recast(rcap) lcolor("gs10")) offset(-0.08)) ///
(q3_pea12, msymbol(s) mcolor("gs7") ciopts(recast(rcap) lcolor("gs7")) offset(0.08)) ///
(q4_pea12, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being in the labor force", size(medsmall)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-1 1)) ///
text(-1.1 2.264 "Jan 2019", size(small) place(se) nobox just(left)) legend(off) 
graph export "$gr\20HY_LABOR_618.png", replace


*======================================*
*  Labor - 19-30
*======================================*
eststo clear

eststo q1_pea12: reg labor treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_1930==1 & quartile==1 [aw=weight], vce(cluster geo)
eststo q2_pea12: reg labor treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_1930==1 & quartile==2 [aw=weight], vce(cluster geo)
eststo q3_pea12: reg labor treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_1930==1 & quartile==3 [aw=weight], vce(cluster geo)
eststo q4_pea12: reg labor treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_1930==1 & quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_pea12, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_pea12, msymbol(d) mcolor("gs10") ciopts(recast(rcap) lcolor("gs10")) offset(-0.08)) ///
(q3_pea12, msymbol(s) mcolor("gs7") ciopts(recast(rcap) lcolor("gs7")) offset(0.08)) ///
(q4_pea12, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being in the labor force", size(medsmall)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-1 1)) ///
text(-1.1 2.264 "Jan 2019", size(small) place(se) nobox just(left)) legend(off) 
graph export "$gr\20HY_LABOR_1930.png", replace



*======================================*
*  Labor - 19-30
*======================================*
eststo clear

eststo q1_pea12: reg labor treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_1930==1 & quartile==1 [aw=weight], vce(cluster geo)
eststo q2_pea12: reg labor treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_1930==1 & quartile==2 [aw=weight], vce(cluster geo)
eststo q3_pea12: reg labor treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_1930==1 & quartile==3 [aw=weight], vce(cluster geo)
eststo q4_pea12: reg labor treat_20* int1 int2 int3 treat tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig if age_1930==1 & quartile==4 [aw=weight], vce(cluster geo)

coefplot ///
(q1_pea12, msymbol(o) mcolor("gs13") ciopts(recast(rcap) lcolor("gs13")) offset(-0.20)) ///
(q2_pea12, msymbol(d) mcolor("gs10") ciopts(recast(rcap) lcolor("gs10")) offset(-0.08)) ///
(q3_pea12, msymbol(s) mcolor("gs7") ciopts(recast(rcap) lcolor("gs7")) offset(0.08)) ///
(q4_pea12, msymbol(t) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(0.20)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being in the labor force", size(medsmall)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-1 1)) ///
text(-1.1 2.264 "Jan 2019", size(small) place(se) nobox just(left)) legend(off)
graph export "$gr\20HY_LABOR_1930.png", replace



*=================================================================================*
                               
							   /*ROBUSTNESS CHECK*/
							   
*=================================================================================*

*=================================================================================*
                               /*TRIPLE DIFFERENCE*/
*=================================================================================*
drop treat_20*
foreach x in 16 18 20 22 24 {
    gen treat_20`x' = 0
    replace treat_20`x' = 1 if treat2==1 & year==20`x' & tr==1
    label var treat_20`x' "20`x'"
}

replace treat_2018 = 0
*=================================================================================*
                               /*DDD BASE*/
*=================================================================================*

/*PT Poverty/Extreme Poverty*/

eststo poverty: reg poor treat_20* int12 int22 int32 treat2 tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

eststo epoverty: reg epoor treat_20* int12 int22 int32 treat2 tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot ///
(poverty, msymbol(o) mcolor("black") ciopts(recast(rcap) lcolor("black")) offset(-0.20)) ///
(epoverty, msymbol(d) mcolor("gs8")  ciopts(recast(rcap) lcolor("gs8"))  offset(-0.08)), ///
vertical keep(treat_20*) ///
byopts(cols(2) title("Likelihood of being in poverty")) ///
yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being in poverty", size(medsmall)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-0.3 0.3)) ///
text(-0.325 2.24 "Jan 2019", size(small) place(se) nobox just(left)) ///
legend(order(2 "Poverty" 4 "Extreme Poverty") pos(1) ring(0) col(1))
graph export "$gr\RC2EPOV_POV.png", replace

/*PT work*/

reg work treat_20* int12 int22 int32 treat2 tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of working", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) text(-0.208 2.09 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$gr\RC2WORK.png", replace 

/*PT Income*/

reg l_inc treat_20* int12 int22 int32 treat2 tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle(" Percentage change of income", size(medium) height(5)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.3 0.3)) text(-0.31 2.09 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$gr\RC2INCOME.png", replace 

/*PAM*/

reg pam treat_20* int12 int22 int32 treat2 tr after i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of receiving PAM", size(medium) height(5)) ///
ylabel(-0.6(0.3)0.6, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.6 0.6)) text(-0.623 2.09 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$gr\RC2PAM.png", replace 





