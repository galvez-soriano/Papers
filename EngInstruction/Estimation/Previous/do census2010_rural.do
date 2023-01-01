*========================================================================*
* Mexican Census 2010 to create rural variable
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Original"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data"
*========================================================================*
use "$data\MexCensus2010.dta", clear
keep entidad mun loc pobtot
rename ent state
rename mun id_mun
rename loc id_loc
drop if id_mun=="000" | id_loc=="0000"
destring pobtot, replace
gen rural=.
replace rural=1 if pobtot<=2500
replace rural=0 if pobtot>2500
save "$base\Rural2010.dta", replace
*========================================================================*
* Mexican Census 2005 to create rural variable
*========================================================================*
use "$data\MexCensus2005.dta", clear
keep entidad mun loc p_total
rename ent state
rename mun id_mun
rename loc id_loc
drop if id_mun=="000" | id_loc=="0000"
destring p_total, replace
rename p_total pobtot05
gen rural05=.
replace rural05=1 if pobtot05<=2500
replace rural05=0 if pobtot05>2500

merge m:m state id_mun id_loc using "$base\Rural2010.dta"
drop _merge

replace rural=rural05 if rural==.
drop pobtot05 rural05 pobtot
save "$base\Rural2010.dta", replace
