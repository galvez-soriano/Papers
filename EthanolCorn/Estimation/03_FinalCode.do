/* ========================================================== */
clear 
set more off
gl data = "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EthanolCorn/Data"
gl base = "C:\Users\Oscar Galvez Soriano\Documents\Papers\Ethanol\Data"
gl doc = "C:\Users\Oscar Galvez Soriano\Documents\Papers\Ethanol\Doc"
graph set window fontface "Times New Roman"
set scheme s1mono
/* ========================================================== */
* MAIN RESULTS
/* ========================================================== */
use "$base/AgDBase.dta", clear
* Summary statistics table: Full Sample
summarize nccpi, detail
gen Treat = (nccpi > r(p10)) 
gen Post = (Year>2005)
gen DiD = Treat*Post
label variable DiD "Treat x After"
/* ========================================================== */
* Table 1. Summary Statistics for full sample
/* ========================================================== */
eststo clear 
estpost tabstat LandValue_Thousand TotalCropland TotalAgLand pct_cropland ///
PecentPlantedCorn Gov_dollarperacre  PopDen nccpi if Treat~=., c(stat) ///
stat(sum mean sd min max)
esttab using"$doc/tab1_SummaryStatistics.tex",replace ///
cells("mean(fmt(%6.2fc)) sd(fmt(%6.2fc)) min(fmt(%6.2fc)) max(fmt(%6.2fc))") ///
sfmt(%6.2fc) nonumber title(Summary Statistics) nonote noobs label ///
collabels("Mean" "SD" "Min" "Max")
/* ========================================================== */
* Table 2. Effect of Ethanol Boom on Farmland Values
/* ========================================================== */
/* Panel A */
/* ========================================================== */
eststo clear
areg LandValue_Thousand DiD i.Year State#Year, absorb(County) cluster(County)
eststo reg1
boottest DiD, seed(6) weight(webb) noci
areg LandValue_Thousand DiD PopDen i.Year State#Year, absorb(County) cluster(County)
eststo reg2
boottest DiD, seed(6) weight(webb) noci
esttab reg* using"$doc/reg1_DiD.tex", replace  ///
keep(DiD PopDen) b(3)se(3) stats(N r2, fmt(%9.0fc %9.3f)) ///
label unstack title("Effect of Ethanol Boom on Farmland Values")
/* ========================================================== */
/* Figure 3. */
/* ========================================================== */
/* Panel (a) */
/* ========================================================== */
sort Year
by Year: egen mean_Treat1 = mean(LandValue_Thousand) if Treat==1 
by Year: egen mean_Treat0 = mean(LandValue_Thousand) if Treat==0

#delimit;
scatter mean_Treat1 Year, connect(l) sort || scatter mean_Treat0 Year, sort connect(l)
||,
   ytitle("Average farmland value (thousands/acre)", margin(small))
   xlabel(1997(5)2022) plotregion(style(none))
   legend(label(1 "High suitability") label(2 "Low suitability"))
   legend(pos(11) ring(0) col(1)) graphregion(fcolor(white)) xline(2005, lcolor(gray) lwidth(thin) lpattern(dash)) 
;
#delimit cr
graph export "$doc/AverageLand.png",replace

/* Panel (b) */
gen zero=0
gen dumyr97=Year==1997
gen dumyr07=Year==2007
gen dumyr12=Year==2012
gen dumyr17=Year==2017
gen dumyr22=Year==2022
gen interact97=dumyr97*Treat
gen interact07=dumyr07*Treat
gen interact12=dumyr12*Treat
gen interact17=dumyr17*Treat
gen interact22=dumyr22*Treat
label variable zero "2002"
label variable interact97 "1997"
label variable interact07 "2007"
label variable interact12 "2012"
label variable interact17 "2017"
label variable interact22 "2022"

areg LandValue_Thousand interact97 zero interact07 interact12 interact17 interact22 PopDen i.Year i.State#i.Year, absorb(County) cluster(County)
#delimit;
coefplot, vertical keep(interact97 zero interact07 interact12 interact17 interact22) yline(0) 
	ylabel(-2(2)4, labs(medium) grid format(%5.0f)) plotregion(style(none))
	xline(2.5, lcolor(gray) lwidth(thin) lpattern(dash))  mcolor(black) msize(small) ciopts(lcolor(gray)) omitted baselevels 
	graphregion(fcolor(white)) xtitle(Year) ytitle(Change in farmland value (thousands)) 
