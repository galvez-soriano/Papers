*========================================================================*
* The effect of the English program on student achievement and wages
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "S:\stata"
gl base= "F:\T43969_Oscar\Data"
gl doc= "F:\T43969_Oscar\Doc"
*========================================================================*
/* Working with IMSS labor data to study the effect on labor market outcomes
Note: Run after imss_db.do */
*========================================================================*
/************* Pre-trends analysis *************/
*========================================================================*
use "$base\dbase_18_21_final.dta", clear
foreach x in 1997 1998 1999 2000 2001 2002{
gen eng_`x'=0
label var eng_`x' "`x'"
replace eng_`x'=h_eng if cohort==`x'
}
replace eng_1999=0
destring state_s, replace
gen cohort_state=cohort*state_s
gen cohort_year=cohort*year

areg imss eng_* h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
coefplot, vertical keep(eng_*) yline(0) omitted baselevels ///
xline(3.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of working in formal sector", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) text(0.12 3 "NEPBE", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\formal_pta.png", replace

areg lwage eng_* h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1, absorb(cct) vce(cluster cct)
coefplot, vertical keep(eng_*) yline(0) omitted baselevels ///
xline(3.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change on wages (/100)", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) text(0.12 3 "NEPBE", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\wages_pta.png", replace

areg ldist eng_* h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
coefplot, vertical keep(eng_*) yline(0) omitted baselevels ///
xline(3.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change on distance (/100)", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) text(0.6 3 "NEPBE", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\dist_pta.png", replace

areg move_state eng_* h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
coefplot, vertical keep(eng_*) yline(0) omitted baselevels ///
xline(3.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of moving from home state", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) text(0.12 3 "NEPBE", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\moves_pta.png", replace

*========================================================================*
/* Regressions Economic Industry */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear
drop if wage==.
/* Creating industry variable: export industry, non-export, telecommunications
and other services */
gen industry=.
replace industry=0 if activity<=107 & (activity!=24 & activity!=106) | ///
activity==112 | activity==114 | activity==116 | activity==118 | activity==126 ///
| activity==127 | activity==131 | activity==132 | activity==144 | ///
activity==147 | activity==148 | activity==153 | activity==154 | activity==178
replace industry=1 if activity<=146 & industry==.
replace industry=2 if (activity>=222 & activity<=223) | (activity>=229 & activity<=231) ///
| activity==233 | activity==236 | activity==242 | (activity>=271 & activity<=276)
replace industry=3 if activity>=149 & industry==.

gen nexport_ind=industry==0
gen export_ind=industry==1
gen hosp_telecom_recrea=industry==2
gen other_ser=industry==3
/************* Full Sample *************/
eststo clear
eststo: areg nexport_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg export_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg hosp_telecom_recrea h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg other_ser h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_econ_sector.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace
/************* Low Enrollment Subsample *************/
eststo clear
eststo: areg nexport_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg export_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg hosp_telecom_recrea h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg other_ser h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_econ_sector_low.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace
/************* Low Enrollment Subsample (Men) *************/
eststo clear
eststo: areg nexport_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg export_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg hosp_telecom_recrea h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg other_ser h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_econ_sector_low_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace
/************* Low Enrollment Subsample (Women) *************/
eststo clear
eststo: areg nexport_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg export_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg hosp_telecom_recrea h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg other_ser h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_econ_sector_low_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace
/************* Low Enrollment Subsample (Gender) *************/
gen eng_female=h_eng*female
eststo clear
eststo: areg nexport_ind eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg export_ind eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg hosp_telecom_recrea eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg other_ser eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_econ_sector_low_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(eng_female) replace
*========================================================================*
/* Regressions Company Size */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear
gen microf=f_size==0
gen smallf=f_size==1
gen mediumf=f_size==2
gen bigf=f_size==3
/************* Full Sample *************/
eststo clear
eststo: areg microf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if wage!=., absorb(cct) vce(cluster cct)
eststo: areg smallf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if wage!=., absorb(cct) vce(cluster cct)
eststo: areg mediumf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if wage!=., absorb(cct) vce(cluster cct)
eststo: areg bigf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if wage!=., absorb(cct) vce(cluster cct)
esttab using "$doc\tab_com_size.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace
/************* Low Enrollment Subsample *************/
eststo clear
eststo: areg microf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & wage!=., absorb(cct) vce(cluster cct)
eststo: areg smallf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & wage!=., absorb(cct) vce(cluster cct)
eststo: areg mediumf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & wage!=., absorb(cct) vce(cluster cct)
eststo: areg bigf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & wage!=., absorb(cct) vce(cluster cct)
esttab using "$doc\tab_com_size_low.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace
/************* Low Enrollment Subsample (Men) *************/
eststo clear
eststo: areg microf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & wage!=. & female==0, absorb(cct) vce(cluster cct)
eststo: areg smallf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & wage!=. & female==0, absorb(cct) vce(cluster cct)
eststo: areg mediumf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & wage!=. & female==0, absorb(cct) vce(cluster cct)
eststo: areg bigf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & wage!=. & female==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_com_size_low_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace
/************* Low Enrollment Subsample (Women) *************/
eststo clear
eststo: areg microf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & wage!=. & female==1, absorb(cct) vce(cluster cct)
eststo: areg smallf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & wage!=. & female==1, absorb(cct) vce(cluster cct)
eststo: areg mediumf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & wage!=. & female==1, absorb(cct) vce(cluster cct)
eststo: areg bigf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & wage!=. & female==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_com_size_low_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace
/************* Low Enrollment Subsample (Gender) *************/
gen eng_female=h_eng*female
eststo clear
eststo: areg microf eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & wage!=., absorb(cct) vce(cluster cct)
eststo: areg smallf eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & wage!=., absorb(cct) vce(cluster cct)
eststo: areg mediumf eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & wage!=., absorb(cct) vce(cluster cct)
eststo: areg bigf eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.state i.cohort i.year if ps38==1 & wage!=., absorb(cct) vce(cluster cct)
esttab using "$doc\tab_com_size_low_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(eng_female) replace
*========================================================================*
/* The effect on type of jobs */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear

gen econ_act=.
replace econ_act=1 if activity<=8 | activity==261
replace econ_act=2 if (activity>=9 & activity<=17) | activity==234 | ///
(activity>=147 & activity<=154)
replace econ_act=3 if activity>=18 & activity<=146
replace econ_act=4 if activity>=153 & activity<=216
replace econ_act=5 if (activity>=217 & activity<=228)
replace econ_act=6 if activity==233 | activity==236 | activity==262 | activity==270
replace econ_act=7 if activity==213 | (activity>=226 & activity<=227) ///
| (activity>=229 & activity<=232) | (activity>=237 & activity<=242)
replace econ_act=8 if (activity>=243 & activity<=251)
replace econ_act=9 if (activity>=273 & activity!=.)
replace econ_act=10 if (activity>=235 & econ_act==. & activity!=.)

/* Construction includes mining, electricity and water.
Hospitaly includes telecommunications and entretainment */
label define econ_act 1 "Agriculture" 2 "Construction" 3 "Manufactures" 4 ///
"Commerce" 5  "Transportation" 6 "Professionals" 7 "Telecommunications/Finance" ///
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
eststo: areg ag_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg cons_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg manu_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg comm_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg transp_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg pro_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg telecom_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg hosp_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg gov_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg other_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_ea.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(h_eng) replace
/* Low-enrollment sample */
eststo clear
eststo: areg ag_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg cons_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg manu_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg comm_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg transp_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg pro_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg telecom_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg hosp_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg gov_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg other_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_ea_low.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(h_eng) replace
/* Men */
eststo clear
eststo: areg ag_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==0 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg cons_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==0 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg manu_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==0 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg comm_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==0 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg transp_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==0 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg pro_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==0 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg telecom_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==0 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg hosp_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==0 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg gov_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==0 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg other_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==0 & ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_ea_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(h_eng) replace
/* Women */
eststo clear
eststo: areg ag_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==1 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg cons_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==1 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg manu_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==1 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg comm_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==1 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg transp_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==1 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg pro_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==1 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg telecom_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==1 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg hosp_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==1 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg gov_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==1 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg other_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==1 & ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_ea_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(h_eng) replace
/************* Low Enrollment Sample (Gender) *************/
gen eng_female=h_eng*female
eststo clear
eststo: areg ag_ea eng_female h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg cons_ea eng_female h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg manu_ea eng_female h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg comm_ea eng_female h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg transp_ea eng_female h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg pro_ea eng_female h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg telecom_ea eng_female h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg hosp_ea eng_female h_eng rural female language6 math6 age age2 i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg gov_ea eng_female h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg other_ea eng_female h_eng rural female language6 math6 age age2 i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_ea_low_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(eng_female) replace
*========================================================================*
/* Exposure at county, locality and school level */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear

merge m:m geo_mun_s cohort using "$base\exposure_mun.dta"
drop if _merge!=3
drop _merge

merge m:m id_geo_s cohort using "$base\exposure_loc.dta"
drop if _merge!=3
drop _merge

eststo clear
eststo: areg imss hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year, absorb(cct) vce(cluster geo_mun_s)
eststo: areg imss hrs_exp_loc rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year, absorb(cct) vce(cluster id_geo_s)
eststo: areg imss h_eng rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year, absorb(cct) vce(cluster cct)
eststo: areg lwage hrs_exp rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year, absorb(cct) vce(cluster geo_mun_s)
eststo: areg lwage hrs_exp_loc rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year, absorb(cct) vce(cluster id_geo_s)
eststo: areg lwage h_eng rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_exp.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) rename(hrs_exp h_eng hrs_exp_loc h_eng) keep(h_eng) replace

eststo clear
eststo: areg imss hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster geo_mun_s)
eststo: areg imss hrs_exp_loc rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster id_geo_s)
eststo: areg imss h_eng rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg lwage hrs_exp rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster geo_mun_s)
eststo: areg lwage hrs_exp_loc rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster id_geo_s)
eststo: areg lwage h_eng rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_exp_low.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) rename(hrs_exp h_eng hrs_exp_loc h_eng) keep(h_eng) replace

