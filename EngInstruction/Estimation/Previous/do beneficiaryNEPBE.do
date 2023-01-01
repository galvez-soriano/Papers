*========================================================================*
* Do file for the list of schools beneficiary of the NEPBE
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
*========================================================================*
drop N nombredelcentroeducativo municipio entidad
rename nivel level
drop if level==""
replace level="Preschool" if level=="PREESCOLAR"
replace level="Elementary" if level=="PRIMARIA" | level=="PRIMARIA " | ///
level=="Primaria"
replace level="Middle" if level!="Preschool" & level!="Elementary"
gen nepbe=1
sort cct
save "C:\Users\Oscar Galvez\Documents\Papers\Current\English on labor outcomes\Data\NPEBE\nepbe2012.dta", replace
