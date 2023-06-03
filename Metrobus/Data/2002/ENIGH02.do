*========================================================================*
* Working with ENIGH 2002
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/Metrobus/Data/2002"
gl base= "C:\Users\iscot\Documents"
*========================================================================*
/* From CSV to DTA */
*========================================================================*
import delimited "$base\hogares.csv", clear
save "$base\hh02.dta", replace

import delimited "$base\sdem02.csv", clear
save "$base\sdem02.dta", replace

import delimited "$base\ingresos.csv", clear
save "$base\income02.dta", replace

import delimited "$base\concen.csv", clear
save "$base\shh02.dta", replace

import delimited "$base\gastos.csv", clear
save "$base\expend02.dta", replace

*========================================================================*
/* Expenditure 2002 */
*========================================================================*
use "$base\expend02.dta", clear
keep in 1/500000
save "$base\expend02_1.dta", replace

use "$base\expend02.dta", clear
keep in 500001/l
save "$base\expend02_2.dta", replace
