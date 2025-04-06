*========================================================================*
/* English skills and labor market outcomes in Mexico */
*========================================================================*
/* Author: Oscar Galvez-Soriano */
*========================================================================*
clear
set more off
import dbase using "C:\Users\Oscar Galvez Soriano\Documents\Papers\ReturnsEng\Data\enilems12\cbasico.dbf"

foreach v of varlist _all {
      capture rename `v' `=lower("`v'")'
}

save "C:\Users\Oscar Galvez Soriano\Documents\Papers\ReturnsEng\Data\enilems12\hsg_data.dta"

*========================================================================*
/* ENOE */
*========================================================================*
use "C:\Users\Oscar Galvez Soriano\Downloads\enoe_2024\ENOE_VIVT424.dta" , clear
tostring mun, replace format(%03.0f)
tostring ent , gen(state) format(%02.0f)

collapse ur, by(state mun cd_a)
label drop cd_a
order state mun
sort state mun cd_a
drop ur



/* 
To work ar the locality level with RAs:
https://www.inegi.org.mx/contenidos/productos/prod_serv/contenidos/espanol/bvinegi/productos/nueva_estruc/889463909743.pdf
*/

/* 
Description of the data:
https://en.www.inegi.org.mx/contenidos/programas/enilems/2012/doc/enilems12_fd.pdf
*/