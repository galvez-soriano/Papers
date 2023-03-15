******************************************************************
********************** Oscar Galvez-Soriano **********************
*** 		   Education and EconomicGrowth of Mexico  	       ***
******************************************************************
clear
set more off
gl data="C:\Users\Oscar Galvez\Documents\Papers\EG\ENOE2019_III"
******************************************************************
use "$data\SDEMT319.dta", clear
tostring cd_a ent v_sel n_ren, replace format(%02.0f) force
tostring con, replace format(%04.0f) force
tostring  n_hog  h_mud  , replace force

gen str foliop = (cd_a + ent + con + v_sel + n_hog + h_mud + n_ren)

sort foliop

replace anios_esc=. if anios_esc==99
replace clase2=. if clase2==0
replace clase2=. if clase2==3
replace clase2=. if clase2==4

tab clase2 if anios_esc<=6
tab clase2 if anios_esc>6 & anios_esc<=9
tab clase2 if anios_esc>9 & anios_esc<=12
tab clase2 if anios_esc>12 & anios_esc<=16
tab clase2 if anios_esc>16 & anios_esc<=18
tab clase2 if anios_esc>18

gen unemploy=0
replace unemploy=1 if clase2==2

tabstat unemploy, by(anios_esc)

gen esc2=anios_esc^2
reg unemploy anios_esc esc2, noconstant
predict unem
collapse unem, by(anios_esc)

use "$data\unem.dta", clear
reg unem age age2, noconstant
predict unemploy

label var unemploy "Unemployment rate"
label var age "Schooling"

line unemploy age
