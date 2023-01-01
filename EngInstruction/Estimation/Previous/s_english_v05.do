*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Ideas\Education\Peer effects in middle schools\Data"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New"
gl doc= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Doc"
*========================================================================*
foreach x in 06 07 08 09 10 11 12 13{
/* Primaria General */
use "$data\20`x'\PRIMGI`x'.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

decode clavecct, gen(cct)
rename turno shift

rename n_entidad state 
rename municipio id_mun 
rename localidad id_loc

rename v59 groups_1
label var groups_1 "Number of groups in 1st grade"
rename v115 groups_2
label var groups_2 "Number of groups in 2nd grade"
rename v166 groups_3
label var groups_3 "Number of groups in 3rd grade"
rename v212 groups_4
label var groups_4 "Number of groups in 4th grade"
rename v253 groups_5
label var groups_5 "Number of groups in 5th grade"
rename v289 groups_6
label var groups_6 "Number of groups in 6th grade"

rename v348 total_groups
label var total_groups "Total number of groups"

rename v347 total_stud
label var total_stud "Total students in school"

rename v372 indig_stud
label var indig_stud "Indigenous stud"

gen anglo_stud=v375+v378+v396
label var anglo_stud "English-speak stud"

gen latino_stud=v381+v384
label var latino_stud "Foreign latino stud"

gen other_stud=v387+v390+v393
label var other_stud "Foreign other stud"

gen disabil=v429-v423
label var disabil "Stud w/disabilities"

rename v423 high_abil
label var high_abil "High ability stud"

gen teach_elem=v437+v438+v453+v454
label var teach_elem "Teachers w/elementary"

gen teach_midle=v469+v470+v485+v486
label var teach_midle "Teachers w/midle"

gen teach_high=v501+v502+v517+v518+v533+v534
label var teach_high "Teachers w/high"

gen teach_colle=v549+v550+v565+v566+v581+v582+v597+v598+v613+v614+v629+v630 ///
+v645+v646+v661+v662+v677+v678+v693+v694
label var teach_colle "Teachers w/college"

gen teach_mast=v709+v710+v725+v726
label var teach_mast "Teachers w/master"

gen teach_phd=v741+v742+v757+v758
label var teach_phd "Teachers w/phd"

gen teach_eng=v832+v833
label var teach_eng "English teachers"

rename v875 hours_eng
label var hours_eng "Hours teach-Eng"

rename v912 school_supp_exp
label var school_supp_exp "School supplies expenses"

rename v913 uniform_exp
label var uniform_exp "School uniform expenses"

rename v914 tuition
label var tuition "Tuition expenses"

keep cct shift state id_mun id_loc total_stud indig_stud anglo_stud latino_stud other_stud disabil ///
high_abil teach_elem teach_midle teach_high teach_colle teach_mast ///
teach_phd teach_eng hours_eng school_supp_exp uniform_exp tuition total_groups groups_*

gen eng=0
replace eng=1 if hours_eng>0

save "$base\stat911_`x'.dta", replace
*========================================================================*
/* Primaria Indígena */
use "$data\20`x'\PRIMII`x'.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

decode clavecct, gen(cct)
rename turno shift

rename n_entidad state 
rename municipio id_mun 
rename localidad id_loc

gen total_stud=v344
label var total_stud "Total students in school"

rename v344 indig_stud
label var indig_stud "Indigenous stud"

rename v394 groups_1
label var groups_1 "Number of groups in 1st grade"
rename v395 groups_2
label var groups_2 "Number of groups in 2nd grade"
rename v396 groups_3
label var groups_3 "Number of groups in 3rd grade"
rename v397 groups_4
label var groups_4 "Number of groups in 4th grade"
rename v398 groups_5
label var groups_5 "Number of groups in 5th grade"
rename v399 groups_6
label var groups_6 "Number of groups in 6th grade"

rename v400 total_groups
label var total_groups "Total number of groups"

gen anglo_stud=0
label var anglo_stud "English-speak stud"

gen latino_stud=0
label var latino_stud "Foreign latino stud"

gen other_stud=0
label var other_stud "Foreign other stud"

gen disabil=v371-v368
label var disabil "Stud w/disabilities"

rename v368 high_abil
label var high_abil "High ability stud"

gen teach_elem=v448+v449+v458+v459
label var teach_elem "Teachers w/elementary"

gen teach_midle=v468+v469+v478+v479
label var teach_midle "Teachers w/midle"

gen teach_high=v488+v489+v498+v499+v508+v509
label var teach_high "Teachers w/high"

gen teach_colle=v518+v528+v538+v548+v558+v568+v578+v588+v598+v608 ///
+v519+v529+v539+v549+v559+v569+v579+v589+v599+v609
label var teach_colle "Teachers w/college"

gen teach_mast=v618+v628+v619+v629
label var teach_mast "Teachers w/master"

gen teach_phd=v638+v648+v639+v649
label var teach_phd "Teachers w/phd"

gen teach_eng=0
label var teach_eng "English teachers"

gen hours_eng=0
label var hours_eng "Hours teach-Eng"

keep cct shift state id_mun id_loc total_stud indig_stud anglo_stud latino_stud other_stud disabil ///
high_abil teach_elem teach_midle teach_high teach_colle teach_mast ///
teach_phd teach_eng hours_eng total_groups groups_*

gen eng=0
replace eng=1 if hours_eng>0

append using "$base\stat911_`x'.dta"
sort cct shift
save "$base\stat911_`x'.dta", replace
*========================================================================*
/* Primaria Comunitaria Rural */
use "$data\20`x'\PRIMCI`x'.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

decode clavecct, gen(cct)
rename turno shift

rename n_entidad state 
rename municipio id_mun 
rename localidad id_loc

gen groups_1=1 if v39!=0 | v147!=0 | v255!=0
label var groups_1 "Number of groups in 1st grade"
gen groups_2=1 if v75!=0 | v183!=0 | v291!=0
label var groups_2 "Number of groups in 2nd grade"
gen groups_3=1 if v111!=0 | v219!=0 | v327!=0
label var groups_3 "Number of groups in 3rd grade"

egen total_groups=rowtotal(groups_1 groups_2 groups_3)
label var total_groups "Total number of groups"
replace total_groups=1 if total_groups==0 & v344!=0
replace total_groups=. if total_groups==0

gen total_stud=v344
label var total_stud "Total students in school"

gen indig_stud=0
replace indig_stud=v363 if v2==1
label var indig_stud "Indigenous stud"

gen anglo_stud=0
label var anglo_stud "English-speak stud"

gen latino_stud=0
label var latino_stud "Foreign latino stud"

gen other_stud=0
label var other_stud "Foreign other stud"

gen disabil=v402-v396
label var disabil "Stud w/disabilities"

rename v396 high_abil
label var high_abil "High ability stud"

gen teach_eng=0
label var teach_eng "English teachers"

gen hours_eng=0
label var hours_eng "Hours teach-Eng"

keep cct shift state id_mun id_loc total_stud indig_stud anglo_stud latino_stud other_stud disabil ///
high_abil teach_eng hours_eng total_groups groups_*

gen eng=0
replace eng=1 if hours_eng>0

append using "$base\stat911_`x'.dta"
gen year=20`x'
sort cct shift
save "$base\stat911_`x'.dta", replace
}
*========================================================================*
clear
append using "$base\stat911_06.dta" "$base\stat911_07.dta" "$base\stat911_08.dta" ///
"$base\stat911_09.dta" "$base\stat911_10.dta" "$base\stat911_11.dta" ///
"$base\stat911_12.dta" "$base\stat911_13.dta"
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
bysort cct: egen had_e=sum(had_eng)

