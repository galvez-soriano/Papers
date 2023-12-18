*========================================================================*
* Working with ENIGH 2006
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/Metrobus/Data/2006"
gl base= "C:\Users\galve\Documents\Papers\Current\Metrobus\Data"
*========================================================================*
/* Sociodemographic 2006 */
*========================================================================*
use "$data/sdem06_1.dta", clear
append using "$data/sdem06_2.dta"

gen str id=folio+num_ren
label var id "ID" // This is the example of how to add labels to variables
rename folio hid
rename parentesco relation
gen female=sexo=="2"
rename edad age
rename residencia state
gen student=asis_esc=="1"
rename nivel stud_level
rename grado stud_grade
gen private=tipo_esc=="2"
destring n_instr141 n_instr142, replace
gen edu=.
replace edu=0 if n_instr141==0 | n_instr141==1
replace edu=n_instr142 if n_instr141==2
replace edu=6+n_instr142 if n_instr141==3
replace edu=9+n_instr142 if n_instr141==4 & antec_esc==" "
replace edu=9+n_instr142 if n_instr141==4 & antec_esc=="2"
replace edu=9+n_instr142 if n_instr141==5 & antec_esc=="2"
replace edu=n_instr142 if n_instr141==6 & antec_esc=="1"
replace edu=9+n_instr142 if n_instr141==6 & antec_esc=="2"
replace edu=12+n_instr142 if n_instr141==5 & antec_esc=="3"
replace edu=12+n_instr142 if n_instr141==6 & antec_esc=="3"
replace edu=12+n_instr142 if n_instr141==7 & antec_esc=="3"
replace edu=16+n_instr142 if n_instr141==8 & antec_esc=="4"
replace edu=16+n_instr142 if n_instr141==9 & antec_esc=="4"
replace edu=18+n_instr142 if n_instr141==9 & antec_esc=="5"
gen work=trabajo=="1"
gen paidw=sueldo08=="1" | sueldo19=="1"
gen labor=trabajo=="1" | bus_trab=="10" | (bus_trab>"100" & bus_trab<"200" & bus_trab!=" ")
gen self_emp=posicion07>="4" // Not sure if we should include 4 or not
rename scian101 naics
rename cmo091 occupa
rename horas_trab hrs_work

order id hid state relation female age student stud_level stud_grade private ///
edu work verific labor paidw self_emp naics occupa hrs_work
keep id hid state relation female age student stud_level stud_grade private ///
edu work verific labor paidw self_emp naics occupa hrs_work

save "$base\2006.dta", replace
*========================================================================*
/* Household 2006 */
*========================================================================*
use "$data/hh06.dta", clear

rename folio hid
rename ubica_geo mun_id
rename residentes hh_size
rename vehi04_1 car
rename vehi04_2 suv
rename vehi04_3 truck
rename vehi04_4 motorcycle
rename vehi04_5 bicycle
rename factor weight

order hid mun_id weight hh_size car suv truck motorcycle bicycle
keep hid mun_id weight hh_size car suv truck motorcycle bicycle

merge 1:m hid using "$base\2006.dta", nogen
save "$base\2006.dta", replace
*========================================================================*
/* Income 2006 */
*========================================================================*
use "$data/income06.dta", clear
gen str id=folio+num_ren
rename ing_tri income
replace income=income/3
collapse (sum) income, by(id)
merge 1:1 id using "$base\2006.dta", nogen
save "$base\2006.dta", replace
*========================================================================*
/* Expenditure 2006 */
*========================================================================*
use "$data/expend06_1.dta", clear
append using "$data/expend06_2.dta"
append using "$data/expend06_3.dta"
append using "$data/expend06_4.dta"

rename folio hid
gen subway=gas_tri/3 if clave=="B001"
gen bus=gas_tri/3 if clave=="B002"
gen train=gas_tri/3 if clave=="B003"
gen combi=gas_tri/3 if clave=="B004"
gen taxi=gas_tri/3 if clave=="B005"
collapse (sum) subway bus train combi taxi, by(hid)

keep hid subway bus train combi taxi
merge 1:m hid using "$base\2006.dta", nogen

order id hid state mun_id weight relation female age student stud_level ///
stud_grade private edu work verific labor paidw self_emp naics occupa ///
hrs_work income

save "$base\2006.dta", replace
