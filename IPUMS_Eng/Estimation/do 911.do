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
gl data= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngInstruct\Data\School Census\911IC9817\911IC"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngInstruct\Data\School Census"
gl doc= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Doc"
*========================================================================*
foreach x in 97{
/* Primaria General */
use "$data\19`x'\PRIMGI`x'.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

decode clavecct, gen(cct)
rename turno shift

rename n_entidad state 
rename municipio id_mun 
rename localidad id_loc

rename siri213 groups_1
label var groups_1 "Number of groups in 1st grade"
rename siri215 groups_2
label var groups_2 "Number of groups in 2nd grade"
rename siri217 groups_3
label var groups_3 "Number of groups in 3rd grade"
rename siri219 groups_4
label var groups_4 "Number of groups in 4th grade"
rename siri221 groups_5
label var groups_5 "Number of groups in 5th grade"
rename siri223 groups_6
label var groups_6 "Number of groups in 6th grade"

rename tot87 total_groups
label var total_groups "Total number of groups"

rename tot147 total_stud
label var total_stud "Total students in school"

rename tot165 indig_stud
label var indig_stud "Indigenous stud"

gen anglo_stud=.
label var anglo_stud "English-speak stud"

gen latino_stud=.
label var latino_stud "Foreign latino stud"

gen other_stud=.
label var other_stud "Foreign other stud"

rename tot166 disabil
label var disabil "Stud w/disabilities"

rename tot167 high_abil
label var high_abil "High ability stud"

gen teach_elem=siri231+siri232+siri273+siri274
label var teach_elem "Teachers w/elementary"

gen teach_midle=siri233+siri234+siri275+siri276
label var teach_midle "Teachers w/midle"

gen teach_high=siri235+siri236+siri237+siri277+siri278+siri279
label var teach_high "Teachers w/high"

egen teach_colle=rowtotal(siri238-siri247 siri280-siri289)
label var teach_colle "Teachers w/college"

gen teach_mast=siri248+siri249+siri290+siri291
label var teach_mast "Teachers w/master"

gen teach_phd=siri250+siri251+siri292+siri293
label var teach_phd "Teachers w/phd"

rename siri398 teach_eng
label var teach_eng "English teachers"

rename siri399 hours_eng
label var hours_eng "Hours teach-Eng"

rename siri228 school_supp_exp
label var school_supp_exp "School supplies expenses"

rename siri229 uniform_exp
label var uniform_exp "School uniform expenses"

rename siri225 tuition
label var tuition "Tuition expenses"

gen rural=siri336==1
keep cct shift state id_mun id_loc total_stud indig_stud anglo_stud latino_stud other_stud disabil ///
high_abil teach_elem teach_midle teach_high teach_colle teach_mast rural ///
teach_phd teach_eng hours_eng school_supp_exp uniform_exp tuition total_groups groups_*

gen eng=0
replace eng=1 if hours_eng>0

save "$base\stat911_`x'.dta", replace
*========================================================================*
/* Primaria Indígena */
use "$data\19`x'\PRIMII`x'.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

decode clavecct, gen(cct)
rename turno shift

rename n_entidad state 
rename municipio id_mun 
rename localidad id_loc

rename sini236 groups_1
label var groups_1 "Number of groups in 1st grade"
rename sini237 groups_2
label var groups_2 "Number of groups in 2nd grade"
rename sini238 groups_3
label var groups_3 "Number of groups in 3rd grade"
rename sini239 groups_4
label var groups_4 "Number of groups in 4th grade"
rename sini240 groups_5
label var groups_5 "Number of groups in 5th grade"
rename sini241 groups_6
label var groups_6 "Number of groups in 6th grade"

rename tot120 total_groups
label var total_groups "Total number of groups"

rename tot187 total_stud
label var total_stud "Total students in school"

gen indig_stud=total_stud
label var indig_stud "Indigenous stud"

gen anglo_stud=.
label var anglo_stud "English-speak stud"

gen latino_stud=.
label var latino_stud "Foreign latino stud"

gen other_stud=.
label var other_stud "Foreign other stud"

gen disabil=.
label var disabil "Stud w/disabilities"

gen high_abil=.
label var high_abil "High ability stud"

gen teach_elem=sini254+sini255+sini296+sini297
label var teach_elem "Teachers w/elementary"

gen teach_midle=sini256+sini257+sini298+sini299
label var teach_midle "Teachers w/midle"

gen teach_high=sini258+sini259+sini260+sini300+sini301+sini302
label var teach_high "Teachers w/high"

egen teach_colle=rowtotal(sini261-sini270 sini303-sini312)
label var teach_colle "Teachers w/college"

gen teach_mast=sini271+sini272+sini313+sini314
label var teach_mast "Teachers w/master"

gen teach_phd=sini273+sini274+sini315+sini316
label var teach_phd "Teachers w/phd"

gen teach_eng=.
label var teach_eng "English teachers"

gen hours_eng=.
label var hours_eng "Hours teach-Eng"

gen school_supp_exp=.
label var school_supp_exp "School supplies expenses"

gen uniform_exp=.
label var uniform_exp "School uniform expenses"

gen tuition=.
label var tuition "Tuition expenses"

keep cct shift state id_mun id_loc total_stud indig_stud anglo_stud latino_stud other_stud disabil ///
high_abil teach_elem teach_midle teach_high teach_colle teach_mast ///
teach_phd teach_eng hours_eng total_groups groups_*

gen eng=0
replace eng=1 if hours_eng>0
gen rural=1

append using "$base\stat911_`x'.dta"
sort cct shift
save "$base\stat911_`x'.dta", replace
*========================================================================*
/* Primaria Comunitaria Rural */
use "$data\19`x'\PRIMCI`x'.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

decode clavecct, gen(cct)
rename turno shift

rename n_entidad state 
rename municipio id_mun 
rename localidad id_loc

gen groups_1=1 if tot5>0 | tot21>0 | tot37>0
label var groups_1 "Number of groups in 1st grade"
gen groups_2=1 if tot53>0 | tot68>0 | tot82>0
label var groups_2 "Number of groups in 2nd grade"
gen groups_3=1 if tot96>0 | tot110>0 | tot124>0
label var groups_3 "Number of groups in 3rd grade"

egen total_groups=rowtotal(groups_1-groups_3)
label var total_groups "Total number of groups"

rename tot182 total_stud
label var total_stud "Total students in school"

gen indig_stud=total_stud if sici006==1
replace indig_stud=0 if sici006!=1
label var indig_stud "Indigenous stud"

gen anglo_stud=.
label var anglo_stud "English-speak stud"

gen latino_stud=.
label var latino_stud "Foreign latino stud"

gen other_stud=.
label var other_stud "Foreign other stud"

gen disabil=.
label var disabil "Stud w/disabilities"

gen high_abil=.
label var high_abil "High ability stud"

gen teach_eng=.
label var teach_eng "English teachers"

gen hours_eng=.
label var hours_eng "Hours teach-Eng"

gen school_supp_exp=.
label var school_supp_exp "School supplies expenses"

gen uniform_exp=.
label var uniform_exp "School uniform expenses"

gen tuition=.
label var tuition "Tuition expenses"

keep cct shift state id_mun id_loc total_stud indig_stud anglo_stud latino_stud other_stud disabil ///
high_abil teach_eng hours_eng total_groups groups_*

gen eng=0
replace eng=1 if hours_eng>0
gen rural=1

append using "$base\stat911_`x'.dta"
gen year=19`x'
sort cct shift
save "$base\stat911_`x'.dta", replace
}
*========================================================================*
foreach x in 98 99{
/* Primaria General */
use "$data\19`x'\PRIMGI`x'.dta", clear

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
use "$data\19`x'\PRIMII`x'.dta", clear

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
gen rural=1

append using "$base\stat911_`x'.dta"
sort cct shift
save "$base\stat911_`x'.dta", replace
*========================================================================*
/* Primaria Comunitaria Rural */
use "$data\19`x'\PRIMCI`x'.dta", clear

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
gen rural=1

append using "$base\stat911_`x'.dta"
gen year=19`x'
sort cct shift
save "$base\stat911_`x'.dta", replace
}


