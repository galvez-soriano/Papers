*========================================================================*
/* English skills and labor market outcomes in Mexico */
*========================================================================*
/* Author: Oscar Galvez-Soriano */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/ReturnsEng/Data"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\ReturnsEng\Data"
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
order soc_code10 soc_code18
bysort soc_code10: gen duplica=_N
bysort soc_code10: gen duplica2=_n
drop if duplica>1 & duplica2>1
drop duplica duplica2
bysort soc_code18: gen duplica=_N
bysort soc_code18: gen duplica2=_n
drop if duplica==2 & duplica2==2
drop duplica duplica2
/* Here, I included the categories without a match that I saved in the Excel
file sinco_soc.xls, which is in my GitHub website */
save "$base/soc10_18.dta", replace

use "$data/sinco11_soc10.dta", clear
drop sinco2011_title soc2010_title
rename soc2010 soc_code10
merge m:1 soc_code10 using "$base/soc10_18.dta"
drop if _merge!=3
drop _merge

merge m:1 soc_code18 using "$base/onet19_soc18.dta"
drop if _merge!=3
keep sinco2011 o_net_code19 o_net_n19
save "$base\sinco11_onet19.dta", replace
*========================================================================*
import delimited "$data/Handling_and_Moving_Objects.csv", clear
*gen mov_obj=importance>=50
rename importance mov_obj_s
rename code o_net_code19
keep o_net_code19 mov_obj mov_obj_s
save "$base/onet_moving_objects.dta", replace

import delimited "$data/Performing_General_Physical_Activities.csv", clear
*gen phy_act=importance>=50
rename importance phy_act_s
rename code o_net_code19
keep o_net_code19 phy_act phy_act_s
save "$base\onet_physical_activ.dta", replace

import delimited "$data/Analyzing_Data_or_Information.csv", clear
*gen analy_dta=importance>=50
rename importance analy_dta_s
rename code o_net_code19
keep o_net_code19 analy_dta analy_dta_s
save "$base\onet_analyzing.dta", replace

import delimited "$data/Communicating_with_People_Outside_the_Organization.csv", clear
*gen communica=importance>=50
rename importance communica_s
rename code o_net_code19
keep o_net_code19 communica communica_s
save "$base\onet_communicating.dta", replace

import delimited "$data/Controlling_Machines_and_Processes.csv", clear
*gen machines=importance>=50
rename importance machines_s
rename code o_net_code19
keep o_net_code19 machines machines_s
save "$base\onet_machines.dta", replace

import delimited "$data/Documenting_Recording_Information.csv", clear
*gen doc_info=importance>=50
rename importance doc_info_s
rename code o_net_code19
keep o_net_code19 doc_info doc_info_s
save "$base\onet_doc_info.dta", replace

import delimited "$data/Dynamic_Strength.csv", clear
*gen doc_info=importance>=50
rename importance dstrength_s
rename code o_net_code19
keep o_net_code19 dstrength_s
save "$base\onet_dstrength.dta", replace

import delimited "$data/Explosive_Strength.csv", clear
*gen doc_info=importance>=50
rename importance estrength_s
rename code o_net_code19
keep o_net_code19 estrength_s
save "$base\onet_estrength.dta", replace

import delimited "$data/Static_Strength.csv", clear
*gen doc_info=importance>=50
rename importance sstrength_s
rename code o_net_code19
keep o_net_code19 sstrength_s
save "$base\onet_sstrength.dta", replace
*========================================================================*
use "$data/sinco11_onet19.dta", clear

merge m:1 o_net_code19 using "$data/onet_physical_activ.dta"
drop if _merge==2
drop _merge
merge m:1 o_net_code19 using "$data/onet_moving_objects.dta"
drop if _merge==2
drop _merge
merge m:1 o_net_code19 using "$data/onet_machines.dta"
drop if _merge==2
drop _merge
merge m:1 o_net_code19 using "$data/onet_doc_info.dta"
drop if _merge==2
drop _merge
merge m:1 o_net_code19 using "$data/onet_communicating.dta"
drop if _merge==2
drop _merge
merge m:1 o_net_code19 using "$data/onet_analyzing.dta"
drop if _merge==2
drop _merge
merge m:1 o_net_code19 using "$data/onet_dstrength.dta"
drop if _merge==2
drop _merge
merge m:1 o_net_code19 using "$data/onet_estrength.dta"
drop if _merge==2
drop _merge
merge m:1 o_net_code19 using "$data/onet_sstrength.dta"
drop if _merge==2
drop _merge

gen pact = (dstrength_s+estrength_s+sstrength_s)/3

