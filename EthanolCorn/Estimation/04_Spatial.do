/* ========================================================== */
clear all
set more off
/* ========================================================== */
cd "C:\Users\Oscar Galvez Soriano\Documents\Papers\Ethanol\Data\Shapefiles"
spshape2dta tl_2016_us_county

use tl_2016_us_county
generate long fips_code = real(STATEFP + COUNTYFP)

assert fips_code!=.
bysort fips_code: assert _N==1

spset fips_code, modify replace
spset, modify coordsys(latlong, miles)

save, replace
/* ========================================================== */
gl data = "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EthanolCorn/Data"
gl base = "C:\Users\Oscar Galvez Soriano\Documents\Papers\Ethanol\Data"
gl doc = "C:\Users\Oscar Galvez Soriano\Documents\Papers\Ethanol\Doc"
graph set window fontface "Times New Roman"
set scheme s1mono
/* ========================================================== */
* Robustness: Spatial regression
/* ========================================================== */
use "$base\AgDBase.dta", clear
drop GovPay GovPayment GovPay_mi Gov_dollarperacre unit AnnualReturn AnnualReturn_mi

merge m:1 fips_code using "$base\Shapefiles\tl_2016_us_county.dta"
keep if _merge==3
drop _merge

xtset, clear
xtset _ID Year
spbalance

*grmap nccpi, t(2022)
spmatrix create contiguity W if Year==1997

summarize nccpi, detail
gen Treat = (nccpi > r(p10)) 
gen Post = (Year>2005)
gen DiD = Treat*Post
label variable DiD "Treat x After"

tabulate Year, generate(year)
/* ========================================================== */
* Table X. Effect of Ethanol Boom on Farmland Values
/* ========================================================== */
xtreg LandValue_Thousand DiD Post, fe cluster(County)
spxtregress LandValue_Thousand DiD Post, fe dvarlag(W)
estat impact DiD

