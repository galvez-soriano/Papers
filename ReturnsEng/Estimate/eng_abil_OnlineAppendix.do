*========================================================================*
/* ONLINE APPENDIX
English skills and labor market outcomes in Mexico */
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/ReturnsEng/Data"
gl doc= "C:\Users\galve\Documents\Papers\Current\Returns to Eng Mex\Doc"
*========================================================================*
/* FIGURE 1: Pre-trends test for Aguascalientes */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1 
keep if state=="01" | state=="32"
gen treat=state=="01"
gen after=cohort>=1990
replace after=. if cohort<1986 | cohort>1995
gen after_treat=after*treat

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
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.2 "Eng program", linegap(.2cm) ///
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
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.2 "Eng program", linegap(.2cm) ///
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
/* FIGURE 2: Pre-trends test for Coahuila */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1 
keep if state=="05" | state=="08"
gen treat=state=="05"
gen after=cohort>=1988
replace after=. if cohort<1979 | cohort>1996 
gen after_treat=after*treat

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
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 7.2 "Eng program", linegap(.2cm) ///
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
ytitle("Likelihood working for pay", size(medium) height(5)) ///
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
/* FIGURE X: Pre-trends test for Durango */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="10" | state=="24"
gen treat=state=="10"
gen after=cohort>=1991
replace after=. if cohort<1985 | cohort>1996 
gen after_treat=after*treat

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
ytitle("Likelihood working for pay", size(medium) height(5)) ///
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
/* FIGURE X: Pre-trends test for Nuevo Leon */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="19" | state=="24"
gen treat=state=="19"
gen after=cohort>=1987
replace after=. if cohort<1981 | cohort>1996
gen after_treat=after*treat

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
ytitle("Likelihood working for pay", size(medium) height(5)) ///
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
/* FIGURE X: Pre-trends test for Sinaloa */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="25" | state=="18"
gen treat=state=="25"
gen after=cohort>=1993
replace after=. if cohort<1989 | cohort>1996 
gen after_treat=after*treat

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
ytitle("Likelihood working for pay", size(medium) height(5)) ///
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
/* FIGURE X: Pre-trends test for Sonora */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="26" | state=="02" | state=="08"
gen treat=state=="26"
gen after=cohort>=1993
replace after=. if cohort<1991 | cohort>1996 
gen after_treat=after*treat

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
ytitle("Likelihood working for pay", size(medium) height(5)) ///
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
/* FIGURE X: Pre-trends test for Tamaulipas */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="28" | state=="02"
gen treat=state=="28"
gen after=cohort>=1990
replace after=. if cohort<1983 | cohort>1996 
gen after_treat=after*treat

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
ytitle("Likelihood working for pay", size(medium) height(5)) ///
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
/* Robustness Check */
*========================================================================*
/* FIGURE X: Pre-trends test for Aguascalientes */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="01" | state=="06" | state=="11" | state=="18" | state=="24" ///
| state=="32"
gen treat=state=="01"
gen after=cohort>=1990
replace after=. if cohort<1986 | cohort>1995
gen after_treat=after*treat

/* PTA */
foreach x in 86 87 88 89 90 91 92 93 94 95 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_89=0

areg eng treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1986 & cohort<=1995 & paidw==1, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 3.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGSr.png", replace

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
graph export "$doc\PTA_AGSr1.png", replace

areg paidw treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1986 & cohort<=1995, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_AGSr2.png", replace

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
graph export "$doc\PTA_AGSr3.png", replace
*========================================================================*
/* FIGURE X: Pre-trends test for Coahuila */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="05" | state=="08" | state=="24" | state=="32"
gen treat=state=="05"
gen after=cohort>=1988
replace after=. if cohort<1979 | cohort>1996
gen after_treat=after*treat

foreach x in 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_87=0

areg eng treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight]if cohort>=1979 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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

areg hrs_exp treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight]if cohort>=1979 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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

areg paidw treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight]if cohort>=1979 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 8.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_COAHr2.png", replace

areg lwage treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight]if cohort>=1979 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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
/* FIGURE X: Pre-trends test for Durango */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="10" | state=="08" | state=="24" | state=="32" | state=="14" 
gen treat=state=="10"
gen after=cohort>=1991
replace after=. if cohort<1985 | cohort>1996
gen after_treat=after*treat

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
graph export "$doc\PTA_DGOr.png", replace

areg hrs_exp treat_* treat i.cohort cohort i.edu female indigenous married ///
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
graph export "$doc\PTA_DGOr1.png", replace

areg paidw treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1985 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 5.1 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_DGOr2.png", replace

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
graph export "$doc\PTA_DGOr3.png", replace
*========================================================================*
/* FIGURE X: Pre-trends test for Nuevo Leon */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="19" | state=="08" | state=="24" | state=="32"  
gen treat=state=="19"
gen after=cohort>=1987
replace after=. if cohort<1981 | cohort>1996
gen after_treat=after*treat

foreach x in 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_86=0

