*=====================================================================*
/* Paper: Income effect and labor market outcomes: The role of remittances 
		  in Mexico
   Authors: Oscar Galvez-Soriano and Hoanh Le */
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
foreach x in 16 18 20 22 {
use "$base\dbaseRemitt.dta", clear

keep if year==20`x'
destring geo, replace

ineqdeco ictpc [aw=weight], bygroup(geo)
return list
tempfile gnxl
postfile results geo ge2 gini using "`gnxl'"
foreach f in `r(levels)' {
    post results (`f') (r(ge2_`f')) (r(gini_`f'))
}
postclose results
use "`gnxl'", clear
list, clean noobs

tostring geo, replace format(%05.0f)
gen year=20`x'
keep geo year gini

save "$base\GiniIndex20`x'.dta", replace
}
*=====================================================================*
use "$base\GiniIndex2016.dta", clear
foreach x in 18 20 22 {
append using "$base\GiniIndex20`x'.dta"
}
sort geo year
save "$base\GiniIndex.dta", replace
*=====================================================================*
use "$base\dbaseRemitt.dta", clear

/* Creating self-employment variable and employee variables */
gen self_empl=main_jobt>=2
replace self_empl=. if work==0
gen employee=self_empl==0


collapse state poor epoor remittan work age female self_empl employee treat formal [fw=weight], by(geo year)

merge 1:1 geo year using "$base\GiniIndex.dta", nogen

/* keep year remit treat poor epoor work self_empl employee formal labor loc_size hhsize age female weight geo 
order geo year 
bsample 300000
*/

gen after=year>=2020
gen treat_after=treat*after
*replace remit=remit/1000

foreach x in 16 18 20 22{
gen treat_20`x'=0
replace treat_20`x'=1 if treat==1 & year==20`x'
label var treat_20`x' "20`x'"
}
replace treat_2018=0

reghdfe poor treat_20* i.year, absorb(geo state#year) vce(cluster geo) 

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being in poverty", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) 
graph export "$doc\PTA_poor.png", replace

reghdfe epoor treat_20* i.year, absorb(geo state#year) vce(cluster geo) 

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being in extreme poverty", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) 
graph export "$doc\PTA_epoor.png", replace

reghdfe remittan treat_20* i.year, absorb(geo state#year) vce(cluster geo) 

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Remittances in dollars", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) 
graph export "$doc\PTA_remitt.png", replace

*=====================================================================*

reghdfe work treat_20* i.year, absorb(geo state#year) vce(cluster geo) 

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having a job", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2))
graph export "$doc\PTA_work.png", replace

reghdfe self_empl treat_20* i.year, absorb(geo state#year) vce(cluster geo) 
estimates store TWFE_self
reghdfe employee treat_20* i.year, absorb(geo state#year) vce(cluster geo) 
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


reghdfe formal treat_20* i.year, absorb(geo state#year) vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having a formal job", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2))

reghdfe gini treat_20* i.year, absorb(geo state#year) vce(cluster geo) 

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Change in Gini index", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1))
