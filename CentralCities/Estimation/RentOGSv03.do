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
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/CentralCities/Data"
gl base= "C:\Users\ogalvezs\Documents\CentralCities\Base"
gl doc= "C:\Users\ogalvezs\Documents\CentralCities\Doc"
*========================================================================*
/* Merge dataset that include city, suburb fiscal variables and Bartik IV */
*========================================================================*
use "$data/Master_Fin_70_17_city.dta", clear
merge 1:1 year msa_sc using "$data/Master_Fin_70_17_sub.dta", nogen
merge 1:1 year msa_sc using "$data/BartikData_version3_mc.dta"
keep if _merge==3
drop _merge
merge 1:1 year msa_sc using "$data/BartikData_version3_nmc.dta"
drop if _merge==2
drop _merge
merge 1:1 year msa_sc using "$data/tradevars_final_msa_mc.dta"
drop if _merge==2
drop _merge
merge 1:1 year msa_sc using "$data/tradevars_final_msa_nmc.dta"
drop if _merge==2
drop _merge
merge 1:1 year msa_sc using "$data/BartikData_version1_mc.dta"
drop if _merge==2
drop _merge 
merge 1:1 year msa_sc using "$data/BartikData_version1_nmc.dta"
drop if _merge==2
rename B_iv_nmc B_iv
replace B_iv=B_iv_mc if B_iv==.
drop _merge dX_it_* B_iv_mc
*========================================================================*
/* Generate intergovernmental transfer revenue into three categories: basic, 
transfer, other */
*========================================================================*
bysort year msa_sc: gen basic_level=(fedigrhighways_rpc+fedigrnaturalres_rpc ///
+stateigrhighways_rpc)
bysort year msa_sc: gen transfer_level=(fedigrhealthhos_rpc+fedigrhouscomdev_rpc ///
+fedigrpublicwelf_rpc+stateigrhealthhos_rpc+stateigrhouscomdev_rpc+stateigrpublicwelf_rpc)
bysort year msa_sc: gen other_level=(fedigrairtransport_rpc+fedigreducation_rpc ///
+fedigrempsecadm_rpc+fedigrgensupport_rpc+fedigrsewerage_rpc+fedigrother_rpc ///
+stateigreducation_rpc+stateigrothgensup_rpc+stateigrsewerage_rpc+stateigrother_rpc)

