/* ========================================================== */
clear 
set more off
gl data = "C:\Users\Oscar Galvez Soriano\Documents\Papers\Ethanol\Data"
gl doc = "C:\Users\Oscar Galvez Soriano\Documents\Papers\Ethanol\Doc"
/* ========================================================== */
* This data only include states in the midwest region
use  "$data/CensusofAg_LandValue_TotalAgLand_CornGrainHarvested_GovPayment_Pop_LandArea_NCCPI_FarmAnnualReturn_midwest.dta"
drop if TotalArea==0|TotalArea==.
/* 6 counties was dropped due to miss data on agland and cropland geoname
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
bysort fips:gen count=_N
keep if count==5
* Gen variable
replace GovPayment = 0 if GovPayment==.
gen AcresCorn = TotalCornAreaHarvested/1000
gen TotalCropland =CroplandArea/1000
gen land_sqmi = aland10/2589988.1103 /* Aland is in square km, convert to square mile here*/
gen PopDen = popcnty/land_sqmi /* person/square mile*/
gen TotalAgLand = TotalArea/1000
gen GovPay = GovPayment/1000
gen pct_cropland = 100* TotalCropland/TotalAgLand
gen PecentPlantedCorn = 100*(AcresCorn/TotalAgLand)
replace PecentPlantedCorn=0 if PecentPlantedCorn==.
gen log_LandValue=log(LandValue)
gen LandValue_Thousand = LandValue/1000
gen AnnualReturn_mi = AnnualReturn/1000
*gen LandValueInflationAdj = LandValue_Thousand/Ratio /* 1997 is the reference year*/
* Label variables
label variable TotalAgLand "Total Ag Land (thousand acre)"
label variable GovPay "Gov Payment (thousand)"
label variable TotalCropland "Total Cropland (thousand acre)"
label variable PopDen "Population Density (person/square mile)"
label variable pct_cropland "Percent Cropland"
label variable LandValue_Thousand "Land Value (thousand/acre)"
label variable AnnualReturn_mi "Annual Return (million)"
label variable PecentPlantedCorn "Corn Planted (\%)"
label variable nccpi "NCCPI"
gen fips_code =real(fips)
xtset fips_code Year, delta(5) 
rename State State_str
encode State_str,gen(State)
rename County County_str
encode County_str,gen(County)

/* ========================================================== */
gen treat=PecentPlantedCorn>5
gen after=Year>2005
gen had_policy=treat*after

gen llv=log(LandValue)

eststo clear
eststo: areg LandValue_Thousand had_policy i.Year, absorb(County) robust
eststo: areg llv had_policy i.Year, absorb(County) robust


foreach x in 1997 2002 2007 2012 2017{
gen treat_`x'=0
replace treat_`x'=1 if treat==1 & Year==`x'
label var treat_`x' "`x'"
}
replace treat_2002=0

areg LandValue_Thousand treat_* i.Year, absorb(County) vce(cluster State)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(2.65, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Land value in thousand dollars", size(medium) height(5)) ///
ylabel(-0.5(0.5)3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 3)) text(-0.61 2.3 "2005", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\eventsl.png", replace

