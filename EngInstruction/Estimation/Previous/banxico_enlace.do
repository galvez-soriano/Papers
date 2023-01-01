*========================================================================*
/* The effect of an English program on labor market outcomes and school 
achievement */
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
*Define your directory
cd "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New"
*========================================================================*
use enlace_ogs

*Generating modfied curp
gen curp_m=substr(curp,5,14)

*Merging with IMSS database. Note: curp_m should also be in the imss database.
merge 1:1 curp_m using imss

/* If curp_m does not uniquely identify observations in the data set use 
instead: "merge m:m". Although this is not the best option, the duplicated 
cases will be the less common. Example: */

* merge m:m curp_m using imss
