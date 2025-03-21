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
merge 1:1 year msa_sc using "$data/BartikData_version12_mc.dta"
drop if _merge==2
drop _merge 
merge 1:1 year msa_sc using "$data/BartikData_version12_nmc.dta"
drop if _merge==2
rename B_iv_nmc B_iv
replace B_iv=B_iv_mc if B_iv==.
drop _merge dX_it* loc_all_* B_iv_mc
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

foreach x in 11 21 22 23 33 42 45 49 51 52 53 54 55 56 61 62 71 72 81{
rename B_iv_`x'_nmc B_iv_`x'
replace B_iv_`x'=B_iv_`x'_mc if B_iv_`x'==.
drop B_iv_`x'_mc loc_ind_`x'_nmc loc_ind_`x'_mc B_iv_`x'_nmc_5 B_iv_`x'_mc_5
}
/* Trade variables */
rename d_usch_pw_msanmc d_usch_pw
rename d_otch_pw_lag_msanmc d_otch_pw
replace d_usch_pw=d_usch_pw_msamc if d_usch_pw==.
replace d_otch_pw=d_otch_pw_lag_msamc if d_otch_pw==.

save "$base/dbaseCCities.dta", replace
*========================================================================*
/* Set up panel data set */
*========================================================================*
use "$base/dbaseCCities.dta", clear
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
			transfer_level other_level
