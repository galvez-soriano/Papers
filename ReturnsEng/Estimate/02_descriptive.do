*========================================================================*
* English skills and labor market outcomes in Mexico
*========================================================================*
* Author: Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/ReturnsEng/Data"
gl doc= "C:\Users\galve\Documents\Papers\Current\Returns to Eng Mex\Doc"
*========================================================================*
/* TABLE 1. Adult English speaking ability in Mexico */
*========================================================================*
use "$base/eng_abil.dta", clear
gen eng_states=1 if state=="01" | state=="10" | state=="19" | state=="25" ///
| state=="26" | state=="28" | state=="05" | state=="31"
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
/* FIGURE 1. Exposure to English instruction and English abilities in 
Mexican states */
*========================================================================*
use "$base/eng_abil.dta", clear

destring state, replace
gen eng_r=eng if rural==1
gen eng_u=eng if rural==0
gen hrs_exp_r=hrs_exp if rural==1
gen hrs_exp_u=hrs_exp if rural==0
keep if age>=18 & age<=65
keep if biare==1 // I restrict the sample to only those who were survey in BIARE
collapse (mean) eng* hrs_exp* [fw=weight], by(state)

merge m:m state using "$data/data/main/Maps/MexStates/mex_map_state.dta"
drop if _merge!=3
drop _merge

format eng* hrs_exp_r* %12.2f
/* Panel (a). Exposure in urban states */
spmap hrs_exp_u using "$base/mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 0.1) legend(off) 
graph export "$doc\fig1_A.png", replace
/* Panel (b). Exposure in rural states */
spmap hrs_exp_r using "$base/mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 0.1) legend(size(*3)) 
graph export "$doc\fig1_B.png", replace
/* Panel (c). English abilities (urban) */
spmap eng_u using "$base/mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 0.1) legend(off) 
graph export "$doc\fig1_C.png", replace
/* Panel (d). English abilities (rural) */
spmap eng_r using "$base/mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 0.1) legend(size(*3)) 
graph export "$doc\fig1_D.png", replace
*========================================================================*
/* FIGURE 2: English abilities, wages and education by occupations */
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
/* FIGURE A.1: English abilities, wages and education by occupations 
(low education) */
*========================================================================*
/* Panel (a). Proportion of female and English speakers */
graph hbar (mean) eng female [fw=weight] if age>=18 & age<=65 & edu<=9, ///
yline(0.0176, lstyle(grid) lpattern(dash) lcolor(red)) ///
over(occup, gap(*0.5)) graphregion(color(white)) scheme(s2mono) ///
ylabel(, grid format(%5.2f)) legend( label(1 "Speak English") label(2 "Female"))
graph export "$doc\occup_EngFemLow.png", replace
/* Pane (b). Wages and education */
graph hbar (mean) lwage edu [fw=weight] if age>=18 & age<=65 & edu<=9, ///
over(occup, gap(*0.5)) graphregion(color(white)) scheme(s2mono) ///
ylabel(, grid format(%5.0f)) legend( label(1 "ln(wage)") label(2 "Education"))
graph export "$doc\occup_WageEduLow.png", replace

*========================================================================*
/* FIGURE A.2: Mexican states with an increase of English instruction in 
primary schools */
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

/* Panel (b). Coahuila */
bysort year: egen hours_yearCOAH=mean(hours_eng) if public==1 & state==05
replace hours_yearCOAH=hours_yearCOAH*0.5 if year==1997
label var hours_yearCOAH "Hours of English instruction"

bysort year: egen hours_year_ruralCOAH=mean(hours_eng) if rural==1 & public==1 & state==05
label var hours_year_ruralCOAH "Hours of English instruction"

bysort year: egen hours_year_urbanCOAH=mean(hours_eng) if rural==0 & public==1 & state==05
replace hours_year_urbanCOAH=hours_year_urbanCOAH*0.5 if year==1997
label var hours_year_urbanCOAH "Hours of English instruction"
set scheme s1color
twoway line hours_yearCOAH year, msymbol(diamond) xlabel(1997(1)2013, angle(vertical)) ///
ytitle(Weekly hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(1999, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_ruralCOAH year || line hours_year_urbanCOAH year, ///
legend(label(1 "Coahuila") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graphCOAH.png", replace

/* Panel (c). Tamaulipas */
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
/* FIGURE A.3: Mexican states with some English instruction in public 
primary schools */
*========================================================================*
/* Panel (a). Durango */
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

/* Panel (b). Nuevo Leon */
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

/* Panel (c). Sinaloa */
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

/* Panel (d). Sonora */
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

*========================================================================*
/* Descriptive statistics */
*========================================================================*
use "$base/eng_abil.dta", clear
keep if biare==1 
eststo clear
eststo full_sample: quietly estpost sum eng hrs_exp income age edu female ///
indigenous married rural [aw=weight] if eng!=. & age>=18 & age<=65 & paidw==1
eststo eng: quietly estpost sum eng hrs_exp income age edu female ///
indigenous married rural [aw=weight] if eng==1 & age>=18 & age<=65 & paidw==1
eststo no_eng: quietly estpost sum eng hrs_exp income age edu female ///
indigenous married rural [aw=weight] if eng==0 & age>=18 & age<=65 & paidw==1
eststo diff: quietly estpost ttest eng hrs_exp income age edu female ///
indigenous married rural if eng!=. & age>=18 & age<=65 & paidw==1, by(eng) unequal
esttab full_sample eng no_eng diff using "$doc\sum_stats.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
foreach x in eng hrs_exp income age edu female indigenous married rural{
eststo: quietly reg `x' eng [aw=weight] if age>=18 & age<=65 & paidw==1, ///
vce(robust)
}
esttab using "$doc\sum_stats_diff.tex", ar2 cells(b(star fmt(%9.2fc)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Descriptive statistics) keep(eng) replace
*========================================================================*
/* Graphs for presentation */
*========================================================================*
use "$base/eng_abil.dta", clear

gen age_cat=.
replace age_cat=1 if age>=18 & age<=35
replace age_cat=2 if age>=36 & age<=50
replace age_cat=3 if age>=51 & age<=65
label define age_cat 1 "18-35" 2 "36-50" 3 "51-65"
label values age_cat age_cat

gen edu_level=.
replace edu_level=1 if edu<=5
replace edu_level=2 if edu==6
replace edu_level=3 if edu>=7 & edu<=9
replace edu_level=4 if edu>=10 & edu<=12
replace edu_level=5 if edu>=13
label define edu_level 1 "0-5" 2 "6" 3 "7-9" 4 "10-12" 5 "13-24"
label values edu_level edu_level

label define rural 0 "Urban" 1 "Rural"
label values rural rural
label define female 0 "Men" 1 "Women"
label values female female

sum income if age>=18 & age<=65
gen hinc=income>=r(mean)
label define hinc 0 "Low" 1 "High"
label values hinc hinc

graph set window fontface "Times New Roman"
graph bar eng [fw=weight] if age>=18 & age<=65, over(age_cat) ///
ytitle("Percent of English speakers") ///
graphregion(color(white)) 
graph export "$doc\EngAge.png", replace 

graph bar eng [fw=weight] if age>=18 & age<=65, over(edu_level) ///
ytitle("Percent of English speakers") ///
graphregion(color(white))
graph export "$doc\EngEdu.png", replace 

graph pie eng [fw=weight] if age>=18 & age<=65, over(female) ///
plabel(_all name, size(*2.5) color(white)) scheme(s2mono) ///
graphregion(color(white)) legend(off)
graph export "$doc\WM.png", replace 
sum eng [fw=weight] if age>=18 & age<=65
scalar total=r(N)*(r(mean)/100)
sum eng [fw=weight] if age>=18 & age<=65 & female==0
scalar men=r(N)*(r(mean)/100)
dis men/total
graph pie eng [fw=weight] if age>=18 & age<=65, over(rural) ///
plabel(_all name, size(*2) color(white)) scheme(s2mono) ///
graphregion(color(white)) legend(off)
graph export "$doc\RU.png", replace 
sum eng [fw=weight] if age>=18 & age<=65 & rural==0
scalar urban=r(N)*(r(mean)/100)
dis urban/total
graph pie eng [fw=weight] if age>=18 & age<=65, over(hinc) ///
plabel(_all name, size(*2.5) color(white)) scheme(s2mono) ///
graphregion(color(white)) legend(off)
graph export "$doc\Income.png", replace 
sum eng [fw=weight] if age>=18 & age<=65 & hinc==1
scalar high=r(N)*(r(mean)/100)
dis high/total