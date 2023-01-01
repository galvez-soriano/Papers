*========================================================================*
* The effect of the English program on school achievement
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
/* Run this after the main do file */
clear
set more off
gl data= "C:\Users\Oscar Galvez\Documents\Papers\Working papers\Peer effects in middle schools\Data"
gl base= "C:\Users\Oscar Galvez\Documents\Papers\Current\English on labor outcomes\Data"
gl doc= "C:\Users\Oscar Galvez\Documents\Papers\Current\English on labor outcomes\Doc_NL"
*========================================================================*
/* Appending 2006 and 2007 data */
*========================================================================*
clear
append using "$base\DBase_NL\06.dta" "$base\DBase_NL\07.dta", force
duplicates drop

drop if grade=="6"
drop if type=="PRIVATE"
replace fts=0 if fts==.
drop if fts==1
bysort cct shift grade group: gen panel=_N
drop if panel!=2
drop panel
bysort cct after shift grade: gen n_group=_N

gen treat=.
replace treat=1 if grade=="5"
replace treat=0 if grade=="4"

recode after (0 = 1) (2 = 0)

gen after_treat=after*treat


save "$base\DBase_NL\dbase0607.dta", replace
*========================================================================*
/* Appending 2007 and 2008 data */
*========================================================================*
clear
append using "$base\DBase_NL\07.dta" "$base\DBase_NL\08.dta", force
duplicates drop

drop if grade=="6"
drop if type=="PRIVATE"
replace fts=0 if fts==.
drop if fts==1
bysort cct shift grade group: gen panel=_N
drop if panel!=2
drop panel
bysort cct after shift grade: gen n_group=_N

gen treat=.
replace treat=1 if grade=="5"
replace treat=0 if grade=="4"
replace after=1 if after==3

gen after_treat=after*treat

save "$base\DBase_NL\dbase0708.dta", replace
*========================================================================*
/* Appending 2007 and 2009 data */
*========================================================================*
clear
append using "$base\DBase_NL\07.dta" "$base\DBase_NL\09.dta", force
duplicates drop

drop if grade=="6"
drop if type=="PRIVATE"
replace fts=0 if fts==.
drop if fts==1
bysort cct shift grade group: gen panel=_N
drop if panel!=2
drop panel
bysort cct after shift grade: gen n_group=_N

gen treat=.
replace treat=1 if grade=="5"
replace treat=0 if grade=="4"

gen after_treat=after*treat

save "$base\DBase_NL\dbase0709.dta", replace
*========================================================================*
/* Regressions 2007-2008 */
*========================================================================*
use "$base\DBase_NL\dbase0708.dta", clear
sum s_spa
replace s_spa=(s_spa-r(mean))/r(sd)
sum s_math
replace s_math=(s_math-r(mean))/r(sd)

label var s_spa "Spanish score"
label var s_math "Math score"
label var after_treat "After*Treat"
label var after "After"
label var treat "Treat"
label var gender "Female"
label var n_students "Students"
label var n_group "Sections"

* Spanish test scores
eststo clear
*eststo: quietly reg s_spa after_treat after treat, robust
*eststo: quietly reg s_spa after_treat after treat gender n_students ///
*n_group, robust
eststo: quietly reg s_spa after_treat after treat gender n_students ///
n_group indig_stud anglo_stud latino_stud teach_eng teach_mast, robust
/*
esttab using "$doc\tab3.tex", ar2 se b(a2) title(Difference in ///
differences results (Spanish test scores) \label{tab3}) label replace
*/
* Math test scores
*eststo clear
*eststo: quietly reg s_math after_treat after treat, robust
*eststo: quietly reg s_math after_treat after treat gender n_students ///
*n_group, robust
eststo: quietly reg s_math after_treat after treat gender n_students ///
n_group indig_stud anglo_stud latino_stud teach_eng teach_mast, robust
/*
esttab using "$doc\tab4.tex", ar2 se b(a2) title(Difference in ///
differences results (Math test scores) \label{tab4}) label replace
*/
*========================================================================*
/* Regressions 2007-2009 */
*========================================================================*
/*
use "$base\DBase_NL\dbase0709.dta", clear
sum s_spa
replace s_spa=(s_spa-r(mean))/r(sd)
sum s_math
replace s_math=(s_math-r(mean))/r(sd)

label var s_spa "Spanish score"
label var s_math "Math score"
label var after_treat "After*Treat"
label var after "After"
label var treat "Treat"
label var gender "Female"
label var n_students "Students"
label var n_group "Sections"

* Spanish test scores
*eststo clear
*eststo: quietly reg s_spa after_treat after treat, robust
*eststo: quietly reg s_spa after_treat after treat gender n_students ///
*n_group, robust
eststo: quietly reg s_spa after_treat after treat gender n_students ///
n_group indig_stud anglo_stud latino_stud teach_eng teach_mast, robust
/*
esttab using "$doc\tab5.tex", ar2 se b(a2) title(Difference in ///
differences results (Spanish test scores) \label{tab3}) label replace
*/
* Math test scores
*eststo clear
*eststo: quietly reg s_math after_treat after treat, robust
*eststo: quietly reg s_math after_treat after treat gender n_students ///
*n_group, robust
eststo: quietly reg s_math after_treat after treat gender n_students ///
n_group indig_stud anglo_stud latino_stud teach_eng teach_mast, robust
/*
esttab using "$doc\tab6.tex", ar2 se b(a2) title(Difference in ///
differences results (Math test scores) \label{tab4}) label replace
*/
*/
*========================================================================*
/* Regressions placebo test*/
*========================================================================*
use "$base\DBase_NL\dbase0607.dta", clear

sum s_spa
replace s_spa=(s_spa-r(mean))/r(sd)
sum s_math
replace s_math=(s_math-r(mean))/r(sd)

label var s_spa "Spanish score"
label var s_math "Math score"
label var after_treat "After*Treat"
label var after "After"
label var treat "Treat"
label var gender "Female"
label var n_students "Students"
label var n_group "Sections"

* Spanish test scores
*eststo clear
eststo: quietly reg s_spa after_treat after treat gender n_students ///
n_group indig_stud anglo_stud latino_stud teach_eng teach_mast, robust
* Math test scores
eststo: quietly reg s_math after_treat after treat gender n_students ///
n_group indig_stud anglo_stud latino_stud teach_eng teach_mast, robust

esttab using "$doc\tab6.tex", ar2 se b(a2) title(DID results with fourth ///
grades as control \label{tab6}) label replace
