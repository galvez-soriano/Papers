*========================================================================*
* The effect of the English program on school achievement
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Ideas\Education\SEP\ENLACE"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New"
gl doc= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Doc"
*========================================================================*
/* ENLACE 2006 */
*========================================================================*
use "$data\ENLACE_2006\enlace2006.dta", clear

drop nvl_esp nvl_mat observalci
rename nivel level
rename turno shift
rename p_esp s_spa
rename p_mat s_math
rename nofolio id_num
rename grado grade
rename grupo group
rename modalidad type
rename entidad state
rename sexo gender

replace level="1" if level=="PRIMARIA"
replace level="2" if level=="SECUNDARIA"

destring level, replace
label define level 1 "PRIMARIA" 2 "SECUNDARIA"
label values level level
drop if level==2

destring shift, replace
label define shift 1 "Morning" 2 "Afternoon" 3 "Evening"
label values shift shift

replace type="PRIVATE" if type=="PARTICULAR"
replace type="INDIGENOUS" if type=="INDIGENA"

replace gender="0" if gender=="H"
replace gender="1" if gender=="M"
destring gender, replace
label define gender 0 "Male" 1 "Female"
label values gender gender

bysort cct shift grade group: gen n_students=_N
sort cct shift grade group id_num

save "$base\enlace06.dta", replace
*========================================================================*
/* ENLACE 2007 */
*========================================================================*
use "$data\ENLACE_2007\enlace2007.dta", clear

drop variabl0 nm nombre_mun observaci
rename nivel level
rename turno shift
rename cal_esp s_spa
rename cal_mat s_math
rename nofolio id_num
rename grado grade
rename grupo group
rename modalidad type
rename ent state
rename sexo gender

replace level="1" if level=="PRIMARIA"
replace level="2" if level=="SECUNDARIA"

destring level, replace
label define level 1 "PRIMARIA" 2 "SECUNDARIA"
label values level level
drop if level==2

destring shift, replace
label define shift 1 "Morning" 2 "Afternoon" 3 "Evening"
label values shift shift

replace type="PRIVATE" if type=="PARTICULAR"

replace gender="0" if gender=="H"
replace gender="1" if gender=="M"
destring gender, replace
label define gender 0 "Male" 1 "Female"
label values gender gender
rename municipio mun

bysort cct shift grade group: gen n_students=_N
sort cct shift grade group id_num

save "$base\enlace07.dta", replace
*========================================================================*
/* ENLACE 2008 */
*========================================================================*
use "$data\ENLACE_2008\enlace2008.dta", clear

drop cal_c_n copia esp_50 variabl0 mat_50 nm c_n_50 nc
rename nivel level
rename turno shift
rename cal_esp s_spa
rename cal_mat s_math
rename nofolio id_num
rename grado grade
rename grupo group
rename mod_sep type
rename ent state
rename sexo gender

replace level="1" if level=="PRIMARIA"
replace level="2" if level=="SECUNDARIA"

destring level, replace
label define level 1 "PRIMARIA" 2 "SECUNDARIA"
label values level level
drop if level==2

destring shift, replace
label define shift 1 "Morning" 2 "Afternoon" 3 "Evening"
label values shift shift

replace type="PRIVATE" if type=="PARTICULAR"

replace gender="0" if gender=="H"
replace gender="1" if gender=="M"
destring gender, replace
label define gender 0 "Male" 1 "Female"
label values gender gender

bysort cct shift grade group: gen n_students=_N
sort cct shift grade group id_num

save "$base\enlace08.dta", replace
*========================================================================*
/* ENLACE 2009 */
*========================================================================*
use "$data\ENLACE_2009\enlace2009.dta", clear

drop nvl_fce observacio cal_fce esp_50 mat_50 fce_50 copia nvl_esp nvl_mat entidad
rename nivel level
rename turno shift
rename cal_esp s_spa
rename cal_mat s_math
rename nofolio id_num
rename grado grade
rename grupo group
rename modalidad type
rename ent state
rename sexo gender

replace level="1" if level=="PRIMARIA"
replace level="2" if level=="SECUNDARIA"

destring level, replace
label define level 1 "PRIMARIA" 2 "SECUNDARIA"
label values level level
drop if level==2

destring shift, replace
label define shift 1 "Morning" 2 "Afternoon" 3 "Evening"
label values shift shift

replace type="PRIVATE" if type=="PARTICULAR"

replace gender="0" if gender=="H"
replace gender="1" if gender=="M"
destring gender, replace
label define gender 0 "Male" 1 "Female"
label values gender gender

bysort cct shift grade group: gen n_students=_N
sort cct shift grade group id_num

save "$base\enlace09.dta", replace
*========================================================================*
/* ENLACE 2010 */
*========================================================================*
use "$data\ENLACE_2010\enlace2010.dta", clear

drop cal_new esp_50 variabl0 mat_50 nm new_50 nn copia
rename nivel level
rename turno shift
rename cal_esp s_spa
rename cal_mat s_math
rename nofolio id_num
rename grado grade
rename grupo group
rename mod_sep type
rename ent state
rename sexo gender