eststo clear
eststo: areg imss hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==0, absorb(cct) vce(cluster geo_mun_s)
eststo: areg imss hrs_exp_loc rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==0, absorb(cct) vce(cluster id_geo_s)
eststo: areg imss h_eng rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg lwage hrs_exp rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==0, absorb(cct) vce(cluster geo_mun_s)
eststo: areg lwage hrs_exp_loc rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==0, absorb(cct) vce(cluster id_geo_s)
eststo: areg lwage h_eng rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_exp_low_men.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) rename(hrs_exp h_eng hrs_exp_loc h_eng) keep(h_eng) replace

eststo clear
eststo: areg imss hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==1, absorb(cct) vce(cluster geo_mun_s)
eststo: areg imss hrs_exp_loc rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==1, absorb(cct) vce(cluster id_geo_s)
eststo: areg imss h_eng rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg lwage hrs_exp rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==1, absorb(cct) vce(cluster geo_mun_s)
eststo: areg lwage hrs_exp_loc rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==1, absorb(cct) vce(cluster id_geo_s)
eststo: areg lwage h_eng rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_exp_low_women.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) rename(hrs_exp h_eng hrs_exp_loc h_eng) keep(h_eng) replace

gen eng_female_c=hrs_exp*female
gen eng_female_l=hrs_exp_loc*female
gen eng_female=h_eng*female
eststo clear
eststo: areg imss eng_female_c hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster geo_mun_s)
eststo: areg imss eng_female_l hrs_exp_loc rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster id_geo_s)
eststo: areg imss eng_female h_eng rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg lwage eng_female_c hrs_exp rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster geo_mun_s)
eststo: areg lwage eng_female_l hrs_exp_loc rural female age age2 perma n_jobs i.state  i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster id_geo_s)
eststo: areg lwage eng_female h_eng rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_exp_low_gender.tex", ar2 cells(b(star fmt(%9.4f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) rename(eng_female_c eng_female eng_female_l eng_female) keep(eng_female) replace
*========================================================================*
/* Dealing with selection problem / Graphs for Appendix */
*========================================================================*
/* Subsample: low enrollment */
use "$base\dbase_18_21_final.dta", clear
label var h_eng "Proportion of individuals enrolled in school"
graph set window fontface "Times New Roman"

eststo clear
foreach x in 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40{
areg lwage h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps`x'==1, absorb(cct) vce(cluster cct)
estimates store wage`x'
}
coefplot (wage25, label(p<=0.25)) (wage26, label(p<=0.26)) (wage27, ///
label(p<=0.27)) (wage28, label(p<=0.28)) (wage29, label(p<=0.29)) ///
(wage30, label(p<=0.30)) (wage31, label(p<=0.31)) (wage32, label(p<=0.32)) ///
(wage33, label(p<=0.33)) (wage34, label(p<=0.34)) (wage35, label(p<=0.35)) ///
(wage36, label(p<=0.36)) (wage37, label(p<=0.37)) (wage38, label(p<=0.38) ///
mcolor(red) ciopts(recast(rcap) color(red))) (wage39, label(p<=0.39)) ///
(wage40, label(p<=0.40)), vertical keep(h_eng) yline(0) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-0.15(0.05)0.15, labs(medium) format(%5.2f)) ///
legend(pos(1) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\wages_c20_low.png", replace