*========================================================================*
foreach x in 00 01 02 03 04 05 06 07 08 09 10 11 12 13{
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
gen rural=1

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
gen rural=1

append using "$base\stat911_`x'.dta"
gen year=20`x'
sort cct shift
save "$base\stat911_`x'.dta", replace
}
*========================================================================*
/*
/* To work with 2000 data */
*keep if state=="01" | state=="10" | state=="19" | state=="25" | state=="26" | state=="28"
tostring id_mun, replace format(%03.0f) force
drop state
gen state=substr(cct,1,2)
gen str geo = state + id_mun
merge m:1 geo using "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Data\treated_mun_mergeSchoolCensus.dta"
drop if _merge!=3
*/
*========================================================================*

*========================================================================*
foreach x in 14 15{
/* Primaria General */
use "$data\20`x'\PRIMGI`x'.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

decode clavecct, gen(cct)
rename turno shift
destring shift, replace

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
destring shift, replace

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
gen rural=1

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
destring shift, replace

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
gen rural=1

append using "$base\stat911_`x'.dta"
gen year=20`x'
sort cct shift
save "$base\stat911_`x'.dta", replace
}

*========================================================================*
foreach x in 16{
/* Primaria General */
use "$data\20`x'\PRIMGI`x'.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

replace n_entidad="1" if n_entidad=="AGUASCALIENTES"
replace n_entidad="2" if n_entidad=="BAJA CALIFORNIA"
replace n_entidad="3" if n_entidad=="BAJA CALIFORNIA SUR"
replace n_entidad="4" if n_entidad=="CAMPECHE"
replace n_entidad="7" if n_entidad=="CHIAPAS"
replace n_entidad="8" if n_entidad=="CHIHUAHUA"
replace n_entidad="5" if n_entidad=="COAHUILA DE ZARAGOZA"
replace n_entidad="6" if n_entidad=="COLIMA"
replace n_entidad="9" if n_entidad=="DISTRITO FEDERAL"
replace n_entidad="10" if n_entidad=="DURANGO"
replace n_entidad="11" if n_entidad=="GUANAJUATO"
replace n_entidad="12" if n_entidad=="GUERRERO"
replace n_entidad="13" if n_entidad=="HIDALGO"
replace n_entidad="14" if n_entidad=="JALISCO"
replace n_entidad="15" if n_entidad=="MEXICO"
replace n_entidad="16" if n_entidad=="MICHOACAN DE OCAMPO"
replace n_entidad="17" if n_entidad=="MORELOS"
replace n_entidad="18" if n_entidad=="NAYARIT"
replace n_entidad="19" if n_entidad=="NUEVO LEON"
replace n_entidad="20" if n_entidad=="OAXACA"
replace n_entidad="21" if n_entidad=="PUEBLA"
replace n_entidad="22" if n_entidad=="QUERETARO"
replace n_entidad="23" if n_entidad=="QUINTANA ROO"
replace n_entidad="24" if n_entidad=="SAN LUIS POTOSI"
replace n_entidad="25" if n_entidad=="SINALOA"
replace n_entidad="26" if n_entidad=="SONORA"
replace n_entidad="27" if n_entidad=="TABASCO"
replace n_entidad="28" if n_entidad=="TAMAULIPAS"
replace n_entidad="29" if n_entidad=="TLAXCALA"
replace n_entidad="30" if n_entidad=="VERACRUZ DE IGNACIO DE LA LLAVE"
replace n_entidad="31" if n_entidad=="YUCATAN"
replace n_entidad="32" if n_entidad=="ZACATECAS"

destring n_entidad, replace
rename clavecct cct
rename turno shift
destring shift, replace

rename n_entidad state 
rename municipio id_mun 
destring id_mun, replace
rename localidad id_loc
destring id_loc, replace

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

replace n_entidad="1" if n_entidad=="AGUASCALIENTES"
replace n_entidad="2" if n_entidad=="BAJA CALIFORNIA"
replace n_entidad="3" if n_entidad=="BAJA CALIFORNIA SUR"
replace n_entidad="4" if n_entidad=="CAMPECHE"
replace n_entidad="7" if n_entidad=="CHIAPAS"
replace n_entidad="8" if n_entidad=="CHIHUAHUA"
replace n_entidad="5" if n_entidad=="COAHUILA DE ZARAGOZA"
replace n_entidad="6" if n_entidad=="COLIMA"
replace n_entidad="9" if n_entidad=="DISTRITO FEDERAL"
replace n_entidad="10" if n_entidad=="DURANGO"
replace n_entidad="11" if n_entidad=="GUANAJUATO"
replace n_entidad="12" if n_entidad=="GUERRERO"
replace n_entidad="13" if n_entidad=="HIDALGO"
replace n_entidad="14" if n_entidad=="JALISCO"
replace n_entidad="15" if n_entidad=="MEXICO"
replace n_entidad="16" if n_entidad=="MICHOACAN DE OCAMPO"
replace n_entidad="17" if n_entidad=="MORELOS"
replace n_entidad="18" if n_entidad=="NAYARIT"
replace n_entidad="19" if n_entidad=="NUEVO LEON"
replace n_entidad="20" if n_entidad=="OAXACA"
replace n_entidad="21" if n_entidad=="PUEBLA"
replace n_entidad="22" if n_entidad=="QUERETARO"
replace n_entidad="23" if n_entidad=="QUINTANA ROO"
replace n_entidad="24" if n_entidad=="SAN LUIS POTOSI"
replace n_entidad="25" if n_entidad=="SINALOA"
replace n_entidad="26" if n_entidad=="SONORA"
replace n_entidad="27" if n_entidad=="TABASCO"
replace n_entidad="28" if n_entidad=="TAMAULIPAS"
replace n_entidad="29" if n_entidad=="TLAXCALA"
replace n_entidad="30" if n_entidad=="VERACRUZ DE IGNACIO DE LA LLAV"
replace n_entidad="31" if n_entidad=="YUCATAN"
replace n_entidad="32" if n_entidad=="ZACATECAS"

destring n_entidad, replace
rename clavecct cct
rename turno shift
destring shift, replace

rename n_entidad state 
rename municipio id_mun 
destring id_mun, replace
rename localidad id_loc
destring id_loc, replace

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
gen rural=1

append using "$base\stat911_`x'.dta"
sort cct shift
save "$base\stat911_`x'.dta", replace
*========================================================================*
/* Primaria Comunitaria Rural */
use "$data\20`x'\PRIMCI`x'.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

replace n_entidad="1" if n_entidad=="AGUASCALIENTES"
replace n_entidad="2" if n_entidad=="BAJA CALIFORNIA"
replace n_entidad="3" if n_entidad=="BAJA CALIFORNIA SUR"
replace n_entidad="4" if n_entidad=="CAMPECHE"
replace n_entidad="7" if n_entidad=="CHIAPAS"
replace n_entidad="8" if n_entidad=="CHIHUAHUA"
replace n_entidad="5" if n_entidad=="COAHUILA DE ZARAGOZA"
replace n_entidad="6" if n_entidad=="COLIMA"
replace n_entidad="9" if n_entidad=="DISTRITO FEDERAL"
replace n_entidad="10" if n_entidad=="DURANGO"
replace n_entidad="11" if n_entidad=="GUANAJUATO"
replace n_entidad="12" if n_entidad=="GUERRERO"
replace n_entidad="13" if n_entidad=="HIDALGO"
replace n_entidad="14" if n_entidad=="JALISCO"
replace n_entidad="15" if n_entidad=="MEXICO"
replace n_entidad="16" if n_entidad=="MICHOACAN DE OCAMPO"
replace n_entidad="17" if n_entidad=="MORELOS"
replace n_entidad="18" if n_entidad=="NAYARIT"
replace n_entidad="19" if n_entidad=="NUEVO LEON"
replace n_entidad="20" if n_entidad=="OAXACA"
replace n_entidad="21" if n_entidad=="PUEBLA"
replace n_entidad="22" if n_entidad=="QUERETARO"
replace n_entidad="23" if n_entidad=="QUINTANA ROO"
replace n_entidad="24" if n_entidad=="SAN LUIS POTOSI"
replace n_entidad="25" if n_entidad=="SINALOA"
replace n_entidad="26" if n_entidad=="SONORA"
replace n_entidad="27" if n_entidad=="TABASCO"
replace n_entidad="28" if n_entidad=="TAMAULIPAS"
replace n_entidad="29" if n_entidad=="TLAXCALA"
replace n_entidad="30" if n_entidad=="VERACRUZ DE IGNACIO DE LA LLAV"
replace n_entidad="31" if n_entidad=="YUCATAN"
replace n_entidad="32" if n_entidad=="ZACATECAS"

destring n_entidad, replace
rename clavecct cct
rename turno shift
destring shift, replace

rename n_entidad state 
rename municipio id_mun 
destring id_mun, replace
rename localidad id_loc
destring id_loc, replace

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
replace indig_stud=v363 if v2=="X"
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
gen rural=1

append using "$base\stat911_`x'.dta"
gen year=20`x'
sort cct shift
save "$base\stat911_`x'.dta", replace
}