egen group_2009=rowtotal(groups_1 groups_2)
egen group_2010=rowtotal(groups_1 groups_2 groups_3 groups_4)
replace total_groups=. if total_groups==0
replace group_2009=. if group_2009==0
replace group_2010=. if group_2010==0

gen h_group=hours_eng/total_groups if year<=2008
replace h_group=hours_eng/total_groups if year>=2009 & had_e==1
replace h_group=hours_eng/group_2009 if year==2009 & had_e==0
replace h_group=hours_eng/group_2010 if year==2010 & had_e==0
replace h_group=hours_eng/total_groups if year>=2011 & had_e==0
replace h_group=0 if h_group==.
label var h_group "Hours of English instruction (per class)"

gen teach_g=teach_eng/total_groups if year<=2008
replace teach_g=teach_eng/total_groups if year>=2009 & had_e==1
replace teach_g=teach_eng/group_2009 if year==2009 & had_e==0
replace teach_g=teach_eng/group_2010 if year==2010 & had_e==0
replace teach_g=teach_eng/total_groups if year>=2011 & had_e==0
replace teach_g=0 if teach_g==.
label var teach_g "English teachers (per class)"

*tostring state, replace format(%02.0f) force
drop state
gen state=substr(cct,1,2)
tostring id_mun, replace format(%03.0f) force
tostring id_loc, replace format(%04.0f) force
merge m:m cct using "$base\schools_06_13.dta"
drop if _merge!=3
drop _merge

