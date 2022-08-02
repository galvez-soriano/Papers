*========================================================================*
* The effect of the English program on student achievement and wages
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Labor\Banxico"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New"
gl doc= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Doc"
*========================================================================*
/* Working with IMSS labor data to study the effect on labor market outcomes
Note: Run after imss_db.do */
*========================================================================*
/* Regressions Labor Market */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear
/************* Full Sample *************/
eststo clear
* Formal sector
eststo: areg imss h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year, absorb(cct) vce(cluster cct)
* Wages
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(cct) vce(cluster cct)
* Distance
eststo: areg ldist h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=., absorb(cct) vce(cluster cct)
* Move state
eststo: areg move_state h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=., absorb(cct) vce(cluster cct)

esttab using "$doc\tab_labor.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Sample *************/
eststo clear
eststo: areg imss h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg ldist h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg move_state h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1, absorb(cct) vce(cluster cct)

esttab using "$doc\tab_labor_low.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Subsample (Men) *************/
eststo clear
eststo: areg imss h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg ldist h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg move_state h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & female==0, absorb(cct) vce(cluster cct)

esttab using "$doc\tab_labor_low_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Subsample (Women) *************/
eststo clear
eststo: areg imss h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg ldist h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg move_state h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & female==1, absorb(cct) vce(cluster cct)

esttab using "$doc\tab_labor_low_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Subsample (Gender) *************/
gen eng_female=h_eng*female
eststo clear
eststo: areg imss eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg lwage eng_female h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg ldist eng_female h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg move_state eng_female h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1, absorb(cct) vce(cluster cct)

esttab using "$doc\tab_labor_low_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(eng_female) replace 
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
/*xtile ability=math6, nq(4)
gen quart1=ability==1
gen quart2=ability==2
gen quart3=ability==3
gen quart4=ability==4
gen q1_eng=quart1*h_eng3
gen q2_eng=quart2*h_eng3
gen q3_eng=quart3*h_eng3
gen q4_eng=quart4*h_eng3
*/
drop if wage==.

gen industry=.
replace industry=0 if naics>=1110 & naics<=2399
replace industry=1 if naics>=3110 & naics<=3399
replace industry=2 if naics>=4310 & naics<=9399

gen h_manu=industry==1 & eng_dist>=3
gen l_manu=industry==1 & eng_dist<3
gen h_svc=industry==2 & eng_dist>=3
gen l_svc=industry==2 & eng_dist<3

gen h_manu_e=industry==1 & eng_dist_edu>=3
gen l_manu_e=industry==1 & eng_dist_edu<3
gen h_svc_e=industry==2 & eng_dist_edu>=3
gen l_svc_e=industry==2 & eng_dist_edu<3
/************* Full Sample *************/
eststo clear
eststo: areg p_eng h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year, absorb(cct) vce(cluster cct)


esttab using "$doc\tab_econ_sector.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Subsample *************/
eststo clear
eststo: areg h_manu h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg l_manu h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg h_svc h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg l_svc h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)

eststo: areg h_manu_e h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg l_manu_e h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg h_svc_e h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg l_svc_e h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)

esttab using "$doc\tab_econ_sector_low.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Subsample (Men) *************/
eststo clear
eststo: areg h_manu h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg l_manu h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg h_svc h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg l_svc h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)

eststo: areg h_manu_e h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg l_manu_e h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg h_svc_e h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg l_svc_e h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_econ_sector_low_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Subsample (Women) *************/
eststo clear
eststo: areg h_manu h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg l_manu h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg h_svc h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg l_svc h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)

