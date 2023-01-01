*========================================================================*
* The effect of the English program on school achievement
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\Oscar Galvez\Documents\Papers\Working papers\Peer effects in middle schools\Data"
gl base= "C:\Users\Oscar Galvez\Documents\Papers\Current\English on labor outcomes\Data"
gl doc= "C:\Users\Oscar Galvez\Documents\Papers\Current\English on labor outcomes\Doc_NL"
*========================================================================*
/* ENLACE 2007 */
*========================================================================*
use "$data\2007\enlace2007.dta", clear

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

* Droping observations of middle school
drop if level==2

destring shift, replace
label define shift 1 "Morning" 2 "Afternoon" 3 "Evening"
label values shift shift

replace type="PRIVATE" if type=="PARTICULAR"

/*
sort type
replace type = "INDIGENOUS" in 7408719/7831474
*/

destring state, replace
label define state 1 AGS 2 BC 3 BCS 4 CAMP 5 COAH 6 COL 7 CHIA 8 CHIH 9 DF 10 ///
DGO 11 GTO 12 GRO 13 HGO 14 JAL 15 MEX 16 MICH 17 MOR 18 NAY 19 NL 20 OAX ///
21 PUE 22 QUER 23 QRO 24 SLP 25 SIN 26 SON 27 TAB 28 TAM 29 TLAX 30 VER ///
31 YUC 32 ZAC
label values state state

drop if grade=="3"
*drop if grade=="4"

replace gender="0" if gender=="H"
replace gender="1" if gender=="M"
destring gender, replace
label define gender 0 "Male" 1 "Female"
label values gender gender

bysort cct grade group: gen n_students=_N
sort cct shift grade group id_num
drop if state!=19
drop variabl0 nm
gen after=0

drop if group=="0"
sort group
drop in 153347/153350
sort cct grade group

save "$base\DBase_NL\enlace07.dta", replace
*========================================================================*
/*
use "$base\ENLACE\censo_10_nl.dta", clear

foreach var of varlist _all{
destring `var', replace
}
rename entidad state
drop if loc==0
drop if loc==9998
drop if loc==9999

gen rururb=.
replace rururb=1 if tam_loc<5
replace rururb=0 if tam_loc>=5

rename nom_loc localidad

keep state mun loc rururb localidad

tostring state, replace format(%02.0f) force
tostring mun, replace format(%03.0f) force
tostring loc, replace format(%04.0f) force

gen str id_loc = (state+mun+loc)

gen x=upper(localidad)
drop localidad
rename x localidad

save "$base\ENLACE\censo10.dta", replace
*/
use "$base\ENLACE\censo10.dta", clear
merge m:m localidad using "$base\ENLACE\schools.dta"
*sort _merge
drop if _merge==1
drop if _merge==2
drop _merge

rename gradodemarginacion margina
keep id_loc cct rururb margina

merge m:m cct using "$base\DBase_NL\enlace07.dta"
drop if _merge==1
drop if _merge==2
drop _merge nombre_mun

sort id_loc cct grade group

collapse rururb state s_spa s_math gender n_students after, by(cct ///
type shift grade group)
save "$base\DBase_NL\07.dta", replace

use "$base\DBase_NL\07.dta", clear
merge m:m cct shift using "$base\DBase_NL\stat911_07.dta"
drop if _merge==1
drop if _merge==2
drop _merge
save "$base\DBase_NL\07.dta", replace

use "$base\FTS\fts0718.dta", clear
keep if year==2007
drop year
merge m:m cct using "$base\DBase_NL\07.dta"
drop if _merge==1
drop _merge

save "$base\DBase_NL\07.dta", replace

*========================================================================*
/* ENLACE 2008 */
*========================================================================*
use "$data\2008\enlace2008.dta", clear

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

destring shift, replace
label define shift 1 "Morning" 2 "Afternoon" 3 "Evening"
label values shift shift

replace type="PRIVATE" if type=="PARTICULAR"

/*
sort type
replace type = "INDIGENOUS" in 7914549/8350736

destring state, replace
label define state 1 AGS 2 BC 3 BCS 4 CAMP 5 COAH 6 COL 7 CHIA 8 CHIH 9 DF 10 ///
DGO 11 GTO 12 GRO 13 HGO 14 JAL 15 MEX 16 MICH 17 MOR 18 NAY 19 NL 20 OAX ///
21 PUE 22 QUER 23 QRO 24 SLP 25 SIN 26 SON 27 TAB 28 TAM 29 TLAX 30 VER ///
31 YUC 32 ZAC
label values state state
*/

drop if grade=="3"
*drop if grade=="4"

replace gender="0" if gender=="H"
replace gender="1" if gender=="M"
destring gender, replace
label define gender 0 "Male" 1 "Female"
label values gender gender

bysort cct grade group: gen n_students=_N
sort cct shift grade group id_num
/*
sort state
replace state = "NUEVO LEON" in 3727591/3968286
*/
drop if state!="NUEVO LEON"
gen after=1

save "$base\DBase_NL\enlace08.dta", replace
*========================================================================*
use "$base\ENLACE\censo10.dta", clear

merge m:m localidad using "$base\ENLACE\schools.dta"
sort _merge
drop if _merge==1
drop if _merge==2
drop _merge

rename gradodemarginacion margina
keep id_loc cct rururb margina

merge m:m cct using "$base\DBase_NL\enlace08.dta"
drop if _merge==1
drop if _merge==2
drop _merge

sort id_loc cct grade group
replace state="19"
destring state, replace

collapse rururb state s_spa s_math gender n_students after, by(cct ///
type shift grade group)
save "$base\DBase_NL\08.dta", replace

use "$base\DBase_NL\08.dta", clear
merge m:m cct shift using "$base\DBase_NL\stat911_08.dta"
drop if _merge==1
drop if _merge==2
drop _merge

save "$base\DBase_NL\08.dta", replace
*========================================================================*
/* ENLACE 2009 */
*========================================================================*
use "$data\2009\enlace2009p.dta", clear

drop nvl_fce observacio cal_fce esp_50 mat_50 fce_50 copia
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

destring shift, replace
label define shift 1 "Morning" 2 "Afternoon" 3 "Evening"
label values shift shift

replace type="PRIVATE" if type=="PARTICULAR"

/*
sort type
replace type = "INDIGENOUS" in 6968867/7315473
*/

destring state, replace
label define state 1 AGS 2 BC 3 BCS 4 CAMP 5 COAH 6 COL 7 CHIA 8 CHIH 9 DF 10 ///
DGO 11 GTO 12 GRO 13 HGO 14 JAL 15 MEX 16 MICH 17 MOR 18 NAY 19 NL 20 OAX ///
21 PUE 22 QUER 23 QRO 24 SLP 25 SIN 26 SON 27 TAB 28 TAM 29 TLAX 30 VER ///
31 YUC 32 ZAC
label values state state

drop if grade=="3"
*drop if grade=="4"

replace gender="0" if gender=="H"
replace gender="1" if gender=="M"
destring gender, replace
label define gender 0 "Male" 1 "Female"
label values gender gender

bysort cct grade group: gen n_students=_N
sort cct shift grade group id_num
drop if state!=19
drop nvl_esp nvl_mat
gen after=1

save "$base\DBase_NL\enlace09.dta", replace
*========================================================================*
use "$base\ENLACE\censo10.dta", clear

merge m:m localidad using "$base\ENLACE\schools.dta"
sort _merge
drop if _merge==1
drop if _merge==2
drop _merge

rename gradodemarginacion margina
keep id_loc cct rururb margina

merge m:m cct using "$base\DBase_NL\enlace09.dta"
drop if _merge==1
drop if _merge==2
drop _merge

sort id_loc cct grade group

collapse rururb state s_spa s_math gender n_students after, by(cct ///
type shift grade group)
save "$base\DBase_NL\09.dta", replace

use "$base\DBase_NL\09.dta", clear
merge m:m cct shift using "$base\DBase_NL\stat911_09.dta"
drop if _merge==1
drop if _merge==2
drop _merge

save "$base\DBase_NL\09.dta", replace
*========================================================================*
/* ENLACE 2006 */
*========================================================================*
use "$data\2006\enlace2006.dta", clear

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

