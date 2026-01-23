/* ========================================================== */
clear 
set more off
gl data = "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EthanolCorn/Data"
gl base = "C:\Users\Oscar Galvez Soriano\Documents\Papers\Ethanol\Data"
/* ========================================================== */
* These data only include states in the Midwest region
use  "$data/CensusofAgData.dta", clear
drop if TotalArea==0|TotalArea==.

merge m:1 fips using "$data/Income.dta"
keep if _merge ==3
drop _merge
format %05s fips
/* 6 counties were dropped due to missing data on agland and cropland geoname
Keweenaw, MI
Sioux, ND
Slope, ND
Menominee, WI*
Menominee, WI*
Milwaukee, WI
Milwaukee, WI
Vilas, WI
*/
drop if CroplandArea==.
/* */
drop LandValue
rename RealLandValue LandValue
/* */
* Gen variable
replace GovPayment = 0 if GovPayment==.
gen AcresCorn = TotalCornAreaHarvested/1000
gen TotalCropland =CroplandArea/1000
gen land_sqmi = aland10/2589988.1103 /* Aland is in square km, convert to square mile here*/
gen PopDen = popcnty/land_sqmi /* person/square mile*/
gen TotalAgLand = TotalArea/1000
gen GovPay = GovPayment/1000
gen pct_cropland = 100* TotalCropland/TotalAgLand
gen PecentPlantedCorn = 100*(TotalCornAreaHarvested/TotalArea)
replace PecentPlantedCorn=0 if PecentPlantedCorn==.
gen log_LandValue=log(LandValue)
gen LandValue_Thousand = LandValue/1000
gen AnnualReturn_mi = AnnualReturn/1000
gen GovPay_mi = GovPay/1000
gen Gov_dollarperacre = GovPayment/TotalArea
*gen LandValueInflationAdj = LandValue_Thousand/Ratio /* 1997 is the reference year*/
* Label variables
label variable TotalAgLand "Total ag land (thousands acres)"
label variable GovPay "Gov Payment (thousands)"
label variable TotalCropland "Total cropland (thousands acres)"
label variable PopDen "Pop. density (persons/square mile)"
label variable pct_cropland "Percent cropland"
label variable LandValue_Thousand "Land value (thousands/acre)"
label variable AnnualReturn_mi "Annual return (millions)"
label variable Gov_dollarperacre "Gov. payment (\$/acre of ag land)"
label variable PecentPlantedCorn "Corn planted (\%)"
label variable nccpi "NCCPI"
gen fips_code =real(fips)
xtset fips_code Year, delta(5) 
rename State State_str
encode State_str,gen(State)
rename County County_str
encode County_str,gen(County)

drop Period WeekEnding Program GeoLevel ZipCode Region Watershed Domain DomainCategory count
order fips fips_code fips_state fips_cnty Year State County
save "$base\AgDBase.dta", replace

use "$base\AgDBase.dta", clear

keep fips PecentPlantedCorn Year
keep if Year==2002 | Year==2022

sum PecentPlantedCorn if Year==2002, d
gen cp2002= PecentPlantedCorn>r(p10) if Year==2002

sum PecentPlantedCorn if Year==2022, d
gen cp2022= PecentPlantedCorn>r(p10) if Year==2022

egen cornp=rowtotal(cp2002 cp2022)
drop PecentPlantedCorn cp2002 cp2022

reshape wide cornp, i(fips) j(Year)
gen cornpc= cornp2002+ cornp2022
drop cornp2002 cornp2022
recode cornpc (1=.) (2=1)
save "$base\CornPC.dta", replace

use "$base\AgDBase.dta", clear
merge m:1 fips using "$data/CornPC.dta"
keep if _merge ==3
drop _merge
save "$base\AgDBase.dta", replace

use "$base\AgDBase.dta", clear
merge m:1 fips using "$data/EthanolPlantsatCounties.dta"
drop if _merge ==2
drop _merge

replace totalplant=0 if totalplant==.
gen ethanol_plant=totalplant>0
save "$base\AgDBase.dta", replace

use "$base\AgDBase.dta", clear
keep fips PecentPlantedCorn Year
destring fips, replace

bysort fips: gen year=_n
xtset fips year

gen gr=(D.PecentPlantedCorn)/(L.PecentPlantedCorn)

drop if Year<=2002
bysort fips: egen agr=mean(gr)

collapse agr, by(fips)
sum agr, d
gen ext_margin=agr>r(p50)
keep fips ext_margin
tostring fips, replace format(%5.0f)
save "$base\ext_margin.dta", replace

use "$base\AgDBase.dta", clear
destring fips, replace
tostring fips, replace format(%5.0f)
merge m:1 fips using "$data/ext_margin.dta"
drop if _merge!=3
drop _merge
save "$base\AgDBase.dta", replace

use "$base\AgDBase.dta", clear

merge 1:1 fips Year using "$data/SAIPE.dta"
drop if _merge==2
drop _merge

save "$base\AgDBase.dta", replace
/*
use "$data/SAIPE.dta", clear
rename year Year
rename povertypercent_allgges poverty
destring Year, replace
gen str fips=state_fips + county_fips
sort fips
drop in 85914/l
drop in 1/16

destring fips, replace
tostring fips, replace format(%5.0f)
keep fips Year poverty
order fips Year poverty
sort fips Year

bysort fips Year: gen dupli=_N
drop if dupli==2
drop dupli

save "$base\SAIPE.dta", replace
*/