;
	#delimit cr		
	
	foreach i of local y_var {
	 gen l`i' = log(`i')-log(L.`i')
	}
				
	foreach i of local y_var {
	 gen d_`i' = ((`i'-L.`i')/L.`i')
	}
}
*========================================================================*
/* Unit Root tests */
*========================================================================*
* Levin-Lin-Chu test
xtunitroot llc d_totalrevenue_rpc
* Harris-Tzavalis test
xtunitroot ht d_totalrevenue_rpc
* Breitung test
xtunitroot breitung d_totalrevenue_rpc
* Im-Pesaran-Shin test
xtunitroot ips d_totalrevenue_rpc
* Fisher-type tests (combining p-values)
xtunitroot fisher d_totalrevenue_rpc, dfuller lags(2)
* Hadri Lagrange multiplier stationarity test
xtunitroot hadri d_totalrevenue_rpc

xtunitroot llc d_totalrevenue_rsbpc
xtunitroot ht d_totalrevenue_rsbpc
xtunitroot breitung d_totalrevenue_rsbpc
xtunitroot ips d_totalrevenue_rsbpc
xtunitroot fisher d_totalrevenue_rsbpc, dfuller lags(2)
xtunitroot hadri d_totalrevenue_rsbpc

xtunitroot llc d_totaltaxes_rpc
xtunitroot ht d_totaltaxes_rpc
xtunitroot breitung d_totaltaxes_rpc
xtunitroot ips d_totaltaxes_rpc
xtunitroot fisher d_totaltaxes_rpc, dfuller lags(2)
xtunitroot hadri d_totaltaxes_rpc

xtunitroot llc d_totaltaxes_rsbpc
xtunitroot ht d_totaltaxes_rsbpc
xtunitroot breitung d_totaltaxes_rsbpc
xtunitroot ips d_totaltaxes_rsbpc
xtunitroot fisher d_totaltaxes_rsbpc, dfuller lags(2)
xtunitroot hadri d_totaltaxes_rsbpc

xtunitroot llc d_totalexpenditure_rpc
xtunitroot ht d_totalexpenditure_rpc
xtunitroot breitung d_totalexpenditure_rpc
xtunitroot ips d_totalexpenditure_rpc
xtunitroot fisher d_totalexpenditure_rpc, dfuller lags(2)
xtunitroot hadri d_totalexpenditure_rpc

xtunitroot llc d_totalexpenditure_rsbpc
xtunitroot ht d_totalexpenditure_rsbpc
xtunitroot breitung d_totalexpenditure_rsbpc
xtunitroot ips d_totalexpenditure_rsbpc
xtunitroot fisher d_totalexpenditure_rsbpc, dfuller lags(2)
xtunitroot hadri d_totalexpenditure_rsbpc

xtunitroot llc d_totalcurrentoper_rpc
xtunitroot ht d_totalcurrentoper_rpc
xtunitroot breitung d_totalcurrentoper_rpc
xtunitroot ips d_totalcurrentoper_rpc
xtunitroot fisher d_totalcurrentoper_rpc, dfuller lags(2)
xtunitroot hadri d_totalcurrentoper_rpc

xtunitroot llc d_totalcurrentoper_rsbpc
xtunitroot ht d_totalcurrentoper_rsbpc
xtunitroot breitung d_totalcurrentoper_rsbpc
xtunitroot ips d_totalcurrentoper_rsbpc
xtunitroot fisher d_totalcurrentoper_rsbpc, dfuller lags(2)
xtunitroot hadri d_totalcurrentoper_rsbpc

xtunitroot llc d_totalcapitaloutlays_rpc
xtunitroot ht d_totalcapitaloutlays_rpc
xtunitroot breitung d_totalcapitaloutlays_rpc
xtunitroot ips d_totalcapitaloutlays_rpc
xtunitroot fisher d_totalcapitaloutlays_rpc, dfuller lags(2)
xtunitroot hadri d_totalcapitaloutlays_rpc

xtunitroot llc d_totalcapitaloutlays_rsbpc
xtunitroot ht d_totalcapitaloutlays_rsbpc
xtunitroot breitung d_totalcapitaloutlays_rsbpc
xtunitroot ips d_totalcapitaloutlays_rsbpc
xtunitroot fisher d_totalcapitaloutlays_rsbpc, dfuller lags(2)
xtunitroot hadri d_totalcapitaloutlays_rsbpc
*========================================================================*
* Running the regressions single Bartik instrument
*========================================================================*
/* Total Revenue */
*========================================================================*
/* Structural equation */
eststo clear
eststo: xtreg d_totalrevenue_rpc d_totalrevenue_rsbpc d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
/* First stage equation */
eststo: xtreg d_totalrevenue_rsbpc B_iv d_basic_level d_transfer_level ///
d_other_level, fe vce(robust)
/* Reduced form equation */
eststo: xtreg d_totalrevenue_rpc B_iv d_basic_level d_transfer_level ///
d_other_level, fe vce(robust)
/* Second stage: IV model */
eststo: xtivreg2 d_totalrevenue_rpc (d_totalrevenue_rsbpc = B_iv) ///
d_basic_level d_transfer_level d_other_level, fe robust
esttab using "$doc\tab_BartikTR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(d_totalrevenue_rsbpc B_iv) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Taxes */
*========================================================================*
eststo clear
eststo: xtreg d_totaltaxes_rpc d_totaltaxes_rsbpc d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
eststo: xtreg d_totaltaxes_rsbpc B_iv d_basic_level d_transfer_level ///
d_other_level, fe vce(robust)
eststo: xtreg d_totaltaxes_rpc B_iv d_basic_level d_transfer_level ///
d_other_level, fe vce(robust)
eststo: xtivreg2 d_totaltaxes_rpc (d_totaltaxes_rsbpc = B_iv) ///
d_basic_level d_transfer_level d_other_level, fe robust
esttab using "$doc\tab_BartikTT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(d_totaltaxes_rsbpc B_iv) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Expenditure */
*========================================================================*
eststo clear
eststo: xtreg d_totalexpenditure_rpc d_totalexpenditure_rsbpc d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
eststo: xtreg d_totalexpenditure_rsbpc B_iv d_basic_level d_transfer_level ///
d_other_level, fe vce(robust)
eststo: xtreg d_totalexpenditure_rpc B_iv d_basic_level d_transfer_level ///
d_other_level, fe vce(robust)
eststo: xtivreg2 d_totalexpenditure_rpc (d_totalexpenditure_rsbpc = B_iv) ///
d_basic_level d_transfer_level d_other_level, fe robust
esttab using "$doc\tab_BartikTE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(d_totalexpenditure_rsbpc B_iv) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================* 
/* Current Toper */
*========================================================================*
eststo clear
eststo: xtreg d_totalcurrentoper_rpc d_totalcurrentoper_rsbpc d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
eststo: xtreg d_totalcurrentoper_rsbpc B_iv d_basic_level d_transfer_level ///
d_other_level, fe vce(robust)
eststo: xtreg d_totalcurrentoper_rpc B_iv d_basic_level d_transfer_level ///
d_other_level, fe vce(robust)
eststo: xtivreg2 d_totalcurrentoper_rpc (d_totalcurrentoper_rsbpc = B_iv) ///
d_basic_level d_transfer_level d_other_level, fe robust
esttab using "$doc\tab_BartikCT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(d_totalcurrentoper_rsbpc B_iv) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Capital Outlays */
*========================================================================*
eststo clear
eststo: xtreg d_totalcapitaloutlays_rpc d_totalcapitaloutlays_rsbpc d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
eststo: xtreg d_totalcapitaloutlays_rsbpc B_iv d_basic_level d_transfer_level ///
d_other_level, fe vce(robust)
eststo: xtreg d_totalcapitaloutlays_rpc B_iv d_basic_level d_transfer_level ///
d_other_level, fe vce(robust)
eststo: xtivreg2 d_totalcapitaloutlays_rpc (d_totalcapitaloutlays_rsbpc = B_iv) ///
d_basic_level d_transfer_level d_other_level, fe robust
esttab using "$doc\tab_BartikCO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(d_totalcapitaloutlays_rsbpc B_iv) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
* Running the regressions single Bartik instrument (variables in logs)
*========================================================================*
/* Total Revenue */
*========================================================================*
/* Structural equation */
eststo clear
eststo: xtreg ltotalrevenue_rpc ltotalrevenue_rsbpc lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
/* First stage equation */
eststo: xtreg ltotalrevenue_rsbpc B_iv lbasic_level ltransfer_level ///
lother_level, fe vce(robust)
/* Reduced form equation */
eststo: xtreg ltotalrevenue_rpc B_iv lbasic_level ltransfer_level ///
lother_level, fe vce(robust)
/* Second stage: IV model */
eststo: xtivreg2 ltotalrevenue_rpc (ltotalrevenue_rsbpc = B_iv) ///
lbasic_level ltransfer_level lother_level, fe robust
esttab using "$doc\tab_BartikTR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(ltotalrevenue_rsbpc B_iv) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Taxes */
*========================================================================*
eststo clear
eststo: xtreg ltotaltaxes_rpc ltotaltaxes_rsbpc lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotaltaxes_rsbpc B_iv lbasic_level ltransfer_level ///
lother_level, fe vce(robust)
eststo: xtreg ltotaltaxes_rpc B_iv lbasic_level ltransfer_level ///
lother_level, fe vce(robust)
eststo: xtivreg2 ltotaltaxes_rpc (ltotaltaxes_rsbpc = B_iv) ///
lbasic_level ltransfer_level lother_level, fe robust
esttab using "$doc\tab_BartikTT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(ltotaltaxes_rsbpc B_iv) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Expenditure */
*========================================================================*
eststo clear
eststo: xtreg ltotalexpenditure_rpc ltotalexpenditure_rsbpc lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotalexpenditure_rsbpc B_iv lbasic_level ltransfer_level ///
lother_level, fe vce(robust)
eststo: xtreg ltotalexpenditure_rpc B_iv lbasic_level ltransfer_level ///
lother_level, fe vce(robust)
eststo: xtivreg2 ltotalexpenditure_rpc (ltotalexpenditure_rsbpc = B_iv) ///
lbasic_level ltransfer_level lother_level, fe robust
esttab using "$doc\tab_BartikTE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(ltotalexpenditure_rsbpc B_iv) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================* 
/* Current Toper */
*========================================================================*
eststo clear
eststo: xtreg ltotalcurrentoper_rpc ltotalcurrentoper_rsbpc lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotalcurrentoper_rsbpc B_iv lbasic_level ltransfer_level ///
lother_level, fe vce(robust)
eststo: xtreg ltotalcurrentoper_rpc B_iv lbasic_level ltransfer_level ///
lother_level, fe vce(robust)
eststo: xtivreg2 ltotalcurrentoper_rpc (ltotalcurrentoper_rsbpc = B_iv) ///
lbasic_level ltransfer_level lother_level, fe robust
esttab using "$doc\tab_BartikCT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(ltotalcurrentoper_rsbpc B_iv) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Capital Outlays */
*========================================================================*
eststo clear
eststo: xtreg ltotalcapitaloutlays_rpc ltotalcapitaloutlays_rsbpc lbasic_level ///
ltransfer_level lother_level, fe vce(robust)
eststo: xtreg ltotalcapitaloutlays_rsbpc B_iv lbasic_level ltransfer_level ///
lother_level, fe vce(robust)
eststo: xtreg ltotalcapitaloutlays_rpc B_iv lbasic_level ltransfer_level ///
lother_level, fe vce(robust)
eststo: xtivreg2 ltotalcapitaloutlays_rpc (ltotalcapitaloutlays_rsbpc = B_iv) ///
lbasic_level ltransfer_level lother_level, fe robust
esttab using "$doc\tab_BartikCO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(ltotalcapitaloutlays_rsbpc B_iv) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
* Running the regressions multiple Bartik instrument
*========================================================================*
/* Total Revenue */
*========================================================================*
/* Structural equation */
eststo clear
eststo: xtreg d_totalrevenue_rpc d_totalrevenue_rsbpc d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
/* First stage equation */
eststo: xtreg d_totalrevenue_rsbpc B_iv_11 B_iv_21 B_iv_22 B_iv_23 B_iv_33 ///
B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 B_iv_54 B_iv_55 ///
B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81 d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
/* Reduced form equation */
eststo: xtreg d_totalrevenue_rpc B_iv_11 B_iv_21 B_iv_22 B_iv_23 B_iv_33 ///
B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 B_iv_54 B_iv_55 ///
B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81 d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
/* Second stage: IV model */
eststo: xtivreg2 d_totalrevenue_rpc (d_totalrevenue_rsbpc = B_iv_11 B_iv_21 ///
B_iv_22 B_iv_23 B_iv_33 B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 ///
B_iv_53 B_iv_54 B_iv_55 B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 ///
B_iv_81) d_basic_level d_transfer_level d_other_level, fe robust
esttab using "$doc\tab_BartikTR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(d_totalrevenue_rsbpc B_iv_*) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Taxes */
*========================================================================*
eststo clear
eststo: xtreg d_totaltaxes_rpc d_totaltaxes_rsbpc d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
eststo: xtreg d_totaltaxes_rsbpc B_iv_11 B_iv_21 B_iv_22 B_iv_23 B_iv_33 ///
B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 B_iv_54 B_iv_55 ///
B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81 d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
eststo: xtreg d_totaltaxes_rpc B_iv_11 B_iv_21 B_iv_22 B_iv_23 B_iv_33 ///
B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 B_iv_54 B_iv_55 ///
B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81 d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
eststo: xtivreg2 d_totaltaxes_rpc (d_totaltaxes_rsbpc = B_iv_11 B_iv_21 B_iv_22 ///
B_iv_23 B_iv_33 B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 B_iv_54 ///
B_iv_55 B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81) d_basic_level ///
d_transfer_level d_other_level, fe robust
esttab using "$doc\tab_BartikTT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(d_totaltaxes_rsbpc B_iv_*) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Expenditure */
*========================================================================*
eststo clear
eststo: xtreg d_totalexpenditure_rpc d_totalexpenditure_rsbpc d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
eststo: xtreg d_totalexpenditure_rsbpc B_iv_11 B_iv_21 B_iv_22 B_iv_23 B_iv_33 ///
B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 B_iv_54 B_iv_55 ///
B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81 d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
eststo: xtreg d_totalexpenditure_rpc B_iv_11 B_iv_21 B_iv_22 B_iv_23 B_iv_33 ///
B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 B_iv_54 B_iv_55 ///
B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81 d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
eststo: xtivreg2 d_totalexpenditure_rpc (d_totalexpenditure_rsbpc = B_iv_11 B_iv_21 ///
B_iv_22 B_iv_23 B_iv_33 B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 ///
B_iv_54 B_iv_55 B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81) ///
d_basic_level d_transfer_level d_other_level, fe robust
esttab using "$doc\tab_BartikTE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(d_totalexpenditure_rsbpc B_iv_*) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Operations */
*========================================================================*
eststo clear
eststo: xtreg d_totalcurrentoper_rpc d_totalcurrentoper_rsbpc d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
eststo: xtreg d_totalcurrentoper_rsbpc B_iv_11 B_iv_21 B_iv_22 B_iv_23 B_iv_33 ///
B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 B_iv_54 B_iv_55 ///
B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81 d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
eststo: xtreg d_totalcurrentoper_rpc B_iv_11 B_iv_21 B_iv_22 B_iv_23 B_iv_33 ///
B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 B_iv_54 B_iv_55 ///
B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81 d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
eststo: xtivreg2 d_totalcurrentoper_rpc (d_totalcurrentoper_rsbpc = B_iv_11 B_iv_21 ///
B_iv_22 B_iv_23 B_iv_33 B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 ///
B_iv_54 B_iv_55 B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81) ///
d_basic_level d_transfer_level d_other_level, fe robust
esttab using "$doc\tab_BartikTO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(d_totalcurrentoper_rsbpc B_iv_*) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Current Outlays */
*========================================================================*
eststo clear
eststo: xtreg d_totalcapitaloutlays_rpc d_totalcapitaloutlays_rsbpc d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
eststo: xtreg d_totalcapitaloutlays_rsbpc B_iv_11 B_iv_21 B_iv_22 B_iv_23 B_iv_33 ///
B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 B_iv_54 B_iv_55 ///
B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81 d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
eststo: xtreg d_totalcapitaloutlays_rpc B_iv_11 B_iv_21 B_iv_22 B_iv_23 B_iv_33 ///
B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 B_iv_54 B_iv_55 ///
B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81 d_basic_level ///
d_transfer_level d_other_level, fe vce(robust)
eststo: xtivreg2 d_totalcapitaloutlays_rpc (d_totalcapitaloutlays_rsbpc = B_iv_11 ///
B_iv_21 B_iv_22 B_iv_23 B_iv_33 B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 ///
B_iv_53 B_iv_54 B_iv_55 B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81) ///
d_basic_level d_transfer_level d_other_level, fe robust
esttab using "$doc\tab_BartikCO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(d_totalcapitaloutlays_rsbpc B_iv_*) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace

*========================================================================*
eststo clear
eststo: xtivreg2 ltotalrevenue_rpc (ltotalrevenue_rsbpc = B_iv_11 B_iv_21 B_iv_22 ///
B_iv_23 B_iv_33 B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 B_iv_54 ///
B_iv_55 B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81) lbasic_level ///
ltransfer_level lother_level, fe r

eststo: xtivreg2 ltotaltaxes_rpc (ltotaltaxes_rsbpc = B_iv_11 B_iv_21 B_iv_22 ///
B_iv_23 B_iv_33 B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 B_iv_54 ///
B_iv_55 B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81) lbasic_level ///
ltransfer_level lother_level, fe r

eststo: xtivreg2 ltotalexpenditure_rpc (ltotalexpenditure_rsbpc = B_iv_11 B_iv_21 ///
B_iv_22 B_iv_23 B_iv_33 B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 ///
B_iv_54 B_iv_55 B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81) ///
lbasic_level ltransfer_level lother_level, fe r

eststo: xtivreg2 ltotalcurrentoper_rpc (ltotalcurrentoper_rsbpc = B_iv_11 B_iv_21 ///
B_iv_22 B_iv_23 B_iv_33 B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 ///
B_iv_54 B_iv_55 B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81) ///
lbasic_level ltransfer_level lother_level, fe r

eststo: xtivreg2 ltotalcapitaloutlays_rpc (ltotalcapitaloutlays_rsbpc = B_iv_11 ///
B_iv_21 B_iv_22 B_iv_23 B_iv_33 B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 ///
B_iv_53 B_iv_54 B_iv_55 B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81) ///
lbasic_level ltransfer_level lother_level, fe r

esttab using "$doc\tab_BartikInd_log.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IVs by industries)) keep(ltotalrevenue_rsbpc ltotaltaxes_rsbpc ///
ltotalexpenditure_rsbpc ltotalcurrentoper_rsbpc ltotalcapitaloutlays_rsbpc) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
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
