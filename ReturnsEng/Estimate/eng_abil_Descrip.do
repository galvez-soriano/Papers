*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/data/main"
gl base= "C:\Users\galve\Documents\Papers\Current\Returns to Eng Mex\Data"
gl doc= "C:\Users\galve\Documents\Papers\Current\Returns to Eng Mex\Doc"
*========================================================================*
/* Adult English speaking ability in Mexico */
*========================================================================*
use "$base\eng_abil.dta", clear
gen eng_states=1 if state=="01" | state=="10" | state=="17" | state=="19" ///
| state=="25" | state=="26" | state=="28" | state=="05" | state=="31"
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

merge m:m state using "$data/Maps/MexStates/mex_map_state.dta"
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
/* Descriptive statistics */
*========================================================================*
use "$base\eng_abil.dta", clear
eststo clear
eststo full_sample: quietly estpost sum eng edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size [aw=weight] ///
if eng!=. & age>=18 & age<=65 
eststo eng: quietly estpost sum eng edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size [aw=weight] ///
if eng==1 & age>=18 & age<=65
eststo no_eng: quietly estpost sum eng edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size [aw=weight] ///
if eng==0 & age>=18 & age<=65
eststo diff: quietly estpost ttest eng edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size if age>=18 ///
& age<=65, by(eng) unequal
esttab full_sample eng no_eng diff using "$doc\sum_stats.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
foreach x in edu expe age female married income student work rural ///
female_hh age_hh edu_hh hh_size{
eststo: quietly reg `x' eng [aw=weight] if age>=18 & age<=65, vce(robust)
}
esttab using "$doc\sum_stats_diff.tex", ar2 cells(b(star fmt(%9.2fc)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Descriptive statistics) keep(eng) replace
*========================================================================*
/* Statistics by occupations */
use "$base\eng_abil.dta", clear
gen occup=.
replace occup=1 if (sinco>6101 & sinco<=6131) | (sinco>6201 & sinco<=6231) ///
| sinco==6999
replace occup=2 if (sinco>=9111 & sinco<=9899) 
replace occup=3 if (sinco>=7111 & sinco<=7135) | (sinco>=7211 & sinco<=7223) ///
| (sinco>=7311 & sinco<=7353) | (sinco>=7411 & sinco<=7412) | (sinco>=7511 & ///
sinco<=7517) | (sinco>=7611 & sinco<=7999)
replace occup=4 if (sinco>=5111 & sinco<=5116) | (sinco>=5211 & sinco<=5254) ///
| (sinco>=5311 & sinco<=5314) | (sinco>=5411 & sinco<=5999)
replace occup=5 if sinco==4111 | (sinco>=4211 & sinco<=4999)
replace occup=6 if sinco==6311 | (sinco>=8111 & sinco<=8199) | (sinco>=8211 ///
& sinco<=8212) | (sinco>=8311 & sinco<=8999)
replace occup=7 if (sinco>=3111 & sinco<=3142) | (sinco>=3211 & sinco<=3999)
replace occup=8 if (sinco>=1111 & sinco<=1999) | sinco==2630 ///
| sinco==2630 | sinco==2640 | sinco==3101 | sinco==3201 | sinco==4201 ///
| sinco==5101 | sinco==5201 | sinco==5301 | sinco==5401 | sinco==6101 ///
| sinco==6201 | sinco==7101 | sinco==7201 | sinco==7301 | sinco==7401 ///
| sinco==7501 | sinco==7601 | sinco==8101 | sinco==8201 | sinco==8301
replace occup=9 if sinco==980
replace occup=10 if (sinco>=2111 & sinco<=2625) | (sinco>=2631 & sinco<=2639) ///
| (sinco>=2641 & sinco<=2992)

label define occup 1 "Farming" 2 "Elementary occupations" 3 "Crafts" ///
4 "Services" 5 "Commerce" 6 "Machine operators" 7 "Clerical support" ///
8 "Managerial" 9 "Abroad" 10 "Professionals/Technicians"
label values occup occup

eststo clear
eststo english: quietly estpost tabstat eng [fw=weight] if eng!=. & age>=18 & age<=65, by(occup) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if eng!=. & age>=18 & age<=65, by(occup) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if eng!=. & age>=18 & age<=65, by(occup) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if eng!=. & age>=18 & age<=65, by(occup) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_occup_eng.tex", ///
cells("mean(fmt(%9.2fc))") nonumber noobs label replace
tab occup [fw=weight] if eng!=. & age>=18 & age<=65

/* Low education */
eststo clear
eststo english: quietly estpost tabstat eng [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=6, by(occup) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=6, by(occup) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=6, by(occup) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=6, by(occup) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_occup_eng_ledu.tex", ///
cells("mean(fmt(%9.2fc))") nonumber noobs label replace
tab occup [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=6

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
/* Statistics by economic activities */
use "$base\eng_abil.dta", clear
gen econ_act=.
replace econ_act=1 if (scian>=1110 & scian<=1199)
replace econ_act=2 if (scian>1199 & scian<=2399)
replace econ_act=3 if (scian>=8111 & scian<=8140)
replace econ_act=4 if (scian>3399 & scian<=4699)
replace econ_act=5 if (scian>=7111 & scian<=7223)
replace econ_act=6 if (scian>2399 & scian<=3399)
replace econ_act=7 if (scian>4699 & scian<=4930)
replace econ_act=8 if (scian>=5611 & scian<=5622)
replace econ_act=9 if (scian>=9311 & scian<=9399)
replace econ_act=10 if (scian>=5411 & scian<=5414) | (scian>=6111 & scian<=6299) ///
| scian==5510 // Includes Professional, Technical and Management
replace econ_act=11 if scian==980
replace econ_act=12 if (scian>=5110 & scian<=5399) //Includes telecommunications, finance and real state

label define econ_act 1 "Agriculture" 2 "Construction" 3 "Other Services" ///
4 "Commerce" 5 "Hospitality and Entertainment" 6 "Manufactures" ///
7 "Transportation" 8 "Administrative" 9 "Government" ///
10 "Professional/Technical" 11 "Abroad" 12"Telecom/Finance"
label values econ_act econ_act

eststo clear
eststo english: quietly estpost tabstat eng [fw=weight] if eng!=. & age>=18 & age<=65, by(econ_act) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if eng!=. & age>=18 & age<=65, by(econ_act) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if eng!=. & age>=18 & age<=65, by(econ_act) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if eng!=. & age>=18 & age<=65, by(econ_act) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_econa_eng.tex", ///
cells("mean(fmt(%9.2fc))") nonumber noobs label replace
tab econ_act [fw=weight] if eng!=. & age>=18 & age<=65

/* Low education */
eststo clear
eststo english: quietly estpost tabstat eng [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=6, by(econ_act) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=6, by(econ_act) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=6, by(econ_act) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=6, by(econ_act) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_econa_eng_edu.tex", ///
cells("mean(fmt(%9.2fc))") nonumber noobs label replace
tab econ_act [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=6

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
