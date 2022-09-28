*========================================================================*
* English program and earnings
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\galve\Documents\Papers\Current\EngMigration\Base"
gl doc= "C:\Users\galve\Documents\Papers\Current\EngMigration\Doc"
*========================================================================*
/*
use "$data/Papers/main/EngMigration/Data/labor_census20_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14 {
    append using "$data/Papers/main/EngMigration/Data/labor_census20_`x'.dta"
}
save "$base\labor_census20.dta", replace 
*/
use "$base\labor_census20.dta", clear
replace lwage=0 if lwage==.

eststo clear
eststo: areg student hrs_exp rural female i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural female i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_exp rural female i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_exp rural female i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg migrant hrs_exp rural female i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg work hrs_exp rural female i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female i.edu i.cohort [aw=factor] if work==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab1_census.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(hrs_exp) replace

eststo clear
eststo: areg student hrs_exp rural female i.cohort [aw=factor] if ps43==1, absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural female i.cohort [aw=factor] if ps43==1, absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_exp rural female i.cohort [aw=factor] if ps43==1, absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_exp rural female i.cohort [aw=factor] if ps43==1, absorb(geo) vce(cluster geo)
eststo: areg migrant hrs_exp rural female i.cohort [aw=factor] if ps43==1, absorb(geo) vce(cluster geo)
eststo: areg work hrs_exp rural female i.cohort [aw=factor] if ps43==1, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female i.edu i.cohort [aw=factor] if work==1 & ps43==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab1_census_low.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(hrs_exp) replace

eststo clear
eststo: areg student hrs_exp rural female i.cohort [aw=factor] if ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural female i.cohort [aw=factor] if ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_exp rural female i.cohort [aw=factor] if ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_exp rural female i.cohort [aw=factor] if ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg migrant hrs_exp rural female i.cohort [aw=factor] if ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg work hrs_exp rural female i.cohort [aw=factor] if ps43==1 & female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female i.edu i.cohort [aw=factor] if work==1 & ps43==1 & female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab1_census_low_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(hrs_exp) replace

eststo clear
eststo: areg student hrs_exp rural female i.cohort [aw=factor] if ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural female i.cohort [aw=factor] if ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_exp rural female i.cohort [aw=factor] if ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_exp rural female i.cohort [aw=factor] if ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg migrant hrs_exp rural female i.cohort [aw=factor] if ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg work hrs_exp rural female i.cohort [aw=factor] if ps43==1 & female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female i.edu i.cohort [aw=factor] if work==1 & ps43==1 & female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab1_census_low_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(hrs_exp) replace

gen hrs_fem=hrs_exp*female
eststo clear
eststo: areg student hrs_fem hrs_exp rural female i.cohort [aw=factor] if ps43==1, absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_fem hrs_exp rural female i.cohort [aw=factor] if ps43==1, absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_fem hrs_exp rural female i.cohort [aw=factor] if ps43==1, absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_fem hrs_exp rural female i.cohort [aw=factor] if ps43==1, absorb(geo) vce(cluster geo)
eststo: areg migrant hrs_fem hrs_exp rural female i.cohort [aw=factor] if ps43==1, absorb(geo) vce(cluster geo)
eststo: areg work hrs_fem hrs_exp rural female i.cohort [aw=factor] if ps43==1, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_fem hrs_exp rural female i.edu i.cohort [aw=factor] if work==1 & ps43==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab1_census_low_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_fem) replace

label var hrs_exp "Proportion of individuals enrolled in school"

