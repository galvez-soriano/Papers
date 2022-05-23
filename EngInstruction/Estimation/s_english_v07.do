*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
/* Working with the School Census (Stats 911) to create a database of 
school's characteristics and exposure to English instruction */
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EngInstruction/Stat911"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New"
gl doc= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Doc"
*========================================================================*
clear
foreach x in 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13{
append using "$data/stat911_`x'.dta"
}
order state id_mun id_loc cct shift year eng teach_eng hours_eng total_groups total_stud ///
indig_stud anglo_stud latino_stud other_stud disabil high_abil teach_elem  ///
teach_midle teach_high teach_colle teach_mast teach_phd school_supp_exp ///
uniform_exp tuition

sort cct shift year
label var year "Year"
label var eng "Had English program"
* Public schools
gen classif=substr(cct,3,3)
gen priv=substr(cct,3,1)
gen public=1
replace public=0 if priv=="P"
replace public=0 if classif=="SBC" | classif=="SBH" | classif=="SCT"
drop classif priv
gen had_eng=1 if eng==1 & year==2008
replace had_eng=0 if had_eng==.

/* Observed hours of English instruction */
gen h_group=hours_eng/total_groups
replace h_group=0 if h_group==.
label var h_group "Hours of English instruction (per class)"

/* Observed number of English teachers */
gen teach_g=teach_eng/total_groups
replace teach_g=0 if teach_g==.
label var teach_g "English teachers (per class)"

drop state
gen state=substr(cct,1,2)
tostring id_mun, replace format(%03.0f) force
tostring id_loc, replace format(%04.0f) force
rename rural rural2

merge m:m cct using "$base\schools_06_13.dta"
drop _merge
replace rural=rural2 if rural==.
drop rural2
rename rural rural2
merge m:m state id_mun id_loc using "$base\Rural2010.dta"
drop if _merge==2
replace rural2=rural if rural2==.
drop _merge rural
rename rural2 rural
merge m:m state id_mun id_loc using "$base\Rural2.dta"
replace rural=rural2 if rural==.
drop _merge rural2
merge m:m cct using "$base\schools_geo.dta"
drop if _merge==2
replace id_loc=id_loc2 if rural==.
drop _merge state2 id_mun2 id_loc2
merge m:m state id_mun id_loc using "$base\Rural2.dta"
replace rural=rural2 if rural==.
drop _merge rural2
rename rural rural2
merge m:m state id_mun id_loc using "$base\Rural2010.dta"
drop if _merge==2
replace rural2=rural if rural2==.
drop _merge rural
rename rural2 rural
merge m:m cct using "$base\schools_cpv.dta"
drop if _merge==2
replace id_loc=cve_loc if rural==.
replace rural=1 if rururb=="R" & rural==.
replace rural=0 if rururb=="U" & rural==.
drop _merge cve_ent cve_mun cve_loc rururb

save "$base\d_schools.dta", replace
*========================================================================*
use "$base\d_schools.dta", clear

label var state "State"
drop if cct==""
drop if year==.
bysort cct: gen same_school=_N
keep if same_school>=15 & same_school<=17
drop same_school

merge m:m cct year using "$base\fts0718.dta"
drop if _merge==2
drop _merge
replace fts=0 if fts==.

order state id_mun id_loc cct shift year
sort state id_mun id_loc cct shift year
save "$base\d_schools.dta", replace
*========================================================================*
/*use "$base\d_schools.dta", clear

twoway (histogram h_group if year==2008 & h_group<=5 & public==1, fraction color(gray)) (histogram h_group if ///
year==2011 & h_group<=5 & public==1, fraction fcolor(none) lcolor(black)), graphregion(fcolor(white)) ///
legend(off) 
graph export "$doc\graph04.png", replace

twoway (histogram h_group if year==2008 & h_group<=5 & h_group!=0 & public==1, fraction color(gray)) (histogram h_group if ///
year==2011 & h_group<=5 & h_group!=0 & public==1, fraction fcolor(none) lcolor(black)), graphregion(fcolor(white)) ///
legend(order(1 "2008" 2 "2011" ) pos(1) ring(0) col(1)) 
graph export "$doc\graph05.png", replace

twoway (histogram teach_g if year==2008 & teach_g<=1 & public==1, fraction color(gray)) (histogram teach_g if ///
year==2011 & teach_g<=1 & public==1, fraction fcolor(none) lcolor(black)), graphregion(fcolor(white)) ///
legend(off) 
graph export "$doc\graph06.png", replace

twoway (histogram teach_g if year==2008 & teach_g<=1 & teach_g!=0 & public==1, fraction color(gray)) (histogram teach_g if ///
year==2011 & teach_g<=1 & teach_g!=0 & public==1, fraction fcolor(none) lcolor(black)), graphregion(fcolor(white)) ///
legend(off) 
graph export "$doc\graph07.png", replace
*/
*========================================================================*
* Patterns in data															
*========================================================================*
use "$base\d_schools.dta", clear