eststo: areg h_manu_e h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg l_manu_e h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg h_svc_e h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg l_svc_e h_eng3 language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_econ_sector_low_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Subsample (Gender) *************/
gen eng_female=h_eng*female
eststo clear
eststo: areg agcons_ind eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg nexport_ind eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg export_ind eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg hosp_telecom_recrea eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg other_ser eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
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
esttab using "$doc\tab_com_size.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
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
esttab using "$doc\tab_com_size_low.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
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
esttab using "$doc\tab_com_size_low_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
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
esttab using "$doc\tab_com_size_low_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
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
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(eng_female) stats(N, fmt(%9.0fc)) replace
*========================================================================*
/* Regressions Student Achievement */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear
destring state_s, replace
gen cohort_state=cohort*state_s
/************* Full Sample *************/
eststo clear
eststo: areg language6 h_eng language5 female n_stud t_colle t_mast rural if wage!=., absorb(state_s) vce(cluster cct)
eststo: areg language6 h_eng language5 female n_stud t_colle t_mast rural i.cohort if wage!=., absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng math5 female n_stud t_colle t_mast rural if wage!=., absorb(state_s) vce(cluster cct)
eststo: areg math6 h_eng math5 female n_stud t_colle t_mast rural i.cohort if wage!=., absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud.tex", cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Sample *************/
eststo clear
eststo: areg language6 h_eng language5 female n_stud t_colle t_mast rural if wage!=. & ps38==1, absorb(state_s) vce(cluster cct)
eststo: areg language6 h_eng language5 female n_stud t_colle t_mast rural i.cohort if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng math5 female n_stud t_colle t_mast rural if wage!=. & ps38==1, absorb(state_s) vce(cluster cct)
eststo: areg math6 h_eng math5 female n_stud t_colle t_mast rural i.cohort if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_low.tex", cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Sample (Men) *************/
eststo clear
eststo: areg language6 h_eng language5 female n_stud t_colle t_mast rural if wage!=. & ps38==1 & female==0, absorb(state_s) vce(cluster cct)
eststo: areg language6 h_eng language5 female n_stud t_colle t_mast rural i.cohort if wage!=. & ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng math5 female n_stud t_colle t_mast rural if wage!=. & ps38==1 & female==0, absorb(state_s) vce(cluster cct)
eststo: areg math6 h_eng math5 female n_stud t_colle t_mast rural i.cohort if wage!=. & ps38==1 & female==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_men.tex", cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Sample (Women) *************/
eststo clear
eststo: areg language6 h_eng language5 female n_stud t_colle t_mast rural if wage!=. & ps38==1 & female==1, absorb(state_s) vce(cluster cct)
eststo: areg language6 h_eng language5 female n_stud t_colle t_mast rural i.cohort if wage!=. & ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng math5 female n_stud t_colle t_mast rural if wage!=. & ps38==1 & female==1, absorb(state_s) vce(cluster cct)
eststo: areg math6 h_eng math5 female n_stud t_colle t_mast rural i.cohort if wage!=. & ps38==1 & female==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_women.tex", cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Sample (Gender) *************/
gen eng_female=h_eng*female
eststo clear
eststo: areg language6 eng_female h_eng language5 female n_stud t_colle t_mast rural if wage!=. & ps38==1, absorb(state_s) vce(cluster cct)
eststo: areg language6 eng_female h_eng language5 female n_stud t_colle t_mast rural i.cohort if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg math6 eng_female h_eng math5 female n_stud t_colle t_mast rural if wage!=. & ps38==1, absorb(state_s) vce(cluster cct)
eststo: areg math6 eng_female h_eng math5 female n_stud t_colle t_mast rural i.cohort if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_low_gender.tex", ar2 cells(b(star fmt(%9.4f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Student achievement) keep(eng_female) replace
*========================================================================* =================================================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
/* Geographical Heterogeneity */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear
/* By Rural-Urban */
gen urban=rural==0
eststo clear
eststo: areg imss h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1 & rural==0, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1 & rural==0, absorb(cct) vce(cluster cct)
eststo: areg ldist h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & rural==0, absorb(cct) vce(cluster cct)
eststo: areg move_state h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & rural==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_low_urban.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg imss h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1 & rural==1, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1 & rural==1, absorb(cct) vce(cluster cct)
eststo: areg ldist h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & rural==1, absorb(cct) vce(cluster cct)
eststo: areg move_state h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & rural==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_low_rural.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen eng_urban=h_eng*urban
eststo clear
eststo: areg imss eng_urban h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg lwage eng_urban h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg ldist eng_urban h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg move_state eng_urban h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_low_context.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(eng_urban) replace
/* By Mexican Regions
Using critera from Mexican government
Northern states: Aguascalientes, Baja California, Baja California Sur, 
Chihuahua, Coahuila, Colima, Durango, Jalisco, Michoacán, Nayarit, Nuevo León, 
San Luis Potosí, Sinaloa, Sonora, Tamaulipas and Zacatecas 
Central states: Guanajuato, Hidalgo, Mexico City, Morelos, Puebla, Querétaro, 
State of Mexico and Tlaxcala
Southern states: Campeche, Chiapas, Guerrero, Oaxaca, Quintana Roo, Tabasco, 
Veracruz and Yucatán
*/
gen region=.
replace region=0 if state_s==04 | state_s==07 | state_s==12 | ///
state_s==20 | state_s==23 | state_s==27 | state_s==30 | state_s==31
replace region=1 if state_s==11 | state_s==13 | state_s==09 | ///
state_s==17 | state_s==21 | state_s==22 | state_s==15 | state_s==29
replace region=2 if region==.
gen north_r=region==2
gen central_r=region==1
gen south_r=region==0

