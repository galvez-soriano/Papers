*=============================================================*
/* Cleaning mobile coverage data */
*=============================================================*
import delimited "C:\Users\Oscar Galvez Soriano\Documents\Papers\AI_Productivity\Data\muni_coverage.csv", clear

gen geo=substr(adm2_pcode,3,5)
keep geo strong_3g any_3g strong_4g any_4g strong_any_network any_network oci_flag_3g oci_flag_4g
order geo strong_3g any_3g strong_4g any_4g strong_any_network any_network oci_flag_3g oci_flag_4g

sort geo

sum any_network, d
gen treat=any_network>=r(p75)

keep geo treat
save "C:\Users\Oscar Galvez Soriano\Documents\Papers\AI_Productivity\Data\exposureCoverage.dta", replace