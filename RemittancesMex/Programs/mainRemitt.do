*=====================================================================*
/* Paper: Income effect and labor market outcomes: The case of remittances 
		  in Mexico
   Authors: Oscar Galvez-Soriano and Hoanh Le */
*=====================================================================*
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Doc"
*=====================================================================*
/*
use "$data/Papers/main/RemittancesMex/Data/dbaseRemitt_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 {
    append using "$data/Papers/main/RemittancesMex/Data/dbaseRemitt_`x'.dta"
}
save "$base\dbaseRemitt.dta", replace 
*/
*=====================================================================*
use "$base\dbaseRemitt.dta", clear