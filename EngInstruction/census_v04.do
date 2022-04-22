*========================================================================*
* English program and earnings
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Census"
gl github= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EngInstruction"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New"
gl doc= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Doc"
*========================================================================*
use "$data\census20.dta", clear
rename geo geo_mun_s
merge m:m geo_mun_s cohort using "$github/exposure_mun.dta"
drop if _merge!=3
drop _merge

tostring state, replace format(%02.0f) force
tostring mun, replace format(%03.0f) force
gen str geo=(state+mun)

merge m:m geo using "$github/p_stud_census2020.dta"
drop _merge

label define ind_act 0 "Student" 1 "Formal worker" ///
2 "Informal worker" 3 "Inactive"
label values ind_act ind_act

replace student=0 if ind_act!=0 & student==.
replace work=0 if ind_act==0 | ind_act==3
gen formal_s=ind_act==1
gen informal_s=ind_act==2
gen inactive=ind_act==3

gen labor=0
replace labor=1 if ind_act==1 | ind_act==2
replace lwage=0 if lwage==.
gen migrant=state_w>=100
replace migrant=0 if state_w>=999
replace ind_act=. if conact==99

/* Droping Pesqueria County, Mty because there is an unusual proportion of
individuals working in formal sector, probably because of the KIA automotive
company recently established there 
drop if geo=="19041" */

catplot ind_act cohort [fw=factor] if ps39==1, percent(cohort) ///
graphregion(fcolor(white)) scheme(s2mono) ///
var1opts(label(labsize(small))) ///
var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Percent of individuals by occupation", size(small)) ///
asyvars stack ///
legend(rows(1) stack size(small) ///
order(1 "Student" 2 "Formal worker" ///
3 "Informal worker" 4 "Inactive") ///
symplacement(center))
graph export "$doc\labor_census20_low.png", replace
save "$base\labor_census20.dta", replace 
*========================================================================*
use "$base\labor_census20.dta", clear
destring state5, replace
eststo clear
eststo: areg student hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu i.cohort i.state5 [aw=factor] if cohort>1997, absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997, absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997, absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997, absorb(geo) vce(cluster geo)
eststo: areg migrant hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997, absorb(geo) vce(cluster geo)
eststo: areg labor hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if formal_s==1 & cohort>1997, absorb(geo) vce(cluster geo)
esttab using "$doc\tab1_census.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg student hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg migrant hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg labor hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if formal_s==1 & cohort>1997 & ps43==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_census.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg student hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg migrant hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg labor hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if formal_s==1 & cohort>1997 & ps43==1 & female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_census_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg student hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg migrant hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg labor hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if formal_s==1 & cohort>1997 & ps43==1 & female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_census_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen eng_fem=hrs_exp*female

eststo clear
eststo: areg student eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg formal_s eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg informal_s eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg inactive eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg migrant eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg labor eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg lwage eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg lwage eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if formal_s==1 & cohort>1997 & ps43==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_census_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(eng_fem) replace
*========================================================================*
/* PTA */
*========================================================================*
foreach x in 1998 1999 2000 2001 2002{
gen engh`x'=0
label var engh`x' "`x'"
replace engh`x'=hrs_exp if cohort==`x'
}
destring state5, replace
replace engh1999=0

