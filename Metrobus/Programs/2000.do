*========================================================================*
* Working with ENIGH 2000
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/Metrobus/Data/2000"
gl base= "C:\Users\galve\Documents\Papers\Current\Metrobus\Data"
*========================================================================*
/* Sociodemographic 2000 */
*========================================================================*
use "$data/sdem00.dta", clear

gen str id=folio+num_ren
label var id "ID"
rename folio hid
label var hid "Household ID"
rename parentesco relation
label var relation "Relation"
gen female==sexo=="2"
label var female "Female"
rename edad age
label var age "Age"
rename residencia state
label var state "State"
gen student=asis_esc=="1"
label var student "Student"
rename nivel stud_level
label var stud_level "Student Level"
rename grado stud_grade
label var stud_grade "Student Grade"
gen private=tipo_esc=="2"
label var private "Private School"
destring n_instr141 n_instr142, replace
gen edu=.
replace edu=0 if n_instr141==0 | n_instr141==1
replace edu=n_instr142 if n_instr==2
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
label var edu "Years of Education"
gen work=trabajo=="1"
label var work "Work"
gen paidw=sueldo08=="1" | sueldo19=="1"
label var paidw "Paid Work"
gen labor=trabajo=="1" | bus_trab=="10" | (bus_trab>"100" & bus_trab<"200" & bus_trab!=" ")
label var labor "Labor"
gen self_emp=posicion07>="4"
label var self_emp "Self-Employed"
rename scian101 naics
label var naics "NAICS"
rename cmo091 occupa
label var occupa "Occupation"
rename horas_trab hrs_work
label var hrs_work "Hours of Work"

order id hid state relation female age student stud_level stud_grade private ///
edu work verific labor paidw self_emp naics occupa hrs_work
keep id hid state relation female age student stud_level stud_grade private ///
edu work verific labor paidw self_emp naics occupa hrs_work

save "$base\2000.dta", replace

*========================================================================*
/* Household 2000 */
*========================================================================*
use "$data/hh00.dta", clear

rename folio hid
label var hid "Household ID"
rename ubica_geo mun_id
label var mun_id "Municipality ID"
rename residentes hh_size
label var hh_size "Household Size"
rename vehi04_1 car
label var car "Car"
rename vehi04_2 suv
label var suv "SUV"
rename vehi04_3 truck
label var truck "Truck"
rename vehi04_4 motorcycle
label var motorcycle "Motorcycle"
rename vehi04_5 bicycle
label var bicycle "Bicycle"
rename factor weight
label var weight "Weight"

order hid mun_id weight hh_size car suv truck motorcycle bicycle
keep hid mun_id weight hh_size car suv truck motorcycle bicycle

merge 1:m hid using "$base\2000.dta", nogen
save "$base\2000.dta", replace

*========================================================================*
/* Income 2000 */
*========================================================================*
use "$data/income00.dta", clear

gen str id=folio+num_ren
label var id "ID"
rename ing_tri income
label var income "Income"
replace income=income/3
collapse (sum) income, by(id)

merge 1:1 id using "$base\2000.dta", nogen
save "$base\2000.dta", replace

*========================================================================*
/* Expenditure 2000 */
*========================================================================*
use "$data/expend00_1.dta", clear
append using "$data/expend00_2.dta"

rename folio hid
label var hid "Household ID"
gen subway=gas_tri/3 if clave=="B001"
label var subway "Subway"
gen bus=gas_tri/3 if clave=="B002"
label var bus "Bus"
gen train=gas_tri/3 if clave=="B003"
label var train "Train"
gen combi=gas_tri/3 if clave=="B004"
label var combi "Combi"
gen taxi=gas_tri/3 if clave=="B005"
label var taxi "Taxi"
collapse (sum) subway bus train combi taxi, by(hid)

keep hid subway bus train combi taxi
merge 1:m hid using "$base\2000.dta", nogen

order id hid state mun_id weight relation female age student stud_level ///
stud_grade private edu work verific labor paidw self_emp naics occupa ///
hrs_work income

save "$base\2000.dta", replace

*========================================================================*
/* Year 2000 */
*========================================================================*
gen year=2000
