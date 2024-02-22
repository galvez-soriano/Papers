/* ========================================================== */
/* Renewable Fuel Standard, Corn Production, and Midwest 
Farmland Values 
Authors: Hoanh Le and Oscar Galvez-Soriano */
/* ========================================================== */
clear 
set more off
gl data = "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EthanolCorn/Data"
gl doc = "C:\Users\Oscar Galvez Soriano\Documents\Papers\Ethanol\Doc"
/* ========================================================== */
* This data only include states in the midwest region
use  "$data/CensusofAg_LandValue_TotalAgLand_CornGrainHarvested_GovPayment_Pop_LandArea_NCCPI_FarmAnnualReturn_midwest.dta", clear
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
sum PecentPlantedCorn, d
return list

gen treat=PecentPlantedCorn>=r(p10)
gen after=Year>2005
gen had_policy=treat*after

/* ========================================================== */
/* Descriptive statistics */
/* ========================================================== */

eststo clear
eststo control_b: quietly estpost sum LandValue_Thousand TotalCropland ///
TotalAgLand pct_cropland PecentPlantedCorn GovPay AnnualReturn_mi ///
PopDen nccpi if after==0 & treat==0 
eststo treat_b: quietly estpost sum LandValue_Thousand TotalCropland ///
TotalAgLand pct_cropland PecentPlantedCorn GovPay AnnualReturn_mi ///
PopDen nccpi if after==0 & treat==1 
eststo control_a: quietly estpost sum LandValue_Thousand TotalCropland ///
TotalAgLand pct_cropland PecentPlantedCorn GovPay AnnualReturn_mi ///
PopDen nccpi if after==1 & treat==0 
eststo treat_a: quietly estpost sum LandValue_Thousand TotalCropland ///
TotalAgLand pct_cropland PecentPlantedCorn GovPay AnnualReturn_mi ///
PopDen nccpi if after==1 & treat==1 
eststo diff: quietly estpost ttest LandValue_Thousand TotalCropland ///
TotalAgLand pct_cropland PecentPlantedCorn GovPay AnnualReturn_mi ///
PopDen nccpi, by(treat) unequal
esttab control_b treat_b control_a treat_a diff using "$doc\tab1.tex", ///
cells("mean(pattern(1 1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace

reg LandValue_Thousand had_policy after treat, vce(cluster State)
reg TotalCropland had_policy after treat, vce(cluster State)
reg TotalAgLand had_policy after treat, vce(cluster State)
*reg pct_cropland had_policy after treat, vce(cluster State)
reg PecentPlantedCorn had_policy after treat, vce(cluster State)
reg GovPay had_policy after treat, vce(cluster State)
reg AnnualReturn_mi had_policy after treat, vce(cluster State)
reg PopDen had_policy after treat, vce(cluster State)
reg nccpi had_policy after treat, vce(cluster State)

/* ========================================================== */

eststo clear
eststo: areg LandValue_Thousand had_policy i.Year GovPay PopDen ///
AnnualReturn_mi, absorb(County) robust

foreach x in 1997 2002 2007 2012 2017{
gen treat_`x'=0
replace treat_`x'=1 if treat==1 & Year==`x'
label var treat_`x' "`x'"
}
replace treat_2002=0

areg LandValue_Thousand treat_* i.Year GovPay PopDen ///
AnnualReturn_mi, absorb(County) vce(cluster State)

coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(2.65, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Land value in thousand dollars", size(medium) height(5)) ///
ylabel(-1(1)3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 3)) text(-1.15 2.3 "2005", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\events.png", replace

/* ========================================================== */
/* Sensitivity analysis */
/* ========================================================== */
xtile pct = PecentPlantedCorn, nq(100) // creates percentile variable

/*drop treat* had_policy

gen treat2=pct>10
gen had_policy2=treat2*after

areg LandValue_Thousand had_policy2 i.Year GovPay PopDen ///
AnnualReturn_mi, absorb(County) robust
*/
label var pct "Percentile of counties ordered by corn production"
graph set window fontface "Times New Roman"

eststo clear
foreach x in 5 6 7 8 9 10 11 12 13 14 15 {

drop treat* had_policy
gen treat=pct>`x'
gen had_policy=treat*after

areg LandValue_Thousand had_policy i.Year GovPay PopDen ///
AnnualReturn_mi, absorb(County) vce(cluster State)
estimates store corn`x'
}

label var had_policy "Percentile of the distribution of planted corn area relative to total area"

/*coefplot (corn5, label(>5)) (corn6, label(>6)) (corn7, label(>7)) ///
(corn8, label(>8)) (corn9, label(>9)) ///
(corn10, label(>10) mcolor(red) ciopts(recast(rcap) color(red))) ///
(corn11, label(>11)) (corn12, label(>12)) (corn13, label(>13)) ///
(corn14, label(>14)) (corn15, label(>15)), ///
vertical keep(had_policy) yline(0) ///
yline(.91646, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Land value in thousand dollars", size(medium) height(5)) ///
ylabel(-0.5(0.5)2, labs(medium) grid format(%5.2f)) ///
legend( pos(2) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\sa_landv.png", replace */

coefplot (corn6, label(>6)) (corn7, label(>7)) ///
(corn8, label(>8)) (corn9, label(>9)) ///
(corn10, label(>10) mcolor(red) ciopts(recast(rcap) color(red))) ///
(corn11, label(>11)) (corn12, label(>12)) (corn13, label(>13)) ///
(corn14, label(>14)), ///
vertical keep(had_policy) yline(0) ///
yline(.91646, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Land value in thousand dollars", size(medium) height(5)) ///
ylabel(-0.5(0.5)2, labs(medium) grid format(%5.2f)) ///
legend( pos(5) ring(0) col(3)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\sa_landv.png", replace

/* ========================================================== */
/* Robust: Heterogeneous Treatment Effects */
/* ========================================================== */
areg LandValue_Thousand had_policy i.Year GovPay PopDen ///
AnnualReturn_mi, absorb(County) robust

gen year_pol=0
replace year_pol=Year if treat==1 & Year>=2005
bysort State County: egen first_treat=sum(had_policy)
bysort State County: egen one_year=sum(year_pol) if first_treat==1
bysort State County: egen two_year=min(year_pol) if first_treat==2 & year_pol>0
bysort State County: egen two_year_all=mean(two_year)

replace first_treat=2007 if first_treat==3
replace first_treat=two_year_all if first_treat==2
replace first_treat=one_year if first_treat==1

drop one_year two_year two_year_all

csdid LandValue_Thousand had_policy GovPay PopDen AnnualReturn_mi, ///
ivar(County) time(Year) gvar(first_treat) wboot seed(6) vce(cluster State)
estat all

csdid LandValue_Thousand had_policy GovPay PopDen AnnualReturn_mi, ///
ivar(County) time(Year) gvar(first_treat) long2 wboot seed(6) vce(cluster State)
estat event, estore(had_policy) 

coefplot had_policy, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(3.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Land value in thousand dollars", size(medium) height(5)) ///
ylabel(-5(2.5)5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-5 5)) recast(connected) 
graph export "$doc\PTA.png", replace
