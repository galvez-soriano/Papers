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
/* Working with IMSS labor data to create company size 
Note: Run before imss_db.do */
*========================================================================*
foreach x in 18 19 20 21{
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

/* Generating years from time variable: 468 is 12/2018 */
gen year=.
forvalues j = 468(12)504 {
replace year=1979+(`j'/12) if time>`j'-12 & time<=`j'
}

keep w_rfc f_rfc activity female perma wage year id_mun state
/* Number of months an individual worked in the same economic sector */
bysort w_rfc year activity f_rfc: gen month_act=_N
/* Collapsing data as the average per worker-year, per economic sector and per company*/
collapse (mean) female month_act perma wage, by(year state id_mun w_rfc activity f_rfc)
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
collapse (mean) female month_act perma n_jobs n_perma (max) wage, by(year state id_mun w_rfc activity f_rfc)
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
drop month_act check_j

duplicates drop w_rfc, force

/*merge 1:1 w_rfc using "$base\cruce_imss.dta"
drop if _merge!=3
drop _merge
order curp state id_mun w_rfc*/
save "$base\imss20`x'all.dta", replace
}
*========================================================================*
/* Appending 2018-2020 databases */
*========================================================================*
clear
append using "$base\imss2018all.dta" "$base\imss2019all.dta" ///
"$base\imss2020all.dta" "$base\imss2021all.dta"
save "$base\dbase_18_21all.dta", replace

gen n_workers=1
collapse (sum) n_workers, by(year f_rfc)

save "$base\comp_size.dta", replace
*========================================================================*
use "$base\comp_size.dta", clear
gen f_size=.
replace f_size=0 if n_workers<10
replace f_size=1 if n_workers>=10 & n_workers<50
replace f_size=2 if n_workers>=50 & n_workers<250
replace f_size=3 if n_workers>=250
save "$base\comp_size.dta", replace
