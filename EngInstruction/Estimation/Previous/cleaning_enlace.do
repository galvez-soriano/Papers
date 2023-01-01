
cd "D:\Google Drive\Project SEP-CPG\Data"
use enlace_full, clear

*working subsample
keep if nivel=="PRIMARIA"
keep if year>2009
sort cct curp year

*panel
bysort curp: gen panel=_N
keep if panel>1
sort cct curp year

*id
egen id=group(curp)

*gender
drop sexo
gen sexo=substr(curp,11,1)
gen sex=1 if sexo=="M"
replace sex=0 if sexo=="H"
label define sex 1 "Mujer" 0 "Hombre"
label values sex sex
drop sexo 
ren sex sexo


*marginal level
destring cve_marg, replace
bys cct: egen marginal=min(cve_marg)
label define marginal 5 "Muy Bajo" 4 "Bajo" 3 "Medio" 2 "Alto" 1 "Muy Alto"
label values marginal marginal
drop cve_marg margina

*privada
gen privada=0
replace privada=1 if modalidad=="PARTICULAR"

*grado
destring grado, replace

*grupo
encode grupo, gen(group)
drop grupo
ren group grupo

drop municipio nombre_mun nvl_esp nvl_mat nvl_fce c_dupli

*drop last wrong CURPS
gen c_dupli=substr(curp,18,1)
drop if c_dupli==""

order nofolio curp cct year nivel turno grupo grado modalidad p_esp p_mat p_cie sexo year marginal 

sort cct curp year

save enlace_primary_0913, replace


