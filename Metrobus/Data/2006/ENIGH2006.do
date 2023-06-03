*========================================================================*
* Working with ENIGH 2006
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/Metrobus/Data/2006"
gl base= "C:\Users\iscot\Documents"
*========================================================================*
/* Expenditure 2006 */
*========================================================================*
local start=0
local end=0
foreach x in 1 2 3{
	use "$base\expend06.dta", clear
	local start=`end'+1
	local end=337133*`x'
	keep in `start'/`end'
	save "$base\expend06_`x'.dta", replace
}
use "$base\expend06.dta", clear
keep in 1011400/l
save "$base\expend06_4.dta", replace
*========================================================================*
/* Sociodemographic 2006 */
*========================================================================*
use "$base\sdem06.dta", clear
keep in 1/40000
save "$base\sdem06_1.dta", replace
use "$base\sdem06.dta", clear
keep in 40001/l
save "$base\sdem06_2.dta", replace
