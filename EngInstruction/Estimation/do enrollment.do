*========================================================================*
clear
set more off
gl dbase= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngEnrollment\Data"
*========================================================================*
use "$dbase\enlace_planea_c2020_2022.dta", clear
drop if level==2
keep if year>=2009

keep curp p_esp p_mat grado cct year cohort grado_max passed_secondary
order curp cct year cohort grado
gen maths5= p_mat if grado==5
gen spans5= p_esp if grado==5
gen maths6= p_mat if grado==6
gen spans6= p_esp if grado==6

rename grado_max edu 

replace maths5=0 if maths5==.
replace maths6=0 if maths6==.
replace spans5=0 if spans5==.
replace spans6=0 if spans6==.

collapse (sum) maths* spans* (mean) edu passed_secondary cohort, by(curp cct)

egen sums=rowtotal(maths5 spans5 maths6 spans6)
drop if sums==0

egen id = group(curp)
drop curp sums
order id

duplicates drop id, force

save "$dbase\db_enrollment.dta", replace
*========================================================================*
use "$dbase\db_enrollment.dta", clear
local start=0
local end=0
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 {
	use "$dbase\db_enrollment.dta", clear
	local start=`end'+1
	local end=409413*`x'
	keep in `start'/`end'
	save "$dbase\db_enrollment_`x'.dta", replace
}
use "$dbase\db_enrollment.dta", clear
keep in 4912957/l
save "$dbase\db_enrollment_13.dta", replace