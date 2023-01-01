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
rename h_eng h_eng2
rename t_eng t_eng2
rename t_colle t_colle2
rename t_mast t_mast2

replace cohort=1997 if cohort==97
replace cohort=1998 if cohort==98
replace cohort=1999 if cohort==99
replace cohort=2000 if cohort==0
replace cohort=2001 if cohort==1
replace cohort=2002 if cohort==2

merge m:m cct cohort using "$base\exposure_school.dta"
drop if _merge!=3
drop _merge
merge m:m geo_mun_s cohort using "$base\p_stud_census2020.dta"
drop if _merge!=3
drop _merge

save "$base\dbase_18_21_final.dta", replace
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

esttab using "$doc\tab_labor.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace

/************* Low Enrollment Sample *************/
use "$base\dbase_18_21_final.dta", clear
eststo clear
* Formal sector
eststo: areg imss h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25, absorb(cct) vce(cluster cct)
* Wages
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps_c20_mun<=0.25, absorb(cct) vce(cluster cct)
* Distance
eststo: areg ldist h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps_c20_mun<=0.25, absorb(cct) vce(cluster cct)
* Move state
eststo: areg move_state h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps_c20_mun<=0.25, absorb(cct) vce(cluster cct)

esttab using "$doc\tab_labor_low.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace

/************* Low Enrollment Subsample (Gender) *************/
use "$base\dbase_18_21_final.dta", clear
gen eng_female=h_eng*female
eststo clear
* Formal sector
eststo: areg imss eng_female h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25, absorb(cct) vce(cluster cct)
* Wages
eststo: areg lwage eng_female h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps_c20_mun<=0.25, absorb(cct) vce(cluster cct)
* Distance
eststo: areg ldist eng_female h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps_c20_mun<=0.25, absorb(cct) vce(cluster cct)
* Move state
eststo: areg move_state eng_female h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps_c20_mun<=0.25, absorb(cct) vce(cluster cct)

esttab using "$doc\tab_labor_low_gender.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace

/************* Low Enrollment Subsample (Men) *************/
use "$base\dbase_18_21_final.dta", clear
gen eng_female=h_eng*female
eststo clear
* Formal sector
eststo: areg imss h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & female==0, absorb(cct) vce(cluster cct)
* Wages
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps_c20_mun<=0.25 & female==0, absorb(cct) vce(cluster cct)
* Distance
eststo: areg ldist h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps_c20_mun<=0.25 & female==0, absorb(cct) vce(cluster cct)
* Move state
eststo: areg move_state h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps_c20_mun<=0.25 & female==0, absorb(cct) vce(cluster cct)

esttab using "$doc\tab_labor_low_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace

/************* Low Enrollment Subsample (Women) *************/
use "$base\dbase_18_21_final.dta", clear
eststo clear
* Formal sector
eststo: areg imss h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & female==1, absorb(cct) vce(cluster cct)
* Wages
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if ps_c20_mun<=0.25 & female==1, absorb(cct) vce(cluster cct)
* Distance
eststo: areg ldist h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps_c20_mun<=0.25 & female==1, absorb(cct) vce(cluster cct)
* Move state
eststo: areg move_state h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & ps_c20_mun<=0.25 & female==1, absorb(cct) vce(cluster cct)

esttab using "$doc\tab_labor_low_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace
*========================================================================*
/* Regressions Economic Industry */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear
drop if wage==.
/* Creating industry variable: export industry, non-export, hospitality
and other services */
gen industry=.
/*replace industry=0 if activity<=107 & (activity!=24 & activity!=40 & ///
activity!=52 & activity!=53 & activity!=95 & activity!=96 & activity!=102 ///
& activity!=106) | activity==112 | activity==114 | activity==116 | ///
activity==118 | activity==126 | activity==127 | activity==131 | activity==144 | ///
activity==147 | activity==148 | activity==153 | activity==154 | activity==178*/
replace industry=0 if activity<=107 & (activity!=24 & activity!=106) | ///
activity==112 | activity==114 | activity==116 | activity==118 | activity==126 ///
| activity==127 | activity==131 | activity==132 | activity==144 | ///
activity==147 | activity==148 | activity==153 | activity==154 | activity==178
replace industry=1 if activity<=146 & industry==.
/*replace industry=2 if activity>=149 & (activity<=221 & industry!=0) | ///
activity>=223 & (activity!=225 & activity!=228 & activity!=243 & activity!=276)
replace industry=3 if activity>=222 & industry==.*/
replace industry=2 if activity==229 | (activity>241 & activity<=251)
replace industry=3 if activity>=149 & (industry!=2 & industry!=0)

