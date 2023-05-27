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
gl base= "C:\Users\iscot\Documents\GalvezSoriano\Papers\CentralCities\Base"
gl doc= "C:\Users\iscot\Documents\GalvezSoriano\Papers\CentralCities\Doc"
*========================================================================*
/* Running the regressions with fiscal variables from other suburbs as 
instrument */
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
label var dln_sb_totalutilcuroper "Suburb UO"
label var dltrIV "IV other suburbs TR"
label var dlttIV "IV other suburbs TT"
label var dltoIV "IV other suburbs CO"
label var dlbeIV "IV other suburbs BE"
label var dltaIV "IV other suburbs TranE"
label var dloeIV "IV other suburbs OE"
label var dluoIV "IV other suburbs UO"
keep id_govs year msa_sc dltrIV dlttIV dltoIV dlbeIV dltaIV dloeIV dluoIV ///
one_city B_iv_nmc1 ///
dln_lpc_totalrevenue dln_lpc_totaltaxes dln_lpc_totalcurrentoper ///
dln_sb_totalrevenue dln_sb_totaltaxes dln_sb_totalcurrentoper ///
dln_lpc_basic_cur dln_lpc_transfer_cur dln_lpc_other_cur dln_lpc_totalutilcuroper ///
dln_sb_basic_cur dln_sb_transfer_cur dln_sb_other_cur dln_sb_totalutilcuroper
egen panelid =group(msa_sc)
egen timeid =group(year)
xtset panelid timeid
*========================================================================*
/* Bartik Sample. Period 1990-2017 */
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

*========================================================================*
/* Bartik Sample. Multiple cities in one state, 1990-2017 */
*========================================================================*
/* Total Revenue */  
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalrevenue dln_sb_totalrevenue if dltrIV!=. & B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV if B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV if B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalrevenue (dln_sb_totalrevenue = dltrIV) if B_iv_nmc1!=. & year>=1990 & one_city==0, fe robust
esttab using "$doc\tab_IV_TR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalrevenue dltrIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Taxes */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totaltaxes dln_sb_totaltaxes if dlttIV!=. & B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtreg dln_sb_totaltaxes dlttIV if B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtreg dln_lpc_totaltaxes dlttIV if B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtivreg2 dln_lpc_totaltaxes (dln_sb_totaltaxes = dlttIV) if B_iv_nmc1!=. & year>=1990 & one_city==0, fe robust
esttab using "$doc\tab_IV_TT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totaltaxes dlttIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Current Operations */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalcurrentoper dln_sb_totalcurrentoper if dltoIV!=. & B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtreg dln_sb_totalcurrentoper dltoIV if B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtreg dln_lpc_totalcurrentoper dltoIV if B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalcurrentoper (dln_sb_totalcurrentoper = dltoIV) if B_iv_nmc1!=. & year>=1990 & one_city==0, fe robust
esttab using "$doc\tab_IV_TO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalcurrentoper dltoIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Basic Expenditure */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_basic_cur dln_sb_basic_cur if dlbeIV!=. & B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtreg dln_sb_basic_cur dlbeIV if B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtreg dln_lpc_basic_cur dlbeIV if B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtivreg2 dln_lpc_basic_cur (dln_sb_basic_cur = dlbeIV) if B_iv_nmc1!=. & year>=1990 & one_city==0, fe robust
esttab using "$doc\tab_IV_BE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_basic_cur dlbeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Transfer Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_transfer_cur dln_sb_transfer_cur if dltaIV!=. & B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtreg dln_sb_transfer_cur dltaIV if B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtreg dln_lpc_transfer_cur dltaIV if B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtivreg2 dln_lpc_transfer_cur (dln_sb_transfer_cur = dltaIV) if B_iv_nmc1!=. & year>=1990 & one_city==0, fe robust
esttab using "$doc\tab_IV_TranE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_transfer_cur dltaIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Other Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_other_cur dln_sb_other_cur if dloeIV!=. & B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtreg dln_sb_other_cur dloeIV if B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtreg dln_lpc_other_cur dloeIV if B_iv_nmc1!=. & year>=1990 & one_city==0, fe vce(robust)
eststo: xtivreg2 dln_lpc_other_cur (dln_sb_other_cur = dloeIV) if B_iv_nmc1!=. & year>=1990 & one_city==0, fe robust
esttab using "$doc\tab_IV_OE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_other_cur dloeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace

*========================================================================*
/* Bartik Sample. Single cities per state, 1990-2017 */
*========================================================================*
/* Total Revenue */  
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalrevenue dln_sb_totalrevenue if dltrIV!=. & B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV if B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV if B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalrevenue (dln_sb_totalrevenue = dltrIV) if B_iv_nmc1!=. & year>=1990 & one_city==1, fe robust
esttab using "$doc\tab_IV_TR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalrevenue dltrIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Taxes */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totaltaxes dln_sb_totaltaxes if dlttIV!=. & B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtreg dln_sb_totaltaxes dlttIV if B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtreg dln_lpc_totaltaxes dlttIV if B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtivreg2 dln_lpc_totaltaxes (dln_sb_totaltaxes = dlttIV) if B_iv_nmc1!=. & year>=1990 & one_city==1, fe robust
esttab using "$doc\tab_IV_TT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totaltaxes dlttIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Current Operations */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalcurrentoper dln_sb_totalcurrentoper if dltoIV!=. & B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtreg dln_sb_totalcurrentoper dltoIV if B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtreg dln_lpc_totalcurrentoper dltoIV if B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalcurrentoper (dln_sb_totalcurrentoper = dltoIV) if B_iv_nmc1!=. & year>=1990 & one_city==1, fe robust
esttab using "$doc\tab_IV_TO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalcurrentoper dltoIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Basic Expenditure */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_basic_cur dln_sb_basic_cur if dlbeIV!=. & B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtreg dln_sb_basic_cur dlbeIV if B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtreg dln_lpc_basic_cur dlbeIV if B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtivreg2 dln_lpc_basic_cur (dln_sb_basic_cur = dlbeIV) if B_iv_nmc1!=. & year>=1990 & one_city==1, fe robust
esttab using "$doc\tab_IV_BE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_basic_cur dlbeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Transfer Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_transfer_cur dln_sb_transfer_cur if dltaIV!=. & B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtreg dln_sb_transfer_cur dltaIV if B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtreg dln_lpc_transfer_cur dltaIV if B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtivreg2 dln_lpc_transfer_cur (dln_sb_transfer_cur = dltaIV) if B_iv_nmc1!=. & year>=1990 & one_city==1, fe robust
esttab using "$doc\tab_IV_TranE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_transfer_cur dltaIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Other Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_other_cur dln_sb_other_cur if dloeIV!=. & B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtreg dln_sb_other_cur dloeIV if B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtreg dln_lpc_other_cur dloeIV if B_iv_nmc1!=. & year>=1990 & one_city==1, fe vce(robust)
eststo: xtivreg2 dln_lpc_other_cur (dln_sb_other_cur = dloeIV) if B_iv_nmc1!=. & year>=1990 & one_city==1, fe robust
esttab using "$doc\tab_IV_OE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_other_cur dloeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace

