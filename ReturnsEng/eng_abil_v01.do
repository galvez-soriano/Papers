*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/data/main/biare/2014"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\English abilities"
gl doc= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Doc"
*========================================================================*
use "$base\poblacion.dta", clear
gen str id_hh=(folioviv + foliohog)
gen str id=(folioviv + foliohog + numren)
keep id_hh id sexo edad hablaind asis_esc nivel grado nivelaprob gradoaprob ///
antec_esc residencia edo_conyug segsoc ss_aa hor_1 hor_2 segpop ///
inscr_1 trabajo_mp act_pnea1
destring sexo hablaind asis_esc nivel grado nivelaprob gradoaprob antec_esc ///
edo_conyug segsoc segpop inscr_1 trabajo_mp act_pnea1, replace
rename sexo female
recode female (1=0) (2=1)
rename edad age
rename hablaind indigenous
recode indigenous (2=0)
rename asis_esc student
recode student (2=0)
rename nivel level
rename grado grade
replace grade=1 if level==3 & grade==. & age==12
replace grade=2 if level==3 & grade==. & age==13
replace grade=3 if level==3 & grade==. & age==14
replace grade=1 if level==5 & grade==. & age==15
replace grade=2 if level==5 & grade==. & age==16
replace grade=3 if level==5 & grade==. & age==17
replace nivelaprob=3 if level==3 & nivelaprob==.
replace nivelaprob=4 if level==5 & nivelaprob==.
replace gradoaprob=grade-1 if gradoaprob==. & grade!=.
gen edu=.
replace edu=0 if nivelaprob==0 | nivelaprob==1
replace edu=gradoaprob if nivelaprob==2
replace edu=6+gradoaprob if nivelaprob==3
replace edu=6+gradoaprob if nivelaprob==6 & antec_esc==1
replace edu=9+gradoaprob if nivelaprob==4
replace edu=9+gradoaprob if nivelaprob==6 & antec_esc==2
replace edu=9+gradoaprob if nivelaprob==6 & antec_esc==.
replace edu=12+gradoaprob if nivelaprob==5
replace edu=12+gradoaprob if nivelaprob==6 & antec_esc==3
replace edu=12+gradoaprob if nivelaprob==7
replace edu=16+gradoaprob if nivelaprob==8
replace edu=16+gradoaprob if nivelaprob==9 & antec_esc==4
replace edu=18+gradoaprob if nivelaprob==9 & antec_esc==5
replace edu=18+gradoaprob if nivelaprob==9 & antec_esc==.
replace edu=0 if edu==. & age<6
rename residencia state5
gen married=edo_conyug<=2
rename segsoc ss
recode ss (2=0)
recode segpop (2=0)
rename ss_aa ss_years 
rename hor_1 hrs_work 
rename hor_2 hrs_study
rename inscr_1 med_affil 
replace med_affil=0 if med_affil==.
rename trabajo_mp work
recode work (2=0)
replace work=1 if act_pnea1==1
drop nivelaprob gradoaprob antec_esc edo_conyug act_pnea1
order id_hh id
save "$base\eng_abil.dta", replace
*========================================================================*
import delimited "$data/2014/ingresos.csv", clear 
tostring foliohog, replace
tostring folioviv, replace format(%10.0f) force
replace folioviv="0"+folioviv in 1/45831
tostring numren, replace format(%02.0f) force
gen str id=(folioviv + foliohog + numren)
collapse (sum) ing_tri, by(id)
rename ing_tri income
replace income=income/3
merge 1:1 id using "$base\eng_abil.dta"
drop _merge
replace income=0 if income==.
save "$base\eng_abil.dta", replace
*========================================================================*
import delimited "$data/2014/trabajos.csv", clear
tostring foliohog, replace
tostring folioviv, replace format(%10.0f) force
replace folioviv="0"+folioviv in 1/18057
tostring numren, replace format(%02.0f) force
gen str id=(folioviv + foliohog + numren)
drop if id_trabajo==2
keep id pago trapais pres_20 htrab sinco scian clas_emp tam_emp tiene_suel tipoact
destring pago trapais pres_20 clas_emp tam_emp tiene_suel tipoact, replace
recode trapais (2=0)
merge 1:1 id using "$base\eng_abil.dta"
drop _merge
save "$base\eng_abil.dta", replace
*========================================================================*
import delimited "$data/2014/concentradohogar.csv", clear
rename ubica_geo geo
sort geo
tostring geo, replace format(%09.0f) force
tostring foliohog, replace
tostring folioviv, replace format(%10.0f) force
replace folioviv="0"+folioviv in 1/10852
gen str id_hh=(folioviv + foliohog)
keep id_hh id geo tam_loc sexo_jefe edad_jefe educa_jefe tot_integ ///
ing_cor smg
destring tam_loc sexo_jefe educa_jefe, replace
gen rural=tam_loc==4
rename sexo_jefe female_hh
recode female_hh (1=0) (2=1)
rename edad_jefe age_hh
rename educa_jefe edu_hh
rename tot_integ hh_size
rename ing_cor income_hh
replace income_hh=income_hh/3
rename smg min_wage
replace min_wage=min_wage/3
drop tam_loc
merge 1:m id_hh using "$base\eng_abil.dta"
drop _merge
save "$base\eng_abil.dta", replace
*========================================================================*
import delimited "$data/2014/biare.csv", clear
tostring foliohog, replace
tostring folioviv, replace format(%10.0f) force
replace folioviv="0"+folioviv in 1/10852
tostring numren, replace format(%02.0f) force
gen str id=(folioviv + foliohog + numren)
keep id lengua_2 factor_per
destring lengua_2, replace
rename lengua_2 eng
recode eng (2=0)
merge 1:1 id using "$base\eng_abil.dta"
drop _merge
order geo id_hh id state5 female age edu student work
replace income=min_wage if hrs_work!=. & income==. & pago==1
gen formal=1 if work==1
replace formal=0 if pres_20==20
replace formal=0 if ss==0 & work==1
replace formal=1 if med_affil==1 & work==1 & formal==0
drop trapais pago pres_20 htrab tiene_suel min_wage clas_emp tam_emp ///
tiene_suel tipoact med_affil ss ss_years segpop
rename factor_per weight
save "$base\eng_abil.dta", replace
*========================================================================*
use "$base\eng_abil.dta", clear
collapse (mean) weight, by(id_hh)

merge m:m id_hh using "$base\eng_abil.dta"
drop _merge
gen state=substr(geo,1,2)
gen cohort=2014-age
gen expe=age-5-edu
replace expe=0 if age<16
replace expe=0 if expe<0
gen expe2=expe^2
label var eng "English (speaking ability)"
label var edu "Education (years)"
label var expe "Experience (years)"
label var age "Age (years)"
label var female "Female (\%)"
label var married "Married (\%)"
label var income "Wage (monthly pesos)"
label var student "Student (\%)"
label var work "Worker (\%)"
label var rural "Rural (\%)"
label var female_hh "Female household head (\%)"
label var age_hh "Age household head (years)"
label var edu_hh "Education household head (\%)"
label var hh_size "Household size (persons)"
save "$base\eng_abil.dta", replace
*========================================================================*
/* English abilities in Nuevo Leon */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="19" | state=="08"
drop if state!=state5
gen treat=state=="19"
gen after=age<=27
replace after=. if age<18 | age>37
gen after_treat=after*treat

eststo clear
eststo: areg eng after_treat treat i.cohort edu female female_hh age_hh edu_hh hh_size ///
[aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_eng_abil.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(after_treat) replace

gen cohort_77_81=0
replace cohort_77_81=1 if cohort>=1977 & cohort<=1981
gen cohort_82_86=0
replace cohort_82_86=1 if cohort>=1982 & cohort<=1986
gen cohort_87_91=0
replace cohort_87_91=1 if cohort>=1987 & cohort<=1991
gen cohort_92_96=0
replace cohort_92_96=1 if cohort>=1992 & cohort<=1996

gen treat_82_86=0
replace treat_82_86=1 if treat==1 & cohort_82_86==1
label var treat_82_86 "1982-1986"
gen treat_87_91=0
replace treat_87_91=1 if treat==1 & cohort_87_91==1
label var treat_87_91 "1987-1991"
gen treat_92_96=0
replace treat_92_96=1 if treat==1 & cohort_92_96==1
label var treat_92_96 "1992-1996"

areg eng treat_* treat cohort_* edu female female_hh age_hh edu_hh hh_size ///
[aw=weight] if age>=18 & age<=37, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) ///
xline(1.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort bins", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 1)) text(1.15 0.95 "Eng program in 6th grade", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\eng_abil.png", replace 
*========================================================================*
/* Descriptive statistics */
*========================================================================*
use "$base\eng_abil.dta", clear
*gen eng_2=eng==1
eststo clear
eststo full_sample: quietly estpost sum eng edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size [aw=weight] ///
if eng!=. & age>=16 & age<=65 
eststo eng: quietly estpost sum eng edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size [aw=weight] ///
if eng==1 & age>=16 & age<=65
eststo no_eng: quietly estpost sum eng edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size [aw=weight] ///
if eng==0 & age>=16 & age<=65
eststo diff: quietly estpost ttest eng edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size if age>=16 ///
& age<=65, by(eng) unequal
esttab full_sample eng no_eng diff using "$doc\sum_stats.tex", ///
cells("mean(pattern(1 1 1 0) fmt(2)) b(star pattern(0 0 0 1) fmt(2))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
foreach x in edu expe age female married income student work rural ///
female_hh age_hh edu_hh hh_size{
eststo: quietly reg `x' eng [aw=weight] if age>=16 & age<=65, vce(robust)
}
esttab using "$doc\sum_stats_diff.tex", ar2 cells(b(star fmt(%9.2f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Descriptive statistics) keep(eng) replace
*========================================================================*
/* Missing are zeros? */
gen eng_0=eng==.
replace eng_0=. if eng==1
label var eng_0 "English (speaking ability)"
eststo clear
eststo missing: quietly estpost sum eng_0 edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size [aw=weight] ///
if eng_0==1 & age>=16 & age<=65
eststo no_eng: quietly estpost sum eng_0 edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size [aw=weight] ///
if eng_0==0 & age>=16 & age<=65
eststo diff: quietly estpost ttest eng_0 edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size if age>=16 ///
& age<=65, by(eng_0) unequal
esttab missing no_eng diff using "$doc\sum_stats_miss.tex", ///
cells("mean(pattern(1 1 0) fmt(2)) b(star pattern(0 0 1) fmt(2))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
foreach x in edu expe age female married income student work rural ///
female_hh age_hh edu_hh hh_size{
eststo: quietly reg `x' eng_0 [aw=weight] if age>=16 & age<=65, vce(robust)
}
esttab using "$doc\sum_stats_diff_miss.tex", ar2 cells(b(star fmt(%9.2f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Descriptive statistics) keep(eng_0) replace
*========================================================================*
/* Adding only real zeros by excluding high achieving and adding rural adults */
replace eng_0=. if (edu>8 & eng_0==1) | (eng_0==1 & income>20000)
replace eng_0=1 if rural==1 & eng!=1 & eng_0==.
eststo clear
eststo missing: quietly estpost sum eng_0 edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size [aw=weight] ///
if eng_0==1 & age>=16 & age<=65
eststo no_eng: quietly estpost sum eng_0 edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size [aw=weight] ///
if eng_0==0 & age>=16 & age<=65
eststo diff: quietly estpost ttest eng_0 edu expe age female married ///
income student work rural female_hh age_hh edu_hh hh_size if age>=16 ///
& age<=65, by(eng_0) unequal
esttab missing no_eng diff using "$doc\sum_stats_miss_ed.tex", ///
cells("mean(pattern(1 1 0) fmt(2)) b(star pattern(0 0 1) fmt(2))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
foreach x in edu expe age female married income student work rural ///
female_hh age_hh edu_hh hh_size{
eststo: quietly reg `x' eng_0 [aw=weight] if age>=16 & age<=65, vce(robust)
}
esttab using "$doc\sum_stats_diff_miss_ed.tex", ar2 cells(b(star fmt(%9.2f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Descriptive statistics) keep(eng_0) replace
*========================================================================*
/* Statistics by occupations */
use "$base\eng_abil.dta", clear
gen occup=.
replace occup=1 if (sinco>6101 & sinco<=6131) | (sinco>6201 & sinco<=6231) ///
| sinco==6999
replace occup=2 if sinco==4111 | (sinco>=4211 & sinco<=4999)
replace occup=3 if (sinco>=5111 & sinco<=5116) | (sinco>=5211 & sinco<=5254) ///
| (sinco>=5311 & sinco<=5314) | (sinco>=5411 & sinco<=5999)
replace occup=4 if (sinco>=7111 & sinco<=7135) | (sinco>=7211 & sinco<=7223) ///
| (sinco>=7311 & sinco<=7353) | (sinco>=7411 & sinco<=7412) | (sinco>=7511 & ///
sinco<=7517) | (sinco>=7611 & sinco<=7999)
replace occup=5 if (sinco>=9111 & sinco<=9899) 
replace occup=6 if sinco==6311 | (sinco>=8111 & sinco<=8199) | (sinco>=8211 ///
& sinco<=8212) | (sinco>=8311 & sinco<=8999)
replace occup=7 if (sinco>=2111 & sinco<=2625) | (sinco>=2631 & sinco<=2639) ///
| (sinco>=2641 & sinco<=2992)
replace occup=8 if (sinco>=3111 & sinco<=3142) | (sinco>=3211 & sinco<=3999)
replace occup=9 if sinco==980 | (sinco>=1111 & sinco<=1999) | sinco==2630 ///
| sinco==2630 | sinco==2640 | sinco==3101 | sinco==3201 | sinco==4201 ///
| sinco==5101 | sinco==5201 | sinco==5301 | sinco==5401 | sinco==6101 ///
| sinco==6201 | sinco==7101 | sinco==7201 | sinco==7301 | sinco==7401 ///
| sinco==7501 | sinco==7601 | sinco==8101 | sinco==8201 | sinco==8301

label define occup 1 "Farming" 2 "Commerce" ///
3 "Services" 4 "Crafts" 5 "Elementary occupations" 6 "Machine operators" ///
7 "Professionals/Technicians" 8 "Clerical support" 9 "Managerial/Abroad"
label values occup occup

tab occup [fw=weight]
table occup [fw=weight], contents(mean eng mean income)

tostring sinco, replace format(%04.0f)
gen sinco_sub=substr(sinco,1,3)
destring sinco_sub sinco, replace
collapse (mean) eng [fw=weight], by(sinco_sub)
merge 1:1 sinco_sub using "$data/sinco_code.dta"
drop if _merge!=3
drop _merge
bro if eng>0.8 & eng!=.
sort eng
*========================================================================*
/* Statistics by economic activities */
use "$base\eng_abil.dta", clear
gen econ_act=.
replace econ_act=1 if (scian>=1110 & scian<=1199)
replace econ_act=2 if (scian>1199 & scian<=2399)
replace econ_act=3 if (scian>2399 & scian<=3399)
replace econ_act=4 if (scian>3399 & scian<=4699)
replace econ_act=5 if (scian>4699 & scian<=4930)
replace econ_act=6 if (scian>=5110 & scian<=5399) //Includes telecommunications, finance and real state
replace econ_act=7 if (scian>=5411 & scian<=5414) | (scian>=6111 & scian<=6299) ///
| scian==5510 | scian==980 // Includes Professional, Technical, Management and Abroad
replace econ_act=8 if (scian>=5611 & scian<=5622)
replace econ_act=9 if (scian>=7111 & scian<=7223)
replace econ_act=10 if (scian>=8111 & scian<=8140)
replace econ_act=11 if (scian>=9311 & scian<=9399)

label define econ_act 1 "Agriculture" 2 "Construction" 3 "Manufactures" ///
4 "Commerce" 5 "Transportation" 6 "Telecom/Finance" 7 "Professional/Technical" ///
8 "Admninistrative" 9 "Hospitality and Entertainment" 10 "Other Services" ///
11 "Government"
label values econ_act econ_act

tab econ_act [fw=weight]
table econ_act [fw=weight], contents(mean eng mean income)

tostring scian, replace format(%04.0f)
gen naics_sub=substr(scian,1,3)
destring naics_sub scian, replace
replace naics_sub=221 if naics_sub==222
collapse (mean) eng [fw=weight], by(naics_sub)
merge 1:1 naics_sub using "$data/naics_code.dta"
drop if _merge!=3
drop _merge
bro if eng>0.8 & eng!=.
sort eng
*========================================================================*
/* Returns to English skills */
*========================================================================*
use "$base\eng_abil.dta", clear
replace income=income+1
gen lincome=log(income)
/* Full sample */
eststo clear
eststo: reg lincome eng [aw=weight] if age>=16 & age<=65, vce(cluster geo)
eststo: reg lincome eng edu expe expe2 [aw=weight] if age>=16 ///
& age<=65, vce(cluster geo)
eststo: reg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=16 & age<=65, vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=16 & age<=65, absorb(state) vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=16 & age<=65, absorb(geo) vce(cluster geo)
/*esttab using "$doc\tab_returns_eng.tex", ar2 cells(b(star fmt(%9.3f)) ///
se(par)) star(* 0.10 ** 0.05 *** 0.01) title(Returns to Eng) keep(eng) replace*/

/* Men */
eststo clear
eststo: reg lincome eng [aw=weight] if age>=16 & age<=65  & female==0, ///
vce(cluster geo)
eststo: reg lincome eng edu expe expe2 [aw=weight] if (age>=16 ///
& age<=65) & female==0, vce(cluster geo)
eststo: reg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=16 & age<=65) & female==0, vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=16 & age<=65) & female==0, absorb(state) vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=16 & age<=65) & female==0, absorb(geo) vce(cluster geo)
/*esttab using "$doc\tab_returns_eng_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to Eng (Men)) keep(eng) replace*/

/* Women */
eststo clear
eststo: reg lincome eng [aw=weight] if age>=16 & age<=65  & female==1, ///
vce(cluster geo)
eststo: reg lincome eng edu expe expe2 [aw=weight] if (age>=16 ///
& age<=65) & female==1, vce(cluster geo)
eststo: reg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=16 & age<=65) & female==1, vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=16 & age<=65) & female==1, absorb(state) vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=16 & age<=65) & female==1, absorb(geo) vce(cluster geo)
/*esttab using "$doc\tab_returns_eng_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to Eng (Women)) keep(eng) replace*/

/* Gender */
gen eng_female=eng*female
eststo clear
eststo: reg lincome eng_female eng female [aw=weight] if age>=16 & age<=65, vce(cluster geo)
eststo: reg lincome eng_female eng edu expe expe2 female [aw=weight] if age>=16 ///
& age<=65, vce(cluster geo)
eststo: reg lincome eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=16 & age<=65, vce(cluster geo)
eststo: areg lincome eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=16 & age<=65, absorb(state) vce(cluster geo)
eststo: areg lincome eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=16 & age<=65, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng_gender.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to Eng) keep(eng_female) replace

/* Education */
gen edu_level=0
replace edu_level=1 if edu>=1 & edu<=5
replace edu_level=2 if edu==6
replace edu_level=3 if edu>=7 & edu<=8
replace edu_level=4 if edu==9
replace edu_level=5 if edu>=10 & edu<=12
replace edu_level=6 if edu>=13 & edu<=16
replace edu_level=7 if edu>=17

gen eng_edu=eng*edu_level
foreach x in 0 1 2 3 4 5 6 7{
gen engedu`x'=eng_edu==`x'
}
replace engedu1=0
label var engedu0 "No-edu"
label var engedu1 "Elem-drop"
label var engedu2 "Elem S"
label var engedu3 "Middle-drop"
label var engedu4 "Middle S"
label var engedu5 "High S"
label var engedu6 "College"
label var engedu7 "Graduate"
areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh married ///
engedu* [aw=weight] if age>=16 & age<=65, absorb(geo) vce(cluster geo)

*graph set window fontface "Times New Roman"
coefplot, vertical keep(engedu*) yline(0) omitted baselevels ///
ytitle("Returns to English abilities by education levels", size(small) height(5)) ///
ylabel(-4(2)4, labs(small) grid) ///
xtitle("Levels of education", size(small) height(5)) xlabel(,labs(small)) ///
graphregion(color(white)) scheme(s2mono) recast(connected) ciopts(recast(rcap)) ///
ysc(r(-0.5 1)) 
graph export "$doc\eng_abil_edu.png", replace 