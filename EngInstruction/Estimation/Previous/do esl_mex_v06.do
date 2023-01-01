*========================================================================*
* The effect of the English program on student achievement
*========================================================================*
/* Working with ENLACE test data to create the database with information
of students achievement */
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
replace gender=0 if gender!=0 & gender!=1 & (c_sex=="H" | c_sex=="h")
replace gender=1 if gender!=0 & gender!=1 & (c_sex=="M" | c_sex=="m")
drop if level!=1
drop level c_sex c_state state
destring grade, replace
keep if grade==6
*keep if grade>=5
*keep if grade<=4
merge m:m cct year using "$base\d_schools.dta", force
drop if _merge!=3
drop _merge
merge m:m cct using "$base\sw_eng.dta"
keep if _merge==3
drop _merge

drop if eng==.
drop if fts==1
drop if public==0
drop fts public
gen id_geo=state+id_mun+id_loc
*collapse (mean) s_spa s_math, by(grade year)
save "$base\e`x'.dta", replace
}
clear
append using "$base\e06.dta" "$base\e07.dta" "$base\e08.dta" ///
"$base\e09.dta" "$base\e10.dta" "$base\e11.dta" "$base\e12.dta" ///
"$base\e13.dta", force

/*label var year "Year"
twoway line s_spa year if grade=="3", msymbol(diamond) xlabel(2006(1)2013, ///
angle(vertical)) ytitle(Language test scores) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
scheme(s2mono) ///
|| line s_spa year if grade=="4" || line s_spa year if grade=="5" ///
|| line s_spa year if grade=="6", legend(label(1 "Third grade") label(2 ///
"Fourth grade") label(3 "Fifth grade") label(4 "Sixth grade"))
graph export "$doc\graph10.png", replace

twoway line s_spa year if grade=="3", msymbol(diamond) xlabel(2006(1)2013, ///
angle(vertical)) ytitle(Math test scores) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
scheme(s2mono) ///
|| line s_spa year if grade=="4" || line s_spa year if grade=="5" ///
|| line s_spa year if grade=="6", legend(label(1 "Third grade") label(2 ///
"Fourth grade") label(3 "Fifth grade") label(4 "Sixth grade"))
graph export "$doc\graph11.png", replace*/

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

save "$base\base0613_6.dta", replace
*========================================================================*
/*use "$base\base0613_34.dta", clear
collapse rural, by(cct year)
bysort cct: gen same_schools=_N
drop if same_schools!=8
drop same_schools
rename rural rural2
save "$base\base_rural.dta", replace
*/
use "$base\base0613_6.dta", clear
merge m:m cct using "$base\base_rural.dta"
drop if _merge!=3
drop _merge
replace rural=rural2 if rural==.
drop rural2
order state id_mun id_loc id_geo rural cct shift grade group id_num year
sort state id_mun id_loc cct shift grade group id_num year
save "$base\base0613_6.dta", replace
*========================================================================*
use "$base\base0613_6.dta", clear
sum s_spa
gen ss=(s_spa-r(mean))/r(sd)
label var ss "Language"
sum s_math
gen sm=(s_math-r(mean))/r(sd)
label var sm "Math"

eststo clear
eststo: areg ss h_group gender n_students i.grade i.year if shift==1, absorb(state) vce(cluster cct)
eststo: areg ss h_group gender n_students i.grade i.year if shift==1, absorb(cct) vce(cluster cct)
eststo: areg sm h_group gender n_students i.grade i.year if shift==1, absorb(state) vce(cluster cct)
eststo: areg sm h_group gender n_students i.grade i.year if shift==1, absorb(cct) vce(cluster cct)
esttab using "$doc\tab1.tex", ar2 se b(a2) title(English instruction and test scores \label{tab1}) label replace
*========================================================================*
/* Creating database from panel structure */
*========================================================================*
foreach x in 06 07 08 09 10 11 12 13{
use "$base\enlace`x'.dta", clear
replace gender=0 if gender!=0 & gender!=1 & (c_sex=="H" | c_sex=="h")
replace gender=1 if gender!=0 & gender!=1 & (c_sex=="M" | c_sex=="m")
drop if level!=1
drop level c_sex c_state state
destring grade, replace
merge m:m cct year using "$base\d_schools.dta", force
drop if _merge!=3
drop _merge
merge m:m cct using "$base\sw_eng.dta"
keep if _merge==3
drop _merge

drop if eng==.
drop if fts==1
drop if shift!=1
drop if public==0
drop if type!="GENERAL"
drop if curp==""
drop if dob_year==""
drop if dob_year=="**"
gen id_geo=state+id_mun+id_loc
gen c_check=substr(curp,18,1)
drop if c_check==""
drop if c_check=="*"
replace teach_colle=teach_colle/total_groups
replace teach_mast=teach_mast/total_groups
drop fts public shift id_num group type dob_month year indig_stud anglo_stud ///
latino_stud other_stud disabil high_abil teach_phd school_supp_exp uniform_exp ///
tuition public sw_eng eng teach_eng hours_eng total_groups total_stud id_mun ///
id_loc c_check groups_* group_20* had_eng teach_elem teach_midle teach_high

duplicates drop

gen ss=.
gen sm=.

/*foreach i in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 ///
21 22 23 24 25 26 27 28 29 30 31 32 {
sum s_spa if state=="`i'" & grade==3
replace ss=(s_spa-r(mean))/r(sd) if state=="`i'" & grade==3
}*/

foreach i in 3 4 5 6 {
sum s_spa if grade==`i'
replace ss=(s_spa-r(mean))/r(sd) if grade==`i'
sum s_math if grade==`i'
replace sm=(s_math-r(mean))/r(sd) if grade==`i'
}

rename grade grade`x'
rename ss ss`x'
rename sm sm`x'
rename h_group h_group`x'
rename teach_g teach_g`x'
rename teach_colle teach_colle`x'
rename teach_mast teach_mast`x'
rename n_students n_students`x'
save "$base\e`x'.dta", replace
}
*========================================================================*
/* To create panel with raw scores */
/*clear
foreach x in 06 07 08 09 10 11 12 13{
use "$base\e`x'.dta", clear
drop ss`x' sm`x'
gen ss`x'=.
replace ss`x'=s_spa
gen sm`x'=.
replace sm`x'=s_math
save "$base\e_raw`x'.dta", replace
}
use "$base\e_raw06.dta", clear
foreach x in 07 08 09 10 11 12 13{
merge m:m curp using "$base\e_raw`x'.dta"
drop _merge
}
drop cve_marg margina
save "$base\panel0613.dta", replace*/
*========================================================================*
/* To create panel with standardized test scores */
use "$base\e06.dta", clear
foreach x in 07 08 09 10 11 12 13{
merge m:m curp using "$base\e`x'.dta"
drop _merge
}
drop cve_marg margina
save "$base\panel0613.dta", replace
*========================================================================*
use "$base\panel0613.dta", clear
order id_geo cct curp dob_year rural gender grade* s_spa* s_math* h_group* 

