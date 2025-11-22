*=============================================================*
/* Cleaning mobile coverage data */
*=============================================================*
import delimited "C:\Users\Oscar Galvez Soriano\Documents\Papers\AI_Productivity\Data\muni_coverage.csv", clear

gen geo=substr(adm2_pcode,3,5)
keep geo treat_control_top_quartile treat_control_median
order geo treat_control_top_quartile treat_control_median
rename treat_control_top_quartile treat_top
rename treat_control_median treat_median

replace treat_top="" if treat_top=="NA"
replace treat_median="" if treat_median=="NA"

destring treat_*, replace

sort geo

keep geo treat_*
save "C:\Users\Oscar Galvez Soriano\Documents\Papers\AI_Productivity\Data\exposureCoverage2.dta", replace