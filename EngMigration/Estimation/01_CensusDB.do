*========================================================================*
* English program and migration
*========================================================================*
/* Oscar Galvez-Soriano, David Escamilla, and Raissa Fabregas */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Doc"
*========================================================================*
import delimited "$data/data/main/MexCensus/2020/Migrantes00.CSV", clear
keep ent mun factor id_viv id_mii mper factor msexo medad mfecemim mfecemia ///
mpaires mfecretm mfecreta mperls tamloc mlugori_c mpaides_c

replace mperls=. if mperls==99
tostring id_viv, replace format(%012.0f) force
tostring id_mii, replace format(%014.0f) force
tostring mperls, replace format(%05.0f) force
tostring mper, replace format(%05.0f) force
gen str id=(id_viv+mper)
gen str id_hh=(id_viv+mperls)
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
replace mpaides_c=. if mlugori_c==999
rename mlugori_c migrant_state
rename mpaides_c destination_c
gen dest_us=destination_c==221
gen cohort=mfecemia-medad
gen rural=tamloc==1
gen time_migra=(mfecreta-mfecemia)*12
replace time_migra=time_migra+(mfecretm-mfecemim) if time_migra==0
replace time_migra=time_migra-mfecemim+mfecretm if time_migra>=12
keep state mun factor id_viv id id_hh id_mii female rural cohort migrant time_migra mperls migrant_state destination_c dest_us
save "$base\migrant.dta", replace
*========================================================================*
keep if mperls=="."
keep state mun factor id_viv id id_mii cohort migrant female rural time_migra migrant_state destination_c dest_us
save "$base\migrantAppend.dta", replace
*========================================================================*
use "$base\migrant.dta", clear
keep if mperls!="."
keep id_hh migrant time_migra migrant_state destination_c dest_us
duplicates drop id_hh, force
rename id_hh id
save "$base\migrantMerge.dta", replace
*========================================================================*
/*use "$data/data/main/MexCensus/2020/personas00_1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 ///
25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 ///
50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 ///
75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91{
    append using "$data/data/main/MexCensus/2020/personas00_`x'.dta"
}
save "$base\personas00.dta", replace*/
use "$base\personas00.dta", clear

keep ent mun id_viv id_persona factor sexo edad asisten mun_asi ent_pais_asi escoacum ///
ent_pais_res_5a mun_res_5a conact ocupacion_c aguinaldo vacaciones servicio_medico ///
incap_sueldo sar_afore credito_vivienda ingtrmen hortra actividades_c ///
mun_trab ent_pais_trab tamloc utilidades perte_indigena hlengua qdialect_inali ///
hespanol elengua ent_pais_nac

rename id_persona id
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
gen work=conact<=30
gen formal=.
replace formal=0 if work==1 & conact!=30
replace formal=1 if (aguinaldo==1 | vacaciones==3 | servicio_medico==5 ///
| incap_sueldo==1 | sar_afore==3 | credito_vivienda==5 | utilidades==7)
drop vacaciones servicio_medico incap_sueldo sar_afore credito_vivienda utilidades
replace formal=1 if actividades_c>=9311 & actividades_c<=9399
replace formal=1 if actividades_c==2110 | actividades_c==2132
replace formal=1 if actividades_c==2211 | actividades_c==2381
replace formal=1 if actividades_c==3120 | actividades_c==3340 | actividades_c==3350 | actividades_c==3360
replace formal=1 if actividades_c==4810 | actividades_c==4820 | actividades_c==4910 | actividades_c==4920
replace formal=1 if actividades_c>=5110 & actividades_c<=5180
replace formal=1 if actividades_c>=5210 & actividades_c<=5221 | (actividades_c>=5230 & actividades_c<=5250)
replace formal=1 if actividades_c==5321 | actividades_c==5330
replace formal=1 if actividades_c>=5411 & actividades_c<=5414
replace formal=1 if actividades_c==5510
replace formal=1 if actividades_c>=6111 & actividades_c<=6150
replace formal=1 if actividades_c>=6211 & actividades_c<=6229 | (actividades_c>=6251 & actividades_c<=6252)
replace formal=1 if actividades_c==7112 | actividades_c==7120

