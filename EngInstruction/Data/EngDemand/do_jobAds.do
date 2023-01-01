*========================================================================*
* Working with CompuTrabajo Data 
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EngInstruction/Data/EngDemand"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\English jobs"
*========================================================================*

local start=0
local end=0
foreach x in 1 2 3 4 5 6 {
	use "$base\computrabajoFile.dta", clear
	local start=`end'+1
	local end=28500*`x'
	keep in `start'/`end'
	save "$base\computrabajoFile_`x'.dta", replace
}
use "$base\computrabajoFile.dta", clear
keep in 171001/l
save "$base\computrabajoFile_7.dta", replace


*/
*========================================================================*
use "$data/computrabajoFile_1.dta", clear
foreach x in 2 3 4 5 6 7 {
	append using "$data/computrabajoFile_`x'.dta"
}

