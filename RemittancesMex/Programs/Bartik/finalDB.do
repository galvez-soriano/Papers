*============================================*
/*  */
*============================================*
use "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Data\final_cbp_database.dta", clear

drop _merge _merge2
drop if emp==.
collapse estab emp payann [aw= pct_mex], by(year state county)

sort state county year

tostring state, replace format(%02.0f)
tostring county, replace format(%03.0f)

gen str county_id=state + county

order county_id year
drop state county

destring county_id, replace

xtset county_id year