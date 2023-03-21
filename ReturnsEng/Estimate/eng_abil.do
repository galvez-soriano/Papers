*========================================================================*
/* English skills and labor market outcomes in Mexico */
*========================================================================*
/* Author: Oscar Galvez-Soriano */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/ReturnsEng/Data"
gl base= "C:\Users\iscot\Documents\GalvezSoriano\Papers\EngSkills\Data"
gl doc= "C:\Users\iscot\Documents\GalvezSoriano\Papers\EngSkills\Doc"
*========================================================================*
/* TABLE 3: Returns to English abilities in Mexico */
*========================================================================*
use "$data/eng_abil.dta", clear
/* Panel A: Full sample */
eststo clear
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if age>=18 ///
& age<=65 & paidw==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous i.edu [aw=weight] if ///
age>=18 & age<=65 & paidw==1, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1 & edu>9, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu>9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
/* Panel B: Men */
eststo clear
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1 & female==0, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if age>=18 ///
& age<=65 & paidw==1 & female==0, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous i.edu [aw=weight] if ///
age>=18 & age<=65 & paidw==1 & female==0, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & female==0, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & female==0, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9 & female==0, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9 & female==0, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1 & edu>9 & female==0, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu>9 & female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
/* Panel C: Women */
eststo clear
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1 & female==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if age>=18 ///
& age<=65 & paidw==1 & female==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous i.edu [aw=weight] if ///
age>=18 & age<=65 & paidw==1 & female==1, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & female==1, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & female==1, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9 & female==1, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9 & female==1, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1 & edu>9 & female==1, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu>9 & female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
/* Difference in estimate by gender */
gen eng_female=eng*female
gen cohort_fem=cohort*female
gen edu_fem=edu*female
gen state_fem=state*female
gen geo_fem=geo*female

