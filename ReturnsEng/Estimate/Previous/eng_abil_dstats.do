*========================================================================*
* English skills and labor market outcomes in Mexico
*========================================================================*
* Author: Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/ReturnsEng/Data"
gl doc= "C:\Users\iscot\Documents\GalvezSoriano\Papers\EngSkills\Doc"
*========================================================================*
/* TABLE 1. Adult English speaking ability in Mexico */
*========================================================================*
use "$base/eng_abil.dta", clear
gen eng_states=1 if state=="01" | state=="10" | state=="19" | state=="25" ///
| state=="26" | state=="28" | state=="05" | state=="31"
replace eng_state=0 if eng_state==.
replace eng=eng*100

eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & female==0
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & female==0
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & female==0
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & female==1
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & female==1
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & female==1
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=35
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=35
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=35
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=36 & age<=50
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=36 & age<=50
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=36 & age<=50
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=51 & age<=65
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=51 & age<=65
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=51 & age<=65
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & edu>=0 & edu<=5
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & edu>=0 & edu<=5
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & edu>=0 & edu<=5
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & edu==6
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & edu==6
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & edu==6
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & edu>=7 & edu<=9
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & edu>=7 & edu<=9
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & edu>=7 & edu<=9
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & edu>=10 & edu<=12
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & edu>=10 & edu<=12
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & edu>=10 & edu<=12
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & edu>=13
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & edu>=13
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & edu>=13
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & indigenous==1
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & indigenous==1
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & indigenous==1
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & indigenous==0
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & indigenous==0
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & indigenous==0
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & rural==0
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & rural==0
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & rural==0
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & rural==1
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & rural==1
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & rural==1
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

sum income if age>=18 & age<=65
scalar minc=r(mean)
eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & income<minc
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & income<minc
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & income<minc
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
eststo full_sample: quietly estpost sum eng [fw=weight] if age>=18 & age<=65 & income>minc
eststo eng: quietly estpost sum eng [fw=weight] if eng_state==1 & age>=18 & age<=65 & income>minc
eststo no_eng: quietly estpost sum eng [fw=weight] if eng_state==0 & age>=18 & age<=65 & income>minc
esttab full_sample eng no_eng using "$doc\sum_stats.tex", ///
cells("mean(fmt(%9.2fc))" "sd(par fmt(%15.2fc))") star(* 0.10 ** 0.05 *** 0.01) label replace

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
reg eng eng_state [aw=weight] if age>=18 & age<=65 & income<minc, vce(robust)
reg eng eng_state [aw=weight] if age>=18 & age<=65 & income>minc, vce(robust)
*========================================================================*
/* FIGURE 1. Exposure to English instruction and English abilities in 
Mexican states */
*========================================================================*
use "$base/eng_abil.dta", clear

destring state, replace
gen eng_r=eng if rural==1
gen eng_u=eng if rural==0
keep if age>=18 & age<=65
collapse (mean) eng* hrs_exp [fw=weight], by(state)

merge m:m state using "$data/data/main/Maps/MexStates/mex_map_state.dta"
drop if _merge!=3
drop _merge

