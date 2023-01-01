*========================================================================*
* English program and earnings
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Ideas\Education\SM English\Data\Original"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New"
gl doc= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Doc"
*========================================================================*
* ENOE 2019
*========================================================================*
use "$data\coe2t119.dta", clear
rename *, lower
tostring cd_a ent v_sel n_ren, replace format(%02.0f) force
tostring con, replace format(%04.0f) force
tostring  n_hog  h_mud  , replace force

gen str id = (cd_a + ent + con + v_sel + n_hog + h_mud + n_ren)
keep id p6c p6b2 p6_9 p6a3
sort id

save "$base\enoe19.dta", replace

use "$data\sdemt119.dta", clear
rename *, lower
tostring cd_a ent v_sel n_ren, replace format(%02.0f) force
tostring con, replace format(%04.0f) force
tostring mun, gen(id_mun) format(%03.0f) force
tostring n_hog h_mud, replace force

keep if r_def==0 & (c_res==1 | c_res==3)

gen str id_h = (cd_a + ent + con + v_sel + n_hog + h_mud)
gen str id = (cd_a + ent + con + v_sel + n_hog + h_mud + n_ren)

sort id
merge id using "$base\enoe19.dta"
drop _merge

gen empl=cond(clase1==1 & clase2==1,1,0)

destring p6b2 p6c, replace
recode p6b2 (999998=.) (999999=.)

* Imputation of income according to minimum wage
gen wage=p6b2
replace wage=0 if empl==0
replace wage=0 if p6b2==. & (p6_9==9 | p6a3==3)
replace wage=0.5*salario if p6b2==. & p6c==1
replace wage=1*salario if p6b2==. & p6c==2
replace wage=1.5*salario if p6b2==. & p6c==3
replace wage=2.5*salario if p6b2==. & p6c==4
replace wage=4*salario if p6b2==. & p6c==5
replace wage=7.5*salario if p6b2==. & p6c==6
replace wage=10*salario if p6b2==. & p6c==7

rename fac weight
gen rural = cond(t_loc>=1 & t_loc<=3,0,1)
destring ent, gen(state)

label define ru 0 "Urban" 1 "Rural"
label values rural ru
label var rural "Rural"
rename sex female
recode female (1=0) (2=1)
label var female "Female"
label define female 1 "Female" 0 "Male"
label values female female
rename eda age
rename l_nac_c s_born
label var s_born "State was born"
drop if s_born>32
label define s_born 1 AGS 2 BC 3 BCS 4 CAMP 5 COAH 6 COL 7 CHIA 8 CHIH 9 DF 10 ///
DGO 11 GTO 12 GRO 13 HGO 14 JAL 15 MEX 16 MICH 17 MOR 18 NAY 19 NL 20 OAX ///
21 PUE 22 QUER 23 QRO 24 SLP 25 SIN 26 SON 27 TAB 28 TAM 29 TLAX 30 VER ///
31 YUC 32 ZAC
label values s_born s_born
label var state "State"
label values state s_born
rename cs_p17 student
label var student "Student"
replace student=. if student==9
recode student (2=0)
label define student 1 "Student" 0 "No studnet"
label values student student
rename n_hij children
label var children "Number of children"
rename e_con married
replace married=1 if married==5
replace married=. if married==9
replace married=0 if married>1
rename seg_soc health
label var health "Access to health system"
replace health=. if health==3
replace health=0 if health>1
rename anios_esc edu
label var edu "Education"
replace edu=. if edu==99
rename emp_ppal formal
label var formal "Formal"
recode formal (1=0) (2=1)
label define formal 1 "Formal" 0 "Informal"
label values formal formal
label var scian "SCIAN"

gen geo=(ent+id_mun)

keep id_h id state id_mun geo wage rural weight empl female age ///
s_born student children married health edu scian formal

order id_h id state id_mun geo wage rural weight empl female age ///
s_born student children married health edu scian formal

save "$base\enoe19.dta", replace
*========================================================================*
* ENOE 2020
*========================================================================*
use "$data\coe2t120.dta", clear
tostring cd_a ent v_sel n_ren, replace format(%02.0f) force
tostring con, replace format(%04.0f) force
tostring  n_hog  h_mud  , replace force

gen str id = (cd_a + ent + con + v_sel + n_hog + h_mud + n_ren)
keep id p6c p6b2 p6_9 p6a3
sort id

save "$base\enoe20.dta", replace

use "$data\sdemt120.dta", clear
tostring cd_a ent v_sel n_ren, replace format(%02.0f) force
tostring con, replace format(%04.0f) force
tostring mun, gen(id_mun) format(%03.0f) force
tostring n_hog h_mud, replace force

keep if r_def==0 & (c_res==1 | c_res==3)

gen str id_h = (cd_a + ent + con + v_sel + n_hog + h_mud)
gen str id = (cd_a + ent + con + v_sel + n_hog + h_mud + n_ren)

sort id
merge id using "$base\enoe20.dta"
drop _merge

gen empl=cond(clase1==1 & clase2==1,1,0)

destring p6b2 p6c, replace
recode p6b2 (999998=.) (999999=.)

