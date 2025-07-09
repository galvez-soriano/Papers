*========================================================================*
/* Using population census to determine municipalities with migrants */
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base2= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Data"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Data"
*========================================================================*
use "$base\Remit1622.dta", clear

merge 1:1 mun_name using "$base\mun_name_code.dta"
keep if _merge==3
drop _merge

reshape long remittan, i(geo) j(year)
keep geo year remittan 

save "$base\RemitYear1622.dta", replace