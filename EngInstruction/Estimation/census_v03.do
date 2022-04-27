*========================================================================*
* English program and earnings
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Census"
gl data2= "https://raw.githubusercontent.com/galvez-soriano/data/main/MexCensus/2020"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New"
gl doc= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Doc"
*========================================================================*
import delimited "$data2/Migrantes00.CSV", clear
keep ent mun factor id_viv msexo medad mfecemia mperls tamloc mlugori_c

replace mperls=. if mperls==99
tostring id_viv, replace format(%012.0f) force
tostring mperls, replace format(%05.0f) force
gen str id_persona=(id_viv+mperls)
gen migrant=1
replace mfecemia=. if mfecemia==9999
replace medad=. if medad==999
replace mlugori_c=. if mlugori_c==999
gen cohort=mfecemia-medad
keep if cohort>=1997 & cohort<=2002
rename ent state
rename msexo female
recode female (1=0) (3=1)
gen rural=tamloc==1
keep state mun factor id_viv id_persona female rural cohort migrant mperls mlugori_c
save "$data\migrant.dta", replace
*========================================================================*
keep if mperls=="."
keep state mun factor id_viv cohort migrant female rural mlugori_c
save "$data\migrant2.dta", replace
*========================================================================*
use "$data\personas00.dta", clear

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
gen work=0
replace work=1 if conact<=30
gen formal=0 if work==1 & conact!=30
replace formal=1 if (vacaciones==3 | servicio_medico==5 | incap_sueldo==1 | ///
 sar_afore==3 | credito_vivienda==5 | utilidades==7)
drop vacaciones servicio_medico incap_sueldo sar_afore credito_vivienda utilidades
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
gen str geo_mun_s=(state5+mun5)
replace geo_mun_s="." if mun5=="."

merge m:m id_persona using "$data\migrant.dta"
drop if _merge==2
drop _merge mperls cohort mlugori_c

save "$data\census20.dta", replace
*========================================================================*
use "$data\census20.dta", clear

gen cohort=.
replace cohort=1997 if age==23
replace cohort=1998 if age==22
replace cohort=1999 if age==21
replace cohort=2000 if age==20
replace cohort=2001 if age==19
replace cohort=2002 if age==18
label var cohort "Age cohorts"

gen ind_act=.
replace ind_act=0 if work==0 & student==1
replace ind_act=1 if work==1 & formal==1
replace ind_act=2 if work==1 & formal==0
replace ind_act=3 if work==0 & student==0

keep if cohort!=.
replace wage=1 if wage==0
gen lwage=log(wage)
gen age2=age^2
replace ind_act=2 if ind_act==. & conact<=30
replace ind_act=3 if ind_act==.

replace migrant=0 if migrant==.
append using "$data\migrant2.dta"

tostring mlugori_c, replace format(%02.0f) force
tostring state, replace format(%02.0f) force
tostring mun, replace format(%03.0f) force
replace geo_mun_s=(state+mun) if geo_mun_s=="." & migrant==1
replace geo_mun_s=(state+mun) if geo_mun_s=="" & migrant==1
replace state5=mlugori_c if state5=="" & migrant==1
drop mlugori_c

catplot ind_act cohort [fw=factor], percent(age) ///
graphregion(fcolor(white)) scheme(s2mono) ///
var1opts(label(labsize(small))) ///
var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Percentage of individuals by labor market status", size(small)) ///
asyvars stack ///
legend(rows(1) stack size(small) ///
order(1 "Student" 2 "Formal worker" ///
3 "Informal worker" 4 "Inactive") ///
symplacement(center))
*graph export "$doc\labor_census20.png", replace

