*========================================================================*
* Rent Capture by Central Cities
*========================================================================*
/* Steven G. Craig, Annie Hsu, Janet Kohlhase and Oscar Gálvez-Soriano
Note: Before running this do file, please install the packages 'xtivreg2' 
and 'ivreg2' by typing the following:
ssc install ivreg2
ssc install xtivreg2 */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/annievm3m4vup/Paper-Big-Cities/main"
gl base= "C:\Users\iscot\Documents\GalvezSoriano\Papers\CentralCities\Base"
gl doc= "C:\Users\iscot\Documents\GalvezSoriano\Papers\CentralCities\Doc"
*========================================================================*
/* Merge dataset that include city, suburb fiscal variables and Bartik IV */
*========================================================================*
use "$data/Fin_67_17_city_linear.dta", clear
merge 1:1 year msa_sc using "$data/Fin_67_17_sub_linear.dta"
keep if _merge==3 //drop msa=26,41,43 in 1967-1971
drop _merge
*merge 1:1 year msa_sc using "$data/Fin_67_17_sub_linear_mc2.dta", nogen
merge 1:1 year msa_sc using "$data/BartikData_CBP_version3_annual_mc.dta", nogen
*rename _merge merge1 //check msa_sc 12,18,63
merge 1:1 year msa_sc using "$data/BartikData_CBP_version3_annual_nmc.dta", nogen
*merge 1:1 year msa_sc using "$data/BartikData_CBP_version1_annual_mc.dta", nogen
*merge 1:1 year msa_sc using "$data/BartikData_CBP_version1_annual_nmc.dta", nogen
keep if year>=1990
*========================================================================*
/* Set up panel data set */
*========================================================================*
sort msa_sc year
egen panelid =group(msa_sc)
egen timeid =group(year)
xtset panelid timeid

*========================================================================*
* Running the regressions multiple Bartik instrument
*========================================================================*
/* Total Revenue */  
*========================================================================*
/* Structural equation */
eststo clear
eststo: xtreg dln_lpc_totalrevenue dln_sb_totalrevenue if B_iv_nmc1!=., fe vce(robust)
/* First stage equation */
eststo: xtreg dln_lpc_totalrevenue B_iv_nmc*, fe vce(robust)
/* Reduced form equation */
eststo: xtreg dln_lpc_totalrevenue B_iv_nmc*, fe vce(robust)
/* Second stage: IV model */
eststo: xtivreg2 dln_lpc_totalrevenue (dln_sb_totalrevenue = B_iv_nmc*), fe robust
esttab using "$doc\tab_BartikTR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(dln_sb_totalrevenue B_iv_nmc*) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Taxes */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totaltaxes dln_sb_totaltaxes if B_iv_nmc1!=., fe vce(robust)
eststo: xtreg dln_sb_totaltaxes B_iv_nmc*, fe vce(robust)
eststo: xtreg dln_lpc_totaltaxes B_iv_nmc*, fe vce(robust)
eststo: xtivreg2 dln_lpc_totaltaxes (dln_sb_totaltaxes = B_iv_nmc*), fe robust
esttab using "$doc\tab_BartikTT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(dln_sb_totaltaxes B_iv_nmc*) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalexpenditure dln_sb_totalexpenditure if B_iv_nmc1!=., fe vce(robust)
eststo: xtreg dln_sb_totalexpenditure B_iv_nmc*, fe vce(robust)
eststo: xtreg dln_lpc_totalexpenditure B_iv_nmc*, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalexpenditure (dln_sb_totalexpenditure = B_iv_nmc*), fe robust
esttab using "$doc\tab_BartikTE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(dln_sb_totalexpenditure B_iv_nmc*) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Operations */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalcurrentoper dln_sb_totalcurrentoper if B_iv_nmc1!=., fe vce(robust)
eststo: xtreg dln_sb_totalcurrentoper B_iv_nmc*, fe vce(robust)
eststo: xtreg dln_lpc_totalcurrentoper B_iv_nmc*, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalcurrentoper (dln_sb_totalcurrentoper = B_iv_nmc*), fe robust
esttab using "$doc\tab_BartikTO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(dln_sb_totalcurrentoper B_iv_nmc*) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Capital Outlays */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalcapitaloutlays dln_sb_totalcapitaloutlays if B_iv_nmc1!=., fe vce(robust)
eststo: xtreg dln_sb_totalcapitaloutlays B_iv_nmc*, fe vce(robust)
eststo: xtreg dln_lpc_totalcapitaloutlays B_iv_nmc*, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalcapitaloutlays (dln_sb_totalcapitaloutlays = B_iv_nmc*), fe robust
esttab using "$doc\tab_BartikCO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(dln_sb_totalcapitaloutlays B_iv_nmc*) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace

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
keep id_govs year govs_state sb_totalrevenue sb_totaltaxes sb_totalexpenditure sb_totalcurrentoper sb_totalcapitaloutlays
rename sb_totalrevenue tr
rename sb_totaltaxes tt
rename sb_totalexpenditure te
rename sb_totalcurrentoper to
rename sb_totalcapitaloutlays co

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

