*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
/* Oscar Galvez-Soriano
In this do file I produce my tables and figures */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/data/main"
gl base= "C:\Users\ogalvez\Documents\EngAbil\Data"
gl doc= "C:\Users\ogalvez\Documents\EngAbil\Doc"
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
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ags.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ags_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ags_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

foreach x in 86 87 88 89 90 91 92 93 94 95 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_89=0

areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight]if cohort>=1986 & cohort<=1995, absorb(geo) vce(cluster geo)
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

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1986 & cohort<=1995, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 3.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGS2.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1986 & cohort<=1995, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-4(1)4, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) text(4.8 3.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGS3.png", replace

*========================================================================*
/* Low education */

eststo clear
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
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ags_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

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
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_nl.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_nl_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_nl_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

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

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 3.2 "Eng program in 6th grade", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_NL2.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-4(1)4, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) text(4.8 3.2 "Eng program in 6th grade", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_NL3.png", replace
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
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_tam.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_tam_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_tam_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

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

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 6 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_TAM2.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-4(1)4, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) text(4.8 6 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_TAM3.png", replace
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

areg eng treat_* i.state i.cohort edu edu2 female student work indigenous ///
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
*========================================================================*
/* Descriptive statistics */
*========================================================================*
use "$base\eng_abil.dta", clear
eststo clear
eststo full_sample: quietly estpost sum eng edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size [aw=weight] ///
if age>=18 & age<=65 
eststo eng: quietly estpost sum eng edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size [aw=weight] ///
if eng==1 & age>=18 & age<=65
eststo no_eng: quietly estpost sum eng edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size [aw=weight] ///
if eng==0 & age>=18 & age<=65
eststo diff: quietly estpost ttest eng edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size if age>=18 ///
& age<=65, by(eng) unequal
esttab full_sample eng no_eng diff using "$doc\sum_stats.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
foreach x in edu expe age female married income student work rural ///
female_hh age_hh edu_hh hh_size{
eststo: quietly reg `x' eng [aw=weight] if age>=18 & age<=65, vce(robust)
}
esttab using "$doc\sum_stats_diff.tex", ar2 cells(b(star fmt(%9.2fc)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Descriptive statistics) keep(eng) replace
*========================================================================*
/* Statistics by occupations */
use "$base\eng_abil.dta", clear
gen occup=.
replace occup=1 if (sinco>6101 & sinco<=6131) | (sinco>6201 & sinco<=6231) ///
| sinco==6999
replace occup=2 if (sinco>=9111 & sinco<=9899) 
replace occup=3 if (sinco>=7111 & sinco<=7135) | (sinco>=7211 & sinco<=7223) ///
| (sinco>=7311 & sinco<=7353) | (sinco>=7411 & sinco<=7412) | (sinco>=7511 & ///
sinco<=7517) | (sinco>=7611 & sinco<=7999)
replace occup=4 if (sinco>=5111 & sinco<=5116) | (sinco>=5211 & sinco<=5254) ///
| (sinco>=5311 & sinco<=5314) | (sinco>=5411 & sinco<=5999)
replace occup=5 if sinco==4111 | (sinco>=4211 & sinco<=4999)
replace occup=6 if sinco==6311 | (sinco>=8111 & sinco<=8199) | (sinco>=8211 ///
& sinco<=8212) | (sinco>=8311 & sinco<=8999)
replace occup=7 if (sinco>=3111 & sinco<=3142) | (sinco>=3211 & sinco<=3999)
replace occup=8 if (sinco>=1111 & sinco<=1999) | sinco==2630 ///
| sinco==2630 | sinco==2640 | sinco==3101 | sinco==3201 | sinco==4201 ///
| sinco==5101 | sinco==5201 | sinco==5301 | sinco==5401 | sinco==6101 ///
| sinco==6201 | sinco==7101 | sinco==7201 | sinco==7301 | sinco==7401 ///
| sinco==7501 | sinco==7601 | sinco==8101 | sinco==8201 | sinco==8301
replace occup=9 if sinco==980
replace occup=10 if (sinco>=2111 & sinco<=2625) | (sinco>=2631 & sinco<=2639) ///
| (sinco>=2641 & sinco<=2992)

label define occup 1 "Farming" 2 "Elementary occupations" 3 "Crafts" ///
4 "Services" 5 "Commerce" 6 "Machine operators" 7 "Clerical support" ///
8 "Managerial" 9 "Abroad" 10 "Professionals/Technicians"
label values occup occup

eststo clear
eststo english: quietly estpost tabstat eng [fw=weight] if age>=18 & age<=65, by(occup) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if age>=18 & age<=65, by(occup) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if age>=18 & age<=65, by(occup) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if age>=18 & age<=65, by(occup) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_occup_eng.tex", ///
cells("mean(fmt(%9.2fc))") nonumber noobs label replace
tab occup [fw=weight] if eng!=. & age>=18 & age<=65

/* Low education */
eststo clear
eststo english: quietly estpost tabstat eng [fw=weight] if age>=18 & age<=65 & edu<=9, by(occup) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if age>=18 & age<=65 & edu<=9, by(occup) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if age>=18 & age<=65 & edu<=9, by(occup) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if age>=18 & age<=65 & edu<=9, by(occup) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_occup_eng_ledu.tex", ///
cells("mean(fmt(%9.2fc))") nonumber noobs label replace
tab occup [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=9

/* Detailed analysis of occupations 
keep if edu<=9
tostring sinco, replace format(%04.0f)
gen sinco_sub=substr(sinco,1,3)
destring sinco_sub sinco, replace
collapse (mean) eng [fw=weight], by(sinco_sub)
merge 1:1 sinco_sub using "$data/biare/sinco_code.dta"
drop if _merge!=3
drop _merge
label var sinco_d "Occupation"
keep if eng>0.5 & eng!=.
drop sinco_sub
sort eng
cd "C:\Users\galve\Documents\Papers\Ideas\Education\Returns to Eng Mex\Doc"
dataout, save(Occupation) tex replace dec(2) */
*========================================================================*
/* Statistics by economic activities */
use "$base\eng_abil.dta", clear
gen econ_act=.
replace econ_act=1 if (scian>=1110 & scian<=1199)
replace econ_act=2 if (scian>1199 & scian<=2399)
replace econ_act=3 if (scian>=8111 & scian<=8140)
replace econ_act=4 if (scian>3399 & scian<=4699)
replace econ_act=5 if (scian>=7111 & scian<=7223)
replace econ_act=6 if (scian>2399 & scian<=3399)
replace econ_act=7 if (scian>4699 & scian<=4930)
replace econ_act=8 if (scian>=5611 & scian<=5622)
replace econ_act=9 if (scian>=9311 & scian<=9399)
replace econ_act=10 if (scian>=5411 & scian<=5414) | (scian>=6111 & scian<=6299) ///
| scian==5510 // Includes Professional, Technical and Management
replace econ_act=11 if scian==980
replace econ_act=12 if (scian>=5110 & scian<=5399) //Includes telecommunications, finance and real state

label define econ_act 1 "Agriculture" 2 "Construction" 3 "Other Services" ///
4 "Commerce" 5 "Hospitality and Entertainment" 6 "Manufactures" ///
7 "Transportation" 8 "Administrative" 9 "Government" ///
10 "Professional/Technical" 11 "Abroad" 12"Telecom/Finance"
label values econ_act econ_act

eststo clear
eststo english: quietly estpost tabstat eng [fw=weight] if age>=18 & age<=65, by(econ_act) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if age>=18 & age<=65, by(econ_act) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if age>=18 & age<=65, by(econ_act) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if age>=18 & age<=65, by(econ_act) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_econa_eng.tex", ///
cells("mean(fmt(%9.2fc))") nonumber noobs label replace
tab econ_act [fw=weight] if age>=18 & age<=65

/* Low education */
eststo clear
eststo english: quietly estpost tabstat eng [fw=weight] if age>=18 & age<=65 & edu<=9, by(econ_act) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if age>=18 & age<=65 & edu<=9, by(econ_act) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if age>=18 & age<=65 & edu<=9, by(econ_act) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if age>=18 & age<=65 & edu<=9, by(econ_act) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_econa_eng_edu.tex", ///
cells("mean(fmt(%9.2fc))") nonumber noobs label replace
tab econ_act [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=9

/* Detailed analysis of economic industries
keep if edu<=9
tostring scian, replace format(%04.0f)
gen naics_sub=substr(scian,1,3)
destring naics_sub scian, replace
replace naics_sub=221 if naics_sub==222
collapse (mean) eng [fw=weight], by(naics_sub)
merge 1:1 naics_sub using "$data/biare/naics_code.dta"
drop if _merge!=3
drop _merge
label var naics_d "Econ Industry"
keep if eng>0.5 & eng!=.
drop naics_sub
sort eng
cd "C:\Users\galve\Documents\Papers\Ideas\Education\Returns to Eng Mex\Doc"
dataout, save(NAICS) tex replace dec(2) */
/*
use "$base\eng_abil.dta", clear
rename scian naics
replace naics=2211 if naics==2210
replace naics=2212 if naics==2221
replace naics=2213 if naics==2222
gen p_eng=eng
replace p_eng=0 if eng==.
collapse (mean) p_eng [fw=weight], by(naics)
save "C:\Users\ogalvez\Documents\EngInstruction\Data\eng_naics.dta", replace
use "$base\eng_abil.dta", clear
rename scian naics
replace naics=2211 if naics==2210
replace naics=2212 if naics==2221
replace naics=2213 if naics==2222
keep if edu<=9
gen p_eng_edu=eng
replace p_eng_edu=0 if eng==.
collapse (mean) p_eng_edu [fw=weight], by(naics)
merge 1:1 naics using "C:\Users\ogalvez\Documents\EngInstruction\Data\eng_naics.dta"
replace p_eng_edu=0 if p_eng_edu==.
drop _merge
xtile eng_dist= p_eng, nq(4)
xtile eng_dist_edu= p_eng_edu, nq(4)
save "C:\Users\ogalvez\Documents\EngInstruction\Data\eng_naics.dta", replace */
*========================================================================*
/* Returns to English skills */
*========================================================================*
use "$base\eng_abil.dta", clear
*replace eng=0 if eng==.
replace income=income+1
gen lincome=log(income)
/* Full sample */
eststo clear
eststo: reg lincome eng [aw=weight] if age>=18 & age<=65, vce(cluster geo)
eststo: reg lincome eng edu expe expe2 [aw=weight] if age>=18 ///
& age<=65, vce(cluster geo)
eststo: reg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, absorb(state) vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng.tex", ar2 cells(b(star fmt(%9.3fc)) ///
se(par)) star(* 0.10 ** 0.05 *** 0.01) title(Returns to Eng) keep(eng) replace

/* Men */
eststo clear
eststo: reg lincome eng [aw=weight] if age>=18 & age<=65  & female==0, ///
vce(cluster geo)
eststo: reg lincome eng edu expe expe2 [aw=weight] if (age>=18 ///
& age<=65) & female==0, vce(cluster geo)
eststo: reg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==0, vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==0, absorb(state) vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng_men.tex", ar2 cells(b(star fmt(%9.3fc)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to Eng (Men)) keep(eng) replace

/* Women */
eststo clear
eststo: reg lincome eng [aw=weight] if age>=18 & age<=65  & female==1, ///
vce(cluster geo)
eststo: reg lincome eng edu expe expe2 [aw=weight] if (age>=18 ///
& age<=65) & female==1, vce(cluster geo)
eststo: reg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==1, vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==1, absorb(state) vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng_women.tex", ar2 cells(b(star fmt(%9.3fc)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to Eng (Women)) keep(eng) replace

/* Gender */
gen eng_female=eng*female
eststo clear
eststo: reg lincome eng_female eng female [aw=weight] if age>=18 & age<=65, vce(cluster geo)
eststo: reg lincome eng_female eng edu expe expe2 female [aw=weight] if age>=18 ///
& age<=65, vce(cluster geo)
eststo: reg lincome eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, vce(cluster geo)
eststo: areg lincome eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, absorb(state) vce(cluster geo)
eststo: areg lincome eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng_gender.tex", ar2 cells(b(star fmt(%9.3fc)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to Eng) keep(eng_female) replace

/* Education */
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
replace engedu1=0
label var engedu0 "No-edu"
label var engedu1 "Elem-drop"
label var engedu2 "Elem S"
label var engedu3 "Middle-drop"
label var engedu4 "Middle S"
label var engedu5 "High S"
label var engedu6 "College"
label var engedu7 "Graduate"
areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh married ///
engedu* [aw=weight] if age>=18 & age<=65, absorb(geo) vce(cluster geo)

*graph set window fontface "Times New Roman"
coefplot, vertical keep(engedu*) yline(0) omitted baselevels ///
ytitle("Returns to English abilities by education levels", size(small) height(5)) ///
ylabel(-4(2)4, labs(small) grid) ///
xtitle("Levels of education", size(small) height(5)) xlabel(,labs(small)) ///
graphregion(color(white)) scheme(s2mono) recast(connected) ciopts(recast(rcap)) ///
ysc(r(-0.5 1)) 
graph export "$doc\eng_abil_edu.png", replace 
/* Same as above but with missings */
replace eng=0 if eng==.
coefplot, vertical keep(engedu*) yline(0) omitted baselevels ///
ytitle("Returns to English abilities by education levels", size(small) height(5)) ///
ylabel(-4(2)4, labs(small) grid) ///
xtitle("Levels of education", size(small) height(5)) xlabel(,labs(small)) ///
graphregion(color(white)) scheme(s2mono) recast(connected) ciopts(recast(rcap)) ///
ysc(r(-0.5 1)) 
graph export "$doc\eng_abil_edu_miss.png", replace 
*========================================================================*
/* Maps */
*========================================================================*
use "$base\eng_abil.dta", clear

destring state, replace
gen eng_r=eng if rural==1
gen eng_u=eng if rural==0
gen engm=eng
replace engm=0 if eng==.
gen engm_r=engm if rural==1
gen engm_u=engm if rural==0
gen nans=eng==.
gen nans_r=nans if rural==1
gen nans_u=nans if rural==0
keep if age>=18 & age<=65
collapse (mean) eng* nans* [fw=weight], by(state)

merge m:m state using "$data/Maps/MexStates/mex_map_state.dta"
drop if _merge!=3
drop _merge

format eng* nans* %12.2f
/* English ability self reported */
spmap eng using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 1)
graph export "$doc\map_eng.png", replace

spmap eng_r using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 1)
graph export "$doc\map_eng_r.png", replace

spmap eng_u using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 1)
graph export "$doc\map_eng_u.png", replace