save "$data\census20.dta", replace
*========================================================================*
/*use "$data\census20.dta", clear

drop geo
tostring state, replace format(%02.0f) force
tostring mun, replace format(%03.0f) force
gen str geo=(state+mun)

replace student=0 if ind_act!=3
replace work=0 if ind_act==0 | ind_act==3
gen tot_pop=1

gen formal_p=1 if formal==1
replace formal_p=0 if formal_p==. & formal==0

collapse (sum) student work tot_pop (mean) formal_p [fw=factor], by(geo)
*collapse (sum) student work tot_pop [fw=factor], by(geo)	

gen p_stud=student/tot_pop
keep if p_stud<=.2

drop if geo=="19041"
graph hbar formal_p if p_stud>0.09 & p_stud<=0.1  & formal_p>=0.1, over(geo) ///
graphregion(fcolor(white)) scheme(s2mono) ///
ytitle("Proportion of individuals in formal sector")
graph export "$doc\p_enroll_formal_bin8.png", replace

graph hbar tot_pop if p_stud>0.09 & p_stud<=0.1 & formal_p>=0.1, over(geo) ///
graphregion(fcolor(white)) scheme(s2mono) ///
ytitle("Number of inhabitants")
graph export "$doc\p_enroll_inhab_bin8.png", replace

keep geo p_stud
save "$base\p_stud.dta", replace*/
*========================================================================*
use "$data\census20.dta", clear

merge m:m geo cohort using "$base\exposure_mun.dta"
drop if _merge!=3
drop _merge

drop geo
tostring state, replace format(%02.0f) force
tostring mun, replace format(%03.0f) force
gen str geo=(state+mun)

merge m:m geo using "$base\p_stud.dta"
drop _merge

label define ind_act 0 "Student" 1 "Formal worker" ///
2 "Informal worker" 3 "Inactive"
label values ind_act ind_act

replace student=0 if ind_act!=0
replace work=0 if ind_act==0 | ind_act==3
gen formal_s=ind_act==1
gen informal_s=ind_act==2
gen inactive=ind_act==3

gen labor=0
replace labor=1 if ind_act==1 | ind_act==2

/* Droping Pesqueria County, Mty because there is an unusual proportion of
individuals working in formal sector, probably because of the KIA automotive
company recently established there */
drop if geo=="19041"
/* County Pueblo Nuevo Solistahuacán, Chiapas has a private university offering 
education from primary to graduate degrees 07062*/
*drop if geo=="07062"

gen p_enrol=.
replace p_enrol=0 if p_stud<=0.05
replace p_enrol=1 if p_stud>0.05 & p_stud<=0.06
replace p_enrol=2 if p_stud>0.06 & p_stud<=0.07
replace p_enrol=3 if p_stud>0.07 & p_stud<=0.08
replace p_enrol=4 if p_stud>0.08 & p_stud<=0.09
replace p_enrol=5 if p_stud>0.09 & p_stud<=0.10
replace p_enrol=6 if p_stud>0.10 & p_stud<=0.11
replace p_enrol=7 if p_stud>0.11 & p_stud<=0.12
replace p_enrol=8 if p_stud>0.12 & p_stud<=0.13
replace p_enrol=9 if p_stud>0.13 & p_stud<=0.14
replace p_enrol=10 if p_stud>0.14 & p_stud<=0.15

label define enrol 0 "p<=0.05" 1 "0.05<p<=0.06" 2 "0.06<p<=0.07" 3 "0.07<p<=0.08" ///
4 "0.08<p<=0.09" 5 "0.09<p<=0.10" 6 "0.10<p<=0.11" 7 "0.11<p<=0.12" 8 ///
"0.12<p<=0.13" 9 "0.13<p<=0.14" 10 "0.14<p<=0.15" 
label values p_enrol enrol

graph hbar (sum) factor, over(p_enrol) ///
graphregion(fcolor(white)) scheme(s2mono) ///
ytitle("Number of inhabitants")
graph export "$doc\p_enroll_inhab.png", replace

graph hbar (mean) formal [fw=factor], over(p_enrol) ///
graphregion(fcolor(white)) scheme(s2mono) ///
ytitle("Proportion of workers in formal sector")
graph export "$doc\p_enroll_formal.png", replace

