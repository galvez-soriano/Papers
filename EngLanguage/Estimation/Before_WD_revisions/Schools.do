*========================================================================*
* Foreign language instruction and language abilities
*========================================================================*
/* Working with the School Census (Stats 911) to create a database of 
school's characteristics and exposure to English instruction */
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EngInstruction/Stat911"
gl data2= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/EngInstruction/Data"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngLanguage\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngLanguage\Doc"
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

merge m:m cct using "$data2/schools_06_13.dta"
drop _merge
replace rural=rural2 if rural==.
drop rural2
rename rural rural2
merge m:m state id_mun id_loc using "$data2/Rural2010.dta"
drop if _merge==2
replace rural2=rural if rural2==.
drop _merge rural
rename rural2 rural
merge m:m state id_mun id_loc using "$data2/Rural2.dta"
replace rural=rural2 if rural==.
drop _merge rural2
merge m:m cct using "$data2/schools_geo.dta"
drop if _merge==2
replace id_loc=id_loc2 if rural==.
drop _merge state2 id_mun2 id_loc2
merge m:m state id_mun id_loc using "$data2/Rural2.dta"
replace rural=rural2 if rural==.
drop _merge rural2
rename rural rural2
merge m:m state id_mun id_loc using "$data2/Rural2010.dta"
drop if _merge==2
replace rural2=rural if rural2==.
drop _merge rural
rename rural2 rural
merge m:m cct using "$data2/schools_cpv.dta"
drop if _merge==2
replace id_loc=cve_loc if rural==.
replace rural=1 if rururb=="R" & rural==.
replace rural=0 if rururb=="U" & rural==.
drop _merge cve_ent cve_mun cve_loc rururb

label var state "State"
drop if cct==""
drop if year==.
bysort cct: gen same_school=_N
keep if same_school>=15 & same_school<=17
drop same_school

merge m:m cct year using "$data2/fts0718.dta"
drop if _merge==2
drop _merge
replace fts=0 if fts==.

order state id_mun id_loc cct shift year
sort state id_mun id_loc cct shift year
save "$base\d_schools.dta", replace
*========================================================================*
use "$base\d_schools.dta", clear

gen cctPB=substr(cct,4,2)
gen indig_school=cctPB=="PB"
drop cctPB

sort cct year
/* Generating treatment variable */
drop if year>2006
bysort cct: replace h_group= (h_group[_n-1]+h_group[_n+1])/2 if h_group==0 & h_group[_n-1]<h_group[_n+1] & h_group[_n-1]!=. & h_group[_n+1]!=.
bysort cct: replace h_group=h_group[_n-1] if h_group[_n-1]>0 & h_group==0 & year==2006 & h_group[_n-1]!=.
bysort cct: replace h_group= (h_group[_n-1]+h_group[_n+1])/2 if h_group==0 & h_group[_n-1]<h_group[_n+1] & h_group[_n-1]!=. & h_group[_n+1]!=.
bysort cct: replace h_group= h_group[_n-1] if h_group==0 & h_group[_n-1]==h_group[_n+1] & h_group[_n-1]!=. & h_group[_n+1]!=.
bysort cct: replace h_group= h_group[_n-1] if h_group<h_group[_n-1] & h_group[_n-1]<h_group[_n+1] & h_group[_n-1]!=. & h_group[_n+1]!=.
bysort cct: replace h_group= h_group[_n-1] if h_group<h_group[_n-1] & h_group[_n-1]==h_group[_n+1] & h_group[_n-1]!=. & h_group[_n+1]!=.
bysort cct: replace h_group= (h_group[_n-1]+h_group[_n+1])/2 if h_group==0 & h_group[_n-1]<=h_group[_n+1] & h_group[_n-1]!=. & h_group[_n+1]!=.
bysort cct: replace h_group= h_group[_n-1] if h_group<h_group[_n-1] & h_group[_n-1]<=h_group[_n+2] & h_group[_n-1]!=. & h_group[_n+2]!=.
bysort cct: replace h_group= h_group[_n-1] if h_group<h_group[_n-1] & h_group[_n-1]<=h_group[_n+1] & h_group[_n-1]!=. & h_group[_n+1]!=.
bysort cct: replace h_group= (h_group[_n-1]+h_group[_n+1])/2 if h_group==0 & h_group[_n-1]<=h_group[_n+1] & h_group[_n-1]!=. & h_group[_n+1]!=.
bysort cct: replace h_group= h_group[_n-1] if h_group<h_group[_n-1] & h_group[_n+1]>=1 & h_group[_n-1]!=. & h_group[_n+1]!=.
bysort cct: replace h_group= (h_group[_n-1]+h_group[_n+1])/2 if h_group==0 & h_group[_n-1]<=h_group[_n+1] & h_group[_n-1]!=. & h_group[_n+1]!=.

bysort cct: replace h_group= (h_group[_n-1]+h_group[_n+1])/2 if h_group==0 & h_group[_n-1]>0 & h_group[_n+1]>0 & h_group[_n-1]!=. & h_group[_n+1]!=.
bysort cct: replace h_group= h_group[_n-1] if h_group<h_group[_n-1] & h_group[_n-1]<h_group[_n+1] & h_group[_n-1]!=. & h_group[_n+1]!=.
bysort cct: replace h_group= (h_group[_n-1]+h_group[_n+1])/2 if h_group==0 & h_group[_n-1]<=h_group[_n+1] & h_group[_n-1]!=. & h_group[_n+1]!=.

