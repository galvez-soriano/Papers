*========================================================================*
* English program and earnings
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
set maxvar 120000
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Doc"
*========================================================================*
/*
use "$data/Papers/main/EngMigration/Data/labor_census20_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 {
    append using "$data/Papers/main/EngMigration/Data/labor_census20_`x'.dta"
}
save "$base\labor_census20.dta", replace 
*/
*========================================================================*
/* FIGURE 3. Event-study graphs: de Chaisemartin and D'Haultfoeuille (2020) */
*========================================================================*
use "$base\labor_census20.dta", clear
drop if state=="05" | state=="17"
drop lwage
gen lwage=log(wage+1)
replace wpaid=. if work==0
gen migra_ret=migrant==1 & conact!=.
*replace dmigrant=0 if migrant==1

drop if imputed_state==1

sum hrs_exp2 if state=="01" & cohort>=1990 & cohort<=1996, d
return list
gen engl=hrs_exp2>=r(p50) & state=="01"
sum hrs_exp2 if state=="10" & cohort>=1991 & cohort<=1996, d
return list
replace engl=1 if hrs_exp2>=r(p50) & state=="10"
sum hrs_exp2 if state=="19" & cohort>=1987 & cohort<=1996, d
return list
replace engl=1 if hrs_exp2>=r(p50) & state=="19"
sum hrs_exp2 if state=="25" & cohort>=1993 & cohort<=1996, d
return list
replace engl=1 if hrs_exp2>=r(p50) & state=="25"
sum hrs_exp2 if state=="26" & cohort>=1993 & cohort<=1996, d
return list
replace engl=1 if hrs_exp2>=r(p50) & state=="26"
sum hrs_exp2 if state=="28" & cohort>=1990 & cohort<=1996, d
return list
replace engl=1 if hrs_exp2>=r(p50) & state=="28"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

gen first_cohort=0
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

keep if cohort>=1984 & cohort<=1994

destring geo, replace
*========================================================================*
/* Panel (a). Domestic migration */
*========================================================================*
csdid dmigrant female migrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_dmigrant)

coefplot csdid_dmigrant, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of migrating domestically", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_dmigrant.png", replace

*========================================================================*
/* Panel (b). Likelihood of migrating abroad */
*========================================================================*
csdid migrant female dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_migrant)

coefplot csdid_migrant, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of migrating abroad", size(medium) height(5)) ///
ylabel(-0.04(0.02)0.04, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.04 0.04)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_migrant.png", replace

*========================================================================*
/* Panel (c). Likelihood of returning to Mexico after migration */
*========================================================================*
csdid migra_ret female dmigrant if migrant==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_rmigrant)

coefplot csdid_rmigrant, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of returning to Mexico after migration", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_rmigrant.png", replace

*========================================================================*
/* Panel (d). Likelihood of migrating to the US */
*========================================================================*
csdid dest_us female dmigrant if migrant==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_USmigrant)

coefplot csdid_USmigrant, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of migrating to the US", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_USmigrant.png", replace

*========================================================================*
/*
replace time_migra=0 if time_migra==. & migra_ret==1
replace time_migra=100 if time_migra==. & migrant==1

csdid time_migra if dmigrant==0 & migrant==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_Tmigra)

coefplot csdid_Tmigra, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Time lenght living abroad (months)", size(medium) height(5)) ///
ylabel(-60(30)60, labs(medium) grid format(%5.0f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-60 60)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_Tmigra.png", replace
*/
*========================================================================*
/* FIGURE 3. Event-study graphs: Callaway and SantAnna (2021) */
*========================================================================*
/* Panel (a). Work */
*========================================================================*
csdid work edu female migrant dmigrant [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_work)

coefplot csdid_work, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of working", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_work.png", replace

*========================================================================*
/* Panel (b). Wages */
*========================================================================*
csdid lwage edu female migrant dmigrant if work==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_wage)

coefplot csdid_wage, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages (if works)", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_wage.png", replace

