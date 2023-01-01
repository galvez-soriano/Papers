*========================================================================*
* The effect of the English program on school achievement
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\Oscar Galvez\Documents\Papers\Working papers\Peer effects in middle schools\Data"
gl base= "C:\Users\Oscar Galvez\Documents\Papers\Current\English on labor outcomes\Data\DBase_NL"

/* Primaria General */
use "$data\2006\PRIMGI06.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

decode clavecct, gen(cct)
rename turno shift

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

keep cct shift indig_stud anglo_stud latino_stud other_stud disabil ///
high_abil teach_elem teach_midle teach_high teach_colle teach_mast ///
teach_phd teach_eng hours_eng h_eng_pt school_supp_exp uniform_exp ///
tuition

save "$base\stat911_06.dta", replace

/* Primaria Indígena */
use "$data\2006\PRIMII06.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

decode clavecct, gen(cct)
rename turno shift

rename v344 indig_stud
label var indig_stud "Indigenous stud"

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

keep cct shift indig_stud anglo_stud latino_stud other_stud disabil ///
high_abil teach_elem teach_midle teach_high teach_colle teach_mast ///
teach_phd teach_eng hours_eng h_eng_pt

append using "$base\stat911_06.dta"
sort cct
save "$base\stat911_06.dta", replace

/* Primaria Comunitaria Rural */
use "$data\2006\PRIMCI06.dta", clear

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

decode clavecct, gen(cct)
rename turno shift

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

keep cct shift indig_stud anglo_stud latino_stud other_stud disabil ///
high_abil teach_eng hours_eng h_eng_pt

append using "$base\stat911_06.dta"
sort cct
save "$base\stat911_06.dta", replace
