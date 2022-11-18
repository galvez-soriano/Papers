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
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_ags
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_ags
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_ags

use "$base\eng_abil.dta", clear
keep if state=="05" | state=="08"
gen treat=state=="05"
gen after=cohort>=1988
replace after=. if cohort<1979 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_coah
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_coah
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_coah
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_coah

use "$base\eng_abil.dta", clear
keep if state=="10" | state=="24"
gen treat=state=="10"
gen after=cohort>=1991
replace after=. if cohort<1985 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_dgo
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_dgo
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_dgo
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_dgo

use "$base\eng_abil.dta", clear
keep if state=="19" | state=="24"
gen treat=state=="19"
gen after=cohort>=1987
replace after=. if cohort<1981 | cohort>1996
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_nl
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_nl
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_nl
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_nl

use "$base\eng_abil.dta", clear
keep if state=="25" | state=="18"
gen treat=state=="25"
gen after=cohort>=1993
replace after=. if cohort<1989 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_sin
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_sin
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_sin
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_sin

use "$base\eng_abil.dta", clear
keep if state=="26" | state=="02" | state=="08"
gen treat=state=="26"
gen after=cohort>=1993
replace after=. if cohort<1991 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_son
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_son
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_son
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_son

use "$base\eng_abil.dta", clear
keep if state=="28" | state=="02"
gen treat=state=="28"
gen after=cohort>=1990
replace after=. if cohort<1983 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_tam
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_tam
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_tam
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_tam

label var after_treat "Mexican states with English programs"
coefplot (hrs_ags, label(AGS)) ///
(hrs_coah, label(COAH)) ///
(hrs_coah, label(DGO)) ///
(hrs_coah, label(NL)) ///
(hrs_coah, label(SIN)) ///
(hrs_coah, label(SON)) ///
(hrs_coah, label(TAM)), ///
vertical keep(after_treat) yline(0) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-0.5(0.5)1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(3) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graphDDhrs.png", replace 

coefplot (eng_ags, label(AGS)) ///
(eng_coah, label(COAH)) ///
(eng_coah, label(DGO)) ///
(eng_coah, label(NL)) ///
(eng_coah, label(SIN)) ///
(eng_coah, label(SON)) ///
(eng_coah, label(TAM)), ///
vertical keep(after_treat) yline(0) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graphDDeng.png", replace 

coefplot (paid_ags, label(AGS)) ///
(paid_coah, label(COAH)) ///
(paid_coah, label(DGO)) ///
(paid_coah, label(NL)) ///
(paid_coah, label(SIN)) ///
(paid_coah, label(SON)) ///
(paid_coah, label(TAM)), ///
vertical keep(after_treat) yline(0) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graphDDpaid.png", replace 

coefplot (wage_ags, label(AGS)) ///
(wage_coah, label(COAH)) ///
(wage_coah, label(DGO)) ///
(wage_coah, label(NL)) ///
(wage_coah, label(SIN)) ///
(wage_coah, label(SON)) ///
(wage_coah, label(TAM)), ///
vertical keep(after_treat) yline(0) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
legend( off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graphDDwage.png", replace 