eststo clear
foreach x in 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50{
areg work hrs_exp rural female i.cohort [aw=factor] if ps`x'==1, absorb(geo) vce(cluster geo)
estimates store work`x'
}
coefplot (work35, label(p<=0.35)) (work36, label(p<=0.36)) ///
(work37, label(p<=0.37)) (work38, label(p<=0.38)) (work39, label(p<=0.39)) ///
(work40, label(p<=0.40)) (work41, label(p<=0.41)) (work42, label(p<=0.42)) ///
(work43, label(p<=0.43) mcolor(red) ciopts(recast(rcap) color(red))) ///
(work44, label(p<=0.44)) (work45, label(p<=0.45)) (work46, label(p<=0.46)) ///
(work47, label(p<=0.47)) (work48, label(p<=0.48)) (work49, label(p<=0.49)) ///
(work50, label(p<=0.50)), vertical keep(hrs_exp) yline(0) ///
ytitle("Probability of working", size(medium) height(5)) ///
ylabel(-0.15(0.05)0.15, labs(medium) grid format(%5.2f)) ///
legend( pos(1) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\work_c20_low.png", replace

eststo clear
foreach x in 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50{
areg lwage hrs_exp rural female i.edu i.cohort [aw=factor] if ps`x'==1 & work==1, absorb(geo) vce(cluster geo)
estimates store wage`x'
}
coefplot (wage35, label(p<=0.35)) (wage36, label(p<=0.36)) ///
(wage37, label(p<=0.37)) (wage38, label(p<=0.38)) (wage39, label(p<=0.39)) ///
(wage40, label(p<=0.40)) (wage41, label(p<=0.41)) (wage42, label(p<=0.42)) ///
(wage43, label(p<=0.43) mcolor(red) ciopts(recast(rcap) color(red))) ///
(wage44, label(p<=0.44)) (wage45, label(p<=0.45)) (wage46, label(p<=0.46)) ///
(wage47, label(p<=0.47)) (wage48, label(p<=0.48)) (wage49, label(p<=0.49)) ///
(wage50, label(p<=0.50)), vertical keep(hrs_exp) yline(0) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
legend( pos(1) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\wages_c20_low.png", replace

catplot ind_act cohort [fw=factor] if ps43==1, percent(cohort) ///
graphregion(fcolor(white)) scheme(s2mono) ///
var1opts(label(labsize(small))) ///
var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Percentage of individuals by labor market status", size(small)) ///
asyvars stack ///
legend(rows(1) stack size(small) ///
order(1 "Student" 2 "Formal worker" ///
3 "Informal worker" 4 "Inactive" 5 "Migrant") ///
symplacement(center))
*graph export "$doc\labor_census20_low.png", replace
*========================================================================*
/* Heterogeneous effects */
*========================================================================*

*========================================================================*
/* Jobs classifications */
*========================================================================*
use "$data\census20.dta", clear

merge m:m geo cohort using "$base\exposure_mun.dta"
drop if _merge!=3
drop _merge
replace actividades_c=. if actividades_c==9999

merge m:m geo using "$base\p_stud.dta"
drop _merge

drop if geo=="19041"

gen econ_act=.
replace econ_act=1 if actividades_c<=1199
replace econ_act=2 if (actividades_c>1199 & actividades_c<=2399) | ///
(actividades_c>4699 & actividades_c<=4930)
replace econ_act=3 if actividades_c>2399 & actividades_c<=3399
replace econ_act=4 if actividades_c>3399 & actividades_c<=4699
replace econ_act=5 if (actividades_c>5399 & actividades_c<=5622) | ///
(actividades_c>7223 & actividades_c<=8140) | (actividades_c>5199 & actividades_c<=5399)
replace econ_act=6 if (actividades_c>5622 & actividades_c<=6299) | ///
(actividades_c>8140 & actividades_c!=.)
replace econ_act=7 if (actividades_c>6299 & actividades_c<=7223) | ///
(actividades_c>4930 & actividades_c<=5199)

label define econ_act 1 "Agriculture" 2 "Construction" 3 "Manufactures" 4 "Commerce" ///
5 "Professionals" 6 "Government" 7 "Hospitality and Entertainment"
label values econ_act econ_act

gen ag_ea=1 if econ_act==1
replace ag_ea=0 if econ_act!=1 & econ_act!=.
gen cons_ea=1 if econ_act==2
replace cons_ea=0 if econ_act!=2 & econ_act!=.
gen manu_ea=1 if econ_act==3
replace manu_ea=0 if econ_act!=3 & econ_act!=.
gen comm_ea=1 if econ_act==4
replace comm_ea=0 if econ_act!=4 & econ_act!=.
gen pro_ea=1 if econ_act==5
replace pro_ea=0 if econ_act!=5 & econ_act!=.
gen gov_ea=1 if econ_act==6
replace gov_ea=0 if econ_act!=6 & econ_act!=.
gen hosp_ea=1 if econ_act==7
replace hosp_ea=0 if econ_act!=7 & econ_act!=.

gen occup=.
replace occup=1 if ocupacion_c>=610 & ocupacion_c<=699
replace occup=2 if ocupacion_c>=411 & ocupacion_c<=499
replace occup=3 if ocupacion_c>=510 & ocupacion_c<=541
replace occup=4 if ocupacion_c>=710 & ocupacion_c<=799
replace occup=5 if ocupacion_c>=911 & ocupacion_c<=989
replace occup=6 if ocupacion_c>=810 & ocupacion_c<=899
replace occup=7 if ocupacion_c>=111 & ocupacion_c<=399

label define occup 1 "Agriculture" 2 "Commerce" ///
3 "Services" 4 "Crafts" 5 "Manual work" ///
6 "Skilled job" 7 "Professional" 
label values occup occup

gen ag_o=1 if occup==1
replace ag_o=0 if occup!=1 & occup!=.
gen com_o=1 if occup==2
replace com_o=0 if occup!=2 & occup!=.
gen ser_o=1 if occup==3
replace ser_o=0 if occup!=3 & occup!=.
gen cft_o=1 if occup==4
replace cft_o=0 if occup!=4 & occup!=.
gen man_o=1 if occup==5
replace man_o=0 if occup!=5 & occup!=.
gen skil_o=1 if occup==6
replace skil_o=0 if occup!=6 & occup!=.
gen prof_o=1 if occup==7
replace prof_o=0 if occup!=7 & occup!=.
*======== Economic activities ========*
/* Full sample */
eststo clear
eststo: areg ag_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Low enrollment sample */
eststo clear
eststo: areg ag_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_low.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Men */
eststo clear
eststo: areg ag_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Women */
eststo clear
eststo: areg ag_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
*============ Occupations ============*
/* Full sample */
eststo clear
eststo: areg ag_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg man_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg skil_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Low enrollment sample */
eststo clear
eststo: areg ag_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg man_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg skil_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup_low.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Men */
eststo clear
eststo: areg ag_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg man_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg skil_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Women */
eststo clear
eststo: areg ag_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg man_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg skil_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
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