save "$base\d_schools.dta", replace
*========================================================================*
use "$base\d_schools.dta", clear
/*
collapse rural, by(state id_mun id_loc)
replace rural=1 if rural!=. & rural!=0
rename rural rural2
save "$base\Rural2.dta", replace

merge m:m state id_mun id_loc using "$base\d_schools.dta"
drop _merge
replace rural=rural2 if rural==.
drop rural2
*/
label var state "State"
drop if cct==""
drop if year==.
bysort cct: gen same_school=_N
keep if same_school==8
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

twoway (histogram h_group if year==2008 & h_group<=5 & public==1, color(gray)) (histogram h_group if ///
year==2011 & h_group<=5 & public==1, fcolor(none) lcolor(black)), graphregion(fcolor(white)) ///
legend(off) 
graph export "$doc\graph04.png", replace

twoway (histogram h_group if year==2008 & h_group<=5 & h_group!=0 & public==1, color(gray)) (histogram h_group if ///
year==2011 & h_group<=5 & h_group!=0 & public==1, fcolor(none) lcolor(black)), graphregion(fcolor(white)) ///
legend(order(1 "2008" 2 "2011" ) pos(1) ring(0) col(1)) 
graph export "$doc\graph05.png", replace

twoway (histogram teach_g if year==2008 & teach_g<=1 & public==1, color(gray)) (histogram teach_g if ///
year==2011 & teach_g<=1 & public==1, fcolor(none) lcolor(black)), graphregion(fcolor(white)) ///
legend(off) 
graph export "$doc\graph06.png", replace

twoway (histogram teach_g if year==2008 & teach_g<=1 & teach_g!=0 & public==1, color(gray)) (histogram teach_g if ///
year==2011 & teach_g<=1 & teach_g!=0 & public==1, fcolor(none) lcolor(black)), graphregion(fcolor(white)) ///
legend(off) 
graph export "$doc\graph07.png", replace
*/
*========================================================================*
* Patterns in data															
*========================================================================*
/*use "$base\d_schools.dta", clear

destring state, replace
label define state 1 AGS 2 BC 3 BCS 4 CAMP 5 COAH 6 COL 7 CHIA 8 CHIH 9 MXC 10 ///
DGO 11 GTO 12 GRO 13 HGO 14 JAL 15 MEX 16 MICH 17 MOR 18 NAY 19 NL 20 OAX ///
21 PUE 22 QUER 23 QRO 24 SLP 25 SIN 26 SON 27 TAB 28 TAM 29 TLAX 30 VER ///
31 YUC 32 ZAC
label values state state

*========================================================================*
* Hours over time
*========================================================================*
drop if year>=2014
label var year "Year"
bysort year: egen hours_year=mean(h_group) if public==1
label var hours_year "Hours of English instruction"

bysort year: egen hours_year_rural=mean(h_group) if rural==1 & public==1
label var hours_year_rural "Hours of English instruction"

bysort year: egen hours_year_urban=mean(h_group) if rural==0 & public==1
label var hours_year_urban "Hours of English instruction"
set scheme s1color
twoway line hours_year year, msymbol(diamond) xlabel(2006(1)2013, angle(vertical)) ///
ytitle(Hours of English instruction) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2009 2011, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line hours_year_rural year || line hours_year_urban year, ///
legend(label(1 "National") label(2 "Rural") label(3 "Urban"))
*graph export "$doc\graph01.png", replace
*========================================================================*
bysort year: egen et_year=mean(teach_g) if public==1
label var hours_year "English teachers"

bysort year: egen et_year_rural=mean(teach_g) if rural==1 & public==1
label var hours_year_rural "English teachers"

bysort year: egen et_year_urban=mean(teach_g) if rural==0 & public==1
label var hours_year_urban "English teachers"

twoway line et_year year, msymbol(diamond) xlabel(2006(1)2013, angle(vertical)) ///
ytitle(English teachers) ylabel(,nogrid) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1)) ///
xline(2009 2011, lstyle(grid) lpattern(dash) lcolor(red)) scheme(s2mono) ///
|| line et_year_rural year || line et_year_urban year, ///
legend(off)
*graph export "$doc\graph02.png", replace
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

graph hbar total_stud if public==1 & state==09, over(year) ytitle(Number of ///
students) graphregion(fcolor(white)) scheme(s2mono)
/* Observations: Oaxaca is weird in terms of the variables measured by(rural) */
*graph export "$doc\graph_states.png", replace
*/ 
*========================================================================*
* Creating exposure variable at locality level
*========================================================================*
use "$base\d_schools.dta", clear

