*========================================================================*
* The effect of the English program on student achievement and labor
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "S:\stata"
gl base= "F:\T43969_Oscar\Data"
gl doc= "F:\T43969_Oscar\Doc"
*========================================================================*
/* Working with IMSS labor data */
*========================================================================*
foreach x in 18 19 20 {
foreach i in 01 02 03 04 05 06 07 08 09 10 11 12{
use "$data\20`x'\imss_`i'20`x'.dta", clear
foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}
save "$base\imss_`i'.dta", replace
}
foreach i in 01 02 03 04 05 06 07 08 09 10 11 12{
append using "$base\imss_`i'.dta"
}

rename llave_tiempo time
rename llave_empleado w_rfc
rename llave_municipio id_mun 
rename llave_entidad state
rename llave_modalidad modalidad
rename llave_actividad activity 
rename llave_sexo female 
rename tipo_trabajador perma
rename salariof wage
rename llave_empresa f_rfc

recode female (1=0) (2=1)
recode perma (2=0) (3=0) (4=0)
/*
merge m:m id_mun using "$data\mun_imss.dta"
drop if _merge!=3
drop _merge
*/
/* Generating years from time variable: 468 is 12/2018 */
gen year=.
forvalues j = 468(12)504 {
replace year=1979+(`j'/12) if time>`j'-12 & time<=`j'
}
gen uma18=80.60 if year==2018
gen uma19=84.49 if year==2019
gen uma20=86.88 if year==2020

gen eng_activ=0
replace eng_activ=1 if activity==243

keep w_rfc f_rfc activity female perma wage year id_mun state modalidad uma`x' eng_activ
/* Number of months an individual worked in the same economic sector */
bysort w_rfc year activity f_rfc: gen month_act=_N
/* Collapsing data as the average per worker-year, per economic sector and per company*/
collapse (mean) female month_act perma wage uma* eng_activ, by(id_mun state year w_rfc activity modalidad f_rfc)
/* I assume that if the individual worked more than 50% of a year in a
permanent job she can be considered as a permanent worker */
replace perma=1 if perma>=0.5
replace perma=0 if perma<0.5
/* Generating a variable that measure the number of jobs a worker has in one 
particular year */
bysort w_rfc year: gen n_jobs=_N
/* Generating a variable that indicates the number of permanent jobs of each
worker */
bysort w_rfc year: egen n_perma=sum(perma)

/*For workers with multiple jobs, I first keep the jobs with the highest wage
among the same economic activities*/
collapse (mean) female month_act perma uma* eng_activ n_perma n_jobs (max) wage, by(id_mun state year w_rfc modalidad activity)
/* I create a variable to indicate workers who work in education and have 
multiple jobs with the same salary */
bysort w_rfc year: egen act=sum(activity)
replace act=act/266
replace act=. if (act!=1 & act!=2 & act!=3 & act!=4 & act!=5)
/* I also consider workers who work in a specific economic sector and also in 
education */
bysort w_rfc year: gen act2=_N if activity==266
bysort w_rfc year: egen act3=sum(act2)
/* This variable identifies the proporcional wage of each job with respect to
the maximum wage */
bysort w_rfc year: egen max_w=max(wage)
bysort w_rfc year: egen max_w2=mean(max_w)
drop max_w
gen p_wage=wage/max_w2
/* This variable identifies if an employee works in the same state */
bysort w_rfc year: egen sta=mean(state)
replace sta=sta/state
/* Lower paid jobs are less than 14 uma's `x' */ 
bysort w_rfc year: gen lpj=1 if wage<=14*uma`x' & p_wage<1
bysort w_rfc year: egen lp_job=sum(lpj)
replace lp_job=1 if lp_job>1
drop lpj
/* Lower paid jobs represents less than 0.5 percent of maximum wage */ 
bysort w_rfc year: gen lpj=1 if p_wage<=0.5
bysort w_rfc year: egen w_50=sum(lpj)
replace w_50=1 if w_50>1
drop lpj
/* Lower paid jobs represents less than 0.1 percent of maximum wage */ 
bysort w_rfc year: gen lpj=1 if p_wage<=0.1
bysort w_rfc year: egen w_10=sum(lpj)
replace w_10=1 if w_10>1
drop lpj
/* Part time wages as 2/5 of regular wages */
gen wage_pt=wage*(0.4) if p_wage<1
replace wage_pt=wage if p_wage==1
/* I consider various cases to sum wages or not.
1) First, I sum the wage of academic jobs if the employee works in the same
state for all her jobs, they all are permanent jobs and her lower paid jobs are
less than 14 uma's (in case she is paid by Conacyt) */
bysort w_rfc year: egen wage_s=sum(wage) if act!=. & sta==1 & lp_job==1
/* 2) Second, I sum wages of academic jobs if the employee works in different 
states, they all are permanent jobs and where the jobs with lower salaries are
considered part time jobs */
bysort w_rfc year: egen wage_s2=sum(wage_pt)  
replace wage_s=wage_s2 if wage_s==. & (act!=. | act3>1)
/* 3) Third, I sum wages if the lower salaries represent less than 50 percent 
of the maximum wage, the jobs are in the same state and they are permanent 
jobs */
bysort w_rfc year: egen wage_s3=sum(wage) 
replace wage_s=wage_s2 if wage_s==. & sta==1 & w_50==1 & perma==1
/* 4) Fourth, I sum wages as part time jobs if the lower salaries represent 
less than 50 percent of the maximum wage and the jobs are in the different 
states */
replace wage_s=wage_s2 if wage_s==. & sta!=1 & w_50==1
/* 5) Finally, I sum wages if the lower salaries represent less than 10 percent 
of the maximum wage and the jobs are either in the same or different state */
replace wage_s=wage_s3 if wage_s==. & w_10==1
drop wage_s2 wage_s3 act act2 act3 p_wage sta lp_job w_50 w_10 wage_pt
/* For the remaining workers, I keep the maximum wage since we do not know what 
job is full time or part time job */
replace wage_s=max_w2 if wage_s==.

/* Generating the maximum wage in a year per worker */
bysort w_rfc year: egen max_w=max(wage)
replace max_w=round(max_w, 1)
gen r_wage=round(wage, 1)
gen check_mw=.
replace check_mw=1 if max_w==r_wage
drop r_wage max_w
/* I will drop the lowest wages for individuals who have more than one job */
drop if check_mw==.
drop check_mw
/* If there are individuals with permanent and not permanent jobs, I use the 
information only of the permanent job */
bysort w_rfc year: gen check_j=_N
drop if check_j>1 & perma==0 & n_perma!=0
drop check_j
/* For individuals who had more than one job with the same wage I choose the 
job in which she has worked most part of the year */
bysort w_rfc year: gen check_j=_N
drop if check_j==2 & month_act<6
drop month_act max_w check_j

duplicates drop w_rfc, force

merge 1:1 w_rfc using "$base\cruce_imss.dta"
drop if _merge!=3
drop _merge
order curp state id_mun w_rfc
save "$base\imss20`x'.dta", replace
}
*========================================================================*
/* Appending 2018-2020 databases and merge with ENLACE test */
*========================================================================*
clear
append using "$base\imss2018.dta" "$base\imss2019.dta" "$base\imss2020.dta"
save "$base\dbase_18_20.dta", replace

