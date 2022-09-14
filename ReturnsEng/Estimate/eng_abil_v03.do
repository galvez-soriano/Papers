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
/* TABLE 6: Returns to English skills */
*========================================================================*
use "$base\eng_abil.dta", clear
/* Full sample */
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
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if age>=18 ///
& age<=65 & paidw==1 & edu<=9, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous i.edu [aw=weight] if ///
age>=18 & age<=65 & paidw==1 & edu<=9, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
/* Men */
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
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if age>=18 ///
& age<=65 & paidw==1 & edu<=9 & female==0, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous i.edu [aw=weight] if ///
age>=18 & age<=65 & paidw==1 & edu<=9 & female==0, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9 & female==0, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9 & female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
/* Women */
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
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if age>=18 ///
& age<=65 & paidw==1 & edu<=9 & female==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous i.edu [aw=weight] if ///
age>=18 & age<=65 & paidw==1 & edu<=9 & female==1, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9 & female==1, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9 & female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
/* Gender */
gen eng_female=eng*female
eststo clear
eststo: reg lwage eng_female eng female [aw=weight] if age>=18 & age<=65 & paidw==1, vce(cluster geo)
eststo: reg lwage eng_female eng i.cohort female indigenous [aw=weight] if age>=18 ///
& age<=65 & paidw==1, vce(cluster geo)
eststo: reg lwage eng_female eng i.cohort female indigenous i.edu [aw=weight] if ///
age>=18 & age<=65 & paidw==1, vce(cluster geo)
eststo: areg lwage eng_female eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1, absorb(state) vce(cluster geo)
eststo: areg lwage eng_female eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng_female eng female [aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9, vce(cluster geo)
eststo: reg lwage eng_female eng i.cohort female indigenous [aw=weight] if age>=18 ///
& age<=65 & paidw==1 & edu<=9, vce(cluster geo)
eststo: reg lwage eng_female eng i.cohort female indigenous i.edu [aw=weight] if ///
age>=18 & age<=65 & paidw==1 & edu<=9, vce(cluster geo)
eststo: areg lwage eng_female eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9, absorb(state) vce(cluster geo)
eststo: areg lwage eng_female eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
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

*graph set window fontface "Times New Roman"
coefplot, vertical keep(engedu*) yline(0) omitted baselevels ///
ytitle("Returns to English abilities by education levels", size(small) height(5)) ///
ylabel(-4(2)4, labs(small) grid) ///
xtitle("Levels of education", size(small) height(5)) xlabel(,labs(small)) ///
graphregion(color(white)) scheme(s2mono) recast(connected) ciopts(recast(rcap)) ///
ysc(r(-0.5 1)) 
graph export "$doc\eng_abil_edu.png", replace 
*========================================================================*
/* TABLE X: Returns to English skills (IV strategy) */
*========================================================================*
/*use "$base\eng_abil.dta", clear
destring geo, replace

eststo clear
/* Structural equation */
eststo: areg lwage eng i.cohort i.edu female rural indigenous married ///
[aw=weight] if age>=18 & age<=23 & paidw==1, absorb(geo) vce(cluster geo)
/* First stage */
eststo: areg eng hrs_exp i.cohort i.edu female rural indigenous married ///
[aw=weight] if age>=18 & age<=23 & paidw==1, absorb(geo) vce(cluster geo)
/* Reduced form */
eststo: areg lwage hrs_exp i.cohort i.edu female rural indigenous married ///
[aw=weight] if age>=18 & age<=23 & paidw==1, absorb(geo) vce(cluster geo)
/* IV estimation */
eststo: ivregress 2sls lwage (eng=hrs_exp) i.geo i.cohort i.edu female rural ///
indigenous married [aw=weight] if age>=18 & age<=23 & paidw==1, vce(cluster geo)
esttab using "$doc\tabIV.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(eng hrs_exp) ///
stats(N ar2 F, fmt(%9.0fc %9.3f)) replace */
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
eststo: areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
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

areg eng treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1986 & cohort<=1995 & paidw==1 , absorb(geo) vce(cluster geo)
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

areg hrs_exp treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1986 & cohort<=1995 & paidw==1, absorb(geo) vce(cluster geo)
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

areg paidw treat_* treat i.cohort cohort i.edu female indigenous married ///
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

areg lwage treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1986 & cohort<=1995 & paidw==1, absorb(geo) vce(cluster geo)
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
eststo: areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
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

areg eng treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1979 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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

areg hrs_exp treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1979 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-2(1)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-2 2)) text(2.4 7.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_COAH1.png", replace

areg paidw treat_* treat i.cohort cohort i.edu female indigenous married ///
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

areg lwage treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1979 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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
eststo: areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
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

areg eng treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1985 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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

areg hrs_exp treat_* treat i.cohort cohort i.edu indigenous married ///
[aw=weight] if cohort>=1985 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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

areg paidw treat_* treat i.cohort cohort i.edu female indigenous married ///
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

areg lwage treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1985 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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
/* English abilities in Nuevo Leon */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="19" | state=="24"
gen treat=state=="19"
gen after=cohort>=1987
replace after=. if cohort<1981 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
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

areg eng treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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

areg hrs_exp treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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

areg paidw treat_* treat i.cohort cohort i.edu female indigenous married ///
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

areg lwage treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight]if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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
eststo: areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
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

