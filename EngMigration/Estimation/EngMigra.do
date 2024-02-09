*========================================================================*
* English program and earnings
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Doc"
*========================================================================*
/*
use "$data/Papers/main/EngMigration/Data/labor_census20_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 {
    append using "$data/Papers/main/EngMigration/Data/labor_census20_`x'.dta"
}
save "$base\labor_census20.dta", replace 
*/
use "$base\labor_census20.dta", clear

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)

eststo clear
eststo: areg student had_policy rural female i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg formal_s had_policy rural female i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg informal_s had_policy rural female i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg inactive had_policy rural female i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg migrant had_policy rural female i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg work had_policy rural female i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy rural female i.edu i.cohort [aw=factor] if work==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab1_census.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
title(Census estimations) keep(had_policy) replace


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
