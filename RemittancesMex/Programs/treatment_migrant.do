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
/*
use "$data/Papers/main/EngMigration/Data/labor_census20_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 {
    append using "$data/Papers/main/EngMigration/Data/labor_census20_`x'.dta"
}
save "$base2\labor_census20.dta", replace 
*/
*========================================================================*
use "$base2\labor_census20.dta", clear

gen migrant_rural=migrant if rural==1
gen migrant_urban=migrant if rural==0

collapse migrant* [fw=factor], by(geo)

sum migrant, d
return list
gen mc=migrant>=r(p95)
label var mc "Migrant municipality (from Census)"

sum migrant_rural, d
return list
gen mcr=migrant_rural>=r(p95) & migrant_rural!=.
label var mcr "Migrant rural localities in this municipality"

sum migrant_urban, d
return list
gen mcu=migrant_urban>=r(p95) & migrant_urban!=.
label var mcu "Migrant urban localities in this municipality"

drop migrant*

save "$base\migrants.dta", replace
*========================================================================*
use "$base\2016\Bases\2016.dta", clear
append using "$base\2018\Bases\2018.dta", force
append using "$base\2020\Bases\2020.dta", force
append using "$base\2022\Bases\2022.dta", force

gen dremit=remit>0
collapse dremit [fw=weight], by(geo)

sum dremit, d
return list
gen drm=dremit>=r(p90)
label var drm "Municipality with highest remittances recipients"

drop dremit
save "$base\mremit.dta", replace