merge m:m curp using "$base\prueba_enlace.dta"
*drop if _merge!=3
gen imss=1
replace imss=0 if _merge!=3
drop _merge
destring cohort, replace

gen curp1=substr(curp,1,1)
replace curp1="0" if curp1=="O"
gen curp2=substr(curp,2,1)
replace curp2="0" if curp2=="O"
gen curp3=substr(curp,3,12)
rename curp curp_2
gen str curp=curp1+curp2+curp3
drop curp1 curp2 curp3 curp_2
order curp state_s id_geo cct year w_rfc state id_mun
 
gen ltd=substr(curp,1,2)
gen str ftd=""
replace ltd=substr(curp,2,2) in 8588412/l
replace ftd="19" if ltd<="99" & ltd>="30"
replace ftd="20" if ltd<="30"
drop if ftd==""
drop if ltd==" 0" | ltd==" 9" | ltd==" M" | ltd=="'1" | ltd=="-9"
replace ltd="01" if ltd=="0I"
replace ltd="00" if ltd=="0O"
replace ltd="10" if ltd=="1O"

expand 3 if year==.
bysort curp: gen n_obs=_n
replace year=2018 if year==. & n_obs==1
replace year=2019 if year==. & n_obs==2
replace year=2020 if year==. & n_obs==3
drop n_obs