replace level="1" if level=="PRIMARIA"
replace level="2" if level=="SECUNDARIA"

destring level, replace
label define level 1 "PRIMARIA" 2 "SECUNDARIA"
label values level level
drop if level==2

destring shift, replace
label define shift 1 "Morning" 2 "Afternoon" 3 "Evening"
label values shift shift

replace type="PRIVATE" if type=="PARTICULAR"

replace gender="0" if gender=="H" | gender=="A"
replace gender="1" if gender=="M" | gender=="2" | gender=="F"
replace gender="0" if gender!="0" & gender!="1" & (c_sex=="H" | c_sex=="h")
replace gender="1" if gender!="0" & gender!="1" & (c_sex=="M" | c_sex=="m")
replace gender="" if gender!="0" & gender!="1"
destring gender, replace
label define gender 0 "Male" 1 "Female"
label values gender gender

bysort cct shift grade group: gen n_students=_N
sort cct shift grade group id_num

save "$base\enlace10.dta", replace
*========================================================================*
/* ENLACE 2011 */
*========================================================================*
use "$data\ENLACE_2011\enlace2011.dta", clear

drop cal_new esp_50 variabl0 mat_50 nm new_50 nn copia
rename nivel level
rename turno shift
rename cal_esp s_spa
rename cal_mat s_math
rename nofolio id_num
rename grado grade
rename grupo group
rename mod_sep type
rename ent state
rename sexo gender

replace level="1" if level=="PRIMARIA"
replace level="2" if level=="SECUNDARIA"

destring level, replace
label define level 1 "PRIMARIA" 2 "SECUNDARIA"
label values level level
drop if level==2

destring shift, replace
label define shift 1 "Morning" 2 "Afternoon" 3 "Evening"
label values shift shift

replace type="PRIVATE" if type=="PARTICULAR"

replace gender="1" if gender=="0" | gender=="F" | gender=="N"
replace gender="0" if gender=="H"
replace gender="1" if gender=="M"
replace gender="0" if gender!="0" & gender!="1" & (c_sex=="H" | c_sex=="h")
replace gender="1" if gender!="0" & gender!="1" & (c_sex=="M" | c_sex=="m")
replace gender="" if gender!="0" & gender!="1"
destring gender, replace
label define gender 0 "Male" 1 "Female"
label values gender gender

bysort cct shift grade group: gen n_students=_N
sort cct shift grade group id_num

save "$base\enlace11.dta", replace
*========================================================================*
/* ENLACE 2012 */
*========================================================================*
use "$data\ENLACE_2012\enlace2012.dta", clear

drop cal_cie variabl0 nm nc esp_50 mat_50 cie_50 copia cve_marg
rename nivel level
rename turno shift
rename cal_esp s_spa
rename cal_mat s_math
rename nofolio id_num
rename grado grade
rename grupo group
rename mod_sep type
rename ent state
rename sexo gender

replace level="1" if level=="PRIMARIA"
replace level="2" if level=="SECUNDARIA"

destring level, replace
label define level 1 "PRIMARIA" 2 "SECUNDARIA"
label values level level
drop if level==2

destring shift, replace
label define shift 1 "Morning" 2 "Afternoon" 3 "Evening"
label values shift shift

replace type="PRIVATE" if type=="PARTICULAR"

replace gender="0" if gender=="H"
replace gender="1" if gender=="M"
destring gender, replace
label define gender 0 "Male" 1 "Female"
label values gender gender

bysort cct shift grade group: gen n_students=_N
sort cct shift grade group id_num

save "$base\enlace12.dta", replace
*========================================================================*
/* ENLACE 2013 */
*========================================================================*
use "$data\ENLACE_2013\enlace2013.dta", clear

drop cal_fce cve_marg esp_50 variabl0 mat_50 nm fce_50 fce copia
rename nivel level
rename turno shift
rename cal_esp s_spa
rename cal_mat s_math
rename nofolio id_num
rename grado grade
rename grupo group
rename mod_sep type
rename ent state
rename sexo gender

replace level="1" if level=="PRIMARIA"
replace level="2" if level=="SECUNDARIA"

destring level, replace
label define level 1 "PRIMARIA" 2 "SECUNDARIA"
label values level level
drop if level==2

destring shift, replace
label define shift 1 "Morning" 2 "Afternoon" 3 "Evening"
label values shift shift

replace type="PRIVATE" if type=="PARTICULAR"

replace gender="0" if gender=="H"
replace gender="1" if gender=="M"
destring gender, replace
label define gender 0 "Male" 1 "Female"
label values gender gender

bysort cct shift grade group: gen n_students=_N
sort cct shift grade group id_num

