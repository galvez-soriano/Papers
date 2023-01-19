*========================================================================*
* Impact of English Instruction on Labor Market Outcomes: The case of Mexico
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "S:\stata"
gl base= "C:\Users\iscot\OneDrive\Documents\Papers\EngInst\Data"
gl doc= "C:\Users\iscot\OneDrive\Documents\Papers\EngInst"
*========================================================================*
/* Descriptive statistics */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear

gen econ_act=.
replace econ_act=1 if activity<=8 | activity==261
replace econ_act=2 if (activity>=9 & activity<=17) | (activity>=147 ///
& activity<=154)
replace econ_act=3 if activity>=18 & activity<=146 & econ_act==.
replace econ_act=4 if activity>=155 & activity<=276 & econ_act==.

/* Construction includes mining and utilities. */
label define econ_act 1 "Agriculture" 2 "Construction" 3 "Manufactures" 4 ///
"Services"
label values econ_act econ_act

gen ag_ea=econ_act==1
gen cons_ea=econ_act==2
gen manu_ea=econ_act==3
gen serv_ea=econ_act==4

eststo clear
estpost tabstat lwage ldist move_state ag_ea cons_ea manu_ea serv_ea ///
female age h_eng language6 math6 n_stud t_colle t_mast rural perma n_jobs ///
n_perma if wage!=., c(stat) stat(mean sd min max) 
esttab using "$doc\sum_stats.tex", ///
cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max") ///
nonumber nomtitle nonote noobs collabels("Mean" "SD" "Min" "Max") label replace

eststo clear
estpost tabstat lwage ldist move_state ag_ea cons_ea manu_ea serv_ea ///
female age h_eng language6 math6 n_stud t_colle t_mast rural perma n_jobs ///
n_perma if wage!=. & ps38==1, c(stat) stat(mean sd min max) 
esttab using "$doc\sum_stats_low.tex", ///
cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min max") ///
nonumber nomtitle nonote noobs collabels("Mean" "SD" "Min" "Max") label replace

*========================================================================*
/* Robustness check */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear
/************* Binary treatment *************/
gen eng=h_eng>0.1
eststo clear
eststo: areg imss eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg lwage eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1, absorb(cct) vce(cluster cct)
eststo: areg ldist eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
eststo: areg move_state eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year if wage!=. & ps38==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_binary.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace

eststo clear
eststo: areg imss eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps38==1 & had_e!=1, absorb(cct) vce(cluster cct)
eststo: areg lwage eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps38==1 & had_e!=1, absorb(cct) vce(cluster cct)
eststo: areg ldist eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & had_e!=1, absorb(cct) vce(cluster cct)
eststo: areg move_state eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps38==1 & had_e!=1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_labor_binary_drop.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(eng) stats(N ar2, fmt(%9.0fc %9.3f)) replace
/* TWFE weights */
/*encode cct, generate(cct_n)
twowayfeweights lwage cct_n cohort h_eng, type(feTR)
twowayfeweights lwage cct_n cohort h_eng, type(feTR) controls(h_eng ///
language6 math6 female n_stud rural perma n_jobs n_perma t_colle t_mast)
gen eng=h_eng>0.1
twowayfeweights lwage cct_n cohort eng, type(feTR) controls(h_eng ///
language6 math6 female n_stud rural perma n_jobs n_perma t_colle t_mast)

twowayfeweights lwage cct_n cohort h_eng if had_e!=1, type(feTR) controls(h_eng ///
language6 math6 female n_stud rural perma n_jobs n_perma t_colle t_mast)
twowayfeweights lwage cct_n cohort eng if had_e!=1, type(feTR) controls(h_eng ///
language6 math6 female n_stud rural perma n_jobs n_perma t_colle t_mast)*/
