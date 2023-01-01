*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Ideas\Education\Peer effects in middle schools\Data"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data"
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

gen h_eng_pt=hours_eng/teach_eng
label var h_eng_pt "Hrs teach-Eng per-teach"

rename v912 school_supp_exp
label var school_supp_exp "School supplies expenses"

rename v913 uniform_exp
label var uniform_exp "School uniform expenses"

rename v914 tuition
label var tuition "Tuition expenses"

keep cct shift state id_mun id_loc total_stud indig_stud anglo_stud latino_stud other_stud disabil ///
high_abil teach_elem teach_midle teach_high teach_colle teach_mast ///
teach_phd teach_eng hours_eng h_eng_pt school_supp_exp uniform_exp ///
tuition total_groups
/*
merge m:m cct using "$base\schools_06_13.dta"
drop if _merge!=3
drop _merge*/
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

gen h_eng_pt=hours_eng/teach_eng
label var h_eng_pt "Hrs teach-Eng per-teach"

keep cct shift state id_mun id_loc total_stud indig_stud anglo_stud latino_stud other_stud disabil ///
high_abil teach_elem teach_midle teach_high teach_colle teach_mast ///
teach_phd teach_eng hours_eng h_eng_pt total_groups

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

gen h_eng_pt=hours_eng/teach_eng
label var h_eng_pt "Hrs teach-Eng per-teach"

keep cct shift state id_mun id_loc total_stud indig_stud anglo_stud latino_stud other_stud disabil ///
high_abil teach_eng hours_eng h_eng_pt
/*
merge m:m cct using "$base\schools_06_13.dta"
drop if _merge!=3
drop _merge*/
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
order cct shift year eng teach_eng hours_eng h_eng_pt total_groups total_stud ///
indig_stud anglo_stud latino_stud other_stud disabil high_abil teach_elem  ///
teach_midle teach_high teach_colle teach_mast teach_phd school_supp_exp ///
uniform_exp tuition

sort cct shift year
label var year "Year"
label var eng "Had Enlish program"
label var h_eng_pt "Hours teaching English (per English teacher)"
* Public schools
gen classif=substr(cct,3,3)
gen priv=substr(cct,3,1)
gen public=1
replace public=0 if priv=="P"
replace public=0 if classif=="SBC" | classif=="SBH" | classif=="SCT"
drop classif priv
replace h_eng_pt=0 if h_eng_pt==.

save "$base\d_schools.dta", replace
*========================================================================*
/*use "$base\d_schools.dta", clear

twoway (histogram h_group if year==2008 & h_group<=25 & public==1, color(gray)) (histogram h_group if ///
year==2011 & h_group<=25 & public==1, fcolor(none) lcolor(black)), graphregion(fcolor(white)) ///
legend(order(1 "2008" 2 "2011" ) pos(1) ring(0) col(1)) 

twoway (histogram h_eng_pt if year==2008 & h_eng_pt<=25 & public==1, color(gray)) (histogram h_eng_pt if ///
year==2011 & h_eng_pt<=25 & public==1, fcolor(none) lcolor(black)), graphregion(fcolor(white)) ///
legend(order(1 "2008" 2 "2011" ) pos(1) ring(0) col(1)) 
graph export "$doc\graph01.png", replace*/
*========================================================================*
use "$base\d_schools.dta", clear
keep year cct shift eng

reshape wide eng, i(cct shift) j(year)
egen seyear=rowtotal(eng2006 eng2007 eng2008 eng2009 eng2010 eng2011)
gen treat=.
replace treat=0 if seyear==0
replace treat=1 if (eng2009==1 | eng2010==1 | eng2011==1 | eng2012==1 | eng2013==1)
*replace treat=1 if (eng2006==0 & eng2007==0 & eng2008==0) & (eng2009==1 | eng2010==1 | eng2011==1)
label var treat "Had English Program"
keep cct shift treat
save "$base\eng_base.dta", replace

merge m:m cct shift using "$base\d_schools.dta"
drop _merge
*save "$base\d_schools.dta", replace

gen after=.
replace after=1 if year==2011
replace after=0 if year==2008
gen interact=after*treat