gen nexport_ind=industry==0
gen export_ind=industry==1
gen hosp_telecom_recrea=industry==2
gen other_ser=industry==3
/************* Full Sample *************/
eststo clear
eststo: areg nexport_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg export_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg hosp_telecom_recrea h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg other_ser h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_econ_sector.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace
/************* Low Enrollment Subsample *************/
eststo clear
eststo: areg nexport_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25, absorb(cct) vce(cluster cct)
eststo: areg export_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25, absorb(cct) vce(cluster cct)
eststo: areg hosp_telecom_recrea h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25, absorb(cct) vce(cluster cct)
eststo: areg other_ser h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_econ_sector_low.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace
/************* Low Enrollment Subsample (Men) *************/
eststo clear
eststo: areg nexport_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & female==0, absorb(cct) vce(cluster cct)
eststo: areg export_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & female==0, absorb(cct) vce(cluster cct)
eststo: areg hosp_telecom_recrea h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & female==0, absorb(cct) vce(cluster cct)
eststo: areg other_ser h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & female==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_econ_sector_low_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace
/************* Low Enrollment Subsample (Women) *************/
eststo clear
eststo: areg nexport_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & female==1, absorb(cct) vce(cluster cct)
eststo: areg export_ind h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & female==1, absorb(cct) vce(cluster cct)
eststo: areg hosp_telecom_recrea h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & female==1, absorb(cct) vce(cluster cct)
eststo: areg other_ser h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & female==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_econ_sector_low_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace
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
t_mast rural i.cohort i.year if wage!=., absorb(cct) vce(cluster cct)
eststo: areg smallf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if wage!=., absorb(cct) vce(cluster cct)
eststo: areg mediumf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if wage!=., absorb(cct) vce(cluster cct)
eststo: areg bigf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if wage!=., absorb(cct) vce(cluster cct)
esttab using "$doc\tab_com_size.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace
/************* Low Enrollment Subsample *************/
eststo clear
eststo: areg microf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & wage!=., absorb(cct) vce(cluster cct)
eststo: areg smallf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & wage!=., absorb(cct) vce(cluster cct)
eststo: areg mediumf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & wage!=., absorb(cct) vce(cluster cct)
eststo: areg bigf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & wage!=., absorb(cct) vce(cluster cct)
esttab using "$doc\tab_com_size_low.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace
/************* Low Enrollment Subsample (Men) *************/
eststo clear
eststo: areg microf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & wage!=. & female==0, absorb(cct) vce(cluster cct)
eststo: areg smallf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & wage!=. & female==0, absorb(cct) vce(cluster cct)
eststo: areg mediumf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & wage!=. & female==0, absorb(cct) vce(cluster cct)
eststo: areg bigf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & wage!=. & female==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_com_size_low_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace
/************* Low Enrollment Subsample (Women) *************/
eststo clear
eststo: areg microf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & wage!=. & female==1, absorb(cct) vce(cluster cct)
eststo: areg smallf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & wage!=. & female==1, absorb(cct) vce(cluster cct)
eststo: areg mediumf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & wage!=. & female==1, absorb(cct) vce(cluster cct)
eststo: areg bigf h_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if ps_c20_mun<=0.25 & wage!=. & female==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_com_size_low_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace

*========================================================================*
/* Regressions Student Achievement */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear

eststo clear
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if wage!=., absorb(state_s) vce(cluster cct)
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if wage!=., absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if wage!=., absorb(state_s) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if wage!=., absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) keep(h_eng) replace
* Low enrollment sample
eststo clear
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if wage!=. & p_stud_enoe<=.11, absorb(state_s) vce(cluster cct)
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if wage!=. & p_stud_enoe<=.11, absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if wage!=. & p_stud_enoe<=.11, absorb(state_s) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if wage!=. & p_stud_enoe<=.11, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_low.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) keep(h_eng) replace
* Men
eststo clear
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if wage!=. & p_stud_enoe<=.11 & gender==0, absorb(state_s) vce(cluster cct)
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if wage!=. & p_stud_enoe<=.11 & gender==0, absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if wage!=. & p_stud_enoe<=.11 & gender==0, absorb(state_s) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if wage!=. & p_stud_enoe<=.11 & gender==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_men.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) keep(h_eng) replace
* Women
eststo clear
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if wage!=. & p_stud_enoe<=.11 & gender==1, absorb(state_s) vce(cluster cct)
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if wage!=. & p_stud_enoe<=.11 & gender==1, absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if wage!=. & p_stud_enoe<=.11 & gender==1, absorb(state_s) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if wage!=. & p_stud_enoe<=.11 & gender==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_women.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) keep(h_eng) replace

/******************************* Apendix ********************************/

*========================================================================*
/* State, county, locality and school FE */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear
* Hours of English instruction
eststo clear
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(state_s) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(geo_mun_s) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(id_geo_s) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_select_hrs.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace

eststo clear
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if p_stud_enoe<=.11, absorb(state_s) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if p_stud_enoe<=.11, absorb(geo_mun_s) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if p_stud_enoe<=.11, absorb(id_geo_s) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if p_stud_enoe<=.11, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_select_hrs_low.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng) replace

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
esttab using "$doc\tab_select_teach.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(t_eng) replace

eststo clear
eststo: areg lwage t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if p_stud_enoe<=.11, absorb(state_s) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if p_stud_enoe<=.11, absorb(geo_mun_s) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if p_stud_enoe<=.11, absorb(id_geo_s) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if p_stud_enoe<=.11, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_select_teach_low.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(t_eng) replace

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
* Formal sector
eststo: areg imss h_eng q2_eng q3_eng q4_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year, absorb(cct) vce(cluster cct)
* Wages
eststo: areg lwage h_eng q2_eng q3_eng q4_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(cct) vce(cluster cct)
* Distance
eststo: areg ldist h_eng q2_eng q3_eng q4_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=., absorb(cct) vce(cluster cct)
* Move state
eststo: areg move_state h_eng q2_eng q3_eng q4_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=., absorb(cct) vce(cluster cct)

esttab using "$doc\tab_labor_ability.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng q2_eng q3_eng q4_eng) replace
/************* Low Enrollment Sample *************/
eststo clear
* Formal sector
eststo: areg imss h_eng q2_eng q3_eng q4_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
* Wages
eststo: areg lwage h_eng q2_eng q3_eng q4_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
* Distance
eststo: areg ldist h_eng q2_eng q3_eng q4_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
* Move state
eststo: areg move_state q2_eng q3_eng q4_eng h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)

esttab using "$doc\tab_labor_abil_low.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng q2_eng q3_eng q4_eng) replace
/************* Low Enrollment Subsample (Men) *************/
eststo clear
* Formal sector
eststo: areg imss h_eng q2_eng q3_eng q4_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if p_stud_enoe<=0.11 & female==0, absorb(cct) vce(cluster cct)
* Wages
eststo: areg lwage h_eng q2_eng q3_eng q4_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if p_stud_enoe<=0.11 & female==0, absorb(cct) vce(cluster cct)
* Distance
eststo: areg ldist h_eng q2_eng q3_eng q4_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & p_stud_enoe<=0.11 & female==0, absorb(cct) vce(cluster cct)
* Move state
eststo: areg move_state h_eng q2_eng q3_eng q4_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & p_stud_enoe<=0.11 & female==0, absorb(cct) vce(cluster cct)

