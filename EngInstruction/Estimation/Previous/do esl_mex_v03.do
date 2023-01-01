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
drop if grade!="5" & grade!="6"
save "$base\e`x'.dta", replace
}
clear
append using "$base\e06.dta" "$base\e07.dta" "$base\e08.dta" ///
"$base\e09.dta" "$base\e10.dta" "$base\e11.dta" "$base\e12.dta" ///
"$base\e13.dta", force
*duplicates drop
drop mun cve_marg margina

merge m:m cct using "$base\d_schools.dta", force
drop if _merge!=3
drop _merge

drop if fts==1
drop if eng==.
destring grade, replace
*keep if year>=2009
drop if public==0
drop fts public
gen id_geo=state+id_mun+id_loc
save "$base\base0613.dta", replace
*========================================================================*
use "$base\base0613.dta", clear
drop if curp==""
foreach x in 07 08 09 10 11 12 13{
gen inter`x'=0
replace inter`x'=1 if eng==1 & year==20`x'

label var inter`x' "20`x'"
}
sum s_spa
gen ss=(s_spa-r(mean))/r(sd)
label var ss "Language"
sum s_math
gen sm=(s_math-r(mean))/r(sd)
label var sm "Math"

areg ss inter* eng gender n_students i.grade i.year, absorb(cct) vce(cluster cct)
coefplot, vertical keep(inter*) yline(0) ytitle("DiD coefficient") ylabel(,nogrid) ///
xtitle("Years") graphregion(fcolor(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graph06.png", replace 

areg sm inter* eng gender n_students total_stud h_group teach_g i.grade i.year, absorb(cct) vce(cluster cct)
coefplot, vertical keep(inter*) yline(0) ytitle("DiD coefficient") ylabel(,nogrid) ///
xtitle("Years") graphregion(fcolor(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graph07.png", replace

*eststo clear
eststo: areg ss eng gender n_students i.grade i.year, absorb(cct) vce(cluster cct)
eststo: areg sm eng gender n_students i.grade i.year, absorb(cct) vce(cluster cct)
esttab using "$doc\tab1.tex", ar2 se b(a2) title(Structural equation \label{tab1}) label replace

*========================================================================*
use "$base\d_schools.dta", clear
drop if fts==1
gen id_geo=state+id_mun+id_loc

eststo clear
eststo: areg eng total_stud total_groups i.year, absorb(id_geo) vce(cluster id_geo)

esttab using "$doc\tab4.tex", ar2 se b(a2) title(First stage \label{tab4}) label replace
