*========================================================================*
/* English skills and labor market outcomes in Mexico */
*========================================================================*
/* Author: Oscar Galvez-Soriano */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/ReturnsEng/Data"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\ReturnsEng\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\ReturnsEng\Doc"
*========================================================================*
/* TABLE 3: Returns to English abilities in Mexico */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
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
esttab using "$doc\tab3_A.tex", cells(b(star fmt(%9.3f)) se(par)) ///
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
esttab using "$doc\tab3_B.tex", cells(b(star fmt(%9.3f)) se(par)) ///
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
esttab using "$doc\tab3_C.tex", cells(b(star fmt(%9.3f)) se(par)) ///
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
esttab using "$doc\tab3_diff.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(eng_female) replace
*========================================================================*
/* FIGURE 3. Interaction speaks English and education */
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
ylabel(-2(2)6, labs(small) grid) ///
xtitle("Levels of education", size(small) height(5)) xlabel(,labs(small)) ///
graphregion(color(white)) scheme(s2mono) recast(connected) ciopts(recast(rcap)) ///
ysc(r(-2 6)) levels(90)
graph export "$doc\fig3.png", replace
*========================================================================*
/* FIGURE 4. Effect of English programs by state (DiD estimates) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="01" | state=="32"
gen treat=state=="01"
gen after=cohort>=1990
replace after=. if cohort<1986 | cohort>1995
gen after_treatAGS=after*treat

quietly areg hrs_exp after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_ags
quietly areg eng after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_ags
quietly areg paidw after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_ags
quietly areg lwage after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_ags

quietly areg hrs_exp after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_ags1
quietly areg eng after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_ags1
quietly areg paidw after_treatAGS treat i.cohort i.edu female indigenous ///
married if edu<=9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_ags1
quietly areg lwage after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_ags1

quietly areg hrs_exp after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_ags2
quietly areg eng after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_ags2
quietly areg paidw after_treatAGS treat i.cohort i.edu female indigenous ///
married if edu>9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_ags2
quietly areg lwage after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_ags2

use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="05" | state=="08"
gen treat=state=="05"
gen after=cohort>=1988
replace after=. if cohort<1979 | cohort>1996 
gen after_treatCOAH=after*treat

quietly areg hrs_exp after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_coah
quietly areg eng after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_coah
quietly areg paidw after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_coah
quietly areg lwage after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_coah

quietly areg hrs_exp after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_coah1
quietly areg eng after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_coah1
quietly areg paidw after_treatCOAH treat i.cohort i.edu female indigenous ///
married if edu<=9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_coah1
quietly areg lwage after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_coah1

quietly areg hrs_exp after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_coah2
quietly areg eng after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_coah2
quietly areg paidw after_treatCOAH treat i.cohort i.edu female indigenous ///
married if edu>9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_coah2
quietly areg lwage after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_coah2

use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="10" | state=="24"
gen treat=state=="10"
gen after=cohort>=1991
replace after=. if cohort<1985 | cohort>1996 
gen after_treatDGO=after*treat

quietly areg hrs_exp after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_dgo
quietly areg eng after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_dgo
quietly areg paidw after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_dgo
quietly areg lwage after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_dgo

quietly areg hrs_exp after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_dgo1
quietly areg eng after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_dgo1
quietly areg paidw after_treatDGO treat i.cohort i.edu female indigenous ///
married if edu<=9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_dgo1
quietly areg lwage after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_dgo1

quietly areg hrs_exp after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_dgo2
quietly areg eng after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_dgo2
quietly areg paidw after_treatDGO treat i.cohort i.edu female indigenous ///
married if edu>9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_dgo2
quietly areg lwage after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_dgo2

use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="19" | state=="24"
gen treat=state=="19"
gen after=cohort>=1987
replace after=. if cohort<1981 | cohort>1996
gen after_treatNL=after*treat

quietly areg hrs_exp after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_nl
quietly areg eng after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_nl
quietly areg paidw after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_nl
quietly areg lwage after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_nl

quietly areg hrs_exp after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_nl1
quietly areg eng after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_nl1
quietly areg paidw after_treatNL treat i.cohort i.edu female indigenous ///
married if edu<=9  [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_nl1
quietly areg lwage after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_nl1

quietly areg hrs_exp after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_nl2
quietly areg eng after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_nl2
quietly areg paidw after_treatNL treat i.cohort i.edu female indigenous ///
married if edu>9  [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_nl2
quietly areg lwage after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_nl2

use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="25" | state=="18"
gen treat=state=="25"
gen after=cohort>=1993
replace after=. if cohort<1989 | cohort>1996 
gen after_treatSIN=after*treat

quietly areg hrs_exp after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_sin
quietly areg eng after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_sin
quietly areg paidw after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_sin
quietly areg lwage after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_sin

quietly areg hrs_exp after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_sin1
quietly areg eng after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_sin1
quietly areg paidw after_treatSIN treat i.cohort i.edu female indigenous ///
married if edu<=9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_sin1
quietly areg lwage after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_sin1

quietly areg hrs_exp after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_sin2
quietly areg eng after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_sin2
quietly areg paidw after_treatSIN treat i.cohort i.edu female indigenous ///
married if edu>9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_sin2
quietly areg lwage after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_sin2

use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="26" | state=="02" | state=="08"
gen treat=state=="26"
gen after=cohort>=1993
replace after=. if cohort<1991 | cohort>1996 
gen after_treatSON=after*treat

quietly areg hrs_exp after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_son
quietly areg eng after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_son
quietly areg paidw after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_son
quietly areg lwage after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_son

quietly areg hrs_exp after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_son1
quietly areg eng after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_son1
quietly areg paidw after_treatSON treat i.cohort i.edu female indigenous ///
married if edu<=9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_son1
quietly areg lwage after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_son1

quietly areg hrs_exp after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_son2
quietly areg eng after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_son2
quietly areg paidw after_treatSON treat i.cohort i.edu female indigenous ///
married if edu>9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_son2
quietly areg lwage after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_son2

use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="28" | state=="02"
gen treat=state=="28"
gen after=cohort>=1990
replace after=. if cohort<1983 | cohort>1996 
gen after_treatTAM=after*treat

quietly areg hrs_exp after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_tam
quietly areg eng after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_tam
quietly areg paidw after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_tam
quietly areg lwage after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_tam

quietly areg hrs_exp after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_tam1
quietly areg eng after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_tam1
quietly areg paidw after_treatTAM treat i.cohort i.edu female indigenous ///
married if edu<=9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_tam1
quietly areg lwage after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_tam1

quietly areg hrs_exp after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_tam2
quietly areg eng after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_tam2
quietly areg paidw after_treatTAM treat i.cohort i.edu female indigenous ///
married if edu>9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_tam2
quietly areg lwage after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_tam2

label var after_treat " "
/* PANEL (a) Hours of English */
coefplot ///
(hrs_ags2, offset(0.15) msymbol(O) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_ags, msymbol(O) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(hrs_ags1, offset(-0.15) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(hrs_coah2, offset(0.15) msymbol(D) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_coah, msymbol(D) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(hrs_coah1, offset(-0.15) msymbol(D) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(hrs_dgo2, offset(0.15) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_dgo, msymbol(T) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(hrs_dgo1, offset(-0.15) msymbol(T) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(hrs_nl2, offset(0.15) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_nl, msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(hrs_nl1, offset(-0.15) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(hrs_sin2, offset(0.15) msymbol(+) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_sin, msymbol(+) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(hrs_sin1, offset(-0.15) msymbol(+) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(hrs_son2, offset(0.15) msymbol(X) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_son, msymbol(X) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(hrs_son1, offset(-0.15) msymbol(X) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(hrs_tam2, offset(0.15) msymbol(Oh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_tam, msymbol(Oh) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(hrs_tam1, offset(-0.15) msymbol(Oh) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(after_treatAGS after_treatCOAH after_treatDGO after_treatNL after_treatSIN ///
after_treatSON after_treatTAM) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
xtitle("Weekly hours of English instruction", size(medium) height(5)) ///
xlabel(-0.2(0.2)0.8, labs(medium) format(%5.2f)) ///
legend( off ) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) levels(90) ///
coeflabels(after_treatAGS = "AGS" after_treatCOAH = "COAH" after_treatDGO = "DGO" ///
after_treatNL = "NL" after_treatSIN = "SIN" after_treatSON = "SON" ///
after_treatTAM = "TAM")
graph export "$doc\graphDDhrs.png", replace 
/* PANEL (b) English skills */
coefplot ///
(eng_ags2, offset(0.15) msymbol(O) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_ags, msymbol(O) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(eng_ags1, offset(-0.15) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(eng_coah2, offset(0.15) msymbol(D) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_coah, msymbol(D) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(eng_coah1, offset(-0.15) msymbol(D) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(eng_dgo2, offset(0.15) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_dgo, msymbol(T) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(eng_dgo1, offset(-0.15) msymbol(T) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(eng_nl2, offset(0.15) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_nl, msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(eng_nl1, offset(-0.15) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(eng_sin2, offset(0.15) msymbol(+) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_sin, msymbol(+) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(eng_sin1, offset(-0.15) msymbol(+) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(eng_son2, offset(0.15) msymbol(X) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_son, msymbol(X) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(eng_son1, offset(-0.15) msymbol(X) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(eng_tam2, offset(0.15) msymbol(Oh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_tam, msymbol(Oh) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(eng_tam1, offset(-0.15) msymbol(Oh) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(after_treatAGS after_treatCOAH after_treatDGO after_treatNL after_treatSIN ///
after_treatSON after_treatTAM) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
xtitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
xlabel(-0.6(0.2)0.8, labs(medium) format(%5.2f)) ///
legend( off ) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) levels(90) ///
coeflabels(after_treatAGS = "AGS" after_treatCOAH = "COAH" after_treatDGO = "DGO" ///
after_treatNL = "NL" after_treatSIN = "SIN" after_treatSON = "SON" ///
after_treatTAM = "TAM")
graph export "$doc\graphDDeng.png", replace
/* PANEL (c) Paid work */
coefplot ///
(paid_ags2, offset(0.15) msymbol(O) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_ags, msymbol(O) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(paid_ags1, offset(-0.15) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(paid_coah2, offset(0.15) msymbol(D) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_coah, msymbol(D) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(paid_coah1, offset(-0.15) msymbol(D) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(paid_dgo2, offset(0.15) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_dgo, msymbol(T) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(paid_dgo1, offset(-0.15) msymbol(T) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(paid_nl2, offset(0.15) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_nl, msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(paid_nl1, offset(-0.15) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(paid_sin2, offset(0.15) msymbol(+) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_sin, msymbol(+) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(paid_sin1, offset(-0.15) msymbol(+) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(paid_son2, offset(0.15) msymbol(X) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_son, msymbol(X) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(paid_son1, offset(-0.15) msymbol(X) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(paid_tam2, offset(0.15) msymbol(Oh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_tam, msymbol(Oh) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(paid_tam1, offset(-0.15) msymbol(Oh) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(after_treatAGS after_treatCOAH after_treatDGO after_treatNL after_treatSIN ///
after_treatSON after_treatTAM) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
xtitle("Likelihood of working for pay", size(medium) height(5)) ///
xlabel(-0.6(0.2)0.8, labs(medium) format(%5.2f)) ///
legend( off ) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) levels(90) ///
coeflabels(after_treatAGS = "AGS" after_treatCOAH = "COAH" after_treatDGO = "DGO" ///
after_treatNL = "NL" after_treatSIN = "SIN" after_treatSON = "SON" ///
after_treatTAM = "TAM")
graph export "$doc\graphDDpaid.png", replace
 
/* PANEL (d) Wages */
coefplot ///
(wage_ags2, offset(0.15) msymbol(O) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_ags, msymbol(O) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(wage_ags1, offset(-0.15) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(wage_coah2, offset(0.15) msymbol(D) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_coah, msymbol(D) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(wage_coah1, offset(-0.15) msymbol(D) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(wage_dgo2, offset(0.15) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_dgo, msymbol(T) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(wage_dgo1, offset(-0.15) msymbol(T) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(wage_nl2, offset(0.15) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_nl, msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(wage_nl1, offset(-0.15) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(wage_sin2, offset(0.15) msymbol(+) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_sin, msymbol(+) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(wage_sin1, offset(-0.15) msymbol(+) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(wage_son2, offset(0.15) msymbol(X) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_son, msymbol(X) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(wage_son1, offset(-0.15) msymbol(X) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(wage_tam2, offset(0.15) msymbol(Oh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_tam, msymbol(Oh) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(wage_tam1, offset(-0.15) msymbol(Oh) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(after_treatAGS after_treatCOAH after_treatDGO after_treatNL after_treatSIN ///
after_treatSON after_treatTAM) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
xtitle("Percentage change of wages", size(medium) height(5)) ///
xlabel(-5(1)5, labs(medium) format(%5.0f)) ///
legend( off ) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) levels(90) ///
coeflabels(after_treatAGS = "AGS" after_treatCOAH = "COAH" after_treatDGO = "DGO" ///
after_treatNL = "NL" after_treatSIN = "SIN" after_treatSON = "SON" ///
after_treatTAM = "TAM")
graph export "$doc\graphDDwage.png", replace
*========================================================================*
/* TABLE 4. Effect of English programs (staggered DiD) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"

*gen engl=hrs_exp>=0.1
gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
keep if cohort>=1975 & cohort<=1996

/* Full sample (staggered DiD) */ 
eststo clear
eststo: areg hrs_exp had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg eng had_policy i.cohort i.edu cohort female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg lwage had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg paidw had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
esttab using "$doc\tab_StaggDD.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Callaway and SantAnna (2021) */
destring geo, replace
destring id, replace
gen fist_cohort=0
/*
replace fist_cohort=1990 if state=="01"
replace fist_cohort=1988 if state=="05"
replace fist_cohort=1991 if state=="10"
replace fist_cohort=1987 if state=="19"
replace fist_cohort=1993 if state=="25"
replace fist_cohort=1993 if state=="26"
replace fist_cohort=1990 if state=="28"
*/
replace fist_cohort=1990 if state=="01" & engl==1
replace fist_cohort=1988 if state=="05" & engl==1
replace fist_cohort=1991 if state=="10" & engl==1
replace fist_cohort=1987 if state=="19" & engl==1
replace fist_cohort=1993 if state=="25" & engl==1
replace fist_cohort=1993 if state=="26" & engl==1
replace fist_cohort=1990 if state=="28" & engl==1

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23{
gen educ`x'=edu==`x'
}

csdid paidw female indigenous married educ* [iw=weight], time(cohort) gvar(fist_cohort) method(dripw) vce(cluster geo)
estat all
/*csdid student female indigenous married educ* [iw=weight], time(cohort) gvar(fist_cohort) method(dripw) vce(cluster geo)
estat all*/

keep if paidw==1
csdid hrs_exp female indigenous married educ* [iw=weight], time(cohort) gvar(fist_cohort) method(dripw) vce(cluster geo)
estat all
csdid eng female indigenous married educ* [iw=weight], time(cohort) gvar(fist_cohort) method(dripw) vce(cluster geo) 
estat all
csdid lwage edu female indigenous married educ* [iw=weight], time(cohort) gvar(fist_cohort) method(dripw) vce(cluster geo)
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
/*eventstudyinteract student had_policy [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)*/

eststo clear
eststo: areg hrs_exp had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)
/*eststo: areg student had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)*/
esttab using "$doc\tab_StaggDD.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

/* Enrollment as a mechanism? */
use "$data/eng_abil.dta", clear
grstyle init
grstyle set plain, horizontal
keep if biare==1
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

merge m:1 age using "$data/cumm_enroll_15.dta", nogen

quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=22, absorb(geo) vce(cluster geo)
estimates store age22
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=23, absorb(geo) vce(cluster geo)
estimates store age23
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=24, absorb(geo) vce(cluster geo)
estimates store age24
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=25, absorb(geo) vce(cluster geo)
estimates store age25
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=26, absorb(geo) vce(cluster geo)
estimates store age26
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=27, absorb(geo) vce(cluster geo)
estimates store age27
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=28, absorb(geo) vce(cluster geo)
estimates store age28
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=29, absorb(geo) vce(cluster geo)
estimates store age29
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=30, absorb(geo) vce(cluster geo)
estimates store age30
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)
estimates store age_all

label var had_policy " "

coefplot ///
age22 age23 age24 age25 age26 age27 age28 age29 age30, ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
xtitle("Likelihood of being enrolled in school", size(medium) height(5)) ///
xlabel(-.1(0.1).3, labs(medium) format(%5.2f)) scheme(s2mono) ///
legend( pos(5) ring(0) col(1) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(95) legend(off)
graph save "$doc\graphSDDenroll",replace
graph export "$doc\graphSDDenroll.png", replace

graph hbar (mean) enroll if age>=22 & age<=30, over(age) scheme(s2mono) ///
graphregion(color(white)) ytitle("School enrollment", size(medium) height(5)) ///
ylabel(0(0.1).3, labs(medium) format(%5.2f) nogrid)
graph save "$doc\graph_enroll",replace
graph export "$doc\graph_enroll.png", replace

graph combine "$doc\graphSDDenroll" "$doc\graph_enroll", ///
graphregion(color(white) margin()) cols(2) imargin(1 1.2 1.2 1) scale(0.9)
graph export "$doc\fig_edu_enroll.png", replace

*========================================================================*
/* TABLE 5. Returns to English abilities (IV estimate) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
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
/* FIGURE 5: Effect of English instruction on occupational decisions */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
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
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store farm
quietly areg farm had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store farm_low
quietly areg farm had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store farm_high

quietly areg elem had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store elem
quietly areg elem had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store elem_low
quietly areg elem had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store elem_high

quietly areg mach had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store mach
quietly areg mach had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store mach_low
quietly areg mach had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store mach_high

quietly areg craf had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store craf
quietly areg craf had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store craf_low
quietly areg craf had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store craf_high

quietly areg cust had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store cust
quietly areg cust had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store cust_low
quietly areg cust had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store cust_high

quietly areg sale had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store sale
quietly areg sale had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store sale_low
quietly areg sale had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store sale_high

quietly areg cler had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store cler
quietly areg cler had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store cler_low
quietly areg cler had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store cler_high

quietly areg prof had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store prof
quietly areg prof had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store prof_low
quietly areg prof had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store prof_high

quietly areg mana had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store mana
quietly areg mana had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store mana_low
quietly areg mana had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store mana_high

quietly areg abro had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store abro
quietly areg abro had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store abro_low
quietly areg abro had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store abro_high

label var had_policy " "
/* Panel (a) Farming */
coefplot ///
(farm_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(farm, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(farm_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in farming occupations", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend( pos(5) ring(0) col(1) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterFarm.png", replace
/* Panel (b) Elementary */
coefplot ///
(elem_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(elem, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(elem_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in elementary occupations", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterElem.png", replace
/* Panel (c) Machine operator */
coefplot ///
(mach_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(mach, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(mach_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in machine operator occupations", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterMach.png", replace
/* Panel (d) Crafts */
coefplot ///
(craf_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(craf, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(craf_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in crafts occupations", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterCraft.png", replace
/* Panel (e) Customer service */
coefplot ///
(cust_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(cust, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(cust_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in customer service", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterCust.png", replace
/* Panel (f ) Sales */
coefplot ///
(sale_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(sale, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(sale_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in sales", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterSale.png", replace
/* Panel (g) Clerks */
coefplot ///
(cler_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(cler, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(cler_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in clerical occupations", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterCler.png", replace
/* Panel (h) Professionals */
coefplot ///
(prof_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(prof, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(prof_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in professional occupations", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterProf.png", replace
/* Panel (i) Managerial */
coefplot ///
(mana_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(mana, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(mana_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in managerial occupations", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterMana.png", replace
/* Panel (j) Abroad */
coefplot ///
(abro_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(abro, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(abro_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working abroad", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterAbro.png", replace
*========================================================================*
/* TABLE XX. English programs and English-intensive occupations */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"
keep if cohort>=1975 & cohort<=1996

collapse (mean) eng [fw=weight], by(sinco)
rename eng peng
xtile eng_int=peng, nq(4)
label var peng "Distribution of English speakers across occupations"
histogram peng, frac graphregion(fcolor(white)) color(gs12) ///
xline(0.042, lstyle(grid) lpattern(dash) lcolor(red)) 
graph export "$doc\histo_eng.png", replace
save "$base/peng.dta", replace

use "$data/eng_abil.dta", clear
keep if biare==1
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

merge m:1 sinco using "$base/peng.dta", nogen

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
*gen treat19=cohort==1996 & state=="19"

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
foreach x in 0 1 2 3 4 5 6 7 8 {
	label var treat1`x' "`x'"
}
gen eng_int_occup=eng_int>=3
/* XXX */
areg eng_int_occup treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in English-intensive occupations", size(medium) height(5)) ///
ylabel(-.5(0.25).5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 .5)) recast(connected)
graph export "$doc\PTA_StaggDD_EngOccup.png", replace

areg eng_int_occup treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store low
areg eng_int_occup treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store high

coefplot ///
(low, label("Low-education") msymbol(O) mcolor(gs14) ciopt(lc(gs14) recast(rcap))) ///
(high, label("High-education") msymbol(O) mcolor(dknavy) ciopt(lc(dknavy) recast(rcap))) ///
, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in English-intensive occupations", size(medium) height(5)) ///
ylabel(-.8(.4).8, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white)) size(medium)) ///
ysc(r(-.8 .8)) levels(90) 
graph export "$doc\PTA_StaggDD_HLoccup.png", replace

/* XXX */
/*eststo clear
drop eng_int_occup
gen eng_int_occup=eng_int==4
areg eng_int_occup treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in English-intensive occupations", size(medium) height(5)) ///
ylabel(-.5(0.25).5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 .5)) recast(connected)
graph export "$doc\PTA_StaggDD_EngOccupL.png", replace

areg eng_int_occup treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store low
areg eng_int_occup treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store high

coefplot ///
(low, label("Low-English intensive") msymbol(O) mcolor(gs14) ciopt(lc(gs14) recast(rcap))) ///
(high, label("High-English intensive") msymbol(O) mcolor(dknavy) ciopt(lc(dknavy) recast(rcap))) ///
, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in English-intensive occupations", size(medium) height(5)) ///
ylabel(-.8(.4).8, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white)) size(medium)) ///
ysc(r(-.8 .8)) levels(90) 
graph export "$doc\PTA_StaggDD_HLoccupL.png", replace*/

/*
areg eng_int_occup had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
areg eng_int_occup had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
areg eng_int_occup had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
*/
*========================================================================*
/* TABLE XX. English programs and types of occupations */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
destring sinco, replace
rename sinco sinco2011
merge m:1 sinco2011 using "$data/sinco11_onet19.dta"
drop if _merge==2
drop _merge
merge m:1 o_net_code19 using "$data/onet_physical_activ.dta"
drop if _merge==2
drop _merge
merge m:1 o_net_code19 using "$data/onet_moving_objects.dta"
drop if _merge==2
drop _merge
merge m:1 o_net_code19 using "$data/onet_machines.dta"
drop if _merge==2
drop _merge
merge m:1 o_net_code19 using "$data/onet_doc_info.dta"
drop if _merge==2
drop _merge
merge m:1 o_net_code19 using "$data/onet_communicating.dta"
drop if _merge==2
drop _merge
merge m:1 o_net_code19 using "$data/onet_analyzing.dta"
drop if _merge==2
drop _merge

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
*gen treat19=cohort==1996 & state=="19"

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
foreach x in 0 1 2 3 4 5 6 7 8 {
	label var treat1`x' "`x'"
}

label var phy_act_s "O*NET importance score accross occupations"

histogram phy_act_s, frac graphregion(fcolor(white)) color(gs12) ///
xline(68, lstyle(grid) lpattern(dash) lcolor(red)) 
graph export "$doc\histo_occup.png", replace

gen phy_act1=phy_act_s>=75 & phy_act_s!=.

areg phy_act1 had_policy i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1 & edu>9, absorb(geo) vce(cluster geo)
*========================================================================*
/* XXX */
*========================================================================*
areg phy_act1 treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in physically-intensive jobs", size(medium) height(5)) ///
ylabel(-.5(0.25).5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 .5)) recast(connected)
graph export "$doc\PTA_SDD_PhysicalOccup.png", replace

areg phy_act1 treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store low
areg phy_act1 treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store high

coefplot ///
(low, label("Low-education") msymbol(O) mcolor(gs14) ciopt(lc(gs14) recast(rcap))) ///
(high, label("High-education") msymbol(O) mcolor(dknavy) ciopt(lc(dknavy) recast(rcap))) ///
, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in physically-demanding jobs", size(medium) height(5)) ///
ylabel(-.8(.4).8, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white)) size(medium)) ///
ysc(r(-.8 .8)) levels(90) 
graph export "$doc\PTA_SDD_PhysicalOccup_Educa.png", replace

areg phy_act1 treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1 & female==1, absorb(geo) vce(cluster geo)
estimates store women
areg phy_act1 treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1 & female==0, absorb(geo) vce(cluster geo)
estimates store men

coefplot ///
(women, label("Women") msymbol(O) mcolor(gs14) ciopt(lc(gs14) recast(rcap))) ///
(men, label("Men") msymbol(O) mcolor(dknavy) ciopt(lc(dknavy) recast(rcap))) ///
, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in physically-demanding jobs", size(medium) height(5)) ///
ylabel(-.8(.4).8, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white)) size(medium)) ///
ysc(r(-.8 .8)) levels(90) 
graph export "$doc\PTA_SDD_PhysicalOccup_Gender.png", replace

*========================================================================*

areg communica treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in communication-intensive jobs", size(medium) height(5)) ///
ylabel(-.5(0.25).5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 .5)) recast(connected)
graph export "$doc\PTA_SDD_CommunicaOccup.png", replace

areg communica treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store low
areg communica treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store high

coefplot ///
(low, label("Low-Educational Achievement") msymbol(O) mcolor(gs14) ciopt(lc(gs14) recast(rcap))) ///
(high, label("High-Educational Achievement") msymbol(O) mcolor(dknavy) ciopt(lc(dknavy) recast(rcap))) ///
, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in communication-intensive jobs", size(medium) height(5)) ///
ylabel(-.8(.4).8, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white)) size(medium)) ///
ysc(r(-.8 .8)) levels(90) 
graph export "$doc\PTA_SDD_CommunicaOccup_Educa.png", replace

areg communica treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1 & female==1, absorb(geo) vce(cluster geo)
estimates store women
areg communica treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1 & female==0, absorb(geo) vce(cluster geo)
estimates store men

coefplot ///
(women, label("Women") msymbol(O) mcolor(gs14) ciopt(lc(gs14) recast(rcap))) ///
(men, label("Men") msymbol(O) mcolor(dknavy) ciopt(lc(dknavy) recast(rcap))) ///
, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in communication-intensive jobs", size(medium) height(5)) ///
ylabel(-.8(.4).8, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white)) size(medium)) ///
ysc(r(-.8 .8)) levels(90) 
graph export "$doc\PTA_SDD_CommunicaOccup_Gender.png", replace

*========================================================================*
/* Robustness Checks */ 
*========================================================================*
/*Neighboring states as comparison group in DD models */
*========================================================================*
/* FIGURE 6. Effect of English programs by state with multiple comparison
groups (DiD estimates) */
*========================================================================*
eststo clear
use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="01" | state=="06" | state=="11" | state=="18" | state=="24" ///
| state=="32"
gen treat=state=="01"
gen after=cohort>=1990
replace after=. if cohort<1986 | cohort>1995
gen after_treatAGS=after*treat

quietly areg hrs_exp after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_ags
quietly areg eng after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_ags
quietly areg paidw after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_ags
quietly areg lwage after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_ags

quietly areg hrs_exp after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_ags1
quietly areg eng after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_ags1
quietly areg paidw after_treatAGS treat i.cohort i.edu female indigenous ///
married if edu<=9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_ags1
quietly areg lwage after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_ags1

quietly areg hrs_exp after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_ags2
quietly areg eng after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_ags2
quietly areg paidw after_treatAGS treat i.cohort i.edu female indigenous ///
married if edu>9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_ags2
quietly areg lwage after_treatAGS treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_ags2

use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="05" | state=="08" | state=="24" | state=="32"
gen treat=state=="05"
gen after=cohort>=1988
replace after=. if cohort<1979 | cohort>1996 
gen after_treatCOAH=after*treat

quietly areg hrs_exp after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_coah
quietly areg eng after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_coah
quietly areg paidw after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_coah
quietly areg lwage after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_coah

quietly areg hrs_exp after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_coah1
quietly areg eng after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_coah1
quietly areg paidw after_treatCOAH treat i.cohort i.edu female indigenous ///
married if edu<=9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_coah1
quietly areg lwage after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_coah1

quietly areg hrs_exp after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_coah2
quietly areg eng after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_coah2
quietly areg paidw after_treatCOAH treat i.cohort i.edu female indigenous ///
married if edu>9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_coah2
quietly areg lwage after_treatCOAH treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_coah2

use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="10" | state=="08" | state=="24" | state=="32" | state=="14" 
gen treat=state=="10"
gen after=cohort>=1991
replace after=. if cohort<1985 | cohort>1996 
gen after_treatDGO=after*treat

quietly areg hrs_exp after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_dgo
quietly areg eng after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_dgo
quietly areg paidw after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_dgo
quietly areg lwage after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_dgo

quietly areg hrs_exp after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_dgo1
quietly areg eng after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_dgo1
quietly areg paidw after_treatDGO treat i.cohort i.edu female indigenous ///
married if edu<=9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_dgo1
quietly areg lwage after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_dgo1

quietly areg hrs_exp after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_dgo2
quietly areg eng after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_dgo2
quietly areg paidw after_treatDGO treat i.cohort i.edu female indigenous ///
married if edu>9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_dgo2
quietly areg lwage after_treatDGO treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_dgo2

use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="19" | state=="08" | state=="24" | state=="32"  
gen treat=state=="19"
gen after=cohort>=1987
replace after=. if cohort<1981 | cohort>1996
gen after_treatNL=after*treat

quietly areg hrs_exp after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_nl
quietly areg eng after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_nl
quietly areg paidw after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_nl
quietly areg lwage after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_nl

quietly areg hrs_exp after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_nl1
quietly areg eng after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_nl1
quietly areg paidw after_treatNL treat i.cohort i.edu female indigenous ///
married if edu<=9  [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_nl1
quietly areg lwage after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_nl1

quietly areg hrs_exp after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_nl2
quietly areg eng after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_nl2
quietly areg paidw after_treatNL treat i.cohort i.edu female indigenous ///
married if edu>9  [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_nl2
quietly areg lwage after_treatNL treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_nl2

use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="25" | state=="08" | state=="32" | state=="18" | state=="02" ///
| state=="03"
gen treat=state=="25"
gen after=cohort>=1993
replace after=. if cohort<1989 | cohort>1996 
gen after_treatSIN=after*treat

quietly areg hrs_exp after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_sin
quietly areg eng after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_sin
quietly areg paidw after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_sin
quietly areg lwage after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_sin

quietly areg hrs_exp after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_sin1
quietly areg eng after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_sin1
quietly areg paidw after_treatSIN treat i.cohort i.edu female indigenous ///
married if edu<=9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_sin1
quietly areg lwage after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_sin1

quietly areg hrs_exp after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_sin2
quietly areg eng after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_sin2
quietly areg paidw after_treatSIN treat i.cohort i.edu female indigenous ///
married if edu>9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_sin2
quietly areg lwage after_treatSIN treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_sin2

use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="26" | state=="08" | state=="02" | state=="03" | state=="14" ///
| state=="32"
gen treat=state=="26"
gen after=cohort>=1993
replace after=. if cohort<1991 | cohort>1996 
gen after_treatSON=after*treat

quietly areg hrs_exp after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_son
quietly areg eng after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_son
quietly areg paidw after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_son
quietly areg lwage after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_son

quietly areg hrs_exp after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_son1
quietly areg eng after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_son1
quietly areg paidw after_treatSON treat i.cohort i.edu female indigenous ///
married if edu<=9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_son1
quietly areg lwage after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_son1

quietly areg hrs_exp after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_son2
quietly areg eng after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_son2
quietly areg paidw after_treatSON treat i.cohort i.edu female indigenous ///
married if edu>9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_son2
quietly areg lwage after_treatSON treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_son2

use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="28" | state=="08" | state=="32" | state=="18" | state=="02" ///
| state=="03"
gen treat=state=="28"
gen after=cohort>=1990
replace after=. if cohort<1983 | cohort>1996 
gen after_treatTAM=after*treat

quietly areg hrs_exp after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_tam
quietly areg eng after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_tam
quietly areg paidw after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_tam
quietly areg lwage after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_tam

quietly areg hrs_exp after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_tam1
quietly areg eng after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_tam1
quietly areg paidw after_treatTAM treat i.cohort i.edu female indigenous ///
married if edu<=9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_tam1
quietly areg lwage after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_tam1

quietly areg hrs_exp after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_tam2
quietly areg eng after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_tam2
quietly areg paidw after_treatTAM treat i.cohort i.edu female indigenous ///
married if edu>9 [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_tam2
quietly areg lwage after_treatTAM treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_tam2

label var after_treat " "
/* PANEL (a) Hours of English */
coefplot ///
(hrs_ags2, offset(0.15) msymbol(O) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_ags, msymbol(O) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(hrs_ags1, offset(-0.15) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(hrs_coah2, offset(0.15) msymbol(D) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_coah, msymbol(D) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(hrs_coah1, offset(-0.15) msymbol(D) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(hrs_dgo2, offset(0.15) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_dgo, msymbol(T) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(hrs_dgo1, offset(-0.15) msymbol(T) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(hrs_nl2, offset(0.15) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_nl, msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(hrs_nl1, offset(-0.15) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(hrs_sin2, offset(0.15) msymbol(+) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_sin, msymbol(+) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(hrs_sin1, offset(-0.15) msymbol(+) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(hrs_son2, offset(0.15) msymbol(X) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_son, msymbol(X) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(hrs_son1, offset(-0.15) msymbol(X) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(hrs_tam2, offset(0.15) msymbol(Oh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_tam, msymbol(Oh) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(hrs_tam1, offset(-0.15) msymbol(Oh) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(after_treatAGS after_treatCOAH after_treatDGO after_treatNL after_treatSIN ///
after_treatSON after_treatTAM) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
xtitle("Weekly hours of English instruction", size(medium) height(5)) ///
xlabel(-0.2(0.2)0.8, labs(medium) format(%5.2f)) ///
legend( off ) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) levels(90) ///
coeflabels(after_treatAGS = "AGS" after_treatCOAH = "COAH" after_treatDGO = "DGO" ///
after_treatNL = "NL" after_treatSIN = "SIN" after_treatSON = "SON" ///
after_treatTAM = "TAM")
graph export "$doc\graphDDhrsR.png", replace 
/* PANEL (b) English skills */
coefplot ///
(eng_ags2, offset(0.15) msymbol(O) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_ags, msymbol(O) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(eng_ags1, offset(-0.15) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(eng_coah2, offset(0.15) msymbol(D) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_coah, msymbol(D) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(eng_coah1, offset(-0.15) msymbol(D) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(eng_dgo2, offset(0.15) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_dgo, msymbol(T) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(eng_dgo1, offset(-0.15) msymbol(T) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(eng_nl2, offset(0.15) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_nl, msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(eng_nl1, offset(-0.15) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(eng_sin2, offset(0.15) msymbol(+) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_sin, msymbol(+) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(eng_sin1, offset(-0.15) msymbol(+) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(eng_son2, offset(0.15) msymbol(X) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_son, msymbol(X) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(eng_son1, offset(-0.15) msymbol(X) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(eng_tam2, offset(0.15) msymbol(Oh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_tam, msymbol(Oh) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(eng_tam1, offset(-0.15) msymbol(Oh) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(after_treatAGS after_treatCOAH after_treatDGO after_treatNL after_treatSIN ///
after_treatSON after_treatTAM) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
xtitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
xlabel(-0.6(0.2)0.8, labs(medium) format(%5.2f)) ///
legend( off ) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) levels(90) ///
coeflabels(after_treatAGS = "AGS" after_treatCOAH = "COAH" after_treatDGO = "DGO" ///
after_treatNL = "NL" after_treatSIN = "SIN" after_treatSON = "SON" ///
after_treatTAM = "TAM")
graph export "$doc\graphDDengR.png", replace
/* PANEL (c) Paid work */
coefplot ///
(paid_ags2, offset(0.15) msymbol(O) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_ags, msymbol(O) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(paid_ags1, offset(-0.15) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(paid_coah2, offset(0.15) msymbol(D) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_coah, msymbol(D) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(paid_coah1, offset(-0.15) msymbol(D) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(paid_dgo2, offset(0.15) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_dgo, msymbol(T) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(paid_dgo1, offset(-0.15) msymbol(T) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(paid_nl2, offset(0.15) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_nl, msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(paid_nl1, offset(-0.15) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(paid_sin2, offset(0.15) msymbol(+) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_sin, msymbol(+) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(paid_sin1, offset(-0.15) msymbol(+) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(paid_son2, offset(0.15) msymbol(X) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_son, msymbol(X) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(paid_son1, offset(-0.15) msymbol(X) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(paid_tam2, offset(0.15) msymbol(Oh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_tam, msymbol(Oh) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(paid_tam1, offset(-0.15) msymbol(Oh) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(after_treatAGS after_treatCOAH after_treatDGO after_treatNL after_treatSIN ///
after_treatSON after_treatTAM) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
xtitle("Likelihood of working for pay", size(medium) height(5)) ///
xlabel(-0.6(0.2)0.8, labs(medium) format(%5.2f)) ///
legend( off ) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) levels(90) ///
coeflabels(after_treatAGS = "AGS" after_treatCOAH = "COAH" after_treatDGO = "DGO" ///
after_treatNL = "NL" after_treatSIN = "SIN" after_treatSON = "SON" ///
after_treatTAM = "TAM")
graph export "$doc\graphDDpaidR.png", replace
 
/* PANEL (d) Wages */
coefplot ///
(wage_ags2, offset(0.15) msymbol(O) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_ags, msymbol(O) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(wage_ags1, offset(-0.15) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(wage_coah2, offset(0.15) msymbol(D) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_coah, msymbol(D) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(wage_coah1, offset(-0.15) msymbol(D) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(wage_dgo2, offset(0.15) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_dgo, msymbol(T) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(wage_dgo1, offset(-0.15) msymbol(T) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(wage_nl2, offset(0.15) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_nl, msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(wage_nl1, offset(-0.15) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(wage_sin2, offset(0.15) msymbol(+) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_sin, msymbol(+) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(wage_sin1, offset(-0.15) msymbol(+) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(wage_son2, offset(0.15) msymbol(X) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_son, msymbol(X) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(wage_son1, offset(-0.15) msymbol(X) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(wage_tam2, offset(0.15) msymbol(Oh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_tam, msymbol(Oh) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(wage_tam1, offset(-0.15) msymbol(Oh) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(after_treatAGS after_treatCOAH after_treatDGO after_treatNL after_treatSIN ///
after_treatSON after_treatTAM) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
xtitle("Percentage change of wages", size(medium) height(5)) ///
xlabel(-5(1)5, labs(medium) format(%5.0f)) ///
legend( off ) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) levels(90) ///
coeflabels(after_treatAGS = "AGS" after_treatCOAH = "COAH" after_treatDGO = "DGO" ///
after_treatNL = "NL" after_treatSIN = "SIN" after_treatSON = "SON" ///
after_treatTAM = "TAM")
graph export "$doc\graphDDwageR.png", replace
*========================================================================*
/* TABLE 6. Returns to English abilities
(IV estimate with narrower comparison group) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
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
eststo: areg lwage eng i.cohort i.edu female student indigenous ///
married [aw=weight] if had_policy!=. & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.cohort i.edu female indigenous ///
married [aw=weight] if had_policy!=. & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female indigenous ///
married [aw=weight] if had_policy!=. & paidw==1, absorb(geo) vce(cluster geo)
eststo: quietly ivregress 2sls lwage (eng=had_policy) i.geo i.cohort i.edu ///
female indigenous married [aw=weight] if had_policy!=. & paidw==1, vce(cluster geo)
esttab using "$doc\tabIVa.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(eng had_policy) ///
stats(N ar2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* TABLE 7. Intention to Treat effect of offering English instruction at 
school (Robust SDD estimate) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
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

*========================================================================*
/* APPENDIX */
*========================================================================*
/* FIGURE A.5. Pre-trends test pooling all states (SDD estimate) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
gen engl=hrs_exp>=0.3
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

/*destring state, replace
gen state_cohort=state*cohort

eststo clear
eststo: areg hrs_exp had_policy i.cohort i.edu female indigenous married i.state_cohort ///
[aw=weight]  if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.cohort i.edu female indigenous married i.state_cohort ///
[aw=weight]  if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw had_policy i.cohort i.edu female indigenous married i.state_cohort ///
[aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female indigenous married i.state_cohort ///
[aw=weight]  if paidw==1, absorb(geo) vce(cluster geo)*/
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<=================================================================== I modified this part!!!
gen treat2=cohort==1980 & engl==1 & state=="05"
gen treat3=cohort==1981 & engl==1 & state=="05"
gen treat4=cohort==1981 & engl==1 & state=="19"
gen treat5=cohort==1982 & engl==1 & state=="19"
gen treat6=cohort==1983 & engl==1 & state=="19"
gen treat7=cohort==1984 & engl==1 & state=="19"
gen treat8=cohort==1985 & engl==1 & state=="19"
gen treat9=cohort==1986 & engl==1 & state=="19"
gen treat10=cohort==1987 & engl==1 & state=="19"
gen treat11=cohort==1988 & engl==1 & state=="19"
gen treat12=cohort==1989 & engl==1 & state=="19"
gen treat13=cohort==1990 & engl==1 & state=="19"
gen treat14=cohort==1991 & engl==1 & state=="19"
gen treat15=cohort==1992 & engl==1 & state=="19"
gen treat16=cohort==1993 & engl==1 & state=="19"
gen treat17=cohort==1994 & engl==1 & state=="19"
gen treat18=cohort==1995 & engl==1 & state=="19"
*gen treat19=cohort==1996 & state=="19"

replace treat6=1 if cohort==1986 & engl==1 & state=="01"
replace treat7=1 if cohort==1987 & engl==1 & state=="01"
replace treat8=1 if cohort==1988 & engl==1 & state=="01"
replace treat9=1 if cohort==1989 & engl==1 & state=="01"
replace treat10=1 if cohort==1990 & engl==1 & state=="01"
replace treat11=1 if cohort==1991 & engl==1 & state=="01"
replace treat12=1 if cohort==1992 & engl==1 & state=="01"
replace treat13=1 if cohort==1993 & engl==1 & state=="01"
replace treat14=1 if cohort==1994 & engl==1 & state=="01"
replace treat15=1 if cohort==1995 & engl==1 & state=="01"
replace treat16=1 if cohort==1996 & engl==1 & state=="01"

replace treat4=1 if cohort==1982 & engl==1 & state=="05"
replace treat5=1 if cohort==1983 & engl==1 & state=="05"
replace treat6=1 if cohort==1984 & engl==1 & state=="05"
replace treat7=1 if cohort==1985 & engl==1 & state=="05"
replace treat8=1 if cohort==1986 & engl==1 & state=="05"
replace treat9=1 if cohort==1987 & engl==1 & state=="05"
replace treat10=1 if cohort==1988 & engl==1 & state=="05"
replace treat11=1 if cohort==1989 & engl==1 & state=="05"
replace treat12=1 if cohort==1990 & engl==1 & state=="05"
replace treat13=1 if cohort==1991 & engl==1 & state=="05"
replace treat14=1 if cohort==1992 & engl==1 & state=="05"
replace treat15=1 if cohort==1993 & engl==1 & state=="05"
replace treat16=1 if cohort==1994 & engl==1 & state=="05"
replace treat17=1 if cohort==1995 & engl==1 & state=="05"
replace treat18=1 if cohort==1996 & engl==1 & state=="05"

replace treat4=1 if cohort==1985 & engl==1 & state=="10"
replace treat5=1 if cohort==1986 & engl==1 & state=="10"
replace treat6=1 if cohort==1987 & engl==1 & state=="10"
replace treat7=1 if cohort==1988 & engl==1 & state=="10"
replace treat8=1 if cohort==1989 & engl==1 & state=="10"
replace treat9=1 if cohort==1990 & engl==1 & state=="10"
replace treat10=1 if cohort==1991 & engl==1 & state=="10"
replace treat11=1 if cohort==1992 & engl==1 & state=="10"
replace treat12=1 if cohort==1993 & engl==1 & state=="10"
replace treat13=1 if cohort==1994 & engl==1 & state=="10"
replace treat14=1 if cohort==1995 & engl==1 & state=="10"
replace treat15=1 if cohort==1996 & engl==1 & state=="10"

replace treat6=1 if cohort==1989 & engl==1 & state=="25"
replace treat7=1 if cohort==1990 & engl==1 & state=="25"
replace treat8=1 if cohort==1991 & engl==1 & state=="25"
replace treat9=1 if cohort==1992 & engl==1 & state=="25"
replace treat10=1 if cohort==1993 & engl==1 & state=="25"
replace treat11=1 if cohort==1994 & engl==1 & state=="25"
replace treat12=1 if cohort==1995 & engl==1 & state=="25"
replace treat13=1 if cohort==1996 & engl==1 & state=="25"

*replace treat7=1 if cohort==1990 & state=="26"
replace treat8=1 if cohort==1991 & engl==1 & state=="26"
replace treat9=1 if cohort==1992 & engl==1 & state=="26"
replace treat10=1 if cohort==1993 & engl==1 & state=="26"
replace treat11=1 if cohort==1994 & engl==1 & state=="26"
replace treat12=1 if cohort==1995 & engl==1 & state=="26"
replace treat13=1 if cohort==1996 & engl==1 & state=="26"

replace treat3=1 if cohort==1983 & engl==1 & state=="28"
replace treat4=1 if cohort==1984 & engl==1 & state=="28"
replace treat5=1 if cohort==1985 & engl==1 & state=="28"
replace treat6=1 if cohort==1986 & engl==1 & state=="28"
replace treat7=1 if cohort==1987 & engl==1 & state=="28"
replace treat8=1 if cohort==1988 & engl==1 & state=="28"
replace treat9=1 if cohort==1989 & engl==1 & state=="28"
replace treat10=1 if cohort==1990 & engl==1 & state=="28"
replace treat11=1 if cohort==1991 & engl==1 & state=="28"
replace treat12=1 if cohort==1992 & engl==1 & state=="28"
replace treat13=1 if cohort==1993 & engl==1 & state=="28"
replace treat14=1 if cohort==1994 & engl==1 & state=="28"
replace treat15=1 if cohort==1995 & engl==1 & state=="28"
replace treat16=1 if cohort==1996 & engl==1 & state=="28"

replace treat9=0

label var treat2 "-8"
label var treat3 "-7"
label var treat4 "-6"
label var treat5 "-5"
label var treat6 "-4"
label var treat7 "-3"
label var treat8 "-2"
label var treat9 "-1"
foreach x in 0 1 2 3 4 5 6 7 8 {
	label var treat1`x' "`x'"
}
/* Panel (a) Hours of English */
areg hrs_exp treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1995 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-0.5(0.25)1.25, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 1.25)) recast(connected)
graph export "$doc\PTA_StaggDD1.png", replace
/* Panel (b) Speak English */
areg eng treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) recast(connected)
graph export "$doc\PTA_StaggDD2.png", replace
/* Panel (c) Paid work */
areg paidw treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) recast(connected)
graph export "$doc\PTA_StaggDD3.png", replace
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
graph export "$doc\PTA_StaggDD4.png", replace
/* Panel not shown: School enrollment */
areg student treat* i.cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of being enrolled in school", size(medium) height(5)) ///
ylabel(-.5(.25).5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-.5 .5)) recast(connected)
graph export "$doc\PTA_StaggDD5.png", replace
*========================================================================*
/* Figure XX */
*========================================================================*
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

/* Elementary occupations */
areg elem treat* i.cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1996, absorb(geo) vce(cluster geo)
estimates store elem
areg mach treat* i.cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1996, absorb(geo) vce(cluster geo)
estimates store mach

areg elem treat* i.cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
estimates store elem_low
areg elem treat* i.cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1996 & edu>9, absorb(geo) vce(cluster geo)
estimates store elem_high

coefplot ///
(elem, label("Elementary") msymbol(O) mcolor(dkorange) ciopt(lc(dkorange) recast(rcap))) ///
(mach, label("Machine operators") msymbol(O) mcolor(dknavy) ciopt(lc(dknavy) recast(rcap))) ///
, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in an specific occupation", size(medium) height(5)) ///
ylabel(-.5(.25).5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend( pos(5) ring(0) col(1) region(lcolor(white)) size(medium)) ///
ysc(r(-.5 .5)) levels(90) 
graph export "$doc\PTA_StaggDDoccup.png", replace

coefplot ///
(elem_low, label("Low-education") msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))) ///
(elem_high, label("High-education") msymbol(O) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in elementary occupations", size(medium) height(5)) ///
ylabel(-.5(.25).5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend( pos(5) ring(0) col(1) region(lcolor(white)) size(medium)) ///
ysc(r(-.5 .5)) levels(90) 
graph export "$doc\PTA_StaggDDelem.png", replace
*========================================================================*
/* FIGURE A.7. Pre-trends test pooling all states 
(SDD estimate with a narrower comparison group) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
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
areg hrs_exp treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(6, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-0.5(0.25)1.25, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 1.25)) recast(connected)
graph export "$doc\PTA_StaggDDa1.png", replace
/* Panel (b) Speak English */
areg eng treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(6, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) recast(connected)
graph export "$doc\PTA_StaggDDa2.png", replace
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
graph export "$doc\PTA_StaggDDa3.png", replace
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
graph export "$doc\PTA_StaggDDa4.png", replace
*========================================================================*
/* TABLE A.2. Heterogenous effects */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
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
*========================================================================*
/* By gender */
*========================================================================*
/* Panel A: Men */
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
*========================================================================*
/* By educational attainment */
*========================================================================*
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
/* By ethnicity */
*========================================================================*
/* Panel E: Indigenous */
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
/* Panel F: Non-indigenous */
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
/* Difference in estimate by ethnicity */
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
/* By geographical context */
*========================================================================*
/* Panel G: Rural */
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
/* Panel H: Urban */
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
/* Difference in estimate by geographical contex */
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
