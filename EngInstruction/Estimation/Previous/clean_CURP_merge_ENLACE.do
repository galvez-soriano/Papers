*========================================================================*
* SEP Project

clear
set more off

global data "D:\Google Drive\Project SEP-CPG\Data\ENLACE"

/*
General instructions:

Before running this code, be sure that all your CURP databases have the
following names: "alumnos_curp_YEAR.dta", where YEAR=[06-13].
Also make sure that the ENLACE results databases have the following 
names: "result_enl_YEAR.dta", where YEAR=[2006-2013].
Each year is saved in a separate folder named "ENLACE_YEAR", where 
again YEAR=[2006-2013].
*/

*========================================================================*
* CURP 
*========================================================================*

*Lines 27 to 31 are to enter each folder rename files and use each "alumnos" database
	cd "$data"
	local carpetas : dir . dir  "*"
	foreach path of local carpetas{
	cd "$data/`path'"
	local year = substr("`path'", -2 , . )
	di `year'
	*capture !rename puntajes_alumnos_`year'.dta result_enl_20`year'.dta //renames all "puntajes" files to a common name.

	use alumnos_curp_`year', clear
	capture ren curp curp_n
	
	*we make all characters in CURP uppercase. 
	replace curp_n = upper(curp)
	
	*we create a new CURP without any funny signs: $%&(·=!.
	egen curp = sieve(curp_n), keep(a n) 
	
* Positions 1 to 4: represent the first two letters of first last name and the first letter of the second last name and first name.	
	
	gen c_name1=substr(curp,1,1)
	gen c_name2=substr(curp,2,1)
	gen c_name3=substr(curp,3,1)
	gen c_name4=substr(curp,4,1)

	*We drop no-numbers from the first 4 characters 
	foreach x in 1 2 3 4{
	drop if c_name`x'=="0" | c_name`x'=="1" | c_name`x'=="2" | c_name`x'=="3" | /// 
	c_name`x'== "4" | c_name`x'== "5" | c_name`x'=="6" | c_name`x'=="7" /// 
	| c_name`x'== "8" | c_name`x'== "9"  | c_name`x'== ""   
		}

* Position 5 to 10 represent date of birth yy/mm/dd 

	gen c_dob1=substr(curp,5,6)
	egen c_dob = sieve(c_dob1), keep(a) // we identify if there are letters instead of numbers
	drop if c_dob!="" & c_dob!="O" //and we drop them! 
	
	*we substitute Os with 0s (apparently, a common mistake)
	replace curp = substr(curp,1,4) + "0" + substr(curp,6,.)  if substr(curp,5,1) == "O"
	replace curp = substr(curp,1,5) + "0" + substr(curp,7,.)  if substr(curp,6,1) == "O"
	replace curp = substr(curp,1,6) + "0" + substr(curp,8,.)  if substr(curp,7,1) == "O"
	replace curp = substr(curp,1,7) + "0" + substr(curp,9,.)  if substr(curp,8,1) == "O"
	replace curp = substr(curp,1,8) + "0" + substr(curp,10,.)  if substr(curp,9,1) == "O"
	replace curp = substr(curp,1,9) + "0" + substr(curp,11,.)  if substr(curp,10,1) == "O"

* Position 11 identifies gender

	gen c_sex=substr(curp,11,1)
	keep if c_sex=="H" | c_sex=="M" 

* Position 12-13 identify state of birth	
	
	gen c_state=substr(curp,12,2)

	*we keep only those born in states that actually exists and NE (Foreigners) 
	keep if c_state=="AS" | c_state=="BC" | c_state=="BS" | c_state=="CC" | ///
	c_state=="CL" | c_state=="CM" | c_state=="CS" | c_state=="CH" | ///
	c_state=="DF" | c_state=="DG" | c_state=="GT" | c_state=="GR" | ///
	c_state=="HG" | c_state=="JC" | c_state=="MC" | c_state=="MN" | ///
	c_state=="MS" | c_state=="NT" | c_state=="NL" | c_state=="OC" | ///
	c_state=="PL" | c_state=="QT" | c_state=="QR" | c_state=="SP" | ///
	c_state=="SL" | c_state=="SR" | c_state=="TC" | c_state=="TS" | ///
	c_state=="TL" | c_state=="VZ" | c_state=="YN" | c_state=="ZS" | ///
	c_state=="NE"    

* Position 14 to 16 represent the second consonant in first and second last name and first name.

	gen c_cname1=substr(curp,14,1)
	gen c_cname2=substr(curp,15,1)
	gen c_cname3=substr(curp,16,1)

	*we drop all with non-consonants in such positions.
	foreach x in 1 2 3 {
		drop if c_cname`x'=="0"
		drop if c_cname`x'=="1"
		drop if c_cname`x'=="2"
		drop if c_cname`x'=="3"
		drop if c_cname`x'=="4"
		drop if c_cname`x'=="5"
		drop if c_cname`x'=="6"
		drop if c_cname`x'=="7"
		drop if c_cname`x'=="8"
		drop if c_cname`x'=="9"
		drop if c_cname`x'=="A"
		drop if c_cname`x'=="E"
		drop if c_cname`x'=="I"
		drop if c_cname`x'=="O"
		drop if c_cname`x'=="U"
	}

