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
use  "$data/RFSdata.dta", clear
drop if TotalArea==0|TotalArea==.
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
gen GovPay_mi = GovPay/1000

label variable TotalAgLand "Total Ag Land (thousand acre)"
label variable GovPay "Gov Payment (thousand)"
label variable TotalCropland "Total Cropland (thousand acre)"
label variable PopDen "Population Density (person/square mile)"
label variable pct_cropland "Percent Cropland"
label variable LandValue_Thousand "Land Value (thousand/acre)"
label variable AnnualReturn_mi "Annual Return (million)"
label variable GovPay_mi "Gov Payment (million)"
label variable PecentPlantedCorn "Corn Planted (\%)"
label variable nccpi "NCCPI"
gen fips_code =real(fips)
xtset fips_code Year, delta(5) 
rename State State_str
encode State_str,gen(State)
rename County County_str
encode County_str,gen(County)

/* keep nccpi LandValue_Thousand State Year GovPay PopDen AnnualReturn_mi County PecentPlantedCorn 
order State County Year*/
/* ========================================================== */
sum nccpi, d
gen treat=nccpi > r(p10)

gen after=Year>2005
gen treat_after=treat*after

areg LandValue_Thousand treat_after State#Year i.Year GovPay PopDen ///
, absorb(County) vce(cluster State)
/* ========================================================== */
sum nccpi, d
gen treat_top=nccpi > r(p75)
replace treat_top=. if treat_top!=1 & treat!=0
gen treat_top_after=treat_top*after

areg LandValue_Thousand treat_top_after State#Year i.Year GovPay PopDen ///
AnnualReturn_mi, absorb(County) vce(cluster State)
/* ========================================================== */
/* Event study graph */
/* ========================================================== */
foreach x in 1997 2002 2007 2012 2017{
gen treat_`x'=0
replace treat_`x'=1 if treat==1 & Year==`x'
label var treat_`x' "`x'"
}

drop treat_after
replace treat_2002=0

areg LandValue_Thousand treat_* State#Year i.Year GovPay PopDen ///
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
xtile pct = nccpi, nq(100) // creates percentile variable

label var pct "Percentile of counties ordered by NCCPI"
graph set window fontface "Times New Roman"

eststo clear
foreach x in 5 6 7 8 9 10 11 12 13 14 15 {

drop treat*

gen treat=pct > `x'
gen treat_after=treat*after

areg LandValue_Thousand treat_after State#Year i.Year GovPay PopDen ///
, absorb(County) vce(cluster State)
estimates store corn`x'
}

label var treat_after "Percentile of the distribution of NCCPI"

