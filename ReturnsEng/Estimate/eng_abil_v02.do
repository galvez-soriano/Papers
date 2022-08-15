*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/data/main"
gl base= "C:\Users\ogalvez\Documents\EngAbil\Data"
gl doc= "C:\Users\ogalvez\Documents\EngAbil\Doc"
*========================================================================*
/* TABLE 6: Returns to English skills */
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
areg lwage eng i.edu expe expe2 female rural female_hh age_hh edu_hh married ///
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
/* TABLE 7: Intention to Treat Effect */
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
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ags.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 86 87 88 89 90 91 92 93 94 95 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_89=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
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

areg hrs_exp treat_* treat i.cohort cohort i.edu student work indigenous ///
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

areg work treat_* treat i.cohort cohort i.edu female indigenous inc_hh edu_hh ///
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

areg lwage treat_* treat i.cohort cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if cohort>=1986 & cohort<=1995, absorb(geo) vce(cluster geo)
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
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_coah.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_87=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
inc_hh edu_hh [aw=weight] if cohort>=1979 & cohort<=1996, absorb(geo) vce(cluster geo)
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

areg hrs_exp treat_* treat i.cohort cohort i.edu female student work indigenous ///
[aw=weight] if cohort>=1979 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-3(1)3, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-3 3)) text(3.6 7.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_COAH1.png", replace

areg work treat_* treat i.cohort cohort i.edu female indigenous inc_hh edu_hh ///
[aw=weight] if cohort>=1979 & cohort<=1996, absorb(geo) vce(cluster geo)
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

areg lwage treat_* treat i.cohort cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if cohort>=1979 & cohort<=1996, absorb(geo) vce(cluster geo)
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
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_dgo.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_90=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
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

areg hrs_exp treat_* treat i.cohort cohort i.edu student work indigenous ///
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

areg work treat_* treat i.cohort cohort i.edu female indigenous inc_hh edu_hh ///
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

areg lwage treat_* treat i.cohort cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if cohort>=1985 & cohort<=1996, absorb(geo) vce(cluster geo)
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
*========================================================================*
/* English abilities in Morelos */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="17" | state=="21"
gen treat=state=="17"
gen after=cohort>=1981
replace after=. if cohort<1967 | cohort>1996 
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_mor.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 ///
86 87 88 89 90 91 92 93 94 95 96{
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_81=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
inc_hh edu_hh [aw=weight] if cohort>=1967 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(15.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 11.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_MOR.png", replace

areg hrs_exp treat_* treat i.cohort cohort i.edu student work indigenous ///
[aw=weight] if cohort>=1967 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(15.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-2(1)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-2 2)) text(2.4 11.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_MOR1.png", replace

areg work treat_* treat i.cohort cohort i.edu female indigenous inc_hh edu_hh ///
[aw=weight] if cohort>=1967 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(15.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 11.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_MOR2.png", replace

areg lwage treat_* treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if cohort>=1967 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(15.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 11.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_MOR3.png", replace
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
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_nl.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_86=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
inc_hh edu_hh [aw=weight] if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
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

areg hrs_exp treat_* treat i.cohort cohort i.edu female student work indigenous ///
[aw=weight] if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.2 "Eng program in 6th grade", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_NL1.png", replace

areg work treat_* treat i.cohort cohort i.edu female indigenous inc_hh edu_hh ///
[aw=weight] if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
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

areg lwage treat_* treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
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
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_sin.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 89 90 91 92 93 94 95 96{
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_92=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
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

areg hrs_exp treat_* treat i.cohort cohort i.edu student work indigenous ///
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

areg work treat_* treat i.cohort cohort i.edu female indigenous inc_hh edu_hh ///
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

areg lwage treat_* treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if cohort>=1966 & cohort<=1996, absorb(geo) vce(cluster geo)
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
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_son.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 89 90 91 92 93 94 95 96{
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_92=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
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

areg hrs_exp treat_* treat i.cohort cohort i.edu student work indigenous ///
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

areg work treat_* treat i.cohort cohort i.edu female indigenous inc_hh edu_hh ///
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

areg lwage treat_* treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if cohort>=1989 & cohort<=1996, absorb(geo) vce(cluster geo)
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
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_tam.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_89=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
inc_hh edu_hh [aw=weight] if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
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

areg hrs_exp treat_* treat i.cohort cohort i.edu female student work indigenous ///
[aw=weight] if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 6 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_TAM1.png", replace

areg work treat_* treat i.cohort cohort i.edu female indigenous inc_hh edu_hh ///
[aw=weight] if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
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

areg lwage treat_* treat i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
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
*========================================================================*
/* Staggered DiD: All states */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" | state=="17" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="08" | state=="18" | state=="21" ///
| state=="24" | state=="32"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="17" & (cohort>=1982 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
destring state, replace
keep if cohort>=1975 & cohort<=1996

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_StaggDD.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

foreach x in 75 76 77 78 79 80 81 82 83 84 85 86 87 ///
88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if state==02 | state==08 | state==18 | state==21 ///
| state==24 | state==32
	label var treat_`x' "19`x'"
}
replace treat_80=0

areg eng treat_* i.state i.cohort cohort i.edu female student work indigenous ///
inc_hh edu_hh [aw=weight] if cohort>=1975 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(12.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(13.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(15.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(16.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(18.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 5 "MOR", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.6 11.3 "NL", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.6 12.2 "COAH", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.61 14.2 "AGS", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.58 14.2 "TAM", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.6 15.4 "DGO", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.61 17.3 "SIN", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.58 17.3 "SON", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_StaggDD.png", replace

areg hrs_exp treat_* i.state i.cohort cohort i.edu female student work indigenous ///
[aw=weight] if cohort>=1975 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(12.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(13.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(15.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(16.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(18.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.75, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.75)) text(0.87 5 "MOR", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.87 11.3 "NL", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.87 12.2 "COAH", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.88 14.2 "AGS", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.85 14.2 "TAM", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.87 15.4 "DGO", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.88 17.3 "SIN", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.85 17.3 "SON", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_StaggDD1.png", replace

areg work treat_* i.state i.cohort cohort i.edu female indigenous inc_hh ///
edu_hh [aw=weight] if cohort>=1975 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(12.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(13.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(15.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(16.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(18.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 5 "MOR", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.6 11.3 "NL", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.6 12.2 "COAH", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.61 14.2 "AGS", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.58 14.2 "TAM", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.6 15.4 "DGO", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.61 17.3 "SIN", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.58 17.3 "SON", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_StaggDD2.png", replace

areg lwage treat_* i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if cohort>=1975 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(12.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(13.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(15.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(16.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(18.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-2(1)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-2 2)) text(2.4 5 "MOR", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(2.4 11.3 "NL", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(2.4 12.2 "COAH", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(2.45 14.2 "AGS", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(2.35 14.2 "TAM", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(2.4 15.4 "DGO", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(2.45 17.3 "SIN", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(2.35 17.3 "SON", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_StaggDD3.png", replace
*========================================================================*
/* Staggered DiD: Less exposure (Durango, Sinaloa, Sonora and Nuevo 
Leon) */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="10" | state=="25" | state=="26" | state=="19" ///
| state=="02" | state=="18" | state=="24"

gen had_policy=0 
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
destring state, replace
keep if cohort>=1983 & cohort<=1996

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_StaggDDlow.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

foreach x in 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if state==02 | state==08 | state==18 | state==21 ///
| state==24 | state==32
	label var treat_`x' "19`x'"
}
replace treat_86=0

areg eng treat_* i.state i.cohort cohort i.edu female student work indigenous ///
inc_hh edu_hh [aw=weight] if cohort>=1983 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(11.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) ///
text(0.6 3.8 "NL", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.6 8.8 "DGO", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.61 10.8 "SIN", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.58 10.8 "SON", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_StaggDDlow.png", replace

areg hrs_exp treat_* i.state i.cohort cohort i.edu female student work indigenous ///
[aw=weight] if cohort>=1983 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(11.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) ///
text(0.6 3.8 "NL", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.6 8.8 "DGO", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.61 10.8 "SIN", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.58 10.8 "SON", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_StaggDDlow1.png", replace

areg work treat_* i.state i.cohort cohort i.edu female indigenous inc_hh ///
edu_hh [aw=weight] if cohort>=1983 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(11.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) ///
text(0.6 3.8 "NL", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.6 8.8 "DGO", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.61 10.8 "SIN", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.58 10.8 "SON", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_StaggDDlow2.png", replace

areg lwage treat_* i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if cohort>=1983 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(11.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-5(2.5)5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-5 5)) ///
text(5.8 3.8 "NL", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(5.8 8.8 "DGO", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(5.95 10.8 "SIN", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(5.65 10.8 "SON", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_StaggDDlow3.png", replace
*========================================================================*
/* Staggered DiD: More exposure (Aguascalientes, Coahuila, Morelos and 
Tamaulipas) */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="17" | state=="28" ///
| state=="02" | state=="08" | state=="21" | state=="32"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="17" & (cohort>=1982 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
destring state, replace
keep if cohort>=1975 & cohort<=1996

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_StaggDDmore.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

foreach x in 75 76 77 78 79 80 81 82 83 84 85 86 87 ///
88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if state==02 | state==08 | state==18 | state==21 ///
| state==24 | state==32
	label var treat_`x' "19`x'"
}
replace treat_80=0

areg eng treat_* i.state i.cohort cohort i.edu female student work indigenous ///
inc_hh edu_hh [aw=weight] if cohort>=1975 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(13.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(15.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 5.2 "MOR", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.6 12.2 "COAH", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.59 14.2 "AGS", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.61 14.2 "TAM", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_StaggDDmore.png", replace

areg hrs_exp treat_* i.state i.cohort cohort i.edu female student work indigenous ///
[aw=weight] if cohort>=1975 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(13.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(15.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-0.5(0.5)1.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 1.5)) text(1.7 5.2 "MOR", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(1.7 12.2 "COAH", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(1.68 14.2 "AGS", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(1.72 14.2 "TAM", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) 
graph export "$doc\PTA_StaggDDmore1.png", replace

areg work treat_* i.state i.cohort cohort i.edu female indigenous inc_hh ///
edu_hh [aw=weight] if cohort>=1975 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(13.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(15.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 5.2 "MOR", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.6 12.2 "COAH", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.59 14.2 "AGS", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.61 14.2 "TAM", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) 
graph export "$doc\PTA_StaggDDmore2.png", replace

areg lwage treat_* i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if cohort>=1975 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(13.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(15.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-3(1)3, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-3 3)) text(3.4 5.2 "MOR", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(3.4 12.2 "COAH", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(3.34 14.2 "AGS", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(3.46 14.2 "TAM", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_StaggDDmore3.png", replace
*========================================================================*
/* Staggered DiD: Significant exposure (Aguascalientes, Coahuila and 
Tamaulipas */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="28" ///
| state=="02" | state=="08" | state=="32"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
destring state, replace
keep if cohort>=1983 & cohort<=1996

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_StaggDDs.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

foreach x in 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if state==02 | state==08 | state==18 | state==21 ///
| state==24 | state==32
	label var treat_`x' "19`x'"
}
replace treat_87=0

areg eng treat_* i.state i.cohort cohort i.edu female student work indigenous ///
inc_hh edu_hh [aw=weight] if cohort>=1983 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) ///
text(0.6 4.7 "COAH", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.61 6.7 "AGS", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.58 6.7 "TAM", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_StaggDDs.png", replace

areg hrs_exp treat_* i.state i.cohort cohort i.edu female student work indigenous ///
[aw=weight] if cohort>=1983 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-0.5(0.5)1.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 1.5)) ///
text(1.7 4.7 "COAH", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(1.72 6.7 "AGS", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(1.66 6.7 "TAM", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_StaggDDs1.png", replace

areg work treat_* i.state i.cohort cohort i.edu female indigenous inc_hh ///
edu_hh [aw=weight] if cohort>=1983 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) ///
text(0.6 4.7 "COAH", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.61 6.7 "AGS", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(0.58 6.7 "TAM", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_StaggDDs2.png", replace

areg lwage treat_* i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if cohort>=1983 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-3(1)3, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-3 3)) ///
text(3.4 4.7 "COAH", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(3.48 6.7 "AGS", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(3.32 6.7 "TAM", linegap(.2cm) ///
size(vsmall) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_StaggDDs3.png", replace
*========================================================================*
/* TABLE X: Heterogenous effects */
*========================================================================*
/* Staggered DiD: By gender */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" | state=="17" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="08" | state=="18" | state=="21" ///
| state=="24" | state=="32"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="17" & (cohort>=1982 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
destring state, replace
keep if cohort>=1975 & cohort<=1996

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDmen.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDwomen.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen fem_pol=female*had_policy
eststo clear
eststo: areg hrs_exp fem_pol had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng fem_pol had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work fem_pol had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage fem_pol had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDgender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(fem_pol) replace
*========================================================================*
/* Staggered DiD: By ethnicity */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" | state=="17" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="08" | state=="18" | state=="21" ///
| state=="24" | state=="32"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="17" & (cohort>=1982 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
destring state, replace
keep if cohort>=1975 & cohort<=1996

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if indigenous==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if indigenous==1, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if indigenous==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if indigenous==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDind.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if indigenous==0, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if indigenous==0, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if indigenous==0, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if indigenous==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDnind.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen ind_pol=indigenous*had_policy
eststo clear
eststo: areg hrs_exp ind_pol had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng ind_pol had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work ind_pol had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage ind_pol had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDethnic.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Ethnicity differences) keep(ind_pol) replace
*========================================================================*
/* Staggered DiD: By geographical context */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" | state=="17" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="08" | state=="18" | state=="21" ///
| state=="24" | state=="32"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="17" & (cohort>=1982 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
destring state, replace
keep if cohort>=1975 & cohort<=1996

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if rural==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if rural==1, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if rural==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if rural==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDrural.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if rural==0, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if rural==0, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if rural==0, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if rural==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDurban.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen rul_pol=rural*had_policy
eststo clear
eststo: areg hrs_exp rul_pol rural had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng rul_pol rural had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work rul_pol rural had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage rul_pol rural had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDgeo.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Geographical differences) keep(rul_pol) replace
*========================================================================*
/* Staggered DiD: By socioeconomic status */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" | state=="17" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="08" | state=="18" | state=="21" ///
| state=="24" | state=="32"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="17" & (cohort>=1982 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
destring state, replace
keep if cohort>=1975 & cohort<=1996
sum income if age>=18 & age<=65
scalar minc=r(mean)
gen socioe=0
replace socioe=1 if income>minc

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if socioe==0, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if socioe==0, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if socioe==0, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if socioe==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDlowi.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if socioe==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if socioe==1, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if socioe==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if socioe==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDhighi.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen se_pol=socioe*had_policy
eststo clear
eststo: areg hrs_exp se_pol socioe had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng se_pol socioe had_policy i.state i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work se_pol socioe had_policy i.state i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage se_pol socioe had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDsocioe.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(se_pol) replace
*========================================================================*
/* TABLE X: IV approach */
*========================================================================*
/* Staggered DiD: All states */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="01" | state=="05" | state=="10" | state=="17" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="08" | state=="18" | state=="21" ///
| state=="24" | state=="32"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="17" & (cohort>=1982 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
destring state, replace
destring geo, replace
keep if cohort>=1975 & cohort<=1996

eststo clear
* Structural equation
eststo: areg lwage eng i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if had_policy!=., absorb(geo) vce(cluster geo)
* First stage equation
eststo: areg eng had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if had_policy!=., absorb(geo) vce(cluster geo)
* Reduced form equation
eststo: areg lwage had_policy i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if had_policy!=., absorb(geo) vce(cluster geo)
* Second stage (IV)
eststo: quietly ivregress 2sls lwage (eng=had_policy) i.geo i.cohort i.edu female rural female_hh age_hh ///
edu_hh student indigenous married [aw=weight] if had_policy!=., vce(cluster geo)
/*ivreghdfe lwage (eng=had_policy) female rural female_hh age_hh edu_hh student ///
indigenous married [aw=weight] if had_policy!=., absorb(geo cohort edu) robust*/
esttab using "$doc\tabIV.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(eng had_policy) ///
stats(N ar2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* TABLE X: Robustness check */
*========================================================================*
/* English abilities in Aguascalientes */
*========================================================================*
use "$base\eng_abil.dta", clear
drop if state=="05" | state=="10" | state=="17" ///
| state=="19" | state=="25" | state=="26" | state=="28"
gen treat=state=="01"
gen after=cohort>=1990
replace after=. if cohort<1986 | cohort>1995
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ags.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 86 87 88 89 90 91 92 93 94 95 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_89=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
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

areg hrs_exp treat_* treat i.cohort cohort i.edu student work indigenous ///
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

areg work treat_* treat i.cohort cohort i.edu female indigenous inc_hh edu_hh ///
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

areg lwage treat_* treat i.cohort cohort i.edu female student indigenous ///
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
*========================================================================*
/* English abilities in Coahuila */
*========================================================================*
use "$base\eng_abil.dta", clear
drop if state=="01" | state=="10" | state=="17" ///
| state=="19" | state=="25" | state=="26" | state=="28"
gen treat=state=="05"
gen after=cohort>=1988
replace after=. if cohort<1979 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_coah.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_87=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
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

areg hrs_exp treat_* treat i.cohort cohort i.edu female student work indigenous ///
[aw=weight]if cohort>=1979 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-3(1)3, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-3 3)) text(3.6 7.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_COAH1.png", replace

areg work treat_* treat i.cohort cohort i.edu female indigenous inc_hh edu_hh ///
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

areg lwage treat_* treat i.cohort cohort i.edu female student indigenous ///
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
*========================================================================*
/* English abilities in Durango */
*========================================================================*
use "$base\eng_abil.dta", clear
drop if state=="01" | state=="05" | state=="17" ///
| state=="19" | state=="25" | state=="26" | state=="28"
gen treat=state=="10"
gen after=cohort>=1991
replace after=. if cohort<1985 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_dgo.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_90=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
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

areg hrs_exp treat_* treat i.cohort cohort i.edu student work indigenous ///
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

areg work treat_* treat i.cohort cohort i.edu female indigenous inc_hh edu_hh ///
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

areg lwage treat_* treat i.cohort cohort i.edu female student indigenous ///
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
*========================================================================*
/* English abilities in Morelos */
*========================================================================*
use "$base\eng_abil.dta", clear
drop if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" 
gen treat=state=="17"
gen after=cohort>=1981
replace after=. if cohort<1967 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_mor.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 ///
86 87 88 89 90 91 92 93 94 95 96{
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_81=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
inc_hh edu_hh [aw=weight] if cohort>=1967 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(15.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 11.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_MOR.png", replace

areg hrs_exp treat_* treat i.cohort cohort i.edu student work indigenous ///
[aw=weight] if cohort>=1967 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(15.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-2(1)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-2 2)) text(2.4 11.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_MOR1.png", replace

areg work treat_* treat i.cohort cohort i.edu female indigenous inc_hh edu_hh ///
[aw=weight] if cohort>=1967 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(15.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 11.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_MOR2.png", replace

areg lwage treat_* treat i.cohort cohort i.edu female student indigenous ///
[aw=weight] if cohort>=1967 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(15.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 11.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_MOR3.png", replace
*========================================================================*
/* English abilities in Nuevo Leon */
*========================================================================*
use "$base\eng_abil.dta", clear
drop if state=="01" | state=="05" | state=="10" | state=="17" ///
| state=="25" | state=="26" | state=="28" 
gen treat=state=="19"
gen after=cohort>=1987
replace after=. if cohort<1981 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_nl.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_86=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
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

areg hrs_exp treat_* treat i.cohort cohort i.edu female student work indigenous ///
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.2 "Eng program in 6th grade", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_NL1.png", replace

areg work treat_* treat i.cohort cohort i.edu female indigenous inc_hh edu_hh ///
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

areg lwage treat_* treat i.cohort cohort i.edu female student indigenous ///
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
*========================================================================*
/* English abilities in Sinaloa */
*========================================================================*
use "$base\eng_abil.dta", clear
drop if state=="01" | state=="05" | state=="10" | state=="17" ///
| state=="19" | state=="26" | state=="28" 
gen treat=state=="25"
gen after=cohort>=1993
replace after=. if cohort<1989 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_sin.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 89 90 91 92 93 94 95 96{
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_92=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
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

areg hrs_exp treat_* treat i.cohort cohort i.edu student work indigenous ///
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

areg work treat_* treat i.cohort cohort i.edu female indigenous inc_hh edu_hh ///
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

areg lwage treat_* treat i.cohort cohort i.edu female student indigenous ///
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
*========================================================================*
/* English abilities in Sonora */
*========================================================================*
use "$base\eng_abil.dta", clear
drop if state=="01" | state=="05" | state=="10" | state=="17" ///
| state=="19" | state=="25" | state=="28" 
gen treat=state=="26"
gen after=cohort>=1993
replace after=. if cohort<1989 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_son.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 89 90 91 92 93 94 95 96{
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_92=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
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

areg hrs_exp treat_* treat i.cohort cohort i.edu student work indigenous ///
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

areg work treat_* treat i.cohort cohort i.edu female indigenous inc_hh edu_hh ///
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

areg lwage treat_* treat i.cohort cohort i.edu female student indigenous ///
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
*========================================================================*
/* English abilities in Tamaulipas */
*========================================================================*
use "$base\eng_abil.dta", clear
drop if state=="01" | state=="05" | state=="10" | state=="17" ///
| state=="19" | state=="25" | state=="26" 
gen treat=state=="28"
gen after=cohort>=1990
replace after=. if cohort<1983 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
inc_hh edu_hh [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_tam.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_89=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
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

areg hrs_exp treat_* treat i.cohort cohort i.edu female student work indigenous ///
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 6 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_TAM1.png", replace

areg work treat_* treat i.cohort cohort i.edu female indigenous inc_hh edu_hh ///
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

areg lwage treat_* treat i.cohort cohort i.edu female student indigenous ///
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