*========================================================================*
/* Appendix */
*========================================================================*
/* FIGURE A.1. Event-study graphs */
*========================================================================*
/* Panel (a). Diversification */
*========================================================================*
gen dest_amer=.
replace dest_amer=0 if destination_c!=.
replace dest_amer=1 if destination_c>=200 & destination_c<300
replace dest_amer=0 if destination_c==221
replace dest_amer=. if destination_c==999

gen dest_asia=.
replace dest_asia=0 if destination_c!=.
replace dest_asia=1 if (destination_c>=300 & destination_c<400) | ///
(destination_c>=100 & destination_c<200) | (destination_c>=500 & destination_c<600)
replace dest_asia=. if destination_c==999

gen dest_euro=.
replace dest_euro=0 if destination_c!=.
replace dest_euro=1 if (destination_c>=400 & destination_c<500)
replace dest_euro=. if destination_c==999


csdid dest_amer female dmigrant if migrant==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_AMERmigrant)

csdid dest_euro female dmigrant if migrant==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_EUROmigrant)

csdid dest_asia female dmigrant if migrant==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_ASIAmigrant)

coefplot ///
(csdid_EUROmigrant, offset(-0.1) label(Europe) msize(small) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)) ///
(csdid_AMERmigrant, label(Americas (except US)) msize(small) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(navy)) lc(navy)) ///
(csdid_ASIAmigrant, offset(0.1) label(Rest of the world) msize(small) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap)) lc(ltblue)), ///
vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of migrating to destiny", size(medium) height(5)) ///
ylabel(-0.6(0.3)0.6, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
legend(pos(5) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.6 0.6)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_DESTmigrant.png", replace

*========================================================================*
/* Panel (b). Likelihood of migrating to Hispanic countries */
*========================================================================*
gen dest_spanish=.
replace dest_spanish=0 if destination_c!=.
replace dest_spanish=1 if (destination_c>=200 & destination_c<=210) | ///
destination_c==212 | (destination_c>=214 & destination_c<=220) | ///
destination_c==222 | (destination_c>=225 & destination_c<=252) | ///
destination_c==415
replace dest_spanish=0 if destination_c==226 | destination_c==244
replace dest_spanish=. if destination_c==999

gen dest_no_spanish=.
replace dest_no_spanish=0 if dest_spanish==1
replace dest_no_spanish=1 if dest_spanish==0
replace dest_no_spanish=0 if destination_c==221

csdid dest_spanish female dmigrant if migrant==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_SPANISHmigrant)

csdid dest_no_spanish female dmigrant if migrant==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_NoSPANISHmigrant)