;
#delimit cr
graph export "$doc/Did.png",replace
****************************************************************************************
* Top Quartile
****************************************************************************************
drop Treat DiD
sum nccpi, detail
gen Treat = 1 if nccpi >=r(p75)
replace Treat = 0 if nccpi <=r(p10)

gen DiD = Treat*Post
label variable DiD "Treat x After"
/* ========================================================== */
* Table 2.
/* ========================================================== */
/* Panel B */
/* ========================================================== */
eststo clear
areg LandValue_Thousand DiD i.Year i.State#i.Year, absorb(County) cluster(County)
eststo reg1
boottest DiD, seed(6) weight(webb) noci
areg LandValue_Thousand DiD PopDen i.Year i.State#i.Year, absorb(County) cluster(County)
eststo reg2
boottest DiD, seed(6) weight(webb) noci
esttab reg* using"$doc\reg1_DiD_TopCorn.tex", replace ///
keep( DiD PopDen) b(3) se(3) label stats(N r2, fmt(%9.0fc %9.3f)) ///
unstack title("Effects of the Ethanol Boom on Midwest Top Corn Suitability Counties")

/* ========================================================== */
/* Figure 3. */
/* ========================================================== */
/* Panel (c) */
/* ========================================================== */
drop mean_Treat1 mean_Treat0
sort Year
by Year: egen mean_Treat1 = mean(LandValue_Thousand) if Treat==1 
by Year: egen mean_Treat0 = mean(LandValue_Thousand) if Treat==0

#delimit;
scatter mean_Treat1 Year, connect(l) sort || scatter mean_Treat0 Year, sort connect(l)
||,
   ytitle("Average farmland value (thousands/acre)", margin(small))
   xlabel(1997(5)2022) plotregion(style(none))
   legend(label(1 "Top suitability") label(2 "Low suitability"))
   legend(pos(11) ring(0) col(1)) graphregion(fcolor(white)) xline(2005, lcolor(gray) lwidth(thin) lpattern(dash)) 
;
#delimit cr
graph export "$doc\AverageLand_TopCorn.png",replace

/* ========================================================== */
/* Panel (d) */
/* ========================================================== */
drop interact*
gen interact97=dumyr97*Treat
gen interact07=dumyr07*Treat
gen interact12=dumyr12*Treat
gen interact17=dumyr17*Treat
gen interact22=dumyr22*Treat
label variable zero "2002"
label variable interact97 "1997"
label variable interact07 "2007"
label variable interact12 "2012"
label variable interact17 "2017"
label variable interact22 "2022"

areg LandValue_Thousand interact97 zero interact07 interact12 interact17 interact22 PopDen i.Year i.State#i.Year, absorb(County) cluster(County)
#delimit;
coefplot, vertical keep(interact97 zero interact07 interact12 interact17 interact22) yline(0) 
	ylabel(-2(2)4, labs(medium) grid format(%5.0f)) plotregion(style(none))
	xline(2.5, lcolor(gray) lwidth(thin) lpattern(dash))  mcolor(black) msize(small) ciopts(lcolor(black)) omitted baselevels 
	graphregion(fcolor(white)) xtitle(Year) ytitle(Change in farmland value (thousands))
;
#delimit cr
graph export "$doc\Did_TopCorn.png",replace

****************************************************************************************
* Heterogeneity
****************************************************************************************
xtile Q_nccpi = nccpi, nq(5)
gen  Q2 = (Q_nccpi ==2)
gen  Q3 = (Q_nccpi ==3)
gen  Q4 = (Q_nccpi ==4)
gen  Q5 = (Q_nccpi ==5)

gen Q2_after = Q2*Post
gen Q3_after = Q3*Post
gen Q4_after = Q4*Post
gen Q5_after = Q5*Post

