*=====================================================================*
/* Paper: Remittances and US shocks 
   Authors: Oscar Galvez-Soriano and Jose Mota */
*=====================================================================*
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Doc"
*=====================================================================*
/*
sort state_name period
bysort state_name: gen time=tq(2013q1)+_n-1
format time %tq
drop period
*/
/*
use "$data/Papers/main/RemittancesMex/Data/ICE_Remitt/ice_combined_fy12-23ytd.dta", clear
keep if aor!=""
drop if gender=="Unknown"
drop if gender=="UNKNOWN"
drop if gender==""
drop if year<2013

merge m:1 aor using "$data/Papers/main/RemittancesMex/Data/ICE_Remitt/fips_aor_ss_AOR.dta"
drop if _merge!=3
drop _merge year quarter
rename yq time

replace gender="M" if gender=="Male"
replace gender="F" if gender=="Female"

collapse (sum) arrests encounters removals, by(time gender region)

reshape wide arrests encounters removals, i(time region) j(gender) string
save "$base\ICE_data_year_region.dta", replace
*/
*=====================================================================*
/*
use "$data/Papers/main/RemittancesMex/Data/ICE_Remitt/RemittUSstatesMX.dta", clear

xtset state time
gen year = yofd(dofq(time))

merge m:1 state using "$data/Papers/main/RemittancesMex/Data/ICE_Remitt/fips_aor_ss.dta"
keep if _merge==3
drop _merge

sort region year

merge m:1 region year using "$data/Papers/main/RemittancesMex/Data/ICE_Remitt/acs_mex_work.dta"
keep if _merge==3
drop _merge

collapse remittances mexicans workers mexicansF mexicansM workersF workersM, by(time region)

merge 1:1 time region using "$data/Papers/main/RemittancesMex/Data/ICE_Remitt/ICE_data_year_region.dta"
keep if _merge==3
drop _merge

gen remitt_mex=(remittances/mexicans)*1000000

gen arrests_mexM=arrestsM/mexicansM
gen arrests_mexF=arrestsF/mexicansF

gen encounters_mexM=encountersM/mexicansM
gen encounters_mexF=encountersF/mexicansF

gen removals_mexM=removalsM/mexicansM
gen removals_mexF=removalsF/mexicansF

gen arrests_mex=(arrestsM+arrestsF)/mexicans
gen encounters_mex=(encountersM+encountersF)/mexicans
gen removals_mex=(removalsM+removalsF)/mexicans

egen id = group(region)

save "$base\ICE_DBase.dta", replace
*/
*=====================================================================*
use "$data/Papers/main/RemittancesMex/Data/ICE_Remitt/ICE_DBase.dta", clear

reg remitt_mex arrests_mex [aw=workers], vce(cluster region)
reg remitt_mex encounters_mex [aw=workers], vce(cluster region)
reg remitt_mex removals_mex [aw=workers], vce(cluster region)

reg remitt_mex arrests_mex encounters_mex removals_mex [aw=workers], vce(cluster region)


areg remitt_mex arrests_mex [aw=workers], absorb(region) vce(cluster region)
areg remitt_mex encounters_mex [aw=workers], absorb(region) vce(cluster region)
areg remitt_mex removals_mex [aw=workers], absorb(region) vce(cluster region)

areg remitt_mex arrests_mex encounters_mex removals_mex [aw=workers], absorb(region) vce(cluster region)


areg remitt_mex arrests_mex i.id [aw=workers], absorb(time) vce(cluster region)
areg remitt_mex encounters_mex i.id [aw=workers], absorb(time) vce(cluster region)
areg remitt_mex removals_mex i.id [aw=workers], absorb(time) vce(cluster region)

areg remitt_mex arrests_mex encounters_mex removals_mex i.id [aw=workers], absorb(time) vce(cluster region)



areg remitt_mex arrests_mexM encounters_mexM removals_mexM i.id [aw=workersM], absorb(time) vce(cluster region)

areg remitt_mex arrests_mexF encounters_mexF removals_mexF i.id [aw=workersF], absorb(time) vce(cluster region)