destring state, replace
label define state 1 AGS 2 BC 3 BCS 4 CAMP 5 COAH 6 COL 7 CHIA 8 CHIH 9 DF 10 ///
DGO 11 GTO 12 GRO 13 HGO 14 JAL 15 MEX 16 MICH 17 MOR 18 NAY 19 NL 20 OAX ///
21 PUE 22 QUER 23 QRO 24 SLP 25 SIN 26 SON 27 TAB 28 TAM 29 TLAX 30 VER ///
31 YUC 32 ZAC
label values state state

drop if grade=="3"
*drop if grade=="4"

replace gender="0" if gender=="H"
replace gender="1" if gender=="M"
destring gender, replace
label define gender 0 "Male" 1 "Female"
label values gender gender

bysort cct grade group: gen n_students=_N
sort cct shift grade group id_num
drop if state!=19
gen after=2

save "$base\DBase_NL\enlace06.dta", replace
*========================================================================*
use "$base\ENLACE\censo10.dta", clear

merge m:m localidad using "$base\ENLACE\schools.dta"
sort _merge
drop if _merge==1
drop if _merge==2
drop _merge

rename gradodemarginacion margina
keep id_loc cct rururb margina

merge m:m cct using "$base\DBase_NL\enlace06.dta"
drop if _merge==1
drop if _merge==2
drop _merge

sort id_loc cct grade group

collapse rururb state s_spa s_math gender n_students after, by(cct ///
type shift grade group)
save "$base\DBase_NL\06.dta", replace

use "$base\DBase_NL\06.dta", clear
merge m:m cct shift using "$base\DBase_NL\stat911_06.dta"
drop if _merge==1
drop if _merge==2
drop _merge

save "$base\DBase_NL\06.dta", replace
*========================================================================*
/* Appending 2006 and 2007 data */
*========================================================================*
clear
append using "$base\DBase_NL\06.dta" "$base\DBase_NL\07.dta", force
duplicates drop

drop if grade=="4"
drop if type=="PRIVATE"
replace fts=0 if fts==.
drop if fts==1
bysort cct shift grade group: gen panel=_N
drop if panel!=2
drop panel
bysort cct after shift grade: gen n_group=_N

gen treat=.
replace treat=1 if grade=="5"
replace treat=0 if grade=="6"

recode after (0 = 1) (2 = 0)

gen after_treat=after*treat


save "$base\DBase_NL\dbase0607.dta", replace
*========================================================================*
/* Appending 2007 and 2008 data */
*========================================================================*
clear
append using "$base\DBase_NL\07.dta" "$base\DBase_NL\08.dta", force
duplicates drop

drop if grade=="4"
drop if type=="PRIVATE"
replace fts=0 if fts==.
drop if fts==1
bysort cct shift grade group: gen panel=_N
drop if panel!=2
drop panel
bysort cct after shift grade: gen n_group=_N

gen treat=.
replace treat=1 if grade=="5"
replace treat=0 if grade=="6"
replace after=1 if after==3

gen after_treat=after*treat

save "$base\DBase_NL\dbase0708.dta", replace
*========================================================================*
/* Appending 2007 and 2009 data */
*========================================================================*
clear
append using "$base\DBase_NL\07.dta" "$base\DBase_NL\09.dta", force
duplicates drop

drop if grade=="4"
drop if type=="PRIVATE"
replace fts=0 if fts==.
drop if fts==1
bysort cct shift grade group: gen panel=_N
drop if panel!=2
drop panel
bysort cct after shift grade: gen n_group=_N

gen treat=.
replace treat=1 if grade=="5"
replace treat=0 if grade=="6"

gen after_treat=after*treat

save "$base\DBase_NL\dbase0709.dta", replace
*========================================================================*
/* Descriptive statistics */
*========================================================================*
use "$base\DBase_NL\dbase0708.dta", clear
*gen teachers=teach_elem+teach_midle+teach_high+teach_colle+teach_mast+teach_phd
ttest s_spa, by(treat) uneq
ttest s_math, by(treat) uneq
ttest gender, by(treat) uneq
ttest n_students, by(treat) uneq
ttest n_group, by(treat) uneq

