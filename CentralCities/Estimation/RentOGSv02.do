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
gl base= "C:\Users\galve\Documents\UH\Summer\Summer2022\Base"
gl doc= "C:\Users\galve\Documents\UH\Summer\Summer2022\Doc"
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
order id_govs year idcity subIV
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
foreach i in tr tt te to co {
foreach j in 01 03 05 06 10 26 33 34 36 37 39 43 44 48 {
foreach k in 01 02 03 04 05 06 07 {
    replace `i'IV=`i'`j' - `i'`j'`k' if nstate=="`k'"
}
}
}

*1101 1401 1501 1701 1901 2101 2201 2301 2401 2801 2901 3201 3801 4701 5001
save "$base/SubIV.dta", replace
*========================================================================*
use "$base/dbaseCCities.dta", clear
drop if year==1980 
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
			transfer_level other_level tr* tt* te* to* co*
;
	#delimit cr		
				
	foreach i of local y_var {
	 gen d_`i' = ((`i'-L.`i')/L.`i')
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
