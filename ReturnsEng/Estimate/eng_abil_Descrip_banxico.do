*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\T43969\Documents\ReturnsEng\Data"
gl doc= "C:\Users\T43969\Documents\ReturnsEng\Doc"
*========================================================================*
/* Adult English speaking ability in Mexico */
*========================================================================*
use "$base\eng_abil.dta", clear
gen eng_states=1 if state=="01" | state=="05" | state=="10" | state=="17" ///
| state=="19" | state=="25" | state=="26" | state=="28" 
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
*========================================================================*
/* Maps */
*========================================================================*
use "$base\eng_abil.dta", clear

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

spmap eng_r using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 0.1) legend(off) 
graph export "$doc\map_eng_r.png", replace

spmap eng_u using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 0.1) legend(off) 
graph export "$doc\map_eng_u.png", replace
*========================================================================*
/* Statistics by occupations */
*========================================================================*
use "$base\eng_abil.dta", clear
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

label define occup 1 "Farming" 2 "Elementary occupations" 3 "Machine operators" ///
4 "Crafts" 5 "Customer service" 6 "Sales" 7 "Clerical support" ///
8 "Professionals/Technicians" 9 "Managerial" 10 "Abroad" 
label values occup occup

eststo clear
eststo english: quietly estpost tabstat eng [fw=weight] if age>=18 & age<=65, by(occup) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if age>=18 & age<=65, by(occup) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if age>=18 & age<=65, by(occup) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if age>=18 & age<=65, by(occup) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_occup_eng.tex", ///
cells("mean(fmt(%9.2fc))") nonumber noobs label replace
tab occup [fw=weight] if age>=18 & age<=65

/* Low education */
eststo clear
eststo english: quietly estpost tabstat eng [fw=weight] if age>=18 & age<=65 & edu<=9, by(occup) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if age>=18 & age<=65 & edu<=9, by(occup) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if age>=18 & age<=65 & edu<=9, by(occup) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if age>=18 & age<=65 & edu<=9, by(occup) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_occup_eng_ledu.tex", ///
cells("mean(fmt(%9.2fc))") nonumber noobs label replace
tab occup [fw=weight] if age>=18 & age<=65 & edu<=9

/* Detailed analysis of occupations 
keep if edu<=6
tostring sinco, replace format(%04.0f)
gen sinco_sub=substr(sinco,1,3)
destring sinco_sub sinco, replace
collapse (mean) eng [fw=weight], by(sinco_sub)
merge 1:1 sinco_sub using "$data/biare/sinco_code.dta"
drop if _merge!=3
drop _merge
label var sinco_d "Occupation"
keep if eng>0.5 & eng!=.
drop sinco_sub
sort eng
cd "C:\Users\galve\Documents\Papers\Ideas\Education\Returns to Eng Mex\Doc"
dataout, save(Occupation) tex replace dec(2) */
*========================================================================*
/* Statistics by economic industries */
*========================================================================*
use "$base\eng_abil.dta", clear
destring scian, replace
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
4 "Commerce" 5 "Manufactures" 6 "Hospitality and Entertainment" ///
7 "Transportation" 8 "Administrative and Support" 9 "Government" ///
10 "Professional/Technical" 11 "Telecom/Finance" 12 "Abroad"
label values econ_act econ_act

eststo clear
eststo english: quietly estpost tabstat eng [fw=weight] if age>=18 & age<=65, by(econ_act) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if age>=18 & age<=65, by(econ_act) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if age>=18 & age<=65, by(econ_act) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if age>=18 & age<=65, by(econ_act) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_econa_eng.tex", ///
cells("mean(fmt(%9.2fc))") nonumber noobs label replace
tab econ_act [fw=weight] if age>=18 & age<=65

/* Low education */
eststo clear
eststo english: quietly estpost tabstat eng [fw=weight] if age>=18 & age<=65 & edu<=9, by(econ_act) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if age>=18 & age<=65 & edu<=9, by(econ_act) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if age>=18 & age<=65 & edu<=9, by(econ_act) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if age>=18 & age<=65 & edu<=9, by(econ_act) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_econa_eng_edu.tex", ///
cells("mean(fmt(%9.3fc))") nonumber noobs label replace
tab econ_act [fw=weight] if age>=18 & age<=65 & edu<=9

/* Detailed analysis of occupations 
keep if edu<=6
tostring scian, replace format(%04.0f)
gen naics_sub=substr(scian,1,3)
destring naics_sub scian, replace
replace naics_sub=221 if naics_sub==222
collapse (mean) eng [fw=weight], by(naics_sub)
merge 1:1 naics_sub using "$data/biare/naics_code.dta"
drop if _merge!=3
drop _merge
label var naics_d "Econ Industry"
keep if eng>0.5 & eng!=.
drop naics_sub
sort eng
cd "C:\Users\galve\Documents\Papers\Ideas\Education\Returns to Eng Mex\Doc"
dataout, save(NAICS) tex replace dec(2) */

/*
use "$base\eng_abil.dta", clear
rename scian naics
replace naics=2211 if naics==2210
replace naics=2212 if naics==2221
replace naics=2213 if naics==2222
gen p_eng=eng
replace p_eng=0 if eng==.
collapse (mean) p_eng [fw=weight], by(naics)
save "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New\eng_naics.dta", replace
use "$base\eng_abil.dta", clear
rename scian naics
replace naics=2211 if naics==2210
replace naics=2212 if naics==2221
replace naics=2213 if naics==2222
keep if edu<=12
gen p_eng_edu=eng
replace p_eng_edu=0 if eng==.
collapse (mean) p_eng_edu [fw=weight], by(naics)
merge 1:1 naics using "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New\eng_naics.dta"
replace p_eng_edu=0 if p_eng_edu==.
drop _merge
xtile eng_dist= p_eng, nq(4)
xtile eng_dist_edu= p_eng_edu, nq(4)
save "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New\eng_naics.dta", replace */
*========================================================================*
/* Descriptive statistics */
*========================================================================*
use "$base\eng_abil.dta", clear
eststo clear
eststo full_sample: quietly estpost sum eng hrs_exp edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size [aw=weight] ///
if eng!=. & age>=18 & age<=65 
eststo eng: quietly estpost sum eng hrs_exp edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size [aw=weight] ///
if eng==1 & age>=18 & age<=65
eststo no_eng: quietly estpost sum eng hrs_exp edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size [aw=weight] ///
if eng==0 & age>=18 & age<=65
eststo diff: quietly estpost ttest eng hrs_exp edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size if age>=18 ///
& age<=65, by(eng) unequal
esttab full_sample eng no_eng diff using "$doc\sum_stats.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
foreach x in hrs_exp edu expe age female married income student work rural ///
female_hh age_hh edu_hh hh_size{
eststo: quietly reg `x' eng [aw=weight] if age>=18 & age<=65, vce(robust)
}
esttab using "$doc\sum_stats_diff.tex", ar2 cells(b(star fmt(%9.2fc)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Descriptive statistics) keep(eng) replace
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