* Imputation of income according to minimum wage
gen wage=p6b2
replace wage=0 if empl==0
replace wage=0 if p6b2==. & (p6_9==9 | p6a3==3)
replace wage=0.5*salario if p6b2==. & p6c==1
replace wage=1*salario if p6b2==. & p6c==2
replace wage=1.5*salario if p6b2==. & p6c==3
replace wage=2.5*salario if p6b2==. & p6c==4
replace wage=4*salario if p6b2==. & p6c==5
replace wage=7.5*salario if p6b2==. & p6c==6
replace wage=10*salario if p6b2==. & p6c==7

rename fac weight
gen rural = cond(t_loc>=1 & t_loc<=3,0,1)
destring ent, gen(state)

label define ru 0 "Urban" 1 "Rural"
label values rural ru
label var rural "Rural"
rename sex female
recode female (1=0) (2=1)
label var female "Female"
label define female 1 "Female" 0 "Male"
label values female female
rename eda age
rename l_nac_c s_born
label var s_born "State was born"
drop if s_born>32
label define s_born 1 AGS 2 BC 3 BCS 4 CAMP 5 COAH 6 COL 7 CHIA 8 CHIH 9 DF 10 ///
DGO 11 GTO 12 GRO 13 HGO 14 JAL 15 MEX 16 MICH 17 MOR 18 NAY 19 NL 20 OAX ///
21 PUE 22 QUER 23 QRO 24 SLP 25 SIN 26 SON 27 TAB 28 TAM 29 TLAX 30 VER ///
31 YUC 32 ZAC
label values s_born s_born
label var state "State"
label values state s_born
rename cs_p17 student
label var student "Student"
replace student=. if student==9
recode student (2=0)
label define student 1 "Student" 0 "No studnet"
label values student student
rename n_hij children
label var children "Number of children"
rename e_con married
replace married=1 if married==5
replace married=. if married==9
replace married=0 if married>1
rename seg_soc health
label var health "Access to health system"
replace health=. if health==3
replace health=0 if health>1
rename anios_esc edu
label var edu "Education"
replace edu=. if edu==99
rename emp_ppal formal
label var formal "Formal"
recode formal (1=0) (2=1)
label define formal 1 "Formal" 0 "Informal"
label values formal formal
label var scian "SCIAN"

gen geo=(ent+id_mun)

keep id_h id state id_mun geo wage rural weight empl female age ///
s_born student children married health edu scian formal

order id_h id state id_mun geo wage rural weight empl female age ///
s_born student children married health edu scian formal

save "$base\enoe20.dta", replace
*========================================================================*
use "$base\enoe19.dta", clear

gen cohort=.
replace cohort=1997 if age==22
replace cohort=1998 if age==21
replace cohort=1999 if age==20
replace cohort=2000 if age==19
replace cohort=2001 if age==18
replace cohort=2002 if age==17
label var cohort "Age cohorts"

graph bar empl, over(cohort) ytitle(Labor participation rate) ///
graphregion(fcolor(white)) legend(off) scheme(s2mono) 
graph export "$doc\labor_enoe19.png", replace
*========================================================================*
use "$base\enoe20.dta", clear

gen cohort=.
replace cohort=1997 if age==23
replace cohort=1998 if age==22
replace cohort=1999 if age==21
replace cohort=2000 if age==20
replace cohort=2001 if age==19
replace cohort=2002 if age==18
label var cohort "Age cohorts"

gen ind_act=.
replace ind_act=0 if empl==0 & student==0
replace ind_act=1 if empl==1 & formal==1
replace ind_act=2 if empl==1 & formal==0
replace ind_act=3 if empl==0 & student==1

catplot ind_act cohort [fw=weight], ///
percent(cohort) ///
graphregion(fcolor(white)) scheme(s2mono) ///
var1opts(label(labsize(small))) ///
var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Percent of individuals by occupation", size(small)) ///
asyvars stack ///
legend(rows(1) stack size(small) ///
order(1 "Inactive" 2 "Formal worker" ///
3 "Informal worker" 4 "Student") ///
symplacement(center))
graph export "$doc\labor_enoe20.png", replace

/*graph bar empl, over(cohort) ytitle(Labor participation rate) ///
graphregion(fcolor(white)) legend(off) scheme(s2mono) 
graph export "$doc\labor_enoe20.png", replace*/

replace student=0 if ind_act!=3
replace empl=0 if ind_act==0 | ind_act==3
gen tot_pop=1
keep if cohort!=.

collapse (sum) student empl tot_pop [fw=weight], by(geo)	

gen p_stud=student/tot_pop
keep if p_stud<.20
keep geo p_stud
save "$base\p_stud_enoe.dta", replace
*tostring geo, replace format(%05.0f) force
*========================================================================*
use "$base\enoe20.dta", clear

merge m:m geo using "$base\p_stud.dta"
drop if _merge!=3
drop _merge

gen cohort=.
replace cohort=1997 if age==23
replace cohort=1998 if age==22
replace cohort=1999 if age==21
replace cohort=2000 if age==20
replace cohort=2001 if age==19
replace cohort=2002 if age==18
label var cohort "Age cohorts"