save "$base\enlace13.dta", replace
*========================================================================*
/* Appending 2006-2013 ENLACE data */
*========================================================================*
foreach x in 06 07 08 09 10 11 12 13{
use "$base\enlace`x'.dta", clear
replace gender=0 if gender!=0 & gender!=1 & (c_sex=="H" | c_sex=="h")
replace gender=1 if gender!=0 & gender!=1 & (c_sex=="M" | c_sex=="m")
drop if level!=1
drop level c_sex c_state state
destring grade, replace
drop if curp==""
collapse (mean) s_spa s_math gender n_students, by(year cct shift grade)

merge m:m cct using "$base\d_schools.dta", force
drop if _merge!=3
drop _merge

drop if eng==.
drop if fts==1
drop if public==0
drop fts public
gen id_geo=state+id_mun+id_loc
save "$base\e`x'.dta", replace
}
clear
append using "$base\e06.dta" "$base\e07.dta" "$base\e08.dta" ///
"$base\e09.dta" "$base\e10.dta" "$base\e11.dta" "$base\e12.dta" ///
"$base\e13.dta", force

save "$base\school_base0613.dta", replace
*========================================================================*
use "$base\d_schools.dta", clear
drop if fts==1
drop if eng==.
drop if public==0
keep if year<=2008
keep cct year h_group
duplicates drop
reshape wide h_group, i(cct) j(year) 
rename h_group2006 hrs06
rename h_group2007 hrs07
rename h_group2008 hrs08
save "$base\hrs08.dta", replace
*========================================================================*
use "$base\school_base0613.dta", clear
duplicates drop
*keep if state=="10"
sum s_spa
gen ss=(s_spa-r(mean))/r(sd)
label var ss "Language"
sum s_math
gen sm=(s_math-r(mean))/r(sd)
label var sm "Math"
gen treat=1 if rural==0
replace treat=0 if rural==1
gen after=0 if year<=2010
replace after=1 if year>=2011
gen interact=after*treat
label var h_group "Hrs English"
label var interact "Urban*After"

merge m:m cct using "$base\hrs08.dta"
drop if _merge!=3
drop _merge
gen z=0
replace z=hrs06 if year>=2011
label var z "Pre06*After"

*========================================================================*
/* First stage */
areg h_group z gender n_students i.grade i.year if shift==1 & hrs06!=., absorb(cct) vce(cluster cct)
/* Reduced form */
areg ss z hrs06 gender n_students i.grade i.year if shift==1, absorb(cct) vce(cluster cct)

drop z
gen z=0
replace z=hrs06 if year>=2011
replace z=1 if z>0
label var z "Pre06*After"

/* First stage */
areg h_group z gender n_students i.grade i.year if shift==1 & hrs06!=., absorb(cct) vce(cluster cct)
/* Reduced form */
areg ss z hrs06 gender n_students i.grade i.year if shift==1, absorb(cct) vce(cluster cct)
*========================================================================*

eststo clear
eststo: areg ss h_group gender n_students i.grade i.year if shift==1 & hrs06!=., absorb(id_loc) vce(cluster cct)
eststo: areg ss h_group gender n_students i.grade i.year if shift==1 & hrs06!=., absorb(cct) vce(cluster cct)
eststo: areg h_group z gender n_students i.grade i.year if shift==1 & rural==0 & hrs06!=., absorb(cct) vce(cluster cct)
eststo: areg ss z hrs06 gender n_students i.grade i.year if shift==1, absorb(cct) vce(cluster cct)
eststo: ivreghdfe ss (h_group=z) hrs06 gender n_students i.grade i.year if shift==1 & hrs06!=., absorb(cct) robust cluster(cct)
esttab using "$doc\tab4.tex", ar2 se b(a2) title(English exposure and Language test scores \label{tab4}) label replace

eststo clear
eststo: areg sm h_group gender n_students i.grade i.year if shift==1 & hrs06!=., absorb(id_loc) vce(cluster cct)
eststo: areg sm h_group gender n_students i.grade i.year if shift==1 & hrs06!=., absorb(cct) vce(cluster cct)
eststo: areg h_group z hrs06 gender n_students i.grade i.year if shift==1, absorb(cct) vce(cluster cct)
eststo: areg sm z hrs06 gender n_students i.grade i.year if shift==1, absorb(cct) vce(cluster cct)
eststo: ivreghdfe sm (h_group=z) hrs06 gender n_students i.grade i.year if shift==1 & hrs06!=., absorb(cct) robust cluster(cct)
esttab using "$doc\tab5.tex", ar2 se b(a2) title(English exposure and Math test scores \label{tab5}) label replace
*========================================================================*
drop inter*
foreach x in 07 08 09 10 11 12 13{
gen inter`x'=0
replace inter`x'=hrs06 if year==20`x'

label var inter`x' "20`x'"
}

areg ss inter* i.year i.grade gender n_students if shift==1 & hrs06!=. & rural==0, absorb(cct) vce(cluster cct)
coefplot, vertical keep(inter*) yline(0) ytitle("DiD coefficient") ylabel(,nogrid) ///
xtitle("Years") graphregion(fcolor(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\pta_ss_sl.png", replace

areg sm inter* treat#year i.year i.grade gender n_students if shift==1 & hrs06!=., absorb(cct) vce(cluster cct)
coefplot, vertical keep(inter*) yline(0) ytitle("DiD coefficient") ylabel(,nogrid) ///
xtitle("Years") graphregion(fcolor(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\pta_sm_sl.png", replace