catplot ind_act cohort [fw=factor] if p_stud<=0.09, percent(cohort) ///
graphregion(fcolor(white)) scheme(s2mono) ///
var1opts(label(labsize(small))) ///
var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Percent of individuals by occupation", size(small)) ///
asyvars stack ///
legend(rows(1) stack size(small) ///
order(1 "Student" 2 "Formal worker" ///
3 "Informal worker" 4 "Inactive") ///
symplacement(center))
graph export "$doc\labor_census20_low.png", replace
save "$base\labor_census20.dta", replace
*========================================================================*
use "$base\labor_census20.dta", clear
replace lwage=0 if lwage==.
*destring state, replace
*mlogit ind_act hrs_exp rural female age i.cohort i.state [aw=factor], base(0) rrr
*destring geo, replace
*mlogit ind_act hrs_exp rural female age i.cohort i.geo [aw=factor], base(0) rrr
/*
eststo clear
eststo: areg student hrs_exp rural female age i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural female age i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_exp rural female age i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_exp rural female age i.cohort [aw=factor], absorb(geo) vce(cluster geo)
esttab using "$doc\tab0_census.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
*/
eststo clear
eststo: areg edu hrs_exp rural female age i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg student hrs_exp rural female age i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural female age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_exp rural female age i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_exp rural female age i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor] if formal==1, absorb(geo) vce(cluster geo)
eststo: areg labor hrs_exp rural female age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
esttab using "$doc\tab1_census.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace

eststo clear
eststo: areg edu hrs_exp rural female age i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg student hrs_exp rural female age i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural female age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_exp rural female age i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_exp rural female age i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor] if formal==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg labor hrs_exp rural female age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_census.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace

eststo clear
eststo: areg edu hrs_exp rural female age i.cohort [aw=factor] if p_stud<=0.09 & female==0, absorb(geo) vce(cluster geo)
eststo: areg student hrs_exp rural female age i.cohort [aw=factor] if p_stud<=0.09 & female==0, absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural female age age2 i.cohort [aw=factor] if p_stud<=0.09 & female==0, absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_exp rural female age i.cohort [aw=factor] if p_stud<=0.09 & female==0, absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_exp rural female age i.cohort [aw=factor] if p_stud<=0.09 & female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor] if formal==1 & p_stud<=0.09 & female==0, absorb(geo) vce(cluster geo)
eststo: areg labor hrs_exp rural female age age2 i.cohort [aw=factor] if p_stud<=0.09 & female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09 & female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_census_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace

eststo clear
eststo: areg edu hrs_exp rural female age i.cohort [aw=factor] if p_stud<=0.09 & female==1, absorb(geo) vce(cluster geo)
eststo: areg student hrs_exp rural female age i.cohort [aw=factor] if p_stud<=0.09 & female==1, absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural female age age2 i.cohort [aw=factor] if p_stud<=0.09 & female==1, absorb(geo) vce(cluster geo)
eststo: areg informal_s hrs_exp rural female age i.cohort [aw=factor] if p_stud<=0.09 & female==1, absorb(geo) vce(cluster geo)
eststo: areg inactive hrs_exp rural female age i.cohort [aw=factor] if p_stud<=0.09 & female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor] if formal==1 & p_stud<=0.09 & female==1, absorb(geo) vce(cluster geo)
eststo: areg labor hrs_exp rural female age age2 i.cohort [aw=factor] if p_stud<=0.09 & female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09 & female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_census_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace

label var hrs_exp "Proportion of individuals enrolled in school"