coefplot (corn5, label(>5)) (corn6, label(>6)) (corn7, label(>7)) ///
(corn8, label(>8)) (corn9, label(>9)) ///
(corn10, label(>10) mcolor(blue) ciopts(recast(rcap) color(blue))) ///
(corn11, label(>11)) (corn12, label(>12)) (corn13, label(>13)) ///
(corn14, label(>14)) (corn15, label(>15)), ///
vertical keep(treat_after) yline(0) ///
yline(1.029, lstyle(grid) lpattern(dash) lcolor(navy)) ///
ytitle("Land value in thousand dollars", size(medium) height(5)) ///
ylabel(0(0.5)2, labs(medium) grid format(%5.2f)) ///
legend( pos(2) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\sa_landv.png", replace  

/* ========================================================== */
/* Callaway and SantAnna (2021) */
/* ========================================================== */
gen year_pol=0
replace year_pol=Year if treat==1 & Year>=2005
bysort State County: egen first_treat=sum(treat_after)
bysort State County: egen one_year=sum(year_pol) if first_treat==1
bysort State County: egen two_year=min(year_pol) if first_treat==2 & year_pol>0
bysort State County: egen two_year_all=mean(two_year)

replace first_treat=2007 if first_treat==3
replace first_treat=two_year_all if first_treat==2
replace first_treat=one_year if first_treat==1
replace first_treat=. if treat==.

drop one_year two_year two_year_all

csdid LandValue_Thousand treat_after GovPay PopDen AnnualReturn_mi, ///
ivar(County) time(Year) gvar(first_treat) wboot seed(6)
estat all

csdid LandValue_Thousand treat_after GovPay PopDen AnnualReturn_mi, ///
ivar(County) time(Year) gvar(first_treat) long2 wboot seed(6) vce(cluster State)
estat event, estore(treat_after) 

coefplot treat_after, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(1.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Land value in thousand dollars", size(medium) height(5)) ///
ylabel(-3(3)6, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-3 6)) recast(connected) ///
coeflabels(Tm10 = "1997" Tp0 = "2007" Tp5 = "2012" Tp10 = "2017")
graph export "$doc\PTAcsdid.png", replace

/* ========================================================== */
gen year_pol_top=0
replace year_pol_top=Year if treat_top==1 & Year>=2005
bysort State County: egen first_treat_top=sum(treat_top_after)
bysort State County: egen one_year=sum(year_pol) if first_treat_top==1
bysort State County: egen two_year=min(year_pol) if first_treat_top==2 & year_pol>0
bysort State County: egen two_year_all=mean(two_year)

replace first_treat_top=2007 if first_treat_top==3
replace first_treat_top=two_year_all if first_treat_top==2
replace first_treat_top=one_year if first_treat_top==1
replace first_treat_top=. if treat_top==.

drop one_year two_year two_year_all

csdid LandValue_Thousand treat_top_after GovPay PopDen AnnualReturn_mi, ///
ivar(County) time(Year) gvar(first_treat_top) wboot seed(6)
estat all

csdid LandValue_Thousand treat_top_after GovPay PopDen AnnualReturn_mi, ///
ivar(County) time(Year) gvar(first_treat) long2 wboot seed(6) vce(cluster State)
estat event, estore(treat_top_after) 

coefplot treat_top_after, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(1.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Land value in thousand dollars", size(medium) height(5)) ///
ylabel(-2(2)8, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-3 6)) recast(connected) ///
coeflabels(Tm10 = "1997" Tp0 = "2007" Tp5 = "2012" Tp10 = "2017")
graph export "$doc\PTAcsdid_top.png", replace

/* ========================================================== */
/* Sun and Abraham (2021) */
/* ========================================================== */
gen tgroup=first_treat & treat!=.
replace tgroup=. if treat==0
gen cgroup=tgroup==.
replace cgroup=. if treat==.

gen K = Year-first_treat

sum first_treat
gen lastcohort = first_treat==r(max) // dummy for the latest- or never-treated cohort
forvalues l = 0(5)10 {
	gen L`l'event = K==`l'
}
forvalues l = 5(5)10 {
	gen F`l'event = K==-`l'
}
replace F5event=0 // normalize K=-1 to zero

eventstudyinteract LandValue_Thousand treat_after if treat!=., absorb(County Year) ///
cohort(tgroup) control_cohort(cgroup) covariates(GovPay PopDen AnnualReturn_mi) ///
vce(cluster State)

eventstudyinteract LandValue_Thousand L*event F*event if treat!=., absorb(County Year) ///
cohort(tgroup) control_cohort(cgroup) covariates(GovPay PopDen AnnualReturn_mi) ///
vce(cluster State)

event_plot e(b_iw)#e(V_iw), plottype(connected) ciplottype(rcap) together ///
graph_opt(xtitle("Year") legend(off) ///
yline(0, lp(solid) lc(black)) yscale(r(-3 6)) ylabel(-3(3)6) ///
xline(-2, lp(dash) lc(ltblue)) ///
ytitle("Land value in thousand dollars") xlabel(-10 "1997" -5 "2002" 0 "2007" 5 "2012" 10 "2017")) ///
stub_lag(L#event) stub_lead(F#event) ///
lag_opt(color(navy)) lag_ci_opt(color(navy)) ///
lead_opt(color(navy)) lead_ci_opt(color(navy))
graph export "$doc\PTA_SAdid.png", replace

/* ========================================================== */
gen tgroup_top=first_treat_top & treat_top!=.
replace tgroup_top=. if treat_top==0
gen cgroup_top=tgroup_top==.
replace cgroup_top=. if treat_top==.

gen K_top = Year-first_treat_top

sum first_treat_top
gen lastcohort_top = first_treat_top==r(max) // dummy for the latest- or never-treated cohort
forvalues l = 0(5)10 {
	gen L`l'event_top = K_top==`l'
}
forvalues l = 5(5)10 {
	gen F`l'event_top = K_top==-`l'
}
replace F5event_top=0 // normalize K=-1 to zero

eventstudyinteract LandValue_Thousand treat_top_after if treat_top!=., absorb(County Year) ///
cohort(tgroup_top) control_cohort(cgroup_top) covariates(GovPay PopDen AnnualReturn_mi) ///
vce(cluster State)

eventstudyinteract LandValue_Thousand L*event_top F*event_top if treat_top!=., absorb(County Year) ///
cohort(tgroup_top) control_cohort(cgroup_top) covariates(GovPay PopDen AnnualReturn_mi) ///
vce(cluster State)

event_plot e(b_iw)#e(V_iw), plottype(connected) ciplottype(rcap) together ///
graph_opt(xtitle("Year") legend(off) ///
yline(0, lp(solid) lc(black)) yscale(r(-2 8)) ylabel(-2(2)8) ///
xline(-2, lp(dash) lc(ltblue)) ///
ytitle("Land value in thousand dollars") xlabel(-10 "1997" -5 "2002" 0 "2007" 5 "2012" 10 "2017")) ///
stub_lag(L#event_top) stub_lead(F#event_top) ///
lag_opt(color(navy)) lag_ci_opt(color(navy)) ///
lead_opt(color(navy)) lead_ci_opt(color(navy))
graph export "$doc\PTA_SAdid_top.png", replace

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
reg PecentPlantedCorn had_policy after treat, vce(cluster State)
reg GovPay had_policy after treat, vce(cluster State)
reg AnnualReturn_mi had_policy after treat, vce(cluster State)
reg PopDen had_policy after treat, vce(cluster State)
reg nccpi had_policy after treat, vce(cluster State)