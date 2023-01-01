*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/data/main/biare/2012"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\English abilities"
gl doc= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Doc"
*========================================================================*
import delimited "$data/personas.csv", clear
tostring hog_ent_1, replace
tostring folio, replace format(%09.0f) force
tostring id_pobla, replace format(%02.0f) force
gen str id_hh=(folio + hog_ent_1)
gen str id=(folio + hog_ent_1 + id_pobla)
keep id_hh id sexo edad asiste_esc nivel_inst grado_inst edo_conyug prov_princ ///
parentesco servmed1 inscrito1 tiene_trab act_buscot act_estudi scian sinco ///
folio factor

rename sexo female
recode female (1=0) (2=1)
rename edad age
rename asiste_esc student
replace student=0 if student==. & age<=3
recode student (2=0)
rename nivel_inst level
rename grado_inst grade
gen edu=.
replace edu=0 if level==0 | level==1
replace edu=grade if level==2
replace edu=6+grade if level==3
replace edu=6+grade if level==6
replace edu=9+grade if level==4
replace edu=9+grade if level==5
replace edu=9+grade if level==7
replace edu=12+grade if level==8
replace edu=12+grade if level==9
replace edu=12+grade if level==10
replace edu=16+grade if level==11
replace edu=18+grade if level==12
replace edu=0 if edu==. & age<=3
gen married=edo_conyug==1
replace married=1 if edo_conyug==6
gen segpop=servmed1==5
rename servmed1 med_affil 
rename tiene_trab work
recode work (2=0)
bysort id_hh: gen hh_size=_N
save "$base\eng_abil_2012.dta", replace

gen female_hh=female==1 if parentesco==1
gen age_hh=age if parentesco==1
gen edu_hh=edu if parentesco==1
rename work n_work
collapse (sum) n_work female_hh (mean) age_hh edu_hh, by(id_hh)
merge m:m id_hh using "$base\eng_abil_2012.dta"
drop _merge

gen w_work=n_work==1
foreach x in 2 3 4 5 6 7 8 9{
replace w_work=2/(`x'+1) if n_work==`x' & prov_princ==1
replace w_work=1/(`x'+1) if n_work==`x' & work==1 & prov_princ!=1
}
replace w_work=1 if n_work==0 & prov_princ==1

replace work=1 if act_buscot==1
replace work=0 if work==. & student==1
replace work=0 if work==. & age<=16
rename factor weight

drop level grade edo_conyug act_buscot prov_princ parentesco
order id_hh id
sort id
save "$base\eng_abil_2012.dta", replace
*========================================================================*
use "$data/gasto.dta", clear 
merge m:m id_hh using "$base\eng_abil_2012.dta"
drop _merge
rename income income_hh
gen income=income_hh*w_work
save "$base\eng_abil_2012.dta", replace
*========================================================================*
import delimited "$data/vivienda.csv", clear
tostring folio, replace format(%09.0f) force
gen rural=tam_loc==4
rename ubica_geo geo
tostring geo, replace format(%09.0f) force
keep folio rural geo
merge m:m folio using "$base\eng_abil_2012.dta"
drop _merge folio
save "$base\eng_abil_2012.dta", replace
*========================================================================*
import delimited "$data/biare2012.csv", clear
tostring hog_ent_1, replace
tostring folio, replace format(%09.0f) force
tostring id_pobla, replace format(%02.0f) force
gen str id=(folio + hog_ent_1 + id_pobla)
keep id lengua_2
rename lengua_2 eng
recode eng (2=0)
merge 1:1 id using "$base\eng_abil_2012.dta"
drop _merge
order geo id_hh id female age edu student work

gen formal=1 if work==1
replace formal=0 if med_affil==5 & work==1
replace formal=0 if med_affil==8 & work==1

drop n_work med_affil inscrito1 act_estudi w_work segpop
gen year=2012
gen state=substr(geo,1,2)
gen cohort=2012-age
*replace eng=1 if cohort>=1987 & rural==0 & state=="19" & income_hh>20000
save "$base\eng_abil_2012.dta", replace
*========================================================================*
/* English abilities in Nuevo Leon */
*========================================================================*
use "$base\eng_abil_2012.dta", clear
keep if state=="19" | state=="08"
gen treat=state=="19"
gen after=cohort>=1987
replace after=. if cohort>1996 | cohort<1977
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
use "$base\eng_abil_2012.dta", clear
gen expe=age-5-edu
replace expe=0 if age<16
replace expe=0 if expe<0
gen expe2=expe^2
replace income=income+1
gen lincome=log(income)
gen eng_2=eng==1

/* Descriptive statistics */
* Individual characteristics
sum eng edu expe age female married income student work if eng!=. & age>=16 & age<=65 
* Household characteristics
sum rural female_hh age_hh edu_hh hh_size if eng!=. & age>=16 & age<=65 
