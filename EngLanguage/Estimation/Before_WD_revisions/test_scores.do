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
gl data= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngInstruct\Data\ENLACE"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngInstruct\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngLanguage\Doc"
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
*keep if grade==6
keep if grade>=5
*keep if grade<=4
merge m:1 cct year using "$base\dbs.dta", force
drop if _merge!=3
drop _merge
*merge m:m cct using "$base\sw_eng.dta"
*keep if _merge==3
*drop _merge

drop if eng==.
*drop if fts==1
drop if public==0
drop public
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

twoway line s_math year if grade=="3", msymbol(diamond) xlabel(2006(1)2013, ///
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

save "$base\base0613_5plus.dta", replace
*========================================================================*
/* Effect on test scores */
*========================================================================*
use "$base\base0613_5plus.dta", clear

keep if grade==5
replace first_treat=2006 if first_treat<2006
replace first_treat=0 if first_treat==2020

sum s_spa
gen ss=(s_spa-r(mean))/r(sd)
label var ss "Language"
sum s_math
gen sm=(s_math-r(mean))/r(sd)
label var sm "Math"

keep id_geo cct shift id_num year n_students rural fts indig_school treat first_treat gender ss sm
order id_geo cct shift id_num year n_students rural fts indig_school treat first_treat gender ss sm

collapse ss sm treat first_treat gender n_students rural fts indig_school shift, by(cct year)

/* Spanish test scores */
csdid ss gender n_students rural fts indig_school shift, ///
time(year) gvar(first_treat) method(dripw) vce(cluster cct) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_ss5)

csdid sm gender n_students rural fts indig_school shift, ///
time(year) gvar(first_treat) method(dripw) vce(cluster cct) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_sm5)

coefplot ///
(csdid_ss5, label("Spanish") connect(l) lpatt(solid) lcol(navy) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(rcap))) ///
(csdid_sm5, label("Mathematics") connect(l) lpatt(solid) lcol(blue) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Test score (standard deviation)", size(medium) height(5)) ///
ylabel(-.3(.15).3, labs(medium) grid format(%5.2f)) ///
xtitle("Years since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.3 0.3)) recast(connected) ///
legend(pos(1) ring(0) col(1) region(lcolor(white)) size(medium)) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_ts5.png", replace



use "$base\base0613_5plus.dta", clear

keep if grade==6
replace first_treat=2006 if first_treat<2006
replace first_treat=0 if first_treat==2020

sum s_spa
gen ss=(s_spa-r(mean))/r(sd)
label var ss "Language"
sum s_math
gen sm=(s_math-r(mean))/r(sd)
label var sm "Math"

keep id_geo cct shift id_num year n_students rural fts indig_school treat first_treat gender ss sm
order id_geo cct shift id_num year n_students rural fts indig_school treat first_treat gender ss sm

collapse ss sm treat first_treat gender n_students rural fts indig_school shift, by(cct year)

/* Spanish test scores */
csdid ss gender n_students rural fts indig_school shift, ///
time(year) gvar(first_treat) method(dripw) vce(cluster cct) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_ss6)

csdid sm gender n_students rural fts indig_school shift, ///
time(year) gvar(first_treat) method(dripw) vce(cluster cct) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_sm6)

coefplot ///
(csdid_ss6, label("Spanish") connect(l) lpatt(solid) lcol(navy) msymbol(O) mcolor(navy) ciopt(lc(navy) recast(rcap))) ///
(csdid_sm6, label("Mathematics") connect(l) lpatt(solid) lcol(blue) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Test score (standard deviation)", size(medium) height(5)) ///
ylabel(-.3(.15).3, labs(medium) grid format(%5.2f)) ///
xtitle("Years since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.3 0.3)) recast(connected) ///
legend(pos(1) ring(0) col(1) region(lcolor(white)) size(medium)) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_ts6.png", replace