areg eng treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1989 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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

areg hrs_exp treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1989 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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

areg paidw treat_* treat i.cohort cohort i.edu female indigenous married ///
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

areg lwage treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1966 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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
keep if state=="26" | state=="02" | state=="08"
gen treat=state=="26"
gen after=cohort>=1993
replace after=. if cohort<1991 | cohort>1996 
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_son.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 91 92 93 94 95 96{
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_92=0

areg eng treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1989 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 1.8 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SON.png", replace

areg hrs_exp treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1989 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-1(1)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 1.8 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SON1.png", replace

areg paidw treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1989 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 1.8 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SON2.png", replace

areg lwage treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1989 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 1.8 "Eng program", linegap(.2cm) ///
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
eststo: areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
/* Low education */
eststo: areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
eststo: areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
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

areg eng treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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

areg hrs_exp treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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

areg paidw treat_* treat i.cohort cohort i.edu female indigenous married ///
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

areg lwage treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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
replace paidw=0 if paidw==.

eststo clear
eststo: areg hrs_exp had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
/*eststo: areg lfp had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)*/
eststo: areg paidw had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)
eststo: areg student had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_StaggDD.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

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

areg eng treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.14(0.07)0.14, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.14 0.14)) recast(connected)
graph export "$doc\PTA_StaggDD.png", replace

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

areg paidw treat* i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1980 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(9, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) recast(connected)
graph export "$doc\PTA_StaggDD2.png", replace

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

areg student treat* i.cohort i.edu female indigenous married ///
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
*========================================================================*
/* TABLE X: IV approach */
*========================================================================*
/* Staggered DiD: All states */
*========================================================================*
use "$base\eng_abil.dta", clear
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
*ivregress 2sls eng (hrs_exp=had_policy) i.geo i.cohort i.edu female rural ///
*student indigenous married [aw=weight] if had_policy!=., vce(cluster geo)
/*ivreghdfe lwage (eng=had_policy) female rural student ///
indigenous married [aw=weight] if had_policy!=., absorb(geo cohort edu) robust*/
esttab using "$doc\tabIV.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(eng had_policy) ///
stats(N ar2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* TABLE X: Occupations */
*========================================================================*
use "$base\eng_abil.dta", clear
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
eststo: areg farm had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg elem had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg mach had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg craf had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg cust had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg sale had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg cler had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg prof had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg mana had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg abro had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tabSDDoccup.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg farm had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & work==1, absorb(geo) vce(cluster geo)
eststo: areg elem had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & work==1, absorb(geo) vce(cluster geo)
eststo: areg mach had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & work==1, absorb(geo) vce(cluster geo)
eststo: areg craf had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & work==1, absorb(geo) vce(cluster geo)
eststo: areg cust had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & work==1, absorb(geo) vce(cluster geo)
eststo: areg sale had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & work==1, absorb(geo) vce(cluster geo)
eststo: areg cler had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & work==1, absorb(geo) vce(cluster geo)
eststo: areg prof had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & work==1, absorb(geo) vce(cluster geo)
eststo: areg mana had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & work==1, absorb(geo) vce(cluster geo)
eststo: areg abro had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & work==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tabSDDoccupMen.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg farm had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & work==1, absorb(geo) vce(cluster geo)
eststo: areg elem had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & work==1, absorb(geo) vce(cluster geo)
eststo: areg mach had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & work==1, absorb(geo) vce(cluster geo)
eststo: areg craf had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & work==1, absorb(geo) vce(cluster geo)
eststo: areg cust had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & work==1, absorb(geo) vce(cluster geo)
eststo: areg sale had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & work==1, absorb(geo) vce(cluster geo)
eststo: areg cler had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & work==1, absorb(geo) vce(cluster geo)
eststo: areg prof had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & work==1, absorb(geo) vce(cluster geo)
eststo: areg mana had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & work==1, absorb(geo) vce(cluster geo)
eststo: areg abro had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & work==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tabSDDoccupWomen.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen fem_pol=female*had_policy

eststo clear
eststo: areg farm fem_pol had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg elem fem_pol had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg mach fem_pol had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg craf fem_pol had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg cust fem_pol had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg sale fem_pol had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg cler fem_pol had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg prof fem_pol had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg mana fem_pol had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg abro fem_pol had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tabSDDoccupGender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(fem_pol) replace
*========================================================================*
/* TABLE X: Robustness check */
*========================================================================*
/* English abilities in Aguascalientes */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="01" | state=="06" | state=="11" | state=="18" | state=="24" ///
| state=="32"
gen treat=state=="01"
gen after=cohort>=1990
replace after=. if cohort<1986 | cohort>1995
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
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
[aw=weight] if cohort>=1986 & cohort<=1995, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 3.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
*text(0.2 9.3 "0.020*", linegap(.2cm) ///
*size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGSr.png", replace

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
*text(1.1 9.2 "0.431***", linegap(.2cm) ///
*size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGSr1.png", replace

areg work treat_* treat i.cohort cohort i.edu female indigenous ///
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
graph export "$doc\PTA_AGSr2.png", replace

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
graph export "$doc\PTA_AGSr3.png", replace
*========================================================================*
/* English abilities in Coahuila */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="05" | state=="08" | state=="24" | state=="32"
gen treat=state=="05"
gen after=cohort>=1988
replace after=. if cohort<1979 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
[aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
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
[aw=weight]if cohort>=1979 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 7.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_COAHr.png", replace

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
graph export "$doc\PTA_COAHr1.png", replace

areg work treat_* treat i.cohort cohort i.edu female indigenous ///
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
graph export "$doc\PTA_COAHr2.png", replace

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
graph export "$doc\PTA_COAHr3.png", replace
*========================================================================*
/* English abilities in Durango */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="10" | state=="08" | state=="24" | state=="32" | state=="14" 
gen treat=state=="10"
gen after=cohort>=1991
replace after=. if cohort<1985 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
[aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
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
[aw=weight] if cohort>=1985 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 5.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_DGOr.png", replace

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
graph export "$doc\PTA_DGOr1.png", replace

areg work treat_* treat i.cohort cohort i.edu female indigenous ///
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
graph export "$doc\PTA_DGOr2.png", replace

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
graph export "$doc\PTA_DGOr3.png", replace
*========================================================================*
/* English abilities in Nuevo Leon */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="19" | state=="08" | state=="24" | state=="32"  
gen treat=state=="19"
gen after=cohort>=1987
replace after=. if cohort<1981 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
[aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
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
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 3.2 "Eng program in 6th grade", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_NLr.png", replace

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
graph export "$doc\PTA_NLr1.png", replace

areg work treat_* treat i.cohort cohort i.edu female indigenous ///
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
graph export "$doc\PTA_NLr2.png", replace

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
graph export "$doc\PTA_NLr3.png", replace
*========================================================================*
/* English abilities in Sinaloa */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="25" | state=="08" | state=="32" | state=="18" | state=="02" ///
| state=="03"
gen treat=state=="25"
gen after=cohort>=1993
replace after=. if cohort<1989 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
[aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
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
[aw=weight] if cohort>=1989 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 3.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SINr.png", replace

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
graph export "$doc\PTA_SINr1.png", replace

areg work treat_* treat i.cohort cohort i.edu female indigenous ///
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
graph export "$doc\PTA_SINr2.png", replace

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
graph export "$doc\PTA_SINr3.png", replace
*========================================================================*
/* English abilities in Sonora */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="26" | state=="08" | state=="02" | state=="03" | state=="14" ///
| state=="32" 
gen treat=state=="26"
gen after=cohort>=1993
replace after=. if cohort<1991 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
[aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_son.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(after_treat) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* PTA */
foreach x in 91 92 93 94 95 96{
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_92=0

areg eng treat_* treat i.cohort cohort i.edu female student work indigenous ///
[aw=weight] if cohort>=1989 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 1.8 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SONr.png", replace

areg hrs_exp treat_* treat i.cohort cohort i.edu student work indigenous ///
[aw=weight] if cohort>=1989 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-1(1)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 1.8 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SONr1.png", replace

areg work treat_* treat i.cohort cohort i.edu female indigenous ///
[aw=weight] if cohort>=1989 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 1.8 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SONr2.png", replace

areg lwage treat_* treat i.cohort cohort i.edu female student indigenous ///
[aw=weight] if cohort>=1989 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 1.8 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SONr3.png", replace
*========================================================================*
/* English abilities in Tamaulipas */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="28" | state=="08" | state=="32" | state=="18" | state=="02" ///
| state=="03"
gen treat=state=="28"
gen after=cohort>=1990
replace after=. if cohort<1983 | cohort>1996
gen after_treat=after*treat

eststo clear
eststo: areg hrs_exp after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng after_treat treat i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work after_treat treat i.cohort i.edu female indigenous ///
[aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage after_treat treat i.cohort i.edu female student ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
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
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 6 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_TAMr.png", replace

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
graph export "$doc\PTA_TAMr1.png", replace

areg work treat_* treat i.cohort cohort i.edu female indigenous ///
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
graph export "$doc\PTA_TAMr2.png", replace

areg lwage treat_* treat i.cohort cohort i.edu female student indigenous ///
[aw=weight] if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(12 6 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_TAMr3.png", replace
*========================================================================*
/* Staggered DiD: All states */
*========================================================================*
use "$base\eng_abil.dta", clear
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
keep if cohort>=1985 & cohort<=1996

eststo clear
eststo: areg hrs_exp had_policy i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.cohort i.edu female indigenous ///
[aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural student ///
indigenous married [aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_StaggDDa.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen treat5=cohort==1986 & state=="10"
gen treat6=cohort==1986 & state=="01"
gen treat7=cohort==1987 & state=="01"
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

replace treat8=1 if cohort==1988 & state=="01"
replace treat9=1 if cohort==1989 & state=="01"
replace treat10=1 if cohort==1990 & state=="01"
replace treat11=1 if cohort==1991 & state=="01"
replace treat12=1 if cohort==1992 & state=="01"
replace treat13=1 if cohort==1993 & state=="01"
replace treat14=1 if cohort==1994 & state=="01"
replace treat15=1 if cohort==1995 & state=="01"
replace treat16=1 if cohort==1996 & state=="01"

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

label var treat5 "-5"
label var treat6 "-4"
label var treat7 "-3"
label var treat8 "-2"
label var treat9 "-1"
foreach x in 0 1 2 3 4 5 6 7 8 9 {
	label var treat1`x' "`x'"
}

areg eng treat* i.cohort cohort i.edu female student work indigenous ///
[aw=weight] if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(6, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.3 0.3)) recast(connected)
graph export "$doc\PTA_StaggDDa.png", replace

areg hrs_exp treat* i.cohort cohort i.edu female student work indigenous ///
[aw=weight] if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(6, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.75, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.75)) recast(connected)
graph export "$doc\PTA_StaggDDa1.png", replace

areg work treat* i.cohort cohort i.edu female indigenous ///
[aw=weight] if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(6, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of participating in labor market", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) recast(connected)
graph export "$doc\PTA_StaggDDa2.png", replace

areg lwage treat* i.cohort i.edu female rural student ///
indigenous married [aw=weight] if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(6, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-2(1)2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-2 2)) recast(connected)
graph export "$doc\PTA_StaggDDa3.png", replace
*========================================================================*
/* TABLE X: IV approach */
*========================================================================*
/* Staggered DiD: All states */
*========================================================================*
use "$base\eng_abil.dta", clear
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
keep if cohort>=1985 & cohort<=1996

eststo clear
* Structural equation
eststo: areg lwage eng i.cohort i.edu female rural student indigenous ///
married [aw=weight] if had_policy!=., absorb(geo) vce(cluster geo)
* First stage equation
eststo: areg eng had_policy i.cohort i.edu female rural student indigenous ///
married [aw=weight] if had_policy!=., absorb(geo) vce(cluster geo)
* Reduced form equation
eststo: areg lwage had_policy i.cohort i.edu female rural student indigenous ///
married [aw=weight] if had_policy!=., absorb(geo) vce(cluster geo)
* Second stage (IV)
eststo: quietly ivregress 2sls lwage (eng=had_policy) i.geo i.cohort i.edu female rural ///
student indigenous married [aw=weight] if had_policy!=., vce(cluster geo)
/*ivreghdfe lwage (eng=had_policy) female rural student ///
indigenous married [aw=weight] if had_policy!=., absorb(geo cohort edu) robust*/
esttab using "$doc\tabIVa.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(eng had_policy) ///
stats(N ar2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* APPENDIX */
*========================================================================*
/* TABLE X: Heterogenous effects */
*========================================================================*
/* Staggered DiD: By gender */
*========================================================================*
use "$base\eng_abil.dta", clear
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
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female indigenous ///
married [aw=weight] if female==0 & work==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female indigenous ///
married [aw=weight] if female==0 & work==1, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
married [aw=weight] if female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female indigenous ///
married [aw=weight] if female==0 & work==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDmen.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female indigenous ///
married [aw=weight] if female==1 & work==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female indigenous ///
married [aw=weight] if female==1 & work==1, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
married [aw=weight] if female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female indigenous ///
married [aw=weight] if female==1 & work==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDwomen.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen fem_pol=female*had_policy
eststo clear
eststo: areg hrs_exp fem_pol had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg eng fem_pol had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
eststo: areg work fem_pol had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage fem_pol had_policy i.state i.cohort i.edu female ///
indigenous married [aw=weight] if work==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDgender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(fem_pol) replace
*========================================================================*
/* Staggered DiD: By ethnicity */
*========================================================================*
use "$base\eng_abil.dta", clear
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
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if indigenous==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if indigenous==1, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
[aw=weight] if indigenous==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural student ///
indigenous married [aw=weight] if indigenous==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDind.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if indigenous==0, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if indigenous==0, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
[aw=weight] if indigenous==0, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural student ///
indigenous married [aw=weight] if indigenous==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDnind.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen ind_pol=indigenous*had_policy
eststo clear
eststo: areg hrs_exp ind_pol had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng ind_pol had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work ind_pol had_policy i.state i.cohort i.edu female indigenous ///
[aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage ind_pol had_policy i.cohort i.edu female rural student ///
indigenous married [aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDethnic.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Ethnicity differences) keep(ind_pol) replace
*========================================================================*
/* Staggered DiD: By geographical context */
*========================================================================*
use "$base\eng_abil.dta", clear
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
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if rural==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if rural==1, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
[aw=weight] if rural==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural student ///
indigenous married [aw=weight] if rural==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDrural.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg hrs_exp had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if rural==0, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight] if rural==0, absorb(geo) vce(cluster geo)
eststo: areg work had_policy i.state i.cohort i.edu female indigenous ///
[aw=weight] if rural==0, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female rural student ///
indigenous married [aw=weight] if rural==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDurban.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen rul_pol=rural*had_policy
eststo clear
eststo: areg hrs_exp rul_pol rural had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg eng rul_pol rural had_policy i.state i.cohort i.edu female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
eststo: areg work rul_pol rural had_policy i.state i.cohort i.edu female indigenous ///
[aw=weight], absorb(geo) vce(cluster geo)
eststo: areg lwage rul_pol rural had_policy i.cohort i.edu female rural student ///
indigenous married [aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_SDDgeo.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Geographical differences) keep(rul_pol) replace
