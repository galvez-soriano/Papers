*========================================================================*
* Working with ENOE 
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/data/main/ENOE"
gl base= "C:\Users\T43969\Documents\Pensions\ENOE"
*========================================================================*
/*
local start=0
local end=0

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18{
	use "$base\COE1T112.dta", clear
	local start=`end'+1
	local end=16300*`x'
	keep in `start'/`end'
	save "$base\coe1t112_`x'.dta", replace
}

use "$base\COE1T112.dta", clear
keep in 293401/l
save "$base\coe1t112_19.dta", replace

local start=0
local end=0

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18{
	use "$base\COE1T114.dta", clear
	local start=`end'+1
	local end=16400*`x'
	keep in `start'/`end'
	save "$base\coe1t114_`x'.dta", replace
}

use "$base\COE1T114.dta", clear
keep in 295201/l
save "$base\coe1t114_19.dta", replace
*/
*========================================================================*
use "$data/2012/coe1t112_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19{
	append using "$data/2012/coe1t112_`x'.dta"
}

gen retired=p2e==2
*graph bar (mean) retired [fw=fac] if eda>=60 & eda<=70, over(eda) xline(64.87)
sum eda [fw=fac] if retired==1 & eda!>=60 & eda<=70

cumul eda [fw=fac] if retired==1 & eda>=60 & eda<=70, gen(cum_ret)
sort cum_ret
label var eda "Age"
line cum_ret eda [fw=fac] if eda>=60 & eda<=70, ylab(, grid) ///
ytitle("Cumulative of retirement") xlab(, grid) xline(64.87) ///
graphregion(fcolor(white))

*========================================================================*
use "$data/2014/coe1t114_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19{
	append using "$data/2014/coe1t114_`x'.dta"
}

gen retired=p2e==2
*graph bar (mean) retired [fw=fac] if eda>=60 & eda<=70, over(eda) xline(64.87)
sum eda [fw=fac] if retired==1 & eda!>=60 & eda<=70

cumul eda [fw=fac] if retired==1 & eda>=60 & eda<=70, gen(cum_ret)
sort cum_ret
label var eda "Age"
line cum_ret eda [fw=fac] if eda>=60 & eda<=70, ylab(, grid) ///
ytitle("Cumulative of retirement") xlab(, grid) xline(64.87) ///
graphregion(fcolor(white))
