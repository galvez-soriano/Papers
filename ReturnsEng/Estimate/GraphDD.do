*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/data/main"
gl base= "C:\Users\ogalvezs\Documents\Returns to Eng\Data"
gl doc= "C:\Users\ogalvezs\Documents\Returns to Eng\Doc"

*========================================================================*
/* TABLE 7: Intention to Treat Effect */
*========================================================================*
eststo clear

use "$base\eng_abil.dta", clear
keep if state=="01" | state=="32"
gen treat=state=="01"
gen after=cohort>=1990
replace after=. if cohort<1986 | cohort>1995
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_ags

use "$base\eng_abil.dta", clear
keep if state=="05" | state=="08"
gen treat=state=="05"
gen after=cohort>=1988
replace after=. if cohort<1979 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_coah

coefplot (hrs_ags, label(Aguascalientes) offset(-.03)) (hrs_coah, ciopt(lc(black) ///
recast(rcap)) label(Coahuila) offset(.03) m(T) mcolor(white) mlcolor(black)), ///
vertical keep(after_treat) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.20, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) text(-0.21 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\graph2.png", replace 