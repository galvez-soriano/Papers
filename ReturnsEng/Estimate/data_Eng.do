*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
/* Oscar Galvez-Soriano
In this do file I work with BIARE survey to create the final database I 
use in this paper */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/data/main"
gl data2= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/ReturnsEng/Data"
gl base= "C:\Users\ogalvez\Documents\BIARE"
gl doc= "C:\Users\ogalvez\Documents\BIARE\Doc"
*========================================================================*
use "$data/biare/2014/poblacion1.dta", clear
foreach x in 2 3{
    append using "$data/biare/2014/poblacion`x'.dta"
}
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
import delimited "$data/biare/2014/ingresos.csv", clear 
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
import delimited "$data/biare/2014/trabajos.csv", clear
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
import delimited "$data/biare/2014/concentradohogar.csv", clear
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
import delimited "$data/biare/2014/biare.csv", clear
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
replace eng=0 if eng==.
gen edu2=edu^2
gen lwage=log(income)
replace lwage=0 if lwage==.
drop if state!=state5 & state5<="32"
gen inc_hh= income_hh-income
replace inc_hh=inc_hh+1
replace inc_hh=log(inc_hh)
replace work=0 if work==.

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
use "$data2/exposure_loc1.dta", clear
append using "$data2/exposure_loc2.dta"
sort geo cohort

merge m:m geo cohort using "$base\eng_abil.dta"
drop if _merge==1
rename _merge merge2

gen geo_mun=substr(geo,1,5)

merge m:m geo_mun cohort using "$data2/exposure_mun.dta"
replace hrs_exp=hrs_exp2 if merge2==2 & hrs_exp==.
drop if _merge==2

rename _merge merge3
merge m:m state cohort using "$data2/exposure_state.dta"
replace hrs_exp=hrs_exp3 if merge2==2 & hrs_exp==.
drop if _merge==2
drop _merge merge2 merge3 hrs_exp2 hrs_exp3
replace hrs_exp=0 if cohort<=1980

save "$base\eng_abil.dta", replace
