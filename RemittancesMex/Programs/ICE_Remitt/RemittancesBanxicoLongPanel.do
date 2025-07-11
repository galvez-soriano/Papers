*=====================================================================*
/* Paper: Remittances and US shocks 
   Authors: Oscar Galvez-Soriano and Jose Mota */
*=====================================================================*
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Doc"
*=====================================================================*
/*
sort state_name period
bysort state_name: gen time=tq(2013q1)+_n-1
format time %tq
drop period
*/
*=====================================================================*
use "$data/Papers/main/RemittancesMex/Data/ICE_Remitt/RemittUSstatesMX.dta", clear

xtset state time
gen year = yofd(dofq(time))

merge m:1 state using "$data/Papers/main/RemittancesMex/Data/ICE_Remitt/fips_aor_ss.dta"

keep if _merge==3
drop _merge

sort region year

merge m:1 region year using "$data/Papers/main/RemittancesMex/Data/ICE_Remitt/acs_mex_work.dta"

keep if _merge==3
drop _merge