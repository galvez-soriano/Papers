*========================================================================*
* English program and earnings
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Data"
*========================================================================*
use "$base\personas00.dta", clear

local start=0
local end=0
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 ///
50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 ///
75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 {
	use "$base\personas00.dta", clear
	local start=`end'+1
	local end=166600*`x'
	keep in `start'/`end'
	save "$base\personas00_`x'.dta", replace
}
use "$base\personas00.dta", clear
keep in 14994001/l
save "$base\personas00_91.dta", replace
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
*========================================================================*
use "$base\labor_census20.dta", clear
local start=0
local end=0
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 {
	use "$base\labor_census20.dta", clear
	local start=`end'+1
	local end=153036*`x'
	keep in `start'/`end'
	save "$base\labor_census20_`x'.dta", replace
}
use "$base\labor_census20.dta", clear
keep in 3672865/l
save "$base\labor_census20_25.dta", replace
