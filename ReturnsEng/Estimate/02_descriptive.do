*========================================================================*
* English skills and labor market outcomes in Mexico
*========================================================================*
* Author: Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/ReturnsEng/Data"
gl base2= "C:\Users\Oscar Galvez Soriano\Documents\Papers\ReturnsEng\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\ReturnsEng\Doc"
*========================================================================*
/* TABLE 1: Descriptive statistics */ 
*========================================================================*
use "$base/eng_abil.dta", clear
keep if biare==1 
drop if state=="05" | state=="17"
keep if cohort>=1984 & cohort<=1994

sum pact, d
return list
gen phy_act=pact>=r(p75)
replace phy_act=. if paidw!=1

sum communica, d
return list
gen c_abil=communica>=r(p75)
replace c_abil=. if paidw!=1

gen dsgral=sgral>=9
gen dssocial=ssocial>=9
gen dssdl=ssd_living>=9
gen dsachiev=sachiev>=9
gen dsfp=sfuture_perspect>=9
gen dsleissure=sleissure>=9
gen dseact=secon_activity>=9

label var hrs_work "Labor supply (hours)"
label var formal "Formal job"
label var phy_act "Physically demanding job"
label var c_abil "Job with comm. skills"
label var dssdl "Satisfied with SOL"
label var dsachiev "Satisfied with achievements"