label variable Q2_after "Second Lowest"
label variable Q3_after "Middle"
label variable Q4_after "Second Highest"
label variable Q5_after "Highest"

/* ========================================================== */
/* Figure 4: Effects by soil quality */
/* ========================================================== */
areg LandValue_Thousand Q2 Q3 Q4 Q5 Q2_after Q3_after Q4_after Q5_after PopDen  i.Year i.State#i.Year, absorb(County) cluster(County)
#delimit;
coefplot, keep(Q2_after Q3_after Q4_after Q5_after) yline(0) mcolor(black) msize(small) ciopts(lcolor(black)) omitted baselevels 
	graphregion(fcolor(white)) xtitle(Change in farmland value (thousands)) plotregion(style(none))
;
#delimit cr
graph export "$doc\DiD_byQuintile.png", replace

/* ========================================================== */
/* Figure 5: Effects by income */
/* ========================================================== */
summarize PI, detail
gen HighInc = (PI > r(p50)) 
drop interact* Treat
sum nccpi, d
gen Treat = (nccpi > r(p10))
gen interact97=dumyr97*Treat
gen interact07=dumyr07*Treat
gen interact12=dumyr12*Treat
gen interact17=dumyr17*Treat
gen interact22=dumyr22*Treat
label variable interact97 "1997"
label variable interact07 "2007"
label variable interact12 "2012"
label variable interact17 "2017"
label variable interact22 "2022"

areg LandValue_Thousand interact97 zero interact07 interact12 interact17 interact22 PopDen i.Year i.State#i.Year if HighInc==1, absorb(County) cluster(County)
estimates store HI_1
areg LandValue_Thousand interact97 zero interact07 interact12 interact17 interact22 PopDen i.Year i.State#i.Year if HighInc==0, absorb(County) cluster(County)
estimates store HI_0

#delimit;
coefplot
(HI_0, label(Low income) msize(small) msymbol(T) mcolor(gs4) ciopt(lc(gs4) recast(gs4)) lc(gs4)) 
(HI_1, offset(-0.1) label(High income) msize(small) msymbol(O) mcolor(gs10) ciopt(lc(gs10) recast(gs10)) lc(gs10)), 
vertical yline(0) keep(interact97 zero interact07 interact12 interact17 interact22) omitted baselevels 
xline(2.5, lstyle(grid) lpattern(dash) lcolor(black))
ytitle("Change in farmland value (thousands)", size(medium) height(5))
ylabel(-2(2)4, labs(medium) grid format(%5.0f))
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) 
legend(pos(11) ring(0) col(1)) 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
ysc(r(-2 2)) plotregion(style(none))
;
#delimit cr
graph export "$doc\DiD_byIncome.png", replace
****************************************************************************************
* Robustness Checks
****************************************************************************************
/* ========================================================== */
/* Figure 6. Sensitivity Analysis */
/* ========================================================== */
xtile pct = nccpi, nq(100) // creates percentile variable
gen after = (Year>2005)
label var pct "Percentile of counties ordered by NCCPI"
gen treat =1
eststo clear
foreach x in 5 6 7 8 9 10 11 12 13 14 15 {

drop treat*

gen treat=pct > `x'
gen treat_after=treat*after

areg LandValue_Thousand treat_after PopDen i.Year i.State#i.Year , absorb(County) cluster(County)
estimates store corn`x'
}

label var treat_after "Percentile of the distribution of NCCPI"

coefplot (corn5, label(>5)) (corn6, label(>6)) (corn7, label(>7)) ///
(corn8, label(>8)) (corn9, label(>9)) ///
(corn10, label(>10) mcolor(black) ciopts(color(black))) ///
(corn11, label(>11)) (corn12, label(>12)) (corn13, label(>13)) ///
(corn14, label(>14)) (corn15, label(>15)), ///
vertical keep(treat_after) ///
yline(1.147, lstyle(grid) lpattern(dash) lcolor(gray)) ///
ytitle("Change of farmland value (thousands)", size(medium) height(5)) ///
ylabel(-1(1)3, labs(medium) grid format(%5.0f)) ///
legend( pos(5) ring(0) col(4)) ///
graphregion(color(white)) scheme(s2mono) ciopts()
graph export "$doc\sa_landv.png", replace  

