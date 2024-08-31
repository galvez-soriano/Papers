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

save "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Data\MexPop.dta"