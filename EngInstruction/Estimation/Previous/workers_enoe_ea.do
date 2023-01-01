*========================================================================*
* Impact of English instruction on labor market outcomes
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Ideas\Education\SM English\Data\Original"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Exports"
gl doc= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Doc"
*========================================================================*
* Counting number of workers by economic industry
*========================================================================*
foreach x in 18 19{
foreach i in 1 2 3 4{
use "$data\coe1t`i'`x'.dta", clear
foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}
gen workers`i'`x'=1
collapse (sum) workers`i'`x' [fw=fac], by(p4a)
merge 1:1 p4a using "$base\workers_enoe.dta"
drop _merge
save "$base\workers_enoe.dta", replace
}
}
local vars "workers118 workers218 workers318 workers418 workers119 workers219 workers319 workers419"
egen n_workers = rmean(`vars')
rename p4a naics
drop workers*
replace naics = 3390 in 44
save "$base\workers_enoe.dta", replace
*========================================================================*
use "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EngInstruction/x_share.dta", clear
gen naics=substr(es_id,1,3)
replace naics=naics+"0"
destring naics, replace
replace naics = 3399 in 86
merge m:m naics using "$base\workers_enoe.dta"
keep if _merge==3
drop _merge
gen weight=round(n_workers)
gen share_w=1 if x_share>0.2 & n_workers>581244
replace share_w=0 if share_w==.
format n_workers %9.0fc

label var x_share "Export share"
histogram x_share, fraction fcolor(none) lcolor(black) graphregion(fcolor(white)) ///
xline(0.2, lstyle(grid) lpattern(dash) lcolor(red))
graph export "$doc\graph_Xshare.png", replace

replace n_workers=n_workers/1000
label var n_workers "Number of workers (thousands)"
histogram n_workers, fraction fcolor(none) lcolor(black) graphregion(fcolor(white)) ///
xline(581, lstyle(grid) lpattern(dash) lcolor(red))
graph export "$doc\graph_Nworkers.png", replace