format eng* %12.2f
/* English ability self reported */
spmap eng using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 0.1) legend(size(*3))
graph export "$doc\map_eng.png", replace
/* Panel (a) */
spmap eng_r using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 0.1) legend(off) 
graph export "$doc\map_eng_r.png", replace
/* Panel (b) */
spmap eng_u using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 0.1) legend(size(*3)) 
graph export "$doc\map_eng_u.png", replace
*========================================================================*
/* FIGURE 2. English abilities, wages and education by occupations */
*========================================================================*
use "$base/eng_abil.dta", clear
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
/* Panel (a) */
graph hbar (mean) eng female [fw=weight] if age>=18 & age<=65, ///
over(occup, gap(*0.5)) graphregion(color(white)) scheme(s2mono) ///
ylabel(, grid format(%5.2f)) legend( label(1 "Speak English") label(2 "Female"))
graph export "$doc\occup_EngFem.png", replace
/* Panel (b) */
graph hbar (mean) lwage edu [fw=weight] if age>=18 & age<=65, ///
over(occup, gap(*0.5)) graphregion(color(white)) scheme(s2mono) ///
ylabel(, grid format(%5.0f)) legend( label(1 "ln(wage)") label(2 "Education"))
graph export "$doc\occup_WageEdu.png", replace
*========================================================================*
/* FIGURE A.1. English abilities, wages and education by occupations 
(Low education) */
*========================================================================*
/* Panel (a) */
graph hbar (mean) eng female [fw=weight] if age>=18 & age<=65 & edu<=9, ///
over(occup, gap(*0.5)) graphregion(color(white)) scheme(s2mono) ///
ylabel(, grid format(%5.2f)) legend( label(1 "Speak English") label(2 "Female"))
graph export "$doc\occup_EngFemLow.png", replace
/* Panel (b) */
graph hbar (mean) lwage edu [fw=weight] if age>=18 & age<=65 & edu<=9, ///
over(occup, gap(*0.5)) graphregion(color(white)) scheme(s2mono) ///
ylabel(, grid format(%5.0f)) legend( label(1 "ln(wage)") label(2 "Education"))
graph export "$doc\occup_WageEduLow.png", replace
*========================================================================*
/* FIGURE 3: English abilities, wages and education by industries */
*========================================================================*
use "$base/eng_abil.dta", clear
gen econ_act=.
replace econ_act=1 if (scian>=1110 & scian<=1199)
replace econ_act=2 if (scian>=8111 & scian<=8140)
replace econ_act=3 if (scian>=2110 & scian<=2399)
replace econ_act=4 if (scian>=4310 & scian<=4699)
replace econ_act=5 if (scian>=3110 & scian<=3399)
replace econ_act=6 if (scian>=7111 & scian<=7223)
replace econ_act=7 if (scian>=4810 & scian<=4930)
replace econ_act=8 if (scian>=5611 & scian<=5622)
replace econ_act=9 if (scian>=9311 & scian<=9399)
replace econ_act=10 if (scian>=5411 & scian<=5414) | (scian>=6111 & scian<=6299) ///
| scian==5510 // Includes Professional, Technical and Management
replace econ_act=11 if (scian>=5110 & scian<=5399) //Includes telecommunications, finance and real state
replace econ_act=12 if scian==980