eststo clear
foreach x in 05 06 07 08 09 10 11 12 13 14 15{
areg labor hrs_exp rural female age i.cohort [aw=factor] if p_stud<=0.`x', absorb(geo) vce(cluster geo)
estimates store labor`x'
}
coefplot (labor05, label(p<=0.05)) (labor06, label(p<=0.06)) (labor07, label(p<=0.07)) ///
(labor08, label(p<=0.08)) (labor09, mcolor(red) ciopts(recast(rcap)color(red)) ///
label(p<=0.09)) (labor10, label(p<=0.10)) (labor11, label(p<=0.11)) (labor12, ///
label(p<=0.12)) (labor13, label(p<=0.13)) ///
(labor14, label(p<=0.14)) (labor15, label(p<=0.15)), ///
vertical keep(hrs_exp) yline(0) ///
ytitle("Probability of participate in the labor market", size(medium) height(5)) ///
legend( pos(1) ring(0) col(2)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\labor_c20_low.png", replace

eststo clear
foreach x in 05 06 07 08 09 10 11 12 13 14 15{
areg formal_s hrs_exp rural female age i.cohort [aw=factor] if p_stud<=0.`x', absorb(geo) vce(cluster geo)
estimates store formal`x'
}
coefplot (formal05, label(p<=0.05)) (formal06, label(p<=0.06)) (formal07, label(p<=0.07)) ///
(formal08, label(p<=0.08)) (formal09, mcolor(red) ciopts(recast(rcap)color(red)) ///
label(p<=0.09)) (formal10, label(p<=0.10)) (formal11, label(p<=0.11)) (formal12, ///
label(p<=0.12)) (formal13, label(p<=0.13)) ///
(formal14, label(p<=0.14)) (formal15, label(p<=0.15)), ///
vertical keep(hrs_exp) yline(0) ///
ytitle("Probability of working in formal sector", size(medium) height(5)) ///
legend( pos(1) ring(0) col(2)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\formal_c20_low.png", replace

eststo clear
foreach x in 05 06 07 08 09 10 11 12 13 14 15{
areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.`x', absorb(geo) vce(cluster geo)
estimates store wage`x'
}
coefplot (wage05, label(p<=0.05)) (wage06, label(p<=0.06)) (wage07, label(p<=0.07)) ///
(wage08, label(p<=0.08)) (wage09, mcolor(red) ciopts(recast(rcap) color(red)) ///
label(p<=0.09)) (wage10, label(p<=0.10)) (wage11, label(p<=0.11)) (wage12, ///
label(p<=0.12)) (wage13, label(p<=0.13)) ///
(wage14, label(p<=0.14)) (wage15, label(p<=0.15)), ///
vertical keep(hrs_exp) yline(0) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
legend( pos(1) ring(0) col(2)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\wages_c20_low.png", replace
*========================================================================*
/* Low achievement */
*========================================================================*
use "$base\labor_census20.dta", clear

catplot ind_act cohort [fw=factor] if edu<=6, percent(cohort) ///
graphregion(fcolor(white)) scheme(s2mono) ///
var1opts(label(labsize(small))) ///
var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Percent of individuals by occupation", size(small)) ///
asyvars stack ///
legend(rows(1) stack size(small) ///
order(1 "Student" 2 "Formal worker" ///
3 "Informal worker" 4 "Inactive") ///
symplacement(center))

eststo clear
eststo: areg student hrs_exp rural female age i.cohort [aw=factor] if edu!=., absorb(geo) vce(cluster geo)
eststo: areg edu hrs_exp rural female age i.cohort [aw=factor] if student!=., absorb(geo) vce(cluster geo)
eststo: areg labor hrs_exp rural female age age2 i.cohort [aw=factor] if edu!=. & student!=., absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural female age age2 i.cohort [aw=factor] if edu!=. & student!=., absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor] if formal==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab1_census.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace

eststo clear
eststo: areg student hrs_exp rural female age i.cohort [aw=factor] if edu<=6 & edu!=., absorb(geo) vce(cluster geo)
eststo: areg edu hrs_exp rural female age i.cohort [aw=factor] if edu<=6 & edu!=. & student!=., absorb(geo) vce(cluster geo)
eststo: areg labor hrs_exp rural female age age2 i.cohort [aw=factor] if edu<=6 & edu!=. & student!=., absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural female age age2 i.cohort [aw=factor] if edu<=6 & edu!=. & student!=., absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor] if edu<=6, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor] if edu<=6 & formal==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_census.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace

eststo clear
eststo: areg student hrs_exp rural female age i.cohort [aw=factor] if edu<=6 & female==0 & edu!=., absorb(geo) vce(cluster geo)
eststo: areg edu hrs_exp rural female age i.cohort [aw=factor] if edu<=6 & female==0 & edu!=. & student!=., absorb(geo) vce(cluster geo)
eststo: areg labor hrs_exp rural female age age2 i.cohort [aw=factor] if edu<=6 & female==0 & edu!=. & student!=., absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural female age age2 i.cohort [aw=factor] if edu<=6 & female==0 & edu!=. & student!=., absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor] if edu<=6 & female==0, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor] if edu<=6 & female==0 & formal==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_census_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace

eststo clear
eststo: areg student hrs_exp rural female age i.cohort [aw=factor] if edu<=6 & female==1 & edu!=., absorb(geo) vce(cluster geo)
eststo: areg edu hrs_exp rural female age i.cohort [aw=factor] if edu<=6 & female==1 & edu!=. & student!=., absorb(geo) vce(cluster geo)
eststo: areg labor hrs_exp rural female age age2 i.cohort [aw=factor] if edu<=6 & female==1 & edu!=. & student!=., absorb(geo) vce(cluster geo)
eststo: areg formal_s hrs_exp rural female age age2 i.cohort [aw=factor] if edu<=6 & female==1 & edu!=. & student!=., absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor] if edu<=6 & female==1, absorb(geo) vce(cluster geo)
eststo: areg lwage hrs_exp rural female edu age age2 i.cohort [aw=factor] if edu<=6 & female==1 & formal==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab2_census_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
*========================================================================*
/* Jobs classifications */
*========================================================================*
use "$data\census20.dta", clear

merge m:m geo cohort using "$base\exposure_mun.dta"
drop if _merge!=3
drop _merge
replace actividades_c=. if actividades_c==9999

merge m:m geo using "$base\p_stud.dta"
drop _merge

drop if geo=="19041"

gen econ_act=.
replace econ_act=1 if actividades_c<=1199
replace econ_act=2 if (actividades_c>1199 & actividades_c<=2399) | ///
(actividades_c>4699 & actividades_c<=4930)
replace econ_act=3 if actividades_c>2399 & actividades_c<=3399
replace econ_act=4 if actividades_c>3399 & actividades_c<=4699
replace econ_act=5 if (actividades_c>5399 & actividades_c<=5622) | ///
(actividades_c>7223 & actividades_c<=8140) | (actividades_c>5199 & actividades_c<=5399)
replace econ_act=6 if (actividades_c>5622 & actividades_c<=6299) | ///
(actividades_c>8140 & actividades_c!=.)
replace econ_act=7 if (actividades_c>6299 & actividades_c<=7223) | ///
(actividades_c>4930 & actividades_c<=5199)

label define econ_act 1 "Agriculture" 2 "Construction" 3 "Manufactures" 4 "Commerce" ///
5 "Professionals" 6 "Government" 7 "Hospitality and Entertainment"
label values econ_act econ_act

gen ag_ea=1 if econ_act==1
replace ag_ea=0 if econ_act!=1 & econ_act!=.
gen cons_ea=1 if econ_act==2
replace cons_ea=0 if econ_act!=2 & econ_act!=.
gen manu_ea=1 if econ_act==3
replace manu_ea=0 if econ_act!=3 & econ_act!=.
gen comm_ea=1 if econ_act==4
replace comm_ea=0 if econ_act!=4 & econ_act!=.
gen pro_ea=1 if econ_act==5
replace pro_ea=0 if econ_act!=5 & econ_act!=.
gen gov_ea=1 if econ_act==6
replace gov_ea=0 if econ_act!=6 & econ_act!=.
gen hosp_ea=1 if econ_act==7
replace hosp_ea=0 if econ_act!=7 & econ_act!=.

