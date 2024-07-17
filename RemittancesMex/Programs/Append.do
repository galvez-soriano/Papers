*=====================================================================*
/* Paper: Income effect and labor market outcomes: The case of remittances 
		  in Mexico
   Authors: Oscar Galvez-Soriano and Hoanh Le */
*=====================================================================*
/* INSTRUCTIONS:

   Before running this program, make sure to run the following programs:
   1_2016.do
   2_2018.do
   3_2020.do
   4_2020.do
   5_treatment_migrant.do
   
   These programs stored data sets (20XX.dta) in four different folders:
   "C:\Users\Documents\Remittances\Data\2008\Bases"
   "C:\Users\Documents\Remittances\Data\2010\Bases"
   "C:\Users\Documents\Remittances\Data\2012\Bases"
   "C:\Users\Documents\Remittances\Data\2014\Bases"
   
   This program, will pull those data sets in one single database named
   "dbaseRemitt.dta". To this purpose, we must define the global "data" in 
   line 30 of this program with the path that corresponds to the user's 
   computer, right before the folders named with the years of the data 
   sets as follows:
   
   gl data="C:\Users\Documents\Remittances\Data"
   */
*=====================================================================*
gl data="C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Data"
*=====================================================================*
use "$data\2016\Bases\2016.dta", clear
append using "$data\2018\Bases\2018.dta", force
append using "$data\2020\Bases\2020.dta", force
append using "$data\2022\Bases\2022.dta", force

merge m:1 geo using "$data\migrants.dta"
drop if _merge==2
drop _merge

merge m:1 geo using "$data\mremit.dta", nogen

save "$data\dbaseRemitt.dta", replace
*=====================================================================*
use "$data\dbaseRemitt.dta", clear
local start=0
local end=0
foreach x in 1 2 3 4 5 6 7 8 {
	use "$data\dbaseRemitt.dta", clear
	local start=`end'+1
	local end=127986*`x'
	keep in `start'/`end'
	save "$data\dbaseRemitt_`x'.dta", replace
}
use "$data\dbaseRemitt.dta", clear
keep in 1023889/l
save "$data\dbaseRemitt_9.dta", replace