*========================================================================*
foreach x in 17{
/* Primaria General */
use "$data\20`x'\PRIMGI`x'.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

rename cv_cct cct
rename cv_turno shift
destring shift, replace

rename cv_ent_adm state 
rename cv_mun id_mun 
rename cv_loc id_loc

rename v609 groups_1
label var groups_1 "Number of groups in 1st grade"
rename v610 groups_2
label var groups_2 "Number of groups in 2nd grade"
rename v611 groups_3
label var groups_3 "Number of groups in 3rd grade"
rename v612 groups_4
label var groups_4 "Number of groups in 4th grade"
rename v613 groups_5
label var groups_5 "Number of groups in 5th grade"
rename v614 groups_6
label var groups_6 "Number of groups in 6th grade"

rename v616 total_groups
label var total_groups "Total number of groups"

rename v608 total_stud
label var total_stud "Total students in school"

rename v647 indig_stud
label var indig_stud "Indigenous stud"

gen anglo_stud=v650+v653+v671
label var anglo_stud "English-speak stud"

gen latino_stud=v656+v659
label var latino_stud "Foreign latino stud"

gen other_stud=v662+v665+v668
label var other_stud "Foreign other stud"

gen disabil=v1083-v1041
label var disabil "Stud w/disabilities"

rename v1041 high_abil
label var high_abil "High ability stud"

gen teach_elem=v1092+v1093+v1112+v1113
label var teach_elem "Teachers w/elementary"

gen teach_midle=v1132+v1133+v1152+v1153
label var teach_midle "Teachers w/midle"

gen teach_high=v1172+v1173+v1192+v1193+v1212+v1213
label var teach_high "Teachers w/high"

gen teach_colle=v1232+v1233+v1252+v1253+v1272+v1273+v1292+v1293+v1312+v1313 ///
+v1332+v1333+v1352+v1353+v1372+v1373+v1392+v1393+v1412+v1413
label var teach_colle "Teachers w/college"

gen teach_mast=v1432+v1433+v1452+v1453
label var teach_mast "Teachers w/master"

gen teach_phd=v1472+v1473+v1492+v1493
label var teach_phd "Teachers w/phd"

gen teach_eng=v1583+v1584
label var teach_eng "English teachers"

rename v1680 hours_eng
label var hours_eng "Hours teach-Eng"

rename v1720 school_supp_exp
label var school_supp_exp "School supplies expenses"

rename v1721 uniform_exp
label var uniform_exp "School uniform expenses"

rename v1722 tuition
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

rename cv_cct cct
rename cv_turno shift
destring shift, replace

rename cv_ent_adm state 
rename cv_mun id_mun 
rename cv_loc id_loc

gen total_stud=v618
label var total_stud "Total students in school"

rename v618 indig_stud
label var indig_stud "Indigenous stud"

rename v1045 groups_1
label var groups_1 "Number of groups in 1st grade"
rename v1046 groups_2
label var groups_2 "Number of groups in 2nd grade"
rename v1047 groups_3
label var groups_3 "Number of groups in 3rd grade"
rename v1048 groups_4
label var groups_4 "Number of groups in 4th grade"
rename v1049 groups_5
label var groups_5 "Number of groups in 5th grade"
rename v1050 groups_6
label var groups_6 "Number of groups in 6th grade"

rename v1052 total_groups
label var total_groups "Total number of groups"

gen anglo_stud=0
label var anglo_stud "English-speak stud"

gen latino_stud=0
label var latino_stud "Foreign latino stud"

gen other_stud=0
label var other_stud "Foreign other stud"

gen disabil=v1016-v974
label var disabil "Stud w/disabilities"

rename v974 high_abil
label var high_abil "High ability stud"

gen teach_elem=v1168+v1169+v1182+v1183
label var teach_elem "Teachers w/elementary"

gen teach_midle=v1196+v1197+v1210+v1211
label var teach_midle "Teachers w/midle"

gen teach_high=v1224+v1225+v1238+v1239+v1252+v1253
label var teach_high "Teachers w/high"

gen teach_colle=v1266+v1267+v1280+v1281+v1294+v1295+v1308+v1309+v1322+v1323 ///
+v1336+v1337+v1350+v1351+v1364+v1365+v1378+v1379+v1392+v1393
label var teach_colle "Teachers w/college"

gen teach_mast=v1406+v1407+v1420+v1421
label var teach_mast "Teachers w/master"

gen teach_phd=v1434+v1435+v1448+v1449
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
gen rural=1

append using "$base\stat911_`x'.dta"
sort cct shift
save "$base\stat911_`x'.dta", replace
*========================================================================*
/* Primaria Comunitaria Rural */
use "$data\20`x'\PRIMCI`x'.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

rename cv_cct cct
rename cv_turno shift
destring shift, replace

rename cv_ent_adm state 
rename cv_mun id_mun 
rename cv_loc id_loc

gen groups_1=1 if v232!=0
label var groups_1 "Number of groups in 1st grade"
gen groups_2=1 if v287!=0
label var groups_2 "Number of groups in 2nd grade"
gen groups_3=1 if v337!=0
label var groups_3 "Number of groups in 3rd grade"
gen groups_4=1 if v382!=0
label var groups_4 "Number of groups in 4th grade"
gen groups_5=1 if v422!=0
label var groups_5 "Number of groups in 5th grade"
gen groups_6=1 if v457!=0
label var groups_6 "Number of groups in 6th grade"

egen total_groups=rowtotal(groups_1 groups_2 groups_3 groups_4 groups_5 groups_6)
label var total_groups "Total number of groups"
replace total_groups=1 if total_groups==0 & v515!=0
replace total_groups=. if total_groups==0

gen total_stud=v515
label var total_stud "Total students in school"

gen indig_stud=v170
label var indig_stud "Indigenous stud"

gen anglo_stud=0
label var anglo_stud "English-speak stud"

gen latino_stud=0
label var latino_stud "Foreign latino stud"

gen other_stud=0
label var other_stud "Foreign other stud"

gen disabil=v582-v576
label var disabil "Stud w/disabilities"

rename v576 high_abil
label var high_abil "High ability stud"

gen teach_eng=0
label var teach_eng "English teachers"

gen hours_eng=0
label var hours_eng "Hours teach-Eng"

keep cct shift state id_mun id_loc total_stud indig_stud anglo_stud latino_stud other_stud disabil ///
high_abil teach_eng hours_eng total_groups groups_*

gen eng=0
replace eng=1 if hours_eng>0
gen rural=1

append using "$base\stat911_`x'.dta"
gen year=20`x'
sort cct shift
save "$base\stat911_`x'.dta", replace
}