merge m:m geo cohort using "$base\exposure_mun.dta"
drop if _merge!=3
drop _merge

gen ind_act=.
replace ind_act=0 if empl==0 & student==0
replace ind_act=1 if empl==1 & formal==1
replace ind_act=2 if empl==1 & formal==0
replace ind_act=3 if empl==0 & student==1

gen formal_s=1 if formal==1
replace formal_s=0 if formal_s==.

gen p_enrol=.
replace p_enrol=0 if p_stud>0.04 & p_stud<=0.05
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

label define enrol 0 "0.04<p<=0.05" 1 "0.05<p<=0.06" 2 "0.06<p<=0.07" 3 "0.07<p<=0.08" ///
4 "0.08<p<=0.09" 5 "0.09<p<=0.10" 6 "0.10<p<=0.11" 7 "0.11<p<=0.12" 8 ///
"0.12<p<=0.13" 9 "0.13<p<=0.14" 10 "0.14<p<=0.15" 
label values p_enrol enrol

/* Droping ages above 22 */
drop if age>22

graph hbar (sum) weight, over(p_enrol) ///
graphregion(fcolor(white)) scheme(s2mono) ///
ytitle("Number of inhabitants")
*graph export "$doc\p_enroll_inhab_enoe.png", replace

graph hbar (mean) formal [fw=weight], over(p_enrol) ///
graphregion(fcolor(white)) scheme(s2mono) ///
ytitle("Proportion of workers in formal sector")
*graph export "$doc\p_enroll_formal_enoe.png", replace

catplot ind_act cohort if p_stud<=0.05 [fw=weight], ///
percent(cohort) ///
graphregion(fcolor(white)) scheme(s2mono) ///
var1opts(label(labsize(small))) ///
var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Percent of individuals by occupation", size(small)) ///
asyvars stack ///
legend(rows(1) stack size(small) ///
order(1 "Inactive" 2 "Formal worker" ///
3 "Informal worker" 4 "Student") ///
symplacement(center))
*graph export "$doc\labor_enoe20_low.png", replace
/*
eststo clear
foreach x in 05 06 07 08 09 10 11 12 13 14 15{
areg formal_s hrs_exp rural female age i.cohort [aw=weight] if p_stud<=0.`x', absorb(geo) vce(cluster geo)
estimates store formal`x'
}
coefplot (formal05, label(p<=0.05)) (formal06, label(p<=0.06)) (formal07, label(p<=0.07)) ///
(formal08, label(p<=0.08) mcolor(red) ciopts(recast(rcap)color(red))) (formal09, ///
label(p<=0.09)) (formal10, label(p<=0.10)) (formal11, label(p<=0.11)) (formal12, ///
label(p<=0.12)) (formal13, label(p<=0.13)) ///
(formal14, label(p<=0.14)) (formal15, label(p<=0.15)), ///
vertical keep(hrs_exp) yline(0) ///
ytitle("Probability of working in formal sector", size(medium) height(5)) ///
legend( pos(1) ring(0) col(2)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
*/
*========================================================================*
/* The effect of English exposure on schooling */
*========================================================================*
use "$base\enoe20.dta", clear

merge m:m geo using "$base\p_stud.dta"
drop if _merge!=3
drop _merge

gen cohort=.
replace cohort=1997 if age==23
replace cohort=1998 if age==22
replace cohort=1999 if age==21
replace cohort=2000 if age==20
replace cohort=2001 if age==19
replace cohort=2002 if age==18
label var cohort "Age cohorts"

gen ind_act=.
replace ind_act=0 if empl==0 & student==0
replace ind_act=1 if empl==1 & formal==1
replace ind_act=2 if empl==1 & formal==0
replace ind_act=3 if empl==0 & student==1

gen lwage=log(wage)
gen age2=age^2

merge m:m geo cohort using "$base\exposure_mun.dta"
drop if _merge!=3
drop _merge
gen formal_s=1 if formal==1
replace formal_s=0 if formal_s==.
gen informal_s=1 if formal==0
replace informal_s=0 if informal_s==.
*drop if age==23

areg student hrs_exp rural female age i.cohort [aw=weight], absorb(geo) vce(cluster geo)
areg edu hrs_exp rural female age i.cohort [aw=weight], absorb(geo) vce(cluster geo)
areg formal_s hrs_exp rural female age i.cohort [aw=weight], absorb(geo) vce(cluster geo)
areg lwage hrs_exp rural female edu age age2 i.cohort [aw=weight], absorb(geo) vce(cluster geo)

areg student hrs_exp rural female age i.cohort [aw=weight] if p_stud<=0.07, absorb(geo) vce(cluster geo)
areg edu hrs_exp rural female age i.cohort [aw=weight] if p_stud<=0.07, absorb(geo) vce(cluster geo)
areg formal_s hrs_exp rural female age i.cohort [aw=weight] if p_stud<=0.07, absorb(geo) vce(cluster geo)
areg lwage hrs_exp rural female edu age age2 i.cohort [aw=weight] if p_stud<=0.07, absorb(geo) vce(cluster geo)
