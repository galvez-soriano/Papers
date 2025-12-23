* Load Library
clear all
gl data = "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EthanolCorn/Data"
gl doc = "C:\Users\Oscar Galvez Soriano\Documents\Papers\Ethanol\Doc"
graph set window fontface "Times New Roman"
set scheme s1mono
***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~***
use  "$data/CornQP.dta", clear
gen share_cornuse = ethanoluse/totalproduction

* Share of Corn Use for Ethanol and Corn Production
#delimit;
scatter totalproduction year, connect(l) sort || scatter share_cornuse year, sort connect(l) symbol(s) yaxis(2) ytitle("Share of corn use for ethanol", axis(2))||
||,
   ytitle("Corn production (million bushels)", margin(small)) 
   xlabel(1997(5)2022) 
   legend(label(1 "Total corn production") label(2 "Corn used for ethanol"))
   legend(pos(5) ring(0) col(1)) graphregion(fcolor(white)) xline(2005, lcolor(black) lwidth(thin) lpattern(dash)) 
;
#delimit cr
graph export "$doc/EthanolUSeCornProduction.png",replace

label variable pricesreceivedbyfarmersdoll "Prices received by farmers ($/bushels)"

* Corn Used for Ethanol and Corn Price Received by Farmers
#delimit;
scatter share_cornuse year, connect(l) sort || scatter pricesreceivedbyfarmersdoll year, yaxis(2) sort connect(l) symbol(s) ytitle("Price ($/bushel)", axis(2))||
||,
   ytitle("Share of corn used for ethanol", margin(small)) 
   xlabel(1997(5)2022)
   legend(label(1 "Corn used for ethanol") label(2 "Prices received by farmers"))
   legend(pos(5) ring(0) col(1)) graphregion(fcolor(white)) xline(2005, lcolor(black) lwidth(thin) lpattern(dash)) 
;
#delimit cr
graph export "$doc/EthanolUSePrices.png",replace


* Ethanol Production 
use  "$data/EthanolQ.dta", clear
set obs 26
replace Year = 1997 in 24
replace Year = 1998 in 25
replace Year = 2022 in 26
sort Year
#delimit;
scatter CapacityBGY Year, connect(l) sort || scatter ProductionBGY Year, connect(l) sort symbol(d)
||,
   ytitle("Ethanol production and capacity (BGY)", margin(small)) 
   xlabel(1997(5)2022)
   legend(label(1 "Ethanol capacity") label(2 "Ethanol production"))
   legend(pos(5) ring(0) col(1)) graphregion(fcolor(white)) xline(2005, lcolor(black) lwidth(thin) lpattern(dash)) 
;
#delimit cr
graph export "$doc/EthanolProduction.png", replace

* Ethanol Plant
#delimit;
scatter EthanolPlants Year, sort connect(l) symbol(s)
||,
   ytitle("Ethanol plants", margin(small)) 
   xlabel(1997(5)2022)
   legend(label(1 "Ethanol plants"))
   legend(pos(11) ring(0) col(1)) graphregion(fcolor(white)) xline(2005, lcolor(black) lwidth(thin) lpattern(dash)) 
;
#delimit cr
graph export "$doc/EthanolPlants.png", replace
***~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~***
* Land Value
use  "$data/AnnualFarmlandValue.dta", clear
gen Midwest =1 if State=="ILLINOIS"| State=="INDIANA" |State=="IOWA"| State=="KANSAS"|State=="MICHIGAN"|State=="MINNESOTA"|State=="MISSOURI"|State=="NEBRASKA"|State=="NORTH DAKOTA"|State=="OHIO"|State=="SOUTH DAKOTA"| State=="WISCONSIN"
*replace Midwest=0 if Midwest==. 
gen Topcorn = 1 if State=="ILLINOIS"| State=="NEBRASKA" |State=="IOWA"
gen Non_Topcorn =1 if State=="KANSAS"|State=="MICHIGAN"|State=="MINNESOTA"|State=="MISSOURI"|State=="INDIANA"|State=="NORTH DAKOTA"|State=="OHIO"|State=="SOUTH DAKOTA"| State=="WISCONSIN"

sort Year
by Year: egen mean_Midwest = mean(Value) if Midwest==1 
*by Year: egen mean_Non_Midwest = mean(Value) if Midwest==0 
by Year: egen mean_Topcorn = mean(Value) if Topcorn==1
by Year: egen mean_NonTopcorn = mean(Value) if Non_Topcorn==1 

* Plot
#delimit;
scatter mean_Midwest Year if Year >=1997 & Year <=2022, connect(l) sort || scatter mean_Topcorn Year if Year >=1997 & Year <=2022, sort connect(l) symbol(s)||scatter mean_NonTopcorn Year if Year>=1997 & Year<=2022, sort connect(l) symbol(d)||
||,
||,
   ytitle("Average farmland value ($/acre)", margin(small)) 
   xlabel(1997(5)2022)
   legend(label(1 "Midwest") label(2 "Top corn states") label(3 "Rest of midwest"))
   legend(pos(5) ring(0) col(1)) graphregion(fcolor(white)) xline(2005, lcolor(black) lwidth(thin) lpattern(dash)) 
;
#delimit cr
graph export "$doc/AverageLandValueMidwest.png",replace

