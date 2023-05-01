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
gl base= "C:\Users\ogalvezs\Documents\CentralCities\Base"
gl doc= "C:\Users\ogalvezs\Documents\CentralCities\Doc"
*========================================================================*
/* Merge dataset that include city, suburb fiscal variables and Bartik IV */
*========================================================================*
use "$data/Fin_67_17_city_linear.dta", clear
merge 1:1 year msa_sc using "$data/Fin_67_17_sub_linear.dta"
keep if _merge==3 //drop msa=26,41,43 in 1967-1971
drop _merge
merge 1:1 year msa_sc using "$data/Fin_67_17_sub_linear_mc2.dta", nogen
merge 1:1 year msa_sc using "$data/BartikData_CBP_version3_annual_mc.dta", nogen
*rename _merge merge1 //check msa_sc 12,18,63
merge 1:1 year msa_sc using "$data/BartikData_CBP_version3_annual_nmc.dta", nogen
merge 1:1 year msa_sc using "$data/BartikData_CBP_version1_annual_mc.dta", nogen
merge 1:1 year msa_sc using "$data/BartikData_CBP_version1_annual_nmc.dta", nogen
keep if year>=1990

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
eststo: xtreg dln_lpc_totalrevenue dln_sb_totalrevenue, fe vce(robust)
/* First stage equation */
eststo: xtreg dln_lpc_totalrevenue B_iv_nmc*, fe vce(robust)
/* Reduced form equation */
eststo: xtreg dln_lpc_totalrevenue B_iv_nmc*, fe vce(robust)
/* Second stage: IV model */
eststo: xtivreg2 dln_lpc_totalrevenue (dln_sb_totalrevenue = B_iv_nmc*), fe robust
esttab using "$doc\tab_BartikTR.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IV)) keep(ltotalrevenue_rsbpc B_iv_*) ///
stats(N r2 F, fmt(%9.0fc %9.3f)) replace

