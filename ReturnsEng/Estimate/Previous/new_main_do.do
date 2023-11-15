*========================================================================*
/* English skills and labor market outcomes in Mexico */
*========================================================================*
/* Author: Oscar Galvez-Soriano */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/ReturnsEng/Data"
gl base= "C:\Users\Oscar Galvez-Soriano\Documents\Papers\ReturnsEng\Data"
gl doc= "C:\Users\Oscar Galvez-Soriano\Documents\Papers\ReturnsEng\Doc"
*========================================================================*
/* TABLE 4. Effect of English programs (staggered DiD) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
replace hrs_exp=hrs_exp/2 if state=="19" & cohort<1987
replace hrs_exp=hrs_exp/2 if state=="01" & cohort<1990
drop if state=="05" | state=="17"
gen engl=hrs_exp>=0.1
/*keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"*/

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996)
*replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
keep if cohort>=1981 & cohort<=1996

destring state, replace
gen cohort_state=cohort*state

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
/* APPENDIX */
*========================================================================*
/* FIGURE A.5. Pre-trends test pooling all states (SDD estimate) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1

gen engl=hrs_exp>=0.1
/*keep if state=="01"  | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"*/
drop if state=="05" | state=="17"
gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996)
*replace had_policy=1 if state=="05" & (cohort>=1990 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
keep if cohort>=1981 & cohort<=1996

*gen treat2=cohort==1979 & engl==1 & state=="19" // -8 relative to the first affected cohort
*gen treat3=cohort==1980 & engl==1 & state=="19"
gen treat4=cohort==1981 & engl==1 & state=="19"
gen treat5=cohort==1982 & engl==1 & state=="19"
gen treat6=cohort==1983 & engl==1 & state=="19"
gen treat7=cohort==1984 & engl==1 & state=="19"
gen treat8=cohort==1985 & engl==1 & state=="19"
gen treat9=cohort==1986 & engl==1 & state=="19"  // -1 relative to the first affected cohort
gen treat10=cohort==1987 & engl==1 & state=="19" // 0 first affected cohort
gen treat11=cohort==1988 & engl==1 & state=="19" // +1 relative to the first affected cohort
gen treat12=cohort==1989 & engl==1 & state=="19"
gen treat13=cohort==1990 & engl==1 & state=="19"
gen treat14=cohort==1991 & engl==1 & state=="19"
gen treat15=cohort==1992 & engl==1 & state=="19"
gen treat16=cohort==1993 & engl==1 & state=="19"
gen treat17=cohort==1994 & engl==1 & state=="19"
gen treat18=cohort==1995 & engl==1 & state=="19" // +8 relative to the first affected cohort

replace treat4=1 if cohort==1984 & engl==1 & state=="01"  // -6 relative to the first affected cohort
replace treat5=1 if cohort==1985 & engl==1 & state=="01"
replace treat6=1 if cohort==1986 & engl==1 & state=="01"
replace treat7=1 if cohort==1987 & engl==1 & state=="01"
replace treat8=1 if cohort==1988 & engl==1 & state=="01"
replace treat9=1 if cohort==1989 & engl==1 & state=="01"  // -1 relative to the first affected cohort
replace treat10=1 if cohort==1990 & engl==1 & state=="01" // 0 first affected cohort
replace treat11=1 if cohort==1991 & engl==1 & state=="01" // +1 relative to the first affected cohort
replace treat12=1 if cohort==1992 & engl==1 & state=="01"
replace treat13=1 if cohort==1993 & engl==1 & state=="01"
replace treat14=1 if cohort==1994 & engl==1 & state=="01"
replace treat15=1 if cohort==1995 & engl==1 & state=="01"
replace treat16=1 if cohort==1996 & engl==1 & state=="01" // +6 relative to the first affected cohort
/*
replace treat4=1 if cohort==1984 & engl==1 & state=="05"  // -6 relative to the first affected cohort
replace treat5=1 if cohort==1985 & engl==1 & state=="05"
replace treat6=1 if cohort==1986 & engl==1 & state=="05"
replace treat7=1 if cohort==1987 & engl==1 & state=="05"
replace treat8=1 if cohort==1988 & engl==1 & state=="05"
replace treat9=1 if cohort==1989 & engl==1 & state=="05"  // -1 relative to the first affected cohort
replace treat10=1 if cohort==1990 & engl==1 & state=="05" // 0 first affected cohort
replace treat13=1 if cohort==1991 & engl==1 & state=="05" // +1 relative to the first affected cohort
replace treat14=1 if cohort==1992 & engl==1 & state=="05"
replace treat15=1 if cohort==1993 & engl==1 & state=="05"
replace treat16=1 if cohort==1994 & engl==1 & state=="05"
replace treat17=1 if cohort==1995 & engl==1 & state=="05"
replace treat18=1 if cohort==1996 & engl==1 & state=="05" // +6 relative to the first affected cohort
*/
replace treat4=1 if cohort==1985 & engl==1 & state=="10"  // -6 relative to the first affected cohort
replace treat5=1 if cohort==1986 & engl==1 & state=="10"
replace treat6=1 if cohort==1987 & engl==1 & state=="10"
replace treat7=1 if cohort==1988 & engl==1 & state=="10"
replace treat8=1 if cohort==1989 & engl==1 & state=="10"
replace treat9=1 if cohort==1990 & engl==1 & state=="10"  // -1 relative to the first affected cohort
replace treat10=1 if cohort==1991 & engl==1 & state=="10" // 0 first affected cohort
replace treat11=1 if cohort==1992 & engl==1 & state=="10" // +1 relative to the first affected cohort
replace treat12=1 if cohort==1993 & engl==1 & state=="10"
replace treat13=1 if cohort==1994 & engl==1 & state=="10"
replace treat14=1 if cohort==1995 & engl==1 & state=="10"
replace treat15=1 if cohort==1996 & engl==1 & state=="10" // +5 relative to the first affected cohort

replace treat6=1 if cohort==1989 & engl==1 & state=="25"  // -4 relative to the first affected cohort
replace treat7=1 if cohort==1990 & engl==1 & state=="25"
replace treat8=1 if cohort==1991 & engl==1 & state=="25"
replace treat9=1 if cohort==1992 & engl==1 & state=="25"  // -1 relative to the first affected cohort
replace treat10=1 if cohort==1993 & engl==1 & state=="25" // 0 first affected cohort
replace treat11=1 if cohort==1994 & engl==1 & state=="25" // +1 relative to the first affected cohort
replace treat12=1 if cohort==1995 & engl==1 & state=="25"
replace treat13=1 if cohort==1996 & engl==1 & state=="25" // +3 relative to the first affected cohort

replace treat7=1 if cohort==1990 & engl==1 & state=="26"  // -3 relative to the first affected cohort
replace treat8=1 if cohort==1991 & engl==1 & state=="26"
replace treat9=1 if cohort==1992 & engl==1 & state=="26"  // -1 relative to the first affected cohort
replace treat10=1 if cohort==1993 & engl==1 & state=="26" // 0 first affected cohort
replace treat11=1 if cohort==1994 & engl==1 & state=="26" // +1 relative to the first affected cohort
replace treat12=1 if cohort==1995 & engl==1 & state=="26"
replace treat13=1 if cohort==1996 & engl==1 & state=="26" // +3 relative to the first affected cohort

*replace treat3=1 if cohort==1983 & engl==1 & state=="28"  // -7 relative to the first affected cohort
replace treat4=1 if cohort==1984 & engl==1 & state=="28"  // -6 relative to the first affected cohort
replace treat5=1 if cohort==1985 & engl==1 & state=="28"
replace treat6=1 if cohort==1986 & engl==1 & state=="28"
replace treat7=1 if cohort==1987 & engl==1 & state=="28"
replace treat8=1 if cohort==1988 & engl==1 & state=="28"
replace treat9=1 if cohort==1989 & engl==1 & state=="28"  // -1 relative to the first affected cohort
replace treat10=1 if cohort==1990 & engl==1 & state=="28" // 0 first affected cohort
replace treat11=1 if cohort==1991 & engl==1 & state=="28" // +1 relative to the first affected cohort
replace treat12=1 if cohort==1992 & engl==1 & state=="28"
replace treat13=1 if cohort==1993 & engl==1 & state=="28"
replace treat14=1 if cohort==1994 & engl==1 & state=="28"
replace treat15=1 if cohort==1995 & engl==1 & state=="28"
replace treat16=1 if cohort==1996 & engl==1 & state=="28" // +6 relative to the first affected cohort

replace treat9=0

*label var treat2 "-8"
*label var treat3 "-7"
label var treat4 "-6"
label var treat5 "-5"
label var treat6 "-4"
label var treat7 "-3"
label var treat8 "-2"
label var treat9 "-1"
foreach x in 0 1 2 3 4 5 6 7 8 {
	label var treat1`x' "`x'"
}
destring state, replace
gen cohort_state=cohort*state

/* Panel (a) Hours of English */
reghdfe hrs_exp treat* i.edu female indigenous married ///
[aw=weight] if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo cohort_state) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-0.5(0.25)1.25, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 1.25)) recast(connected)
graph export "$doc\PTA_StaggDD1.png", replace
/* Panel (b) Speak English */
reghdfe eng treat* i.edu female indigenous married ///
[aw=weight] if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo cohort_state) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) recast(connected)
graph export "$doc\PTA_StaggDD2.png", replace
/* Panel (c) Paid work */
reghdfe paidw treat* i.edu female indigenous married ///
[aw=weight] if cohort>=1981 & cohort<=1996, absorb(geo cohort_state) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) recast(connected)
graph export "$doc\PTA_StaggDD3.png", replace
/* Panel (d) Ln(wage) */
reghdfe lwage treat* i.edu female indigenous married ///
[aw=weight] if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo cohort_state) vce(cluster geo)
coefplot, vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
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
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of being enrolled in school", size(medium) height(5)) ///
ylabel(-.5(.25).5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-.5 .5)) recast(connected)
graph export "$doc\PTA_StaggDD5.png", replace