coefplot ///
(csdid_SPANISHmigrant, label(Hispanic countries) msize(small) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(navy)) lc(navy)) /// 
(csdid_NoSPANISHmigrant, offset(-0.1) label(Non-Hispanic countries (except US)) msize(small) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of migrating to countries by speaking language", size(medium) height(5)) ///
ylabel(-0.8(0.4)0.8, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
legend(pos(5) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.8 0.8)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_SPANISHmigrant.png", replace






*========================================================================*
/* END of do file */
*========================================================================*







reghdfe dest_us treat* if cohort>=1984 & cohort<=1994 & migrant==1 & dmigrant==0  ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store destus_ss
reghdfe dest_us treat* female if cohort>=1984 & cohort<=1994 & migrant==1 & dmigrant==0  ///
[aw=factor], absorb(cohort geo) vce(cluster geo)
estimates store destus_ssc

coefplot ///
(destus_ss, label(Sample without controls) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(ltblue)) lc(ltblue)) ///
(destus_ssc, offset(-0.1) label(Sample with controls) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of migrating to the US", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(off) ///
ysc(r(-1 1)) recast(connected)
graph export "$doc\PTA_SDD10.png", replace


*========================================================================*
/* Jobs classifications */
*========================================================================*
use "$data\census20.dta", clear

merge m:m geo cohort using "$base\exposure_mun.dta"
drop if _merge!=3
drop _merge
replace actividades_c=. if actividades_c==9999

merge m:m geo using "$base\p_stud.dta"
drop _merge

drop if geo=="19041"

gen econ_act=.
replace econ_act=1 if actividades_c<=1199
replace econ_act=2 if (actividades_c>1199 & actividades_c<=2399) | ///
(actividades_c>4699 & actividades_c<=4930)
replace econ_act=3 if actividades_c>2399 & actividades_c<=3399
replace econ_act=4 if actividades_c>3399 & actividades_c<=4699
replace econ_act=5 if (actividades_c>5399 & actividades_c<=5622) | ///
(actividades_c>7223 & actividades_c<=8140) | (actividades_c>5199 & actividades_c<=5399)
replace econ_act=6 if (actividades_c>5622 & actividades_c<=6299) | ///
(actividades_c>8140 & actividades_c!=.)
replace econ_act=7 if (actividades_c>6299 & actividades_c<=7223) | ///
(actividades_c>4930 & actividades_c<=5199)

label define econ_act 1 "Agriculture" 2 "Construction" 3 "Manufactures" 4 "Commerce" ///
5 "Professionals" 6 "Government" 7 "Hospitality and Entertainment"
label values econ_act econ_act

gen ag_ea=1 if econ_act==1
replace ag_ea=0 if econ_act!=1 & econ_act!=.
gen cons_ea=1 if econ_act==2
replace cons_ea=0 if econ_act!=2 & econ_act!=.
gen manu_ea=1 if econ_act==3
replace manu_ea=0 if econ_act!=3 & econ_act!=.
gen comm_ea=1 if econ_act==4
replace comm_ea=0 if econ_act!=4 & econ_act!=.
gen pro_ea=1 if econ_act==5
replace pro_ea=0 if econ_act!=5 & econ_act!=.
gen gov_ea=1 if econ_act==6
replace gov_ea=0 if econ_act!=6 & econ_act!=.
gen hosp_ea=1 if econ_act==7
replace hosp_ea=0 if econ_act!=7 & econ_act!=.

gen occup=.
replace occup=1 if ocupacion_c>=610 & ocupacion_c<=699
replace occup=2 if ocupacion_c>=411 & ocupacion_c<=499
replace occup=3 if ocupacion_c>=510 & ocupacion_c<=541
replace occup=4 if ocupacion_c>=710 & ocupacion_c<=799
replace occup=5 if ocupacion_c>=911 & ocupacion_c<=989
replace occup=6 if ocupacion_c>=810 & ocupacion_c<=899
replace occup=7 if ocupacion_c>=111 & ocupacion_c<=399

label define occup 1 "Agriculture" 2 "Commerce" ///
3 "Services" 4 "Crafts" 5 "Manual work" ///
6 "Skilled job" 7 "Professional" 
label values occup occup

gen ag_o=1 if occup==1
replace ag_o=0 if occup!=1 & occup!=.
gen com_o=1 if occup==2
replace com_o=0 if occup!=2 & occup!=.
gen ser_o=1 if occup==3
replace ser_o=0 if occup!=3 & occup!=.
gen cft_o=1 if occup==4
replace cft_o=0 if occup!=4 & occup!=.
gen man_o=1 if occup==5
replace man_o=0 if occup!=5 & occup!=.
gen skil_o=1 if occup==6
replace skil_o=0 if occup!=6 & occup!=.
gen prof_o=1 if occup==7
replace prof_o=0 if occup!=7 & occup!=.

*========================================================================*
/* Indigenous regressions */
*========================================================================*
gen uilanguage=hlengua==1 | elengua==1

areg indigenous had_policy rural female migrant edu i.cohort [aw=factor] if dmigrant==0, absorb(geo) vce(cluster geo)
areg hlengua had_policy rural female migrant edu i.cohort [aw=factor] if dmigrant==0, absorb(geo) vce(cluster geo)
areg elengua had_policy rural female migrant edu i.cohort [aw=factor] if dmigrant==0, absorb(geo) vce(cluster geo)
areg uilanguage had_policy rural female migrant edu i.cohort [aw=factor] if dmigrant==0, absorb(geo) vce(cluster geo)

areg hlengua had_policy rural female migrant edu i.cohort [aw=factor] if dmigrant==0 & female==0, absorb(geo) vce(cluster geo)
areg hlengua had_policy rural female migrant edu i.cohort [aw=factor] if dmigrant==0 & female==1, absorb(geo) vce(cluster geo)


csdid hlengua edu rural female migrant if dmigrant==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_speaksInd)

coefplot csdid_speaksInd, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking an indigenous language", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_speaksInd.png", replace



csdid elengua edu rural female migrant if dmigrant==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_understInd)

