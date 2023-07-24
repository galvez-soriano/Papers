*========================================================================*
* English program and earnings
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\galve\Documents\Papers\Current\EngMigration\Base"
gl doc= "C:\Users\galve\Documents\Papers\Current\EngMigration\Doc"
*========================================================================*
import delimited "$data/data/main/MexCensus/2020/Migrantes00.CSV", clear
keep ent mun factor id_viv id_mii mper factor msexo medad mfecemim mfecemia ///
mpaires mfecretm mfecreta mperls tamloc mlugori_c 

replace mperls=. if mperls==99
tostring id_viv, replace format(%012.0f) force
tostring id_mii, replace format(%014.0f) force
tostring mperls, replace format(%05.0f) force
tostring mper, replace format(%05.0f) force
gen str id_persona=(id_viv+mper)
gen str id_persona_hh=(id_viv+mperls)
gen migrant=1
rename ent state
rename msexo female
recode female (1=0) (3=1)
replace medad=. if medad==999
replace mfecemim=. if mfecemim==99
replace mfecemia=. if mfecemia==9999
replace mfecretm=. if mfecretm==99
replace mfecreta=. if mfecreta==9999
replace mlugori_c=. if mlugori_c==999
gen cohort=mfecemia-medad
gen rural=tamloc==1
gen time_migra=(mfecreta-mfecemia)*12
replace time_migra=time_migra+(mfecretm-mfecemim) if time_migra==0
replace time_migra=time_migra-mfecemim+mfecretm if time_migra>=12
keep state mun factor id_viv id_persona id_persona_hh id_mii female rural cohort migrant time_migra mperls mlugori_c
save "$base\migrant.dta", replace
*========================================================================*
keep if mperls=="."
*keep if cohort>=1997 & cohort<=2002
keep state mun factor id_viv id_persona id_mii cohort migrant female rural time_migra mlugori_c
save "$base\migrantAppend.dta", replace
*========================================================================*
use "$base\migrant.dta", clear
keep if mperls!="."
keep id_persona_hh migrant time_migra mlugori_c
duplicates drop id_persona_hh, force
rename id_persona_hh id_persona
save "$base\migrantMerge.dta", replace
*========================================================================*
/*use "$data/personas00_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 ///
50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 ///
75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91{
    append using "$data/personas00_`x'.dta"
}
save "$base\personas00.dta", replace */
use "$base\personas00.dta", clear

keep ent mun id_viv id_persona factor sexo edad asisten mun_asi ent_pais_asi escoacum ///
ent_pais_res_5a mun_res_5a conact ocupacion_c vacaciones servicio_medico ///
incap_sueldo sar_afore credito_vivienda ingtrmen hortra actividades_c ///
mun_trab ent_pais_trab tamloc utilidades

tostring id_viv, replace format(%012.0f) force
rename ent state
rename sexo female
recode female (1=0) (3=1)
rename edad age
rename asisten student
recode student (3=0) (9=.)
replace student=1 if conact==50
rename escoacum edu
replace edu=. if edu==99
rename ent_pais_res_5a state5
rename mun_res_5a mun5
gen work=conact<=19
gen formal=.
replace formal=0 if work==1
replace formal=1 if (vacaciones==3 | servicio_medico==5 | incap_sueldo==1 | ///
 sar_afore==3 | credito_vivienda==5 | utilidades==7)
drop vacaciones servicio_medico incap_sueldo sar_afore credito_vivienda utilidades
replace formal=1 if actividades_c>=9311 & actividades_c<=9399
replace formal=1 if actividades_c==2110 | actividades_c==2132
replace formal=1 if actividades_c==2211
replace formal=1 if actividades_c==4810 | actividades_c==4910 | actividades_c==4920
replace formal=1 if actividades_c==5210

rename ingtrmen wage
replace wage=. if wage==999999
rename hortra hrs_w
replace hrs_w=. if hrs_w==999
rename mun_trab mun_w 
rename ent_pais_trab state_w
gen rural=tamloc==1
replace state5=. if state5>32
tostring state5, replace format(%02.0f) force
tostring mun5, replace format(%03.0f) force
gen str geo=(state5+mun5)
replace geo="." if mun5=="."

merge 1:1 id_persona using "$base\migrantMerge.dta", nogen

save "$base\census20.dta", replace
*========================================================================*
use "$base\census20.dta", clear

gen cohort=.
replace cohort=1997 if age==23
replace cohort=1998 if age==22
replace cohort=1999 if age==21
replace cohort=2000 if age==20
replace cohort=2001 if age==19
replace cohort=2002 if age==18
label var cohort "Cohorts"

replace migrant=0 if migrant==.
append using "$base\migrantAppend.dta"

gen ind_act=.
replace ind_act=0 if work==0 & student==1 & migrant!=1
replace ind_act=1 if work==1 & formal==1 & migrant!=1
replace ind_act=2 if work==1 & formal==0 & migrant!=1
replace ind_act=3 if work==0 & student==0 & migrant!=1
replace ind_act=4 if migrant==1

keep if cohort!=.
drop if cohort<1997 | cohort>2002
replace wage=1 if wage==0
gen lwage=log(wage)
gen age2=age^2
replace ind_act=2 if ind_act==. & conact<=19
replace ind_act=3 if ind_act==.

tostring mlugori_c, replace format(%02.0f) force
tostring state, replace format(%02.0f) force
tostring mun, replace format(%03.0f) force
replace geo=(state+mun) if geo=="." & migrant==1
replace geo=(state+mun) if geo=="" & migrant==1
replace state5=mlugori_c if state5=="" & migrant==1
drop mlugori_c 

/*
use "$data/Papers/main/EngMigration/Data/census20_1.dta", clear
foreach x in 2 3 4 5 6 7 {
    append using "$data/Papers/main/EngMigration/Data/census20_`x'.dta"
}
save "$base\census20.dta", replace 
*/

catplot ind_act cohort [fw=factor], percent(cohort) ///
graphregion(fcolor(white)) scheme(s2mono) ///
var1opts(label(labsize(small))) ///
var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Percentage of individuals by labor market status", size(small)) ///
asyvars stack ///
legend(rows(1) stack size(small) ///
order(1 "Student" 2 "Formal worker" ///
3 "Informal worker" 4 "Inactive" 5 "Migrant") ///
symplacement(center))
*graph export "$doc\labor_census20.png", replace
save "$base\census20.dta", replace
*========================================================================* 
use "$base\census20.dta", clear

merge 1:m geo cohort using "$data/Papers/main/EngInstruction/Data/exposure_mun.dta"
drop if _merge==2
drop if geo=="."
drop _merge
merge 1:m state cohort using "$data/Papers/main/EngInstruction/Data/exposure_state.dta"
drop if _merge!=3

replace hrs_exp=hrs_exp2 if hrs_exp==. & state==state5
drop _merge hrs_exp2
drop if hrs_exp==.

drop geo
tostring state, replace format(%02.0f) force
tostring mun, replace format(%03.0f) force
gen str geo=(state+mun)

merge 1:m geo using "$data/Papers/main/EngInstruction/Data/p_stud_census2020.dta"
drop if _merge==2
drop _merge

label define ind_act 0 "Student" 1 "Formal worker" ///
2 "Informal worker" 3 "Inactive" 4 "Migrant"
label values ind_act ind_act

replace student=0 if ind_act!=0
replace work=0 if ind_act==0 | ind_act==3 | migrant==1
gen formal_s=ind_act==1
gen informal_s=ind_act==2
gen inactive=ind_act==3
gen labor=conact<=30
save "$base\labor_census20.dta", replace