egen h_eng=rowtotal(h_group06 h_group07 h_group08 h_group09 h_group10 ///
h_group11 h_group12 h_group13)
drop h_group*

egen t_eng=rowtotal(teach_g06 teach_g07 teach_g08 teach_g09 teach_g10 ///
teach_g11 teach_g11 teach_g13)
drop teach_g*

egen t_colle=rowtotal(teach_colle06 teach_colle07 teach_colle08 teach_colle09 ///
teach_colle10 teach_colle11 teach_colle12 teach_colle13)
drop teach_colle*

egen t_mast=rowtotal(teach_mast06 teach_mast07 teach_mast08 teach_mast09 ///
teach_mast10 teach_mast11 teach_mast12 teach_mast13)
drop teach_mast*

gen n_stud=.
*replace n_stud=n_students06 if grade06==6
*replace n_stud=n_students07 if grade07==6
replace n_stud=n_students08 if grade08==6
replace n_stud=n_students09 if grade09==6
replace n_stud=n_students10 if grade10==6
replace n_stud=n_students11 if grade11==6
replace n_stud=n_students12 if grade12==6
replace n_stud=n_students13 if grade13==6

drop n_students*

gen language6=.
*replace language6=ss06 if grade06==6
*replace language6=ss07 if grade07==6
replace language6=ss08 if grade08==6
replace language6=ss09 if grade09==6
replace language6=ss10 if grade10==6
replace language6=ss11 if grade11==6
replace language6=ss12 if grade12==6
replace language6=ss13 if grade13==6

gen language5=.
*replace language5=ss06 if grade06==5
*replace language5=ss07 if grade07==5
replace language5=ss08 if grade08==5
replace language5=ss09 if grade09==5
replace language5=ss10 if grade10==5
replace language5=ss11 if grade11==5
replace language5=ss12 if grade12==5

gen math6=.
*replace math6=sm06 if grade06==6
*replace math6=sm07 if grade07==6
replace math6=sm08 if grade08==6
replace math6=sm09 if grade09==6
replace math6=sm10 if grade10==6
replace math6=sm11 if grade11==6
replace math6=sm12 if grade12==6
replace math6=sm13 if grade13==6

gen math5=.
*replace math5=sm06 if grade06==5
*replace math5=sm07 if grade07==5
replace math5=sm08 if grade08==5
replace math5=sm09 if grade09==5
replace math5=sm10 if grade10==5
replace math5=sm11 if grade11==5
replace math5=sm12 if grade12==5

gen cohort=""
*replace cohort="95" if grade06==6
*replace cohort="96" if grade07==6
replace cohort="97" if grade08==6
replace cohort="98" if grade09==6
replace cohort="99" if grade10==6
replace cohort="00" if grade11==6
replace cohort="01" if grade12==6
replace cohort="02" if grade13==6

foreach x in 06 07 08 09 10 11 12 13{
replace grade`x'=grade`x'/grade`x'
}
egen ny=rowtotal(grade06 grade07 grade08 grade09 grade10 ///
grade11 grade12 grade13)

replace h_eng=h_eng/ny
replace t_eng=t_eng/ny
replace t_colle=t_colle/ny
replace t_mast=t_mast/ny

drop if cohort==""
drop grade* s_spa* s_math* dob_year

save "$base\enlace_ogs.dta", replace
*========================================================================*
use "$base\enlace_ogs.dta", clear
destring cohort, replace
label var language6 "Language 6th"
label var math6 "Math 6th"
drop ss* sm* 
duplicates drop curp, force
gen curp_m=substr(curp,5,14)
duplicates drop curp_m, force
drop curp
rename curp_m curp
rename id_geo id_geo_s
rename state state_s
order curp cct h_eng
drop ny
*keep curp h_eng t_eng
*keep curp h_eng had_e t_eng t_colle t_mast
save "$base\prueba_enlace.dta", replace
*export delimited using "$base\enlace_banxico.csv", replace
*/

eststo clear
eststo: areg language6 h_eng language5 gender n_stud i.cohort, absorb(state) vce(cluster cct)
eststo: areg language6 h_eng language5 gender n_stud i.cohort, absorb(cct) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud i.cohort, absorb(state) vce(cluster cct)
eststo: areg math6 h_eng math5 gender n_stud i.cohort, absorb(cct) vce(cluster cct)
esttab using "$doc\tab2.tex", ar2 se b(a2) title(English exposure and test scores \label{tab2}) label replace