eststo clear
eststo full_sample: quietly estpost sum income eng hrs_exp hrs_work formal ///
phy_act c_abil age edu female indigenous married rural ///
[aw=weight] if eng!=. & age>=18 & age<=65 & paidw==1
eststo eng: quietly estpost sum income eng hrs_exp hrs_work formal ///
phy_act c_abil age edu female indigenous married rural ///
[aw=weight] if eng==1 & age>=18 & age<=65 & paidw==1
eststo no_eng: quietly estpost sum income eng hrs_exp hrs_work formal ///
phy_act c_abil age edu female indigenous married rural ///
[aw=weight] if eng==0 & age>=18 & age<=65 & paidw==1
eststo diff: quietly estpost ttest income eng hrs_exp hrs_work formal ///
phy_act c_abil age edu female indigenous married rural ///
if eng!=. & age>=18 & age<=65 & paidw==1, by(eng) unequal
esttab full_sample eng no_eng diff using "$doc\tab1.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace
/* 
Note: 
Replace the "Diff." column from previous table with the coefficients from the
following regressions as the previous ones did not include the sample weights 
*/
eststo clear
foreach x in income eng hrs_exp hrs_work formal ///
phy_act c_abil age edu female indigenous married rural {
eststo: quietly reg `x' eng [aw=weight] if age>=18 & age<=65 & paidw==1, ///
vce(robust)
}
esttab using "$doc\tab1_diff.tex", ar2 cells(b(star fmt(%9.2fc)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Descriptive statistics) keep(eng) replace

*========================================================================*
/* Appendix*/ 
*========================================================================*

*========================================================================*
/* FIGURE A.1. Exposure to English instruction and English abilities in 
Mexican states */
*========================================================================*
use "$base/eng_abil.dta", clear

destring state, replace
gen eng_r=eng if rural==1
gen eng_u=eng if rural==0
gen hrs_exp_r=hrs_exp if rural==1
gen hrs_exp_u=hrs_exp if rural==0
replace hrs_exp_u=hrs_exp_u/2 if state==17
replace hrs_exp_r=hrs_exp_r/2 if state==17
keep if age>=18 & age<=65
keep if biare==1 // I restrict the sample to only those who were survey in BIARE
collapse (mean) eng* hrs_exp* [fw=weight], by(state)

merge m:m state using "$data/data/main/Maps/MexStates/mex_map_state.dta"
drop if _merge!=3
drop _merge
replace eng_u=.2 if state==23

format eng* hrs_exp_u* %12.2f
/* Panel (a). Exposure in urban states */
spmap hrs_exp_u using "$base2\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 0.2) legend(size(*3))
graph export "$doc\fig1_A.png", replace
/* Panel (b). Exposure in rural states */
spmap hrs_exp_r using "$base2\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 0.2) legend(off) 
graph export "$doc\fig1_B.png", replace
/* Panel (c). English abilities (urban) */
spmap eng_u using "$base2\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 0.2) legend(size(*3))
graph export "$doc\fig1_C.png", replace
/* Panel (d). English abilities (rural) */
spmap eng_r using "$base2\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 0.2) legend(off)
graph export "$doc\fig1_D.png", replace
*========================================================================*
/* FIGURE A.2: English abilities, wages and education by occupations */
*========================================================================*
use "$base/eng_abil.dta", clear
keep if biare==1 
destring sinco, replace
gen occup=.
replace occup=1 if (sinco>6101 & sinco<=6131) | (sinco>6201 & sinco<=6231) ///
| sinco==6999
replace occup=2 if (sinco>=9111 & sinco<=9899) 
replace occup=3 if sinco==6311 | (sinco>=8111 & sinco<=8199) | (sinco>=8211 ///
& sinco<=8212) | (sinco>=8311 & sinco<=8999)
replace occup=4 if (sinco>=7111 & sinco<=7135) | (sinco>=7211 & sinco<=7223) ///
| (sinco>=7311 & sinco<=7353) | (sinco>=7411 & sinco<=7412) | (sinco>=7511 & ///
sinco<=7517) | (sinco>=7611 & sinco<=7999)
replace occup=5 if (sinco>=5111 & sinco<=5116) | (sinco>=5211 & sinco<=5254) ///
| (sinco>=5311 & sinco<=5314) | (sinco>=5411 & sinco<=5999)
replace occup=6 if sinco==4111 | (sinco>=4211 & sinco<=4999)
replace occup=7 if (sinco>=3111 & sinco<=3142) | (sinco>=3211 & sinco<=3999)
replace occup=8 if (sinco>=2111 & sinco<=2625) | (sinco>=2631 & sinco<=2639) ///
| (sinco>=2641 & sinco<=2992)
replace occup=9 if (sinco>=1111 & sinco<=1999) | sinco==2630 ///
| sinco==2630 | sinco==2640 | sinco==3101 | sinco==3201 | sinco==4201 ///
| sinco==5101 | sinco==5201 | sinco==5301 | sinco==5401 | sinco==6101 ///
| sinco==6201 | sinco==7101 | sinco==7201 | sinco==7301 | sinco==7401 ///
| sinco==7501 | sinco==7601 | sinco==8101 | sinco==8201 | sinco==8301
replace occup=10 if sinco==980

label define occup 1 "Farming" 2 "Elem occupations" 3 "Machine operators" ///
4 "Crafts" 5 "Customer service" 6 "Sales" 7 "Clerical support" ///
8 "Pro/Tech" 9 "Managerial" 10 "Abroad" 
label values occup occup
/* Panel (a). Proportion of female and English speakers */
graph hbar (mean) eng female [fw=weight] if age>=18 & age<=65, ///
yline(0.0699, lstyle(grid) lpattern(dash) lcolor(red)) ///
over(occup, gap(*0.5)) graphregion(color(white)) scheme(s2mono) ///
ylabel(, grid format(%5.2f)) legend( label(1 "Speak English") label(2 "Female"))
graph export "$doc\occup_EngFem.png", replace
/* Pane (b). Wages and education */
graph hbar (mean) lwage edu [fw=weight] if age>=18 & age<=65, ///
over(occup, gap(*0.5)) graphregion(color(white)) scheme(s2mono) ///
ylabel(, grid format(%5.0f)) legend( label(1 "ln(wage)") label(2 "Education"))
graph export "$doc\occup_WageEdu.png", replace
*========================================================================*
/* FIGURE A.3: Mexican states with English programs */
*========================================================================*
use "$base/sum_Eng_state_1.dta", clear
append using "$base/sum_Eng_state_2.dta"

destring state, replace
label define state 1 AGS 2 BC 3 BCS 4 CAMP 5 COAH 6 COL 7 CHIA 8 CHIH 9 MXC 10 ///
DGO 11 GTO 12 GRO 13 HGO 14 JAL 15 MEX 16 MICH 17 MOR 18 NAY 19 NL 20 OAX ///
21 PUE 22 QUER 23 QRO 24 SLP 25 SIN 26 SON 27 TAB 28 TAM 29 TLAX 30 VER ///
31 YUC 32 ZAC
label values state state

/* Panel (a). Aguascalientes */
bysort year: egen hours_yearAGS=mean(hours_eng) if public==1 & state==01
replace hours_yearAGS=hours_yearAGS+5.5 if year==2009
label var hours_year "Hours of English instruction"

bysort year: egen hours_year_ruralAGS=mean(hours_eng) if rural==1 & public==1 & state==01
label var hours_year_rural "Hours of English instruction"

bysort year: egen hours_year_urbanAGS=mean(hours_eng) if rural==0 & public==1 & state==01
replace hours_year_urbanAGS=hours_year_urbanAGS+10 if year==2009
label var hours_year_urban "Hours of English instruction"
set scheme s1color
twoway line hours_yearAGS year, msymbol(diamond) xlabel(1997(1)2013, angle(vertical)) ///
ytitle(Weekly hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2001, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_ruralAGS year || line hours_year_urbanAGS year, ///
legend(label(1 "Aguascalientes") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graphAGS.png", replace

/* Panel (b). Durango */
bysort year: egen hours_yearDGO=mean(hours_eng) if public==1 & state==10
label var hours_yearDGO "Hours of English instruction"

bysort year: egen hours_year_ruralDGO=mean(hours_eng) if rural==1 & public==1 & state==10
label var hours_year_ruralDGO "Hours of English instruction"

bysort year: egen hours_year_urbanDGO=mean(hours_eng) if rural==0 & public==1 & state==10
label var hours_year_urbanDGO "Hours of English instruction"
set scheme s1color
twoway line hours_yearDGO year, msymbol(diamond) xlabel(1997(1)2013, angle(vertical)) ///
ytitle(Weekly hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2002, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_ruralDGO year || line hours_year_urbanDGO year, ///
legend(label(1 "Durango") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graphDGO.png", replace

/* Panel (c). Nuevo Leon */
bysort year: egen hours_yearNL=mean(hours_eng) if public==1 & state==19
label var hours_yearNL "Hours of English instruction"

bysort year: egen hours_year_ruralNL=mean(hours_eng) if rural==1 & public==1 & state==19
label var hours_year_ruralNL "Hours of English instruction"

bysort year: egen hours_year_urbanNL=mean(hours_eng) if rural==0 & public==1 & state==19
label var hours_year_urbanNL "Hours of English instruction"
set scheme s1color
twoway line hours_yearNL year, msymbol(diamond) xlabel(1997(1)2013, angle(vertical)) ///
ytitle(Weekly hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(1998, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_ruralNL year || line hours_year_urbanNL year, ///
legend(label(1 "Nuevo Leon") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graphNL.png", replace

/* Panel (d). Sinaloa */
bysort year: egen hours_yearSIN=mean(hours_eng) if public==1 & state==25
label var hours_yearSIN "Hours of English instruction"

bysort year: egen hours_year_ruralSIN=mean(hours_eng) if rural==1 & public==1 & state==25
label var hours_year_ruralSIN "Hours of English instruction"

bysort year: egen hours_year_urbanSIN=mean(hours_eng) if rural==0 & public==1 & state==25
label var hours_year_urbanSIN "Hours of English instruction"
set scheme s1color
twoway line hours_yearSIN year, msymbol(diamond) xlabel(1997(1)2013, angle(vertical)) ///
ytitle(Weekly hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2004, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_ruralSIN year || line hours_year_urbanSIN year, ///
legend(label(1 "Sinaloa") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graphSIN.png", replace

/* Panel (e). Sonora */
bysort year: egen hours_yearSON=mean(hours_eng) if public==1 & state==26
label var hours_yearSON "Hours of English instruction"

bysort year: egen hours_year_ruralSON=mean(hours_eng) if rural==1 & public==1 & state==26
label var hours_year_ruralSON "Hours of English instruction"

bysort year: egen hours_year_urbanSON=mean(hours_eng) if rural==0 & public==1 & state==26
label var hours_year_urbanSON "Hours of English instruction"
set scheme s1color
twoway line hours_yearSON year, msymbol(diamond) xlabel(1997(1)2013, angle(vertical)) ///
ytitle(Weekly hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2004, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_ruralSON year || line hours_year_urbanSON year, ///
legend(label(1 "Sonora") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graphSON.png", replace

/* Panel (f). Tamaulipas */
bysort year: egen hours_yearTAM=mean(hours_eng) if public==1 & state==28
label var hours_yearTAM "Hours of English instruction"

bysort year: egen hours_year_ruralTAM=mean(hours_eng) if rural==1 & public==1 & state==28
label var hours_year_ruralTAM "Hours of English instruction"

bysort year: egen hours_year_urbanTAM=mean(hours_eng) if rural==0 & public==1 & state==28
label var hours_year_urbanTAM "Hours of English instruction"
set scheme s1color
twoway line hours_yearTAM year, msymbol(diamond) xlabel(1997(1)2013, angle(vertical)) ///
ytitle(Weekly hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2001, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_ruralTAM year || line hours_year_urbanTAM year, ///
legend(label(1 "Tamaulipas") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graphTAM.png", replace
*========================================================================*
/* FIGURE A.4. Event-study graphs from TWFE specification */
*========================================================================*
use "$base/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
keep if cohort>=1984 & cohort<=1994

sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)

gen lhwork=log(hrs_work)
destring geo, replace

gen first_cohort=0
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

bysort geo cohort: gen treat2 = cohort == (first_cohort - 8)
bysort geo cohort: gen treat3 = cohort == (first_cohort - 7)
bysort geo cohort: gen treat4 = cohort == (first_cohort - 6)
bysort geo cohort: gen treat5 = cohort == (first_cohort - 5)
bysort geo cohort: gen treat6 = cohort == (first_cohort - 4)
bysort geo cohort: gen treat7 = cohort == (first_cohort - 3)
bysort geo cohort: gen treat8 = cohort == (first_cohort - 2)
bysort geo cohort: gen treat9 = cohort == (first_cohort - 1)
bysort geo cohort: gen treat10 = cohort == first_cohort
bysort geo cohort: gen treat11 = cohort == (first_cohort + 1)
bysort geo cohort: gen treat12 = cohort == (first_cohort + 2)
bysort geo cohort: gen treat13 = cohort == (first_cohort + 3)
bysort geo cohort: gen treat14 = cohort == (first_cohort + 4)
bysort geo cohort: gen treat15 = cohort == (first_cohort + 5)
bysort geo cohort: gen treat16 = cohort == (first_cohort + 6)
bysort geo cohort: gen treat17 = cohort == (first_cohort + 7)
bysort geo cohort: gen treat18 = cohort == (first_cohort + 8)

replace treat9=0

label var treat2 "-8"
label var treat3 "-7"
label var treat4 "-6"
label var treat5 "-5"
label var treat6 "-4"
label var treat7 "-3"
label var treat8 "-2"
label var treat9 "-1"
foreach x in 0 1 2 3 4 5 6 7 8 {
	label var treat1`x' "`x'"
}

