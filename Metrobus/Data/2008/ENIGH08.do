*========================================================================*
* Working with ENIGH 2008
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/Metrobus/Data/2006"
gl base= "C:\Users\iscot\Documents"
*========================================================================*
/* Daily Expenditure 2008 */
*========================================================================*
use "$base\dexpend08.dta", clear
keep in 1/500000
save "$base\dexpend08_1.dta", replace
use "$base\dexpend08.dta", clear
keep in 500001/l
save "$base\dexpend08_2.dta", replace
*========================================================================*
/* Expenditure 2008 */
*========================================================================*
use "$base\expend08.dta", clear
keep in 1/400000
save "$base\expend08_1.dta", replace
use "$base\expend08.dta", clear
keep in 400001/l
save "$base\expend08_2.dta", replace
*========================================================================*
/* Summary HH 2008 */
*========================================================================*
use "$base\shh08.dta", clear
keep in 1/15000
save "$base\shh08_1.dta", replace
use "$base\shh08.dta", clear
keep in 15001/l
save "$base\shh08_2.dta", replace
