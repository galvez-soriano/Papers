*=====================================================================*
/* Main do file
Note: Before running this do file, please install the boottest package
ssc install boottest, replace
*/
*=====================================================================*
set more off
gl base="https://raw.githubusercontent.com/galvez-soriano/Papers/main/SocialPensions/Data"
gl data="C:\Users\galve\Documents\Papers\Working papers\Social pension program\Data"
gl doc="C:\Users\galve\Documents\Papers\Working papers\Social pension program\Doc"
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
/* Main Results (Wild Bootstrap). DiD estimations */
*=====================================================================*
eststo clear
eststo: quietly areg pam after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg l_inc after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg poor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg epoor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg labor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg hwork after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
esttab using "$doc\tabWild.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(DiD estimations ///
(\autoref{eq:1})\label{tab3}) label replace keep(after_treat)
*=====================================================================*
/* Robustness checks: DiD estimations */
*=====================================================================*
* Narrowed age groups
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=67
bysort folioviv foliohog: replace treat=0 if age>=63 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
eststo clear
eststo: quietly areg pam after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg l_inc after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg poor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg epoor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg labor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg hwork after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
esttab using "$doc\tabWild.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(DiD estimations ///
(\autoref{eq:1})\label{tab3}) label replace keep(after_treat)
*=====================================================================*
* Different control group
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=71 & age<=74
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
eststo clear
eststo: quietly areg pam after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg l_inc after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg poor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg epoor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg labor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg hwork after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
esttab using "$doc\tabWild.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(DiD estimations ///
(\autoref{eq:1})\label{tab3}) label replace keep(after_treat)
*=====================================================================*
/* Including individuals 65 years old */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=65 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
eststo clear
eststo: quietly areg pam after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg l_inc after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg poor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg epoor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg labor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: quietly areg hwork after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
esttab using "$doc\tabWild.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(DiD estimations ///
(\autoref{eq:1})\label{tab3}) label replace keep(after_treat)
*=====================================================================*
/* TABLE 2.
Heterogenous effects: DiD estimations */
*=====================================================================*
/* Indigenous */
eststo clear
eststo: areg pam after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: areg l_inc after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: areg poor after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: areg epoor after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: areg labor after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: areg hwork after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: areg poor_health after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: areg weight_h after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
esttab using "$doc\table_ind.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
title(Indigenous) label replace keep(after_treat)
*=====================================================================*
/* Non-Indigenous */
eststo clear
eststo: areg pam after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: areg l_inc after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: areg poor after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: areg epoor after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: areg labor after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: areg hwork after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: areg poor_health after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
eststo: areg weight_h after_treat after treat educ gender disabil hli i.age cohab ///
remitt i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster age)
boottest after_treat, seed(6) weight(webb) noci
esttab using "$doc\table_non_ind.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
title(Non-Indigenous) label replace keep(after_treat)
*=====================================================================*
