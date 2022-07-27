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
/* Regressions Economic Industry */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear
drop if wage==.
/* Creating industry variable: export industry, non-export, hospitality
and other services */
gen industry=.
replace industry=1 if activity==24 | activity==45 | activity==46 ///
| activity==54 | activity==55 | activity==97 | activity==102 | activity==106 ///
| (activity>=127 & activity<=130) | (activity>=133 & activity<=136)
replace industry=2 if activity<=146 & industry==.

gen nexport_ind=industry==1
gen export_ind=industry==2
/************* Full Sample *************/
eststo clear
eststo: areg nexport_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg export_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_econ_sector.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Subsample *************/
eststo clear
eststo: areg nexport_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg export_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_econ_sector_low.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Subsample (Men) *************/
eststo clear
eststo: areg nexport_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg export_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_econ_sector_low_men.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Subsample (Women) *************/
eststo clear
eststo: areg nexport_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg export_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1 & female==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_econ_sector_low_women.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/************* Low Enrollment Subsample (Gender) *************/
gen eng_female=h_eng*female
eststo clear
eststo: areg nexport_ind eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg export_ind eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural perma n_jobs i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_econ_sector_low_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(eng_female) replace