areg student engh* hrs_exp rural rural#cohort female#cohort female#state5 ///
female age age2 edu i.cohort i.state5 [aw=factor] if ps43==1 ///
& cohort>1997, absorb(geo) vce(cluster geo)
coefplot, vertical keep(engh*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of being enrolled in school", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) text(0.12 2.1 "NEPBE", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\cpv_stud_pta.png", replace

areg formal_s engh* hrs_exp rural rural#cohort female#cohort female#state5 ///
female age age2 edu student i.cohort i.state5 [aw=factor] if ps43==1 ///
& cohort>1997, absorb(geo) vce(cluster geo)
coefplot, vertical keep(engh*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of working in formal sector", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) text(0.12 2.1 "NEPBE", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\cpv_formal_pta.png", replace

areg informal_s engh* hrs_exp rural rural#cohort female#cohort female#state5 ///
female age age2 edu student i.cohort i.state5 [aw=factor] if ps43==1 ///
& cohort>1997, absorb(geo) vce(cluster geo)
coefplot, vertical keep(engh*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of working in informal sector", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) text(0.12 2.1 "NEPBE", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\cpv_informal_pta.png", replace

areg inactive engh* hrs_exp rural rural#cohort female#cohort female#state5 ///
female age age2 edu student i.cohort i.state5 [aw=factor] if ps43==1 ///
& cohort>1997, absorb(geo) vce(cluster geo)
coefplot, vertical keep(engh*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of being inactive", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) text(0.12 2.1 "NEPBE", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\cpv_inactive_pta.png", replace

areg lwage engh* hrs_exp rural rural#cohort female#cohort female#state5 ///
female age age2 edu student formal_s informal_s i.cohort i.state5 ///
[aw=factor] if ps43==1 & cohort>1997, absorb(geo) vce(cluster geo)
coefplot, vertical keep(engh*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.4 0.4)) text(0.48 2.1 "NEPBE", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\cpv_wage_pta.png", replace

areg migrant engh* hrs_exp rural rural#cohort female#cohort female#state5 ///
female age age2 edu student formal_s informal_s i.cohort i.state5 ///
[aw=factor] if ps43==1 & cohort>1997, absorb(geo) vce(cluster geo)
coefplot, vertical keep(engh*) yline(0) omitted baselevels ///
xline(2.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of international migration", size(medium) height(5)) ///
ylabel(-0.01(0.005)0.01, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.01 0.01)) text(0.012 2.1 "NEPBE", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\cpv_migrant_pta.png", replace
*========================================================================*
label var hrs_exp "Proportion of individuals enrolled in school"
destring state5, replace

eststo clear
foreach x in 35 36 37 38 39 40 41 42 43 44 45{
areg formal_s hrs_exp rural rural#cohort female#cohort female#state5 female age ///
age2 edu student i.cohort i.state5 [aw=factor] if ps`x'==1, absorb(geo) vce(cluster geo)
estimates store formal`x'
}
coefplot (formal35, label(p<=0.35)) (formal36, label(p<=0.36)) (formal37, ///
label(p<=0.37)) (formal38, label(p<=0.38)) (formal39, label(p<=0.39)) ///
(formal40, label(p<=0.40)) (formal41, label(p<=0.41)) (formal42, ///
label(p<=0.42)) (formal43, mcolor(red) ciopts(recast(rcap)color(red)) ///
label(p<=0.43)) (formal44, label(p<=0.44)) ///
(formal45, label(p<=0.45)), vertical keep(hrs_exp) yline(0) ///
ytitle("Probability of working in formal sector", size(medium) height(5)) ///
ylabel(-0.15(0.05)0.15, labs(medium) grid format(%5.2f)) ///
legend( pos(1) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\formal_cpv20.png", replace

eststo clear
foreach x in 35 36 37 38 39 40 41 42 43 44 45{
areg labor hrs_exp rural rural#cohort female#cohort female#state5 female age ///
age2 edu student i.cohort i.state5 [aw=factor] if ps`x'==1, absorb(geo) vce(cluster geo)
estimates store labor`x'
}
coefplot (labor35, label(p<=0.35)) (labor36, label(p<=0.36)) (labor37, ///
label(p<=0.37)) (labor38, label(p<=0.38)) (labor39, label(p<=0.39)) ///
(labor40, label(p<=0.40)) (labor41, label(p<=0.41)) (labor42, ///
label(p<=0.42)) (labor43, mcolor(red) ciopts(recast(rcap)color(red)) ///
label(p<=0.43)) (labor44, label(p<=0.44)) ///
(labor45, label(p<=0.45)), vertical keep(hrs_exp) yline(0) ///
ytitle("Probability of participate in the labor market", size(medium) height(5)) ///
ylabel(-0.15(0.05)0.15, labs(medium) grid format(%5.2f)) ///
legend( pos(1) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\labor_cpv20.png", replace

eststo clear
foreach x in 35 36 37 38 39 40 41 42 43 44 45{
areg lwage hrs_exp rural rural#cohort female#cohort female#state5 ///
female age age2 edu student formal_s informal_s i.cohort i.state5 ///
[aw=factor] if ps`x'==1 , absorb(geo) vce(cluster geo)
estimates store wage`x'
}
coefplot (wage35, label(p<=0.35)) (wage36, label(p<=0.36)) (wage37, ///
label(p<=0.37)) (wage38, label(p<=0.38)) (wage39, label(p<=0.39)) ///
(wage40, label(p<=0.40)) (wage41, label(p<=0.41)) (wage42, ///
label(p<=0.42)) (wage43, mcolor(red) ciopts(recast(rcap)color(red)) ///
label(p<=0.43)) (wage44, label(p<=0.44)) ///
(wage45, label(p<=0.45)), vertical keep(hrs_exp) yline(0) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
legend( pos(1) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\wage_cpv20.png", replace
*========================================================================*
/* Low achievement */
*========================================================================*
use "$base\labor_census20.dta", clear

catplot ind_act cohort [fw=factor] if edu<=9, percent(cohort) ///
graphregion(fcolor(white)) scheme(s2mono) ///
var1opts(label(labsize(small))) ///
var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Percent of individuals by occupation", size(small)) ///
asyvars stack ///
legend(rows(1) stack size(small) ///
order(1 "Student" 2 "Formal worker" ///
3 "Informal worker" 4 "Inactive") ///
symplacement(center))

destring state5, replace
eststo clear
eststo: areg student hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6, absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6, absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6, absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6, absorb(geo) vce(cluster geo)
eststo: areg migrant hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6, absorb(geo) vce(cluster geo)
eststo: areg labor hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if formal_s==1 & cohort>1997 & edu<=6, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_cpv_edu.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg student hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6 & female==0, absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6 & female==0, absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6 & female==0, absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6 & female==0, absorb(geo) vce(cluster geo)
eststo: areg migrant hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6 & female==0, absorb(geo) vce(cluster geo)
eststo: areg labor hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6 & female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6 & female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if formal_s==1 & cohort>1997 & edu<=6 & female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_cpv_edu_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg student hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6 & female==1, absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6 & female==1, absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6 & female==1, absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6 & female==1, absorb(geo) vce(cluster geo)
eststo: areg migrant hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6 & female==1, absorb(geo) vce(cluster geo)
eststo: areg labor hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6 & female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6 & female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if formal_s==1 & cohort>1997 & edu<=6 & female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_cpv_edu_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen eng_fem=hrs_exp*female

eststo clear
eststo: areg student eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6, absorb(geo) vce(cluster geo)
eststo: areg formal_s eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6, absorb(geo) vce(cluster geo)
eststo: areg informal_s eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6, absorb(geo) vce(cluster geo)
eststo: areg inactive eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6, absorb(geo) vce(cluster geo)
eststo: areg migrant eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6, absorb(geo) vce(cluster geo)
eststo: areg labor eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6, absorb(geo) vce(cluster geo)
eststo: areg lwage eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if cohort>1997 & edu<=6, absorb(geo) vce(cluster geo)
eststo: areg lwage eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s informal_s i.cohort i.state5 [aw=factor] if formal_s==1 & cohort>1997 & edu<=6, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_cpv_edu_gender.tex", cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(eng_fem) stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Jobs classifications */
*========================================================================*
use "$base\labor_census20.dta", clear
destring state5, replace
replace actividades_c=. if actividades_c==9999
rename actividades_c scian

gen econ_act=.
replace econ_act=1 if (scian>=1110 & scian<=1199)
replace econ_act=2 if (scian>1199 & scian<=2399)
replace econ_act=3 if (scian>2399 & scian<=3399)
replace econ_act=4 if (scian>3399 & scian<=4699)
replace econ_act=5 if (scian>4699 & scian<=4930)
replace econ_act=6 if (scian>=5411 & scian<=5414) | (scian>=6111 & scian<=6299) ///
| (scian>=5510 & scian<=5622) // Includes Professional, Technical and Management
replace econ_act=7 if (scian>=5110 & scian<=5399) //Includes telecommunications, finance and real state
replace econ_act=8 if (scian>=7111 & scian<=7223)
replace econ_act=9 if (scian>=9311 & scian<=9399)
replace econ_act=10 if (scian>=8111 & scian<=8140)

label define econ_act 1 "Agriculture" 2 "Construction" 3 "Manufactures" ///
4 "Commerce" 5 "Transportation" 6 "Professional/Technical" 7 "Telecom/Finance" ///
8 "Hospitality/Entertainment" 9 "Government" 10 "Other Services"
label values econ_act econ_act

gen ag_ea=econ_act==1
gen cons_ea=econ_act==2
gen manu_ea=econ_act==3
gen comm_ea=econ_act==4
gen transp_ea=econ_act==5
gen pro_ea=econ_act==6
gen telecom_ea=econ_act==7
gen hosp_ea=econ_act==8
gen gov_ea=econ_act==9
gen other_ea=econ_act==10

*======== Economic activities ========*
/* Full sample */
eststo clear
eststo: areg ag_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg transp_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg telecom_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg other_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=., absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Low enrollment sample */
eststo clear
eststo: areg ag_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg transp_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg telecom_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg other_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_low.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Men */
eststo clear
eststo: areg ag_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0, absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0, absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0, absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0, absorb(geo) vce(cluster geo)
eststo: areg transp_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0, absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0, absorb(geo) vce(cluster geo)
eststo: areg telecom_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0, absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0, absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0, absorb(geo) vce(cluster geo)
eststo: areg other_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Women */
eststo clear
eststo: areg ag_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1, absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1, absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1, absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1, absorb(geo) vce(cluster geo)
eststo: areg transp_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1, absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1, absorb(geo) vce(cluster geo)
eststo: areg telecom_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1, absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1, absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1, absorb(geo) vce(cluster geo)
eststo: areg other_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Gender differences */
gen eng_fem=hrs_exp*female

eststo clear
eststo: areg ag_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg cons_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg manu_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg comm_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg transp_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg pro_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg telecom_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg hosp_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg gov_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
eststo: areg other_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=., absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(eng_fem) replace

*======== Economic activities in formal sector ========*
/* Full sample */
eststo clear
eststo: areg ag_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg transp_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg telecom_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg other_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_formal.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Low enrollment sample */
eststo clear
eststo: areg ag_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg transp_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg telecom_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg other_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_low_formal.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Men */
eststo clear
eststo: areg ag_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg transp_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg telecom_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg other_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==0 & formal_s==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_men_formal.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Women */
eststo clear
eststo: areg ag_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg transp_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg telecom_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1 & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg other_ea hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & female==1 & formal_s==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_women_formal.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Gender differences */
eststo clear
eststo: areg ag_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg cons_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg manu_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg comm_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg transp_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg pro_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg telecom_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg hosp_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg gov_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg other_ea eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & ps43==1 & econ_act!=. & formal_s==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_gender_formal.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(eng_fem) replace
*============ Occupations ============*
use "$base\labor_census20.dta", clear
destring state5, replace
rename ocupacion_c sinco

gen occup=.
replace occup=1 if (sinco>610 & sinco<=613) | (sinco>620 & sinco<=623) ///
| sinco==699
replace occup=2 if (sinco>=911 & sinco<=989) 
replace occup=3 if (sinco>=711 & sinco<=719) | (sinco>=721 & sinco<=729) ///
| (sinco>=731 & sinco<=739) | (sinco==741) | (sinco>=751 & sinco<=759) ///
| (sinco>=761 & sinco<=799)
replace occup=4 if (sinco==511) | (sinco>=521 & sinco<=529) ///
| (sinco==531) | (sinco==541)
replace occup=5 if sinco==411 | (sinco>=421 & sinco<=423) | (sinco==431) ///
| (sinco==499)
replace occup=6 if sinco==631 | (sinco>=811 & sinco<=819) | (sinco==821) ///
| (sinco>=831 & sinco<=899)
replace occup=7 if (sinco>=311 & sinco<=314) | (sinco>=321 & sinco<=399)
replace occup=8 if (sinco>=111 & sinco<=199) | sinco==231 | sinco==310 ///
| sinco==320 | sinco==420 | sinco==430 | sinco==510 | sinco==520 ///
| sinco==530 | sinco==540 | sinco==610 | sinco==620 | sinco==710 ///
| sinco==720 | sinco==730 | sinco==740 | sinco==750 | sinco==760 ///
| sinco==810 | sinco==820 | sinco==830
replace occup=9 if (sinco>=211 & sinco<=299)

label define occup 1 "Farming" 2 "Elementary occupations" 3 "Crafts" ///
4 "Services" 5 "Commerce" 6 "Machine operators" 7 "Clerical support" ///
8 "Managerial" 9 "Professionals/Technicians"
label values occup occup

gen farm_o=occup==1
gen elem_o=occup==2
gen cft_o=occup==3
gen ser_o=occup==4
gen com_o=occup==5
gen mach_o=occup==6
gen cler_o=occup==7
gen mana_o=occup==8
gen prof_o=occup==9

/* Full sample */
eststo clear
eststo: areg farm_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=., absorb(geo) vce(cluster geo)
eststo: areg elem_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=., absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=., absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=., absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=., absorb(geo) vce(cluster geo)
eststo: areg mach_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=., absorb(geo) vce(cluster geo)
eststo: areg cler_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=., absorb(geo) vce(cluster geo)
eststo: areg mana_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=., absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=., absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Occupations - Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Low enrollment sample */
eststo clear
eststo: areg farm_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg elem_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg mach_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg cler_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg mana_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup_low.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Men */
eststo clear
eststo: areg farm_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg elem_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg mach_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg cler_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg mana_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Women */
eststo clear
eststo: areg farm_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg elem_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg mach_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg cler_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg mana_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1 & female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Gender differences */
gen eng_fem=hrs_exp*female
eststo clear
eststo: areg farm_o eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg elem_o eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg cft_o eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg ser_o eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg com_o eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg mach_o eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg cler_o eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg mana_o eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
eststo: areg prof_o eng_fem hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student formal_s i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & ps43==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup_gender.tex", cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) stats(N ar2, fmt(%9.0fc %9.3f)) replace
*======== Occupations in formal sector ========*
/* Full sample */
eststo clear
eststo: areg farm_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg elem_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg mach_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg cler_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg mana_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & formal_s==1, absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural rural#cohort female#cohort female#state5 female age age2 edu student i.cohort i.state5 [aw=factor] if cohort>1997 & occup!=. & formal_s==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup_formal.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Occupations - Census estimations) keep(hrs_exp) replace
*========================================================================*
/* Table occupations and Multinomial Logit */
*========================================================================*
tab occup [fw=factor]
table occup [fw=factor], c(mean edu mean wage mean formal)

*set mat 11000
destring state, replace
eststo clear
* All
eststo: mlogit occup hrs_exp rural female age formal i.cohort i.state [aw=factor], vce(cluster geo) base(5) rrr
* Men
eststo: mlogit occup hrs_exp rural female age formal i.cohort i.state if female==0 [aw=factor], vce(cluster geo) base(5) rrr
* Female
eststo: mlogit occup hrs_exp rural female age formal i.cohort i.state if female==1 [aw=factor], vce(cluster geo) base(5) rrr
* Formal
eststo: mlogit occup hrs_exp rural female age formal i.cohort i.state if formal==1 [aw=factor], vce(cluster geo) base(5) rrr
* Informal
eststo: mlogit occup hrs_exp rural female age formal i.cohort i.state if formal==0 [aw=factor], vce(cluster geo) base(5) rrr
esttab using "$doc\tab_occup_multi_logit.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(Census estimations) ///
keep(hrs_exp) replace

/*quietly mlogit occup hrs_exp rural female age i.cohort i.geo [aw=factor], vce(cluster geo) base(5) rrr
estimates table, keep(hrs_exp)*/