esttab using "$doc\tab_labor_abil_low_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng q2_eng q3_eng q4_eng) replace
/************* Low Enrollment Subsample (Women) *************/
eststo clear
* Formal sector
eststo: areg imss h_eng q2_eng q3_eng q4_eng language6 math6 female n_stud age age2 t_colle ///
t_mast rural i.cohort i.year if p_stud_enoe<=0.11 & female==1, absorb(cct) vce(cluster cct)
* Wages
eststo: areg lwage h_eng q2_eng q3_eng q4_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if p_stud_enoe<=0.11 & female==1, absorb(cct) vce(cluster cct)
* Distance
eststo: areg ldist h_eng q2_eng q3_eng q4_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & p_stud_enoe<=0.11 & female==1, absorb(cct) vce(cluster cct)
* Move state
eststo: areg move_state h_eng q2_eng q3_eng q4_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if wage!=. & p_stud_enoe<=0.11 & female==1, absorb(cct) vce(cluster cct)

esttab using "$doc\tab_labor_abil_low_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(h_eng q2_eng q3_eng q4_eng) replace
*========================================================================*
/* The effect on type of jobs */
*========================================================================*
use "$base\dbase_18_21_final.dta", clear

gen econ_act=.
replace econ_act=1 if activity<=8
replace econ_act=2 if (activity>8 & activity<=17) | (activity>146 & activity<=154) ///
| (activity>216 & activity<=228)
replace econ_act=3 if activity>17 & activity<=146
replace econ_act=4 if activity>154 & activity<=216
replace econ_act=5 if (activity>229 & activity<=241) | ///
(activity>251 & activity<=272)
replace econ_act=6 if (activity>272 & activity!=.)
replace econ_act=7 if activity==229 | (activity>241 & activity<=251)
/* Construction includes mining, electricity and water, and transportation
Hospitaly includes communications and entretainment */
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
*======== Economic activities ========*
/* Full sample */
eststo clear
eststo: areg ag_ea h_eng rural female language6 math6 age age2 i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg cons_ea h_eng rural female language6 math6 age age2 i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg manu_ea h_eng rural female language6 math6 age age2 i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg comm_ea h_eng rural female language6 math6 age age2 i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg pro_ea h_eng rural female language6 math6 age age2 i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg gov_ea h_eng rural female language6 math6 age age2 i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg hosp_ea h_eng rural female language6 math6 age age2 i.cohort i.year, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_ea.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(h_eng) replace
/* Low-enrollment sample */
eststo clear
eststo: areg ag_ea h_eng rural female language6 math6 age age2 i.cohort i.year if p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg cons_ea h_eng rural female language6 math6 age age2 i.cohort i.year if p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg manu_ea h_eng rural female language6 math6 age age2 i.cohort i.year if p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg comm_ea h_eng rural female language6 math6 age age2 i.cohort i.year if p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg pro_ea h_eng rural female language6 math6 age age2 i.cohort i.year if p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg gov_ea h_eng rural female language6 math6 age age2 i.cohort i.year if p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg hosp_ea h_eng rural female language6 math6 age age2 i.cohort i.year if p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_ea_low.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(h_eng) replace
/* Men */
eststo clear
eststo: areg ag_ea h_eng rural female language6 math6 age age2 i.cohort i.year if female==0 & p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg cons_ea h_eng rural female language6 math6 age age2 i.cohort i.year if female==0 & p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg manu_ea h_eng rural female language6 math6 age age2 i.cohort i.year if female==0 & p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg comm_ea h_eng rural female language6 math6 age age2 i.cohort i.year if female==0 & p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg pro_ea h_eng rural female language6 math6 age age2 i.cohort i.year if female==0 & p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg gov_ea h_eng rural female language6 math6 age age2 i.cohort i.year if female==0 & p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg hosp_ea h_eng rural female language6 math6 age age2 i.cohort i.year if female==0 & p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_ea_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(h_eng) replace
/* Women */
eststo clear
eststo: areg ag_ea h_eng rural female language6 math6 age age2 i.cohort i.year if female==1 & p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg cons_ea h_eng rural female language6 math6 age age2 i.cohort i.year if female==1 & p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg manu_ea h_eng rural female language6 math6 age age2 i.cohort i.year if female==1 & p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg comm_ea h_eng rural female language6 math6 age age2 i.cohort i.year if female==1 & p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg pro_ea h_eng rural female language6 math6 age age2 i.cohort i.year if female==1 & p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg gov_ea h_eng rural female language6 math6 age age2 i.cohort i.year if female==1 & p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
eststo: areg hosp_ea h_eng rural female language6 math6 age age2 i.cohort i.year if female==1 & p_stud_enoe<=0.11, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_ea_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(h_eng) replace