foreach x in 1 2 3 4 5 6 7 8 9 {
rename B_iv_nmc_`x' B_iv_`x'
replace B_iv_`x'=B_iv_mc_`x' if B_iv_`x'==.
drop B_iv_mc_`x' 
}
/* Trade variables */
rename d_usch_msanmc d_usch_pw
rename d_otch_lag_msanmc d_otch_pw
replace d_usch_pw=d_usch_msamc if d_usch_pw==.
replace d_otch_pw=d_otch_lag_msamc if d_otch_pw==.

save "$base/dbaseCCities.dta", replace
*========================================================================*
/* Set up panel data set */
*========================================================================*
use "$base/dbaseCCities.dta", clear
drop if year==1980
sort id_govs year
keep id_govs year govs_state namecity totalrevenue_rsbpc totaltaxes_rsbpc totalexpenditure_rsbpc totalcurrentoper_rsbpc totalcapitaloutlays_rsbpc
rename totalrevenue_rsbpc tr
rename totaltaxes_rsbpc tt
rename totalexpenditure_rsbpc te
rename totalcurrentoper_rsbpc to
rename totalcapitaloutlays_rsbpc co

bysort year govs_state: gen ncity=_N
sort id_govs year
bysort govs_state: gen nstate=_n
replace nstate=nstate-year+1990
replace nstate=2 if nstate==19
replace nstate=3 if nstate==37
replace nstate=4 if nstate==55
replace nstate=5 if nstate==73
replace nstate=6 if nstate==91
replace nstate=7 if nstate==109
tostring nstate, replace format(%02.0f) force
gen str idcity=govs_state+nstate

reshape wide tr tt te to co, i(id_govs year) j(idcity) string
collapse tr* tt* te* to* co*, by(year)

save "$base/SubIV.dta", replace

use "$base/dbaseCCities.dta", clear
drop if year==1980
sort id_govs year
keep id_govs year govs_state namecity 

bysort year govs_state: gen ncity=_N
sort id_govs year
bysort govs_state: gen nstate=_n
replace nstate=nstate-year+1990
replace nstate=2 if nstate==19
replace nstate=3 if nstate==37
replace nstate=4 if nstate==55
replace nstate=5 if nstate==73
replace nstate=6 if nstate==91
replace nstate=7 if nstate==109
tostring nstate, replace format(%02.0f) force
gen str idcity=govs_state+nstate

merge m:1 year using "$base/SubIV.dta"
drop _merge
sort id_govs year

foreach i in tr tt te to co {
	gen `i'IV=.
}
order id_govs year idcity trIV ttIV teIV toIV coIV
foreach i in tr tt te to co {
foreach j in 03 04 05 06 07 {
	gen `i'01`j'=.
	gen `i'03`j'=.
	gen `i'06`j'=.
	gen `i'26`j'=.
	gen `i'37`j'=.
	gen `i'39`j'=.
	gen `i'48`j'=.
}
}
foreach i in tr tt te to co {
foreach j in 04 05 06 07 {
	gen `i'33`j'=.
	gen `i'34`j'=.
	gen `i'43`j'=.
}
}
foreach i in tr tt te to co {
foreach j in 05 06 07 {
	gen `i'10`j'=.
}
}
foreach i in tr tt te to co {
foreach j in 07 {
	gen `i'36`j'=.
	gen `i'44`j'=.
}
}
foreach i in tr tt te to co {
foreach j in 01 03 05 06 10 26 33 34 36 37 39 43 44 48 {
	egen `i'`j'=rowtotal(`i'`j'01 `i'`j'02 `i'`j'03 `i'`j'04 `i'`j'05 `i'`j'06 `i'`j'07)
}
}
/* Modify this part:
Sates with only one city have as instrument all other cities*/
foreach i in tr tt te to co {
	egen `i'_all=rowtotal(`i'01 `i'03 `i'05 `i'06 `i'10 `i'26 `i'33 `i'34 ///
	`i'36 `i'37 `i'39 `i'43 `i'44 `i'48 `i'1101 `i'1401 `i'1501 `i'1701 ///
	`i'1901 `i'2101 `i'2201 `i'2301 `i'2401 `i'2801 `i'2901 `i'3201 ///
	`i'3801 `i'4701 `i'5001)
}
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
    replace `i'IV=`i'48 - `i'48`k' if nstate=="`k'" & govs_state=="48"
}
}
/* Substracting city i (itself) for those with more than one city 
foreach i in tr tt te to co {
foreach j in 01 03 05 06 10 26 33 34 36 37 39 43 44 48 {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'`j' - `i'`j'`k' if nstate=="`k'"
}
}
}*/
/* Substracting city i (itself) for those with only one city */
foreach i in tr tt te to co {
foreach j in 1101 1401 1501 1701 1901 2101 2201 2301 2401 2801 2901 3201 3801 4701 5001{
    replace `i'IV=`i'_all - `i'`j' if idcity=="`j'" & `i'IV==.
}
}
/* To take the mean */
destring nstate, replace
foreach i in tr tt te to co {
replace `i'IV=`i'IV/(nstate-1) if nstate>=2
}
foreach i in tr tt te to co {
replace `i'IV=`i'IV/60 if nstate==1
}

save "$base/SubIV.dta", replace
*========================================================================*
use "$base/dbaseCCities.dta", clear
drop if year==1980 
merge m:1 id_govs year using "$base/SubIV.dta"
drop _merge