label define econ_act 1 "Agriculture" 2 "Other Services" 3 "Construction" ///
4 "Commerce" 5 "Manufacturing" 6 "Hospitality" ///
7 "Transportation" 8 "Admin and Support" 9 "Government" ///
10 "Pro/Tech" 11 "Telecom/Finance" 12 "Abroad"
label values econ_act econ_act
/* Panel (a) */
graph hbar (mean) eng female [fw=weight] if age>=18 & age<=65, ///
over(econ_act, gap(*0.5)) graphregion(color(white)) scheme(s2mono) ///
ylabel(, grid format(%5.2f)) legend( label(1 "Speak English") label(2 "Female"))
graph export "$doc\ind_EngFem.png", replace
/* Panel (b) */
graph hbar (mean) lwage edu [fw=weight] if age>=18 & age<=65, ///
over(econ_act, gap(*0.5)) graphregion(color(white)) scheme(s2mono) ///
ylabel(, grid format(%5.0f)) legend( label(1 "ln(wage)") label(2 "Education"))
graph export "$doc\ind_WageEdu.png", replace
*========================================================================*
/* FIGURE A.2. English abilities, wages and education by industries 
(Low education) */
*========================================================================*
/* Panel (a) */
graph hbar (mean) eng female [fw=weight] if age>=18 & age<=65 & edu<=9, ///
over(econ_act, gap(*0.5)) graphregion(color(white)) scheme(s2mono) ///
ylabel(, grid format(%5.2f)) legend( label(1 "Speak English") label(2 "Female"))
graph export "$doc\ind_EngFemLow.png", replace
/* Panel (b) */
graph hbar (mean) lwage edu [fw=weight] if age>=18 & age<=65 & edu<=9, ///
over(econ_act, gap(*0.5)) graphregion(color(white)) scheme(s2mono) ///
ylabel(, grid format(%5.0f)) legend( label(1 "ln(wage)") label(2 "Education"))
graph export "$doc\ind_WageEduLow.png", replace
*========================================================================*
/* TABLE 2. Descriptive statistics */
*========================================================================*
use "$base/eng_abil.dta", clear
eststo clear
eststo full_sample: quietly estpost sum income eng hrs_exp age edu female ///
indigenous married rural [aw=weight] if eng!=. & age>=18 & age<=65 & paidw==1
eststo eng: quietly estpost sum income eng hrs_exp age edu female ///
indigenous married rural [aw=weight] if eng==1 & age>=18 & age<=65 & paidw==1
eststo no_eng: quietly estpost sum income eng hrs_exp age edu female ///
indigenous married rural [aw=weight] if eng==0 & age>=18 & age<=65 & paidw==1
eststo diff: quietly estpost ttest income eng hrs_exp age edu female ///
indigenous married rural if eng!=. & age>=18 & age<=65 & paidw==1, by(eng) unequal
esttab full_sample eng no_eng diff using "$doc\sum_stats.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
foreach x in income eng hrs_exp age edu female indigenous married rural{
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
*========================================================================*
/* Maps for presentation */
*========================================================================*
use "$data/Papers/main/ReturnsEng/Data/map_names.dta", clear
merge m:m state using "$data/data/main/Maps/MexStates/mex_map_state.dta"
drop if _merge!=3
drop _merge
rename id _ID
merge m:m _ID using "$base\mxcoord.dta"
bysort state: gen nobs=_n
replace names="" if nobs!=1
replace ags="" if nobs!=1
replace coah="" if nobs!=1
replace dgo="" if nobs!=1
replace mor="" if nobs!=1
replace nl="" if nobs!=1
replace sin="" if nobs!=1
replace son="" if nobs!=1
replace tam="" if nobs!=1

save "$base\map_names.dta", replace

use "$base\map_presentation.dta", clear
merge m:m state using "$data/data/main/Maps/MexStates/mex_map_state.dta"
drop if _merge!=3
drop _merge

cd "C:\Users\galve\Documents\Papers\Current\Returns to Eng Mex\Data"
/* Map for Aguascalientes and Zacatecas */
spmap ags_zac using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 1) legend(off) fcolor(Greens) ///
label(data(map_names) xcoord(_X) ycoord(_Y) color(gray) ///
label(ags) size(*1.5 ..) pos(1 1) length(22))
graph export "$doc\map_AGS_ZAC.png", replace

/* Map for Coahuila and Chihuahua */
spmap coah_chih using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 1) legend(off) fcolor(Blues) ///
label(data(map_names) xcoord(_X) ycoord(_Y) color(gray) ///
label(coah) size(*1.5 ..) pos(1 1) length(22))
graph export "$doc\map_COAH_CHIH.png", replace

/* Map for Durango and San Luis Potosi */
spmap dgo_slp using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 1) legend(off) fcolor(Oranges) ///
label(data(map_names) xcoord(_X) ycoord(_Y) color(gray) ///
label(dgo) size(*1.5 ..) pos(1 1) length(22))
graph export "$doc\map_DGO_SLP.png", replace

/* Map for Morelos and Puebla */
spmap mor_pue using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 1) legend(off) fcolor(Purples) ///
label(data(map_names) xcoord(_X) ycoord(_Y) color(gray) ///
label(mor) size(*1.5 ..) pos(1 1) length(22))
graph export "$doc\map_MOR_PUE.png", replace