replace formal=1 if ocupacion_c>=111 & ocupacion_c<=254
replace formal=1 if ocupacion_c>=256 & ocupacion_c<=311
replace formal=1 if ocupacion_c>=320 & ocupacion_c<=323
replace formal=1 if ocupacion_c>=420 & ocupacion_c<=421
replace formal=1 if ocupacion_c==510 | ocupacion_c==520 | ocupacion_c==530 | ocupacion_c==540 | ocupacion_c==541
replace formal=1 if ocupacion_c>=820 & ocupacion_c<=833
replace formal=1 if ocupacion_c==899

gen indigenous=perte_indigena==1
drop perte_indigena

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

recode hlengua (3=0) (9=.)
recode hespanol (3=0) (9=.)
recode elengua (5=1) (7=0) (9=.)
rename ent_pais_nac countryborn

merge 1:1 id using "$base\migrantMerge.dta", nogen

save "$base\census20.dta", replace
*========================================================================*
use "$base\census20.dta", clear

gen cohort=.
replace cohort=2020-age
keep if cohort>=1979 & cohort<=1996
label var cohort "Cohorts"

replace migrant=0 if migrant==.
append using "$base\migrantAppend.dta"
keep if cohort!=.
keep if cohort>=1979 & cohort<=1996

gen ind_act=.
replace ind_act=0 if work==0 & student==1 & migrant!=1
replace ind_act=1 if work==1 & formal==1 & migrant!=1
replace ind_act=2 if work==1 & formal==0 & migrant!=1
replace ind_act=3 if conact==30 & migrant!=1
replace ind_act=4 if work==0 & student==0 & migrant!=1
replace ind_act=5 if migrant==1

gen wpaid=wage>0 & work==1 & wage!=.

gen lwage=log(wage) if wpaid==1
gen age2=age^2
replace ind_act=2 if ind_act==. & conact<=20
replace ind_act=3 if ind_act==.

tostring migrant_state, replace format(%02.0f) force
tostring state, replace format(%02.0f) force
tostring mun, replace format(%03.0f) force
replace geo=(state+mun) if geo=="." & migrant==1
replace geo=(state+mun) if geo=="" & migrant==1
replace state5=migrant_state if state5=="" & migrant==1
drop migrant_state 

catplot ind_act cohort [fw=factor] if cohort>=1984 & cohort<=1994, percent(cohort) ///
graphregion(fcolor(white)) scheme(s2mono) ///
var1opts(label(labsize(small))) ///
var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Percentage of individuals by labor market status", size(small)) ///
asyvars stack ///
legend(rows(1) stack size(small) ///
order(1 "Student" 2 "Formal worker" ///
3 "Informal worker" 4 "Looking for a job" 5 "Inactive" 6 "Intl. migrant") ///
symplacement(center))
graph export "$doc\econ_status.png", replace

save "$base\census20.dta", replace
*========================================================================* 
use "$base\census20.dta", clear

keep if cohort>=1984 & cohort<=1994
gen str geo_mun = state5 + mun5
replace geo_mun=state+mun if geo=="."

merge m:1 geo_mun cohort using "$data/Papers/main/EngMigration/Data/exposure_mun.dta"
drop if _merge==2
drop _merge

merge m:1 state cohort using "$data/Papers/main/EngMigration/Data/exposure_state.dta"
drop if _merge!=3

rename hrs_exp2 hrs_exp 
replace hrs_exp=hrs_exp3 if hrs_exp==.
drop _merge hrs_exp3

gen imputed_state=geo=="."
drop geo
gen str geo=(state+mun)
order geo

replace student=0 if ind_act!=0
replace work=0 if ind_act==0 | ind_act==4 | migrant==1
replace work=. if conact==30
gen formal_s=ind_act==1
gen informal_s=ind_act==2
gen inactive=ind_act==4
gen labor=conact<=30

gen dmigrant=geo!=geo_mun
drop geo_mun mun_asi ent_pais_asi aguinaldo

