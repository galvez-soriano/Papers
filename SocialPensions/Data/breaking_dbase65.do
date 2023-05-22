*========================================================================*
/* Breaking master database into small files */
*========================================================================*
/* Oscar Galvez-Soriano */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/SocialPensions/Data"
gl base= "C:\Users\iscot\Documents\GalvezSoriano\Papers\Pensions\Data"
*========================================================================*
/* To break it */
*========================================================================*
local start=0
local end=0
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 {
	use "$base\dbase65.dta", clear
	local start=`end'+1
	local end=61570*`x'
	keep in `start'/`end'
	save "$base\dbase`x'.dta", replace
}
use "$base\dbase65.dta", clear
keep in 861981/l
save "$base\dbase15.dta", replace
*========================================================================*
/* To append it back */
*========================================================================*
use "$base/dbase1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14{
    append using "$base/dbase`x'.dta"
}
save "$data\dbase65.dta", replace
