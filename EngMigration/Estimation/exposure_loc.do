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
gl base= "C:\Users\galve\Documents\Papers\Current\EngMigration\Base"
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
/* Creating exposure variable at locality level
The Mexican school census has missing values for some observations at 
locality level. In this section of the do file, I fill in those missings.
First, I add the missing years and then I interpolate the missing 
observations using the mean between two priximate years. */
*========================================================================*
use "$base\d_schools.dta", clear

gen str geo=(state + id_mun + id_loc)
collapse (mean) h_group [fw=total_stud], by(geo year)

rename h_group hrs_exp
replace hrs_exp=0 if hrs_exp==.

/* One missing year */
bysort geo: gen nobs=_n
bysort geo: gen nobs_tot=_N
count
expand 2 if nobs==16 & nobs_tot==16
gen obs=_n
replace year=. if obs>r(N)
replace hrs_exp=. if obs>r(N)
sort geo year
bysort geo: egen sum_year=sum(year)
replace year=1997 if year==. & sum_year==32088
replace year=1998 if year==. & sum_year==32087
replace year=1999 if year==. & sum_year==32086
replace year=2000 if year==. & sum_year==32085
replace year=2001 if year==. & sum_year==32084
replace year=2002 if year==. & sum_year==32083
replace year=2003 if year==. & sum_year==32082
replace year=2004 if year==. & sum_year==32081
replace year=2005 if year==. & sum_year==32080
replace year=2006 if year==. & sum_year==32079
replace year=2007 if year==. & sum_year==32078
replace year=2008 if year==. & sum_year==32077
replace year=2009 if year==. & sum_year==32076
replace year=2010 if year==. & sum_year==32075
replace year=2011 if year==. & sum_year==32074
replace year=2012 if year==. & sum_year==32073
replace year=2013 if year==. & sum_year==32072

sort geo year
replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==1997 & nobs_tot==16
replace hrs_exp=(hrs_exp[_n-1]+hrs_exp[_n+1])/2 if missing(hrs_exp) & year!=1997 & year!=2013 & nobs_tot==16
replace hrs_exp=hrs_exp[_n-1]*1.05 if missing(hrs_exp) & year==2013 & nobs_tot==16
drop nobs nobs_tot obs sum_year

/* Two missing years */
bysort geo: gen nobs=_n
bysort geo: gen nobs_tot=_N
count
expand 3 if nobs==15 & nobs_tot==15
gen obs=_n
replace year=. if obs>r(N)
replace hrs_exp=. if obs>r(N)

sort geo year
bysort geo: gen count_obs=_n+1996
gen diff_year=count_obs if year!=count_obs
bysort geo: gen year1997=1 if diff_year==1997
bysort geo: egen y1997=sum(year1997)

replace diff_year=. if year>=1998 & y1997==1
replace year=1997 if count_obs==2012 & year==. & y1997==1
drop year1997 y1997

replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==2012 & year==.
drop count_obs diff_year replace_year

sort geo year
bysort geo: gen count_obs=_n+1996
gen diff_year=count_obs if year!=count_obs
replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==2013 & year==.

sort geo year
replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==1997 & nobs_tot==15
replace hrs_exp=(hrs_exp[_n-1]+hrs_exp[_n+1])/2 if missing(hrs_exp) & year>1997 & year<2012 & nobs_tot==15
replace hrs_exp=hrs_exp[_n-1]*1.05 if missing(hrs_exp) & hrs_exp[_n+1]==. & nobs_tot==15
replace hrs_exp=(hrs_exp[_n-1]+hrs_exp[_n+1])/2 if missing(hrs_exp) & year>1997 & year<2012 & nobs_tot==15
replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & nobs_tot==15
replace hrs_exp=hrs_exp[_n-1]*1.05 if missing(hrs_exp) & nobs_tot==15
keep geo year hrs_exp

/* Three missing years */
bysort geo: gen nobs=_n
bysort geo: gen nobs_tot=_N
count
expand 4 if nobs==14 & nobs_tot==14
gen obs=_n
replace year=. if obs>r(N)
replace hrs_exp=. if obs>r(N)

sort geo year
bysort geo: gen count_obs=_n+1996
gen diff_year=count_obs if year!=count_obs
bysort geo: gen year1997=1 if diff_year==1997
bysort geo: egen y1997=sum(year1997)
replace diff_year=. if year>=1998 & y1997==1
replace year=1997 if count_obs==2011 & year==. & y1997==1
drop year1997 y1997

replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==2011 & year==.
drop count_obs diff_year replace_year

sort geo year
bysort geo: gen count_obs=_n+1996
gen diff_year=count_obs if year!=count_obs
replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==2012 & year==.
drop count_obs diff_year replace_year

sort geo year
bysort geo: gen count_obs=_n+1996
gen diff_year=count_obs if year!=count_obs
replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==2013 & year==.
sort geo year
drop count_obs diff_year replace_year

replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==1997 & nobs_tot==14
replace hrs_exp=(hrs_exp[_n-1]+hrs_exp[_n+1])/2 if missing(hrs_exp) & year>1997 & year<2012 & nobs_tot==14
replace hrs_exp=hrs_exp[_n-1]*1.05 if missing(hrs_exp) & hrs_exp[_n+1]==. & nobs_tot==14
replace hrs_exp=(hrs_exp[_n-1]+hrs_exp[_n+1])/2 if missing(hrs_exp) & year>1997 & year<2012 & nobs_tot==14
replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & nobs_tot==14
replace hrs_exp=hrs_exp[_n-1]*1.05 if missing(hrs_exp) & nobs_tot==14
keep geo year hrs_exp