keep if cohort>=1984 & cohort<=1994

save "$base\labor_census20.dta", replace
*========================================================================* 
/* Exposure variable check */
*========================================================================* 
use "$base\labor_census20.dta", clear

collapse hrs_exp, by(geo cohort)
rename hrs_exp hrs_exp2
save "$base\exp_mun_cohort.dta", replace
merge 1:m geo cohort using "$base\labor_census20.dta", nogen

order geo cohort hrs_exp hrs_exp2
save "$base\labor_census20.dta", replace

*========================================================================* 
/* Treatment variable */
*========================================================================* 
use "$base\labor_census20.dta", clear
keep geo hrs_exp2 state cohort
collapse hrs_exp2, by(geo cohort)
sort geo cohort
gen state=substr(geo,1,2)

sum hrs_exp2 if state=="01" & cohort>=1990 & cohort<=1996, d
gen engl=hrs_exp2>=r(p50) & state=="01"
sum hrs_exp2 if state=="10" & cohort>=1991 & cohort<=1996, d
replace engl=1 if hrs_exp2>=r(p50) & state=="10"
sum hrs_exp2 if state=="19" & cohort>=1987 & cohort<=1996, d
replace engl=1 if hrs_exp2>=r(p50) & state=="19"
sum hrs_exp2 if state=="25" & cohort>=1993 & cohort<=1996, d
replace engl=1 if hrs_exp2>=r(p50) & state=="25"
sum hrs_exp2 if state=="26" & cohort>=1993 & cohort<=1996, d
replace engl=1 if hrs_exp2>=r(p50) & state=="26"
sum hrs_exp2 if state=="28" & cohort>=1990 & cohort<=1996, d
replace engl=1 if hrs_exp2>=r(p50) & state=="28"

bysort geo: replace engl=1 if engl[_n-1]==1 & engl[_n+1]==1 & engl==0
bysort geo: replace engl=1 if engl[_n-1]==1 & engl==0 & cohort==1994
bysort geo: replace engl=0 if engl[_n-1]==0 & engl[_n+1]==0 & engl==1
bysort geo: replace engl=0 if engl[_n+1]==0 & engl==1 & cohort==1984

gen ftreat=.
bysort geo: gen ncount=_n if engl!=0
bysort geo: replace ftreat=cohort if ncount[_n-1]==. & ncount[_n+1]>ncount & ncount!=. // this identifies the first treated cohort but exclude never treated
bysort geo: egen first_treat = total(ftreat) // assigning the value of the first treated cohort to all observations within a municipality

replace engl=0 if first_treat>1994
sum hrs_exp2 if engl==1, d
replace engl=1 if hrs_exp2>=r(p75) & first_treat>1994
drop ftreat ncount first_treat

sort geo cohort

gen ftreat=.
bysort geo: gen ncount=_n if engl!=0
bysort geo: replace ftreat=cohort if ncount[_n-1]==. & ncount[_n+1]>ncount & ncount!=.
bysort geo: egen first_treat = total(ftreat)

rename first_treat first_cohort
keep geo cohort first_cohort

replace first_cohort = 1995 if first_cohort==0
gen K = cohort-first_cohort
gen D = K>=0 & first_cohort!=.

save "$base\treatment_mun.dta", replace
*=======================================================================* 
use "$base\labor_census20.dta", clear

merge m:1 geo cohort using "$data/Papers/main/EngMigration/Data/treatment_mun.dta", nogen

save "$base\labor_census20.dta", replace
*=========================================================================* 
/* Keeping only individuals likely to be treated */
*=========================================================================* 
use "$base\labor_census20.dta", clear
destring state5, replace
gen samestate=countryborn==state5

*keep if samestate==1

drop if state=="05" | state=="17"
drop lwage
gen lwage=log(wage+1)
replace wpaid=. if work==0
gen migra_ret=migrant==1 & conact!=.

drop if imputed_state==1

drop countryborn state5 mun5 conact mun_w state_w id_mii imputed_state
destring geo, replace

save "$base\labor_census20.dta", replace