ttest indig_stud, by(after) uneq 
ttest anglo_stud, by(after) uneq 
ttest latino_stud, by(after) uneq
ttest teach_eng, by(after) uneq
ttest teach_mast, by(after) uneq
ttest hours_eng, by(after) uneq
*ttest teachers, by(after) uneq
*========================================================================*
/* Regressions 2007-2008 */
*========================================================================*
use "$base\DBase_NL\dbase0708.dta", clear
sum s_spa
replace s_spa=(s_spa-r(mean))/r(sd)
sum s_math
replace s_math=(s_math-r(mean))/r(sd)

label var s_spa "Spanish score"
label var s_math "Math score"
label var after_treat "After*Treat"
label var after "After"
label var treat "Treat"
label var gender "Female"
label var n_students "Students"
label var n_group "Sections"

* Spanish test scores
eststo clear
eststo: quietly reg s_spa after_treat after treat, robust
eststo: quietly reg s_spa after_treat after treat gender n_students ///
n_group, robust
eststo: quietly reg s_spa after_treat after treat gender n_students ///
n_group indig_stud anglo_stud latino_stud teach_eng teach_mast, robust

esttab using "$doc\tab3.tex", ar2 se b(a2) title(Difference in ///
differences results (Spanish test scores) \label{tab3}) label replace

* Math test scores
eststo clear
eststo: quietly reg s_math after_treat after treat, robust
eststo: quietly reg s_math after_treat after treat gender n_students ///
n_group, robust
eststo: quietly reg s_math after_treat after treat gender n_students ///
n_group indig_stud anglo_stud latino_stud teach_eng teach_mast, robust

esttab using "$doc\tab4.tex", ar2 se b(a2) title(Difference in ///
differences results (Math test scores) \label{tab4}) label replace

*========================================================================*
/* Regressions placebo test*/
*========================================================================*
use "$base\DBase_NL\dbase0607.dta", clear

sum s_spa
replace s_spa=(s_spa-r(mean))/r(sd)
sum s_math
replace s_math=(s_math-r(mean))/r(sd)

label var s_spa "Spanish score"
label var s_math "Math score"
label var after_treat "After*Treat"
label var after "After"
label var treat "Treat"
label var gender "Female"
label var n_students "Students"
label var n_group "Sections"

* Spanish test scores
eststo clear
eststo: quietly reg s_spa after_treat after treat gender n_students ///
n_group indig_stud anglo_stud latino_stud teach_eng teach_mast, robust
* Math test scores
eststo: quietly reg s_math after_treat after treat gender n_students ///
n_group indig_stud anglo_stud latino_stud teach_eng teach_mast, robust

esttab using "$doc\tab5.tex", ar2 se b(a2) title(Placebo test ///
\label{tab5}) label replace

*========================================================================*
/* Regressions 2007-2009 */
*========================================================================*
use "$base\DBase_NL\dbase0709.dta", clear
sum s_spa
replace s_spa=(s_spa-r(mean))/r(sd)
sum s_math
replace s_math=(s_math-r(mean))/r(sd)

label var s_spa "Spanish score"
label var s_math "Math score"
label var after_treat "After*Treat"
label var after "After"
label var treat "Treat"
label var gender "Female"
label var n_students "Students"
label var n_group "Sections"

* Spanish test scores
eststo clear
eststo: quietly reg s_spa after_treat after treat, robust
eststo: quietly reg s_spa after_treat after treat gender n_students ///
n_group, robust
eststo: quietly reg s_spa after_treat after treat gender n_students ///
n_group indig_stud anglo_stud latino_stud teach_eng teach_mast, robust

esttab using "$doc\tab6.tex", ar2 se b(a2) title(Difference in ///
differences results (Spanish test scores) \label{tab6}) label replace

* Math test scores
eststo clear
eststo: quietly reg s_math after_treat after treat, robust
eststo: quietly reg s_math after_treat after treat gender n_students ///
n_group, robust
eststo: quietly reg s_math after_treat after treat gender n_students ///
n_group indig_stud anglo_stud latino_stud teach_eng teach_mast, robust

esttab using "$doc\tab7.tex", ar2 se b(a2) title(Difference in ///
differences results (Math test scores) \label{tab7}) label replace
