*=====================================================================*
* Type of company
*=====================================================================*
set more off
gl base="https://raw.githubusercontent.com/galvez-soriano/Data/main/ENIGH"
gl data="C:\Users\ogalvezs\Documents\SocialPensions\Data"
gl doc="C:\Users\ogalvezs\Documents\SocialPensions\Doc"
*=====================================================================*
foreach x in 08 10 12 14{
use "$base/20`x'/trabajos`x'.dta", clear
destring clas_emp, replace
gen fbusiness=clas_emp==1
keep folioviv foliohog numren fbusiness
save "$data\fbusiness`x'.dta", replace
}

foreach x in 08 10 12{
    append using "$data/fbusiness`x'.dta"
}
save "$data\fbusiness.dta", replace