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

merge m:1 state using "$data/Papers/main/RemittancesMex/Data/ICE_Remitt/fips_aor.dta"


