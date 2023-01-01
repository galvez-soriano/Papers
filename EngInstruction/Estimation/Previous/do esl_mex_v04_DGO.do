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
clear
append using "$base\enlace06.dta" "$base\enlace07.dta" ///
"$base\enlace08.dta" "$base\enlace09.dta" "$base\enlace10.dta" ///
"$base\enlace11.dta" "$base\enlace12.dta" "$base\enlace13.dta", force
*duplicates drop
replace gender=0 if gender!=0 & gender!=1 & (c_sex=="H" | c_sex=="h")
replace gender=1 if gender!=0 & gender!=1 & (c_sex=="M" | c_sex=="m")

drop level c_sex cve_marg 
rename state state_e
rename margina margina_e

merge m:m cct using "$base\d_schools.dta", force
drop if _merge!=3
drop _merge
drop state_e mun

save "$base\dbase0613.dta", replace
*========================================================================*
use "$base\dbase0613.dta", clear
keep if state=="10"
drop if fts==1
drop if eng==.
destring grade, replace
drop if public==0
drop fts public mun margina
drop if curp==""
gen id_geo=id_mun+id_loc
save "$base\dgo0613.dta", replace
*========================================================================*
use "$base\dgo0613.dta", clear
keep if year<=2008
keep cct year h_group
reshape wide h_group, i(cct) j(year) 
rename h_group2006 hrs06
rename h_group2007 hrs07
rename h_group2008 hrs08
save "$base\dgo_hrs08.dta", replace
*========================================================================*
use "$base\dgo0613.dta", clear
duplicates drop
set matsize 11000

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

merge m:m cct using "$base\dgo_hrs08.dta"
drop if _merge!=3
drop _merge
gen z=hrs08*after
label var z "Pre08*After"

areg h_group interact treat gender n_students i.grade i.year if shift==1, absorb(id_loc) vce(cluster cct)
areg h_group interact treat gender n_students i.grade i.year if shift==1, absorb(cct) vce(cluster cct)
quietly tab cct, gen(cct_fe)
*drop cct
reg h_group interact gender n_students cct_fe* i.grade i.year if shift==1, vce(cluster cct)

areg h_group z gender n_students i.grade i.year if shift==1, absorb(id_loc) vce(cluster cct)

reg h_group interact gender n_students i.grade i.year treat if shift==1, vce(cluster cct)
reg h_group z gender n_students i.grade i.year if shift==1, vce(cluster cct)

eststo clear
eststo: areg ss h_group gender n_students i.grade i.year if shift==1 & interact!=., absorb(id_loc) vce(cluster cct)
eststo: areg ss h_group gender n_students i.grade i.year if shift==1 & interact!=., absorb(cct) vce(cluster cct)
eststo: areg h_group interact z gender n_students i.grade i.year if shift==1, absorb(id_loc) vce(cluster cct)
eststo: areg ss interact z gender n_students i.grade i.year if shift==1, absorb(id_loc) vce(cluster cct)
eststo: ivreghdfe ss (h_group=interact z) gender n_students i.grade i.year if shift==1, absorb(id_loc) robust cluster(cct)
esttab using "$doc\tab2.tex", ar2 se b(a2) title(English exposure and Language test scores (Durango) \label{tab2}) label replace

eststo clear
eststo: areg sm h_group gender n_students i.grade i.year if shift==1 & interact!=., absorb(id_loc) vce(cluster cct)
eststo: areg sm h_group gender n_students i.grade i.year if shift==1 & interact!=., absorb(cct) vce(cluster cct)
eststo: areg h_group interact z gender n_students i.grade i.year if shift==1, absorb(id_loc) vce(cluster cct)
eststo: areg sm interact z gender n_students i.grade i.year if shift==1, absorb(id_loc) vce(cluster cct)
eststo: ivreghdfe sm (h_group=interact z) gender n_students i.grade i.year if shift==1, absorb(id_loc) robust cluster(cct)
esttab using "$doc\tab3.tex", ar2 se b(a2) title(English exposure and Math test scores (Durango) \label{tab3}) label replace
*========================================================================*
drop interact
foreach x in 07 08 09 10 11 12 13{
gen inter`x'=0
replace inter`x'=1 if treat==1 & year==20`x'

label var inter`x' "20`x'"
}
bysort year cct shift grade group: egen ss_bar=sum(ss)
replace ss_bar=(ss_bar-ss)/(n_students-1)
bysort year cct shift grade group: egen sm_bar=sum(sm)
replace sm_bar=(sm_bar-sm)/(n_students-1)

areg ss inter* treat i.year i.grade gender n_students ss_bar if shift==1, absorb(cct) vce(cluster cct)
coefplot, vertical keep(inter*) yline(0) ytitle("DiD coefficient") ylabel(,nogrid) ///
xtitle("Years") graphregion(fcolor(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\pta_ss_urban.png", replace

areg sm inter* treat i.year i.grade gender n_students sm_bar if shift==1, absorb(cct) vce(cluster cct)
coefplot, vertical keep(inter*) yline(0) ytitle("DiD coefficient") ylabel(,nogrid) ///
xtitle("Years") graphregion(fcolor(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\pta_sm_urban.png", replace