*========================================================================*
/* All states. Period 1972-2017 */
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
(Suburbs IV)) keep(dln_sb_other_cur dloeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace

*========================================================================*
/* All states. Multiple cities in one state, 1972-2017 */
*========================================================================*
/* Total Revenue */  
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalrevenue dln_sb_totalrevenue if dltrIV!=. & one_city==0, fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV if one_city==0 & dln_lpc_totalrevenue!=., fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV if one_city==0, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalrevenue (dln_sb_totalrevenue = dltrIV) if one_city==0, fe robust
esttab using "$doc\tab_IV_TR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalrevenue dltrIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Taxes */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totaltaxes dln_sb_totaltaxes if dlttIV!=. & one_city==0, fe vce(robust)
eststo: xtreg dln_sb_totaltaxes dlttIV if one_city==0 & dln_lpc_totaltaxes!=., fe vce(robust)
eststo: xtreg dln_lpc_totaltaxes dlttIV if one_city==0, fe vce(robust)
eststo: xtivreg2 dln_lpc_totaltaxes (dln_sb_totaltaxes = dlttIV) if one_city==0, fe robust
esttab using "$doc\tab_IV_TT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totaltaxes dlttIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Current Operations */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalcurrentoper dln_sb_totalcurrentoper if dltoIV!=. & one_city==0, fe vce(robust)
eststo: xtreg dln_sb_totalcurrentoper dltoIV if one_city==0 & dln_lpc_totalcurrentoper!=., fe vce(robust)
eststo: xtreg dln_lpc_totalcurrentoper dltoIV if one_city==0, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalcurrentoper (dln_sb_totalcurrentoper = dltoIV) if one_city==0, fe robust
esttab using "$doc\tab_IV_TO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalcurrentoper dltoIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Basic Expenditure */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_basic_cur dln_sb_basic_cur if dlbeIV!=. & one_city==0, fe vce(robust)
eststo: xtreg dln_sb_basic_cur dlbeIV if one_city==0 & dln_lpc_basic_cur!=., fe vce(robust)
eststo: xtreg dln_lpc_basic_cur dlbeIV if one_city==0, fe vce(robust)
eststo: xtivreg2 dln_lpc_basic_cur (dln_sb_basic_cur = dlbeIV) if one_city==0, fe robust
esttab using "$doc\tab_IV_BE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_basic_cur dlbeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Transfer Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_transfer_cur dln_sb_transfer_cur if dltaIV!=. & one_city==0, fe vce(robust)
eststo: xtreg dln_sb_transfer_cur dltaIV if one_city==0 & dln_lpc_transfer_cur!=., fe vce(robust)
eststo: xtreg dln_lpc_transfer_cur dltaIV if one_city==0 & dln_sb_transfer_cur!=., fe vce(robust)
eststo: xtivreg2 dln_lpc_transfer_cur (dln_sb_transfer_cur = dltaIV) if one_city==0, fe robust
esttab using "$doc\tab_IV_TranE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_transfer_cur dltaIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Other Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_other_cur dln_sb_other_cur if dloeIV!=. & one_city==0, fe vce(robust)
eststo: xtreg dln_sb_other_cur dloeIV if one_city==0 & dln_lpc_other_cur!=., fe vce(robust)
eststo: xtreg dln_lpc_other_cur dloeIV if one_city==0, fe vce(robust)
eststo: xtivreg2 dln_lpc_other_cur (dln_sb_other_cur = dloeIV) if one_city==0, fe robust
esttab using "$doc\tab_IV_OE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_other_cur dloeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace

*========================================================================*
/* All states. Single city in one state, 1972-2017 */
*========================================================================*
/* Total Revenue */  
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalrevenue dln_sb_totalrevenue if dltrIV!=. & one_city==1, fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV if one_city==1 & dln_lpc_totalrevenue!=., fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV if one_city==1, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalrevenue (dln_sb_totalrevenue = dltrIV) if one_city==1, fe robust
esttab using "$doc\tab_IV_TR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalrevenue dltrIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Taxes */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totaltaxes dln_sb_totaltaxes if dlttIV!=. & one_city==1, fe vce(robust)
eststo: xtreg dln_sb_totaltaxes dlttIV if one_city==1 & dln_lpc_totaltaxes!=., fe vce(robust)
eststo: xtreg dln_lpc_totaltaxes dlttIV if one_city==1, fe vce(robust)
eststo: xtivreg2 dln_lpc_totaltaxes (dln_sb_totaltaxes = dlttIV) if one_city==1, fe robust
esttab using "$doc\tab_IV_TT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totaltaxes dlttIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Current Operations */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalcurrentoper dln_sb_totalcurrentoper if dltoIV!=. & one_city==1, fe vce(robust)
eststo: xtreg dln_sb_totalcurrentoper dltoIV if one_city==1 & dln_lpc_totalcurrentoper!=., fe vce(robust)
eststo: xtreg dln_lpc_totalcurrentoper dltoIV if one_city==1, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalcurrentoper (dln_sb_totalcurrentoper = dltoIV) if one_city==1, fe robust
esttab using "$doc\tab_IV_TO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalcurrentoper dltoIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Basic Expenditure */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_basic_cur dln_sb_basic_cur if dlbeIV!=. & one_city==1, fe vce(robust)
eststo: xtreg dln_sb_basic_cur dlbeIV if one_city==1 & dln_lpc_basic_cur!=., fe vce(robust)
eststo: xtreg dln_lpc_basic_cur dlbeIV if one_city==1, fe vce(robust)
eststo: xtivreg2 dln_lpc_basic_cur (dln_sb_basic_cur = dlbeIV) if one_city==1, fe robust
esttab using "$doc\tab_IV_BE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_basic_cur dlbeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Transfer Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_transfer_cur dln_sb_transfer_cur if dltaIV!=. & one_city==1, fe vce(robust)
eststo: xtreg dln_sb_transfer_cur dltaIV if one_city==1 & dln_lpc_transfer_cur!=., fe vce(robust)
eststo: xtreg dln_lpc_transfer_cur dltaIV if one_city==1 & dln_sb_transfer_cur!=., fe vce(robust)
eststo: xtivreg2 dln_lpc_transfer_cur (dln_sb_transfer_cur = dltaIV) if one_city==1, fe robust
esttab using "$doc\tab_IV_TranE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_transfer_cur dltaIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Other Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_other_cur dln_sb_other_cur if dloeIV!=. & one_city==1, fe vce(robust)
eststo: xtreg dln_sb_other_cur dloeIV if one_city==1 & dln_lpc_other_cur!=., fe vce(robust)
eststo: xtreg dln_lpc_other_cur dloeIV if one_city==1 & dln_sb_other_cur!=., fe vce(robust)
eststo: xtivreg2 dln_lpc_other_cur (dln_sb_other_cur = dloeIV) if one_city==1, fe robust
esttab using "$doc\tab_IV_OE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_other_cur dloeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace

*========================================================================* 
/* All states. Period 1972-2007 */
*========================================================================*
/* Total Revenue */  
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalrevenue dln_sb_totalrevenue if dltrIV!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV if year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV if year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalrevenue (dln_sb_totalrevenue = dltrIV) if year<=2007, fe robust
esttab using "$doc\tab_IV_TR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalrevenue dltrIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Taxes */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totaltaxes dln_sb_totaltaxes if dlttIV!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_sb_totaltaxes dlttIV if year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_totaltaxes dlttIV if year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_totaltaxes (dln_sb_totaltaxes = dlttIV) if year<=2007, fe robust
esttab using "$doc\tab_IV_TT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totaltaxes dlttIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Current Operations */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalcurrentoper dln_sb_totalcurrentoper if dltoIV!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_sb_totalcurrentoper dltoIV if year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_totalcurrentoper dltoIV if year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalcurrentoper (dln_sb_totalcurrentoper = dltoIV) if year<=2007, fe robust
esttab using "$doc\tab_IV_TO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalcurrentoper dltoIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Basic Expenditure */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_basic_cur dln_sb_basic_cur if dlbeIV!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_sb_basic_cur dlbeIV if year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_basic_cur dlbeIV if year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_basic_cur (dln_sb_basic_cur = dlbeIV) if year<=2007, fe robust
esttab using "$doc\tab_IV_BE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_basic_cur dlbeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Transfer Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_transfer_cur dln_sb_transfer_cur if dltaIV!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_sb_transfer_cur dltaIV if year<=2007 & dln_lpc_transfer_cur!=., fe vce(robust)
eststo: xtreg dln_lpc_transfer_cur dltaIV if year<=2007 & dln_sb_transfer_cur!=., fe vce(robust)
eststo: xtivreg2 dln_lpc_transfer_cur (dln_sb_transfer_cur = dltaIV) if year<=2007, fe robust
esttab using "$doc\tab_IV_TranE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_transfer_cur dltaIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Other Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_other_cur dln_sb_other_cur if dloeIV!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_sb_other_cur dloeIV if year<=2007 & dln_lpc_other_cur!=., fe vce(robust)
eststo: xtreg dln_lpc_other_cur dloeIV if year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_other_cur (dln_sb_other_cur = dloeIV) if year<=2007, fe robust
esttab using "$doc\tab_IV_OE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_other_cur dloeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace

*========================================================================*
/* All states. Multiple cities in one state, 1972-2007 */
*========================================================================*
/* Total Revenue */  
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalrevenue dln_sb_totalrevenue if dltrIV!=. & one_city==0 & year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV if one_city==0 & dln_lpc_totalrevenue!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV if one_city==0 & year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalrevenue (dln_sb_totalrevenue = dltrIV) if one_city==0 & year<=2007, fe robust
esttab using "$doc\tab_IV_TR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalrevenue dltrIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Taxes */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totaltaxes dln_sb_totaltaxes if dlttIV!=. & one_city==0 & year<=2007, fe vce(robust)
eststo: xtreg dln_sb_totaltaxes dlttIV if one_city==0 & dln_lpc_totaltaxes!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_totaltaxes dlttIV if one_city==0 & year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_totaltaxes (dln_sb_totaltaxes = dlttIV) if one_city==0 & year<=2007, fe robust
esttab using "$doc\tab_IV_TT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totaltaxes dlttIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Current Operations */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalcurrentoper dln_sb_totalcurrentoper if dltoIV!=. & year<=2007 & one_city==0, fe vce(robust)
eststo: xtreg dln_sb_totalcurrentoper dltoIV if one_city==0 & dln_lpc_totalcurrentoper!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_totalcurrentoper dltoIV if one_city==0 & year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalcurrentoper (dln_sb_totalcurrentoper = dltoIV) if one_city==0 & year<=2007, fe robust
esttab using "$doc\tab_IV_TO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalcurrentoper dltoIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Basic Expenditure */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_basic_cur dln_sb_basic_cur if dlbeIV!=. & one_city==0 & year<=2007, fe vce(robust)
eststo: xtreg dln_sb_basic_cur dlbeIV if one_city==0 & dln_lpc_basic_cur!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_basic_cur dlbeIV if one_city==0 & year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_basic_cur (dln_sb_basic_cur = dlbeIV) if one_city==0 & year<=2007, fe robust
esttab using "$doc\tab_IV_BE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_basic_cur dlbeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Transfer Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_transfer_cur dln_sb_transfer_cur if dltaIV!=. & one_city==0 & year<=2007, fe vce(robust)
eststo: xtreg dln_sb_transfer_cur dltaIV if one_city==0 & dln_lpc_transfer_cur!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_transfer_cur dltaIV if one_city==0 & dln_sb_transfer_cur!=. & year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_transfer_cur (dln_sb_transfer_cur = dltaIV) if one_city==0 & year<=2007, fe robust
esttab using "$doc\tab_IV_TranE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_transfer_cur dltaIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Other Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_other_cur dln_sb_other_cur if dloeIV!=. & one_city==0 & year<=2007, fe vce(robust)
eststo: xtreg dln_sb_other_cur dloeIV if one_city==0 & dln_lpc_other_cur!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_other_cur dloeIV if one_city==0 & year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_other_cur (dln_sb_other_cur = dloeIV) if one_city==0 & year<=2007, fe robust
esttab using "$doc\tab_IV_OE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_other_cur dloeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace

*========================================================================*
/* All states. Single city in one state, 1972-2007 */
*========================================================================*
/* Total Revenue */  
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalrevenue dln_sb_totalrevenue if dltrIV!=. & one_city==1 & year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV if one_city==1 & dln_lpc_totalrevenue!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_totalrevenue dltrIV if one_city==1 & year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalrevenue (dln_sb_totalrevenue = dltrIV) if one_city==1 & year<=2007, fe robust
esttab using "$doc\tab_IV_TR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalrevenue dltrIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Total Taxes */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totaltaxes dln_sb_totaltaxes if dlttIV!=. & one_city==1 & year<=2007, fe vce(robust)
eststo: xtreg dln_sb_totaltaxes dlttIV if one_city==1 & dln_lpc_totaltaxes!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_totaltaxes dlttIV if one_city==1 & year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_totaltaxes (dln_sb_totaltaxes = dlttIV) if one_city==1 & year<=2007, fe robust
esttab using "$doc\tab_IV_TT.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totaltaxes dlttIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Current Operations */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_totalcurrentoper dln_sb_totalcurrentoper if dltoIV!=. & one_city==1 & year<=2007, fe vce(robust)
eststo: xtreg dln_sb_totalcurrentoper dltoIV if one_city==1 & dln_lpc_totalcurrentoper!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_totalcurrentoper dltoIV if one_city==1 & year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_totalcurrentoper (dln_sb_totalcurrentoper = dltoIV) if one_city==1 & year<=2007, fe robust
esttab using "$doc\tab_IV_TO.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_totalcurrentoper dltoIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Basic Expenditure */ 
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_basic_cur dln_sb_basic_cur if dlbeIV!=. & one_city==1 & year<=2007, fe vce(robust)
eststo: xtreg dln_sb_basic_cur dlbeIV if one_city==1 & dln_lpc_basic_cur!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_basic_cur dlbeIV if one_city==1 & year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_basic_cur (dln_sb_basic_cur = dlbeIV) if one_city==1 & year<=2007, fe robust
esttab using "$doc\tab_IV_BE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_basic_cur dlbeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Transfer Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_transfer_cur dln_sb_transfer_cur if dltaIV!=. & one_city==1 & year<=2007, fe vce(robust)
eststo: xtreg dln_sb_transfer_cur dltaIV if one_city==1 & dln_lpc_transfer_cur!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_transfer_cur dltaIV if one_city==1 & dln_sb_transfer_cur!=. & year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_transfer_cur (dln_sb_transfer_cur = dltaIV) if one_city==1 & year<=2007, fe robust
esttab using "$doc\tab_IV_TranE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_transfer_cur dltaIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Other Expenditure */
*========================================================================*
eststo clear
eststo: xtreg dln_lpc_other_cur dln_sb_other_cur if dloeIV!=. & one_city==1 & year<=2007, fe vce(robust)
eststo: xtreg dln_sb_other_cur dloeIV if one_city==1 & dln_lpc_other_cur!=. & year<=2007, fe vce(robust)
eststo: xtreg dln_lpc_other_cur dloeIV if one_city==1 & dln_sb_other_cur!=. & year<=2007, fe vce(robust)
eststo: xtivreg2 dln_lpc_other_cur (dln_sb_other_cur = dloeIV) if one_city==1 & year<=2007, fe robust
esttab using "$doc\tab_IV_OE.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Suburbs IV)) keep(dln_sb_other_cur dloeIV) label ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace
