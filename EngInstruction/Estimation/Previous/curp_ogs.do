*========================================================================*
* SEP Project
/* 
General instructions:

Before running this code, be sure that all your CURP databases have the
following names: "alumnos_curp_YEAR.dta", where YEAR=[06-13].
Also make sure that the ENLACE results databases have the following 
names: "result_enl_YEAR.dta", where YEAR=[2006-2013].
Finally, the global I define in line 16 sets the path where I saved the 
data. Each year is saved in a separate folder named "ENLACE_YEAR", where 
again YEAR=[2006-2013].

Note: before running you have to change the name of variable curp_n for 
curp in "alumnos_curp_13.dta" database.
*/
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Ideas\Education\SEP"
*========================================================================*
* CURP 
*========================================================================*
foreach i in 06 07 08 09 10 11 12 13 {
	use "$data\ENLACE\ENLACE_20`i'\alumnos_curp_`i'.dta", clear

	gen c_sex=substr(curp,11,1)
	gen c_state=substr(curp,12,2)
	gen c_dob1=substr(curp,5,1)
	gen c_dob2=substr(curp,6,1)
	gen c_dob3=substr(curp,7,1)
	gen c_dob4=substr(curp,8,1)
	gen c_dob5=substr(curp,9,1)
	gen c_dob6=substr(curp,10,1)
	gen str dob_year=c_dob1+c_dob2
	gen str dob_month=c_dob3+c_dob4
	gen c_date=substr(curp,17,1)
	replace c_date="A" if c_date=="a"
	replace c_date="B" if c_date=="b"
	replace c_date="C" if c_date=="c"
	replace c_date="D" if c_date=="d"
	replace c_date="E" if c_date=="e"
	replace c_date="F" if c_date=="f"
	replace c_date="G" if c_date=="g"
	replace c_date="H" if c_date=="h"
	replace c_date="I" if c_date=="i"
	replace c_date="J" if c_date=="j"
	replace c_date="K" if c_date=="k"
	replace c_date="L" if c_date=="l"
	replace c_date="M" if c_date=="m"
	replace c_date="N" if c_date=="n"
	replace c_date="O" if c_date=="o"
	replace c_date="P" if c_date=="p"
	replace c_date="Q" if c_date=="q"
	replace c_date="R" if c_date=="r"
	replace c_date="S" if c_date=="s"
	replace c_date="T" if c_date=="t"
	replace c_date="U" if c_date=="u"
	replace c_date="V" if c_date=="v"
	replace c_date="W" if c_date=="w"
	replace c_date="X" if c_date=="x"
	replace c_date="Y" if c_date=="y"
	replace c_date="Z" if c_date=="z"

	gen c_dupli1=substr(curp,18,1)
	gen c_dupli2=substr(curp,19,1)

	foreach x in 1 2 {
		replace c_dupli`x'="A" if c_dupli`x'=="a"
		replace c_dupli`x'="B" if c_dupli`x'=="b"
		replace c_dupli`x'="C" if c_dupli`x'=="c"
		replace c_dupli`x'="D" if c_dupli`x'=="d"
		replace c_dupli`x'="E" if c_dupli`x'=="e"
		replace c_dupli`x'="F" if c_dupli`x'=="f"
		replace c_dupli`x'="G" if c_dupli`x'=="g"
		replace c_dupli`x'="H" if c_dupli`x'=="h"
		replace c_dupli`x'="I" if c_dupli`x'=="i"
		replace c_dupli`x'="J" if c_dupli`x'=="j"
		replace c_dupli`x'="K" if c_dupli`x'=="k"
		replace c_dupli`x'="L" if c_dupli`x'=="l"
		replace c_dupli`x'="M" if c_dupli`x'=="m"
		replace c_dupli`x'="N" if c_dupli`x'=="n"
		replace c_dupli`x'="O" if c_dupli`x'=="o"
		replace c_dupli`x'="P" if c_dupli`x'=="p"
		replace c_dupli`x'="Q" if c_dupli`x'=="q"
		replace c_dupli`x'="R" if c_dupli`x'=="r"
		replace c_dupli`x'="S" if c_dupli`x'=="s"
		replace c_dupli`x'="T" if c_dupli`x'=="t"
		replace c_dupli`x'="U" if c_dupli`x'=="u"
		replace c_dupli`x'="V" if c_dupli`x'=="v"
		replace c_dupli`x'="W" if c_dupli`x'=="w"
		replace c_dupli`x'="X" if c_dupli`x'=="x"
		replace c_dupli`x'="Y" if c_dupli`x'=="y"
		replace c_dupli`x'="Z" if c_dupli`x'=="z"
	}

	keep nofolio curp c_sex c_state dob_year dob_month

	save "$data\ENLACE\ENLACE_20`i'\curp20`i'.dta", replace
}
*========================================================================*
* Merge CURP with ENLACE 
*========================================================================*
foreach i in 06 07 08 09 10 11 12 13 {
	use "$data\ENLACE\ENLACE_20`i'\result_enl_20`i'.dta", clear

	merge 1:1 nofolio using "$data\ENLACE\ENLACE_20`i'\curp20`i'.dta"
	drop if _merge==1
	drop if _merge==2
	drop _merge
	
	gen year=20`i'

	save "$data\ENLACE\ENLACE_20`i'\enlace20`i'.dta", replace
}
*========================================================================*
* Example: Append 2006 and 2007 ENLACE databases
*========================================================================*
clear
append using "$data\ENLACE\ENLACE_2006\enlace2006.dta" ///
"$data\ENLACE\ENLACE_2007\enlace2007.dta", force
sort cct curp
bysort curp: gen panel=_N
tab year if panel==1
keep if panel==2
sort curp
