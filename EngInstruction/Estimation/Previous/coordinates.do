*========================================================================*
/* Creating coordinates database */
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New"
*========================================================================*
/* Census 2010 */
*========================================================================*
use "$data\Census\coordinates10.dta", clear

gen str geo_mun=cve_ent + cve_mun
keep if cve_loc=="0001"
keep geo_mun lat_decimal lon_decimal altitud
order geo_mun lat_decimal lon_decimal altitud
rename lat_decimal latitude
rename lon_decimal longitude
rename altitud altitude
destring latitude longitude altitude, replace

*save "$base\coord_mex.dta", replace
*========================================================================*
/* Census 2020 */
*========================================================================*
use "$data\Census\coordinates20.dta", clear

gen str geo_mun=cve_ent + cve_mun
keep if cve_loc=="0001"
keep geo_mun lat_decimal lon_decimal altitud
order geo_mun lat_decimal lon_decimal altitud
rename lat_decimal latitude
rename lon_decimal longitude
rename altitud altitude
destring latitude longitude altitude, replace

save "$base\coord_mex.dta", replace
*========================================================================*
cd "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Census"
unicode analyze coordinates20.dta
unicode encoding set ISO-8859-1
unicode translate coordinates20.dta*

use "$data\Census\coordinates20.dta", clear
rename nom_loc loc
replace loc= ustrlower( ustrregexra( ustrnormalize( loc, "nfd" ) , "\p{Mark}", "" )  )
save "$data\Census\coordinates20.dta", replace
