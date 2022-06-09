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
gl base2= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EngInstruction/Data"
gl base= "C:\Users\ogalvez\Documents\EngAbil\Data"
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

merge m:m cct using "$base2/schools_06_13.dta"
drop _merge
replace rural=rural2 if rural==.
drop rural2
rename rural rural2
merge m:m state id_mun id_loc using "$base2/Rural2010.dta"
drop if _merge==2
replace rural2=rural if rural2==.
drop _merge rural
rename rural2 rural
merge m:m state id_mun id_loc using "$base2/Rural2.dta"
replace rural=rural2 if rural==.
drop _merge rural2
merge m:m cct using "$base2/schools_geo.dta"
drop if _merge==2
replace id_loc=id_loc2 if rural==.
drop _merge state2 id_mun2 id_loc2
merge m:m state id_mun id_loc using "$base2/Rural2.dta"
replace rural=rural2 if rural==.
drop _merge rural2
rename rural rural2
merge m:m state id_mun id_loc using "$base2/Rural2010.dta"
drop if _merge==2
replace rural2=rural if rural2==.
drop _merge rural
rename rural2 rural
merge m:m cct using "$base2/schools_cpv.dta"
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

merge m:m cct year using "$base2/fts0718.dta"
drop if _merge==2
drop _merge
replace fts=0 if fts==.

order state id_mun id_loc cct shift year
sort state id_mun id_loc cct shift year
save "$base\d_schools.dta", replace
*========================================================================*
* Creating exposure variable at locality level
*========================================================================*
use "$base\d_schools.dta", clear

gen str geo=(state + id_mun + id_loc)
collapse (mean) h_group [fw=total_stud], by(geo year)

rename h_group hrs_exp
replace hrs_exp=0 if hrs_exp==.
drop if year>2007

bysort geo: gen nobs=_n
bysort geo: gen nobs_tot=_N
count
expand 2 if nobs==10 & nobs_tot==10
gen obs=_n
replace year=. if obs>r(N)
replace hrs_exp=. if obs>r(N)
sort geo year
bysort geo: egen sum_year=sum(year)
replace year=1997 if year==. & sum_year==20025
replace year=1998 if year==. & sum_year==20024
replace year=1999 if year==. & sum_year==20023
replace year=2000 if year==. & sum_year==20022
replace year=2001 if year==. & sum_year==20021
replace year=2002 if year==. & sum_year==20020
replace year=2003 if year==. & sum_year==20019
replace year=2004 if year==. & sum_year==20018
replace year=2005 if year==. & sum_year==20017
replace year=2006 if year==. & sum_year==20016
replace year=2007 if year==. & sum_year==20015

replace hrs_exp=hrs_exp[_n+1] if missing(hrs_exp) & year==1997
replace hrs_exp=(hrs_exp[_n-1]+hrs_exp[_n+1])/2 if missing(hrs_exp) & year!=1997 & year!=2007
replace hrs_exp=hrs_exp[_n-1] if missing(hrs_exp) & year==2007
drop nobs nobs_tot obs sum_year

bysort geo: gen nobs=_n
bysort geo: gen nobs_tot=_N
count
expand 3 if nobs==9 & nobs_tot==9
gen obs=_n
replace year=. if obs>r(N)
replace hrs_exp=. if obs>r(N)
sort geo year
bysort geo: egen sum_year=sum(year)


gen cohort=year-11
drop year

save "$base\exposure_loc.dta", replace