reshape wide tr tt te to co, i(id_govs year) j(idcity) string
collapse tr* tt* te* to* co*, by(year)

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

foreach i in tr tt te to co {
	gen `i'IV=.
}
order id_govs year idcity trIV ttIV teIV toIV coIV
/* Filling missing variables */
*States with only two cities
foreach i in tr tt te to co {
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
foreach i in tr tt te to co {
foreach j in 04 05 06 07 {
	gen `i'01`j'=.
	gen `i'33`j'=.
	gen `i'34`j'=.
	gen `i'43`j'=.
}
}
*States with only four cities
foreach i in tr tt te to co {
foreach j in 05 06 07 {
	gen `i'10`j'=.
}
}
/*States with five cities
foreach i in tr tt te to co {
foreach j in 07 {
	gen `i'36`j'=.
	gen `i'44`j'=.
}
}*/
*States with six cities
foreach i in tr tt te to co {
foreach j in 07 {
	gen `i'36`j'=.
}
}
foreach i in tr tt te to co {
foreach j in 01 03 05 06 10 19 26 33 34 36 37 39 43 44 47 48 {
	egen `i'`j'=rowtotal(`i'`j'01 `i'`j'02 `i'`j'03 `i'`j'04 `i'`j'05 `i'`j'06 `i'`j'07)
}
}
/* Potentially modify this part:
Sates with only one city have as instrument all other cities. So, I create
the sum of all suburbs in my sample. I start with states having more than one 
city and I finish with states having only one city*/
foreach i in tr tt te to co {
	egen `i'_all=rowtotal(`i'01 `i'03 `i'05 `i'06 `i'10 `i'19 `i'26 `i'33 ///
	`i'34 `i'36 `i'37 `i'39 `i'43 `i'44 `i'47 `i'48 `i'1101 `i'1401 ///
	`i'1501 `i'1601 `i'1701 `i'1801 `i'2101 `i'2201 `i'2301 `i'2401 ///
	`i'2501 `i'2801 `i'2901 `i'3201 `i'3801 `i'5001)
}
*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<==================================== I stopped HERE!!!
/* Substracting city i (itself) for those with more than one city */
foreach i in tr tt te to co {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'01 - `i'01`k' if nstate=="`k'" & govs_state=="01"
}
}
foreach i in tr tt te to co {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'03 - `i'03`k' if nstate=="`k'" & govs_state=="03"
}
}
foreach i in tr tt te to co {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'05 - `i'05`k' if nstate=="`k'" & govs_state=="05"
}
}
foreach i in tr tt te to co {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'06 - `i'06`k' if nstate=="`k'" & govs_state=="06"
}
}
foreach i in tr tt te to co {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'10 - `i'10`k' if nstate=="`k'" & govs_state=="10"
}
}
foreach i in tr tt te to co {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'10 - `i'10`k' if nstate=="`k'" & govs_state=="19"
}
}
foreach i in tr tt te to co {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'26 - `i'26`k' if nstate=="`k'" & govs_state=="26"
}
}
foreach i in tr tt te to co {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'33 - `i'33`k' if nstate=="`k'" & govs_state=="33"
}
}
foreach i in tr tt te to co {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'34 - `i'34`k' if nstate=="`k'" & govs_state=="34"
}
}
foreach i in tr tt te to co {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'36 - `i'36`k' if nstate=="`k'" & govs_state=="36"
}
}
foreach i in tr tt te to co {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'37 - `i'37`k' if nstate=="`k'" & govs_state=="37"
}
}
foreach i in tr tt te to co {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'39 - `i'39`k' if nstate=="`k'" & govs_state=="39"
}
}
foreach i in tr tt te to co {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'43 - `i'43`k' if nstate=="`k'" & govs_state=="43"
}
}
foreach i in tr tt te to co {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'44 - `i'44`k' if nstate=="`k'" & govs_state=="44"
}
}
foreach i in tr tt te to co {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'48 - `i'48`k' if nstate=="`k'" & govs_state=="47"
}
}
foreach i in tr tt te to co {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'48 - `i'48`k' if nstate=="`k'" & govs_state=="48"
}
}
/* Substracting city i (itself) for those with only one city */
foreach i in tr tt te to co {
foreach j in 1101 1401 1501 1601 1701 1801 2101 2201 2301 2401 2501 2801 2901 3201 3801 5001{
    replace `i'IV=`i'_all - `i'`j' if idcity=="`j'" & `i'IV==.
}
}
/* To take the mean */
destring nstate, replace
foreach i in tr tt te to co {
replace `i'IV=`i'IV/(nstate-1) if nstate>=2
}
/*
collapse trIV, by(idcity)
*There are 68 cities, so n=67 because I am excluding suburb i
*/
foreach i in tr tt te to co {
replace `i'IV=`i'IV/67 if nstate==1
}
destring idcity, replace
xtset idcity year
foreach i in trIV ttIV teIV toIV coIV {
	 gen l`i' = log(`i')-log(L.`i')
	}