destring state, replace
label define state 1 AGS 2 BC 3 BCS 4 CAMP 5 COAH 6 COL 7 CHIA 8 CHIH 9 MXC 10 ///
DGO 11 GTO 12 GRO 13 HGO 14 JAL 15 MEX 16 MICH 17 MOR 18 NAY 19 NL 20 OAX ///
21 PUE 22 QUER 23 QRO 24 SLP 25 SIN 26 SON 27 TAB 28 TAM 29 TLAX 30 VER ///
31 YUC 32 ZAC
label values state state

*========================================================================*
* Hours over time
*========================================================================*
/******************* National Level *******************/
label var year "Year"
bysort year: egen hours_year=mean(hours_eng) if public==1
label var hours_year "Hours of English instruction"

bysort year: egen hours_year_rural=mean(hours_eng) if rural==1 & public==1
label var hours_year_rural "Hours of English instruction"

bysort year: egen hours_year_urban=mean(hours_eng) if rural==0 & public==1
label var hours_year_urban "Hours of English instruction"
set scheme s1color
twoway line hours_year year, msymbol(diamond) xlabel(2006(1)2013, angle(vertical)) ///
ytitle(Avergae hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2009 2011, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_rural year || line hours_year_urban year, ///
legend(label(1 "National") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graph01.png", replace
/******************* Aguascalientes *******************/
bysort year: egen hours_yearAGS=mean(hours_eng) if public==1 & state==01
replace hours_yearAGS=hours_yearAGS+5.5 if year==2009
label var hours_year "Hours of English instruction"

bysort year: egen hours_year_ruralAGS=mean(hours_eng) if rural==1 & public==1 & state==01
label var hours_year_rural "Hours of English instruction"

bysort year: egen hours_year_urbanAGS=mean(hours_eng) if rural==0 & public==1 & state==01
replace hours_year_urbanAGS=hours_year_urbanAGS+10 if year==2009
label var hours_year_urban "Hours of English instruction"
set scheme s1color
twoway line hours_yearAGS year, msymbol(diamond) xlabel(1997(1)2013, angle(vertical)) ///
ytitle(Avergae hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2009 2011, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_ruralAGS year || line hours_year_urbanAGS year, ///
legend(label(1 "Aguscalientes") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graphAGS.png", replace
/******************* Baja California *******************/
bysort year: egen hours_yearBC=mean(hours_eng) if public==1 & state==02
label var hours_year "Hours of English instruction"

bysort year: egen hours_year_ruralBC=mean(hours_eng) if rural==1 & public==1 & state==02
label var hours_year_rural "Hours of English instruction"

bysort year: egen hours_year_urbanBC=mean(hours_eng) if rural==0 & public==1 & state==02
label var hours_year_urban "Hours of English instruction"
set scheme s1color
twoway line hours_yearBC year, msymbol(diamond) xlabel(1997(1)2013, angle(vertical)) ///
ytitle(Avergae hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2009 2011, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_ruralBC year || line hours_year_urbanBC year, ///
legend(label(1 "Baja California") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graphBC.png", replace
/******************* Chihuahua *******************/
bysort year: egen hours_yearCHIH=mean(hours_eng) if public==1 & state==08
label var hours_year "Hours of English instruction"

bysort year: egen hours_year_ruralCHIH=mean(hours_eng) if rural==1 & public==1 & state==08
label var hours_year_rural "Hours of English instruction"

bysort year: egen hours_year_urbanCHIH=mean(hours_eng) if rural==0 & public==1 & state==08
label var hours_year_urban "Hours of English instruction"
set scheme s1color
twoway line hours_yearCHIH year, msymbol(diamond) xlabel(1997(1)2013, angle(vertical)) ///
ytitle(Avergae hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2009 2011, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_ruralCHIH year || line hours_year_urbanCHIH year, ///
legend(label(1 "Chihuahua") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graphCHIH.png", replace
/******************* Coahuila *******************/
bysort year: egen hours_yearCOAH=mean(hours_eng) if public==1 & state==05
label var hours_year "Hours of English instruction"

bysort year: egen hours_year_ruralCOAH=mean(hours_eng) if rural==1 & public==1 & state==05
label var hours_year_rural "Hours of English instruction"

bysort year: egen hours_year_urbanCOAH=mean(hours_eng) if rural==0 & public==1 & state==05
label var hours_year_urban "Hours of English instruction"
set scheme s1color
twoway line hours_yearCOAH year, msymbol(diamond) xlabel(1997(1)2013, angle(vertical)) ///
ytitle(Avergae hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2009 2011, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_ruralCOAH year || line hours_year_urbanCOAH year, ///
legend(label(1 "Coahuila") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graphCOAH.png", replace
/******************* Nuevo Leon *******************/
bysort year: egen hours_yearNL=mean(hours_eng) if public==1 & state==19
label var hours_year "Hours of English instruction"

bysort year: egen hours_year_ruralNL=mean(hours_eng) if rural==1 & public==1 & state==19
label var hours_year_rural "Hours of English instruction"

bysort year: egen hours_year_urbanNL=mean(hours_eng) if rural==0 & public==1 & state==19
label var hours_year_urban "Hours of English instruction"
set scheme s1color
twoway line hours_yearNL year, msymbol(diamond) xlabel(1997(1)2013, angle(vertical)) ///
ytitle(Avergae hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2009 2011, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_ruralNL year || line hours_year_urbanNL year, ///
legend(label(1 "Nuevo Leon") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graphNL.png", replace
/******************* Sonora *******************/
bysort year: egen hours_yearSON=mean(hours_eng) if public==1 & state==26
label var hours_year "Hours of English instruction"

bysort year: egen hours_year_ruralSON=mean(hours_eng) if rural==1 & public==1 & state==26
label var hours_year_rural "Hours of English instruction"

bysort year: egen hours_year_urbanSON=mean(hours_eng) if rural==0 & public==1 & state==26
label var hours_year_urban "Hours of English instruction"
set scheme s1color
twoway line hours_yearSON year, msymbol(diamond) xlabel(1997(1)2013, angle(vertical)) ///
ytitle(Avergae hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2009 2011, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_ruralSON year || line hours_year_urbanSON year, ///
legend(label(1 "Sonora") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graphSON.png", replace
/******************* Tamaulipas *******************/
bysort year: egen hours_yearTAM=mean(hours_eng) if public==1 & state==28
label var hours_year "Hours of English instruction"

bysort year: egen hours_year_ruralTAM=mean(hours_eng) if rural==1 & public==1 & state==28
label var hours_year_rural "Hours of English instruction"

bysort year: egen hours_year_urbanTAM=mean(hours_eng) if rural==0 & public==1 & state==28
label var hours_year_urban "Hours of English instruction"
set scheme s1color
twoway line hours_yearTAM year, msymbol(diamond) xlabel(1997(1)2013, angle(vertical)) ///
ytitle(Avergae hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2009 2011, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_ruralTAM year || line hours_year_urbanTAM year, ///
legend(label(1 "Tamaulipas") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graphTAM.png", replace
/******************* Zacatecas *******************/
bysort year: egen hours_yearZAC=mean(hours_eng) if public==1 & state==32
label var hours_year "Hours of English instruction"

bysort year: egen hours_year_ruralZAC=mean(hours_eng) if rural==1 & public==1 & state==32
label var hours_year_rural "Hours of English instruction"

bysort year: egen hours_year_urbanZAC=mean(hours_eng) if rural==0 & public==1 & state==32
label var hours_year_urban "Hours of English instruction"
set scheme s1color
twoway line hours_yearZAC year, msymbol(diamond) xlabel(1997(1)2013, angle(vertical)) ///
ytitle(Avergae hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2009 2011, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_ruralZAC year || line hours_year_urbanZAC year, ///
legend(label(1 "Zacatecas") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graphZAC.png", replace
*========================================================================*
bysort year: egen et_year=mean(teach_eng) if public==1
label var et_year "Number of English teachers"

bysort year: egen et_year_rural=mean(teach_eng) if rural==1 & public==1
label var et_year_rural "Number of English teachers"

bysort year: egen et_year_urban=mean(teach_eng) if rural==0 & public==1
label var et_year_urban "Number of English teachers"

twoway line et_year year, msymbol(diamond) xlabel(2006(1)2013, angle(vertical)) ///
ytitle(Average number of English teachers) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2009 2011, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line et_year_rural year || line et_year_urban year, ///
legend(off)
graph export "$doc\graph02.png", replace
*========================================================================*
/* English instruction by state */
gen hg_2008=h_group if year==2008
gen hg_2011=h_group if year==2011

graph hbar hg_2008 hg_2011 if public==1, over(state) ytitle(Hours ///
of English instruction) graphregion(fcolor(white)) title(Weekly hours of ///
English instruction by state) legend( label(1 "2008") ///
label(2 "2011") pos(3) ring(0) col(1)) scheme(s2mono) ///
note("Note: Hours of English instruction calculated dividing total hours in a school by number of classes", span)
*graph export "$doc\graph_states.png", replace

/* English instruction by state, by rural*/
graph hbar hg_2008 hg_2011 if public==1, over(state) by(rural) ///
graphregion(fcolor(white)) legend( label(1 "2008") ///
label(2 "2011")) scheme(s2mono)
*graph export "$doc\graph06.png", replace

/* English teachers by state */
gen tg_2008=teach_g if year==2008
gen tg_2011=teach_g if year==2011
graph hbar tg_2008 tg_2011 if public==1, over(state) ytitle(English ///
teachers) graphregion(fcolor(white)) title(English ///
teachers by state) legend( label(1 "2008") ///
label(2 "2011") pos(3) ring(0) col(1)) scheme(s2mono) ///
note("Note: English teachers calculated dividing total Eng teachers in a school by number of classes", span)
*graph export "$doc\graph_states2.png", replace

/* English teachers by state, by rural*/
graph hbar tg_2008 tg_2011 if public==1, over(state) by(rural) ytitle(English ///
teachers) graphregion(fcolor(white)) legend( label(1 "2008") ///
label(2 "2011")) scheme(s2mono)
*graph export "$doc\graph_states_rural2.png", replace

/* Percent of schools */
gen eng_2008=eng if year==2008
gen eng_2011=eng if year==2011

graph hbar eng_2008 eng_2011 if public==1, over(state) ytitle(Proportion of ///
schools with Eng instruction) graphregion(fcolor(white)) title(Enlgish ///
in schools by state) legend( label(1 "2008") label(2 "2011") pos(3) ring(0) ///
col(1)) scheme(s2mono)
*graph export "$doc\graph_states3.png", replace

/* Percent of schools, by rural*/
graph hbar eng_2008 eng_2011 if public==1, over(state) by(rural) ///
graphregion(fcolor(white)) legend( label(1 "2008") ///
label(2 "2011")) scheme(s2mono)
*graph export "$doc\graph07.png", replace
*/
*========================================================================*
/*use "$base\d_schools.dta", clear

destring state, replace
label define state 1 AGS 2 BC 3 BCS 4 CAMP 5 COAH 6 COL 7 CHIA 8 CHIH 9 MXC 10 ///
DGO 11 GTO 12 GRO 13 HGO 14 JAL 15 MEX 16 MICH 17 MOR 18 NAY 19 NL 20 OAX ///
21 PUE 22 QUER 23 QRO 24 SLP 25 SIN 26 SON 27 TAB 28 TAM 29 TLAX 30 VER ///
31 YUC 32 ZAC
label values state state
*========================================================================*
* PrePost Graph 13 19
*========================================================================*
keep if year==2006 | year==2011
drop if public==0 | fts==1
keep cct year state rural hours_eng total_stud teach_eng
replace hours_eng=0 if hours_eng==.
replace teach_eng=0 if teach_eng==.
collapse (sum) total_stud (mean) hours_eng teach_eng, by(year state rural cct)
reshape wide hours_eng teach_eng total_stud, i(cct rural state) j(year)
drop if hours_eng2011==. | total_stud2011==.
gen post_pre=hours_eng2011-hours_eng2006
gen post_pre_t=teach_eng2011-teach_eng2006
label var post_pre "Hrs Eng (2011-2006)"
label var post_pre_t "Eng teachers (2011-2006)"
label var hours_eng2006 "Pre-Hours of English instruction coefficients"
label var teach_eng2006 "Pre-intensity English teachers"
drop if post_pre_t<0

eststo clear
foreach x in 1 2 3 4 5 6 7 8 10 11 12 13 14 15 17 18 19 21 22 24 ///
25 26 27 28 29 30 31 32 {
quietly reg post_pre_t teach_eng2006 if state==`x'
estimates store s`x'
}
coefplot (s1) (s2) (s3) (s4) (s5) (s6) (s7) (s8) (s10) (s11) (s12) ///
(s13) (s14) (s15) (s17) (s18) (s19) (s21) (s22) (s24) (s25) (s26) (s27) ///
(s28) (s29) (s30) (s31) (s32), legend(off) drop(_cons) yline(0) ///
graphregion(fcolor(white)) vertical scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graph09_all.png", replace

scatter post_pre_t teach_eng2006, ytitle(Post-Pre English teachers) ///
ylabel(,nogrid) graphregion(fcolor(white)) xtitle(English teachers ///
in 2006) legend(off) || lfit post_pre_t teach_eng2006 
*graph export "$doc\prepost01.png", replace

binscatter post_pre hours_eng2006, absorb(state) ytitle(Post-Pre hrs of ///
English instruction) ylabel(,nogrid) graphregion(fcolor(white)) xtitle(Hrs ///
English instruction in 2006) legend(off)
*graph export "$doc\prepost02.png", replace

collapse (sum) total_stud2006 (mean) hours_eng* post_pre, by(state)
scatter post_pre hours_eng2006, mlabel(state) ytitle(Post-Pre hrs of ///
English instruction) ylabel(,nogrid) graphregion(fcolor(white)) xtitle(Hrs ///
English instruction in 2006) legend(off) || lfit post_pre hours_eng2006
*graph export "$doc\prepost03.png", replace
*/
*========================================================================*
* Data for map
*========================================================================*
use "$base\d_schools.dta", clear

destring state, replace
label define state 1 AGS 2 BC 3 BCS 4 CAMP 5 COAH 6 COL 7 CHIA 8 CHIH 9 MXC 10 ///
DGO 11 GTO 12 GRO 13 HGO 14 JAL 15 MEX 16 MICH 17 MOR 18 NAY 19 NL 20 OAX ///
21 PUE 22 QUER 23 QRO 24 SLP 25 SIN 26 SON 27 TAB 28 TAM 29 TLAX 30 VER ///
31 YUC 32 ZAC
label values state state

drop if rural==.
collapse (mean) eng, by(year state)
reshape wide eng, i(state) j(year)

save "$base\eng_sch.dta", replace

use "$base\d_schools.dta", clear

destring state, replace
label define state 1 AGS 2 BC 3 BCS 4 CAMP 5 COAH 6 COL 7 CHIA 8 CHIH 9 MXC 10 ///
DGO 11 GTO 12 GRO 13 HGO 14 JAL 15 MEX 16 MICH 17 MOR 18 NAY 19 NL 20 OAX ///
21 PUE 22 QUER 23 QRO 24 SLP 25 SIN 26 SON 27 TAB 28 TAM 29 TLAX 30 VER ///
31 YUC 32 ZAC
label values state state

keep if rural==0
collapse (mean) eng, by(year state)
reshape wide eng, i(state) j(year)

foreach x in 06 07 08 09 10 11 12 13 {
quietly rename eng20`x' eng20`x'u
}

merge 1:1 state using "$base\eng_sch.dta"
drop _merge

save "$base\eng_sch.dta", replace

use "$base\d_schools.dta", clear

destring state, replace
label define state 1 AGS 2 BC 3 BCS 4 CAMP 5 COAH 6 COL 7 CHIA 8 CHIH 9 MXC 10 ///
DGO 11 GTO 12 GRO 13 HGO 14 JAL 15 MEX 16 MICH 17 MOR 18 NAY 19 NL 20 OAX ///
21 PUE 22 QUER 23 QRO 24 SLP 25 SIN 26 SON 27 TAB 28 TAM 29 TLAX 30 VER ///
31 YUC 32 ZAC
label values state state

keep if rural==1
collapse (mean) eng, by(year state)
reshape wide eng, i(state) j(year)

foreach x in 06 07 08 09 10 11 12 13 {
quietly rename eng20`x' eng20`x'r
}

merge 1:1 state using "$base\eng_sch.dta"
drop _merge
replace eng2011r=0 if eng2011r==.

save "$base\eng_sch.dta", replace
/*
*========================================================================*
* Data check
*========================================================================*
use "$base\d_schools.dta", clear

destring state, replace
label define state 1 AGS 2 BC 3 BCS 4 CAMP 5 COAH 6 COL 7 CHIA 8 CHIH 9 MXC 10 ///
DGO 11 GTO 12 GRO 13 HGO 14 JAL 15 MEX 16 MICH 17 MOR 18 NAY 19 NL 20 OAX ///
21 PUE 22 QUER 23 QRO 24 SLP 25 SIN 26 SON 27 TAB 28 TAM 29 TLAX 30 VER ///
31 YUC 32 ZAC
label values state state

graph hbar total_stud if public==1 & state==20, over(year) ytitle(Number of ///
students) graphregion(fcolor(white)) scheme(s2mono)
/* Observations: Oaxaca is weird in terms of the variables measured by(rural) */
*graph export "$doc\graph_states.png", replace
*/ 
*========================================================================*
* Creating exposure variable at locality level
*========================================================================*
use "$base\d_schools.dta", clear

gen str id_geo=(state + id_mun + id_loc)
collapse (mean) eng h_group [fw=total_stud], by(id_geo year)

reshape wide eng h_group, i(id_geo) j(year)

egen eng_exp1997=rowmean(eng2003 eng2004 eng2005 eng2006 eng2007 eng2008)
egen eng_exp1998=rowmean(eng2004 eng2005 eng2006 eng2007 eng2008 eng2009)
egen eng_exp1999=rowmean(eng2005 eng2006 eng2007 eng2008 eng2009 eng2010)
egen eng_exp2000=rowmean(eng2006 eng2007 eng2008 eng2009 eng2010 eng2011)
egen eng_exp2001=rowmean(eng2007 eng2008 eng2009 eng2010 eng2011 eng2012)
egen eng_exp2002=rowmean(eng2008 eng2009 eng2010 eng2011 eng2012 eng2013)

egen hrs_exp1997=rowmean(h_group2003 h_group2004 h_group2005 h_group2006 h_group2007 h_group2008)
egen hrs_exp1998=rowmean(h_group2004 h_group2005 h_group2006 h_group2007 h_group2008 h_group2009)
egen hrs_exp1999=rowmean(h_group2005 h_group2006 h_group2007 h_group2008 h_group2009 h_group2010)
egen hrs_exp2000=rowmean(h_group2006 h_group2007 h_group2008 h_group2009 h_group2010 h_group2011)
egen hrs_exp2001=rowmean(h_group2007 h_group2008 h_group2009 h_group2010 h_group2011 h_group2012)
egen hrs_exp2002=rowmean(h_group2008 h_group2009 h_group2010 h_group2011 h_group2012 h_group2013)

drop eng20* h_group20*

reshape long hrs_exp, i(id_geo) j(cohort)
drop eng_exp*
replace hrs_exp=0 if hrs_exp==.

save "$base\exposure_loc.dta", replace
*========================================================================*
* Creating exposure variable at county level
*========================================================================*
use "$base\d_schools.dta", clear

gen str geo_mun_s=(state + id_mun)
collapse (mean) eng h_group [fw=total_stud], by(geo year)

reshape wide eng h_group, i(geo) j(year)

egen eng_exp1997=rowmean(eng2003 eng2004 eng2005 eng2006 eng2007 eng2008)
egen eng_exp1998=rowmean(eng2004 eng2005 eng2006 eng2007 eng2008 eng2009)
egen eng_exp1999=rowmean(eng2005 eng2006 eng2007 eng2008 eng2009 eng2010)
egen eng_exp2000=rowmean(eng2006 eng2007 eng2008 eng2009 eng2010 eng2011)
egen eng_exp2001=rowmean(eng2007 eng2008 eng2009 eng2010 eng2011 eng2012)
egen eng_exp2002=rowmean(eng2008 eng2009 eng2010 eng2011 eng2012 eng2013)

egen hrs_exp1997=rowmean(h_group2003 h_group2004 h_group2005 h_group2006 h_group2007 h_group2008)
egen hrs_exp1998=rowmean(h_group2004 h_group2005 h_group2006 h_group2007 h_group2008 h_group2009)
egen hrs_exp1999=rowmean(h_group2005 h_group2006 h_group2007 h_group2008 h_group2009 h_group2010)
egen hrs_exp2000=rowmean(h_group2006 h_group2007 h_group2008 h_group2009 h_group2010 h_group2011)
egen hrs_exp2001=rowmean(h_group2007 h_group2008 h_group2009 h_group2010 h_group2011 h_group2012)
egen hrs_exp2002=rowmean(h_group2008 h_group2009 h_group2010 h_group2011 h_group2012 h_group2013)

drop eng20* h_group20*

reshape long eng_exp hrs_exp, i(geo) j(cohort)
replace hrs_exp=0 if hrs_exp==.

save "$base\exposure_mun.dta", replace