eststo clear
eststo: areg imss h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1 & region==0, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1 & region==0, absorb(cct) vce(cluster cct)
eststo: areg ldist h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & region==0, absorb(cct) vce(cluster cct)
eststo: areg move_state h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & region==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_low_south.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg imss h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1 & region==1, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1 & region==1, absorb(cct) vce(cluster cct)
eststo: areg ldist h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & region==1, absorb(cct) vce(cluster cct)
eststo: areg move_state h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & region==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_low_central.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg imss h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1 & region==2, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1 & region==2, absorb(cct) vce(cluster cct)
eststo: areg ldist h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & region==2, absorb(cct) vce(cluster cct)
eststo: areg move_state h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & region==2, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_low_north.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen eng_north=h_eng*north_r
gen eng_central=h_eng*central_r
gen eng_south=h_eng*south_r
/* test eng_north eng_central gives the difference between northern and central states
test eng_north eng_south gives the difference between northern and southern states */
eststo clear
eststo: areg imss eng_north eng_central h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year i.region if ps38==1, absorb(cct) vce(cluster cct)
test eng_north eng_central
eststo: areg lwage eng_north eng_central h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.region i.state if ps38==1, absorb(cct) vce(cluster cct)
test eng_north eng_central
eststo: areg ldist eng_north eng_central h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state i.region if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
test eng_north eng_central
eststo: areg move_state eng_north eng_central h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state i.region if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
test eng_north eng_central
esttab using "$doc\tab_labor_low_region.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(eng_north eng_central) replace 
*========================================================================*
/* Robustness Checks */
*========================================================================*
/********* Noisy exposure variable? Use English teachers instead *********/
use "$base\dbase_18_21_final_alter.dta", clear