drop treat2 treat3 treat17 treat18
destring state, replace

reghdfe hrs_exp treat* if paidw==1 ///
[aw=weight], absorb(cohort geo) vce(cluster geo)
estimates store hexp_ss
reghdfe hrs_exp treat* edu female if paidw==1 ///
[aw=weight], absorb(cohort geo state#cohort) vce(cluster geo)
estimates store hexp_ssc

coefplot ///
(hexp_ss, label(Sample without controls) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap)) lc(ltblue)) ///
(hexp_ssc, offset(-0.1) label(Sample with controls) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(pos(5) ring(0) col(1) region(lcolor(white)) size(medium)) ///
ysc(r(-1 1)) recast(connected)
graph export "$doc\PTA_StagDD1.png", replace

reghdfe eng treat* if paidw==1 ///
[aw=weight], absorb(cohort geo) vce(cluster geo)
estimates store eng_ss
reghdfe eng treat* edu female if paidw==1 ///
[aw=weight], absorb(cohort geo state#cohort) vce(cluster geo)
estimates store eng_ssc

coefplot ///
(eng_ss, label(Sample without controls) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap)) lc(ltblue)) ///
(eng_ssc, offset(-0.1) label(Sample with controls) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of speaking English", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(off) ///
ysc(r(-1 1)) recast(connected)
graph export "$doc\PTA_StagDD2.png", replace

reghdfe paidw treat* ///
[aw=weight], absorb(cohort geo) vce(cluster geo)
estimates store paid_ss
reghdfe paidw treat* edu female ///
[aw=weight], absorb(cohort geo state#cohort) vce(cluster geo)
estimates store paid_ssc

coefplot ///
(paid_ss, label(Sample without controls) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap)) lc(ltblue)) ///
(paid_ssc, offset(-0.1) label(Sample with controls) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of working for pay", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(off) ///
ysc(r(-1 1)) recast(connected)
graph export "$doc\PTA_StagDD3.png", replace

reghdfe lwage treat* if paidw==1 ///
[aw=weight], absorb(cohort geo) vce(cluster geo)
estimates store wage_ss
reghdfe lwage treat* edu female if paidw==1 ///
[aw=weight], absorb(cohort geo state#cohort) vce(cluster geo)
estimates store wage_ssc

coefplot ///
(wage_ss, label(Sample without controls) msymbol(O) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap)) lc(ltblue)) ///
(wage_ssc, offset(-0.1) label(Sample with controls) msymbol(T) mcolor(blue) ciopt(lc(blue) recast(rcap)) lc(blue)), ///
vertical keep(treat*) yline(0) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of wages", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend(off) ///
ysc(r(-10 10)) recast(connected)
graph export "$doc\PTA_StagDD4.png", replace
*========================================================================*
/* Heterogeneous effects */
*========================================================================*
/* Borusyak, Jaravel, and Spiess (2024) */
*========================================================================*
clear
clear matrix
clear mata
set maxvar 120000
use "$base/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
keep if cohort>=1984 & cohort<=1994
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

gen first_cohort=1997
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

destring geo state, replace
*========================================================================*
/* FIGURE A.5. Effect of English programs on labor market outcomes */
*========================================================================*
/* Gender heterogeneous effects */
*========================================================================*
did_imputation hrs_exp geo cohort first_cohort if paidw==1 & female==0  [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort) cluster(geo) autos minn(0)
estimates store bjs_hrs_m
did_imputation eng geo cohort first_cohort if paidw==1 & female==0  [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort) cluster(geo) autos minn(0)
estimates store bjs_Eng_m
did_imputation lwage geo cohort first_cohort if paidw==1 & female==0  [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort) cluster(geo) autos minn(0)
estimates store bjs_wage_m
did_imputation paidw geo cohort first_cohort [aw=weight] if female==0 , ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort) cluster(geo) autos minn(0)
estimates store bjs_paid_m

did_imputation hrs_exp geo cohort first_cohort if paidw==1 & female==1  [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort) cluster(geo) autos minn(0)
estimates store bjs_hrs_w
did_imputation eng geo cohort first_cohort if paidw==1 & female==1  [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort) cluster(geo) autos minn(0)
estimates store bjs_Eng_w
did_imputation lwage geo cohort first_cohort if paidw==1 & female==1  [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort) cluster(geo) autos minn(0)
estimates store bjs_wage_w
did_imputation paidw geo cohort first_cohort [aw=weight] if female==1 , ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort) cluster(geo) autos minn(0)
estimates store bjs_paid_w
*========================================================================*
/* Panel (a) */
*========================================================================*
event_plot bjs_hrs_m bjs_hrs_w, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre#) ///
    stub_lag(tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Men" 4 "Women") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_hrsEngSex.png", replace
*========================================================================*
/* Panel (b) */
*========================================================================*
event_plot bjs_Eng_m bjs_Eng_w, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre#) ///
    stub_lag(tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_EngSex.png", replace
*========================================================================*
/* Panel (c) */
*========================================================================*
event_plot bjs_wage_m bjs_wage_w, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre#) ///
    stub_lag(tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_WageSex.png", replace
*========================================================================*
/* Panel (d) */
*========================================================================*
event_plot bjs_paid_m bjs_paid_w, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre#) ///
    stub_lag(tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_PaidSex.png", replace
*========================================================================*
/* FIGURE A.6. Effect of English programs on labor market outcomes */
*========================================================================*
/* Educational heterogeneous effects */
*========================================================================*
did_imputation hrs_exp geo cohort first_cohort if paidw==1 & edu<12  [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort) cluster(geo) autos minn(0)
estimates store bjs_hrs_l
did_imputation eng geo cohort first_cohort if paidw==1 & edu<12  [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort) cluster(geo) autos minn(0)
estimates store bjs_Eng_l
did_imputation lwage geo cohort first_cohort if paidw==1 & edu<12  [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort) cluster(geo) autos minn(0)
estimates store bjs_wage_l
did_imputation paidw geo cohort first_cohort [aw=weight] if edu<12 , ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort) cluster(geo) autos minn(0)
estimates store bjs_paid_l

did_imputation hrs_exp geo cohort first_cohort if paidw==1 & edu>=12 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort) cluster(geo) autos minn(0)
estimates store bjs_hrs_h
did_imputation eng geo cohort first_cohort if paidw==1 & edu>=12 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort) cluster(geo) autos minn(0)
estimates store bjs_Eng_h
did_imputation lwage geo cohort first_cohort if paidw==1 & edu>=12 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort) cluster(geo) autos minn(0)
estimates store bjs_wage_h
did_imputation paidw geo cohort first_cohort [aw=weight] if edu>=12, ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort) cluster(geo) autos minn(0)
estimates store bjs_paid_h
*========================================================================*
/* Panel (a) */
*========================================================================*
event_plot bjs_hrs_l bjs_hrs_h, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre#) ///
    stub_lag(tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "High educational attainment" 4 "Low educational attainment") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_hrsEngEdu.png", replace
