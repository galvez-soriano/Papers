*========================================================================*
* English program and indegenous language
*========================================================================*
* Oscar Galvez-Soriano and Raymundo Ramirez
*========================================================================*
clear
set more off
gl base= "C:\Users\ogalvez\OneDrive - The University of Chicago\Documents\Papers\UniversalizationPAM"
*========================================================================*
use "$base\dbasePAM.dta", clear
local start=0
local end=0
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 ///
21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 {
	use "$base\dbasePAM.dta", clear
	local start=`end'+1
	local end=38440*`x'
	keep in `start'/`end'
	save "$base\dbasePAM_`x'.dta", replace
}
use "$base\dbasePAM.dta", clear
keep in 1422281/l
save "$base\dbasePAM_38.dta", replace

*========================================================================*
/*
*Run this section of the code only once to pull the data from the 
*GitHub website. Once the data is stored in your computer, you can
*run this code without downloading the data again.

use "$data/Papers/main/EngMigration/Data/labor_census20_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 {
    append using "$data/Papers/main/EngMigration/Data/labor_census20_`x'.dta"
}
save "$base\labor_census20.dta", replace 
*/