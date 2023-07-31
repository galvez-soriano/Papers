*========================================================================*
/* English skills and labor market outcomes in Mexico */
*========================================================================*
/* Author: Oscar Galvez-Soriano */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/ReturnsEng/Data"
gl base= "C:\Users\galve\Documents\Papers\Current\Returns to Eng Mex\Data"
*========================================================================*
/* O*Net and SOC */
*========================================================================*
use "$data/onet19_soc18.dta", clear
order o_net_code19 soc_code18
bysort soc_code18: gen duplica=_N
bysort soc_code18: gen duplica2=_n
drop if duplica>1 & duplica2>1
drop duplica duplica2
save "$base/onet19_soc18.dta", replace

use "$data/soc10_18.dta", clear
order soc_code10 soc_code18
bysort soc_code10: gen duplica=_N
bysort soc_code10: gen duplica2=_n
drop if duplica>1 & duplica2>1
drop duplica duplica2
bysort soc_code18: gen duplica=_N
bysort soc_code18: gen duplica2=_n
drop if duplica==2 & duplica2==2
drop duplica duplica2
save "$base/soc10_18.dta", replace