*========================================================================*
/* Panel (b) */
*========================================================================*
event_plot bjs_Eng_l bjs_Eng_h, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre#) ///
    stub_lag(tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_EngEdu.png", replace
*========================================================================*
/* Panel (c) */
*========================================================================*
event_plot bjs_wage_l bjs_wage_h, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre#) ///
    stub_lag(tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_WageEdu.png", replace
*========================================================================*
/* Panel (d) */
*========================================================================*
event_plot bjs_paid_l bjs_paid_h, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre#) ///
    stub_lag(tau# tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick))
graph export "$doc\PTA_PaidEdu.png", replace
*========================================================================*
/* Robustness Checks */
*========================================================================*
/* FIGURE A.7. Event-study graphs from sensitivity analysis by leads 
and lags */
*========================================================================*
clear
clear matrix
clear mata
use "$base/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
keep if cohort>=1984 & cohort<=1994
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

gen first_cohort=1997
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1
destring geo state, replace
*========================================================================*
/* Full sample */
did_imputation hrs_exp geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_hrs
did_imputation eng geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_Eng
did_imputation lwage geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_wage
did_imputation paidw geo cohort first_cohort [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_paid
/* Excluding one lead and one lag */
did_imputation hrs_exp geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/5) pretrend(5) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_hrs1
did_imputation eng geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/5) pretrend(5) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_Eng1
did_imputation lwage geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/5) pretrend(5) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_wage1
did_imputation paidw geo cohort first_cohort [aw=weight], ///
horizons(0/5) pretrend(5) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_paid1
/* Excluding two leads and two lags */
did_imputation hrs_exp geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/4) pretrend(4) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_hrs2
did_imputation eng geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/4) pretrend(4) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_Eng2
did_imputation lwage geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/4) pretrend(4) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_wage2
did_imputation paidw geo cohort first_cohort [aw=weight], ///
horizons(0/4) pretrend(4) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_paid2
/* Excluding three leads and three lags */
did_imputation hrs_exp geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/3) pretrend(3) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_hrs3
did_imputation eng geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/3) pretrend(3) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_Eng3
did_imputation lwage geo cohort first_cohort if paidw==1 [aw=weight], ///
horizons(0/3) pretrend(3) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_wage3
did_imputation paidw geo cohort first_cohort [aw=weight], ///
horizons(0/3) pretrend(3) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_paid3
*========================================================================*
/* Panel (a) */
*========================================================================*
event_plot bjs_hrs bjs_hrs1 bjs_hrs2 bjs_hrs3, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre# pre#) ///
    stub_lag(tau# tau# tau# tau#) ///
    together noautolegend perturb(-.12 -0.04 0.04 0.12) ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Full sample" 4 "Excluding one lead and one lag" 6 "Excluding two leads and two lags" 8 "Excluding three leads and three lags") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt4(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_hrsEngSensitivity.png", replace
*========================================================================*
/* Panel (b) */
*========================================================================*
event_plot bjs_Eng bjs_Eng1 bjs_Eng2 bjs_Eng3, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre# pre#) ///
    stub_lag(tau# tau# tau# tau#) ///
    together noautolegend perturb(-.12 -0.04 0.04 0.12) ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt4(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_EngSensitivity.png", replace
*========================================================================*
/* Panel (c) */
*========================================================================*
event_plot bjs_wage bjs_wage1 bjs_wage2 bjs_wage3, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre# pre#) ///
    stub_lag(tau# tau# tau# tau#) ///
    together noautolegend perturb(-.12 -0.04 0.04 0.12) ///
	graph_opt( ///
	ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt4(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_WageSensitivity.png", replace
*========================================================================*
/* Panel (d) */
*========================================================================*
event_plot bjs_paid bjs_paid1 bjs_paid2 bjs_paid3, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre# pre#) ///
    stub_lag(tau# tau# tau# tau#) ///
    together noautolegend perturb(-.12 -0.04 0.04 0.12) ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt4(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_PaidSensitivity.png", replace

*========================================================================*
/* FIGURE XXX. Narrow cohorts */
*========================================================================*
did_imputation hrs_exp geo cohort first_cohort if paidw==1 ///
& cohort>=1985 & cohort<=1993 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_hrsC1
did_imputation eng geo cohort first_cohort if paidw==1 ///
& cohort>=1985 & cohort<=1993 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_EngC1
did_imputation lwage geo cohort first_cohort if paidw==1 ///
& cohort>=1985 & cohort<=1993 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_wageC1
did_imputation paidw geo cohort first_cohort ///
if cohort>=1985 & cohort<=1993 [aw=weight], ///
horizons(0/6) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_paidC1

did_imputation hrs_exp geo cohort first_cohort if paidw==1 ///
& cohort>=1986 & cohort<=1992 [aw=weight], ///
horizons(0/5) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_hrsC2
did_imputation eng geo cohort first_cohort if paidw==1 ///
& cohort>=1986 & cohort<=1992 [aw=weight], ///
horizons(0/5) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_EngC2
did_imputation lwage geo cohort first_cohort if paidw==1 ///
& cohort>=1986 & cohort<=1992 [aw=weight], ///
horizons(0/5) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_wageC2
did_imputation paidw geo cohort first_cohort ///
if cohort>=1986 & cohort<=1992 [aw=weight], ///
horizons(0/5) pretrend(6) ///
controls(female edu) fe(geo cohort state#cohort) cluster(geo) autos minn(0)
estimates store bjs_paidC2

*========================================================================*
/* Panel (a) */
*========================================================================*
event_plot bjs_hrs bjs_hrsC1 bjs_hrsC2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre#) ///
    stub_lag(tau# tau# tau#) ///
    together noautolegend perturb(-.08 0 0.08) ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Full sample" 4 "Excluding one old and young cohorts" 6 "Excluding two old and young cohorts") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick))
graph export "$doc\PTA_hrsEngCohorts.png", replace
*========================================================================*
/* Panel (b) */
*========================================================================*
event_plot bjs_Eng bjs_EngC1 bjs_EngC2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre#) ///
    stub_lag(tau# tau# tau#) ///
    together noautolegend perturb(-.08 0 0.08) ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick))
graph export "$doc\PTA_EngCohorts.png", replace
*========================================================================*
/* Panel (c) */
*========================================================================*
event_plot bjs_wage bjs_wageC1 bjs_wageC2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre#) ///
    stub_lag(tau# tau# tau#) ///
    together noautolegend perturb(-.08 0 0.08) ///
	graph_opt( ///
	ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick))
graph export "$doc\PTA_WageCohorts.png", replace
*========================================================================*
/* Panel (d) */
*========================================================================*
event_plot bjs_paid bjs_paidC1 bjs_paidC2, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre# pre# pre#) ///
    stub_lag(tau# tau# tau#) ///
    together noautolegend perturb(-.08 0 0.08) ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(T) mfcolor(midblue) mlcolor(midblue) mlwidth(thin)) lag_ci_opt2(color(midblue) lwidth(medthick)) ///
    lag_opt3(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(blue) lwidth(medthick)) ///
    lag_opt4(msize(small) msymbol(D) mfcolor(ltblue) mlcolor(ltblue) mlwidth(thin)) lag_ci_opt4(color(ltblue) lwidth(medthick))
graph export "$doc\PTA_PaidCohorts.png", replace

*========================================================================*
/* TABLE XXX. Sensitivity changing the treatment and comparison groups */
*========================================================================*
clear
clear matrix
clear mata
set maxvar 120000
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

gen sstates=state=="31" | state=="23" | state=="04" | state=="07" | ///
state=="27" | state=="20" | state=="30" | state=="12" | state=="21" | ///
state=="17" | state=="29" | state=="16" | state=="15" | state=="09" | ///
state=="13" | state=="06" | state=="22"

destring geo, replace

*========================================================================*
/* Changes in comparison group */
*========================================================================*
/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b1 = e(estimates) \ 0
matrix hrsEng_v1 = e(variances) \ 0

mat rownames hrsEng_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt hrs_exp geo cohort had_policy if paidw==1 & sstates==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b3 = e(estimates) \ 0
matrix hrsEng_v3 = e(variances) \ 0

mat rownames hrsEng_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b1 = e(estimates) \ 0
matrix Eng_v1 = e(variances) \ 0

mat rownames Eng_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt eng geo cohort had_policy if paidw==1 & sstates==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b3 = e(estimates) \ 0
matrix Eng_v3 = e(variances) \ 0

mat rownames Eng_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b1 = e(estimates) \ 0
matrix wage_v1 = e(variances) \ 0

mat rownames wage_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt lwage geo cohort had_policy if paidw==1 & sstates==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b3 = e(estimates) \ 0
matrix wage_v3 = e(variances) \ 0

mat rownames wage_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b1 = e(estimates) \ 0
matrix paidw_v1 = e(variances) \ 0

mat rownames paidw_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt paidw geo cohort had_policy if sstates==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b3 = e(estimates) \ 0
matrix paidw_v3 = e(variances) \ 0

mat rownames paidw_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hrs worked */
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b1 = e(estimates) \ 0
matrix lhwork_v1 = e(variances) \ 0

mat rownames lhwork_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt lhwork geo cohort had_policy if paidw==1 & sstates==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b3 = e(estimates) \ 0
matrix lhwork_v3 = e(variances) \ 0

mat rownames lhwork_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b1 = e(estimates) \ 0
matrix formal_v1 = e(variances) \ 0

mat rownames formal_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

did_multiplegt formal geo cohort had_policy if paidw==1 & sstates==0, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b3 = e(estimates) \ 0
matrix formal_v3 = e(variances) \ 0

mat rownames formal_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

*========================================================================*
/* With Morelos and Coahuila */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
*drop if state=="05" | state=="17"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

destring geo, replace

/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b2 = e(estimates) \ 0
matrix hrsEng_v2 = e(variances) \ 0

mat rownames hrsEng_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b2 = e(estimates) \ 0
matrix Eng_v2 = e(variances) \ 0

mat rownames Eng_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b2 = e(estimates) \ 0
matrix wage_v2 = e(variances) \ 0

mat rownames wage_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b2 = e(estimates) \ 0
matrix paidw_v2 = e(variances) \ 0

mat rownames paidw_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hrs worked */
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b2 = e(estimates) \ 0
matrix lhwork_v2 = e(variances) \ 0

mat rownames lhwork_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b2 = e(estimates) \ 0
matrix formal_v2 = e(variances) \ 0

mat rownames formal_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hours of English instruction */
event_plot hrsEng_b1#hrsEng_v1 hrsEng_b2#hrsEng_v2 hrsEng_b3#hrsEng_v3, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Original sample" 4 "Including Morelos and Coahila" 6 "Excluding southern states") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick))
graph export "$doc\PTA_hrsEngStates.png", replace

/* English speaking ability */
event_plot Eng_b1#Eng_v1 Eng_b2#Eng_v2 Eng_b3#Eng_v3, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick))
graph export "$doc\PTA_EngStates.png", replace

/* Log of wages */
event_plot wage_b1#wage_v1 wage_b2#wage_v2 wage_b3#wage_v3, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_WageStates.png", replace

/* Likelihood of working for pay */
event_plot paidw_b1#paidw_v1 paidw_b2#paidw_v2 paidw_b3#paidw_v3, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick))
graph export "$doc\PTA_PaidStates.png", replace

/* Hrs worked */
event_plot lhwork_b1#lhwork_v1 lhwork_b2#lhwork_v2 lhwork_b3#lhwork_v3, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of hours worked", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_lsStates.png", replace

/* Likelihood of working in formal sector */
event_plot formal_b1#formal_v1 formal_b2#formal_v2 formal_b3#formal_v3, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of hours worked", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) 
graph export "$doc\PTA_FormalStates.png", replace

*========================================================================*
/* TABLE XXX. Sensitivity changing the treatment and comparison groups */
*========================================================================*
clear
clear matrix
clear mata
set maxvar 120000
*========================================================================*
/* Changes in treatment group */
*========================================================================*
/* Aguascalientes */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17" | state=="01"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

gen had_policy=0 
*replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

destring geo, replace

/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b1 = e(estimates) \ 0
matrix hrsEng_v1 = e(variances) \ 0

mat rownames hrsEng_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames hrsEng_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b1 = e(estimates) \ 0
matrix Eng_v1 = e(variances) \ 0

mat rownames Eng_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames Eng_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b1 = e(estimates) \ 0
matrix wage_v1 = e(variances) \ 0

mat rownames wage_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames wage_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b1 = e(estimates) \ 0
matrix paidw_v1 = e(variances) \ 0

mat rownames paidw_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames paidw_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

	/* Hrs worked */
	did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
	robust_dynamic dynamic(3) placebo(3) breps(100) cluster(geo) ///
	controls(female edu) 

matrix lhwork_b1 = e(estimates) \ 0
matrix lhwork_v1 = e(variances) \ 0

mat rownames lhwork_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames lhwork_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(4) placebo(3) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b1 = e(estimates) \ 0
matrix formal_v1 = e(variances) \ 0

mat rownames formal_b1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
mat rownames formal_v1 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Average Placebo_2 Placebo_3 Placebo_4 Placebo_1
*========================================================================*
/* Durango */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17" | state=="10"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
*replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

destring geo, replace

/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b2 = e(estimates) \ 0
matrix hrsEng_v2 = e(variances) \ 0

mat rownames hrsEng_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b2 = e(estimates) \ 0
matrix Eng_v2 = e(variances) \ 0

mat rownames Eng_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b2 = e(estimates) \ 0
matrix wage_v2 = e(variances) \ 0

mat rownames wage_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b2 = e(estimates) \ 0
matrix paidw_v2 = e(variances) \ 0

mat rownames paidw_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hrs worked */
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b2 = e(estimates) \ 0
matrix lhwork_v2 = e(variances) \ 0

mat rownames lhwork_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b2 = e(estimates) \ 0
matrix formal_v2 = e(variances) \ 0

mat rownames formal_b2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v2 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* Nuevo Leon */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17" | state=="19"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
*replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

destring geo, replace

/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b3 = e(estimates) \ 0
matrix hrsEng_v3 = e(variances) \ 0

mat rownames hrsEng_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b3 = e(estimates) \ 0
matrix Eng_v3 = e(variances) \ 0

mat rownames Eng_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b3 = e(estimates) \ 0
matrix wage_v3 = e(variances) \ 0

mat rownames wage_b3= Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b3 = e(estimates) \ 0
matrix paidw_v3 = e(variances) \ 0

mat rownames paidw_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hrs worked */
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b3 = e(estimates) \ 0
matrix lhwork_v3 = e(variances) \ 0

mat rownames lhwork_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b3 = e(estimates) \ 0
matrix formal_v3 = e(variances) \ 0

mat rownames formal_b3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v3 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* Sinaloa */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17" | state=="25"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
*replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

destring geo, replace

/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b4 = e(estimates) \ 0
matrix hrsEng_v4 = e(variances) \ 0

mat rownames hrsEng_b4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b4 = e(estimates) \ 0
matrix Eng_v4 = e(variances) \ 0

mat rownames Eng_b4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b4 = e(estimates) \ 0
matrix wage_v4 = e(variances) \ 0

mat rownames wage_b4= Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b4 = e(estimates) \ 0
matrix paidw_v4 = e(variances) \ 0

mat rownames paidw_b4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hrs worked */
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b4 = e(estimates) \ 0
matrix lhwork_v4 = e(variances) \ 0

mat rownames lhwork_b4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b4 = e(estimates) \ 0
matrix formal_v4 = e(variances) \ 0

mat rownames formal_b4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v4 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

*========================================================================*
/* Sonora */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17" | state=="26"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
*replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

destring geo, replace

/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b5 = e(estimates) \ 0
matrix hrsEng_v5 = e(variances) \ 0

mat rownames hrsEng_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b5 = e(estimates) \ 0
matrix Eng_v5 = e(variances) \ 0

mat rownames Eng_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b5 = e(estimates) \ 0
matrix wage_v5 = e(variances) \ 0

mat rownames wage_b5= Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b5 = e(estimates) \ 0
matrix paidw_v5 = e(variances) \ 0

mat rownames paidw_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hrs worked */
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b5 = e(estimates) \ 0
matrix lhwork_v5 = e(variances) \ 0

mat rownames lhwork_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b5 = e(estimates) \ 0
matrix formal_v5 = e(variances) \ 0

mat rownames formal_b5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v5 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
*========================================================================*
/* Tamaulipas */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17" | state=="28"
keep if cohort>=1984 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
*replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

destring geo, replace

/* Hours of English instruction */
did_multiplegt hrs_exp geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix hrsEng_b6 = e(estimates) \ 0
matrix hrsEng_v6 = e(variances) \ 0

mat rownames hrsEng_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames hrsEng_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* English speaking ability */
did_multiplegt eng geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix Eng_b6 = e(estimates) \ 0
matrix Eng_v6 = e(variances) \ 0

mat rownames Eng_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames Eng_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Log of wages */
did_multiplegt lwage geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix wage_b6 = e(estimates) \ 0
matrix wage_v6 = e(variances) \ 0

mat rownames wage_b6= Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames wage_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working for pay */
did_multiplegt paidw geo cohort had_policy, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix paidw_b6 = e(estimates) \ 0
matrix paidw_v6 = e(variances) \ 0

mat rownames paidw_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames paidw_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Hrs worked */
did_multiplegt lhwork geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix lhwork_b6 = e(estimates) \ 0
matrix lhwork_v6 = e(variances) \ 0

mat rownames lhwork_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames lhwork_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

/* Likelihood of working in formal sector */
did_multiplegt formal geo cohort had_policy if paidw==1, weight(weight) ///
robust_dynamic dynamic(6) placebo(5) breps(100) cluster(geo) ///
controls(female edu) 

matrix formal_b6 = e(estimates) \ 0
matrix formal_v6 = e(variances) \ 0

mat rownames formal_b6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1
mat rownames formal_v6 = Effect_0 Effect_1 Effect_2 Effect_3 Effect_4 Effect_5 Effect_6 Average Placebo_2 Placebo_3 Placebo_4 Placebo_5 Placebo_6 Placebo_1

*========================================================================*
/* FIGURE XX:  */
*========================================================================*
/* Hours of English instruction */
event_plot hrsEng_b1#hrsEng_v1 hrsEng_b2#hrsEng_v2 hrsEng_b3#hrsEng_v3 hrsEng_b4#hrsEng_v4 hrsEng_b5#hrsEng_v5 hrsEng_b6#hrsEng_v6, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(order(2 "Excluding Aguascalientes" 4 "Excluding Durango" 6 "Excluding Nuevo Leon" 8 "Excluding Sinaloa" 10 "Excluding Sonora" 12 "Excluding Tamaulipas") pos(5) ring(0) col(1)) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(dkgreen) mlcolor(dkgreen) mlwidth(thin)) lag_ci_opt4(color(dkgreen) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(+) mfcolor(midgreen) mlcolor(midgreen) mlwidth(thin)) lag_ci_opt5(color(midgreen) lwidth(medthick)) ///
	lag_opt6(msize(small) msymbol(X) mfcolor(green) mlcolor(green) mlwidth(thin)) lag_ci_opt6(color(green) lwidth(medthick))
graph export "$doc\PTA_hrsEngTStates.png", replace

/* English speaking ability */
event_plot Eng_b1#Eng_v1 Eng_b2#Eng_v2 Eng_b3#Eng_v3 Eng_b4#Eng_v4 Eng_b5#Eng_v5 Eng_b6#Eng_v6, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of speaking English", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(dkgreen) mlcolor(dkgreen) mlwidth(thin)) lag_ci_opt4(color(dkgreen) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(+) mfcolor(midgreen) mlcolor(midgreen) mlwidth(thin)) lag_ci_opt5(color(midgreen) lwidth(medthick)) ///
	lag_opt6(msize(small) msymbol(X) mfcolor(green) mlcolor(green) mlwidth(thin)) lag_ci_opt6(color(green) lwidth(medthick))
graph export "$doc\PTA_EngTStates.png", replace

/* Log of wages */
event_plot wage_b1#wage_v1 wage_b2#wage_v2 wage_b3#wage_v3 wage_b4#wage_v4 wage_b5#wage_v5 wage_b6#wage_v6, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of wages", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(dkgreen) mlcolor(dkgreen) mlwidth(thin)) lag_ci_opt4(color(dkgreen) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(+) mfcolor(midgreen) mlcolor(midgreen) mlwidth(thin)) lag_ci_opt5(color(midgreen) lwidth(medthick)) ///
	lag_opt6(msize(small) msymbol(X) mfcolor(green) mlcolor(green) mlwidth(thin)) lag_ci_opt6(color(green) lwidth(medthick))
graph export "$doc\PTA_WageTStates.png", replace

/* Likelihood of working for pay */
event_plot paidw_b1#paidw_v1 paidw_b2#paidw_v2 paidw_b3#paidw_v3 paidw_b4#paidw_v4 paidw_b5#paidw_v5 paidw_b6#paidw_v6, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Likelihood of working for pay", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(dkgreen) mlcolor(dkgreen) mlwidth(thin)) lag_ci_opt4(color(dkgreen) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(+) mfcolor(midgreen) mlcolor(midgreen) mlwidth(thin)) lag_ci_opt5(color(midgreen) lwidth(medthick)) ///
	lag_opt6(msize(small) msymbol(X) mfcolor(green) mlcolor(green) mlwidth(thin)) lag_ci_opt6(color(green) lwidth(medthick))
graph export "$doc\PTA_PaidTStates.png", replace

/* Hrs worked */
event_plot lhwork_b1#lhwork_v1 lhwork_b2#lhwork_v2 lhwork_b3#lhwork_v3 lhwork_b4#lhwork_v4 lhwork_b5#lhwork_v5 lhwork_b6#lhwork_v6, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of hours worked", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(dkgreen) mlcolor(dkgreen) mlwidth(thin)) lag_ci_opt4(color(dkgreen) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(+) mfcolor(midgreen) mlcolor(midgreen) mlwidth(thin)) lag_ci_opt5(color(midgreen) lwidth(medthick)) ///
	lag_opt6(msize(small) msymbol(X) mfcolor(green) mlcolor(green) mlwidth(thin)) lag_ci_opt6(color(green) lwidth(medthick))
graph export "$doc\PTA_lsTStates.png", replace

/* Likelihood of working in formal sector */
event_plot formal_b1#formal_v1 formal_b2#formal_v2 formal_b3#formal_v3 formal_b4#formal_v4 formal_b5#formal_v5 formal_b6#formal_v6, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(Placebo_# Placebo_# Placebo_# Placebo_#) ///
    stub_lag(Effect_# Effect_# Effect_# Effect_#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-2(1)2, labs(medium) grid format(%5.0f)) ///
	ytitle("Percentage change of hours worked", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) ///
    lag_opt2(msize(small) msymbol(S) mfcolor(blue) mlcolor(blue) mlwidth(thin)) lag_ci_opt2(color(blue) lwidth(medthick)) ///
	lag_opt3(msize(small) msymbol(T) mfcolor(midblue) mlcolor(blue) mlwidth(thin)) lag_ci_opt3(color(midblue) lwidth(medthick)) ///
	lag_opt4(msize(small) msymbol(D) mfcolor(dkgreen) mlcolor(dkgreen) mlwidth(thin)) lag_ci_opt4(color(dkgreen) lwidth(medthick)) ///
	lag_opt5(msize(small) msymbol(+) mfcolor(midgreen) mlcolor(midgreen) mlwidth(thin)) lag_ci_opt5(color(midgreen) lwidth(medthick)) ///
	lag_opt6(msize(small) msymbol(X) mfcolor(green) mlcolor(green) mlwidth(thin)) lag_ci_opt6(color(green) lwidth(medthick))
graph export "$doc\PTA_FormalTStates.png", replace
*========================================================================*
/* TABLE A.1. Adult English speaking ability in Mexico */
*========================================================================*
use "$base/eng_abil.dta", clear
gen eng_states=1 if state=="01" | state=="10" | state=="19" | state=="25" ///
| state=="26" | state=="28"
replace eng_state=0 if eng_state==.
replace eng=eng*100
keep if biare==1 // I restrict the sample to only those who were survey in BIARE

/* All individuals ages 18-65 */
eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65
eststo diff: quietly estpost ttest eng if age>=18 & age<=65, by(eng_state) unequal
esttab full_sample eng no_eng diff using "$doc\tab1_A.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace
/* Male */
eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & female==0
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & female==0
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & female==0
eststo diff: quietly estpost ttest eng if age>=18 & age<=65 & female==0, by(eng_state) unequal
esttab full_sample eng no_eng diff using "$doc\tab1_B.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace
/* Female */
eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & female==1
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & female==1
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & female==1
eststo diff: quietly estpost ttest eng if age>=18 & age<=65 & female==1, by(eng_state) unequal
esttab full_sample eng no_eng diff using "$doc\tab1_C.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace
/* Ages 18-35 */
eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=35
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=35
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=35
eststo diff: quietly estpost ttest eng if age>=18 & age<=35, by(eng_state) unequal
esttab full_sample eng no_eng diff using "$doc\tab1_D.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace
/* Ages 36-50 */
eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=36 & age<=50
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=36 & age<=50
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=36 & age<=50
eststo diff: quietly estpost ttest eng if age>=36 & age<=50, by(eng_state) unequal
esttab full_sample eng no_eng diff using "$doc\tab1_E.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace
/* Ages 51-65 */
eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=51 & age<=65
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=51 & age<=65
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=51 & age<=65
eststo diff: quietly estpost ttest eng if age>=51 & age<=65, by(eng_state) unequal
esttab full_sample eng no_eng diff using "$doc\tab1_F.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace
/* Incomplete primary (0-5 years) */
eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & edu>=0 & edu<=5
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & edu>=0 & edu<=5
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & edu>=0 & edu<=5
eststo diff: quietly estpost ttest eng if age>=18 & age<=65 & edu>=0 & edu<=5, by(eng_state) unequal
esttab full_sample eng no_eng diff using "$doc\tab1_G.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace
/* Primary school (6 years) */
eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & edu==6
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & edu==6
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & edu==6
eststo diff: quietly estpost ttest eng if age>=18 & age<=65 & edu>=0 & edu==6, by(eng_state) unequal
esttab full_sample eng no_eng diff using "$doc\tab1_H.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace
/* Lower secondary (7-9 years) */
eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & edu>=7 & edu<=9
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & edu>=7 & edu<=9
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & edu>=7 & edu<=9
eststo diff: quietly estpost ttest eng if age>=18 & age<=65 & edu>=0 & edu>=7 & edu<=9, by(eng_state) unequal
esttab full_sample eng no_eng diff using "$doc\tab1_I.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace
/* Upper secondary (10-12 years) */
eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & edu>=10 & edu<=12
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & edu>=10 & edu<=12
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & edu>=10 & edu<=12
eststo diff: quietly estpost ttest eng if age>=18 & age<=65 & edu>=0 & edu>=10 & edu<=12, by(eng_state) unequal
esttab full_sample eng no_eng diff using "$doc\tab1_J.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace
/* College or higher (13-24 years) */
eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & edu>=13
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & edu>=13
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & edu>=13
eststo diff: quietly estpost ttest eng if age>=18 & age<=65 & edu>=0 & edu>=13, by(eng_state) unequal
esttab full_sample eng no_eng diff using "$doc\tab1_K.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace
/* Indigenous */
eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & indigenous==1
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & indigenous==1
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & indigenous==1
eststo diff: quietly estpost ttest eng if age>=18 & age<=65 & indigenous==1, by(eng_state) unequal
esttab full_sample eng no_eng diff using "$doc\tab1_L.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace
/* Non-indigenous */
eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & indigenous==0
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & indigenous==0
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & indigenous==0
eststo diff: quietly estpost ttest eng if age>=18 & age<=65 & indigenous==0, by(eng_state) unequal
esttab full_sample eng no_eng diff using "$doc\tab1_M.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace
/* Urban */
eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & rural==0
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & rural==0
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & rural==0
eststo diff: quietly estpost ttest eng if age>=18 & age<=65 & rural==0, by(eng_state) unequal
esttab full_sample eng no_eng diff using "$doc\tab1_N.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace
/* Rural */
eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & rural==1
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & rural==1
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & rural==1
eststo diff: quietly estpost ttest eng if age>=18 & age<=65 & rural==1, by(eng_state) unequal
esttab full_sample eng no_eng diff using "$doc\tab1_O.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace

/* Note: in this table you just need to manually replacethe last column, which 
currently contains a simple difference in means, with the difference that 
includes weights generated by the following regressions: */

/* Replace Diff. column with the following numbers */
reg eng eng_state [aw=weight] if age>=18 & age<=65, vce(robust)
reg eng eng_state [aw=weight] if age>=18 & age<=65 & female==0, vce(robust)
reg eng eng_state [aw=weight] if age>=18 & age<=65 & female==1, vce(robust)
reg eng eng_state [aw=weight] if age>=18 & age<=35, vce(robust)
reg eng eng_state [aw=weight] if age>=36 & age<=50, vce(robust)
reg eng eng_state [aw=weight] if age>=51 & age<=65, vce(robust)
reg eng eng_state [aw=weight] if age>=18 & age<=65 & edu>=0 & edu<=5, vce(robust)
reg eng eng_state [aw=weight] if age>=18 & age<=65 & edu==6, vce(robust)
reg eng eng_state [aw=weight] if age>=18 & age<=65 & edu>=7 & edu<=9, vce(robust)
reg eng eng_state [aw=weight] if age>=18 & age<=65 & edu>=10 & edu<=12, vce(robust)
reg eng eng_state [aw=weight] if age>=18 & age<=65 & edu>=13, vce(robust)
reg eng eng_state [aw=weight] if age>=18 & age<=65 & indigenous==1, vce(robust)
reg eng eng_state [aw=weight] if age>=18 & age<=65 & indigenous==0, vce(robust)
reg eng eng_state [aw=weight] if age>=18 & age<=65 & rural==0, vce(robust)
reg eng eng_state [aw=weight] if age>=18 & age<=65 & rural==1, vce(robust)
/* 
* Gender-English gap
reg eng female [aw=weight] if age>=18 & age<=65, vce(robust)
* Ethnicity-English gap
reg eng indigenous [aw=weight] if age>=18 & age<=65, vce(robust)
*/

*========================================================================*
/* TABLE A.2. Policy changes in Mexican states */
*========================================================================*
 /* I created this table manually with information about the state English
  programs and the means reported in school census */
  
*========================================================================*
/* TABLE A.3: Returns to English abilities in Mexico */
*========================================================================*
use "$data/eng_abil.dta", clear

destring state, replace
gen expe=age-edu-5
gen expe2=expe^2

eststo clear
eststo: areg lwage eng edu expe expe2 married female i.state if biare==1 ///
& lwage>0, absorb(sinco2011) vce(bootstrap)

drop if state==5 | state==17
keep if cohort>=1984 & cohort<=1994

eststo: areg lwage eng edu expe expe2 married female i.state if biare==1 ///
& lwage>0, absorb(sinco2011) vce(bootstrap)

esttab using "$doc\tabA3.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) ///
keep(eng edu expe expe2 married female) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace

*========================================================================*
/* Heterogeneous effects */
*========================================================================*
/* Borusyak, Jaravel, and Spiess (2024) */
*========================================================================*
clear
clear matrix
clear mata
set maxvar 120000
use "$base/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
keep if cohort>=1984 & cohort<=1994

sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)

gen lhwork=log(hrs_work)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1

gen first_cohort=1997
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

destring geo state, replace
*========================================================================*
/* TABLE A.4. Effect of English programs and heterogeneity by sex and 
education */
*========================================================================*
/* Panel A. Men */
*========================================================================*
eststo clear
eststo: did_imputation hrs_exp geo cohort first_cohort if paidw==1 & female==0 [aw=weight], ///
controls(edu) fe(geo cohort) cluster(geo) autos 
eststo: did_imputation eng geo cohort first_cohort if paidw==1 & female==0 [aw=weight], ///
controls(edu) fe(geo cohort) cluster(geo) autos 
eststo: did_imputation lwage geo cohort first_cohort if paidw==1 & female==0 [aw=weight], ///
controls(edu) fe(geo cohort) cluster(geo) autos 
eststo: did_imputation paidw geo cohort first_cohort [aw=weight] if female==0, ///
controls(edu) fe(geo cohort) cluster(geo) autos 
esttab using "$doc\tabA3_A.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Heterogeneous effects) keep(tau) ///
stats(N, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Panel B. Women */
*========================================================================*
eststo clear
eststo: did_imputation hrs_exp geo cohort first_cohort if paidw==1 & female==1 [aw=weight], ///
controls(edu) fe(geo cohort) cluster(geo) autos 
eststo: did_imputation eng geo cohort first_cohort if paidw==1 & female==1 [aw=weight], ///
controls(edu) fe(geo cohort) cluster(geo) autos 
eststo: did_imputation lwage geo cohort first_cohort if paidw==1 & female==1 [aw=weight], ///
controls(edu) fe(geo cohort) cluster(geo) autos 
eststo: did_imputation paidw geo cohort first_cohort [aw=weight] if female==1, ///
controls(edu) fe(geo cohort) cluster(geo) autos 
esttab using "$doc\tabA3_B.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Heterogeneous effects) keep(tau) ///
stats(N, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Panel C. Low educational attainment */
*========================================================================*
eststo clear
eststo: did_imputation hrs_exp geo cohort first_cohort if paidw==1 & edu<12 [aw=weight], ///
controls(edu) fe(geo cohort) cluster(geo) autos 
eststo: did_imputation eng geo cohort first_cohort if paidw==1 & edu<12 [aw=weight], ///
controls(edu) fe(geo cohort) cluster(geo) autos 
eststo: did_imputation lwage geo cohort first_cohort if paidw==1 & edu<12 [aw=weight], ///
controls(edu) fe(geo cohort) cluster(geo) autos 
eststo: did_imputation paidw geo cohort first_cohort [aw=weight] if edu<12, ///
controls(edu) fe(geo cohort) cluster(geo) autos 
esttab using "$doc\tabA3_C.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Heterogeneous effects) keep(tau) ///
stats(N, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Panel D. High educational attainment */
*========================================================================*
eststo clear
eststo: did_imputation hrs_exp geo cohort first_cohort if paidw==1 & edu>=12 [aw=weight], ///
controls(edu) fe(geo cohort) cluster(geo) autos 
eststo: did_imputation eng geo cohort first_cohort if paidw==1 & edu>=12 [aw=weight], ///
controls(edu) fe(geo cohort) cluster(geo) autos 
eststo: did_imputation lwage geo cohort first_cohort if paidw==1 & edu>=12 [aw=weight], ///
controls(edu) fe(geo cohort) cluster(geo) autos 
eststo: did_imputation paidw geo cohort first_cohort [aw=weight] if edu>=12, ///
controls(edu) fe(geo cohort) cluster(geo) autos 
esttab using "$doc\tabA3_D.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Heterogeneous effects) keep(tau) ///
stats(N, fmt(%9.0fc %9.3f)) replace