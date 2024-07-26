*========================================================================*
* Natioanl English program and enrollment
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Doc"
*========================================================================*
/*
use "$data/Papers/main/EngInstruction/Data/Enrollment/db_enrollment_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 {
    append using "$data/Papers/main/EngInstruction/Data/Enrollment/db_enrollment_`x'.dta"
}
save "$base\db_enrollment.dta", replace 
*/
use "$base\db_enrollment.dta", clear
