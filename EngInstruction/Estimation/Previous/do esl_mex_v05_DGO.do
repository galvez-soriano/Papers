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

drop variabl0 nm nombre_mun observaci municipio
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

replace state="01" if state=="AGUASCALIENTES"
replace state="02" if state=="BAJA CALIFORNIA"
replace state="03" if state=="BAJA CALIFORNIA SUR"
replace state="04" if state=="CAMPECHE"
replace state="05" if state=="COAHUILA"
replace state="06" if state=="COLIMA"
replace state="07" if state=="CHIAPAS"
replace state="08" if state=="CHIHUAHUA"
replace state="09" if state=="DISTRITO FEDERAL"
replace state="10" if state=="DURANGO"
replace state="11" if state=="GUANAJUATO"
replace state="12" if state=="GUERRERO"
replace state="13" if state=="HIDALGO"
replace state="14" if state=="JALISCO"
replace state="15" if state=="M�XICO"
replace state="16" if state=="MICHOACAN"
replace state="17" if state=="MORELOS"
replace state="18" if state=="NAYARIT"
replace state="19" if state=="NUEVO LE�N"
replace state="20" if state=="OAXACA"
replace state="21" if state=="PUEBLA"
replace state="22" if state=="QUER�TARO"
replace state="23" if state=="QUINTANA ROO"
replace state="24" if state=="SAN LUIS POTOSI"
replace state="25" if state=="SINALOA"
replace state="26" if state=="SONORA"
replace state="27" if state=="TABASCO"
replace state="28" if state=="TAMAULIPAS"
replace state="29" if state=="TLAXCALA"
replace state="30" if state=="VERACRUZ"
replace state="31" if state=="YUCATAN"
replace state="32" if state=="ZACATECAS"
sort state
replace state="15" in 6648289/7815987
replace state="19" in 7815988/8139429
replace state="22" in 8139430/8286724

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

drop cal_cie variabl0 nm nc esp_50 mat_50 cie_50 copia margina
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
keep if state=="10"
replace gender=0 if gender!=0 & gender!=1 & (c_sex=="H" | c_sex=="h")
replace gender=1 if gender!=0 & gender!=1 & (c_sex=="M" | c_sex=="m")
drop if level!=1
drop level c_sex c_state state
destring grade, replace
*drop if curp==""

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

replace margina="" if margina=="SIN DATO"
replace margina="5" if margina=="MUY BAJO"
replace margina="4" if margina=="BAJO"
replace margina="3" if margina=="MEDIO"
replace margina="2" if margina=="ALTO"
replace margina="1" if margina=="MUY ALTO"
replace margina=cve_marg if margina==""
destring margina, replace
label define margina 5 "Very low" 4 "Low" 3 "Medium" 2 "High" 1 "Very high"
label values margina margina
drop cve_marg

save "$base\dgo0613.dta", replace
*========================================================================*
use "$base\dgo0613.dta", clear
collapse rural, by(cct year)
bysort cct: gen same_schools=_N
drop if same_schools!=8
drop same_schools
rename rural rural2
save "$base\dgo_rural.dta", replace

use "$base\dgo0613.dta", clear
merge m:m cct using "$base\dgo_rural.dta"
drop if _merge!=3
drop _merge
replace rural=rural2 if rural==.
drop rural2
order state id_mun id_loc id_geo rural cct shift grade group id_num year
sort state id_mun id_loc cct shift grade group id_num year
save "$base\dgo0613.dta", replace
*========================================================================*
use "$base\d_schools.dta", clear
keep if state=="10"
drop if fts==1
drop if eng==.
drop if public==0
keep if year==2006
keep cct year h_group
reshape wide h_group, i(cct) j(year) 
rename h_group2006 hrs06
save "$base\dgo_hrs06.dta", replace
*========================================================================*
use "$base\dgo0613.dta", clear
*set matsize 11000
duplicates drop

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

merge m:m cct using "$base\dgo_hrs06.dta"
drop if _merge!=3
drop _merge
gen z=0
replace z=hrs06 if year>=2011
label var z "Pre06*After"
*========================================================================*
/* First stage */
areg h_group z hrs06 gender n_students i.grade i.year if shift==1 & rural==1 & (year==2008 | year==2011), absorb(cct) vce(cluster cct)
areg h_group interact treat gender n_students i.grade i.year if shift==1, absorb(cct) vce(cluster cct)