gen yob=ftd+ltd
destring yob, replace
gen age=year-yob
drop if age>22 | age<15
drop ftd ltd
replace wage=wage*30

gen gender=substr(curp,7,1)
replace gender="0" if gender=="H"
replace gender="1" if gender=="M"
drop if gender!="0" & gender!="1"
destring gender, replace
replace female=gender if female!=0 | female!=1

merge m:m w_rfc using "$base\nss_year.dta"
drop if _merge==2
drop _merge
drop uma*

gen exp_fs=year-year_ffw if year_ffw>(yob+15)
replace exp_fs=0 if age==16 & exp_fs==.
replace exp_fs=1 if age==17 & exp_fs==.
replace exp_fs=2 if age==18 & exp_fs==.

gen geo=substr(id_geo_s,1,5)
merge m:m geo using "$base\low_stud.dta"
drop if _merge==2
drop _merge

save "$base\dbase_18_20.dta", replace
*========================================================================*
/* Descriptive statistics */
*========================================================================*
use "$base\dbase_18_20.dta", clear
sum female age language6 math6 h_eng t_eng n_stud t_colle t_mast rural wage perma n_jobs n_perma if wage!=.
*========================================================================*
/* Regressions Labor Market */
*========================================================================*
use "$base\dbase_18_20.dta", clear

gen lwage=log(wage)
gen lwage_s=log(wage_s)
gen age2=age^2
gen h_eng2=h_eng^2
/* English exposure and wages */
eststo clear
eststo: areg lwage h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year, absorb(state_s) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(cct) vce(cluster cct)
esttab using "$doc\tab2a.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) keep(h_eng) replace
* Number of English teachers
eststo clear
eststo: areg lwage t_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year, absorb(state_s) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year, absorb(cct) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state, absorb(cct) vce(cluster cct)
esttab using "$doc\tab2b.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) keep(t_eng) replace
*========================================================================*
/* Participation in formal labor market */
eststo clear
eststo: areg imss h_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year, absorb(state_s) vce(cluster cct)
eststo: areg imss h_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year, absorb(cct) vce(cluster cct)
esttab using "$doc\tab3a.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) keep(h_eng) replace
* Number of English teachers
eststo clear
eststo: areg imss t_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year, absorb(state_s) vce(cluster cct)
eststo: areg imss t_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year, absorb(cct) vce(cluster cct)
esttab using "$doc\tab3b.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) keep(t_eng) replace
*========================================================================*
/* Participation in jobs requiring English abilities */
eststo clear
eststo: areg eng_activ h_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if wage!=., absorb(state_s) vce(cluster cct)
eststo: areg eng_activ h_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if wage!=., absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if eng_activ==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab4a.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) keep(h_eng) replace
* Number of English teachers
eststo clear
eststo: areg eng_activ t_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if wage!=., absorb(state_s) vce(cluster cct)
eststo: areg eng_activ t_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if wage!=., absorb(cct) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year i.state if eng_activ==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab4e.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) keep(t_eng) replace
*========================================================================*
/* Dealing with selection problem */
*========================================================================*
/* Subsample: low enrollment */
use "$base\dbase_18_20.dta", clear