eststo clear
eststo: reg lwage eng_female eng female [aw=weight] if age>=18 & age<=65 & paidw==1, vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous [aw=weight] if age>=18 ///
& age<=65 & paidw==1, absorb(cohort cohort_fem) vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous [aw=weight] if ///
age>=18 & age<=65 & paidw==1, absorb(cohort cohort_fem edu edu_fem) vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1, absorb(cohort cohort_fem edu edu_fem state state_fem) vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1, absorb(cohort cohort_fem edu edu_fem geo geo_fem) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng_female eng female [aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9, vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9, absorb(cohort cohort_fem edu edu_fem geo geo_fem) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng_female eng female [aw=weight] if age>=18 & age<=65 & paidw==1 & edu>9, vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu>9, absorb(cohort cohort_fem edu edu_fem geo geo_fem) vce(cluster geo)
esttab using "$doc\tab_returns_eng_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(eng_female) replace
*========================================================================*
/* Interaction speaks Eng and education */
/* Education */
*========================================================================*
gen edu_level=0
replace edu_level=1 if edu>=1 & edu<=5
replace edu_level=2 if edu==6
replace edu_level=3 if edu>=7 & edu<=8
replace edu_level=4 if edu==9
replace edu_level=5 if edu>=10 & edu<=12
replace edu_level=6 if edu>=13 & edu<=16
replace edu_level=7 if edu>=17

gen eng_edu=eng*edu_level
foreach x in 0 1 2 3 4 5 6 7{
gen engedu`x'=eng_edu==`x'
}
replace engedu0=0
label var engedu0 "No-edu"
label var engedu1 "Elem-drop"
label var engedu2 "Elem S"
label var engedu3 "Middle-drop"
label var engedu4 "Middle S"
label var engedu5 "High S"
label var engedu6 "College"
label var engedu7 "Graduate"
areg lwage eng i.cohort i.edu female rural married engedu* indigenous ///
[aw=weight] if age>=18 & age<=65 & paidw==1, absorb(geo) vce(cluster geo)

graph set window fontface "Times New Roman"
coefplot, vertical keep(engedu*) yline(0) omitted baselevels ///
ytitle("Returns to English abilities by education levels", size(small) height(5)) ///
ylabel(-4(2)4, labs(small) grid) ///
xtitle("Levels of education", size(small) height(5)) xlabel(,labs(small)) ///
graphregion(color(white)) scheme(s2mono) recast(connected) ciopts(recast(rcap)) ///
ysc(r(-0.5 1)) levels(90)
graph export "$doc\eng_abil_edu.png", replace 
*========================================================================*
/* FIGURE 4. ITT of offering English instruction (DD estimates by state) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="01" | state=="32"
gen treat=state=="01"
gen after=cohort>=1990
replace after=. if cohort<1986 | cohort>1995
gen after_treat=after*treat

quietly areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_ags
quietly areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_ags
quietly areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_ags
quietly areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_ags

use "$data/eng_abil.dta", clear
keep if state=="05" | state=="08"
gen treat=state=="05"
gen after=cohort>=1988
replace after=. if cohort<1979 | cohort>1996 
gen after_treat=after*treat

quietly areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_coah
quietly areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_coah
quietly areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_coah
quietly areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_coah

use "$data/eng_abil.dta", clear
keep if state=="10" | state=="24"
gen treat=state=="10"
gen after=cohort>=1991
replace after=. if cohort<1985 | cohort>1996 
gen after_treat=after*treat

quietly areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_dgo
quietly areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_dgo
quietly areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_dgo
quietly areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_dgo

use "$data/eng_abil.dta", clear
keep if state=="19" | state=="24"
gen treat=state=="19"
gen after=cohort>=1987
replace after=. if cohort<1981 | cohort>1996
gen after_treat=after*treat

quietly areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_nl
quietly areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_nl
quietly areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_nl
quietly areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_nl

use "$data/eng_abil.dta", clear
keep if state=="25" | state=="18"
gen treat=state=="25"
gen after=cohort>=1993
replace after=. if cohort<1989 | cohort>1996 
gen after_treat=after*treat

quietly areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_sin
quietly areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_sin
quietly areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_sin
quietly areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_sin

use "$data/eng_abil.dta", clear
keep if state=="26" | state=="02" | state=="08"
gen treat=state=="26"
gen after=cohort>=1993
replace after=. if cohort<1991 | cohort>1996 
gen after_treat=after*treat

quietly areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_son
quietly areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_son
quietly areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_son
quietly areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_son

use "$data/eng_abil.dta", clear
keep if state=="28" | state=="02"
gen treat=state=="28"
gen after=cohort>=1990
replace after=. if cohort<1983 | cohort>1996 
gen after_treat=after*treat

quietly areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_tam
quietly areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_tam
quietly areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_tam
quietly areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_tam

label var after_treat "Mexican states with English programs"
/* PANEL (a) Hours of English */
coefplot (hrs_ags, label(AGS)) ///
(hrs_coah, label(COAH)) ///
(hrs_dgo, label(DGO)) ///
(hrs_nl, label(NL)) ///
(hrs_sin, label(SIN)) ///
(hrs_son, label(SON)) ///
(hrs_tam, label(TAM)), ///
vertical keep(after_treat) yline(0) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-0.5(0.5)1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(3) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graphDDhrs.png", replace 
/* PANEL (b) English skills */
coefplot (eng_ags, label(AGS)) ///
(eng_coah, label(COAH)) ///
(eng_dgo, label(DGO)) ///
(eng_nl, label(NL)) ///
(eng_sin, label(SIN)) ///
(eng_son, label(SON)) ///
(eng_tam, label(TAM)), ///
vertical keep(after_treat) yline(0) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graphDDeng.png", replace 
/* PANEL (c) Paid work */
coefplot (paid_ags, label(AGS)) ///
(paid_coah, label(COAH)) ///
(paid_dgo, label(DGO)) ///
(paid_nl, label(NL)) ///
(paid_sin, label(SIN)) ///
(paid_son, label(SON)) ///
(paid_tam, label(TAM)), ///
vertical keep(after_treat) yline(0) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graphDDpaid.png", replace 
/* PANEL (d) Wages */
coefplot (wage_ags, label(AGS)) ///
(wage_coah, label(COAH)) ///
(wage_dgo, label(DGO)) ///
(wage_nl, label(NL)) ///
(wage_sin, label(SIN)) ///
(wage_son, label(SON)) ///
(wage_tam, label(TAM)), ///
vertical keep(after_treat) yline(0) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
legend( off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graphDDwage.png", replace
*========================================================================*
/* TABLE 4. Intention to treat effect of offering English instruction at 
school */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
keep if cohort>=1975 & cohort<=1996
/* Panel A: Full sample */
eststo clear
eststo: areg hrs_exp had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)
eststo: areg student had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_StaggDD.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Panel B: Men */
eststo clear
eststo: areg hrs_exp had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg paidw had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg student had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_StaggDDmen.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Panel B: Women */
eststo clear
eststo: areg hrs_exp had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg paidw had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg student had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_StaggDDwomen.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Difference in estimate by gender */
gen fem_pol=female*had_policy
gen fem_cohort=female*cohort
destring geo, replace
gen fem_geo=female*geo
gen fem_edu=female*edu
eststo clear
eststo: reghdfe hrs_exp fem_pol had_policy female indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe eng fem_pol had_policy female indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe lwage fem_pol had_policy female indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe paidw fem_pol had_policy female indigenous married ///
[aw=weight], absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe student fem_pol had_policy female indigenous married ///
[aw=weight], absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
esttab using "$doc\tab_StaggDDgender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(fem_pol) replace
/* Panel D: Low education sample */
eststo clear
eststo: areg hrs_exp had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg paidw had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg student had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_StaggDDlow.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Panel E: High education sample */
eststo clear
eststo: areg hrs_exp had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
eststo: areg paidw had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if edu>9, absorb(geo) vce(cluster geo)
eststo: areg student had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if edu>9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_StaggDDhigh.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Difference in estimate by education */
gen lowe=edu<=9
gen edu_pol=lowe*had_policy
gen edu_cohort=lowe*cohort
destring geo, replace
gen edu_geo=lowe*geo
gen edu_low=lowe*edu
eststo clear
eststo: reghdfe hrs_exp edu_pol had_policy female indigenous married ///
[aw=weight] if paidw==1, absorb(edu_cohort edu_geo edu_low cohort edu geo) vce(cluster geo)
eststo: reghdfe eng edu_pol had_policy female indigenous married ///
[aw=weight] if paidw==1, absorb(edu_cohort edu_geo edu_low cohort edu geo) vce(cluster geo)
eststo: reghdfe lwage edu_pol had_policy female indigenous married ///
[aw=weight] if paidw==1, absorb(edu_cohort edu_geo edu_low cohort edu geo) vce(cluster geo)
eststo: reghdfe paidw edu_pol had_policy female indigenous married ///
[aw=weight], absorb(edu_cohort edu_geo edu_low cohort edu geo) vce(cluster geo)
eststo: reghdfe student edu_pol had_policy female indigenous married ///
[aw=weight], absorb(edu_cohort edu_geo edu_low cohort edu geo) vce(cluster geo)
esttab using "$doc\tab_StaggDDedu.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(edu_pol) replace
*========================================================================*
/* TABLE 5. Returns to English abilities (IV estimate) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
destring state, replace
destring geo, replace
keep if cohort>=1975 & cohort<=1996

eststo clear
* Structural equation
eststo: areg lwage eng i.cohort i.edu female rural indigenous married ///
[aw=weight] if had_policy!=. & paidw==1, absorb(geo) vce(cluster geo)
* First stage equation
eststo: areg eng had_policy i.cohort i.edu female rural indigenous married ///
[aw=weight] if had_policy!=. & paidw==1, absorb(geo) vce(cluster geo)
* Reduced form equation
eststo: areg lwage had_policy i.cohort i.edu female rural indigenous married ///
[aw=weight] if had_policy!=. & paidw==1, absorb(geo) vce(cluster geo)
* Second stage (IV)
eststo: quietly ivregress 2sls lwage (eng=had_policy) i.geo i.cohort i.edu ///
female rural indigenous married [aw=weight] if had_policy!=. & paidw==1, vce(cluster geo)
esttab using "$doc\tabIV.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(eng had_policy) ///
stats(N ar2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* FIGURE 5: ITT effect of offering English instruction at school on 
occupational decisions */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
keep if cohort>=1975 & cohort<=1996

destring sinco, replace
gen occup=.
replace occup=1 if (sinco>6101 & sinco<=6131) | (sinco>6201 & sinco<=6231) ///
| sinco==6999
replace occup=2 if (sinco>=9111 & sinco<=9899) 
replace occup=3 if sinco==6311 | (sinco>=8111 & sinco<=8199) | (sinco>=8211 ///
& sinco<=8212) | (sinco>=8311 & sinco<=8999)
replace occup=4 if (sinco>=7111 & sinco<=7135) | (sinco>=7211 & sinco<=7223) ///
| (sinco>=7311 & sinco<=7353) | (sinco>=7411 & sinco<=7412) | (sinco>=7511 & ///
sinco<=7517) | (sinco>=7611 & sinco<=7999)
replace occup=5 if (sinco>=5111 & sinco<=5116) | (sinco>=5211 & sinco<=5254) ///
| (sinco>=5311 & sinco<=5314) | (sinco>=5411 & sinco<=5999)
replace occup=6 if sinco==4111 | (sinco>=4211 & sinco<=4999)
replace occup=7 if (sinco>=3111 & sinco<=3142) | (sinco>=3211 & sinco<=3999)
replace occup=8 if (sinco>=2111 & sinco<=2625) | (sinco>=2631 & sinco<=2639) ///
| (sinco>=2641 & sinco<=2992)
replace occup=9 if (sinco>=1111 & sinco<=1999) | sinco==2630 ///
| sinco==2630 | sinco==2640 | sinco==3101 | sinco==3201 | sinco==4201 ///
| sinco==5101 | sinco==5201 | sinco==5301 | sinco==5401 | sinco==6101 ///
| sinco==6201 | sinco==7101 | sinco==7201 | sinco==7301 | sinco==7401 ///
| sinco==7501 | sinco==7601 | sinco==8101 | sinco==8201 | sinco==8301
replace occup=10 if sinco==980

label define occup 1 "Farming" 2 "Elementary occupations" 3 "Machine operators" ///
4 "Crafts" 5 "Customer service" 6 "Sales" 7 "Clerical support" ///
8 "Professionals/Technicians" 9 "Managerial" 10 "Abroad" 
label values occup occup

gen farm=occup==1
gen elem=occup==2
gen mach=occup==3
gen craf=occup==4
gen cust=occup==5
gen sale=occup==6
gen cler=occup==7
gen prof=occup==8
gen mana=occup==9
gen abro=occup==10

eststo clear
quietly areg farm had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
estimates store farm_men
quietly areg farm had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
estimates store farm_women
quietly areg farm had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store farm_low
quietly areg farm had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store farm_high

quietly areg elem had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
estimates store elem_men
quietly areg elem had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
estimates store elem_women
quietly areg elem had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store elem_low
quietly areg elem had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store elem_high

quietly areg mach had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
estimates store mach_men
quietly areg mach had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
estimates store mach_women
quietly areg mach had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store mach_low
quietly areg mach had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store mach_high

quietly areg craf had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
estimates store craf_men
quietly areg craf had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
estimates store craf_women
quietly areg craf had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store craf_low
quietly areg craf had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store craf_high

quietly areg cust had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
estimates store cust_men
quietly areg cust had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
estimates store cust_women
quietly areg cust had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store cust_low
quietly areg cust had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store cust_high

quietly areg sale had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
estimates store sale_men
quietly areg sale had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
estimates store sale_women
quietly areg sale had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store sale_low
quietly areg sale had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store sale_high

quietly areg cler had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
estimates store cler_men
quietly areg cler had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
estimates store cler_women
quietly areg cler had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store cler_low
quietly areg cler had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store cler_high

quietly areg prof had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
estimates store prof_men
quietly areg prof had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
estimates store prof_women
quietly areg prof had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store prof_low
quietly areg prof had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store prof_high

quietly areg mana had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
estimates store mana_men
quietly areg mana had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
estimates store mana_women
quietly areg mana had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store mana_low
quietly areg mana had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store mana_high

label var had_policy "SDD heterogeneous effects by gender and education"
/* Panel (a) Farming */
coefplot (farm_men, label(Men) offset(-.25) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(farm_women, label(Women) offset(-.22) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(farm_low, label(Low-education) offset(.25) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(farm_high, label(High-education) offset(.28) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(had_policy) yline(0, lcolor(black)) ///
ytitle("Likelihood of working in farming occupations", size(medium) height(5)) ///
ylabel(-.1(0.05).1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(2) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterFarm.png", replace
/* Panel (b) Elementary */
coefplot (elem_men, label(Men) offset(-.25) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(elem_women, label(Women) offset(-.22) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(elem_low, label(Low-education) offset(.25) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(elem_high, label(High-education) offset(.28) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(had_policy) yline(0, lcolor(black)) ///
ytitle("Likelihood of working in elementary occupations", size(medium) height(5)) ///
ylabel(-.1(0.05).1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(2) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) legend(off) levels(90)
graph export "$doc\graphSDDheterElem.png", replace
/* Panel (c) Machine operator */
coefplot (mach_men, label(Men) offset(-.25) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(mach_women, label(Women) offset(-.22) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(mach_low, label(Low-education) offset(.25) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(mach_high, label(High-education) offset(.28) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(had_policy) yline(0, lcolor(black)) ///
ytitle("Likelihood of working in machine operator occupations", size(medium) height(5)) ///
ylabel(-.1(0.05).1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(2) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) legend(off) levels(90)
graph export "$doc\graphSDDheterMach.png", replace
/* Panel (d) Crafts */
coefplot (craf_men, label(Men) offset(-.25) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(craf_women, label(Women) offset(-.22) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(craf_low, label(Low-education) offset(.25) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(craf_high, label(High-education) offset(.28) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(had_policy) yline(0, lcolor(black)) ///
ytitle("Likelihood of working in crafts occupations", size(medium) height(5)) ///
ylabel(-.1(0.05).1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(2) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) legend(off) levels(90)
graph export "$doc\graphSDDheterCraft.png", replace
/* Panel (e) Customer service */
coefplot (cust_men, label(Men) offset(-.25) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(cust_women, label(Women) offset(-.22) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(cust_low, label(Low-education) offset(.25) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(cust_high, label(High-education) offset(.28) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(had_policy) yline(0, lcolor(black)) ///
ytitle("Likelihood of working in customer service", size(medium) height(5)) ///
ylabel(-.1(0.05).1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(2) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) legend(off) levels(90)
graph export "$doc\graphSDDheterCust.png", replace
/* Panel (f ) Sales */
coefplot (sale_men, label(Men) offset(-.25) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(sale_women, label(Women) offset(-.22) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(sale_low, label(Low-education) offset(.25) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(sale_high, label(High-education) offset(.28) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(had_policy) yline(0, lcolor(black)) ///
ytitle("Likelihood of working in sales", size(medium) height(5)) ///
ylabel(-.1(0.05).1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(2) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) legend(off) levels(90)
graph export "$doc\graphSDDheterSale.png", replace
/* Panel (g) Clerks */
coefplot (cler_men, label(Men) offset(-.25) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(cler_women, label(Women) offset(-.22) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(cler_low, label(Low-education) offset(.25) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(cler_high, label(High-education) offset(.28) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(had_policy) yline(0, lcolor(black)) ///
ytitle("Likelihood of working in clerical occupations", size(medium) height(5)) ///
ylabel(-.1(0.05).1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(2) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) legend(off) levels(90)
graph export "$doc\graphSDDheterCler.png", replace
/* Panel (h) Professionals */
coefplot (prof_men, label(Men) offset(-.25) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(prof_women, label(Women) offset(-.22) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(prof_low, label(Low-education) offset(.25) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(prof_high, label(High-education) offset(.28) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(had_policy) yline(0, lcolor(black)) ///
ytitle("Likelihood of working in professional occupations", size(medium) height(5)) ///
ylabel(-.1(0.05).1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(2) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) legend(off) levels(90)
graph export "$doc\graphSDDheterProf.png", replace
/* Panel (i) Managerial */
coefplot (mana_men, label(Men) offset(-.25) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(mana_women, label(Women) offset(-.22) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(mana_low, label(Low-education) offset(.25) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(mana_high, label(High-education) offset(.28) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(had_policy) yline(0, lcolor(black)) ///
ytitle("Likelihood of working in managerial occupations", size(medium) height(5)) ///
ylabel(-.1(0.05).1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(2) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) legend(off) levels(90)
graph export "$doc\graphSDDheterMana.png", replace
*========================================================================*
/* FIGURE 6: ITT effect of offering English instruction at school on 
economic industries */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
keep if cohort>=1975 & cohort<=1996

gen econ_act=.
replace econ_act=1 if (scian>=1110 & scian<=1199)
replace econ_act=2 if (scian>=2110 & scian<=2399)
replace econ_act=3 if (scian>=3110 & scian<=3399)
replace econ_act=4 if (scian>=4310 & scian<=9399)
replace econ_act=5 if scian==980

label define econ_act 1 "Agriculture" 2 "Construction" ///
3 "Manufacturing" 4 "Services" 5 "Abroad"
label values econ_act econ_act

gen ag=econ_act==1
gen cons=econ_act==2
gen manu=econ_act==3
gen svcs=econ_act==4
gen abroad=econ_act==5

eststo clear
quietly areg ag had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
estimates store ag_men
quietly areg ag had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
estimates store ag_women
quietly areg ag had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store ag_low
quietly areg ag had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store ag_high

quietly areg cons had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
estimates store cons_men
quietly areg cons had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
estimates store cons_women
quietly areg cons had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store cons_low
quietly areg cons had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store cons_high

quietly areg manu had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
estimates store manu_men
quietly areg manu had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
estimates store manu_women
quietly areg manu had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store manu_low
quietly areg manu had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store manu_high

quietly areg svcs had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
estimates store svcs_men
quietly areg svcs had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
estimates store svcs_women
quietly areg svcs had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store svcs_low
quietly areg svcs had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store svcs_high

label var had_policy "SDD heterogeneous effects by gender and education"
/* Panel (a) Agriculture */
coefplot (ag_men, label(Men) offset(-.25) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(ag_women, label(Women) offset(-.22) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(ag_low, label(Low-education) offset(.25) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(ag_high, label(High-education) offset(.28) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(had_policy) yline(0, lcolor(black)) ///
ytitle("Likelihood of working in agriculture", size(medium) height(5)) ///
ylabel(-.1(0.05).1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(2) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterAg.png", replace
/* Panel (b) Construction */
coefplot (cons_men, label(Men) offset(-.25) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(cons_women, label(Women) offset(-.22) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(cons_low, label(Low-education) offset(.25) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(cons_high, label(High-education) offset(.28) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(had_policy) yline(0, lcolor(black)) ///
ytitle("Likelihood of working in construction", size(medium) height(5)) ///
ylabel(-.1(0.05).1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(2) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90) legend(off)
graph export "$doc\graphSDDheterCons.png", replace
/* Panel (c) Manufacturing */
coefplot (manu_men, label(Men) offset(-.25) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(manu_women, label(Women) offset(-.22) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(manu_low, label(Low-education) offset(.25) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(manu_high, label(High-education) offset(.28) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(had_policy) yline(0, lcolor(black)) ///
ytitle("Likelihood of working in manufacturing", size(medium) height(5)) ///
ylabel(-.1(0.05).1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(2) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90) legend(off)
graph export "$doc\graphSDDheterManu.png", replace
/* Panel (d) Services */
coefplot (svcs_men, label(Men) offset(-.25) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(svcs_women, label(Women) offset(-.22) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(svcs_low, label(Low-education) offset(.25) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(svcs_high, label(High-education) offset(.28) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(had_policy) yline(0, lcolor(black)) ///
ytitle("Likelihood of working in services", size(medium) height(5)) ///
ylabel(-.1(0.05).1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(2) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90) legend(off)
graph export "$doc\graphSDDheterSvcs.png", replace
*========================================================================*
/* FIGURE 7. ITT effect of offering English instruction and English 
intensive jobs */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
keep if cohort>=1975 & cohort<=1996

bysort scian: egen eng_ind=mean(eng)
xtile eng_speak=eng_ind, nq(4)

gen econ_act=.
replace econ_act=1 if (scian>=1110 & scian<=1199)
replace econ_act=2 if (scian>=2110 & scian<=2399)
replace econ_act=3 if (scian>=3110 & scian<=3399)
replace econ_act=4 if (scian>=4310 & scian<=9399)
replace econ_act=5 if scian==980

label define econ_act 1 "Agriculture" 2 "Construction" ///
3 "Manufacturing" 4 "Services" 5 "Abroad"
label values econ_act econ_act

gen ag=econ_act==1
gen cons=econ_act==2
gen manu=econ_act==3
gen svcs=econ_act==4
gen abroad=econ_act==5

gen cons_low=cons==1 & eng_speak<4
gen cons_high=cons==1 & eng_speak==4
gen manu_low=manu==1 & eng_speak<4
gen manu_high=manu==1 & eng_speak==4
gen svcs_low=svcs==1 & eng_speak<4
gen svcs_high=svcs==1 & eng_speak==4

eststo clear
quietly areg cons_low had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
estimates store cons_low_men
quietly areg cons_low had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
estimates store cons_low_women
quietly areg cons_low had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store cons_low_low
quietly areg cons_low had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store cons_low_high
quietly areg cons_high had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
estimates store cons_high_men
quietly areg cons_high had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
estimates store cons_high_women
quietly areg cons_high had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store cons_high_low
quietly areg cons_high had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store cons_high_high

quietly areg manu_low had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
estimates store manu_low_men
quietly areg manu_low had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
estimates store manu_low_women
quietly areg manu_low had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store manu_low_low
quietly areg manu_low had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store manu_low_high
quietly areg manu_high had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
estimates store manu_high_men
quietly areg manu_high had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
estimates store manu_high_women
quietly areg manu_high had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store manu_high_low
quietly areg manu_high had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store manu_high_high

quietly areg svcs_low had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
estimates store svcs_low_men
quietly areg svcs_low had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
estimates store svcs_low_women
quietly areg svcs_low had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store svcs_low_low
quietly areg svcs_low had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store svcs_low_high
quietly areg svcs_high had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
estimates store svcs_high_men
quietly areg svcs_high had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
estimates store svcs_high_women
quietly areg svcs_high had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store svcs_high_low
quietly areg svcs_high had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store svcs_high_high

label var had_policy "SDD heterogeneous effects for low and high-English intensive jobs"

/* Panel (a) Construction */
coefplot (cons_low_men, label(Low-Eng Men) offset(-.35) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(cons_low_women, label(Low-Eng Women) offset(-.32) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(cons_low_low, label(Low-Eng Low-education) offset(-.22) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(cons_low_high, label(Low-Eng High-education) offset(-.19) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(cons_high_men, label(High-Eng Men) offset(.19) msymbol(O) mcolor(cranberry) ciopt(lc(cranberry) recast(rcap))) ///
(cons_high_women, label(High-Eng Women) offset(.22) msymbol(Oh) mcolor(orange) ciopt(lc(orange) recast(rcap))) ///
(cons_high_low, label(High-Eng Low-education) offset(.32) msymbol(D) mcolor(cranberry) ciopt(lc(cranberry) recast(rcap))) ///
(cons_high_high, label(High-Eng High-education) offset(.35) msymbol(Dh) mcolor(orange) ciopt(lc(orange) recast(rcap))), ///
vertical keep(had_policy) yline(0, lcolor(black)) ///
ytitle("Likelihood of working in construction", size(medium) height(5)) ///
ylabel(-.1(0.05).1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(2) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90) 
graph export "$doc\graphSDDheterEngCons.png", replace
/* Panel (b) Manufacturing */
coefplot (manu_low_men, label(Low-Eng Men) offset(-.35) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(manu_low_women, label(Low-Eng Women) offset(-.32) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(manu_low_low, label(Low-Eng Low-education) offset(-.22) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(manu_low_high, label(Low-Eng High-education) offset(-.19) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(manu_high_men, label(High-Eng Men) offset(.19) msymbol(O) mcolor(cranberry) ciopt(lc(cranberry) recast(rcap))) ///
(manu_high_women, label(High-Eng Women) offset(.22) msymbol(Oh) mcolor(orange) ciopt(lc(orange) recast(rcap))) ///
(manu_high_low, label(High-Eng Low-education) offset(.32) msymbol(D) mcolor(cranberry) ciopt(lc(cranberry) recast(rcap))) ///
(manu_high_high, label(High-Eng High-education) offset(.35) msymbol(Dh) mcolor(orange) ciopt(lc(orange) recast(rcap))), ///
vertical keep(had_policy) yline(0, lcolor(black)) ///
ytitle("Likelihood of working in manufacturing", size(medium) height(5)) ///
ylabel(-.1(0.05).1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(2) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90) legend(off)
graph export "$doc\graphSDDheterEngManu.png", replace 
/* Panel (c) Services */
coefplot (svcs_low_men, label(Low-Eng Men) offset(-.35) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(svcs_low_women, label(Low-Eng Women) offset(-.32) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(svcs_low_low, label(Low-Eng Low-education) offset(-.22) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(svcs_low_high, label(Low-Eng High-education) offset(-.19) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(svcs_high_men, label(High-Eng Men) offset(.19) msymbol(O) mcolor(cranberry) ciopt(lc(cranberry) recast(rcap))) ///
(svcs_high_women, label(High-Eng Women) offset(.22) msymbol(Oh) mcolor(orange) ciopt(lc(orange) recast(rcap))) ///
(svcs_high_low, label(High-Eng Low-education) offset(.32) msymbol(D) mcolor(cranberry) ciopt(lc(cranberry) recast(rcap))) ///
(svcs_high_high, label(High-Eng High-education) offset(.35) msymbol(Dh) mcolor(orange) ciopt(lc(orange) recast(rcap))), ///
vertical keep(had_policy) yline(0, lcolor(black)) ///
ytitle("Likelihood of working in services", size(medium) height(5)) ///
ylabel(-.1(0.05).1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(2) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90) legend(off)
graph export "$doc\graphSDDheterEngSvcs.png", replace 
*========================================================================*
/* Robustness Checks */ 
*========================================================================*
/*Neighboring states as comparison group in DD models */
*========================================================================*
/* FIGURE 8. ITT of offering English instruction with differemt comparison
group (DD estimates by state) */
*========================================================================*
eststo clear
use "$data/eng_abil.dta", clear
keep if state=="01" | state=="06" | state=="11" | state=="18" | state=="24" ///
| state=="32"
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

use "$data/eng_abil.dta", clear
keep if state=="05" | state=="08" | state=="24" | state=="32"
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

use "$data/eng_abil.dta", clear
keep if state=="10" | state=="08" | state=="24" | state=="32" | state=="14" 
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

use "$data/eng_abil.dta", clear
keep if state=="19" | state=="08" | state=="24" | state=="32"  
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

use "$data/eng_abil.dta", clear
keep if state=="25" | state=="08" | state=="32" | state=="18" | state=="02" ///
| state=="03"
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

use "$data/eng_abil.dta", clear
keep if state=="26" | state=="08" | state=="02" | state=="03" | state=="14" ///
| state=="32" 
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

use "$data/eng_abil.dta", clear
keep if state=="28" | state=="08" | state=="32" | state=="18" | state=="02" ///
| state=="03"
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
/* Panel (a) Hours of English */
coefplot (hrs_ags, label(AGS)) ///
(hrs_coah, label(COAH)) ///
(hrs_dgo, label(DGO)) ///
(hrs_nl, label(NL)) ///
(hrs_sin, label(SIN)) ///
(hrs_son, label(SON)) ///
(hrs_tam, label(TAM)), ///
vertical keep(after_treat) yline(0) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-0.5(0.5)1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(3) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graphDDhrsR.png", replace 
/* Panel (b) English skills */
coefplot (eng_ags, label(AGS)) ///
(eng_coah, label(COAH)) ///
(eng_dgo, label(DGO)) ///
(eng_nl, label(NL)) ///
(eng_sin, label(SIN)) ///
(eng_son, label(SON)) ///
(eng_tam, label(TAM)), ///
vertical keep(after_treat) yline(0) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graphDDengR.png", replace 
/* Panel (c) Paid work */
coefplot (paid_ags, label(AGS)) ///
(paid_coah, label(COAH)) ///
(paid_dgo, label(DGO)) ///
(paid_nl, label(NL)) ///
(paid_sin, label(SIN)) ///
(paid_son, label(SON)) ///
(paid_tam, label(TAM)), ///
vertical keep(after_treat) yline(0) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graphDDpaidR.png", replace 
/* Panel (d) Wages */
coefplot (wage_ags, label(AGS)) ///
(wage_coah, label(COAH)) ///
(wage_dgo, label(DGO)) ///
(wage_nl, label(NL)) ///
(wage_sin, label(SIN)) ///
(wage_son, label(SON)) ///
(wage_tam, label(TAM)), ///
vertical keep(after_treat) yline(0) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
legend( off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graphDDwageR.png", replace 
*========================================================================*
/* TABLE 6. Returns to English abilities
(IV estimate with narrower comparison group) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
destring state, replace
destring geo, replace
keep if cohort>=1984 & cohort<=1993

eststo clear
* Structural equation
eststo: areg lwage eng i.cohort i.edu female student indigenous ///
married [aw=weight] if had_policy!=. & paidw==1, absorb(geo) vce(cluster geo)
* First stage equation
eststo: areg eng had_policy i.cohort i.edu female indigenous ///
married [aw=weight] if had_policy!=. & paidw==1, absorb(geo) vce(cluster geo)
* Reduced form equation
eststo: areg lwage had_policy i.cohort i.edu female indigenous ///
married [aw=weight] if had_policy!=. & paidw==1, absorb(geo) vce(cluster geo)
* Second stage (IV)
eststo: quietly ivregress 2sls lwage (eng=had_policy) i.geo i.cohort i.edu ///
female indigenous married [aw=weight] if had_policy!=. & paidw==1, vce(cluster geo)
/*ivreghdfe lwage (eng=had_policy) female rural student ///
indigenous married [aw=weight] if had_policy!=., absorb(geo cohort edu) robust*/
esttab using "$doc\tabIVa.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(eng had_policy) ///
stats(N ar2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* TABLE 7. Intention to Treat effect of offering English instruction at 
school (Robust SDD estimate) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
keep if cohort>=1975 & cohort<=1996

/* Callaway and SantAnna (2021) */

destring geo, replace
destring id, replace
gen fist_cohort=0
replace fist_cohort=1990 if state=="01"
replace fist_cohort=1988 if state=="05"
replace fist_cohort=1991 if state=="10"
replace fist_cohort=1987 if state=="19"
replace fist_cohort=1993 if state=="25"
replace fist_cohort=1993 if state=="26"
replace fist_cohort=1990 if state=="28"

csdid paidw edu female indigenous married [iw=weight] if paidw==1, time(cohort) gvar(fist_cohort) method(dripw) vce(cluster geo)
estat all
csdid student edu female indigenous married [iw=weight] if paidw==1, time(cohort) gvar(fist_cohort) method(dripw) vce(cluster geo)
estat all

keep if paidw==1
csdid hrs_exp edu female indigenous married [iw=weight] if paidw==1, time(cohort) gvar(fist_cohort) method(dripw) vce(cluster geo)
estat all
csdid eng edu female indigenous married [iw=weight] if paidw==1, time(cohort) gvar(fist_cohort) method(dripw) vce(cluster geo)
estat all
csdid lwage edu female indigenous married [iw=weight] if paidw==1, time(cohort) gvar(fist_cohort) method(dripw) vce(cluster geo)
estat all

/* Sun and Abraham (2021) */
gen tgroup=fist_cohort
replace tgroup=. if state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"
gen cgroup=tgroup==.

eventstudyinteract hrs_exp had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)
eventstudyinteract eng had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)
eventstudyinteract lwage had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)
eventstudyinteract paidw had_policy [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)
eventstudyinteract student had_policy [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)

eststo clear
eststo: areg hrs_exp had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)
eststo: areg student had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_StaggDD.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* APPENDIX */
*========================================================================*
/* Robustness Check */
*========================================================================*
/* Figure A.3. ITT of offering English instruction with different comparison
group and by education (DD estimates by state) */
*========================================================================*
eststo clear
use "$base\eng_abil.dta", clear
keep if state=="01" | state=="32"
gen treat=state=="01"
gen after=cohort>=1990
replace after=. if cohort<1986 | cohort>1995
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_ags
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_ags
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
estimates store paid_ags
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_ags

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_ags2
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_ags2
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu>9, absorb(geo) vce(cluster geo)
estimates store paid_ags2
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_ags2

use "$base\eng_abil.dta", clear
keep if state=="05" | state=="08"
gen treat=state=="05"
gen after=cohort>=1988
replace after=. if cohort<1979 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_coah
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_coah
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
estimates store paid_coah
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_coah

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_coah2
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_coah2
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu>9, absorb(geo) vce(cluster geo)
estimates store paid_coah2
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_coah2

use "$base\eng_abil.dta", clear
keep if state=="10" | state=="24"
gen treat=state=="10"
gen after=cohort>=1991
replace after=. if cohort<1985 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_dgo
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_dgo
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
estimates store paid_dgo
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_dgo

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_dgo2
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_dgo2
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu>9, absorb(geo) vce(cluster geo)
estimates store paid_dgo2
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_dgo2

use "$base\eng_abil.dta", clear
keep if state=="19" | state=="24"
gen treat=state=="19"
gen after=cohort>=1987
replace after=. if cohort<1981 | cohort>1996
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_nl
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_nl
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
estimates store paid_nl
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_nl

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_nl2
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_nl2
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu>9, absorb(geo) vce(cluster geo)
estimates store paid_nl2
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_nl2

use "$base\eng_abil.dta", clear
keep if state=="25" | state=="18"
gen treat=state=="25"
gen after=cohort>=1993
replace after=. if cohort<1989 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_sin
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_sin
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
estimates store paid_sin
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_sin

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_sin2
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_sin2
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu>9, absorb(geo) vce(cluster geo)
estimates store paid_sin2
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_sin2

use "$base\eng_abil.dta", clear
keep if state=="26" | state=="02" | state=="08"
gen treat=state=="26"
gen after=cohort>=1993
replace after=. if cohort<1991 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_son
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_son
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
estimates store paid_son
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_son

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_son2
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_son2
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu>9, absorb(geo) vce(cluster geo)
estimates store paid_son2
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_son2

use "$base\eng_abil.dta", clear
keep if state=="28" | state=="02"
gen treat=state=="28"
gen after=cohort>=1990
replace after=. if cohort<1983 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_tam
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_tam
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
estimates store paid_tam
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_tam

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_tam2
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_tam2
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu>9, absorb(geo) vce(cluster geo)
estimates store paid_tam2
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_tam2

label var after_treat "Mexican states with English programs by educational attainment"
/* Panel (a) Hours of English */
coefplot (hrs_ags, label(AGS low) offset(-.46) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(hrs_ags2, label(AGS high) offset(-.43) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_coah, label(COAH low) offset(-.28) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(hrs_coah2, label(COAH high) offset(-.25) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_nl, label(NL low) offset(-.10) msymbol(O) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(hrs_nl2, label(NL high) offset(-.07) msymbol(Oh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_sin, label(SIN low) offset(.08) msymbol(D) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(hrs_sin2, label(SIN high) offset(.11) msymbol(Dh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_son, label(SON low) offset(.26) msymbol(+) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(hrs_son2, label(SON high) offset(.29) msymbol(+) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_tam, label(TAM low) offset(.44) msymbol(X) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(hrs_tam2, label(TAM high) offset(.47) msymbol(X) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(after_treat) yline(0, lcolor(black)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(4) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap))
graph export "$doc\graphDDhrs2.png", replace
/* Panel (b) English skills */
coefplot (eng_ags, label(AGS low) offset(-.46) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(eng_ags2, label(AGS high) offset(-.43) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_coah, label(COAH low) offset(-.28) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(eng_coah2, label(COAH high) offset(-.25) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_nl, label(NL low) offset(-.10) msymbol(O) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(eng_nl2, label(NL high) offset(-.07) msymbol(Oh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_sin, label(SIN low) offset(.08) msymbol(D) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(eng_sin2, label(SIN high) offset(.11) msymbol(Dh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_son, label(SON low) offset(.26) msymbol(+) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(eng_son2, label(SON high) offset(.29) msymbol(+) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_tam, label(TAM low) offset(.44) msymbol(X) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(eng_tam2, label(TAM high) offset(.47) msymbol(X) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(after_treat) yline(0, lcolor(black)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
legend(off) graphregion(color(white)) ciopts(recast(rcap))
graph export "$doc\graphDDeng2.png", replace 
/* Panel (c) Paid work */
coefplot (paid_ags, label(AGS low) offset(-.46) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(paid_ags2, label(AGS high) offset(-.43) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_coah, label(COAH low) offset(-.28) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(paid_coah2, label(COAH high) offset(-.25) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_nl, label(NL low) offset(-.10) msymbol(O) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(paid_nl2, label(NL high) offset(-.07) msymbol(Oh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_sin, label(SIN low) offset(.08) msymbol(D) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(paid_sin2, label(SIN high) offset(.11) msymbol(Dh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_son, label(SON low) offset(.26) msymbol(+) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(paid_son2, label(SON high) offset(.29) msymbol(+) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_tam, label(TAM low) offset(.44) msymbol(X) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(paid_tam2, label(TAM high) offset(.47) msymbol(X) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(after_treat) yline(0, lcolor(black)) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
legend(off) graphregion(color(white)) ciopts(recast(rcap))
graph export "$doc\graphDDpaid2.png", replace
/* Panel (d) Wages */
coefplot (wage_ags, label(AGS low) offset(-.46) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(wage_ags2, label(AGS high) offset(-.43) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_coah, label(COAH low) offset(-.28) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(wage_coah2, label(COAH high) offset(-.25) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_nl, label(NL low) offset(-.10) msymbol(O) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(wage_nl2, label(NL high) offset(-.07) msymbol(Oh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_sin, label(SIN low) offset(.08) msymbol(D) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(wage_sin2, label(SIN high) offset(.11) msymbol(Dh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_son, label(SON low) offset(.26) msymbol(+) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(wage_son2, label(SON high) offset(.29) msymbol(+) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_tam, label(TAM low) offset(.44) msymbol(X) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(wage_tam2, label(TAM high) offset(.47) msymbol(X) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(after_treat) yline(0, lcolor(black)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-3(1)3, labs(medium) grid format(%5.2f)) ///
legend(off) graphregion(color(white)) ciopts(recast(rcap))
graph export "$doc\graphDDwage2.png", replace
*========================================================================*
/* TABLE A.2. Heterogenous effects */
*========================================================================*
/* Staggered DiD: By ethnicity */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
destring state, replace
keep if cohort>=1975 & cohort<=1996

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if indigenous==1 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if indigenous==1 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female ///
indigenous married [aw=weight] if indigenous==1 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if indigenous==1, absorb(geo) vce(cluster geo)
eststo: areg student had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if indigenous==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDind.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if indigenous==0 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if indigenous==0 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female ///
indigenous married [aw=weight] if indigenous==0 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if indigenous==0, absorb(geo) vce(cluster geo)
eststo: areg student had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if indigenous==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDnind.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen ind_pol=indigenous*had_policy
gen ind_cohort=indigenous*cohort
gen ind_state=indigenous*state

eststo clear
eststo: areg hrs_exp ind_pol had_policy i.ind_cohort i.ind_state i.state i.cohort ///
i.edu female indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng ind_pol had_policy i.ind_cohort i.ind_state i.state i.cohort ///
i.edu female indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg lwage ind_pol had_policy i.ind_cohort i.ind_state i.state i.cohort ///
i.edu female indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw ind_pol had_policy i.ind_cohort i.ind_state i.state i.cohort ///
i.edu female indigenous married [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg student ind_pol had_policy i.ind_cohort i.ind_state i.state i.cohort ///
i.edu female indigenous married [aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDethnic.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Ethnicity differences) keep(ind_pol) replace
*========================================================================*
/* Staggered DiD: By geographical context */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
destring state, replace
keep if cohort>=1975 & cohort<=1996

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if rural==1 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if rural==1 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female ///
indigenous married [aw=weight] if rural==1 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if rural==1, absorb(geo) vce(cluster geo)
eststo: areg student had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if rural==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDrural.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if rural==0 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if rural==0 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female ///
indigenous married [aw=weight] if rural==0 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if rural==0, absorb(geo) vce(cluster geo)
eststo: areg student had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if rural==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDurban.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen rul_pol=rural*had_policy
gen rul_cohort=rural*cohort
gen rul_state=rural*state

eststo clear
eststo: areg hrs_exp rul_pol rural had_policy i.rul_cohort i.rul_state i.state i.cohort ///
i.edu female indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng rul_pol rural had_policy i.rul_cohort i.rul_state i.state i.cohort ///
i.edu female indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg lwage rul_pol rural had_policy i.rul_cohort i.rul_state i.state i.cohort ///
i.edu female indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw rul_pol rural had_policy i.rul_cohort i.rul_state i.state i.cohort ///
i.edu female indigenous married [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg student rul_pol rural had_policy i.rul_cohort i.rul_state i.state i.cohort ///
i.edu female indigenous married [aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDgeo.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Geographical differences) keep(rul_pol) replace
*========================================================================*
/* FIGURE A.6. Pre-trends test pooling all states (SDD estimate) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
keep if cohort>=1975 & cohort<=1996

gen treat2=cohort==1980 & state=="05"
gen treat3=cohort==1981 & state=="05"
gen treat4=cohort==1981 & state=="19"
gen treat5=cohort==1982 & state=="19"
gen treat6=cohort==1983 & state=="19"
gen treat7=cohort==1984 & state=="19"
gen treat8=cohort==1985 & state=="19"
gen treat9=cohort==1986 & state=="19"
gen treat10=cohort==1987 & state=="19"
gen treat11=cohort==1988 & state=="19"
gen treat12=cohort==1989 & state=="19"
gen treat13=cohort==1990 & state=="19"
gen treat14=cohort==1991 & state=="19"
gen treat15=cohort==1992 & state=="19"
gen treat16=cohort==1993 & state=="19"
gen treat17=cohort==1994 & state=="19"
gen treat18=cohort==1995 & state=="19"
gen treat19=cohort==1996 & state=="19"

replace treat6=1 if cohort==1986 & state=="01"
replace treat7=1 if cohort==1987 & state=="01"
replace treat8=1 if cohort==1988 & state=="01"
replace treat9=1 if cohort==1989 & state=="01"
replace treat10=1 if cohort==1990 & state=="01"
replace treat11=1 if cohort==1991 & state=="01"
replace treat12=1 if cohort==1992 & state=="01"
replace treat13=1 if cohort==1993 & state=="01"
replace treat14=1 if cohort==1994 & state=="01"
replace treat15=1 if cohort==1995 & state=="01"
replace treat16=1 if cohort==1996 & state=="01"

replace treat4=1 if cohort==1982 & state=="05"
replace treat5=1 if cohort==1983 & state=="05"
replace treat6=1 if cohort==1984 & state=="05"
replace treat7=1 if cohort==1985 & state=="05"
replace treat8=1 if cohort==1986 & state=="05"
replace treat9=1 if cohort==1987 & state=="05"
replace treat10=1 if cohort==1988 & state=="05"
replace treat11=1 if cohort==1989 & state=="05"
replace treat12=1 if cohort==1990 & state=="05"
replace treat13=1 if cohort==1991 & state=="05"
replace treat14=1 if cohort==1992 & state=="05"
replace treat15=1 if cohort==1993 & state=="05"
replace treat16=1 if cohort==1994 & state=="05"
replace treat17=1 if cohort==1995 & state=="05"
replace treat18=1 if cohort==1996 & state=="05"

replace treat4=1 if cohort==1985 & state=="10"
replace treat5=1 if cohort==1986 & state=="10"
replace treat6=1 if cohort==1987 & state=="10"
replace treat7=1 if cohort==1988 & state=="10"
replace treat8=1 if cohort==1989 & state=="10"
replace treat9=1 if cohort==1990 & state=="10"
replace treat10=1 if cohort==1991 & state=="10"
replace treat11=1 if cohort==1992 & state=="10"
replace treat12=1 if cohort==1993 & state=="10"
replace treat13=1 if cohort==1994 & state=="10"
replace treat14=1 if cohort==1995 & state=="10"
replace treat15=1 if cohort==1996 & state=="10"

replace treat6=1 if cohort==1989 & state=="25"
replace treat7=1 if cohort==1990 & state=="25"
replace treat8=1 if cohort==1991 & state=="25"
replace treat9=1 if cohort==1992 & state=="25"
replace treat10=1 if cohort==1993 & state=="25"
replace treat11=1 if cohort==1994 & state=="25"
replace treat12=1 if cohort==1995 & state=="25"
replace treat13=1 if cohort==1996 & state=="25"

*replace treat7=1 if cohort==1990 & state=="26"
replace treat8=1 if cohort==1991 & state=="26"
replace treat9=1 if cohort==1992 & state=="26"
replace treat10=1 if cohort==1993 & state=="26"
replace treat11=1 if cohort==1994 & state=="26"
replace treat12=1 if cohort==1995 & state=="26"
replace treat13=1 if cohort==1996 & state=="26"

replace treat3=1 if cohort==1983 & state=="28"
replace treat4=1 if cohort==1984 & state=="28"
replace treat5=1 if cohort==1985 & state=="28"
replace treat6=1 if cohort==1986 & state=="28"
replace treat7=1 if cohort==1987 & state=="28"
replace treat8=1 if cohort==1988 & state=="28"
replace treat9=1 if cohort==1989 & state=="28"
replace treat10=1 if cohort==1990 & state=="28"
replace treat11=1 if cohort==1991 & state=="28"
replace treat12=1 if cohort==1992 & state=="28"
replace treat13=1 if cohort==1993 & state=="28"
replace treat14=1 if cohort==1994 & state=="28"
replace treat15=1 if cohort==1995 & state=="28"
replace treat16=1 if cohort==1996 & state=="28"

replace treat9=0

label var treat2 "-8"
label var treat3 "-7"
label var treat4 "-6"
label var treat5 "-5"
label var treat6 "-4"
label var treat7 "-3"
label var treat8 "-2"
label var treat9 "-1"
foreach x in 0 1 2 3 4 5 6 7 8 9 {
	label var treat1`x' "`x'"
}
/* Panel (a) Hours of English */
areg eng treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.10(0.05)0.10, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.10 0.10)) recast(connected)
graph export "$doc\PTA_StaggDD.png", replace
/* Panel (b) Speak English */
areg hrs_exp treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.75, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.75)) recast(connected)
graph export "$doc\PTA_StaggDD1.png", replace
/* Panel (c) Paid work */
areg paidw treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) recast(connected)
graph export "$doc\PTA_StaggDD2.png", replace
/* Panel (d) Ln(wage) */
areg lwage treat* i.cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-2(1)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-2 2)) recast(connected)
graph export "$doc\PTA_StaggDD3.png", replace
/* Panel not shown: School enrollment */
areg student treat* i.cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-.5(.25).5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-.5 .5)) recast(connected)
graph export "$doc\PTA_StaggDD4.png", replace
*========================================================================*
/* FIGURE A.7. Pre-trends test pooling all states 
(SDD estimate with a narrower comparison group) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
keep if cohort>=1984 & cohort<=1993

eststo clear
eststo: areg hrs_exp had_policy i.cohort i.edu female indigenous married ///
[aw=weight]  if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.cohort i.edu female indigenous married ///
[aw=weight]  if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female indigenous married ///
[aw=weight]  if paidw==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_StaggDDa.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen treat4=cohort==1985 & state=="10"
gen treat5=cohort==1986 & state=="10"
gen treat6=cohort==1986 & state=="01"
gen treat7=cohort==1984 & state=="19"
gen treat8=cohort==1985 & state=="19"
gen treat9=cohort==1986 & state=="19"
gen treat10=cohort==1987 & state=="19"
gen treat11=cohort==1988 & state=="19"
gen treat12=cohort==1989 & state=="19"
gen treat13=cohort==1990 & state=="19"
gen treat14=cohort==1991 & state=="19"
gen treat15=cohort==1992 & state=="19"
gen treat16=cohort==1993 & state=="19"

replace treat7=1 if cohort==1987 & state=="01"
replace treat8=1 if cohort==1988 & state=="01"
replace treat9=1 if cohort==1989 & state=="01"
replace treat10=1 if cohort==1990 & state=="01"
replace treat11=1 if cohort==1991 & state=="01"
replace treat12=1 if cohort==1992 & state=="01"
replace treat13=1 if cohort==1993 & state=="01"

replace treat6=1 if cohort==1984 & state=="05"
replace treat7=1 if cohort==1985 & state=="05"
replace treat8=1 if cohort==1986 & state=="05"
replace treat9=1 if cohort==1987 & state=="05"
replace treat10=1 if cohort==1988 & state=="05"
replace treat11=1 if cohort==1989 & state=="05"
replace treat12=1 if cohort==1990 & state=="05"
replace treat13=1 if cohort==1991 & state=="05"
replace treat14=1 if cohort==1992 & state=="05"
replace treat15=1 if cohort==1993 & state=="05"

replace treat6=1 if cohort==1987 & state=="10"
replace treat7=1 if cohort==1988 & state=="10"
replace treat8=1 if cohort==1989 & state=="10"
replace treat9=1 if cohort==1990 & state=="10"
replace treat10=1 if cohort==1991 & state=="10"
replace treat11=1 if cohort==1992 & state=="10"
replace treat12=1 if cohort==1993 & state=="10"

replace treat6=1 if cohort==1989 & state=="25"
replace treat7=1 if cohort==1990 & state=="25"
replace treat8=1 if cohort==1991 & state=="25"
replace treat9=1 if cohort==1992 & state=="25"
replace treat10=1 if cohort==1993 & state=="25"

*replace treat7=1 if cohort==1990 & state=="26"
replace treat8=1 if cohort==1991 & state=="26"
replace treat9=1 if cohort==1992 & state=="26"
replace treat10=1 if cohort==1993 & state=="26"

replace treat4=1 if cohort==1984 & state=="28"
replace treat5=1 if cohort==1985 & state=="28"
replace treat6=1 if cohort==1986 & state=="28"
replace treat7=1 if cohort==1987 & state=="28"
replace treat8=1 if cohort==1988 & state=="28"
replace treat9=1 if cohort==1989 & state=="28"
replace treat10=1 if cohort==1990 & state=="28"
replace treat11=1 if cohort==1991 & state=="28"
replace treat12=1 if cohort==1992 & state=="28"
replace treat13=1 if cohort==1993 & state=="28"

replace treat9=0

label var treat4 "-6"
label var treat5 "-5"
label var treat6 "-4"
label var treat7 "-3"
label var treat8 "-2"
label var treat9 "-1"
foreach x in 0 1 2 3 4 5 6 {
	label var treat1`x' "`x'"
}
/* Panel (a) Hours of English */
areg eng treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(6, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.14(0.07)0.14, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.14 0.14)) recast(connected)
graph export "$doc\PTA_StaggDDa.png", replace
/* Panel (b) Speak English */
areg hrs_exp treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(6, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.75, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.75)) recast(connected)
graph export "$doc\PTA_StaggDDa1.png", replace
/* Panel (c) Paid work */
areg paidw treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(6, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) recast(connected)
graph export "$doc\PTA_StaggDDa2.png", replace
/* Panel (d) Ln(wage) */
areg lwage treat* i.cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(6, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-2(1)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-2 2)) recast(connected)
graph export "$doc\PTA_StaggDDa3.png", replace
