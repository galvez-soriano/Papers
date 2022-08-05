*=====================================================================*
/* Main do file
Note: Before running this do file, please install the 'cgmreg' and 
'unique' commands by downloading the ado files for the former at the 
following site:

https://github.com/galvez-soriano/Papers/edit/main/SocialPensions/Estimation/

and typing the following for the latter:

ssc install unique
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
eststo: cgmreg pam after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg l_inc after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg poor after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg epoor after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg labor after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg hwork after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg poor_health after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg weight_h after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
esttab using "$doc\tab1SE.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab3}) label replace keep(after_treat)
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
eststo: cgmreg pam after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg l_inc after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg poor after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg epoor after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg labor after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg hwork after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg poor_health after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg weight_h after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
esttab using "$doc\tab1SE.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab3}) label replace keep(after_treat)
*=====================================================================*
* Different control group
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=71 & age<=74
*bysort folioviv foliohog: replace treat=. if tcheck==1 
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
eststo: cgmreg pam after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg l_inc after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg poor after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg epoor after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg labor after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg hwork after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg poor_health after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg weight_h after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
esttab using "$doc\tab1SE.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
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
eststo: cgmreg pam after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg l_inc after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg poor after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg epoor after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg labor after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg hwork after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg poor_health after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
eststo: cgmreg weight_h after_treat after treat educ gender disabil hli i.age ///
remitt cohab i.tam_loc i.state if ss_dir==0 [aw=factor], cluster (age ubica_geo)
esttab using "$doc\tab1SE.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab3}) label replace keep(after_treat)