keep id_govs year trIV ttIV teIV toIV coIV l*
save "$base/SubIV.dta", replace
*========================================================================*
/* Set up panel data set */
*========================================================================*
use "$base/dbaseCCities.dta", clear
sort id_govs year
merge 1:1 id_govs year using "$base/SubIV.dta"
drop _merge
sort msa_sc year
order id_govs year
egen panelid =group(msa_sc)
egen timeid =group(year)
xtset panelid timeid
*========================================================================*
* Running the regressions with spending from other suburbs as instrument
*========================================================================*
/* Total Revenue */  
*========================================================================*
/* Structural equation */
eststo clear
eststo: xtreg dln_lpc_totalrevenue dln_sb_totalrevenue if ltrIV!=., fe vce(robust)
/* First stage equation */
eststo: xtreg dln_lpc_totalrevenue ltrIV, fe vce(robust)
/* Reduced form equation */
eststo: xtreg dln_lpc_totalrevenue ltrIV, fe vce(robust)
/* Second stage: IV model */
eststo: xtivreg2 dln_lpc_totalrevenue (dln_sb_totalrevenue = ltrIV), fe robust
esttab using "$doc\tab_IV_TR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(dln_sb_totalrevenue ltrIV) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Taxes */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totaltaxes dln_sb_totaltaxes if lttIV!=., fe vce(robust)
eststo: xtreg dln_sb_totaltaxes lttIV, fe vce(robust)
eststo: xtreg dln_lpc_totaltaxes lttIV, fe vce(robust)
eststo: xtivreg2 dln_lpc_totaltaxes (dln_sb_totaltaxes = lttIV), fe robust
esttab using "$doc\tab_IV_TT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(dln_sb_totaltaxes lttIV) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalexpenditure dln_sb_totalexpenditure if lteIV!=., fe vce(robust)
eststo: xtreg dln_sb_totalexpenditure lteIV, fe vce(robust)
eststo: xtreg dln_lpc_totalexpenditure lteIV, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalexpenditure (dln_sb_totalexpenditure = lteIV), fe robust
esttab using "$doc\tab_IV_TE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(dln_sb_totalexpenditure lteIV) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Operations */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalcurrentoper dln_sb_totalcurrentoper if ltoIV!=., fe vce(robust)
eststo: xtreg dln_sb_totalcurrentoper ltoIV, fe vce(robust)
eststo: xtreg dln_lpc_totalcurrentoper ltoIV, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalcurrentoper (dln_sb_totalcurrentoper = ltoIV), fe robust
esttab using "$doc\tab_IV_TO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(dln_sb_totalcurrentoper ltoIV) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Capital Outlays */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalcapitaloutlays dln_sb_totalcapitaloutlays if lcoIV!=., fe vce(robust)
eststo: xtreg dln_sb_totalcapitaloutlays lcoIV, fe vce(robust)
eststo: xtreg dln_lpc_totalcapitaloutlays lcoIV, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalcapitaloutlays (dln_sb_totalcapitaloutlays = lcoIV), fe robust
esttab using "$doc\tab_IV_CO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(dln_sb_totalcapitaloutlays lcoIV) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