/* Four missing years */
bysort geo: gen nobs=_n
bysort geo: gen nobs_tot=_N
count
expand 5 if nobs==13 & nobs_tot==13
gen obs=_n
replace year=. if obs>r(N)
replace hrs_exp=. if obs>r(N)

sort geo year
bysort geo: gen count_obs=_n+1996
gen diff_year=count_obs if year!=count_obs
bysort geo: gen year1997=1 if diff_year==1997
bysort geo: egen y1997=sum(year1997)
replace diff_year=. if year>=1998 & y1997==1
replace year=1997 if count_obs==2010 & year==. & y1997==1
drop year1997 y1997

replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==2010 & year==.
drop count_obs diff_year replace_year

sort geo year
bysort geo: gen count_obs=_n+1996
gen diff_year=count_obs if year!=count_obs
replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==2011 & year==.
drop count_obs diff_year replace_year

sort geo year
bysort geo: gen count_obs=_n+1996
gen diff_year=count_obs if year!=count_obs
replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==2012 & year==.
drop count_obs diff_year replace_year

sort geo year
bysort geo: gen count_obs=_n+1996
gen diff_year=count_obs if year!=count_obs
replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==2013 & year==.
sort geo year
drop count_obs diff_year replace_year

replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==1997 & nobs_tot==13
replace hrs_exp=(hrs_exp[_n-1]+hrs_exp[_n+1])/2 if missing(hrs_exp) & year>1997 & year<2012 & nobs_tot==13
replace hrs_exp=hrs_exp[_n-1]*1.05 if missing(hrs_exp) & hrs_exp[_n+1]==. & nobs_tot==13
replace hrs_exp=(hrs_exp[_n-1]+hrs_exp[_n+1])/2 if missing(hrs_exp) & year>1997 & year<2012 & nobs_tot==13
replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & nobs_tot==13
replace hrs_exp=hrs_exp[_n-1]*1.05 if missing(hrs_exp) & nobs_tot==13
keep geo year hrs_exp

/* Five missing years */
bysort geo: gen nobs=_n
bysort geo: gen nobs_tot=_N
count
expand 6 if nobs==12 & nobs_tot==12
gen obs=_n
replace year=. if obs>r(N)
replace hrs_exp=. if obs>r(N)

sort geo year
bysort geo: gen count_obs=_n+1996
gen diff_year=count_obs if year!=count_obs
bysort geo: gen year1997=1 if diff_year==1997
bysort geo: egen y1997=sum(year1997)
replace diff_year=. if year>=1998 & y1997==1
replace year=1997 if count_obs==2003 & year==. & y1997==1
drop year1997 y1997

replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==2009 & year==.
drop count_obs diff_year replace_year

sort geo year
bysort geo: gen count_obs=_n+1996
gen diff_year=count_obs if year!=count_obs
replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==2010 & year==.
drop count_obs diff_year replace_year

sort geo year
bysort geo: gen count_obs=_n+1996
gen diff_year=count_obs if year!=count_obs
replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==2011 & year==.
drop count_obs diff_year replace_year

sort geo year
bysort geo: gen count_obs=_n+1996
gen diff_year=count_obs if year!=count_obs
replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==2012 & year==.
drop count_obs diff_year replace_year

sort geo year
bysort geo: gen count_obs=_n+1996
gen diff_year=count_obs if year!=count_obs
replace diff_year=0 if diff_year==.
replace diff_year=diff_year-year[_n-1] if diff_year!=0
replace diff_year=. if diff_year!=1
replace diff_year=count_obs if diff_year==1
bysort geo: egen replace_year=sum(diff_year)
replace year=replace_year if count_obs==2013 & year==.
sort geo year
drop count_obs diff_year replace_year

replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & year==1997 & nobs_tot==12
replace hrs_exp=(hrs_exp[_n-1]+hrs_exp[_n+1])/2 if missing(hrs_exp) & year>1997 & year<2012 & nobs_tot==12
replace hrs_exp=hrs_exp[_n-1]*1.05 if missing(hrs_exp) & hrs_exp[_n+1]==. & nobs_tot==12
replace hrs_exp=(hrs_exp[_n-1]+hrs_exp[_n+1])/2 if missing(hrs_exp) & year>1997 & year<2012 & nobs_tot==12
replace hrs_exp=hrs_exp[_n+1]*0.95 if missing(hrs_exp) & nobs_tot==12
replace hrs_exp=hrs_exp[_n-1]*1.05 if missing(hrs_exp) & nobs_tot==12
keep geo year hrs_exp

gen cohort=year-11
gen check=substr(geo,6,10)
drop if check==""
drop if cohort<=1996
drop year check

save "$base\exposure_loc.dta", replace
*========================================================================*
use "$base\exposure_loc.dta", clear

gen geo_mun=substr(geo,1,5)
collapse (mean) hrs_exp, by(geo_mun cohort)
save "$base\exposure_mun.dta", replace
*========================================================================*
use "$base\exposure_loc.dta", clear

gen state=substr(geo,1,2)
collapse (mean) hrs_exp, by(state cohort)
rename hrs_exp hrs_exp2
save "$base\exposure_state.dta", replace