areg eng treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight]if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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

areg hrs_exp treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight]if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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

areg paidw treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight]if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.2 "Eng program in 6th grade", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_NLr2.png", replace

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
graph export "$doc\PTA_NLr3.png", replace
*========================================================================*
/* FIGURE X: Pre-trends test for Sinaloa */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="25" | state=="08" | state=="32" | state=="18" | state=="02" ///
| state=="03"
gen treat=state=="25"
gen after=cohort>=1993
replace after=. if cohort<1989 | cohort>1996
gen after_treat=after*treat

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
graph export "$doc\PTA_SINr.png", replace

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
graph export "$doc\PTA_SINr1.png", replace

areg paidw treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1966 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 3.5 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SINr2.png", replace

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
graph export "$doc\PTA_SINr3.png", replace
*========================================================================*
/* FIGURE X: Pre-trends test for Sonora */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="26" | state=="08" | state=="02" | state=="03" | state=="14" ///
| state=="32" 
gen treat=state=="26"
gen after=cohort>=1993
replace after=. if cohort<1991 | cohort>1996
gen after_treat=after*treat

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
graph export "$doc\PTA_SONr.png", replace

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
graph export "$doc\PTA_SONr1.png", replace

areg paidw treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1989 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 1.8 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_SONr2.png", replace

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
graph export "$doc\PTA_SONr3.png", replace
*========================================================================*
/* FIGURE X: Pre-trends test for Tamaulipas */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if state=="28" | state=="08" | state=="32" | state=="18" | state=="02" ///
| state=="03"
gen treat=state=="28"
gen after=cohort>=1990
replace after=. if cohort<1983 | cohort>1996
gen after_treat=after*treat

foreach x in 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_89=0

areg eng treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight]if cohort>=1981 & cohort<=1996 & paidw==1, absorb(geo) vce(cluster geo)
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
graph export "$doc\PTA_TAMr1.png", replace

areg paidw treat_* treat i.cohort cohort i.edu female indigenous married ///
[aw=weight] if cohort>=1981 & cohort<=1996, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(1.2 6 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\PTA_TAMr2.png", replace

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
graph export "$doc\PTA_TAMr3.png", replace
*========================================================================*
/* TABLE X: ITT effect of offering English instruction at school on 
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
/* Panel A: Full sample */
eststo clear
eststo: areg farm had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg elem had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg mach had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg craf had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg cust had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg sale had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg cler had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg prof had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg mana had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg abro had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tabSDDoccup.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Panel B: Heterogeneous effects by gender */
/* Men */
eststo clear
eststo: areg farm had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg elem had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg mach had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg craf had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg cust had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg sale had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg cler had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg prof had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg mana had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg abro had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==0 & paidw==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tabSDDoccupMen.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Women */
eststo clear
eststo: areg farm had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg elem had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg mach had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg craf had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg cust had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg sale had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg cler had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg prof had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg mana had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
eststo: areg abro had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if female==1 & paidw==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tabSDDoccupWomen.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Difference in estimate by gender */
gen fem_pol=female*had_policy
gen fem_cohort=female*cohort
destring geo, replace
gen fem_geo=female*geo
gen fem_edu=female*edu
eststo clear
eststo: reghdfe farm fem_pol had_policy female rural indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe elem fem_pol had_policy female rural indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe mach fem_pol had_policy female rural indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe craf fem_pol had_policy female rural indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe cust fem_pol had_policy female rural indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe sale fem_pol had_policy female rural indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe cler fem_pol had_policy female rural indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe prof fem_pol had_policy female rural indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe mana fem_pol had_policy female rural indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe abro fem_pol had_policy female rural indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
esttab using "$doc\tabSDDoccupGender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(fem_pol) replace
*========================================================================*
/* TABLE X: ITT effect of offering English instruction at school on 
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
/* Panel A: Full sample */
eststo clear
eststo: areg ag had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg cons had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg manu had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg svcs had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg abroad had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tabSDDind.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Panel B: Heterogeneous effects by gender */
/* Men */
eststo clear
eststo: areg ag had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg cons had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg manu had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg svcs had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg abroad had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tabSDDindMen.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Women */
eststo clear
eststo: areg ag had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg cons had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg manu had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg svcs had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg abroad had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tabSDDindWomen.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Difference in estimate by gender */
gen fem_pol=female*had_policy
gen fem_cohort=female*cohort
destring geo, replace
gen fem_geo=female*geo
gen fem_edu=female*edu
eststo clear
eststo: reghdfe ag fem_pol had_policy female rural indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe cons fem_pol had_policy female rural indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe manu fem_pol had_policy female rural indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe svcs fem_pol had_policy female rural indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
eststo: reghdfe abroad fem_pol had_policy female rural indigenous married ///
[aw=weight] if paidw==1, absorb(fem_cohort fem_geo fem_edu cohort edu geo) vce(cluster geo)
esttab using "$doc\tabSDDindGender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(fem_pol) replace
