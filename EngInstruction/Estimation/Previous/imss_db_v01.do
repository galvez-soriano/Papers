*========================================================================*
* The effect of the English program on student achievement and wages
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "S:\stata"
gl base= "F:\T43969_Oscar\Data"
gl doc= "F:\T43969_Oscar\Doc"
*========================================================================*
/* Working with IMSS labor data to create the final database
Note: Run right after imss_firm.do */
*========================================================================*
foreach x in 18 19 20 21{
use "$base\imss20`x'all.dta", clear
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
append using "$base\imss2018.dta" "$base\imss2019.dta" "$base\imss2020.dta" ///
"$base\imss2021.dta"
save "$base\dbase_18_21.dta", replace

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
sort curp
 
gen ltd=substr(curp,1,2)
gen str ftd=""
replace ltd=substr(curp,2,2) in 1/76
replace ltd=substr(curp,2,2) in 9956167/l
replace ftd="19" if ltd<="99" & ltd>="30"
replace ftd="20" if ltd<="30"
drop if ftd==""
drop if ltd==" 0" | ltd==" 9" | ltd==" M" | ltd=="'1" | ltd=="-9" | ltd=="1'"
replace ltd="01" if ltd=="0I"
replace ltd="01" if ltd=="O1"
replace ltd="01" if ltd=="O1"
replace ltd="00" if ltd=="0O"
replace ltd="10" if ltd=="1O"

expand 4 if year==.
bysort curp: gen n_obs=_n
replace year=2018 if year==. & n_obs==1
replace year=2019 if year==. & n_obs==2
replace year=2020 if year==. & n_obs==3
replace year=2021 if year==. & n_obs==4
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

gen geo=substr(id_geo_s,1,5)
merge m:m geo using "$base\low_enrol.dta"
drop if _merge==2
drop _merge

merge m:m year f_rfc using "$base\comp_size.dta"
drop if _merge==2
drop _merge

save "$base\dbase_18_21.dta", replace
*========================================================================*
/* Final database and descriptive statistics */
*========================================================================*
use "$base\dbase_18_21.dta", clear

gen lwage=log(wage)
gen age2=age^2

drop geo
destring state_s, replace
gen geo_mun=substr(id_geo_s,1,5)
merge m:m geo_mun using "$base\coord_mex.dta"
drop if _merge!=3
drop _merge 
rename geo_mun geo_mun_s

rename latitude lat_school
rename longitude lon_school
rename altitude alt_school

merge m:m id_mun using "$base\mun_imss.dta"
drop if _merge==2
drop _merge

rename id_geo geo_mun
replace geo_mun="31050" if geo_mun=="31."
merge m:m geo_mun using "$base\coord_mex.dta"
drop if _merge==2
drop _merge geo_mun

vincenty lat_school lon_school latitude longitude, v(distance)
replace distance=distance+1 if distance!=.
replace distance=1 if distance==. & wage!=.

gen ldist=log(distance)
gen move_state=.
replace move_state=1 if state_s!=state & state!=.
replace move_state=0 if state_s==state & state!=.

save "$base\dbase_18_21_final.dta", replace

use "$base\dbase_18_21_final.dta", clear
sum female age language6 math6 h_eng t_eng n_stud t_colle t_mast rural wage perma n_jobs n_perma n_workers distance if wage!=.