coefplot csdid_understInd, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of understanding an indigenous language", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_understInd.png", replace



csdid hespanol edu rural female migrant if dmigrant==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_speaksSpa)

coefplot csdid_speaksSpa, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking Spanish language", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_speaksSpa.png", replace





csdid elengua edu rural migrant if dmigrant==0 & female==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_understIndM)

csdid elengua edu rural migrant if dmigrant==0 & female==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_understIndW)

coefplot ///
(csdid_understIndM, label(Men) msymbol(O) mcolor(blue) ciopt(lc(blue) recast(blue)) lc(blue)) ///
(csdid_understIndW, offset(-0.1) label(Women) msymbol(T) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap)) lc(ltblue)), ///
vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of understanding an indigenous language", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
legend(pos(5) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_understIndSex.png", replace


csdid elengua edu female migrant if dmigrant==0 & rural==0 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_understIndU)

csdid elengua edu female migrant if dmigrant==0 & rural==1 [iw=factor], ///
time(cohort) gvar(first_cohort) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-5 7) estore(csdid_understIndR)

coefplot ///
(csdid_understIndU, label(Urban) msymbol(O) mcolor(blue) ciopt(lc(blue) recast(blue)) lc(blue)) ///
(csdid_understIndR, offset(-0.1) label(Rural) msymbol(T) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap)) lc(ltblue)), ///
vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of understanding an indigenous language", size(medium) height(5)) ///
ylabel(-0.1(0.05)0.1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
legend(pos(5) ring(0) col(1)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.1 0.1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_understIndGC.png", replace


*========================================================================*
tostring state, replace format(%02.0f) force
gen tgroup=first_cohort
replace tgroup=. if state!="01" & state!="10" & state!="19" & state!="25" ///
& state!="26" & state!="28"
gen cgroup=tgroup==.

gen K = cohort-first_cohort

sum first_cohort
gen lastcohort = first_cohort==r(max) // dummy for the latest- or never-treated cohort
forvalues l = 0/7 {
	gen L`l'event = K==`l'
}
forvalues l = 1/6 {
	gen F`l'event = K==-`l'
}
replace F1event=0 // normalize K=-1 to zero
destring state, replace

eventstudyinteract hlengua L*event F*event if dmigrant==0 [aw=factor], ///
absorb(geo cohort) cohort(tgroup) control_cohort(cgroup) ///
covariates(edu female rural migrant) vce(cluster geo)

*========================================================================*
reghdfe hlengua F*event L*event edu female rural migrant [aw=factor] ///
if dmigrant==0, absorb(cohort geo) vce(cluster geo)

*========================================================================*
did_multiplegt hlengua geo cohort had_policy if dmigrant==0, weight(factor) ///
robust_dynamic dynamic(7) placebo(5) breps(50) cluster(geo) ///
controls(edu female migrant rural)

*========================================================================*
replace first_cohort=1997 if first_cohort==0

did_imputation hlengua geo cohort first_cohort if dmigrant==0 ///
[aw=factor], horizons(0/6) pretrend(6) ///
controls(edu female migrant rural) cluster(geo) fe(geo cohort) autos minn(0)