bysort cct: replace h_group= h_group[_n-1] if h_group<h_group[_n-1] & h_group[_n+1]>=0.33 & h_group[_n-1]!=. & h_group[_n+1]!=.
bysort cct: replace h_group= (h_group[_n-1]+h_group[_n+1])/2 if h_group==0 & h_group[_n-1]<=h_group[_n+1] & h_group[_n-1]!=. & h_group[_n+1]!=.

gen treat=0
*tab h_group
replace treat=1 if h_group>=0.33

gen ftreat=.
bysort cct: gen ncount=_n if treat!=0
bysort cct: replace ftreat=year if ncount[_n-1]==. & ncount[_n+1]>ncount & ncount!=. // this identifies the first treated year but exclude never treated
bysort cct: egen first_treat = total(ftreat) // assigning the value of the first treat year to all observation within a school

replace treat=0 if first_treat>2006
*tab h_group if first_treat>2006
replace treat=1 if h_group>=1 & first_treat>2006
drop ftreat ncount first_treat

sort cct year

gen ftreat=.
bysort cct: gen ncount=_n if treat!=0
bysort cct: replace ftreat=year if ncount[_n-1]==. & ncount[_n+1]>ncount & ncount!=.
bysort cct: egen first_treat = total(ftreat)

drop if first_treat>2006

replace first_treat=2007 if first_treat==0 // assigning the value of 2007 to never treated schools
drop ncount ftreat
/* Creatig time-relative variable */
gen K=year-first_treat
save "$base\dbs.dta", replace
*========================================================================*
/*  Treatment at municipality level to explore effects on enrollment in 
Indigenous schools */
*========================================================================*
use "$base\dbs.dta", clear
bysort cct: gen same_school=_N
keep if same_school==10
drop same_school

gen str geo=state+id_mun
collapse h_group, by(geo year)

sum h_group, d
gen treat_mun=h_group>=r(p90)

gen ftreat=.
bysort geo: gen ncount=_n if treat_mun!=0
bysort geo: replace ftreat=year if ncount[_n-1]==. & ncount[_n+1]>ncount & ncount!=. // this identifies the first treated year but exclude never treated
bysort geo: egen first_treat = total(ftreat) // assigning the value of the first treat year to all observation within a school


replace treat=0 if first_treat>2006
sum h_group if first_treat>2006, d
replace treat=1 if h_group>=r(p90) & first_treat>2006
drop ftreat ncount first_treat

sort geo year

gen ftreat=.
bysort geo: gen ncount=_n if treat!=0
bysort geo: replace ftreat=year if ncount[_n-1]==. & ncount[_n+1]>ncount & ncount!=.
bysort geo: egen first_treat = total(ftreat)
rename first_treat first_treat_mun
drop h_group ftreat ncount

save "$base\dbs_mun.dta", replace
*========================================================================*
/* Treatment at the school level */
*========================================================================*
use "$base\dbs.dta", clear
bysort cct: gen same_school=_N
keep if same_school==10
drop same_school

*========================================================================*
/* FIGURE 4. Mechanisms: school enrollment */
*========================================================================*
/* Public, non-indigenous schools */
csdid total_stud shift total_groups school_supp_exp uniform_exp tuition fts if public==1, ///
time(year) gvar(first_treat) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_nstud)

coefplot csdid_nstud, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Number of students enrolled in school", size(medium) height(5)) ///
ylabel(-180(90)180, labs(medium) grid format(%5.0f)) ///
xtitle("Years since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) recast(connected) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_nstud.png", replace

/* Public, non-indigenous schools */
csdid indig_stud shift total_groups total_stud school_supp_exp uniform_exp tuition fts if public==1, ///
time(year) gvar(first_treat) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_istud)

coefplot csdid_istud, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Number of Indigenous students enrolled in school", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Years since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) recast(connected) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_istud.png", replace

*========================================================================*
/* Treatment at the municipality level for Indigenous schools */
*========================================================================*
use "$base\dbs.dta", clear
bysort cct: gen same_school=_N
keep if same_school==10
drop same_school

gen str geo=state+id_mun
merge m:1 year geo using "$base\dbs_mun.dta", nogen

/* Indigenous schools */
csdid total_stud shift total_groups if indig_school==1, ///
time(year) gvar(first_treat_mun) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_nstud_ind)

coefplot csdid_nstud_ind, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Number of students enrolled in indigenous schools", size(medium) height(5)) ///
ylabel(-180(90)180, labs(medium) grid format(%5.0f)) ///
xtitle("Years since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) recast(connected) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_nstud_ind.png", replace
/*
/* Public, non-indigenous schools */
csdid total_stud shift total_groups school_supp_exp uniform_exp tuition fts if public==1, ///
time(year) gvar(first_treat_mun) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_nstud_m)

coefplot csdid_nstud_m, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Number of students enrolled in school", size(medium) height(5)) ///
ylabel(-180(90)180, labs(medium) grid format(%5.0f)) ///
xtitle("Years since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) recast(connected) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_nstud_m.png", replace

/* Public, non-indigenous schools */
csdid indig_stud shift total_groups total_stud school_supp_exp uniform_exp tuition fts if public==1, ///
time(year) gvar(first_treat_mun) method(dripw) vce(cluster geo) long2 wboot seed(6)
estat event, window(-4 6) estore(csdid_istud_m)

coefplot csdid_istud_m, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(4.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Number of Indigenous students enrolled in school", size(medium) height(5)) ///
ylabel(-4(2)4, labs(medium) grid format(%5.0f)) ///
xtitle("Years since policy intervention", size(medium) height(5)) ///
xlabel(, angle(horizontal) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) recast(connected) ///
coeflabels(Tm9 = "-9" Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_CS_istud_m.png", replace

/* Hours of Eng instruction by state */

tabstat hours_eng, by(state)
*/