*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/data/main"
gl base= "C:\Users\galve\Documents\Papers\Current\Returns to Eng Mex\Data"
gl doc= "C:\Users\galve\Documents\Papers\Current\Returns to Eng Mex\Doc"
*========================================================================*
/* Returns to English skills */
*========================================================================*
use "$base\eng_abil.dta", clear
/* Full sample */
eststo clear
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65, vce(cluster geo)
eststo: reg lwage eng i.edu expe expe2 [aw=weight] if age>=18 ///
& age<=65, vce(cluster geo)
eststo: reg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, vce(cluster geo)
eststo: areg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & edu<=9, vce(cluster geo)
eststo: reg lwage eng i.edu expe expe2 [aw=weight] if age>=18 ///
& age<=65 & edu<=9, vce(cluster geo)
eststo: reg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65 & edu<=9, vce(cluster geo)
eststo: areg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65 & edu<=9, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace

/* Men */
eststo clear
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65  & female==0, ///
vce(cluster geo)
eststo: reg lwage eng i.edu expe expe2 [aw=weight] if (age>=18 ///
& age<=65) & female==0, vce(cluster geo)
eststo: reg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==0, vce(cluster geo)
eststo: areg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==0, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==0, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65  & female==0 & edu<=9, ///
vce(cluster geo)
eststo: reg lwage eng i.edu expe expe2 [aw=weight] if (age>=18 ///
& age<=65) & female==0 & edu<=9, vce(cluster geo)
eststo: reg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==0 & edu<=9, vce(cluster geo)
eststo: areg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==0 & edu<=9, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==0 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace

/* Women */
eststo clear
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65  & female==1, ///
vce(cluster geo)
eststo: reg lwage eng i.edu expe expe2 [aw=weight] if (age>=18 ///
& age<=65) & female==1, vce(cluster geo)
eststo: reg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==1, vce(cluster geo)
eststo: areg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==1, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==1, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65  & female==1 & edu<=9, ///
vce(cluster geo)
eststo: reg lwage eng i.edu expe expe2 [aw=weight] if (age>=18 ///
& age<=65) & female==1 & edu<=9, vce(cluster geo)
eststo: reg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==1 & edu<=9, vce(cluster geo)
eststo: areg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==1 & edu<=9, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==1 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace

/* Gender */
gen eng_female=eng*female
eststo clear
eststo: reg lwage eng_female eng female [aw=weight] if age>=18 & age<=65, vce(cluster geo)
eststo: reg lwage eng_female eng edu expe expe2 female [aw=weight] if age>=18 ///
& age<=65, vce(cluster geo)
eststo: reg lwage eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, vce(cluster geo)
eststo: areg lwage eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, absorb(state) vce(cluster geo)
eststo: areg lwage eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng_female eng female [aw=weight] if age>=18 & age<=65 & edu<=9, vce(cluster geo)
eststo: reg lwage eng_female eng edu expe expe2 female [aw=weight] if age>=18 ///
& age<=65 & edu<=9, vce(cluster geo)
eststo: reg lwage eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65 & edu<=9, vce(cluster geo)
eststo: areg lwage eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65 & edu<=9, absorb(state) vce(cluster geo)
eststo: areg lwage eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65 & edu<=9, absorb(geo) vce(cluster geo)
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
areg lwage eng edu expe expe2 female rural female_hh age_hh edu_hh married ///
engedu* [aw=weight] if age>=18 & age<=65, absorb(geo) vce(cluster geo)

*graph set window fontface "Times New Roman"
coefplot, vertical keep(engedu*) yline(0) omitted baselevels ///
ytitle("Returns to English abilities by education levels", size(small) height(5)) ///
ylabel(-4(2)4, labs(small) grid) ///
xtitle("Levels of education", size(small) height(5)) xlabel(,labs(small)) ///
graphregion(color(white)) scheme(s2mono) recast(connected) ciopts(recast(rcap)) ///
ysc(r(-0.5 1)) 
graph export "$doc\eng_abil_edu.png", replace 
*========================================================================*
/* English abilities in Aguascalientes */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="01" | state=="32"
gen treat=state=="01"
gen after=cohort>=1990
replace after=. if cohort<1986 | cohort>1995
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ags.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ags_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ags_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen eng_female=after_treat*female
eststo clear
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ags_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(eng_female) replace 
*========================================================================*
/* PTA */
foreach x in 86 87 88 89 90 91 92 93 94 95 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_89=0

areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight] if cohort>=1986 & cohort<=1995, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 3.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGS.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 student work indigenous ///
[aw=weight] if cohort>=1986 & cohort<=1995, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGS1.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight] if cohort>=1986 & cohort<=1995, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGS2.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight] if cohort>=1986 & cohort<=1995, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 3.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGS3.png", replace
/* Low education */
areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight]if cohort>=1986 & cohort<=1995 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 3.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGS_edu.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
[aw=weight]if cohort>=1986 & cohort<=1995 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGS1_edu.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1986 & cohort<=1995 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGS2_edu.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1986 & cohort<=1995 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 3.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGS3_edu.png", replace
*========================================================================*
/* English abilities in Nuevo Leon */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="19" | state=="24"
gen treat=state=="19"
gen after=cohort>=1987
replace after=. if cohort<1981 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_nl.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_nl_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_nl_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen eng_female=after_treat*female
eststo clear
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_nl_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(eng_female) replace 
*========================================================================*
/* PTA */
foreach x in 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_86=0

areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 3.2 "Eng program in 6th grade", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_NL.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.2 "Eng program in 6th grade", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_NL1.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.2 "Eng program in 6th grade", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_NL2.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 3.2 "Eng program in 6th grade", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_NL3.png", replace
/* Low education */
areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight]if cohort>=1981 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 3.2 "Eng program in 6th grade", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_NL_edu.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
[aw=weight]if cohort>=1981 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.2 "Eng program in 6th grade", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_NL1_edu.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1981 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.2 "Eng program in 6th grade", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_NL2_edu.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1981 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 3.2 "Eng program in 6th grade", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_NL3_edu.png", replace
*========================================================================*
/* English abilities in Tamaulipas */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="28" | state=="02"
gen treat=state=="28"
gen after=cohort>=1990
replace after=. if cohort<1983 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_tam.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0 & edu<=9 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0 & edu<=9 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_tam_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_tam_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen eng_female=after_treat*female
eststo clear
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_tam_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(eng_female) replace
*========================================================================*
/* PTA */
foreach x in 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_89=0

areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 6 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_TAM.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 6 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_TAM1.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 6 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_TAM2.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 6 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_TAM3.png", replace
/* Low education */
areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight]if cohort>=1981 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 6 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_TAM_edu.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
[aw=weight]if cohort>=1981 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 6 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_TAM1_edu.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1981 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 6 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_TAM2_edu.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1981 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 6 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_TAM3_edu.png", replace
*========================================================================*
/* English abilities in Durango */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="10" | state=="24"
gen treat=state=="10"
gen after=cohort>=1991
replace after=. if cohort<1985 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_dgo.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_dgo_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_dgo_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen eng_female=after_treat*female
eststo clear
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_dgo_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(eng_female) replace 
*========================================================================*
/* PTA */
foreach x in 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_90=0

areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight] if cohort>=1985 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 5.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_DGO.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 student work indigenous ///
[aw=weight] if cohort>=1985 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 5.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_DGO1.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight] if cohort>=1985 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 5.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_DGO2.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight] if cohort>=1985 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 5.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_DGO3.png", replace
/* Low education */
areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight]if cohort>=1985 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 5.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_DGO_edu.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
[aw=weight]if cohort>=1985 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 5.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_DGO1_edu.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1985 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 5.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_DGO2_edu.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1985 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 5.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_DGO3_edu.png", replace
*========================================================================*
/* English abilities in Morelos */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="17" | state=="21"
gen treat=state=="17"
gen after=cohort>=1981
replace after=. if cohort<1966 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_mor.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_mor_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_mor_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen eng_female=after_treat*female
eststo clear
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_mor_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(eng_female) replace 
*========================================================================*
/* PTA */
foreach x in 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 ///
86 87 88 89 90 91 92 93 94 95 96{
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_81=0

areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight] if cohort>=1966 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(16.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 12.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_MOR.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 student work indigenous ///
[aw=weight] if cohort>=1966 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(16.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-2(1)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-2 2)) text(2.4 12.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_MOR1.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight] if cohort>=1966 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(16.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 12.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_MOR2.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight] if cohort>=1966 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(16.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 12.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_MOR3.png", replace
/* Low education */
areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight]if cohort>=1966 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(16.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 12.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_MOR_edu.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
[aw=weight]if cohort>=1966 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(16.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-2(1)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-2 2)) text(2.4 12.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_MOR1_edu.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1966 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(16.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 12.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_MOR2_edu.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1966 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(16.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 12.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_MOR3_edu.png", replace
*========================================================================*
/* English abilities in Sinaloa */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="25" | state=="18"
gen treat=state=="25"
gen after=cohort>=1993
replace after=. if cohort<1989 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_sin.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_sin_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_sin_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen eng_female=after_treat*female
eststo clear
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_sin_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(eng_female) replace 
*========================================================================*
/* PTA */
foreach x in 89 90 91 92 93 94 95 96{
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_92=0

areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight] if cohort>=1989 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 3.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SIN.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 student work indigenous ///
[aw=weight] if cohort>=1989 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-1(1)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SIN1.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight] if cohort>=1966 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SIN2.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight] if cohort>=1966 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 3.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SIN3.png", replace
/* Low education */
areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight]if cohort>=1966 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(16.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 12.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SIN_edu.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
[aw=weight]if cohort>=1966 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(16.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-2(1)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-2 2)) text(2.4 12.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SIN1_edu.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1966 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(16.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 12.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SIN2_edu.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1966 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(16.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 12.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SIN3_edu.png", replace
*========================================================================*
/* English abilities in Sonora */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="26" | state=="02"
gen treat=state=="26"
gen after=cohort>=1993
replace after=. if cohort<1989 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_son.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_son_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_son_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen eng_female=after_treat*female
eststo clear
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */	
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_son_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(eng_female) replace 
*========================================================================*
/* PTA */
foreach x in 89 90 91 92 93 94 95 96{
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_92=0

areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight] if cohort>=1989 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 3.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SON.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 student work indigenous ///
[aw=weight] if cohort>=1989 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-1(1)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SON1.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight] if cohort>=1989 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SON2.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight] if cohort>=1989 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 3.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SON3.png", replace
/* Low education */
areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight]if cohort>=1989 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 3.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SON_edu.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
[aw=weight]if cohort>=1990 & cohort<=1989 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-2(1)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-2 2)) text(2.4 3.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SON1_edu.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1990 & cohort<=1989 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SON2_edu.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1989 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 3.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SON3_edu.png", replace
*========================================================================*
/* English abilities in Coahuila */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="05" | state=="08"
gen treat=state=="05"
gen after=cohort>=1988
replace after=. if cohort<1979 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_coah.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_coah_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_coah_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen eng_female=after_treat*female
eststo clear
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_coah_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(eng_female) replace 
*========================================================================*
/* PTA */
foreach x in 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_87=0

areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight]if cohort>=1979 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 7.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_COAH.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
[aw=weight]if cohort>=1979 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-3(1)3, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-3 3)) text(3.6 7.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_COAH1.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1979 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 8.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_COAH2.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1979 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 7.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_COAH3.png", replace
/* Low education */
areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight]if cohort>=1979 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 7.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_COAH_edu.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
[aw=weight]if cohort>=1979 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 7.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_COAH1_edu.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1979 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 7.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_COAH2_edu.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1979 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 7.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_COAH3_edu.png", replace
*========================================================================*
/* English abilities in Guerrero */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="12" 
*| state=="20"
gen treat=state=="12" & rural==0
gen after=cohort>=1989
replace after=. if cohort<1981 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_gro.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_gro_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_gro_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen eng_female=after_treat*female
eststo clear
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng eng_female after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work eng_female after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage eng_female after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_gro_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(eng_female) replace 
*========================================================================*
/* PTA */
foreach x in 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_87=0

areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 5.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_GRO.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-3(1)3, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-3 3)) text(3.6 5.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_GRO1.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 5.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_GRO2.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 5.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_GRO3.png", replace
/* Low education */
areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight]if cohort>=1981 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 7.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_GRO_edu.png", replace

areg hrs_exp treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
[aw=weight]if cohort>=1981 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 7.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_GRO1_edu.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1981 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 7.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_GRO2_edu.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1981 & cohort<=1996 & edu<=9, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 7.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_GRO3_edu.png", replace

*========================================================================*
/* English abilities in Nuevo Leon and Tamaulipas */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="02" | state=="08" | state=="19" | state=="28"
drop if state!=state5
*gen cohort=2014-age
gen had_policy=0 
replace had_policy=1 if state=="19" & age>=18 & age<=27
replace had_policy=1 if state=="28" & age>=18 & age<=23
destring state, replace
keep if age>=18 & age<=37
replace eng=0 if eng==.
gen edu2=edu^2

eststo clear
eststo: areg eng had_policy i.state [aw=weight], absorb(cohort) vce(cluster geo)
eststo: areg eng had_policy i.state edu edu2 female student work indigenous ///
[aw=weight], absorb(cohort) vce(cluster geo)
eststo: areg eng had_policy i.cohort edu edu2 female student work indigenous ///
[aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_eng_abil2.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English instruction and Eng abilities) keep(had_policy) replace

foreach x in 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if state==02 | state==08
	label var treat_`x' "19`x'"
}
replace treat_86=0

areg eng treat_* i.state cohort* edu edu2 female student work indigenous ///
[aw=weight] if age>=18 & age<=37, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xline(11.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.62 5.6 "Eng program NL", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.62 10.2 "Eng program Tam", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\eng_abil2.png", replace 
