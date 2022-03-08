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
/* Returns to English skills */
*========================================================================*
use "$base\eng_abil.dta", clear
gen expe=age-5-edu
replace expe=0 if age<16
replace expe=0 if expe<0
gen expe2=expe^2
replace income=income+1
gen lincome=log(income)
gen eng_2=eng==1
destring state, replace
gen age_state=age*state

/* Full sample */
eststo clear
eststo: reg lincome eng edu expe expe2 [aw=weight] if age>=16 ///
& age<=65, vce(cluster geo)
eststo: reg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=16 & age<=65, vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=16 & age<=65, absorb(state) vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=16 & age<=65, absorb(geo) vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=16 & age<=65, absorb(age_state) vce(cluster geo)
esttab using "$doc\tab_returns_eng.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to Eng) keep(eng) replace

/* Men */
eststo clear
eststo: reg lincome eng edu expe expe2 [aw=weight] if (age>=16 ///
& age<=65) & female==0, vce(cluster geo)
eststo: reg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=16 & age<=65) & female==0, vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=16 & age<=65) & female==0, absorb(state) vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=16 & age<=65) & female==0, absorb(geo) vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=16 & age<=65) & female==0, absorb(age_state) vce(cluster geo)
esttab using "$doc\tab_returns_eng_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to Eng (Men)) keep(eng) replace

/* Women */
eststo clear
eststo: reg lincome eng edu expe expe2 [aw=weight] if (age>=16 ///
& age<=65) & female==1, vce(cluster geo)
eststo: reg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=16 & age<=65) & female==1, vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=16 & age<=65) & female==1, absorb(state) vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=16 & age<=65) & female==1, absorb(geo) vce(cluster geo)
eststo: areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if (age>=16 & age<=65) & female==1, absorb(age_state) vce(cluster geo)
esttab using "$doc\tab_returns_eng_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to Eng (Women)) keep(eng) replace

/* Gender */
gen eng_female=eng*female
eststo clear
eststo: reg lincome eng_female eng edu expe expe2 female [aw=weight] if age>=16 ///
& age<=65, vce(cluster geo)
eststo: reg lincome eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=16 & age<=65, vce(cluster geo)
eststo: areg lincome eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=16 & age<=65, absorb(state) vce(cluster geo)
eststo: areg lincome eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=16 & age<=65, absorb(geo) vce(cluster geo)
eststo: areg lincome eng_female eng edu expe expe2 female rural female_hh age_hh edu_hh ///
married [aw=weight] if age>=16 & age<=65, absorb(age_state) vce(cluster geo)
esttab using "$doc\tab_returns_eng_gender.tex", ar2 cells(b(star fmt(%9.3f)) p()) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to Eng) keep(eng_female) replace

/* Education */
gen eng_edu=eng*edu
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24{
gen engedu`x'=eng_edu==`x'
label var engedu`x' "`x'"
}

areg lincome eng edu expe expe2 female rural female_hh age_hh edu_hh married ///
engedu* [aw=weight] if age>=16 & age<=65, absorb(geo) vce(cluster geo)

graph set window fontface "Times New Roman"
coefplot, vertical keep(engedu*) yline(0) ///
ytitle("Returns to English abilities by education", size(small) height(5)) ///
ylabel(-5(2.5)5, labs(small) grid) ///
xtitle("Years of education", size(small) height(5)) xlabel(,labs(small)) ///
graphregion(color(white)) scheme(s2mono) recast(connected) ciopts(recast(rcap)) ///
ysc(r(-0.5 1)) 
graph export "$doc\eng_abil_edu.png", replace 