* Position 17 identifies with (A-Z) if child was born after 1999 and 0-9 if she was born before 2000s.
* position 18 should always be a 0-9.

	gen str dob_year=substr(curp,5,2)
	gen str dob_month=substr(curp,7,2)
	
	* we drop unrealistic years of birth
	drop if dob_year>"13" & dob_year<"93"
	
	* we replace all 0s in position 17th in CURP with "Os" if born after 1999 (apparently a common mistake)
    replace curp = substr(curp,1,16) + "O" + substr(curp,18,.)  if substr(curp,17,1) == "0" & dob_year<"14"
	
	gen c_date=substr(curp,17,1)
	destring c_date, replace force // we keep only numbers, it is useful to delete letters, now = "."
	
	* we delete observation where position 18 is not 0-9.
	gen c_dupli=substr(curp,18,1)
	destring c_dupli, replace force
    drop if c_dupli==.
   
   * if child was born after 1999 and position 17th is a number and 18th is a letter we switch them in CURP (apparently not a common mistake!)
    replace curp = substr(curp,1,16) + substr(curp,18,1) + substr(curp,17,1)  if c_date!=. & c_dupli==. & dob_year<"14"
  
   * we drop verifiers in position 17th wich do not match the rule: born after 99 = "A-Z" & born before 2000 = "0-9" 
			drop if c_date<=9 & dob_year<"14"
			drop if c_date==. & dob_year>"92"

	keep nofolio curp 
	count

*Saving and merging

	save curp20`year'_merged.dta, replace
	
	merge 1:1 nofolio using result_enl_20`year' 
	drop if _merge==1
	drop if _merge==2
	drop _merge
	
	gen year=20`year'
	
	save "D:\Google Drive\Project SEP-CPG\Data\enlace20`year'_merged", replace
	
}


*========================================================================*
* Append ENLACE databases
*========================================================================*

clear
cd "D:\Google Drive\Project SEP-CPG\Data"

foreach x in 2006 2007 2008 2009 2010 2011 2012 2013{

use enlace`x'_merged, clear

capture ren cal_esp p_esp 
capture ren cal_mat p_mat
capture ren cal_c_n p_cie
capture ren cal_fce p_cie
capture ren cal_cie p_cie
capture ren cal_new p_cie
capture ren mod_sep modalidad
capture drop ent entidad

save enlace`x'_curp, replace
}


use enlace2006_curp, clear
drop observalci

append using enlace2007_curp, force
drop variabl0 nm observaci

append using enlace2008_curp, force
drop copia esp_50 variabl0 mat_50 nm c_n_50 nc

append using enlace2009_curp, force
drop observacio esp_50 mat_50 fce_50 copia

append using enlace2010_curp, force
drop esp_50 variabl0 mat_50 nm new_50 nn copia

append using enlace2011_curp, force
drop esp_50 variabl0 mat_50 nm new_50 nn copia

append using enlace2012_curp, force
drop variabl0 nm nc esp_50 mat_50 cie_50 copia

append using enlace2013_curp, force
drop variabl0 nm esp_50 mat_50 copia fce_50 fce

save enlace_full, replace



/*
	* we make all characters in position 17th uppercase. 
		levelsof c_date, local(levels)  
		foreach l of local levels{
			replace c_date = "`=upper("`l'")'" if c_date=="`l'"
			}
*/