gen lwage=log(wage)
gen lwage_s=log(wage_s)
gen age2=age^2

replace p_stud=1 if p_stud<=0.05 & p_stud!=.
replace p_stud=0 if (p_stud>0.05 & p_stud!=1) | p_stud==.
/* Participation in formal labor market: Subsample */
eststo clear
eststo: areg imss h_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if p_stud==1, absorb(cct) vce(cluster cct)
/* English exposure and earnings: Subsample */
eststo: areg lwage h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year if p_stud==1, absorb(cct) vce(cluster cct)
/* Participation in jobs requiring English abilities: Subsample */
eststo: areg eng_activ h_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if wage!=. & p_stud==1, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year if eng_activ==1 & p_stud==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab5a.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) keep(h_eng) replace
/* Men */
/* Participation in formal labor market: Subsample */
eststo clear
eststo: areg imss h_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if p_stud==1 & female==0, absorb(cct) vce(cluster cct)
/* English exposure and earnings: Subsample. */
eststo: areg lwage h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year if female==0 & p_stud==1, absorb(cct) vce(cluster cct)
/* Participation in jobs requiring English abilities: Subsample */
eststo: areg eng_activ h_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if wage!=. & p_stud==1 & female==0, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year if eng_activ==1 & p_stud==1 & female==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab5b.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) keep(h_eng) replace
/* Women */
/* Participation in formal labor market: Subsample */
eststo clear
eststo: areg imss h_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if p_stud==1 & female==1, absorb(cct) vce(cluster cct)
/* English exposure and earnings: Subsample. */
eststo: areg lwage h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year if female==1 & p_stud==1, absorb(cct) vce(cluster cct)
/* Participation in jobs requiring English abilities: Subsample */
eststo: areg eng_activ h_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if wage!=. & p_stud==1 & female==1, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year if eng_activ==1 & p_stud==1 & female==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab5c.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) keep(h_eng) replace
/* Number of teachers: Subsample */
/* Participation in formal labor market: Subsample */
eststo clear
eststo: areg imss t_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if p_stud==1, absorb(cct) vce(cluster cct)
/* English exposure and earnings: Subsample */
eststo: areg lwage t_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year if p_stud==1, absorb(cct) vce(cluster cct)
/* Participation in jobs requiring English abilities: Subsample */
eststo: areg eng_activ t_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if wage!=. & p_stud==1, absorb(cct) vce(cluster cct)
eststo: areg lwage t_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year if eng_activ==1 & p_stud==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab5d.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) keep(t_eng) replace
*========================================================================*
/* Subsample: older cohorts */
use "$base\dbase_18_20.dta", clear

gen lwage=log(wage)
gen lwage_s=log(wage_s)
gen age2=age^2

/* Participation in formal labor market: Subsample */
eststo clear
eststo: areg imss h_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if age>=20, absorb(cct) vce(cluster cct)
/* English exposure and earnings: Subsample */
eststo: areg lwage h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year if age>=20, absorb(cct) vce(cluster cct)
/* Participation in jobs requiring English abilities: Subsample */
eststo: areg eng_activ h_eng language6 math6 female n_stud age age2 i.cohort ///
t_colle t_mast i.year if wage!=. & age>=20, absorb(cct) vce(cluster cct)
eststo: areg lwage h_eng language6 math6 female n_stud age age2 perma n_jobs ///
n_perma t_colle t_mast i.cohort i.year if eng_activ==1 & age>=20, absorb(cct) vce(cluster cct)
esttab using "$doc\tab5a.tex", ar2 cells(b(star fmt(%9.4f)) se(par)) keep(h_eng) replace
*========================================================================*
/* Regressions Student Achievement (Full Sample) */
*========================================================================*
clear
append using "$base\imss2018.dta" "$base\imss2019.dta" "$base\imss2020.dta"
save "$base\dbase_match.dta", replace