/* ========================================================== */
* Table 3. Robustness Check: Removing Big Corn Producers
/* ========================================================== */
drop Treat DiD
summarize nccpi, detail
gen Treat = (nccpi > r(p10)) 

gen DiD = Treat*Post
label variable DiD "Treat x After"

* Excluded IOWA
areg LandValue_Thousand DiD PopDen i.Year i.State#i.Year ///
if State_str!= "IOWA", absorb(County) cluster(County)
eststo reg1
boottest DiD, seed(6) weight(webb) noci
* Excluded IOWA and Illinois
areg LandValue_Thousand DiD PopDen i.Year i.State#i.Year ///
if State_str!="IOWA" & State_str!="ILLINOIS", absorb(County) cluster(County)
eststo reg2
boottest DiD, seed(6) weight(webb) noci
* Excluded IOWA and Illinois and Nebraska
areg LandValue_Thousand DiD PopDen i.Year i.State#i.Year ///
if State_str!="IOWA" & State_str!="ILLINOIS" & State_str!="NEBRASKA", absorb(County) cluster(County)
eststo reg3
boottest DiD, seed(6) weight(webb) noci

esttab reg* using"$doc\reg6_DiD_Robust.tex", replace ///
keep(DiD PopDen)  b(3)se(3) label unstack ///
title("Robustness Check: Removing Big Corn Producers") stats(N r2, fmt(%9.0fc %9.3f))
/* ========================================================== */
/* Figure 7. Removing switchers */
/* ========================================================== */
drop interact*
gen interact97=dumyr97*Treat
gen interact07=dumyr07*Treat
gen interact12=dumyr12*Treat
gen interact17=dumyr17*Treat
gen interact22=dumyr22*Treat
label variable interact97 "1997"
label variable interact07 "2007"
label variable interact12 "2012"
label variable interact17 "2017"
label variable interact22 "2022"

replace cornpc=1 if cornpc==. & Treat==0

areg LandValue_Thousand interact97 zero interact07 interact12 interact17 interact22 PopDen i.Year i.State#i.Year if cornpc!=., absorb(County) cluster(County)
estimates store woswithers
areg LandValue_Thousand interact97 zero interact07 interact12 interact17 interact22 PopDen i.Year i.State#i.Year, absorb(County) cluster(County)
estimates store wswithers

#delimit;
coefplot
(wswithers, label(Full sample) msize(small) msymbol(T) mcolor(gs4) ciopt(lc(gs4) recast(gs4)) lc(gs4)) 
(woswithers, offset(-0.1) label(No-switchers) msize(small) msymbol(O) mcolor(gs10) ciopt(lc(gs10) recast(gs10)) lc(gs10)), 
vertical yline(0) keep(interact97 zero interact07 interact12 interact17 interact22) omitted baselevels 
xline(2.5, lstyle(grid) lpattern(dash) lcolor(black))
ytitle("Change in farmland value (thousands)", size(medium) height(5))
ylabel(-2(2)4, labs(medium) grid format(%5.0f))
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) 
legend(pos(11) ring(0) col(1)) 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
ysc(r(-2 2)) plotregion(style(none))
;
#delimit cr
graph export "$doc\Did_Switchers.png", replace
****************************************************************************************
* Mechanisms
****************************************************************************************
/* ========================================================== */
/* Figure 8. Expanding area of corn production */
/* ========================================================== */
areg LandValue_Thousand interact97 zero interact07 interact12 interact17 interact22 PopDen i.Year i.State#i.Year if ext_margin==0, absorb(County) cluster(County)
estimates store ext_marg
areg LandValue_Thousand interact97 zero interact07 interact12 interact17 interact22 PopDen i.Year i.State#i.Year if ext_margin==1, absorb(County) cluster(County)
estimates store int_marg

