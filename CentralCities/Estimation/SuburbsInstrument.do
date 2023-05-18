*========================================================================*
* Rent Capture by Central Cities
*========================================================================*
/* Steven G. Craig, Oscar Gálvez-Soriano, Annie Hsu and Janet Kohlhase
Note: Before running this do file, please install the packages 'xtivreg2' 
and 'ivreg2' by typing the following:
ssc install ivreg2
ssc install xtivreg2 */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/annievm3m4vup/Paper-Big-Cities/main"
gl base= "C:\Users\ogalvezs\Documents\CentralCities\Base"
gl doc= "C:\Users\ogalvezs\Documents\CentralCities\Doc"
*========================================================================*
/* Merge dataset that includes city and suburb fiscal variables */
*========================================================================*
use "$data/Fin_67_17_city_linear.dta", clear
merge 1:1 year msa_sc using "$data/Fin_67_17_sub_linear.dta"
keep if _merge==3 //drop msa=26,41,43 in 1967-1971
drop _merge
keep if year>=1972
save "$base/dbaseCCities.dta", replace
*========================================================================*
/* Creating instrument */
*========================================================================*
use "$base/dbaseCCities.dta", clear
sort id_govs year
gen govs_state=substr(id_govs,1,2)
order id_govs govs_state year
keep id_govs year govs_state sb_totalrevenue sb_totaltaxes ///
sb_totalexpenditure sb_totalcurrentoper sb_totalcapitaloutlays ///
sb_basic_cur sb_transfer_cur sb_other_cur
rename sb_totalrevenue tr
rename sb_totaltaxes tt
rename sb_totalexpenditure te
rename sb_totalcurrentoper to
rename sb_totalcapitaloutlays co
rename sb_basic_cur be
rename sb_transfer_cur ta
rename sb_other_cur oe

bysort year govs_state: gen ncity=_N 
sort id_govs year ncity

bysort govs_state: gen nstate=_n
replace nstate=nstate-year+1972
replace nstate=2 if nstate==47
replace nstate=3 if nstate==93
replace nstate=4 if nstate==139
replace nstate=5 if nstate==185
replace nstate=6 if nstate==231
replace nstate=7 if nstate==277
tostring nstate, replace format(%02.0f) force
gen str idcity=govs_state+nstate

/* To see number of cities per state */
*collapse ncity, by(idcity)

reshape wide tr tt te to co be ta oe, i(id_govs year) j(idcity) string
collapse tr* tt* te* to* co* be* ta* oe*, by(year)

save "$base/SubIV.dta", replace

use "$base/dbaseCCities.dta", clear
sort id_govs year
gen govs_state=substr(id_govs,1,2)
keep id_govs year govs_state

bysort year govs_state: gen ncity=_N 
sort id_govs year
bysort govs_state: gen nstate=_n
replace nstate=nstate-year+1972
replace nstate=2 if nstate==47
replace nstate=3 if nstate==93
replace nstate=4 if nstate==139
replace nstate=5 if nstate==185
replace nstate=6 if nstate==231
replace nstate=7 if nstate==277
tostring nstate, replace format(%02.0f) force
gen str idcity=govs_state+nstate

merge m:1 year using "$base/SubIV.dta"
drop _merge
sort id_govs year

