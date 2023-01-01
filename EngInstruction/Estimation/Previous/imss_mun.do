*========================================================================*
/* Code to generate mun_imss database 
Oscar Galvez-Soriano */
*========================================================================*
clear
rename llave_municipio id_mun 
rename llave_entidad state
rename clave_municipio_inegi mun

tostring state, replace format(%02.0f) force
tostring mun, replace format(%03.0f) force

gen id_geo=(state+mun)
keep id_mun id_geo
save "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Labor\mun_imss.dta", replace
