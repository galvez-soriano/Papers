*========================================================================*
* English program and indegenous language
*========================================================================*
* Oscar Galvez-Soriano and Ornella Darova
*========================================================================*
clear
set more off
gl base= "C:\Users\galve\Documents\Papers\Current\EngLanguage"
*========================================================================*
use "$base\labor_census10.dta", clear
local start=0
local end=0
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 {
	use "$base\labor_census10.dta", clear
	local start=`end'+1
	local end=108790*`x'
	keep in `start'/`end'
	save "$base\labor_census10_`x'.dta", replace
}
use "$base\labor_census10.dta", clear
keep in 2175801/l
save "$base\labor_census10_21.dta", replace
