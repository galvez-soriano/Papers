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
label var B_iv_nmc1 "Agriculture"
label var B_iv_nmc2 "Mining"
label var B_iv_nmc3 "Construction"
label var B_iv_nmc4 "Manufacturing"
label var B_iv_nmc5 "Transportation"
label var B_iv_nmc6 "Wholesale"
label var B_iv_nmc7 "Retail"
label var B_iv_nmc8 "Financial"
label var B_iv_nmc9 "Other Services"
label var dln_sb_totalrevenue "Suburb TR"
label var dln_sb_totaltaxes "Suburb TT"
label var dln_sb_totalcurrentoper "Suburb CO"
label var dln_sb_basic_cur "Suburb BE"
label var dln_sb_transfer_cur "Suburb TranE"
label var dln_sb_other_cur "Suburb OE"

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
(Bartik IV)) keep(dln_sb_totalrevenue B_iv_nmc*) label ///
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
(Bartik IV)) keep(dln_sb_totaltaxes B_iv_nmc*) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Current Operations */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalcurrentoper dln_sb_totalcurrentoper if B_iv_nmc1!=., fe vce(robust)
eststo: xtreg dln_sb_totalcurrentoper B_iv_nmc*, fe vce(robust)
eststo: xtreg dln_lpc_totalcurrentoper B_iv_nmc*, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalcurrentoper (dln_sb_totalcurrentoper = B_iv_nmc*), fe robust
esttab using "$doc\tab_BartikTO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(dln_sb_totalcurrentoper B_iv_nmc*) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Basic Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_basic_cur dln_sb_basic_cur if B_iv_nmc1!=., fe vce(robust)
eststo: xtreg dln_sb_basic_cur B_iv_nmc*, fe vce(robust)
eststo: xtreg dln_lpc_basic_cur B_iv_nmc*, fe vce(robust)
eststo: xtivreg2 dln_lpc_basic_cur (dln_sb_basic_cur = B_iv_nmc*), fe robust
esttab using "$doc\tab_BartikBE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(dln_sb_basic_cur B_iv_nmc*) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Transfer Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_transfer_cur dln_sb_transfer_cur if B_iv_nmc1!=., fe vce(robust)
eststo: xtreg dln_sb_transfer_cur B_iv_nmc*, fe vce(robust)
eststo: xtreg dln_lpc_transfer_cur B_iv_nmc*, fe vce(robust)
eststo: xtivreg2 dln_lpc_transfer_cur (dln_sb_transfer_cur = B_iv_nmc*), fe robust
esttab using "$doc\tab_BartikTranE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(dln_sb_transfer_cur B_iv_nmc*) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Other Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_other_cur dln_sb_other_cur if B_iv_nmc1!=., fe vce(robust)
eststo: xtreg dln_sb_other_cur B_iv_nmc*, fe vce(robust)
eststo: xtreg dln_lpc_other_cur B_iv_nmc*, fe vce(robust)
eststo: xtivreg2 dln_lpc_other_cur (dln_sb_other_cur = B_iv_nmc*), fe robust
esttab using "$doc\tab_BartikOE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(dln_sb_other_cur B_iv_nmc*) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace

*========================================================================*
* Running the regressions with fiscal variables from other suburbs as instrument 
*========================================================================*
/* Set up panel data set */
*========================================================================*
use "$base/dbaseCCities.dta", clear
sort id_govs year
merge 1:1 id_govs year using "$base/SubIV.dta"
drop _merge
merge 1:1 year msa_sc using "$data/BartikData_CBP_version3_annual_nmc.dta", nogen
sort msa_sc year
order id_govs year
label var dln_sb_totalrevenue "Suburb TR"
label var dln_sb_totaltaxes "Suburb TT"
label var dln_sb_totalcurrentoper "Suburb CO"
label var dln_sb_basic_cur "Suburb BE"
label var dln_sb_transfer_cur "Suburb TranE"
label var dln_sb_other_cur "Suburb OE"
label var dltrIV "IV other suburbs TR"
label var dlttIV "IV other suburbs TT"
label var dltoIV "IV other suburbs CO"
label var dlbeIV "IV other suburbs BE"
label var dltaIV "IV other suburbs TranE"
label var dloeIV "IV other suburbs OE"
keep id_govs year msa_sc dltrIV dlttIV dltoIV dlbeIV dltaIV dloeIV one_city B_iv_nmc1 ///
dln_lpc_totalrevenue dln_lpc_totaltaxes dln_lpc_totalcurrentoper ///
dln_sb_totalrevenue dln_sb_totaltaxes dln_sb_totalcurrentoper ///
dln_lpc_basic_cur dln_lpc_transfer_cur dln_lpc_other_cur ///
dln_sb_basic_cur dln_sb_transfer_cur dln_sb_other_cur
egen panelid =group(msa_sc)
egen timeid =group(year)
xtset panelid timeid
*========================================================================*
/* 1972-2017 */
*========================================================================*
/* Total Revenue */  
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalrevenue dln_sb_totalrevenue if dltrIV!=., fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV, fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalrevenue (dln_sb_totalrevenue = dltrIV), fe robust
esttab using "$doc\tab_IV_TR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalrevenue dltrIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Taxes */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totaltaxes dln_sb_totaltaxes if dlttIV!=., fe vce(robust)
eststo: xtreg dln_sb_totaltaxes dlttIV, fe vce(robust)
eststo: xtreg dln_lpc_totaltaxes dlttIV, fe vce(robust)
eststo: xtivreg2 dln_lpc_totaltaxes (dln_sb_totaltaxes = dlttIV), fe robust
esttab using "$doc\tab_IV_TT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totaltaxes dlttIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Current Operations */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalcurrentoper dln_sb_totalcurrentoper if dltoIV!=., fe vce(robust)
eststo: xtreg dln_sb_totalcurrentoper dltoIV, fe vce(robust)
eststo: xtreg dln_lpc_totalcurrentoper dltoIV, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalcurrentoper (dln_sb_totalcurrentoper = dltoIV), fe robust
esttab using "$doc\tab_IV_TO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalcurrentoper dltoIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Basic Expenditure */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_basic_cur dln_sb_basic_cur if dlbeIV!=., fe vce(robust)
eststo: xtreg dln_sb_basic_cur dlbeIV, fe vce(robust)
eststo: xtreg dln_lpc_basic_cur dlbeIV, fe vce(robust)
eststo: xtivreg2 dln_lpc_basic_cur (dln_sb_basic_cur = dlbeIV), fe robust
esttab using "$doc\tab_IV_BE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_basic_cur dlbeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Transfer Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_transfer_cur dln_sb_transfer_cur if dltaIV!=., fe vce(robust)
eststo: xtreg dln_sb_transfer_cur dltaIV, fe vce(robust)
eststo: xtreg dln_lpc_transfer_cur dltaIV, fe vce(robust)
eststo: xtivreg2 dln_lpc_transfer_cur (dln_sb_transfer_cur = dltaIV), fe robust
esttab using "$doc\tab_IV_TranE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_transfer_cur dltaIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Other Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_other_cur dln_sb_other_cur if dloeIV!=., fe vce(robust)
eststo: xtreg dln_sb_other_cur dloeIV, fe vce(robust)
eststo: xtreg dln_lpc_other_cur dloeIV, fe vce(robust)
eststo: xtivreg2 dln_lpc_other_cur (dln_sb_other_cur = dloeIV), fe robust
esttab using "$doc\tab_IV_OE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_other_cur loeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace

*========================================================================*
/* 1990-2017 */
*========================================================================*
/* Total Revenue */  
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalrevenue dln_sb_totalrevenue if dltrIV!=. & B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV if B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV if B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalrevenue (dln_sb_totalrevenue = dltrIV) if B_iv_nmc1!=. & year>=1990, fe robust
esttab using "$doc\tab_IV_TR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalrevenue dltrIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Taxes */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totaltaxes dln_sb_totaltaxes if dlttIV!=. & B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtreg dln_sb_totaltaxes dlttIV if B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtreg dln_lpc_totaltaxes dlttIV if B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtivreg2 dln_lpc_totaltaxes (dln_sb_totaltaxes = dlttIV) if B_iv_nmc1!=. & year>=1990, fe robust
esttab using "$doc\tab_IV_TT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totaltaxes dlttIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Current Operations */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalcurrentoper dln_sb_totalcurrentoper if dltoIV!=. & B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtreg dln_sb_totalcurrentoper dltoIV if B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtreg dln_lpc_totalcurrentoper dltoIV if B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalcurrentoper (dln_sb_totalcurrentoper = dltoIV) if B_iv_nmc1!=. & year>=1990, fe robust
esttab using "$doc\tab_IV_TO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalcurrentoper dltoIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Basic Expenditure */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_basic_cur dln_sb_basic_cur if dlbeIV!=. & B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtreg dln_sb_basic_cur dlbeIV if B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtreg dln_lpc_basic_cur dlbeIV if B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtivreg2 dln_lpc_basic_cur (dln_sb_basic_cur = dlbeIV) if B_iv_nmc1!=. & year>=1990, fe robust
esttab using "$doc\tab_IV_BE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_basic_cur dlbeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Transfer Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_transfer_cur dln_sb_transfer_cur if dltaIV!=. & B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtreg dln_sb_transfer_cur dltaIV if B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtreg dln_lpc_transfer_cur dltaIV if B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtivreg2 dln_lpc_transfer_cur (dln_sb_transfer_cur = dltaIV) if B_iv_nmc1!=. & year>=1990, fe robust
esttab using "$doc\tab_IV_TranE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_transfer_cur dltaIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Other Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_other_cur dln_sb_other_cur if dloeIV!=. & B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtreg dln_sb_other_cur dloeIV if B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtreg dln_lpc_other_cur dloeIV if B_iv_nmc1!=. & year>=1990, fe vce(robust)
eststo: xtivreg2 dln_lpc_other_cur (dln_sb_other_cur = dloeIV) if B_iv_nmc1!=. & year>=1990, fe robust
esttab using "$doc\tab_IV_OE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_other_cur dloeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace