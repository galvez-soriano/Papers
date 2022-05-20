*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/data/main/biare/2014"
gl base= "C:\Users\ogalvezs\Documents\Returns to Eng\Data"
gl doc= "C:\Users\ogalvezs\Documents\Returns to Eng\Doc"
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
import delimited "$data/ingresos.csv", clear 
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
import delimited "$data/trabajos.csv", clear
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
import delimited "$data/concentradohogar.csv", clear
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
import delimited "$data/biare.csv", clear
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
save "$base\eng_abil.dta", replace
*========================================================================*
/* English abilities in Nuevo Leon */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="19" | state=="08"
drop if state!=state5
gen cohort=2014-age
gen treat=state=="19"
gen after=age<=27
replace after=. if age<18 | age>37
gen after_treat=after*treat
replace eng=0 if eng==.
gen edu2=edu^2

eststo clear
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_eng_abil.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Labor Market Outcomes) keep(after_treat) replace

foreach x in 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_86=0
*recast(connected)
areg eng treat_* treat i.cohort edu edu2 female student work indigenous ///
[aw=weight] if age>=18 & age<=37, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(9.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort bins", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) /// 
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 6.3 "Eng program in 6th grade", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\eng_abil.png", replace 
*========================================================================*
/* English abilities in Tamaulipas */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="28" | state=="02"
drop if state!=state5
gen cohort=2014-age
gen treat=state=="28"
gen after=age<=23
replace after=. if age<18 | age>29
gen after_treat=after*treat
replace eng=0 if eng==.
gen edu2=edu^2

eststo clear
eststo: areg eng after_treat treat i.cohort edu edu2 female student work ///
indigenous [aw=weight], absorb(geo) vce(cluster geo)

foreach x in 86 87 88 89 90 91 92 93 94 95 96 {
    gen treat_`x'=cohort==19`x'
	replace treat_`x'=0 if treat==0
	label var treat_`x' "19`x'"
}
replace treat_90=0

areg eng treat_* treat cohort* edu female female_hh age_hh edu_hh hh_size ///
[aw=weight] if age>=18 & age<=29, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort bins", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(0.6 4.2 "Eng program", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
*========================================================================*
/* English abilities in Nuevo Leon and Tamaulipas */
*========================================================================*
use "$base\eng_abil.dta", clear
keep if state=="02" | state=="08" | state=="19" | state=="28"
drop if state!=state5
gen cohort=2014-age
gen had_policy=0 
replace had_policy=1 if state=="19" & age>=18 & age<=27
replace had_policy=1 if state=="28" & age>=18 & age<=23
destring state, replace
keep if age>=18 & age<=37
*replace eng=0 if eng==.
eststo clear
eststo: areg eng had_policy i.state [aw=weight], absorb(cohort) vce(cluster geo)
eststo: areg eng had_policy i.state edu female student work female_hh age_hh edu_hh hh_size ///
[aw=weight], absorb(cohort) vce(cluster geo)
eststo: areg eng had_policy i.cohort edu female student work female_hh age_hh edu_hh hh_size ///
[aw=weight], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_eng_abil2.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English instruction and Eng abilities) keep(had_policy) replace

gen cohort_77_78=0
replace cohort_77_78=1 if cohort>=1977 & cohort<=1978
gen cohort_79_80=0
replace cohort_79_80=1 if cohort>=1979 & cohort<=1980
gen cohort_81_82=0
replace cohort_81_82=1 if cohort>=1981 & cohort<=1982
gen cohort_83_84=0
replace cohort_83_84=1 if cohort>=1983 & cohort<=1984
gen cohort_85_86=0
replace cohort_85_86=1 if cohort>=1985 & cohort<=1986
gen cohort_87_88=0
replace cohort_87_88=1 if cohort>=1987 & cohort<=1988
gen cohort_89_90=0
replace cohort_89_90=1 if cohort>=1989 & cohort<=1990
gen cohort_91_92=0
replace cohort_91_92=1 if cohort>=1991 & cohort<=1992
gen cohort_93_94=0
replace cohort_93_94=1 if cohort>=1993 & cohort<=1994
gen cohort_95_96=0
replace cohort_95_96=1 if cohort>=1995 & cohort<=1996

gen treat_77_78=0
replace treat_77_78=1 if (state==19 | state==28) & cohort_77_78==1
label var treat_77_78 "77/78"
gen treat_79_80=0
replace treat_79_80=1 if (state==19 | state==28) & cohort_79_80==1
label var treat_79_80 "79/80"
gen treat_81_82=0
replace treat_81_82=1 if (state==19 | state==28) & cohort_81_82==1
label var treat_81_82 "81/82"
gen treat_83_84=0
replace treat_83_84=1 if (state==19 | state==28) & cohort_83_84==1
label var treat_83_84 "83/84"
gen treat_85_86=0
*replace treat_85_86=1 if had_policy==1 & cohort_85_86==1
label var treat_85_86 "85/86"
gen treat_87_88=0
replace treat_87_88=1 if had_policy==1 & cohort_87_88==1
label var treat_87_88 "87/88"
gen treat_89_90=0
replace treat_89_90=1 if had_policy==1 & cohort_89_90==1
label var treat_89_90 "89/90"
gen treat_91_92=0
replace treat_91_92=1 if had_policy==1 & cohort_91_92==1
label var treat_91_92 "91/92"
gen treat_93_94=0
replace treat_93_94=1 if had_policy==1 & cohort_93_94==1
label var treat_93_94 "93/94"
gen treat_95_96=0
replace treat_95_96=1 if had_policy==1 & cohort_95_96==1
label var treat_95_96 "95/96"