*========================================================================*
/* Dealing with selection problem */
*========================================================================*
/* Subsample: low enrollment */
use "$base\dbase_18_21_final.dta", clear
label var h_eng "Proportion of individuals enrolled in school"
/*
*graph set window fontface "Times New Roman"
label var h_eng "Proportion of individuals enrolled in school"

eststo clear
foreach x in 05 06 07 08 09 10 11 12 13 14 15{
areg imss h_eng language6 math6 female n_stud age age2 rural i.cohort ///
t_colle t_mast i.year if p_stud_enoe<=0.`x', absorb(cct) vce(cluster cct)
estimates store formal`x'
}
coefplot (formal05, label(p<=0.05)) (formal06, label(p<=0.06)) (formal07, ///
label(p<=0.07)) (formal08, label(p<=0.08)) (formal09, label(p<=0.09)) ///
(formal10, label(p<=0.10)) (formal11, label(p<=0.11) mcolor(red) ///
ciopts(recast(rcap) color(red))) (formal12, ///
label(p<=0.12)) (formal13, label(p<=0.13)) ///
(formal14, label(p<=0.14)) (formal15, label(p<=0.15)), ///
vertical keep(h_eng) yline(0) ///
ytitle("Probability of working in formal sector", size(medium) height(5)) ///
legend( pos(8) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\formal_c20_low.png", replace

eststo clear
foreach x in 05 06 07 08 09 10 11 12 13 14 15{
areg lwage h_eng language6 math6 female n_stud rural age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if p_stud_enoe<=0.`x', absorb(cct) vce(cluster cct)
estimates store wage`x'
}
coefplot (wage05, label(p<=0.05)) (wage06, label(p<=0.06)) (wage07, ///
label(p<=0.07) mcolor(red) ciopts(recast(rcap) color(red))) ///
(wage08, label(p<=0.08)) (wage09, label(p<=0.09)) ///
(wage10, label(p<=0.10)) (wage11, label(p<=0.11)) (wage12, ///
label(p<=0.12)) (wage13, label(p<=0.13)) ///
(wage14, label(p<=0.14)) (wage15, label(p<=0.15)), ///
vertical keep(h_eng) yline(0) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
legend( pos(1) ring(0) col(2)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\wages_c20_low.png", replace
*/
************************************************************************
eststo clear
foreach x in 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30{
areg imss h_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if ps_c20_mun<=0.`x', absorb(cct) vce(cluster cct)
estimates store formal`x'
}
coefplot (formal15, label(p<=0.15)) (formal16, label(p<=0.16)) (formal17, ///
label(p<=0.17)) (formal18, label(p<=0.18)) (formal19, label(p<=0.19)) ///
(formal20, label(p<=0.20)) (formal21, label(p<=0.21)) (formal22, ///
label(p<=0.22)) (formal23, label(p<=0.23)) (formal24, label(p<=0.24)) ///
(formal25, label(p<=0.25) mcolor(red) ciopts(recast(rcap) color(red))) ///
(formal26, label(p<=0.26)) (formal27, label(p<=0.27)) (formal28, ///
label(p<=0.28)) (formal29, label(p<=0.29)) (formal30, label(p<=0.30)), ///
vertical keep(h_eng) yline(0) ///
ytitle("Probability of working in formal sector", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
legend( pos(1) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\formal_c20_low.png", replace

eststo clear
foreach x in 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30{
areg lwage h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year if ps_c20_mun<=0.`x', absorb(cct) vce(cluster cct)
estimates store wage`x'
}
coefplot (wage15, label(p<=0.15)) (wage16, label(p<=0.16)) (wage17, ///
label(p<=0.17)) (wage18, label(p<=0.18)) (wage19, label(p<=0.19)) ///
(wage20, label(p<=0.20)) (wage21, label(p<=0.21)) (wage22, ///
label(p<=0.22)) (wage23, label(p<=0.23)) (wage24, label(p<=0.24)) ///
(wage25, label(p<=0.25) mcolor(red) ciopts(recast(rcap) color(red))) ///
(wage26, label(p<=0.26)) (wage27, label(p<=0.27)) ///
(wage28, label(p<=0.28)) (wage29, label(p<=0.29)) (wage30, label(p<=0.30)), ///
vertical keep(h_eng) yline(0) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) format(%5.2f)) ///
legend(pos(1) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\wages_c20_low.png", replace

*========================================================================*
/* Subsample: low enrollment and exposure at county level */
use "$base\dbase_18_21_final.dta", clear

/*
merge m:m id_mun using "$base\mun_imss.dta"
drop if _merge!=3
drop _merge

drop geo
rename id_geo geo
*/
merge m:m geo cohort using "$base\exposure_mun.dta"
drop if _merge!=3
drop _merge

replace cohort=cohort+1900 if cohort>10
replace cohort=cohort+2000 if cohort<10

eststo clear
eststo: areg imss hrs_exp rural female age i.cohort n_stud language6 math6 t_colle t_mast i.year, absorb(state_s) vce(cluster geo)
eststo: areg imss hrs_exp rural female age i.cohort n_stud language6 math6 t_colle t_mast i.year, absorb(geo) vce(cluster geo)
eststo: areg imss hrs_exp rural female age i.cohort n_stud language6 math6 t_colle t_mast i.year, absorb(cct) vce(cluster geo)
eststo: areg lwage hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year, absorb(state_s) vce(cluster geo)
eststo: areg lwage hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year, absorb(cct) vce(cluster geo)
esttab using "$doc\tab1_county.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) keep(hrs_exp) replace

eststo clear
eststo: areg imss hrs_exp rural female age i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07, absorb(state_s) vce(cluster geo)
eststo: areg imss hrs_exp rural female age i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07, absorb(geo) vce(cluster geo)
eststo: areg imss hrs_exp rural female age i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07, absorb(cct) vce(cluster geo)
eststo: areg lwage hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07, absorb(state_s) vce(cluster geo)
eststo: areg lwage hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07, absorb(cct) vce(cluster geo)
esttab using "$doc\tab2_county.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) keep(hrs_exp) replace

eststo clear
eststo: areg imss hrs_exp rural female age i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07 & female==0, absorb(state_s) vce(cluster geo)
eststo: areg imss hrs_exp rural female age i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07 & female==0, absorb(geo) vce(cluster geo)
eststo: areg imss hrs_exp rural female age i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07 & female==0, absorb(cct) vce(cluster geo)
eststo: areg lwage hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07 & female==0, absorb(state_s) vce(cluster geo)
eststo: areg lwage hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07 & female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07 & female==0, absorb(cct) vce(cluster geo)
esttab using "$doc\tab3_county.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) keep(hrs_exp) replace

eststo clear
eststo: areg imss hrs_exp rural female age i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07 & female==1, absorb(state_s) vce(cluster geo)
eststo: areg imss hrs_exp rural female age i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07 & female==1, absorb(geo) vce(cluster geo)
eststo: areg imss hrs_exp rural female age i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07 & female==1, absorb(cct) vce(cluster geo)
eststo: areg lwage hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07 & female==1, absorb(state_s) vce(cluster geo)
eststo: areg lwage hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07 & female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female age age2 i.cohort n_stud language6 math6 t_colle t_mast i.year if p_stud_enoe<=0.07 & female==1, absorb(cct) vce(cluster geo)
esttab using "$doc\tab4_county.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) keep(hrs_exp) replace