sort msa_sc year
egen panelid =group(msa_sc)
egen timeid =group(year)
xtset panelid timeid
*========================================================================*
* Generate fiscal variables growth
*========================================================================*
{
	#delimit ;
			local y_var totalrevenue_rpc totaltaxes_rpc totalexpenditure_rpc 
			totalcurrentoper_rpc totalcapitaloutlays_rpc basic_rpc basic_cur_rpc 
			basic_cap_rpc transfer_rpc transfer_cur_rpc transfer_cap_rpc 
			other_rpc other_cur_rpc other_cap_rpc totalrevenue_rsbpc 
			totaltaxes_rsbpc totalexpenditure_rsbpc totalcurrentoper_rsbpc 
			totalcapitaloutlays_rsbpc basic_rsbpc basic_cur_rsbpc 
			basic_cap_rsbpc transfer_rsbpc transfer_cur_rsbpc transfer_cap_rsbpc 
			other_rsbpc other_cur_rsbpc other_cap_rsbpc	basic_level 
			transfer_level other_level trIV ttIV teIV toIV coIV
;
	#delimit cr		
				
	foreach i of local y_var {
	 gen l`i' = log(`i')-log(L.`i')
	}
}
*========================================================================*
* Running the regressions multiple Bartik instrument
*========================================================================*
/* Total Revenue */
*========================================================================*
/* Structural equation */
eststo clear
eststo: xtreg ltotalrevenue_rpc ltotalrevenue_rsbpc lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
/* First stage equation */
eststo: xtreg ltotalrevenue_rsbpc B_iv_* lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
/* Reduced form equation */
eststo: xtreg ltotalrevenue_rpc B_iv_* lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
/* Second stage: IV model */
eststo: xtivreg2 ltotalrevenue_rpc (ltotalrevenue_rsbpc = B_iv_*) ///
lbasic_level ltransfer_level lother_level, fe robust
esttab using "$doc\tab_BartikTR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(ltotalrevenue_rsbpc B_iv_*) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Taxes */ 
*========================================================================*
eststo clear
eststo: xtreg ltotaltaxes_rpc ltotaltaxes_rsbpc lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotaltaxes_rsbpc B_iv_* lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotaltaxes_rpc B_iv_* lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtivreg2 ltotaltaxes_rpc (ltotaltaxes_rsbpc = B_iv_*) lbasic_level ///
ltransfer_level lother_level, fe robust
esttab using "$doc\tab_BartikTT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(ltotaltaxes_rsbpc B_iv_*) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Expenditure */
*========================================================================*
eststo clear
eststo: xtreg ltotalexpenditure_rpc ltotalexpenditure_rsbpc lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotalexpenditure_rsbpc B_iv_* lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotalexpenditure_rpc B_iv_* lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtivreg2 ltotalexpenditure_rpc (ltotalexpenditure_rsbpc = B_iv_*) ///
lbasic_level ltransfer_level lother_level, fe robust
esttab using "$doc\tab_BartikTE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(ltotalexpenditure_rsbpc B_iv_*) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Operations */
*========================================================================*
eststo clear
eststo: xtreg ltotalcurrentoper_rpc ltotalcurrentoper_rsbpc lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotalcurrentoper_rsbpc B_iv_* lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotalcurrentoper_rpc B_iv_* lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtivreg2 ltotalcurrentoper_rpc (ltotalcurrentoper_rsbpc = B_iv_*) ///
lbasic_level ltransfer_level lother_level, fe robust
esttab using "$doc\tab_BartikTO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(ltotalcurrentoper_rsbpc B_iv_*) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Current Outlays */
*========================================================================*
eststo clear
eststo: xtreg ltotalcapitaloutlays_rpc ltotalcapitaloutlays_rsbpc lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotalcapitaloutlays_rsbpc B_iv_* lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotalcapitaloutlays_rpc B_iv_* lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtivreg2 ltotalcapitaloutlays_rpc (ltotalcapitaloutlays_rsbpc = B_iv_*) ///
lbasic_level ltransfer_level lother_level, fe robust
esttab using "$doc\tab_BartikCO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(ltotalcapitaloutlays_rsbpc B_iv_*) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace

