*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
/* Oscar Galvez-Soriano
In this do file I produce my tables and figures */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/data/main"
gl base= "C:\Users\galve\Documents\Papers\Current\Returns to Eng Mex\Data"
gl doc= "C:\Users\galve\Documents\Papers\Current\Returns to Eng Mex\Doc"
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
eststo: areg eng hrs_exp treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if after!=., absorb(geo) vce(cluster geo)
eststo: areg work hrs_exp treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if after!=., absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if after!=., absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ags.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg eng hrs_exp treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==0 & after!=., absorb(geo) vce(cluster geo)
eststo: areg work hrs_exp treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==0 & after!=., absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==0 & after!=., absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ags_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg eng hrs_exp treat i.cohort edu edu2 female student work ///
indigenous inc_hh edu_hh [aw=weight] if female==1 & after!=., absorb(geo) vce(cluster geo)
eststo: areg work hrs_exp treat i.cohort edu female indigenous ///
inc_hh edu_hh [aw=weight] if female==1 & after!=., absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp treat i.cohort edu edu2 female student ///
indigenous [aw=weight] if female==1 & after!=., absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ags_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

foreach x in 87 88 89 90 91 92 93 94 95 96{
    gen treat_`x'=0
	replace treat_`x'=hrs_exp if cohort==19`x'
	label var treat_`x' "19`x'"
}
replace treat_89=0

areg eng treat_* treat i.cohort cohort edu edu2 female student work indigenous ///
inc_hh edu_hh [aw=weight] if cohort>=1986 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(3.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 2.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGS.png", replace

areg work treat_* treat i.cohort cohort edu female indigenous inc_hh edu_hh ///
[aw=weight]if cohort>=1986 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(3.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 2.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGS2.png", replace

areg lwage treat_* treat i.cohort cohort edu edu2 female student indigenous ///
[aw=weight]if cohort>=1986 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(3.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-4(1)4, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-4 4)) text(4.8 2.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGS3.png", replace
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