#delimit;
coefplot
(ext_marg, label(Demand + price effect) msize(small) msymbol(T) mcolor(gs4) ciopt(lc(gs4) recast(gs4)) lc(gs4)) 
(int_marg, offset(-0.1) label(Price effect) msize(small) msymbol(O) mcolor(gs10) ciopt(lc(gs10) recast(gs10)) lc(gs10)), 
vertical yline(0) keep(interact97 zero interact07 interact12 interact17 interact22) omitted baselevels 
xline(2.5, lstyle(grid) lpattern(dash) lcolor(black))
ytitle("Change in farmland value (thousands)", size(medium) height(5))
ylabel(-2(2)4, labs(medium) grid format(%5.0f))
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) 
legend(pos(11) ring(0) col(1)) 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
ysc(r(-2 2)) plotregion(style(none))
;
#delimit cr
graph export "$doc\Did_ExtMargin.png", replace

/* ========================================================== */
/* Figure X. By ethanol plants */
/* ========================================================== */
areg LandValue_Thousand interact97 zero interact07 interact12 interact17 interact22 PopDen i.Year i.State#i.Year if ethanol_plant==1, absorb(County) cluster(County)
estimates store ethanol
areg LandValue_Thousand interact97 zero interact07 interact12 interact17 interact22 PopDen i.Year i.State#i.Year if ethanol_plant==0, absorb(County) cluster(County)
estimates store noethanol

#delimit;
coefplot
(ethanol, label(Ethanol plants counties) msize(small) msymbol(T) mcolor(gs4) ciopt(lc(gs4) recast(gs4)) lc(gs4)) 
(noethanol, offset(-0.1) label(No ethanol plants counties) msize(small) msymbol(O) mcolor(gs10) ciopt(lc(gs10) recast(gs10)) lc(gs10)), 
vertical yline(0) keep(interact97 zero interact07 interact12 interact17 interact22) omitted baselevels 
xline(2.5, lstyle(grid) lpattern(dash) lcolor(black))
ytitle("Change in farmland value (thousands)", size(medium) height(5))
ylabel(-2(2)4, labs(medium) grid format(%5.0f))
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) 
legend(pos(11) ring(0) col(1)) 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
ysc(r(-2 2)) plotregion(style(none))
;
#delimit cr
graph export "$doc\Did_EthanolPlants.png", replace

/* ========================================================== */
* Appendix
/* ========================================================== */
* Table A.1. Summary Statistics: Full sample
/* ========================================================== */
drop Treat DiD
summarize nccpi, detail
gen Treat = (nccpi > r(p10)) 
gen DiD = Treat*Post
label variable DiD "Treat x After"

eststo clear
eststo grp1: quietly estpost summarize LandValue_Thousand TotalCropland TotalAgLand pct_cropland PecentPlantedCorn Gov_dollarperacre PopDen nccpi if Treat==1 & Post ==0
eststo grp2: quietly estpost summarize LandValue_Thousand TotalCropland TotalAgLand pct_cropland PecentPlantedCorn Gov_dollarperacre PopDen nccpi if Treat==1 & Post ==1
eststo grp3: quietly estpost summarize LandValue_Thousand TotalCropland TotalAgLand pct_cropland PecentPlantedCorn Gov_dollarperacre PopDen nccpi if Treat==0 & Post ==0
eststo grp4: quietly estpost summarize LandValue_Thousand TotalCropland TotalAgLand pct_cropland PecentPlantedCorn Gov_dollarperacre PopDen nccpi if Treat==0 & Post ==1
esttab grp*, main(mean %6.2f) aux(sd) mtitle("Before" "After" "Before" "After")
esttab grp* using"$doc\tab2.SummaryStatistics_DiD.tex", replace  ///
main(mean %15.2fc) aux(sd %15.2fc) label nostar nonumber unstack  nonote ///
mtitle("Before" "After" "Before" "After")  ///
mgroups("High Suitability" "Low Suitability", pattern(1 0 1 0 ) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span ///
erepeat(\cmidrule(lr){@span})) stats(N, fmt(%9.0fc)) ///
title("Summary Statistics: High and Low Corn Suitability Counties")

/* ========================================================== */
* Table A.1. Summary Statistics: Top and Bottom Corn Suitability Counties
/* ========================================================== */
drop Treat DiD
sum nccpi, detail
gen Treat = 1 if nccpi >=r(p75)
replace Treat = 0 if nccpi <=r(p10)
gen DiD = Treat*Post
label variable DiD "Treat x After"

