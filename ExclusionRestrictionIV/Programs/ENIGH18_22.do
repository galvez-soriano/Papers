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
use "$base\dbaseRemitt.dta", clear

merge m:1 geo using "$base\migrants.dta"
drop if _merge!=3
drop _merge

merge m:1 geo using "$base\distance_border.dta"
drop if _merge==2
drop _merge

gen after=year>=2020
gen treat_after=treat*after
replace remit=remit/1000
/*
foreach x in 16 18 20 22{
gen treat_20`x'=0
replace treat_20`x'=1 if treat==1 & year==20`x'
label var treat_20`x' "20`x'"
}
replace treat_2018=0
*/

reghdfe remit treat rururb age female educ if age>=18 & age<=65 [aw=weight], absorb(year state) vce(cluster geo)

reghdfe ictpc treat rururb age female educ if age>=18 & age<=65 [aw=weight], absorb(year state) vce(cluster geo)

ivregress 2sls ictpc (remit=treat) rururb age female educ i.state i.year if age>=18 & age<=65 [aw=weight], vce(cluster geo)


reghdfe remit mc rururb age female educ if age>=18 & age<=65 [aw=weight], absorb(year state) vce(cluster geo)

reghdfe ictpc mc rururb age female educ if age>=18 & age<=65 [aw=weight], absorb(year state) vce(cluster geo)

ivregress 2sls ictpc (remit=mc) rururb age female educ i.state i.year if age>=18 & age<=65 [aw=weight], vce(cluster geo)


reghdfe remit distance_borderbytrain rururb age female educ if age>=18 & age<=65 [aw=weight], absorb(year state) vce(cluster geo)

reghdfe ictpc distance_borderbytrain rururb age female educ if age>=18 & age<=65 [aw=weight], absorb(year state) vce(cluster geo)

ivregress 2sls ictpc (remit=distance_borderbytrain) rururb age female educ i.state i.year if age>=18 & age<=65 [aw=weight], vce(cluster geo)