eststo clear
eststo: areg imss t_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(cct) vce(cluster cct)
eststo: areg ldist t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=., absorb(cct) vce(cluster cct)
eststo: areg move_state t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=., absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_teach.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(t_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg imss t_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg ldist t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg move_state t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_low_teach.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(t_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg imss t_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg ldist t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg move_state t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & female==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_low_men_teach.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(t_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg imss t_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg ldist t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg move_state t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & female==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_low_women_teach.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(t_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen eng_female=t_eng*female
eststo clear
eststo: areg imss eng_female t_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg lwage eng_female t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg ldist eng_female t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg move_state eng_female t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_low_gender_teach.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(eng_female) replace

/********* Are my results sensible to different low enrollment rates? *********/
use "$base\dbase_18_21_final_alter.dta", clear
label var h_eng "Proportion of individuals enrolled in school"
graph set window fontface "Times New Roman"

eststo clear
foreach x in 36 37 38 39{
areg imss h_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if ps`x'==1, absorb(cct) vce(cluster cct)
estimates store formal`x'
}
coefplot (formal36, label(p<=0.36)) (formal37, label(p<=0.37)) (formal38, ///
label(p<=0.38) mcolor(red) ciopts(recast(rcap) color(red))) (formal39, ///
label(p<=0.39)), vertical keep(h_eng) yline(0) ///
ytitle("Probability of working in formal sector", size(medium) height(5)) ///
ylabel(-0.05(0.025)0.05, labs(medium) grid format(%5.2f)) ///
legend( pos(1) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\rtest_formal.png", replace

eststo clear
foreach x in 36 37 38 39{
areg lwage h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps`x'==1, absorb(cct) vce(cluster cct)
estimates store wage`x'
}
coefplot (wage36, label(p<=0.36)) (wage37, label(p<=0.37)) ///
(wage38, label(p<=0.38) mcolor(red) ciopts(recast(rcap) color(red))) ///
(wage39, label(p<=0.39)), vertical keep(h_eng) yline(0) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-0.05(0.025)0.05, labs(medium) format(%5.2f)) ///
legend(pos(1) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\rtest_wages.png", replace

eststo clear
foreach x in 36 37 38 39{
areg ldist h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps`x'==1, absorb(cct) vce(cluster cct)
estimates store dist`x'
}
coefplot (dist36, label(p<=0.36)) (dist37, label(p<=0.37)) ///
(dist38, label(p<=0.38) mcolor(red) ciopts(recast(rcap) color(red))) ///
(dist39, label(p<=0.39)), vertical keep(h_eng) yline(0) ///
ytitle("Percentage change of distance (/100)", size(medium) height(5)) ///
ylabel(-0.05(0.025)0.05, labs(medium) format(%5.2f)) ///
legend(pos(1) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\rtest_dist.png", replace

eststo clear
foreach x in 36 37 38 39{
areg move_state h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps`x'==1, absorb(cct) vce(cluster cct)
estimates store moves`x'
}
coefplot (moves36, label(p<=0.36)) (moves37, label(p<=0.37)) ///
(moves38, label(p<=0.38) mcolor(red) ciopts(recast(rcap) color(red))) ///
(moves39, label(p<=0.39)), vertical keep(h_eng) yline(0) ///
ytitle("Probability of moving from home state", size(medium) height(5)) ///
ylabel(-0.05(0.025)0.05, labs(medium) format(%5.2f)) ///
legend(pos(1) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\rtest_moves.png", replace

/********* Did the NEPBE affect other school inputs? *********/
use "$base\dbase_18_21_final_alter.dta", clear

eststo clear
eststo: areg n_stud h_eng language6 math6 female t_colle t_mast rural i.cohort if wage!=., absorb(cct) vce(cluster cct)
eststo: areg t_colle h_eng language6 math6 female n_stud t_mast rural i.cohort if wage!=., absorb(cct) vce(cluster cct)
eststo: areg t_mast h_eng language6 math6 female n_stud t_colle rural i.cohort if wage!=., absorb(cct) vce(cluster cct)
eststo: areg y h_eng language6 math6 female n_stud t_colle t_mast rural i.cohort if wage!=., absorb(cct) vce(cluster cct)
esttab using "$doc\tab_sinput.tex", cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg n_stud h_eng language6 math6 female t_colle t_mast rural i.cohort if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg t_colle h_eng language6 math6 female n_stud t_mast rural i.cohort if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg t_mast h_eng language6 math6 female n_stud t_colle rural i.cohort if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg y h_eng language6 math6 female n_stud t_colle t_mast rural i.cohort if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_sinput_low.tex", cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg n_stud h_eng language6 math6 female t_colle t_mast rural i.cohort if wage!=. & ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg t_colle h_eng language6 math6 female n_stud t_mast rural i.cohort if wage!=. & ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg t_mast h_eng language6 math6 female n_stud t_colle rural i.cohort if wage!=. & ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg y h_eng language6 math6 female n_stud t_colle t_mast rural i.cohort if wage!=. & ps38==1 & female==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_sinput_men.tex", cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg n_stud h_eng language6 math6 female t_colle t_mast rural i.cohort if wage!=. & ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg t_colle h_eng language6 math6 female n_stud t_mast rural i.cohort if wage!=. & ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg t_mast h_eng language6 math6 female n_stud t_colle rural i.cohort if wage!=. & ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg y h_eng language6 math6 female n_stud t_colle t_mast rural i.cohort if wage!=. & ps38==1 & female==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_sinput_women.tex", cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

gen eng_female=h_eng*female
eststo clear
eststo: areg n_stud eng_female h_eng language6 math6 female t_colle t_mast rural i.cohort if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg t_colle eng_female h_eng language6 math6 female n_stud t_mast rural i.cohort if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg t_mast eng_female h_eng language6 math6 female n_stud t_colle rural i.cohort if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg y h_eng eng_female language6 math6 female n_stud t_colle t_mast rural i.cohort if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_sinput_gender.tex", ar2 cells(b(star fmt(%9.4f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Student achievement) keep(eng_female) replace
/********* Is good the solution to the second selection problem? *********/
/* We could also use a sample of low ability individuals if we are willing 
to beleive that low ability individuals are less likely to change their formal
labor participation given exposure to English instrution. The intuition is that 
they will not change their motivation for continue studying. In other words, 
they would had drop out with or without exposure to English instruction */
use "$base\dbase_18_21_final_alter.dta", clear

/********* What about a Lee bound? *********/
use "$base\dbase_18_21_final_alter.dta", clear
ssc install leebounds

/******************************* Apendix ********************************/

*========================================================================*
/* State, county, locality and school FE */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear
* Hours of English instruction
eststo clear
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(state_s) vce(cluster cct)
estadd local  StateFE  "YES"
estadd local  CountyFE  "NO"
estadd local  LocalityFE  "NO"
estadd local  SchoolFE  "NO"
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(geo_mun_s) vce(cluster cct)
estadd local  StateFE  "NO"
estadd local  CountyFE  "YES"
estadd local  LocalityFE  "NO"
estadd local  SchoolFE  "NO"
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(id_geo_s) vce(cluster cct)
estadd local  StateFE  "NO"
estadd local  CountyFE  "NO"
estadd local  LocalityFE  "YES"
estadd local  SchoolFE  "NO"
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(cct) vce(cluster cct)
estadd local  StateFE  "NO"
estadd local  CountyFE  "NO"
estadd local  LocalityFE  "NO"
estadd local  SchoolFE  "YES"
esttab using "$doc\tab_select_hrs.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace ///
scalars( "StateFE State FE" "CountyFE County FE" "LocalityFE Locality FE" "SchoolFE School FE")

eststo clear
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1, absorb(state_s) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1, absorb(geo_mun_s) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1, absorb(id_geo_s) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_select_hrs_low.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

* Number of English teachers
eststo clear
eststo: areg lwage t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(state_s) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(geo_mun_s) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(id_geo_s) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_select_teach.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(t_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg lwage t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1, absorb(state_s) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1, absorb(geo_mun_s) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1, absorb(id_geo_s) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_select_teach_low.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(t_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* The effect on type of jobs */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear

gen econ_act=.
replace econ_act=1 if activity<=8 
replace econ_act=2 if (activity>=9 & activity<=17) | (activity>=147 ///
& activity<=154)
replace econ_act=3 if activity>=18 & activity<=146
replace econ_act=4 if activity>=155 & activity<=276


/* Construction includes mining and utilities.
Hospitaly includes entretainment */
label define econ_act 1 "Agriculture" 2 "Construction" 3 "Manufactures" 4 ///
"Services"
label values econ_act econ_act

gen ag_ea=econ_act==1
gen cons_ea=econ_act==2
gen manu_ea=econ_act==3
gen serv_ea=econ_act==4

*======== Economic activities ========*
/* Full sample */
eststo clear
eststo: areg ag_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg cons_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg manu_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg serv_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_ea.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Low-enrollment sample */
eststo clear
eststo: areg ag_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg cons_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg manu_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg serv_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_ea_low.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Men */
eststo clear
eststo: areg ag_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==0 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg cons_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==0 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg manu_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==0 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg serv_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==0 & ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_ea_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* Women */
eststo clear
eststo: areg ag_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==1 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg cons_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==1 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg manu_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==1 & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg serv_ea h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if female==1 & ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_ea_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Sample (Gender) *************/
gen eng_female=h_eng*female
eststo clear
eststo: areg ag_ea eng_female h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg cons_ea eng_female h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg manu_ea eng_female h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg serv_ea eng_female h_eng rural female language6 math6 age age2 perma n_jobs i.state i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
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
esttab using "$doc\tab_exp.tex", cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) rename(hrs_exp h_eng hrs_exp_loc h_eng) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg imss hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster geo_mun_s)
eststo: areg imss hrs_exp_loc rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster id_geo_s)
eststo: areg imss h_eng rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg lwage hrs_exp rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster geo_mun_s)
eststo: areg lwage hrs_exp_loc rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster id_geo_s)
eststo: areg lwage h_eng rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_exp_low.tex", cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) rename(hrs_exp h_eng hrs_exp_loc h_eng) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg imss hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==0, absorb(cct) vce(cluster geo_mun_s)
eststo: areg imss hrs_exp_loc rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==0, absorb(cct) vce(cluster id_geo_s)
eststo: areg imss h_eng rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg lwage hrs_exp rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==0, absorb(cct) vce(cluster geo_mun_s)
eststo: areg lwage hrs_exp_loc rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==0, absorb(cct) vce(cluster id_geo_s)
eststo: areg lwage h_eng rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_exp_low_men.tex", cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) rename(hrs_exp h_eng hrs_exp_loc h_eng) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg imss hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==1, absorb(cct) vce(cluster geo_mun_s)
eststo: areg imss hrs_exp_loc rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==1, absorb(cct) vce(cluster id_geo_s)
eststo: areg imss h_eng rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg lwage hrs_exp rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==1, absorb(cct) vce(cluster geo_mun_s)
eststo: areg lwage hrs_exp_loc rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==1, absorb(cct) vce(cluster id_geo_s)
eststo: areg lwage h_eng rural female age age2 perma n_jobs i.state i.cohort n_stud language6 math6 t_colle t_mast i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_exp_low_women.tex", cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) rename(hrs_exp h_eng hrs_exp_loc h_eng) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

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
/* Regressions Labor Market by Abilities */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear
xtile ability=math6, nq(4)
gen quart1=ability==1
gen quart2=ability==2
gen quart3=ability==3
gen quart4=ability==4
gen q1_eng=quart1*h_eng
gen q2_eng=quart2*h_eng
gen q3_eng=quart3*h_eng
gen q4_eng=quart4*h_eng
/************* Full Sample *************/
eststo clear
eststo: areg imss h_eng q2_eng q3_eng q4_eng quart* language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng q2_eng q3_eng q4_eng quart* language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(cct) vce(cluster cct)
eststo: areg ldist h_eng q2_eng q3_eng q4_eng quart* language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=., absorb(cct) vce(cluster cct)
eststo: areg move_state h_eng q2_eng q3_eng q4_eng quart* language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=., absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_ability.tex", cells(b(star fmt(%9.3fc)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng q2_eng q3_eng q4_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Sample *************/
eststo clear
eststo: areg imss h_eng q2_eng q3_eng q4_eng quart* language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng q2_eng q3_eng q4_eng quart* language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg ldist h_eng q2_eng q3_eng q4_eng quart* language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg move_state q2_eng q3_eng q4_eng quart* h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_abil_low.tex", cells(b(star fmt(%9.3fc)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng q2_eng q3_eng q4_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Subsample (Men) *************/
eststo clear
eststo: areg imss h_eng q2_eng q3_eng q4_eng quart* language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng q2_eng q3_eng q4_eng quart* language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg ldist h_eng q2_eng q3_eng q4_eng quart* language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg move_state h_eng q2_eng q3_eng q4_eng quart* language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & female==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_abil_low_men.tex", cells(b(star fmt(%9.3fc)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng q2_eng q3_eng q4_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Subsample (Women) *************/
eststo clear
eststo: areg imss h_eng q2_eng q3_eng q4_eng quart* language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng q2_eng q3_eng q4_eng quart* language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg ldist h_eng q2_eng q3_eng q4_eng quart* language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg move_state h_eng q2_eng q3_eng q4_eng quart* language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & female==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_abil_low_women.tex", cells(b(star fmt(%9.3fc)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng q2_eng q3_eng q4_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

label var math6 "Math standardized test score in 6th grade"
twoway (histogram math6 if ps38==1, color(gs12)) ///
(histogram math6, fcolor(none) lcolor(black)), graphregion(fcolor(white)) ///
legend(order(1 "Low-enrollment" 2 "Full sample" ) pos(1) ring(0) col(1)) ///
xline(-.735 0 .7585, lstyle(grid) lpattern(dash) lcolor(red)) 
graph export "$doc\histo_abil.png", replace
*========================================================================*
/* Dealing with selection problem / Graphs for Appendix */
*========================================================================*
/* Subsample: low enrollment */
use "$base\dbase_18_21_final.dta", clear
label var h_eng "Proportion of individuals enrolled in school"
graph set window fontface "Times New Roman"

************************************************************************
eststo clear
foreach x in 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40{
areg imss h_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if ps`x'==1, absorb(cct) vce(cluster cct)
estimates store formal`x'
}
coefplot (formal25, label(p<=0.25)) (formal26, label(p<=0.26)) (formal27, ///
label(p<=0.27)) (formal28, label(p<=0.28)) (formal29, label(p<=0.29)) ///
(formal30, label(p<=0.30)) (formal31, label(p<=0.31)) (formal32, ///
label(p<=0.32)) (formal33, label(p<=0.33)) (formal34, label(p<=0.34)) ///
(formal35, label(p<=0.35)) (formal36, label(p<=0.36)) (formal37, ///
label(p<=0.37)) (formal38, label(p<=0.38) mcolor(red) ///
ciopts(recast(rcap) color(red))) (formal39, label(p<=0.39)) ///
(formal40, label(p<=0.40)), vertical keep(h_eng) yline(0) ///
ytitle("Probability of working in formal sector", size(medium) height(5)) ///
ylabel(-0.15(0.05)0.15, labs(medium) grid format(%5.2f)) ///
legend( pos(1) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\formal_c20_low.png", replace

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
