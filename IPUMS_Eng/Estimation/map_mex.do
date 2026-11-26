*========================================================================*
* Map of Mexico
*========================================================================*
cd "C:\Users\galve\Documents\Papers\Current\IPUMS"
*========================================================================*
use "mex_map_state.dta", clear

merge m:m state using "treat_states.dta"
drop _merge
save "mx_eng.dta", replace
*========================================================================*
use "mx_eng.dta", clear

spmap eng_year using "mxcoord.dta", id(id) ///
    clmethod(unique) ///
    fcolor("8 48 107" "66 146 198" "158 202 225" "222 235 247") ///
    legend(position(7) size(large))
graph export "map_Eng.png", replace

