*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\iscot\OneDrive\Documents\Papers\EngSkills\Data"
gl doc= "C:\Users\iscot\OneDrive\Documents\Papers\EngSkills\Doc"
*========================================================================*
/* Maps for presentation */
*========================================================================*
use "$data/data/main/Maps/MexStates/mex_map_state.dta", clear

gen treat=0.8 if state==01 | state==05 | state==10 ///
| state==19 | state==25 | state==26 | state==28 
gen compar=1 if state==02 | state==03 | state==08 | state==18 ///
| state==14 | state==24 | state==32 | state==06 | state==11
replace treat=0.2 if compar==1

spmap treat using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 1) legend(off) fcolor(Greens)
graph export "$doc\map_sdd.png", replace
