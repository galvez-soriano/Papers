*========================================================================*
* Rent Capture by Central Cities
*========================================================================*
/* Steven G. Craig, Annie Hsu, Janet Kohlhase

Modified by Oscar Gálvez-Soriano

Note: Before running this do file, install the package xtivreg2
ssc install ivreg2
ssc install xtivreg2 */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/CentralCities/Data"
gl base= "C:\Users\ogalvez\Documents\ProfessorCraig\Base"
gl doc= "C:\Users\ogalvez\Documents\ProfessorCraig\Doc"
*========================================================================*
/* Merge dataset that include city, suburb fiscal variables and Bartik IV */
*========================================================================*
use "$data/Master_Fin_70_17_city.dta", clear
merge 1:1 year msa_sc using "$data/Master_Fin_70_17_sub.dta", nogen
merge 1:1 year msa_sc using "$data/BartikData_version3_all.dta"
keep if _merge==3
drop _merge
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
*========================================================================*
/* Set up panel data set */
*========================================================================*
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
	 gen l`i' = log(`i')
	}
				
	foreach i of local y_var {
	 gen d_`i' = ((`i'-L.`i')/L.`i')
	}
	
	label var d_totalrevenue_rpc "Revenue"
	label var d_totaltaxes_rpc "Taxes"
	label var d_totalexpenditure_rpc "Expenditure"
	label var d_totalcurrentoper_rpc "Transfers"
	label var d_totalcapitaloutlays_rpc "Other"
	
	label var d_totalrevenue_rsbpc "Revenue"
	label var d_totaltaxes_rsbpc "Taxes"
	label var d_totalexpenditure_rsbpc "Expenditure"
	label var d_totalcurrentoper_rsbpc "Transfers"
	label var d_totalcapitaloutlays_rsbpc "Other"
}
*========================================================================*
* Running the regressions
*========================================================================*
* Outcome varibales: city variables
* Right-hand-side varibales: suburban variables
*========================================================================*
eststo clear
eststo: xtivreg2 d_totalrevenue_rpc (d_totalrevenue_rsbpc = B_iv_11 B_iv_21 B_iv_22 ///
B_iv_23 B_iv_33 B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 B_iv_54 ///
B_iv_55 B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81) d_basic_level ///
d_transfer_level d_other_level, fe r

eststo: xtivreg2 d_totaltaxes_rpc (d_totaltaxes_rsbpc = B_iv_11 B_iv_21 B_iv_22 ///
B_iv_23 B_iv_33 B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 B_iv_54 ///
B_iv_55 B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81) d_basic_level ///
d_transfer_level d_other_level, fe r

eststo: xtivreg2 d_totalexpenditure_rpc (d_totalexpenditure_rsbpc = B_iv_11 B_iv_21 ///
B_iv_22 B_iv_23 B_iv_33 B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 ///
B_iv_54 B_iv_55 B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81) ///
d_basic_level d_transfer_level d_other_level, fe r

eststo: xtivreg2 d_totalcurrentoper_rpc (d_totalcurrentoper_rsbpc = B_iv_11 B_iv_21 ///
B_iv_22 B_iv_23 B_iv_33 B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 B_iv_53 ///
B_iv_54 B_iv_55 B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81) ///
d_basic_level d_transfer_level d_other_level, fe r

eststo: xtivreg2 d_totalcapitaloutlays_rpc (d_totalcapitaloutlays_rsbpc = B_iv_11 ///
B_iv_21 B_iv_22 B_iv_23 B_iv_33 B_iv_42 B_iv_45 B_iv_49 B_iv_51 B_iv_52 ///
B_iv_53 B_iv_54 B_iv_55 B_iv_56 B_iv_61 B_iv_62 B_iv_71 B_iv_72 B_iv_81) ///
d_basic_level d_transfer_level d_other_level, fe r

esttab using "$doc\tab_BartikInd.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Effect of suburbs on central cities ///
(Bartik IVs by industries)) keep(d_totalrevenue_rsbpc d_totaltaxes_rsbpc ///
d_totalexpenditure_rsbpc d_totalcurrentoper_rsbpc d_totalcapitaloutlays_rsbpc) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace