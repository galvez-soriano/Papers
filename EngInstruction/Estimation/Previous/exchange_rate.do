*=======================================================*
/* Do file to convert daily exchange rate to monthly */
*=======================================================*
clear
replace tc="" if tc=="N/E"
destring tc, replace
replace date = subinstr(date, "/", "",.)

gen month=substr(date,3,2)
gen year=substr(date,5,4)

collapse (mean) tc, by(year month)