drop if wage==.
collapse (mean) female, by(curp)
gen gender=substr(curp,7,1)
replace gender="0" if gender=="H"
replace gender="1" if gender=="M"
drop if gender!="0" & gender!="1"
destring gender, replace
replace female=gender if female!=0 | female!=1

merge m:m curp using "$base\prueba_enlace.dta"
drop if _merge!=3
drop _merge
destring cohort, replace
save "$base\dbase_match.dta", replace
*========================================================================*
use "$base\dbase_match.dta", clear
eststo clear
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort, absorb(state) vce(cluster cct)
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort, absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort, absorb(state) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_a.tex", ar2 se b(a2) title(English exposure and test scores \label{tab2}) keep(h_eng) label replace

eststo clear
eststo: areg language6 t_eng language5 gender n_stud t_colle t_mast rural i.cohort, absorb(state) vce(cluster cct)
eststo: areg language6 t_eng language5 gender n_stud t_colle t_mast rural i.cohort, absorb(cct) vce(cluster cct)
eststo: areg math6 t_eng math5 gender n_stud t_colle t_mast rural i.cohort, absorb(state) vce(cluster cct)
eststo: areg math6 t_eng math5 gender n_stud t_colle t_mast rural i.cohort, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_b.tex", ar2 se b(a2) title(English exposure and test scores \label{tab2}) keep(t_eng) label replace

/* Gender Heterogeneous effects */
* Men
eststo clear
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if gender==0, absorb(state) vce(cluster cct)
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if gender==0, absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if gender==0, absorb(state) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if gender==0, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_men.tex", ar2 se b(a2) title(English exposure and test scores \label{tab2}) keep(h_eng) label replace
* Women
eststo clear
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if gender==1, absorb(state) vce(cluster cct)
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if gender==1, absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if gender==1, absorb(state) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if gender==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_women.tex", ar2 se b(a2) title(English exposure and test scores \label{tab2}) keep(h_eng) label replace

/* Non-linear production function */
gen h_eng2=h_eng^2
gen t_eng2=t_eng^2

eststo clear
eststo: areg language6 h_eng h_eng2 language5 gender n_stud t_colle t_mast rural i.cohort, absorb(state) vce(cluster cct)
eststo: areg language6 h_eng h_eng2 language5 gender n_stud t_colle t_mast rural i.cohort, absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng h_eng2 math5 gender n_stud t_colle t_mast rural i.cohort, absorb(state) vce(cluster cct)
eststo: areg math6 h_eng h_eng2 math5 gender n_stud t_colle t_mast rural i.cohort, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_nla.tex", ar2 se b(a2) title(English exposure and test scores \label{tab2}) keep(h_eng h_eng2) label replace

eststo clear
eststo: areg language6 t_eng t_eng2 language5 gender n_stud t_colle t_mast rural i.cohort, absorb(state) vce(cluster cct)
eststo: areg language6 t_eng t_eng2 language5 gender n_stud t_colle t_mast rural i.cohort, absorb(cct) vce(cluster cct)
eststo: areg math6 t_eng t_eng2 math5 gender n_stud t_colle t_mast rural i.cohort, absorb(state) vce(cluster cct)
eststo: areg math6 t_eng t_eng2 math5 gender n_stud t_colle t_mast rural i.cohort, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_nlb.tex", ar2 se b(a2) title(English exposure and test scores \label{tab2}) keep(t_eng t_eng2) label replace

*========================================================================*
/* Regressions Student Achievement (Sub Sample) */
*========================================================================*
clear
append using "$base\imss2018.dta" "$base\imss2019.dta" "$base\imss2020.dta"
save "$base\dbase_match_ss.dta", replace

drop if wage==.
collapse (mean) female, by(curp)
gen gender=substr(curp,7,1)
replace gender="0" if gender=="H"
replace gender="1" if gender=="M"
drop if gender!="0" & gender!="1"
destring gender, replace
replace female=gender if female!=0 | female!=1

merge m:m curp using "$base\prueba_enlace.dta"
drop if _merge!=3
drop _merge
destring cohort, replace

