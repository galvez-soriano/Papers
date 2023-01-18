*========================================================================*
* Working with ENLACE data
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EngInstruction/Data/New"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New"
*========================================================================*

local start=0
local end=0
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 {
	use "$base\prueba_enlace.dta", clear
	local start=`end'+1
	local end=285700*`x'
	keep in `start'/`end'
	save "$base\prueba_enlace_`x'.dta", replace
}
use "$base\prueba_enlace.dta", clear
keep in 7713901/l
save "$base\prueba_enlace_28.dta", replace
