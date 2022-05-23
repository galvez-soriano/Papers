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
gl data= "C:\Users\galve\Documents\Papers\Ideas\Education\Peer effects in middle schools\Data"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New"
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
