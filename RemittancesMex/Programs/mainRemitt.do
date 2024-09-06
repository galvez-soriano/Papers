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
use "$base\dbaseRemitt.dta", clear

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


areg epoor treat_20* i.year i.loc_size hhsize age female if age>=18 & age<=65 [aw=weight], absorb(geo) vce(cluster geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of being in extreme poverty", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) 

*=====================================================================*



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


areg remit treat_20* i.year i.loc_size hhsize age female if age>=18 & age<=65 [aw=weight], absorb(geo) vce(cluster geo) 

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Remittances in thousands of pesos", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) 

/* Other controls: i.loc_size age female */