areg eng treat_* i.state cohort_* edu female female_hh age_hh edu_hh hh_size ///
[aw=weight] if age>=18 & age<=37, absorb(geo) vce(cluster geo)
coefplot, vertical keep(treat_*) yline(0) omitted baselevels ///
xline(5.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
xline(7.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohort bins", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 1)) text(1.15 3.8 "Eng program NL", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
text(1.15 6.2 "Eng program Tam", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\eng_abil2.png", replace 
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
/* Missing are zeros? */
replace eng=0 if eng==.
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
esttab full_sample eng no_eng diff using "$doc\sum_stats_miss.tex", ///
cells("mean(pattern(1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace

eststo clear
foreach x in edu expe age female married income student work rural ///
female_hh age_hh edu_hh hh_size{
eststo: quietly reg `x' eng [aw=weight] if age>=18 & age<=65, vce(robust)
}
esttab using "$doc\sum_stats_diff_miss.tex", ar2 cells(b(star fmt(%9.2fc)) se(par)) ///
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

/*********** With missings as zeros ************/
replace eng=0 if eng==.
eststo clear
eststo english: quietly estpost tabstat eng [fw=weight] if eng!=. & age>=18 & age<=65, by(occup) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if eng!=. & age>=18 & age<=65, by(occup) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if eng!=. & age>=18 & age<=65, by(occup) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if eng!=. & age>=18 & age<=65, by(occup) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_occup_eng_miss.tex", ///
cells("mean(fmt(%9.3fc))") nonumber noobs label replace
tab occup [fw=weight] if eng!=. & age>=18 & age<=65

/* Low education */
eststo clear
eststo english: quietly estpost tabstat eng [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=9, by(occup) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=9, by(occup) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=9, by(occup) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=9, by(occup) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_occup_eng_ledu_miss.tex", ///
cells("mean(fmt(%9.3fc))") nonumber noobs label replace
tab occup [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=9

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
keep if eng>0.02 & eng!=.
drop sinco_sub
sort eng
cd "C:\Users\galve\Documents\Papers\Ideas\Education\Returns to Eng Mex\Doc"
dataout, save(OccupationMiss) tex replace dec(2)*/
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
eststo english: quietly estpost tabstat eng [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=12, by(econ_act) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=12, by(econ_act) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=12, by(econ_act) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=12, by(econ_act) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_econa_eng_edu.tex", ///
cells("mean(fmt(%9.2fc))") nonumber noobs label replace
tab econ_act [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=12

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

/************** With missings as zeros **************/
replace eng=0 if eng==.
eststo clear
eststo english: quietly estpost tabstat eng [fw=weight] if eng!=. & age>=18 & age<=65, by(econ_act) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if eng!=. & age>=18 & age<=65, by(econ_act) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if eng!=. & age>=18 & age<=65, by(econ_act) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if eng!=. & age>=18 & age<=65, by(econ_act) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_econa_eng_miss.tex", ///
cells("mean(fmt(%9.3fc))") nonumber noobs label replace
tab econ_act [fw=weight] if eng!=. & age>=18 & age<=65

/* Low education */
eststo clear
eststo english: quietly estpost tabstat eng [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=12, by(econ_act) nototal c(stat) stat(mean)
eststo income: quietly estpost tabstat income [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=12, by(econ_act) nototal c(stat) stat(mean)
eststo gender: quietly estpost tabstat female [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=12, by(econ_act) nototal c(stat) stat(mean)
eststo education: quietly estpost tabstat edu [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=12, by(econ_act) nototal c(stat) stat(mean)
esttab english income gender education gender using "$doc\fq_econa_eng_edu_miss.tex", ///
cells("mean(fmt(%9.3fc))") nonumber noobs label replace
tab econ_act [fw=weight] if eng!=. & age>=18 & age<=65 & edu<=12

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
keep if eng>0.01 & eng!=.
drop naics_sub
sort eng
cd "C:\Users\galve\Documents\Papers\Ideas\Education\Returns to Eng Mex\Doc"
dataout, save(NAICSmiss) tex replace dec(2) 
*/
*========================================================================*
/* Replicating Table 4 of CIDAC report */
use "$base\eng_abil.dta", clear
replace eng=0 if eng==.
replace work=0 if work==.
sum eng [fw=weight] if age>=18 & age<=65
sum eng [fw=weight] if female==0 & age>=18 & age<=65
sum eng [fw=weight] if female==1 & age>=18 & age<=65
sum eng [fw=weight] if age>=18 & age<=29
sum eng [fw=weight] if age>=30 & age<=44
sum eng [fw=weight] if age>=45 & age<=55
sum eng [fw=weight] if edu>=1 & edu<=6 & age>=18 & age<=65
sum eng [fw=weight] if edu>=7 & edu<=9 & age>=18 & age<=65
sum eng [fw=weight] if edu>=10 & edu<=12 & age>=18 & age<=65
sum eng [fw=weight] if edu>=13 & edu<=16 & age>=18 & age<=65
sum eng [fw=weight] if work==1 & age>=18 & age<=65
sum eng [fw=weight] if student==1 & age>=18 & age<=65
sum eng [fw=weight] if student==0 & work==0 & age>=18 & age<=65
sum eng [fw=weight] if income<=1600 & age>=18 & age<=65
sum eng [fw=weight] if income>1600 & income<=2400 & age>=18 & age<=65
sum eng [fw=weight] if income>2400 & income<=3200 & age>=18 & age<=65
sum eng [fw=weight] if income>3200 & income<=4000 & age>=18 & age<=65
sum eng [fw=weight] if income>4000 & income<=5400 & age>=18 & age<=65
sum eng [fw=weight] if income>5400 & income<=6800 & age>=18 & age<=65
sum eng [fw=weight] if income>6800 & income<=10000 & age>=18 & age<=65
sum eng [fw=weight] if income>10000 & age>=18 & age<=65
*========================================================================*
/* Returns to English skills */
*========================================================================*
use "$base\eng_abil.dta", clear
*replace eng=0 if eng==.
replace income=income+1
gen lincome=log(income)
/* Full sample */
eststo clear
eststo: reg lincome eng [aw=weight] if age>=18 & age<=65, vce(cluster geo)
eststo: reg lincome eng edu expe expe2 [aw=weight] if age>=18 ///
& age<=65, vce(cluster geo)
eststo: reg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, absorb(state) vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng.tex", ar2 cells(b(star fmt(%9.3fc)) ///
se(par)) star(* 0.10 ** 0.05 *** 0.01) title(Returns to Eng) keep(eng) replace

/* Men */
eststo clear
eststo: reg lincome eng [aw=weight] if age>=18 & age<=65  & female==0, ///
vce(cluster geo)
eststo: reg lincome eng edu expe expe2 [aw=weight] if (age>=18 ///
& age<=65) & female==0, vce(cluster geo)
eststo: reg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==0, vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==0, absorb(state) vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng_men.tex", ar2 cells(b(star fmt(%9.3fc)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to Eng (Men)) keep(eng) replace

/* Women */
eststo clear
eststo: reg lincome eng [aw=weight] if age>=18 & age<=65  & female==1, ///
vce(cluster geo)
eststo: reg lincome eng edu expe expe2 [aw=weight] if (age>=18 ///
& age<=65) & female==1, vce(cluster geo)
eststo: reg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==1, vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==1, absorb(state) vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=18 & age<=65) & female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng_women.tex", ar2 cells(b(star fmt(%9.3fc)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to Eng (Women)) keep(eng) replace

/* Gender */
gen eng_female=eng*female
eststo clear
eststo: reg lincome eng_female eng female [aw=weight] if age>=18 & age<=65, vce(cluster geo)
eststo: reg lincome eng_female eng edu expe expe2 female [aw=weight] if age>=18 ///
& age<=65, vce(cluster geo)
eststo: reg lincome eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, vce(cluster geo)
eststo: areg lincome eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, absorb(state) vce(cluster geo)
eststo: areg lincome eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=18 & age<=65, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_returns_eng_gender.tex", ar2 cells(b(star fmt(%9.3fc)) p(par([ ]))) ///
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
engedu* [aw=weight] if age>=18 & age<=65, absorb(geo) vce(cluster geo)

*graph set window fontface "Times New Roman"
coefplot, vertical keep(engedu*) yline(0) omitted baselevels ///
ytitle("Returns to English abilities by education levels", size(small) height(5)) ///
ylabel(-4(2)4, labs(small) grid) ///
xtitle("Levels of education", size(small) height(5)) xlabel(,labs(small)) ///
graphregion(color(white)) scheme(s2mono) recast(connected) ciopts(recast(rcap)) ///
ysc(r(-0.5 1)) 
graph export "$doc\eng_abil_edu.png", replace 
/* Same as above but with missings */
replace eng=0 if eng==.
coefplot, vertical keep(engedu*) yline(0) omitted baselevels ///
ytitle("Returns to English abilities by education levels", size(small) height(5)) ///
ylabel(-4(2)4, labs(small) grid) ///
xtitle("Levels of education", size(small) height(5)) xlabel(,labs(small)) ///
graphregion(color(white)) scheme(s2mono) recast(connected) ciopts(recast(rcap)) ///
ysc(r(-0.5 1)) 
graph export "$doc\eng_abil_edu_miss.png", replace 
*========================================================================*
/* Maps */
*========================================================================*
use "$base\eng_abil.dta", clear

destring state, replace
gen eng_r=eng if rural==1
gen eng_u=eng if rural==0
gen engm=eng
replace engm=0 if eng==.
gen engm_r=engm if rural==1
gen engm_u=engm if rural==0
gen nans=eng==.
gen nans_r=nans if rural==1
gen nans_u=nans if rural==0
keep if age>=18 & age<=65
collapse (mean) eng* nans* [fw=weight], by(state)

merge m:m state using "$data/Maps/MexStates/mex_map_state.dta"
drop if _merge!=3
drop _merge

format eng* nans* %12.2f
/* English ability self reported */
spmap eng using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 1)
graph export "$doc\map_eng.png", replace

spmap eng_r using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 1)
graph export "$doc\map_eng_r.png", replace

spmap eng_u using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 1)
graph export "$doc\map_eng_u.png", replace

/* English ability with missings as zeros */
spmap engm using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(9) eirange(0 0.1)
graph export "$doc\map_engm.png", replace

spmap engm_r using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(9) eirange(0 0.1)
graph export "$doc\map_engm_r.png", replace

spmap engm_u using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(9) eirange(0 0.1)
graph export "$doc\map_engm_u.png", replace

/* No-response */
spmap nans using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(6) eirange(0.8 1)
graph export "$doc\map_nans.png", replace

spmap nans_r using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(6) eirange(0.8 1)
graph export "$doc\map_nans_r.png", replace

spmap nans_u using "$base\mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(6) eirange(0.8 1)
graph export "$doc\map_nans_u.png", replace