*========================================================================*
* The effect of the English program on student achievement and labor
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Labor"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New"
gl doc= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Doc"
*========================================================================*
/* Working with IMSS labor data */
*========================================================================*
use "$data\muestra_imss.dta", clear

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
/* Generating years from time variable */
gen year=.
forvalues i = 12(12)504 {
replace year=1979+(`i'/12) if time>`i'-12 & time<=`i'
}

sort w_rfc year

keep w_rfc activity female perma wage year
/* Number of months an individual worked in the same economic sector */
bysort w_rfc year activity: gen month_act=_N
/* Collapsing data as the average per worker-year and per economic sector */
collapse (mean) female month_act perma wage, by(w_rfc year activity)
/* Generating a variable that measure the number of jobs a worker has in one 
particular year */
bysort w_rfc year: gen n_jobs=_N
/* I assume that if the individual worked more than 50% of a year in a
permanent job she can be considered as a permanent worker */
replace perma=1 if perma>=0.5
replace perma=0 if perma<0.5
/* Generating a variable that indicates the number of permanent jobs of each
worker */
bysort w_rfc year: egen n_perma=sum(perma)
/* Generating the maximum wage in a year per worker */
bysort w_rfc year: egen max_w=max(wage)
gen check_mw=.
replace check_mw=1 if max_w==wage
/* I will drop the lowest wages for individuals who have more than one job */
drop if check_mw==.
drop check_mw
/* For individuals who had more than one job with the same wage I choose the 
job in which she has worked most part of the year */
bysort w_rfc year: gen check_j=_N
drop if check_j==2 & month_act<6
drop month_act max_w check_j count_j
save "$data\data_imss.dta", replace
*========================================================================*
use "$data\data_imss.dta", clear