eststo clear
eststo: areg h_group z hrs06 gender n_students i.grade i.year if shift==1 & rural==1 & (year==2008 | year==2011), absorb(cct) vce(cluster cct)
/* Reduced form */
eststo: areg ss z hrs06 gender n_students i.grade i.year if shift==1, absorb(id_loc) vce(cluster cct)
eststo: areg sm z hrs06 gender n_students i.grade i.year if shift==1, absorb(id_loc) vce(cluster cct)

drop z
gen z=0
replace z=hrs06 if year>=2011
*replace z=1 if z>0
label var z "Pre06*After"

/* First stage */
eststo: areg h_group z gender n_students i.grade i.year if shift==1 & hrs06!=., absorb(id_loc) vce(cluster cct)
/* Reduced form */
eststo: areg ss z hrs06 gender n_students i.grade i.year if shift==1, absorb(id_loc) vce(cluster cct)
eststo: areg sm z hrs06 gender n_students i.grade i.year if shift==1, absorb(id_loc) vce(cluster cct)
esttab using "$doc\tab_dgo.tex", ar2 se b(a2) title(English exposure and test scores (Durango) \label{tab3}) label replace
*========================================================================*

eststo clear
eststo: areg ss h_group gender n_students i.grade i.year if shift==1 & hrs06!=., absorb(id_loc) vce(cluster cct)
eststo: areg ss h_group gender n_students i.grade i.year if shift==1 & hrs06!=., absorb(cct) vce(cluster cct)
eststo: areg h_group z hrs06 gender n_students i.grade i.year if shift==1, absorb(id_loc) vce(cluster cct)
eststo: areg ss z hrs06 gender n_students i.grade i.year if shift==1, absorb(id_loc) vce(cluster cct)
eststo: ivreghdfe ss (h_group=z) hrs06 gender n_students i.grade i.year if shift==1 & hrs06!=., absorb(id_loc) robust cluster(cct)
esttab using "$doc\tab2.tex", ar2 se b(a2) title(English exposure and Language test scores (Durango) \label{tab2}) label replace

eststo clear
eststo: areg sm h_group gender n_students i.grade i.year if shift==1 & hrs06!=., absorb(id_loc) vce(cluster cct)
eststo: areg sm h_group gender n_students i.grade i.year if shift==1 & hrs06!=., absorb(cct) vce(cluster cct)
eststo: areg h_group z hrs06 gender n_students i.grade i.year if shift==1, absorb(id_loc) vce(cluster cct)
eststo: areg sm z hrs06 gender n_students i.grade i.year if shift==1, absorb(id_loc) vce(cluster cct)
eststo: ivreghdfe sm (h_group=z) hrs06 gender n_students i.grade i.year if shift==1 & hrs06!=., absorb(id_loc) robust cluster(cct)
esttab using "$doc\tab3.tex", ar2 se b(a2) title(English exposure and Math test scores (Durango) \label{tab3}) label replace
*========================================================================*
drop inter*
foreach x in 07 08 09 10 11 12 13{
gen inter`x'=0
replace inter`x'=hrs06 if year==20`x'
*replace inter`x'=1 if inter`x'>0
label var inter`x' "20`x'"
}

areg ss inter* i.year i.grade gender n_students if shift==1, absorb(cct) vce(cluster cct)
coefplot, vertical keep(inter*) yline(0) ytitle("DiD coefficient") ylabel(,nogrid) ///
xtitle("Years") graphregion(fcolor(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\pta_ss.png", replace

areg sm inter* i.year i.grade gender n_students if shift==1, absorb(cct) vce(cluster cct)
coefplot, vertical keep(inter*) yline(0) ytitle("DiD coefficient") ylabel(,nogrid) ///
xtitle("Years") graphregion(fcolor(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\pta_sm.png", replace

*========================================================================*
/* Here I am trying triple interactions */
foreach x in 07 08 09 10 11 12 13{
gen tinter`x'=inter`x'*treat
}
foreach x in 07 08 09 10 11 12 13{
gen after_treat`x'=0
replace after_treat`x'=1 if treat==1 & year==20`x'
}
gen urban_pre=0
replace urban_pre=1 if treat==1 & h_group==hrs06
areg ss tinter* inter* after_treat* i.year i.grade gender n_students trend2 if shift==1, absorb(cct) vce(cluster cct)
coefplot, vertical keep(tinter*) yline(0) ytitle("DiD coefficient") ylabel(,nogrid) ///
xtitle("Years") graphregion(fcolor(white)) scheme(s2mono) ciopts(recast(rcap))
