*=====================================================================*
/* Main do file
Note: Before running this do file, please install the "reghdfe" and "ftools" 
packages by typing the following:

ssc install reghdfe
ssc install ftools
*/
*=====================================================================*
set more off
gl base="https://raw.githubusercontent.com/galvez-soriano/Papers/main/SocialPensions/Data"
gl data="C:\Users\ogalvez\Documents\SocialPensions\Data"
gl doc="C:\Users\ogalvez\Documents\SocialPensions\Doc"
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
/* Main Results (TABLE 1). DiD estimations */
*=====================================================================*
eststo clear
eststo: reghdfe pam after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe l_inc after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe poor after_treat after treat tamhogesc educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe epoor after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe labor after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe hwork after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe poor_health after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe weight_h after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
esttab using "$doc\tab1SE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(DiD estimations ///
(\autoref{eq:1})\label{tab1}) keep(after_treat) stats(N ar2, fmt(%9.0fc %9.3f)) replace
*=====================================================================*
* Robustness checks: DiD estimations
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
eststo: reghdfe pam after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe l_inc after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe poor after_treat after treat tamhogesc educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe epoor after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe labor after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe hwork after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe poor_health after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe weight_h after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
esttab using "$doc\tab1SE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(DiD estimations ///
(\autoref{eq:1})\label{tab1}) keep(after_treat) stats(N ar2, fmt(%9.0fc %9.3f)) replace
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
eststo: reghdfe pam after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe l_inc after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe poor after_treat after treat tamhogesc educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe epoor after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe labor after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe hwork after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe poor_health after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe weight_h after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
esttab using "$doc\tab1SE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(DiD estimations ///
(\autoref{eq:1})\label{tab1}) keep(after_treat) stats(N ar2, fmt(%9.0fc %9.3f)) replace
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
eststo: reghdfe pam after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe l_inc after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe poor after_treat after treat tamhogesc educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe epoor after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe labor after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe hwork after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe poor_health after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
eststo: reghdfe weight_h after_treat after treat educ gender disabil hli cohab ///
remitt i.tam_loc if ss_dir==0 [aw=factor], absorb(state age) cluster(ubica_geo age)
esttab using "$doc\tab1SE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(DiD estimations ///
(\autoref{eq:1})\label{tab1}) keep(after_treat) stats(N ar2, fmt(%9.0fc %9.3f)) replace
