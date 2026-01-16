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
/* Panel A. Combined effects: increment in cash transfer and universalization */
*=====================================================================*
eststo clear
eststo: areg pam int1 i.age i.year educ female indig ///
cohab1 i.loc_size [aw=weight], absorb(state) vce(cluster geo)
* Dependent variable: Income per capita
eststo: areg l_inc int1 i.age i.year educ female indig ///
cohab1 i.loc_size [aw=weight], absorb(state) vce(cluster geo)
* Dependent variable: Poverty. Welfare and minimum welfare lines
eststo: areg poor int1 i.age i.year educ female indig ///
cohab1 i.loc_size [aw=weight], absorb(state) vce(cluster geo)
eststo: areg epoor int1 i.age i.year educ female indig ///
cohab1 i.loc_size [aw=weight], absorb(state) vce(cluster geo)
* Dependent variable: Labor
eststo: areg work int1 i.age i.year educ female indig ///
cohab1 i.loc_size [aw=weight], absorb(state) vce(cluster geo)

esttab using "$gr\tab2A.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DDD estimations ///
(\autoref{eq:1})\label{tab2A}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(int1)
*=====================================================================*
/* Panel B. Isolating the universalization effects */
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

esttab using "$gr\tab2B.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DDD estimations ///
(\autoref{eq:1})\label{tab2B}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
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

eststo poverty: reg poor treat_20* i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

eststo epoverty: reg epoor treat_20* i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

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
graph export "$gr\DiD_poverty.png", replace

/*PT work*/

reg work treat_20* i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of working", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) text(-0.208 2.09 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$gr\DiD_work.png", replace 

/*PT Income*/

reg l_inc treat_20* i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle(" Percentage change of income", size(medium) height(5)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.3 0.3)) text(-0.31 2.09 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$gr\DiD_income.png", replace 

/*PAM*/

reg pam treat_20* i.year after i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.51, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of receiving PAM", size(medium) height(5)) ///
ylabel(-0.6(0.3)0.6, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.6 0.6)) text(-0.623 2.09 "Jan 2019",   ///
size(small) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$gr\DiD_PAM.png", replace 

/*PT INDEP*/

reg selfemp treat_20* i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

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

eststo poverty: reg poor treat_20* int1 int2 int3 after tr i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

eststo epoverty: reg epoor treat_20* int1 int2 int3 after tr i.year i.age i.state i.loc_size state#year educ cohab1 female indig [aw=weight], vce(cluster geo)

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
xline(2.53, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of working", size(medsmall)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-0.5 0.5)) ///
text(-0.54 2.265 "Jan 2019", size(small) place(se) nobox just(left)) ///
legend(order(2 "Q1" 4 "Q2" 6 "Q3" 8 "Q4") pos(1) ring(0) col(2) size(small))
graph export "$gr\2WORK_Q.png", replace


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
eststo epov_nocoh: reg epoor treat_20* int1 int2 int3 treat tr i.year i.age i.state state#year educ female i.loc_size indig if cohab1==0 [aw=weight], vce(cluster geo)

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
eststo pov_indig:  reg poor  treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if indig==1 [aw=weight], vce(cluster geo)
eststo pov_noindig:  reg poor  treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if indig==0  [aw=weight], vce(cluster geo)
eststo epov_indig: reg epoor treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if indig==1 [aw=weight], vce(cluster geo)
eststo epov_noindig: reg epoor treat_20* int1 int2 int3 treat tr i.year i.age i.state state#year educ female i.loc_size if indig==0 [aw=weight], vce(cluster geo)

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
eststo work_indig:  reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if indig==1 [aw=weight], vce(cluster geo)
eststo work_noindig:  reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if indig==0 [aw=weight], vce(cluster geo)

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
eststo inc_indig:    reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if indig==1 [aw=weight], vce(cluster geo)
eststo inc_noindig:  reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if indig==0 [aw=weight], vce(cluster geo)

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
eststo pam_indig:    reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if indig==1 [aw=weight], vce(cluster geo)
eststo pam_noindig:  reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if indig==0 [aw=weight], vce(cluster geo)

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
eststo pov_disabled:  reg poor  treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if disabled==1 [aw=weight], vce(cluster geo)
eststo pov_nodisabled:  reg poor  treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if disabled==0  [aw=weight], vce(cluster geo)
eststo epov_disabled: reg epoor treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if disabled==1 [aw=weight], vce(cluster geo)
eststo epov_nodisabled: reg epoor treat_20* int1 int2 int3 treat tr i.year i.age i.state state#year educ female i.loc_size if disabled==0 [aw=weight], vce(cluster geo)

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
eststo work_disabled:  reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if disabled==1 [aw=weight], vce(cluster geo)
eststo work_nodisabled:  reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if disabled==0 [aw=weight], vce(cluster geo)

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
eststo inc_disabled:    reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if disabled==1 [aw=weight], vce(cluster geo)
eststo inc_nodisabled:  reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if disabled==0 [aw=weight], vce(cluster geo)

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
eststo pam_disabled:    reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if disabled==1 [aw=weight], vce(cluster geo)
eststo pam_nodisabled:  reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if disabled==0 [aw=weight], vce(cluster geo)

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
ysc(r(-0.015 0.015)) text(-0.031 2.09 "Jan 2019",   ///
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
xline(4, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wealth", size(medsmall)) ///
ylabel(-0.05(0.025)0.05, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ysc(r(-0.005 0.005)) ///
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
eststo pov_border:  reg poor  treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if border==1 [aw=weight], vce(cluster geo)
eststo pov_noborder:  reg poor  treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if border==0  [aw=weight], vce(cluster geo)
eststo epov_border: reg epoor treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if border==1 [aw=weight], vce(cluster geo)
eststo epov_noborder: reg epoor treat_20* int1 int2 int3 treat tr i.year i.age i.state state#year educ female i.loc_size if border==0 [aw=weight], vce(cluster geo)

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
eststo work_border:  reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if border==1 [aw=weight], vce(cluster geo)
eststo work_noborder:  reg work treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if border==0 [aw=weight], vce(cluster geo)

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
eststo inc_border:    reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if border==1 [aw=weight], vce(cluster geo)
eststo inc_noborder:  reg l_inc treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if border==0 [aw=weight], vce(cluster geo)

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
eststo pam_border:    reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if border==1 [aw=weight], vce(cluster geo)
eststo pam_noborder:  reg pam treat_20* int1 int2 int3 treat tr after i.year i.age i.state state#year educ female i.loc_size if border==0 [aw=weight], vce(cluster geo)

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