gen occup=.
replace occup=1 if ocupacion_c>=610 & ocupacion_c<=699
replace occup=2 if ocupacion_c>=411 & ocupacion_c<=499
replace occup=3 if ocupacion_c>=510 & ocupacion_c<=541
replace occup=4 if ocupacion_c>=710 & ocupacion_c<=799
replace occup=5 if ocupacion_c>=911 & ocupacion_c<=989
replace occup=6 if ocupacion_c>=810 & ocupacion_c<=899
replace occup=7 if ocupacion_c>=111 & ocupacion_c<=399

label define occup 1 "Agriculture" 2 "Commerce" ///
3 "Services" 4 "Crafts" 5 "Manual work" ///
6 "Skilled job" 7 "Professional" 
label values occup occup

gen ag_o=1 if occup==1
replace ag_o=0 if occup!=1 & occup!=.
gen com_o=1 if occup==2
replace com_o=0 if occup!=2 & occup!=.
gen ser_o=1 if occup==3
replace ser_o=0 if occup!=3 & occup!=.
gen cft_o=1 if occup==4
replace cft_o=0 if occup!=4 & occup!=.
gen man_o=1 if occup==5
replace man_o=0 if occup!=5 & occup!=.
gen skil_o=1 if occup==6
replace skil_o=0 if occup!=6 & occup!=.
gen prof_o=1 if occup==7
replace prof_o=0 if occup!=7 & occup!=.
*======== Economic activities ========*
/* Full sample */
eststo clear
eststo: areg ag_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Low enrollment sample */
eststo clear
eststo: areg ag_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if p_stud<=0.09, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_low.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Men */
eststo clear
eststo: areg ag_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Women */
eststo clear
eststo: areg ag_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg cons_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg manu_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg comm_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg pro_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg gov_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg hosp_ea hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_ea_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
*============ Occupations ============*
/* Full sample */
eststo clear
eststo: areg ag_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg man_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg skil_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural female edu age age2 i.cohort [aw=factor], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Low enrollment sample */
eststo clear
eststo: areg ag_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg man_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg skil_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural female edu age age2 i.cohort if p_stud<=0.09 [aw=factor], absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup_low.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Men */
eststo clear
eststo: areg ag_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg man_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg skil_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==0 & p_stud<=0.09, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
/* Women */
eststo clear
eststo: areg ag_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg com_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg ser_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg cft_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg man_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg skil_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
eststo: areg prof_o hrs_exp rural female edu age age2 i.cohort [aw=factor] if female==1 & p_stud<=0.09, absorb(geo) vce(cluster geo)
esttab using "$doc\tab_occup_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Census estimations) keep(hrs_exp) replace
*========================================================================*
/* Table occupations and Multinomial Logit */
*========================================================================*
tab occup [fw=factor]
table occup [fw=factor], c(mean edu mean wage mean formal)

*set mat 11000
destring state, replace
eststo clear
* All
eststo: mlogit occup hrs_exp rural female age formal i.cohort i.state [aw=factor], vce(cluster geo) base(5) rrr
* Men
eststo: mlogit occup hrs_exp rural female age formal i.cohort i.state if female==0 [aw=factor], vce(cluster geo) base(5) rrr
* Female
eststo: mlogit occup hrs_exp rural female age formal i.cohort i.state if female==1 [aw=factor], vce(cluster geo) base(5) rrr
* Formal
eststo: mlogit occup hrs_exp rural female age formal i.cohort i.state if formal==1 [aw=factor], vce(cluster geo) base(5) rrr
* Informal
eststo: mlogit occup hrs_exp rural female age formal i.cohort i.state if formal==0 [aw=factor], vce(cluster geo) base(5) rrr
esttab using "$doc\tab_occup_multi_logit.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(Census estimations) ///
keep(hrs_exp) replace

/*quietly mlogit occup hrs_exp rural female age i.cohort i.geo [aw=factor], vce(cluster geo) base(5) rrr
estimates table, keep(hrs_exp)*/
