*========================================================================*
/* 
Do file to clean Mexican Population database with all available years
and indicators at the municipality level.

Original source here: https://www.inegi.org.mx/app/descarga/?t=123#tabulados
 */
*========================================================================*

keep if indicador=="Población total"
drop if mun=="0"
destring year2000 year2020, replace

/* The following is optional to fill out missing in 2000 */

replace year2000= year2005*.9 if year2000==.
replace year2000= year2010*.8 if year2000==.
replace year2000= year2020*.6 if year2000==.

gen str geo=state + mun
sort geo

save "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Data\MexPop.dta", replace

*========================================================================*
/* Remittances from Banxico */
*========================================================================*

drop if geo == ""
drop if municipality=="Aguascalientes, No identificado"
drop if geo == "05039" | geo == "07120" | geo == "10040" | geo == "18021"

sort geo

merge m:1 geo using "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Data\MexPop.dta"

drop if _merge!=3
gen remitd= remittances/ year2000

keep geo remitd
duplicates drop

sum remitd, d
return list
gen treat=remitd>=r(p90)

save "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Data\RemitDensity.dta", replace