areg h_eng_pt interact after treat, absorb(state)
areg h_eng_pt interact after treat [aw=total_stud], absorb(state)

use "$base\d_schools.dta", clear
twoway (histogram h_eng_pt if year==2008 & h_eng_pt<=25 & treat!=. & public==1, color(gray)) (histogram h_eng_pt if ///
year==2011 & h_eng_pt<=25 & treat!=. & public==1, fcolor(none) lcolor(black)), graphregion(fcolor(white)) ///
legend(order(1 "2008" 2 "2011" ) pos(1) ring(0) col(1)) 
*graph export "$doc\graph02.png", replace
*========================================================================*
/*use "$base\fts0718.dta", clear
keep if year==2011
merge m:m cct using "$base\schools_06_13.dta"
drop if _merge!=3
drop _merge
collapse (mean) fts, by(state id_mun)
save "$base\fts.dta", replace*/
*========================================================================*
* Patterns in data															<===============================================
*========================================================================*
use "$base\d_schools.dta", clear
tostring state, replace format(%02.0f) force
tostring id_mun, replace format(%03.0f) force
tostring id_loc, replace format(%04.0f) force

*merge m:m state id_mun id_loc using "$base\Rural2010.dta"
merge m:m cct using "$base\schools_06_13.dta"
drop if _merge!=3
drop _merge

*histogram h_group if h_group!=0 & h_group<=15

destring state, replace
label define state 1 AGS 2 BC 3 BCS 4 CAMP 5 COAH 6 COL 7 CHIA 8 CHIH 9 CDMX 10 ///
DGO 11 GTO 12 GRO 13 HGO 14 JAL 15 MEX 16 MICH 17 MOR 18 NAY 19 NL 20 OAX ///
21 PUE 22 QUER 23 QRO 24 SLP 25 SIN 26 SON 27 TAB 28 TAM 29 TLAX 30 VER ///
31 YUC 32 ZAC
label values state state
*========================================================================*
* Hours over time
*========================================================================*
bysort year: egen hours_year=mean(h_group) if public==1
label var hours_year "Hours of English instruction"

bysort year: egen hours_year_rural=mean(h_group) if rural==1 & public==1
label var hours_year_rural "Hours of English instruction"

bysort year: egen hours_year_urban=mean(h_group) if rural==0 & public==1
label var hours_year_urban "Hours of English instruction"

twoway line hours_year year, msymbol(diamond) xlabel(2006(1)2013, angle(vertical)) ///
ytitle(Hours of English instruction) graphregion(fcolor(white)) legend(pos(10) ///
ring(0) col(1)) title(Hours of English instruction (rural vs urban)) xline(2009) ///
note("Note: Vertical line in 2009 highlights the year of implementation of the national English program", span) ///
|| line hours_year_rural year || line hours_year_urban year, ///
legend(label(1 "Nation") label(2 "Rural") label(3 "Urban"))
graph export "$doc\graph07.png", replace

*========================================================================*
/* English instruction by state */
foreach x in 06 07 08 09 10 11 12 13{
graph hbar h_group if public==1 & year==20`x', over(state) ytitle(Hours ///
of English instruction) graphregion(fcolor(white)) title(Weekly hours of ///
English instruction in 20`x' by state) ysc(r(0 2)) ///
note("Note: Hours of English instruction calculated dividing total hours in a school by total number of groups", span)
graph export "$doc\graph_states`x'.png", replace
}

/* English instruction by state, by rural*/
foreach x in 06 07 08 09 10 11 12 13{
graph hbar h_group if public==1 & year==20`x', over(state) by(rural) ///
ytitle(Hours of English instruction) graphregion(fcolor(white))
graph export "$doc\graph_states_rural`x'.png", replace
}
*========================================================================*
* Percent of schools															<===============================================
*========================================================================*
/* English instruction by state, by rural*/
foreach x in 06 07 08 09 10 11 12 13{
graph hbar eng if public==1 & year==20`x', over(state) by(rural) ///
ytitle(Proportion of schools with English instruction) graphregion(fcolor(white))
graph export "$doc\graph_proport`x'.png", replace
}
*========================================================================*

