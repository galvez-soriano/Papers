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
   4_2022.do
   5_2024.do
   
   These programs stored data sets (20XX.dta) in five different folders:
   "C:\Users\Documents\Remittances\Data\2016\Bases"
   "C:\Users\Documents\Remittances\Data\2018\Bases"
   "C:\Users\Documents\Remittances\Data\2020\Bases"
   "C:\Users\Documents\Remittances\Data\2022\Bases"
   "C:\Users\Documents\Remittances\Data\2024\Bases"
   
   This program, will pull those data sets in one single database named
   "dbaseAI.dta". To this purpose, we must define the global "data" in 
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
append using "$data\2024\Bases\2024.dta", force

save "$data\dbaseAI.dta", replace
*=====================================================================*
/*
gl data="C:\Users\Oscar Galvez Soriano\Documents\Papers\AI_Productivity\Data"

use "$data\dbaseAI.dta", clear
local start=0
local end=0
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 {
	use "$data\dbaseAI.dta", clear
	local start=`end'+1
	local end=104310*`x'
	keep in `start'/`end'
	save "$data\dbaseAI_`x'.dta", replace
}
use "$data\dbaseAI.dta", clear
keep in 1356031/l
save "$data\dbaseAI_14.dta", replace
*/