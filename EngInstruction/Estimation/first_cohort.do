*========================================================================*
/* First cohort affected */
*========================================================================*
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngInstruct\Data"
*========================================================================*
use "$base\exposure_school.dta", clear

drop if cohort<=1996
drop t_eng t_colle t_mast

gen state=substr(cct,1,2)

/* Generating treatment variable */
gen treat=0
/* These three states offered a substantial amount of hours of English 
instruction in the top quartile of the distribution of hours of English
instruciton */
foreach x in 01 05 17 {
	
sum h_eng if state=="`x'", d
replace treat=1 if h_eng>=r(p75) & state=="`x'"

}
/* Similar as above but in the top 10th percentile of the distribution */
foreach x in 03 06 10 18 19 23 25 26 28 31 {
	
sum h_eng if state=="`x'", d
replace treat=1 if h_eng>=r(p90) & state=="`x'"

}
/* Similar as above but in the top 5th percentile of the distribution. These
are the states with less hours of English instruciton */
foreach x in 02 04 07 08 09 11 12 13 14 15 21 22 24 27 29 30 32 {
	
sum h_eng if state=="`x'", d
replace treat=1 if h_eng>=r(p95) & state=="`x'"

}
/* Making sure that treated schools remian treated for future cohorts */
bysort cct: replace treat=1 if treat==0 & treat[_n-1]==1 & treat[_n+1]==1
bysort cct: replace treat=1 if treat==0 & treat[_n-1]==1 & cohort==1998
bysort cct: replace treat=1 if treat==0 & treat[_n-1]==1 & cohort==1999
bysort cct: replace treat=1 if treat==0 & treat[_n-1]==1 & cohort==2000
bysort cct: replace treat=1 if treat==0 & treat[_n-1]==1 & cohort==2001
bysort cct: replace treat=1 if treat==0 & treat[_n-1]==1 & cohort==2002
/* Creating first treated variable */
gen ftreat=.
bysort cct: gen ncount=_n if treat!=0
bysort cct: replace ftreat=cohort if ncount[_n-1]==. & ncount[_n+1]>ncount & ncount!=. // this identifies the first treated cohorts but exclude never treated
bysort cct: egen first_treat = total(ftreat) // assigning the value of the first treat cohort to all observation within a school
replace first_treat=2003 if first_treat==0 // assigning the value of 2003 to never treated schools
drop ncount ftreat
/* Creatig time-relative variable */
gen K=cohort-first_treat