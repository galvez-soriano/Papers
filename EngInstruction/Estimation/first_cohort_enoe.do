*========================================================================*
/* First cohort affected */
*========================================================================*
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngInstruct\Data"
*========================================================================*
/* For ENOE only */
use "$base\d_schools.dta", clear

gen str geo_mun_s=(state + id_mun)
drop if public==0
drop if fts==1
keep if shift==1
keep if year==2011
destring geo_mun_s, replace
collapse geo_mun, by(cct)
tostring geo_mun, replace format(%05.0f)

save "$base\cct_geo.dta", replace
*========================================================================*
/* For ENOE */ 
*========================================================================*
use "$base\exposure_school.dta", clear

drop if cohort<=1996
drop t_eng t_colle t_mast

gen state=substr(cct,1,2)

merge m:1 cct using "$base\cct_geo.dta"
drop if _merge!=3
drop _merge
collapse h_eng, by(state geo_mun_s cohort)

/* Generating treatment variable */
gen treat=0
/* These three states offered a substantial amount of hours of English 
instruction in the top quartile of the distribution of hours of English
instruciton */
foreach x in 03 04 06 11 12 15 19 23 24 26 31 {
	
sum h_eng if state=="`x'", d
replace treat=1 if h_eng>=r(p75) & state=="`x'"

}
/* Similar as above but in the top 10th percentile of the distribution */
foreach x in 10 18 22 29 30 32 {
	
sum h_eng if state=="`x'", d
replace treat=1 if h_eng>=r(p90) & state=="`x'"

}
/* Similar as above but in the top 5th percentile of the distribution. These
are the states with less hours of English instruciton */
foreach x in 07 08 09 13 14 21 27 {
	
sum h_eng if state=="`x'", d
replace treat=1 if h_eng>=r(p95) & state=="`x'"

}
/* Similar as above but in the top 50th percentile of the distribution. These
are the states with less hours of English instruciton */
foreach x in 01 02 05 17 25 28 {
	
sum h_eng if state=="`x'", d
replace treat=1 if h_eng>=r(p50) & state=="`x'"

}
/* Making sure that treated schools remian treated for future cohorts */
bysort geo_mun_s: replace treat=1 if treat==0 & treat[_n-1]==1 & treat[_n+1]==1
bysort geo_mun_s: replace treat=1 if treat==0 & treat[_n-1]==1 & cohort==1998
bysort geo_mun_s: replace treat=1 if treat==0 & treat[_n-1]==1 & cohort==1999
bysort geo_mun_s: replace treat=1 if treat==0 & treat[_n-1]==1 & cohort==2000
bysort geo_mun_s: replace treat=1 if treat==0 & treat[_n-1]==1 & cohort==2001
bysort geo_mun_s: replace treat=1 if treat==0 & treat[_n-1]==1 & cohort==2002
/* Creating first treated variable */
gen ftreat=.
bysort geo_mun_s: gen ncount=_n if treat!=0
bysort geo_mun_s: replace ftreat=cohort if ncount[_n-1]==. & ncount[_n+1]>ncount & ncount!=. // this identifies the first treated cohorts but exclude never treated
bysort geo_mun_s: egen first_treat = total(ftreat) // assigning the value of the first treat cohort to all observation within a school
replace first_treat=2003 if first_treat==0 // assigning the value of 2003 to never treated schools
drop ncount ftreat
/* Creatig time-relative variable */
gen K=cohort-first_treat
*========================================================================*
/* For ENOE */
rename geo_mun_s geo1a
keep treat first_treat K cohort geo1a h_eng
order geo1a cohort 
*========================================================================*
save "$base\treatment_mun_enoe.dta", replace