*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
/* Working with the School Census (Stats 911) to create a database of 
school's characteristics and exposure to English instruction */
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EngInstruction/Stat911"
gl data2= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EngInstruction/Data"
gl base= "C:\Users\Oscar Galvez Soriano\OneDrive - The University of Chicago\Documents\Papers\IPUMS\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\OneDrive - The University of Chicago\Documents\Papers\IPUMS\Doc"
*========================================================================*
clear
foreach x in 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13{
append using "$data/stat911_`x'.dta"
}
order state id_mun id_loc cct shift year eng teach_eng hours_eng total_groups total_stud ///
indig_stud anglo_stud latino_stud other_stud disabil high_abil teach_elem  ///
teach_midle teach_high teach_colle teach_mast teach_phd school_supp_exp ///
uniform_exp tuition

sort cct shift year
label var year "Year"
label var eng "Had English program"
* Public schools
gen classif=substr(cct,3,3)
gen priv=substr(cct,3,1)
gen public=1
replace public=0 if priv=="P"
replace public=0 if classif=="SBC" | classif=="SBH" | classif=="SCT"
drop classif priv
gen had_eng=1 if eng==1 & year==2008
replace had_eng=0 if had_eng==.

/* Observed hours of English instruction */
gen h_group=hours_eng/total_groups
replace h_group=0 if h_group==.
label var h_group "Hours of English instruction (per class)"

/* Observed number of English teachers */
gen teach_g=teach_eng/total_groups
replace teach_g=0 if teach_g==.
label var teach_g "English teachers (per class)"

drop state
gen state=substr(cct,1,2)
tostring id_mun, replace format(%03.0f) force
tostring id_loc, replace format(%04.0f) force
rename rural rural2

merge m:m cct using "$data2/schools_06_13.dta"
drop _merge
replace rural=rural2 if rural==.
drop rural2
rename rural rural2
merge m:m state id_mun id_loc using "$data2/Rural2010.dta"
drop if _merge==2
replace rural2=rural if rural2==.
drop _merge rural
rename rural2 rural
merge m:m state id_mun id_loc using "$data2/Rural2.dta"
replace rural=rural2 if rural==.
drop _merge rural2
merge m:m cct using "$data2/schools_geo.dta"
drop if _merge==2
replace id_loc=id_loc2 if rural==.
drop _merge state2 id_mun2 id_loc2
merge m:m state id_mun id_loc using "$data2/Rural2.dta"
replace rural=rural2 if rural==.
drop _merge rural2
rename rural rural2
merge m:m state id_mun id_loc using "$data2/Rural2010.dta"
drop if _merge==2
replace rural2=rural if rural2==.
drop _merge rural
rename rural2 rural
merge m:m cct using "$data2/schools_cpv.dta"
drop if _merge==2
replace id_loc=cve_loc if rural==.
replace rural=1 if rururb=="R" & rural==.
replace rural=0 if rururb=="U" & rural==.
drop _merge cve_ent cve_mun cve_loc rururb

save "$base\d_schools.dta", replace
*========================================================================*
use "$base\d_schools.dta", clear

label var state "State"
drop if cct==""
drop if year==.
bysort cct: gen same_school=_N
keep if same_school>=15 & same_school<=17
drop same_school

merge m:m cct year using "$data2/fts0718.dta"
drop if _merge==2
drop _merge
replace fts=0 if fts==.

order state id_mun id_loc cct shift year
sort state id_mun id_loc cct shift year
save "$base\d_schools.dta", replace
*========================================================================*
* Creating exposure variable at the national level
*========================================================================*
use "$base\d_schools.dta", clear

drop if public==0
egen groups=rowtotal(groups_*)
egen groups4=rowtotal(groups_1 groups_2 groups_3 groups_4)
gen correction=groups4/groups
replace h_group=h_group*correction if year<=2010

collapse (mean) h_group [fw=total_stud], by(year)
gen id=1
reshape wide h_group, i(id) j(year)

egen hrs_exp1997=rowmean(h_group2003 h_group2004 h_group2005 h_group2006 h_group2007 h_group2008)
egen hrs_exp1998=rowmean(h_group2004 h_group2005 h_group2006 h_group2007 h_group2008 h_group2009)
egen hrs_exp1999=rowmean(h_group2005 h_group2006 h_group2007 h_group2008 h_group2009 h_group2010)
egen hrs_exp2000=rowmean(h_group2006 h_group2007 h_group2008 h_group2009 h_group2010 h_group2011)
egen hrs_exp2001=rowmean(h_group2007 h_group2008 h_group2009 h_group2010 h_group2011 h_group2012)
egen hrs_exp2002=rowmean(h_group2008 h_group2009 h_group2010 h_group2011 h_group2012 h_group2013)

drop h_group19* h_group20*

reshape long hrs_exp, i(id) j(cohort)
drop id

graph bar hrs_exp, over(cohort) graphregion(color(white)) ///
ytitle("Weekly hours of Eng instruction per class", size(medium) height(5))
graph export "$doc\EngCohort.png", replace
*========================================================================*

use "$base\d_schools.dta", clear

drop if public==0
egen groups=rowtotal(groups_*)
egen groups4=rowtotal(groups_1 groups_2 groups_3 groups_4)
gen correction=groups4/groups
replace h_group=h_group*correction if year<=2010

collapse (mean) h_group [fw=total_stud], by(year)
gen id=1
reshape wide h_group, i(id) j(year)

egen hrs_exp1997=rowmean(h_group2003 h_group2004 h_group2005 h_group2006 h_group2007 h_group2008)
egen hrs_exp1998=rowmean(h_group2004 h_group2005 h_group2006 h_group2007 h_group2008)
egen hrs_exp1999=rowmean(h_group2005 h_group2006 h_group2007 h_group2008)
egen hrs_exp2000=rowmean(h_group2006 h_group2007 h_group2008 h_group2009 h_group2010 h_group2011)
egen hrs_exp2001=rowmean(h_group2007 h_group2008 h_group2009 h_group2010 h_group2011 h_group2012)
egen hrs_exp2002=rowmean(h_group2008 h_group2009 h_group2010 h_group2011 h_group2012 h_group2013)

drop h_group19* h_group20*

reshape long hrs_exp, i(id) j(cohort)
drop id

graph bar hrs_exp, over(cohort) graphregion(color(white)) ///
ytitle("Weekly hours of Eng instruction per class", size(medium) height(5))
graph export "$doc\EngCohortPolicy.png", replace