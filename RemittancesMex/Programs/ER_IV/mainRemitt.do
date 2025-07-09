*=====================================================================*
/* Paper: Income effect and labor market outcomes: The role of remittances 
		  in Mexico
   Author: Oscar Galvez-Soriano */
*=====================================================================*
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Doc"
*=====================================================================*
/*
use "$data/Papers/main/RemittancesMex/Data/dbaseRemitt_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 {
    append using "$data/Papers/main/RemittancesMex/Data/dbaseRemitt_`x'.dta"
}
save "$base\dbaseRemitt.dta", replace 
*/
*=====================================================================*
use "$base\dbaseRemitt.dta", clear

/* Creating self-employment variable and employee variables */
gen self_empl=main_jobt>=2
replace self_empl=. if work==0
gen employee=self_empl==0

/* keep year remit treat poor epoor work self_empl employee formal labor loc_size hhsize age female weight geo 
order geo year 
bsample 300000
*/

gen after=year>=2020
gen treat_after=treat*after
replace remit=remit/1000

foreach x in 16 18 20 22{
gen treat_20`x'=0
replace treat_20`x'=1 if treat==1 & year==20`x'
label var treat_20`x' "20`x'"
}
replace treat_2018=0

areg poor treat_20* i.year i.loc_size hhsize age female if age>=18 & age<=65 [aw=weight], absorb(geo) vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being in poverty", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) 
graph export "$doc\PTA_poor.png", replace

areg epoor treat_20* i.year i.loc_size hhsize age female if age>=18 & age<=65 [aw=weight], absorb(geo) vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being in extreme poverty", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) 
graph export "$doc\PTA_epoor.png", replace

reghdfe remit treat_20* i.year i.loc_size hhsize age female if age>=18 & age<=65 [aw=weight], absorb(geo) vce(cluster geo) 

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Remittances in dollars", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) 
graph export "$doc\PTA_remitt.png", replace

*=====================================================================*

areg work treat_20* i.year i.loc_size hhsize age female if age>=18 & age<=65 [aw=weight], absorb(geo) vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having a job", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2))
graph export "$doc\PTA_work.png", replace

/* Creating indicator for having a second job */
gen secondj=second_jobt!=.
replace secondj=. if work==0
/* Creating self-employment variable for secondary job */
gen self_empls=second_jobt>=2
replace self_empls=. if work==0

areg self_empl treat_20* i.year i.loc_size hhsize age female if age>=18 & age<=65 & work==1 [aw=weight], absorb(geo) vce(cluster geo) 
estimates store TWFE_self
areg employee treat_20* i.year i.loc_size hhsize age female if age>=18 & age<=65 & work==1 [aw=weight], absorb(geo) vce(cluster geo) 
estimates store TWFE_employee

coefplot ///
(TWFE_self, offset(-0.1) label(Self-employed) msize(small) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)) ///
(TWFE_employee, label(Empleyee) msize(small) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(navy)) lc(navy)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being a self-employed/employee", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(pos(5) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1))
graph export "$doc\PTA_selfempl.png", replace


areg secondj treat_20* i.year i.loc_size hhsize age female if age>=18 & age<=65 & work==1 [aw=weight], absorb(geo) vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of havig a second job", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2))

areg self_empls treat_20* i.year i.loc_size hhsize age female if age>=18 & age<=65 & work==1 [aw=weight], absorb(geo) vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being a self-employed in secondary job", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2))


areg formal treat_20* i.year i.loc_size hhsize age female if age>=18 & age<=65 [aw=weight], absorb(geo) vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having a formal job", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2))

areg labor treat_20* i.year i.loc_size hhsize age female if age>=18 & age<=65 [aw=weight], absorb(geo) vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood belonging to labor force", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2))


*=====================================================================*

areg poori treat_20* i.year i.loc_size age female if age>=18 & age<=65 [aw=weight], absorb(geo) vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being in poverty", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) 


areg epoori treat_20* i.year i.loc_size age female if age>=18 & age<=65 [aw=weight], absorb(geo) vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being in extreme poverty", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) 