gen geo=substr(id_geo_s,1,5)
merge m:m geo using "$base\low_stud.dta"
drop if _merge==2
drop _merge

save "$base\dbase_match_ss.dta", replace
*========================================================================*
use "$base\dbase_match_ss.dta", clear

replace p_stud=1 if p_stud<=0.05 & p_stud!=.
replace p_stud=0 if (p_stud>0.05 & p_stud!=1) | p_stud==.

eststo clear
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if p_stud==1, absorb(state) vce(cluster cct)
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if p_stud==1, absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if p_stud==1, absorb(state) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if p_stud==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_a.tex", ar2 se b(a2) title(English exposure and test scores \label{tab2}) keep(h_eng) label replace

eststo clear
eststo: areg language6 t_eng language5 gender n_stud t_colle t_mast rural i.cohort if p_stud==1, absorb(state) vce(cluster cct)
eststo: areg language6 t_eng language5 gender n_stud t_colle t_mast rural i.cohort if p_stud==1, absorb(cct) vce(cluster cct)
eststo: areg math6 t_eng math5 gender n_stud t_colle t_mast rural i.cohort if p_stud==1, absorb(state) vce(cluster cct)
eststo: areg math6 t_eng math5 gender n_stud t_colle t_mast rural i.cohort if p_stud==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_b.tex", ar2 se b(a2) title(English exposure and test scores \label{tab2}) keep(t_eng) label replace

/* Gender Heterogeneous effects */
* Men
eststo clear
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if gender==0 & p_stud==1, absorb(state) vce(cluster cct)
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if gender==0 & p_stud==1, absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if gender==0 & p_stud==1, absorb(state) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if gender==0 & p_stud==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_men.tex", ar2 se b(a2) title(English exposure and test scores \label{tab2}) keep(h_eng) label replace
* Women
eststo clear
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if gender==1 & p_stud==1, absorb(state) vce(cluster cct)
eststo: areg language6 h_eng language5 gender n_stud t_colle t_mast rural i.cohort if gender==1 & p_stud==1, absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if gender==1 & p_stud==1, absorb(state) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud t_colle t_mast rural i.cohort if gender==1 & p_stud==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_women.tex", ar2 se b(a2) title(English exposure and test scores \label{tab2}) keep(h_eng) label replace

/* Non-linear production function */
gen h_eng2=h_eng^2
gen t_eng2=t_eng^2

eststo clear
eststo: areg language6 h_eng h_eng2 language5 gender n_stud t_colle t_mast rural i.cohort if p_stud==1, absorb(state) vce(cluster cct)
eststo: areg language6 h_eng h_eng2 language5 gender n_stud t_colle t_mast rural i.cohort if p_stud==1, absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng h_eng2 math5 gender n_stud t_colle t_mast rural i.cohort if p_stud==1, absorb(state) vce(cluster cct)
eststo: areg math6 h_eng h_eng2 math5 gender n_stud t_colle t_mast rural i.cohort if p_stud==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_nla.tex", ar2 se b(a2) title(English exposure and test scores \label{tab2}) keep(h_eng h_eng2) label replace

eststo clear
eststo: areg language6 t_eng t_eng2 language5 gender n_stud t_colle t_mast rural i.cohort if p_stud==1, absorb(state) vce(cluster cct)
eststo: areg language6 t_eng t_eng2 language5 gender n_stud t_colle t_mast rural i.cohort if p_stud==1, absorb(cct) vce(cluster cct)
eststo: areg math6 t_eng t_eng2 math5 gender n_stud t_colle t_mast rural i.cohort if p_stud==1, absorb(state) vce(cluster cct)
eststo: areg math6 t_eng t_eng2 math5 gender n_stud t_colle t_mast rural i.cohort if p_stud==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab_stud_nlb.tex", ar2 se b(a2) title(English exposure and test scores \label{tab2}) keep(t_eng t_eng2) label replace