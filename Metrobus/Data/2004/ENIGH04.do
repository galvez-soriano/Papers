*========================================================================*
* Working with ENIGH 2004
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/Metrobus/Data/2004"
gl base= "C:\Users\iscot\Documents"
*========================================================================*
/* From CSV to DTA */
*========================================================================*
import delimited "$base\hogares.csv", clear
rename ïfolio folio
save "$base\hh04.dta", replace

import delimited "$base\sdem04.csv", clear
save "$base\sdem04.dta", replace

import delimited "$base\ingresos.csv", clear
save "$base\income04.dta", replace

import delimited "$base\concen.csv", clear
save "$base\shh04.dta", replace

import delimited "$base\gastos.csv", clear
save "$base\expend04.dta", replace

*========================================================================*
/* Expenditure 2004 */
*========================================================================*
local start=0
local end=0
foreach x in 1 2{
	use "$base\expend04.dta", clear
	local start=`end'+1
	local end=349525*`x'
	keep in `start'/`end'
	save "$base\expend04_`x'.dta", replace
}
use "$base\expend04.dta", clear
keep in 699051/l
save "$base\expend04_3.dta", replace
