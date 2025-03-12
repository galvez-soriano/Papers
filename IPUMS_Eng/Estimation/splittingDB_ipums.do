*========================================================================*
* English program and earnings
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Data"
*========================================================================*
use "$base\census20.dta", clear
local start=0
local end=0
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {
	use "$base\census20.dta", clear
	local start=`end'+1
	local end=201364*`x'
	keep in `start'/`end'
	save "$base\census20_`x'.dta", replace
}
use "$base\census20.dta", clear
keep in 3624553/l
save "$base\census20_19.dta", replace