foreach i in tr tt te to co be ta oe {
	gen `i'IV=.
}
order id_govs year idcity trIV ttIV teIV toIV coIV beIV taIV oeIV
/* Filling missing variables */
*States with only two cities
foreach i in tr tt te to co be ta oe {
foreach j in 03 04 05 06 07 {
	gen `i'03`j'=.
	gen `i'06`j'=.
	gen `i'19`j'=.
	gen `i'26`j'=.
	gen `i'37`j'=.
	gen `i'39`j'=.
	gen `i'47`j'=.
	gen `i'48`j'=.
}
}
*States with only three cities
foreach i in tr tt te to co be ta oe {
foreach j in 04 05 06 07 {
	gen `i'01`j'=.
	gen `i'33`j'=.
	gen `i'34`j'=.
	gen `i'43`j'=.
}
}
*States with only four cities
foreach i in tr tt te to co be ta oe {
foreach j in 05 06 07 {
	gen `i'10`j'=.
}
}
/*States with five cities
foreach i in tr tt te to co be ta oe {
foreach j in 07 {
	gen `i'36`j'=.
	gen `i'44`j'=.
}
}*/
*States with six cities
foreach i in tr tt te to co be ta oe {
foreach j in 07 {
	gen `i'36`j'=.
}
}
foreach i in tr tt te to co be ta oe {
foreach j in 01 03 05 06 10 19 26 33 34 36 37 39 43 44 47 48 {
	egen `i'`j'=rowtotal(`i'`j'01 `i'`j'02 `i'`j'03 `i'`j'04 `i'`j'05 `i'`j'06 `i'`j'07)
}
}
/* Potentially modify this part:
Sates with only one city have as instrument all other cities. So, I create
the sum of all suburbs in my sample. I start with states having more than one 
city and I finish with states having only one city*/
foreach i in tr tt te to co be ta oe {
	egen `i'_all=rowtotal(`i'01 `i'03 `i'05 `i'06 `i'10 `i'19 `i'26 `i'33 ///
	`i'34 `i'36 `i'37 `i'39 `i'43 `i'44 `i'47 `i'48 `i'1101 `i'1401 ///
	`i'1501 `i'1601 `i'1701 `i'1801 `i'2101 `i'2201 `i'2301 `i'2401 ///
	`i'2501 `i'2801 `i'2901 `i'3201 `i'3801 `i'5001)
}
/* Substracting city i (itself) for those with more than one city */
foreach i in tr tt te to co be ta oe {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'01 - `i'01`k' if nstate=="`k'" & govs_state=="01"
}
}
foreach i in tr tt te to co be ta oe {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'03 - `i'03`k' if nstate=="`k'" & govs_state=="03"
}
}
foreach i in tr tt te to co be ta oe {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'05 - `i'05`k' if nstate=="`k'" & govs_state=="05"
}
}
foreach i in tr tt te to co be ta oe {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'06 - `i'06`k' if nstate=="`k'" & govs_state=="06"
}
}
foreach i in tr tt te to co be ta oe {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'10 - `i'10`k' if nstate=="`k'" & govs_state=="10"
}
}
foreach i in tr tt te to co be ta oe {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'10 - `i'10`k' if nstate=="`k'" & govs_state=="19"
}
}
foreach i in tr tt te to co be ta oe {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'26 - `i'26`k' if nstate=="`k'" & govs_state=="26"
}
}
foreach i in tr tt te to co be ta oe {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'33 - `i'33`k' if nstate=="`k'" & govs_state=="33"
}
}
foreach i in tr tt te to co be ta oe {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'34 - `i'34`k' if nstate=="`k'" & govs_state=="34"
}
}
foreach i in tr tt te to co be ta oe {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'36 - `i'36`k' if nstate=="`k'" & govs_state=="36"
}
}
foreach i in tr tt te to co be ta oe {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'37 - `i'37`k' if nstate=="`k'" & govs_state=="37"
}
}
foreach i in tr tt te to co be ta oe {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'39 - `i'39`k' if nstate=="`k'" & govs_state=="39"
}
}
foreach i in tr tt te to co be ta oe {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'43 - `i'43`k' if nstate=="`k'" & govs_state=="43"
}
}
foreach i in tr tt te to co be ta oe {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'44 - `i'44`k' if nstate=="`k'" & govs_state=="44"
}
}
foreach i in tr tt te to co be ta oe {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'48 - `i'48`k' if nstate=="`k'" & govs_state=="47"
}
}
foreach i in tr tt te to co be ta oe {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'48 - `i'48`k' if nstate=="`k'" & govs_state=="48"
}
}
/* Substracting city i (itself) for those with only one city */
foreach i in tr tt te to co be ta oe {
foreach j in 1101 1401 1501 1601 1701 1801 2101 2201 2301 2401 2501 2801 2901 3201 3801 5001{
    replace `i'IV=`i'_all - `i'`j' if idcity=="`j'" & `i'IV==.
}
}
/* To take the mean */
destring nstate, replace
foreach i in tr tt te to co be ta oe {
replace `i'IV=`i'IV/(nstate-1) if nstate>=2
}
/*
collapse trIV, by(idcity)
*There are 68 cities, so n=67 because I am excluding suburb i
*/
foreach i in tr tt te to co be ta oe {
replace `i'IV=`i'IV/67 if nstate==1
}
destring idcity, replace
xtset idcity year
foreach i in trIV ttIV teIV toIV coIV beIV taIV oeIV {
	 gen l`i' = log(`i')-log(L.`i')
	}
gen one_city=0
replace one_city=1 if idcity==1101 | idcity==1401 | idcity==1501 ///
 | idcity==1601 | idcity==1701 | idcity==1801 | idcity==2101 ///
 | idcity==2201 | idcity==2301 | idcity==2401 | idcity==2501 ///
 | idcity==2801 | idcity==2901 | idcity==3201 | idcity==3801 | idcity==5001

keep id_govs year trIV ttIV teIV toIV coIV beIV taIV oeIV l* one_city
save "$base/SubIV.dta", replace