eststo clear
eststo grp1: quietly estpost summarize LandValue_Thousand TotalCropland TotalAgLand pct_cropland PecentPlantedCorn Gov_dollarperacre PopDen nccpi if Treat==1 & Post ==0
eststo grp2: quietly estpost summarize LandValue_Thousand TotalCropland TotalAgLand pct_cropland PecentPlantedCorn Gov_dollarperacre PopDen nccpi if Treat==1 & Post ==1
eststo grp3: quietly estpost summarize LandValue_Thousand TotalCropland TotalAgLand pct_cropland PecentPlantedCorn Gov_dollarperacre PopDen nccpi if Treat==0 & Post ==0
eststo grp4: quietly estpost summarize LandValue_Thousand TotalCropland TotalAgLand pct_cropland PecentPlantedCorn Gov_dollarperacre PopDen nccpi if Treat==0 & Post ==1
esttab grp*, main(mean %6.2f) aux(sd) mtitle("Before" "After" "Before" "After")
esttab grp* using"$doc\tabA1_SummaryStatistics_Top25.tex", replace ///
main(mean %15.2fc) aux(sd %15.2fc) label nostar nonumber unstack  ///
nonote mtitle("Before" "After" "Before" "After")  ///
mgroups("Top Suitability" "Low Suitability", pattern(1 0 1 0 ) ///
prefix(\multicolumn{@span}{c}{) suffix(}) span ///
erepeat(\cmidrule(lr){@span})) stats(N, fmt(%9.0fc)) ///
title("Summary Statistics: Top and Bottom Corn Suitability Counties")

/* ========================================================== */
* Table A2. Summary Statistics: Corn Suitability by Quintile
/* ========================================================== */
xtile Q_nccpi = nccpi, nq(5)
gen  Q2 = (Q_nccpi ==2)
gen  Q3 = (Q_nccpi ==3)
gen  Q4 = (Q_nccpi ==4)
gen  Q5 = (Q_nccpi ==5)

gen Q2_after = Q2*Post
gen Q3_after = Q3*Post
gen Q4_after = Q4*Post
gen Q5_after = Q5*Post

label variable Q2_after "Second Lowest"
label variable Q3_after "Middle"
label variable Q4_after "Second Highest"
label variable Q5_after "Highest"

eststo clear
*eststo grp1: quietly estpost summarize LandValue_Thousand TotalCropland TotalAgLand pct_cropland PecentPlantedCorn Gov_dollarperacre PopDen nccpi if Q_nccpi ==1
eststo grp2: quietly estpost summarize LandValue_Thousand TotalCropland TotalAgLand pct_cropland PecentPlantedCorn Gov_dollarperacre PopDen nccpi if Q_nccpi ==2
eststo grp3: quietly estpost summarize LandValue_Thousand TotalCropland TotalAgLand pct_cropland PecentPlantedCorn Gov_dollarperacre PopDen nccpi if Q_nccpi==3
eststo grp4: quietly estpost summarize LandValue_Thousand TotalCropland TotalAgLand pct_cropland PecentPlantedCorn Gov_dollarperacre PopDen nccpi if Q_nccpi ==4
eststo grp5: quietly estpost summarize LandValue_Thousand TotalCropland TotalAgLand pct_cropland PecentPlantedCorn Gov_dollarperacre PopDen nccpi if Q_nccpi==5
esttab grp*, main(mean %6.2f) aux(sd) mtitle("Second Lowest" "Midle" "Second Highest" "Highest")
esttab grp* using"$doc\tabA2_SummaryStatistics_by Quintiles.tex", replace  ///
main(mean %15.2fc) aux(sd %15.2fc) label nostar nonumber unstack nonote ///
mtitle("Second Lowest" "Midle" "Second Highest" "Highest") ///
mgroups("Quintiles", pattern(1 0 0 0) prefix(\multicolumn{@span}{c}{) ///
suffix(}) span erepeat(\cmidrule(lr){@span})) stats(N, fmt(%9.0fc)) ///
title("Summary Statistics: Corn Suitability by Quintile")