gen str id_geo=(state + id_mun + id_loc)
collapse (mean) eng h_group, by(id_geo year)

reshape wide eng h_group, i(id_geo) j(year)

egen eng_exp1997=rowmean(eng2006 eng2007 eng2008)
egen eng_exp1998=rowmean(eng2006 eng2007 eng2008 eng2009)
egen eng_exp1999=rowmean(eng2006 eng2007 eng2008 eng2009 eng2010)
egen eng_exp2000=rowmean(eng2006 eng2007 eng2008 eng2009 eng2010 eng2011)
egen eng_exp2001=rowmean(eng2007 eng2008 eng2009 eng2010 eng2011 eng2012)
egen eng_exp2002=rowmean(eng2008 eng2009 eng2010 eng2011 eng2012 eng2013)

egen hrs_exp1997=rowmean(h_group2006 h_group2007 h_group2008)
egen hrs_exp1998=rowmean(h_group2006 h_group2007 h_group2008 h_group2009)
egen hrs_exp1999=rowmean(h_group2006 h_group2007 h_group2008 h_group2009 h_group2010)
egen hrs_exp2000=rowmean(h_group2006 h_group2007 h_group2008 h_group2009 h_group2010 h_group2011)
egen hrs_exp2001=rowmean(h_group2007 h_group2008 h_group2009 h_group2010 h_group2011 h_group2012)
egen hrs_exp2002=rowmean(h_group2008 h_group2009 h_group2010 h_group2011 h_group2012 h_group2013)

drop eng20* h_group20*

reshape long eng_exp, i(id_geo) j(cohort)

save "$base\exposure_loc.dta", replace
*========================================================================*
* Creating exposure variable at county level
*========================================================================*
use "$base\d_schools.dta", clear

gen str geo=(state + id_mun)
collapse (mean) eng h_group, by(geo year)

reshape wide eng h_group, i(geo) j(year)

egen eng_exp1997=rowmean(eng2006 eng2007 eng2008)
egen eng_exp1998=rowmean(eng2006 eng2007 eng2008 eng2009)
egen eng_exp1999=rowmean(eng2006 eng2007 eng2008 eng2009 eng2010)
egen eng_exp2000=rowmean(eng2006 eng2007 eng2008 eng2009 eng2010 eng2011)
egen eng_exp2001=rowmean(eng2007 eng2008 eng2009 eng2010 eng2011 eng2012)
egen eng_exp2002=rowmean(eng2008 eng2009 eng2010 eng2011 eng2012 eng2013)

egen hrs_exp1997=rowmean(h_group2006 h_group2007 h_group2008)
egen hrs_exp1998=rowmean(h_group2006 h_group2007 h_group2008 h_group2009)
egen hrs_exp1999=rowmean(h_group2006 h_group2007 h_group2008 h_group2009 h_group2010)
egen hrs_exp2000=rowmean(h_group2006 h_group2007 h_group2008 h_group2009 h_group2010 h_group2011)
egen hrs_exp2001=rowmean(h_group2007 h_group2008 h_group2009 h_group2010 h_group2011 h_group2012)
egen hrs_exp2002=rowmean(h_group2008 h_group2009 h_group2010 h_group2011 h_group2012 h_group2013)

drop eng20* h_group20*

reshape long eng_exp hrs_exp, i(geo) j(cohort)

save "$base\exposure_mun.dta", replace
