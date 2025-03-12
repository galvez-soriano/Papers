*========================================================================*
* English program and earnings
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\IPUMS_Eng\Data"
*========================================================================*
use "$base\ipums.dta", clear
local start=0
local end=0
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 {
	use "$base\ipums.dta", clear
	local start=`end'+1
	local end=212863*`x'
	keep in `start'/`end'
	save "$base\ipums_`x'.dta", replace
}
use "$base\ipums.dta", clear
keep in 3192946/l
save "$base\ipums_16.dta", replace

