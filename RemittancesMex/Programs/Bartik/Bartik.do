/* ========================================================== */
clear 
set more off
gl base = "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Data"
/* ========================================================== */
use "$base/Network_data.dta", clear

gen str geo=cve_ent + cve_mun
gen str county_id=state_FIPS + county_FIPS

keep geo county_id Rnetwork05
order geo county_id Rnetwork05

expand 4
bysort geo county_id: gen year=_n
replace year=2016 if year==1
replace year=2018 if year==2
replace year=2020 if year==3
replace year=2022 if year==4

merge m:1 county_id year using "$base/treat_counties_enigh.dta"

keep if _merge==3
drop _merge

order geo county_id year 

gen exposure= Rnetwork05*treat

collapse (sum) exposure, by(geo year)

save "$base/Bartik.dta", replace