*========================================================================*
* Running the regressions with spending from other cities as instrument
*========================================================================*
/* Total Revenue */
*========================================================================*
/* Structural equation */
eststo clear
eststo: xtreg ltotalrevenue_rpc ltotalrevenue_rsbpc lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
/* First stage equation */
eststo: xtreg ltotalrevenue_rsbpc ltrIV lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
/* Reduced form equation */
eststo: xtreg ltotalrevenue_rpc ltrIV lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
/* Second stage: IV model */
eststo: xtivreg2 ltotalrevenue_rpc (ltotalrevenue_rsbpc = ltrIV) ///
lbasic_level ltransfer_level lother_level, fe robust
esttab using "$doc\tab_IVotherTR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(ltotalrevenue_rsbpc ltrIV) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Taxes */ 
*========================================================================*
eststo clear
eststo: xtreg ltotaltaxes_rpc ltotaltaxes_rsbpc lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotaltaxes_rsbpc lttIV lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotaltaxes_rpc lttIV lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtivreg2 ltotaltaxes_rpc (ltotaltaxes_rsbpc = lttIV) lbasic_level ///
ltransfer_level lother_level, fe robust
esttab using "$doc\tab_IVotherTT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(ltotaltaxes_rsbpc lttIV) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Expenditure */
*========================================================================*
eststo clear
eststo: xtreg ltotalexpenditure_rpc ltotalexpenditure_rsbpc lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotalexpenditure_rsbpc lteIV lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotalexpenditure_rpc lteIV lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtivreg2 ltotalexpenditure_rpc (ltotalexpenditure_rsbpc = lteIV) ///
lbasic_level ltransfer_level lother_level, fe robust
esttab using "$doc\tab_IVotherTE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(ltotalexpenditure_rsbpc lteIV) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Operations */
*========================================================================*
eststo clear
eststo: xtreg ltotalcurrentoper_rpc ltotalcurrentoper_rsbpc lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotalcurrentoper_rsbpc ltoIV lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotalcurrentoper_rpc ltoIV lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtivreg2 ltotalcurrentoper_rpc (ltotalcurrentoper_rsbpc = ltoIV) ///
lbasic_level ltransfer_level lother_level, fe robust
esttab using "$doc\tab_IVotherTO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(ltotalcurrentoper_rsbpc ltoIV) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Current Outlays */
*========================================================================*
eststo clear
eststo: xtreg ltotalcapitaloutlays_rpc ltotalcapitaloutlays_rsbpc lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotalcapitaloutlays_rsbpc lcoIV lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotalcapitaloutlays_rpc lcoIV lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtivreg2 ltotalcapitaloutlays_rpc (ltotalcapitaloutlays_rsbpc = lcoIV) ///
lbasic_level ltransfer_level lother_level, fe robust
esttab using "$doc\tab_IVotherCO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(ltotalcapitaloutlays_rsbpc lcoIV) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace



*========================================================================*
eststo clear
eststo: xtivreg2 d_totalrevenue_rpc (d_totalrevenue_rsbpc = d_otch_pw) d_basic_level ///
d_transfer_level d_other_level if d_otch_pw!=., fe r

eststo: xtivreg2 d_totaltaxes_rpc (d_totaltaxes_rsbpc = d_otch_pw) d_basic_level ///
d_transfer_level d_other_level, fe r

eststo: xtivreg2 d_totalexpenditure_rpc (d_totalexpenditure_rsbpc = d_otch_pw) ///
d_basic_level d_transfer_level d_other_level, fe r

eststo: xtivreg2 d_totalcurrentoper_rpc (d_totalcurrentoper_rsbpc = d_otch_pw) ///
d_basic_level d_transfer_level d_other_level, fe r

eststo: xtivreg2 d_totalcapitaloutlays_rpc (d_totalcapitaloutlays_rsbpc = d_otch_pw) ///
d_basic_level d_transfer_level d_other_level, fe r

esttab using "$doc\tab_trade.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(China schock instrument)) keep(d_totalrevenue_rsbpc d_totaltaxes_rsbpc ///
d_totalexpenditure_rsbpc d_totalcurrentoper_rsbpc d_totalcapitaloutlays_rsbpc) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace