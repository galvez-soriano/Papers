*=====================================================================*
/* Paper: Income effect and labor market outcomes: The role of remittances 
		  in Mexico
   Author: Oscar Galvez-Soriano */
*=====================================================================*
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\Remittances\Doc"
*=====================================================================*
/*
use "$data/Papers/main/RemittancesMex/Data/dbaseRemitt_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 {
    append using "$data/Papers/main/RemittancesMex/Data/dbaseRemitt_`x'.dta"
}
save "$base\dbaseRemitt.dta", replace 
*/
*=====================================================================*
foreach x in 16 18 20 22 {
use "$base\dbaseRemitt.dta", clear

keep if year==20`x'
destring geo, replace

ineqdeco ictpc [aw=weight], bygroup(geo)
return list
tempfile gnxl
postfile results geo ge2 gini using "`gnxl'"
foreach f in `r(levels)' {
    post results (`f') (r(ge2_`f')) (r(gini_`f'))
}
postclose results
use "`gnxl'", clear
list, clean noobs

tostring geo, replace format(%05.0f)
gen year=20`x'
keep geo year gini

save "$base\GiniIndex20`x'.dta", replace
}
*=====================================================================*
use "$base\GiniIndex2016.dta", clear
foreach x in 18 20 22 {
append using "$base\GiniIndex20`x'.dta"
}
sort geo year
save "$base\GiniIndex.dta", replace
*=====================================================================*
use "$base\dbaseRemitt.dta", clear

*keep if age>=18 & age<=65
collapse state ictpc poor epoor remittan work age female treat formal [fw=weight], by(geo year)

merge 1:1 geo year using "$base\GiniIndex.dta", nogen

merge m:1 geo using "$base\migrants.dta"
drop if _merge!=3
drop _merge

merge m:1 geo using "$base\distance_border.dta"
drop if _merge==2
drop _merge

reghdfe remittan mc age female, absorb(year state) vce(cluster geo)

reghdfe ictpc mc age female, absorb(year state) vce(cluster geo)

ivregress 2sls ictpc (remittan=mc) age female i.state i.year, vce(cluster geo)


reghdfe remittan distance_borderbytrain age female, absorb(year state) vce(cluster geo)

reghdfe ictpc distance_borderbytrain age female, absorb(year state) vce(cluster geo)

ivregress 2sls ictpc (remittan=distance_borderbytrain) age female i.state i.year, vce(cluster geo)
*=====================================================================*
use "$base\dbaseRemitt.dta", clear

collapse remit [fw=weight], by(folioviv foliohog year)

gen rremitt=remit>0
drop remit

save "$base\rremitt.dta", replace
*=====================================================================*
use "$base\dbaseRemitt.dta", clear

merge m:1 folioviv foliohog year using "$base\rremitt.dta", nogen

collapse state ictpc poor epoor remittan work age female treat formal [fw=weight], by(geo year rremitt)

merge m:1 geo year using "$base\GiniIndex.dta", nogen

merge m:1 geo using "$base\migrants.dta"
drop if _merge!=3
drop _merge

merge m:1 geo using "$base\distance_border.dta"
drop if _merge==2
drop _merge

/* Receivers */

reghdfe remittan mc age female if rremitt==1, absorb(year state) vce(cluster geo)

reghdfe ictpc mc age female if rremitt==1, absorb(year state) vce(cluster geo)

ivregress 2sls ictpc (remittan=mc) age female i.state i.year if rremitt==1, vce(cluster geo)


reghdfe remittan distance_borderbytrain age female if rremitt==1, absorb(year state) vce(cluster geo)

reghdfe ictpc distance_borderbytrain age female if rremitt==1, absorb(year state) vce(cluster geo)

ivregress 2sls ictpc (remittan=distance_borderbytrain) age female i.state i.year if rremitt==1, vce(cluster geo)

/* Non-receivers */

reghdfe remittan mc age female if rremitt==0, absorb(year state) vce(cluster geo)

reghdfe ictpc mc age female if rremitt==0, absorb(year state) vce(cluster geo)

ivregress 2sls ictpc (remittan=mc) age female i.state i.year if rremitt==0, vce(cluster geo)


reghdfe remittan distance_borderbytrain age female if rremitt==0, absorb(year state) vce(cluster geo)

reghdfe ictpc distance_borderbytrain age female if rremitt==0, absorb(year state) vce(cluster geo)

ivregress 2sls ictpc (remittan=distance_borderbytrain) age female i.state i.year if rremitt==0, vce(cluster geo)

*=====================================================================*
use "$base\dbaseRemitt.dta", clear

merge m:1 folioviv foliohog year using "$base\rremitt.dta", nogen

collapse state ictpc poor epoor remittan work age female treat formal [fw=weight], by(geo year rremitt)

merge m:1 geo year using "$base\GiniIndex.dta", nogen

merge m:1 geo using "$base\migrants.dta"
drop if _merge!=3
drop _merge

merge m:1 geo using "$base\distance_border.dta"
drop if _merge==2
drop _merge

keep remittan ictpc mc distance_borderbytrain geo rremitt state year
reshape wide remittan ictpc mc distance_borderbytrain, i(geo rremitt state) j(year) 


reghdfe remittan2022 mc2022 if rremitt==1, absorb(state) vce(cluster geo)

reghdfe ictpc2022 mc2022 if rremitt==1, absorb(state) vce(cluster geo)

ivregress 2sls ictpc2022 (remittan2022=mc2022) i.state if rremitt==1, vce(cluster geo)


reghdfe remittan2022 distance_borderbytrain2022 if rremitt==1, absorb(state) vce(cluster geo)

reghdfe ictpc2022 distance_borderbytrain2022 if rremitt==1, absorb(state) vce(cluster geo)

ivregress 2sls ictpc2022 (remittan2022=distance_borderbytrain2022) i.state if rremitt==1, vce(cluster geo)


reghdfe remittan2022 remittan2020 if rremitt==1, absorb(state) vce(cluster geo)

reghdfe ictpc2022 remittan2020 if rremitt==1, absorb(state) vce(cluster geo)

ivregress 2sls ictpc2022 (remittan2022=remittan2020) i.state if rremitt==1, vce(cluster geo)


reghdfe remittan2022 remittan2018 if rremitt==1, absorb(state) vce(cluster geo)

reghdfe ictpc2022 remittan2018 if rremitt==1, absorb(state) vce(cluster geo)

ivregress 2sls ictpc2022 (remittan2022=remittan2018) i.state if rremitt==1, vce(cluster geo)


reghdfe remittan2022 remittan2016 if rremitt==1, absorb(state) vce(cluster geo)

reghdfe ictpc2022 remittan2016 if rremitt==1, absorb(state) vce(cluster geo)

ivregress 2sls ictpc2022 (remittan2022=remittan2016) i.state if rremitt==1, vce(cluster geo)



