*========================================================================*
/* English skills and labor market outcomes in Mexico */
*========================================================================*
/* Authors: Oscar Galvez-Soriano and Ornella Darova */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/ReturnsEng/Data"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\AI_Productivity\Data"
*========================================================================*
/* O*Net and SOC */
*========================================================================*
use "$data/onet19_soc18.dta", clear
order o_net_code19 soc_code18
bysort soc_code18: gen duplica=_N
bysort soc_code18: gen duplica2=_n
drop if duplica>1 & duplica2>1
drop duplica duplica2
save "$base/onet19_soc18.dta", replace

use "$data/soc10_18.dta", clear
/*order soc_code10 soc_code18
bysort soc_code10: gen duplica=_N
bysort soc_code10: gen duplica2=_n
drop if duplica>1 & duplica2>1
drop duplica duplica2
bysort soc_code18: gen duplica=_N
bysort soc_code18: gen duplica2=_n
drop if duplica==2 & duplica2==2
drop duplica duplica2*/
/* Here, I included the categories without a match that I saved in the Excel
file sinco_soc.xls, which is in my GitHub website */
save "$base/soc10_18.dta", replace

use "$data/sinco11_soc10.dta", clear
drop if sinco2011==9999

drop sinco2011_title soc2010_title
rename soc2010 soc_code10
merge m:1 soc_code10 using "$base/soc10_18.dta"

/*replace soc_code18=soc_code18[_n-1] if sinco2011==1511
replace soc_code18=soc_code18[_n+1] if sinco2011==1423
replace soc_code18="19-1013" if sinco2011==2234
replace soc_n18="Soil and Plant Scientists" if sinco2011==2234
replace soc_code18=soc_code18[_n+1] if sinco2011==7343
*/

drop if _merge!=3
drop _merge

merge m:1 soc_code18 using "$base/onet19_soc18.dta"
drop if _merge!=3
keep sinco2011 o_net_code19 o_net_n19 soc_code10 soc_code18
rename sinco2011 sinco
save "$base\sinco11_onet19.dta", replace
*========================================================================*
/* Database to merge with Polulation Census */
*========================================================================*
use "$base\sinco11_onet19.dta", clear

merge m:1 soc_code18 using "$base/soc_AI.dta"
drop if _merge==2
drop _merge

merge m:1 o_net_code19 using "$base/computer_AI.dta"
drop if _merge==2
drop _merge
/*
replace computer_ai = 50 in 5
replace computer_ai = ((aioe+2.67)/(1.482+2.67))*100
replace computer_ai=70 if o_net_n19=="Entertainment and Recreation Managers, Except Gambling"
replace aioe=(computer_ai/100)*(1.482+2.67)-2.67 if o_net_n19=="Entertainment and Recreation Managers, Except Gambling"
replace computer_ai = 65 in 45
replace computer_ai = 85 in 51
replace computer_ai = 99 in 58
replace computer_ai = 95 in 59
replace computer_ai = 90 in 60
replace computer_ai = 90 in 61
replace computer_ai=80 if o_net_n19=="Calibration Technologists and Technicians"
replace computer_ai=80 if o_net_n19=="Environmental Science and Protection Technicians, Including Health"
replace computer_ai=80 if o_net_n19=="Agricultural Technicians"
replace computer_ai = 10 in 105
replace computer_ai = 5 in 110
replace computer_ai = 50 in 116
replace computer_ai=50 if o_net_n19=="Teaching Assistants, Postsecondary"
replace computer_ai = 80 in 154

replace aioe=(computer_ai/100)*(1.482+2.67)-2.67 if aioe==.
*/
save "$base\ai_occupations.dta", replace