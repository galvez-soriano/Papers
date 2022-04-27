*========================================================================*
* This do file generates the list of all schools with their respective 
* state, municipality and locality codes.
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Ideas\Education\SM English\Data\Original"
gl github= "https://raw.githubusercontent.com/galvez-soriano/data/main/MexSchools"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New"
*========================================================================*
foreach x in 06 07 08{

use "$data\schools20`x'.dta", clear

rename ent state
rename turno shift
rename gradodemarginacion margina
replace shift="1" if shift=="MATUTINO"
replace shift="2" if shift=="VESPERTINO"
replace shift="3" if shift=="NOCTURNO"

destring shift, replace
keep cct shift state margina

save "$base\school20`x'.dta", replace
}
*========================================================================*
foreach x in 09 10 11 12 13{

use "$data\schools20`x'.dta", clear

rename ent state
rename clavedelaescuela cct
rename turno shift
rename GRADODEMARGINACIÓN margina
replace shift="1" if shift=="MATUTINO"
replace shift="2" if shift=="VESPERTINO"
replace shift="3" if shift=="NOCTURNO"
rename clavemun id_mun
rename claveloc id_loc

destring shift, replace
keep state cct shift id_mun id_loc margina

save "$base\school20`x'.dta", replace
}
*========================================================================*
use "$base\school2006.dta", clear
foreach x in 07 08 09 10 11 12 13{
merge m:m cct using "$base\school20`x'.dta", force
rename _merge m`x'
}
replace state="07" if state=="33"
replace state="15" if state=="34"
*========================================================================*
order state id_mun id_loc cct shift margina m*
egen check=rowtotal(m07 m08 m09 m10 m11 m12 m13)

drop if check!=21
/*drop if check<15
drop if check<=19 & (m07==. | m13==2)
drop check*/

replace margina="" if margina=="SIN DATO"
replace margina="0" if margina=="MUY BAJO"
replace margina="1" if margina=="BAJO"
replace margina="2" if margina=="MEDIO"
replace margina="3" if margina=="ALTO"
replace margina="4" if margina=="MUY ALTO"
destring margina, replace
label define margina 0 "Very low" 1 "Low" 2 "Medium" 3 "High" 4 "Very high"
label values margina margina

label define shift 1 "Morning" 2 "Afternoon" 3 "Night"
label values shift shift
*========================================================================*
* Private schools
*========================================================================*
gen classif=substr(cct,3,3)
gen priv=substr(cct,3,1)
gen public=1
replace public=0 if priv=="P"
replace public=0 if classif=="SBC" | classif=="SBH" | classif=="SCT"
drop classif priv
*========================================================================*
* Rural localities
*========================================================================*
replace id_loc="0001" if state=="09" & (id_mun=="002" | id_mun=="003" | ///
id_mun=="004" | id_mun=="005" | id_mun=="006" | id_mun=="007" | id_mun=="008" ///
| id_mun=="009" | id_mun=="010" | id_mun=="011" | id_mun=="012" | id_mun=="013" ///
| id_mun=="014" | id_mun=="015" | id_mun=="016" | id_mun=="017")

replace id_loc="0001" if state=="01" & id_mun=="001" & id_loc=="9994"
replace id_loc="0293" if state=="07" & id_mun=="012" & id_loc=="0000"
replace id_loc="0017" if state=="07" & id_mun=="014" & id_loc=="9001"
replace id_loc="0172" if state=="07" & id_mun=="017" & id_loc=="9561"
replace id_loc="0174" if state=="07" & id_mun=="023" & id_loc=="9001"
replace id_loc="0001" if state=="15" & id_mun=="031" & (id_loc=="0056" ///
| id_loc=="0058")
replace id_loc="0005" if state=="15" & id_mun=="115" & id_loc=="0027"
replace id_loc="0001" if state=="15" & id_mun=="121" & id_loc=="0109"
replace id_loc="0001" if state=="21" & id_mun=="156" & id_loc=="0120"
replace id_loc="0001" if state=="21" & id_mun=="186" & id_loc=="0008"

merge m:1 state id_mun id_loc using "$base\Rural2010.dta"
drop if _merge==2
drop _merge

replace rural=1 if rural==. & state=="05" & id_mun=="007" & id_loc=="0196"
replace rural=1 if rural==. & state=="07" & id_mun=="004" & id_loc=="9994"
replace rural=1 if rural==. & state=="07" & id_mun=="017" & (id_loc=="9560" ///
| id_loc=="0172" | id_loc=="9562" | id_loc=="9572")
replace rural=1 if rural==. & state=="07" & id_mun=="023" & id_loc=="9160"
replace rural=1 if rural==. & state=="07" & id_mun=="025" & id_loc=="9001"
replace rural=1 if rural==. & state=="07" & id_mun=="027" & id_loc=="0555"
replace rural=1 if rural==. & margina>=3
replace rural=0 if rural==. & margina<=1
replace rural=1 if rural==. & state=="15" & id_mun=="048" & id_loc=="0049"
replace rural=1 if rural==. & state=="21" & id_mun=="053" & id_loc=="0037"
replace rural=1 if rural==. & state=="26" & id_mun=="055" & id_loc=="9052"

label define rural 0 "Urban" 1 "Rural"
label values rural rural

label define public 0 "Private" 1 "Public"
label values public public
*========================================================================*
*keep state id_mun id_loc rural cct shift public margina
keep cct rural
order cct rural
drop if cct==""
save "$base\schools_06_13.dta", replace
*========================================================================*
/* geographical location with school id */
*========================================================================*
clear
foreach x in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 ///
21 22 23 24 25 26 27 28 29 30 31 32 {
append using "$github/elem_schools`x'.dta", force
}
keep cct clavedelaentidadfederativa Clavedelmunicipioodelegación clavedelalocalidad
rename clavedelaentidadfederativa state2
rename Clavedelmunicipioodelegación id_mun2
rename clavedelalocalidad id_loc2
tostring state2, replace format(%02.0f) force
tostring id_mun2, replace format(%03.0f) force
tostring id_loc2, replace format(%04.0f) force
save "$base\schools_geo.dta", replace
*========================================================================*
/* geographical location with locality name */
*========================================================================*
clear
foreach x in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 ///
21 22 23 24 25 26 27 28 29 30 31 32 {
append using "$github/elem_schools`x'.dta", force
}
keep cct nombredelocalidad
rename nombredelocalidad loc
replace loc= ustrlower( ustrregexra( ustrnormalize( loc, "nfd" ) , "\p{Mark}", "" )  )
merge m:m loc using "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Census\coordinates20"
drop if _merge!=3
rename _ámbito rururb
keep cct cve_ent cve_mun cve_loc rururb
save "$base\schools_cpv.dta", replace
