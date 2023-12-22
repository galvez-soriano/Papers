*========================================================================*
* Working with ENIGH 2004
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/Metrobus/Data/2004"
gl base= "C:\Users\galve\Documents\Papers\Current\Metrobus\Data"
*========================================================================*
/* Sociodemographic 2004 */
*========================================================================*
use "$data/sdem04.dta", clear

gen folio_str=folio/10
tostring folio_str, replace
tostring num_ren, gen(num_ren_str)
gen str id=folio_str+num_ren_str
drop folio_str num_ren_str
label var id "ID"
rename folio hid
label var hid "Household ID"
rename parentesco relation
label var relation "Relation"
gen female=(sexo==2)
label var female "Female"
rename edad age
label var age "Age"
rename residencia state
label var state "State"
gen student=asis_esc==1
label var student "Student"
rename nivel stud_level
label var stud_level "Student Level"
rename grado stud_grade
label var stud_grade "Student Grade"
gen private=tipo_esc==2
label var private "Private School"
destring n_instr161 n_instr162, replace
tostring antec_esc, replace
gen edu=.
replace edu=0 if n_instr161==0 | n_instr161==1
replace edu=n_instr162 if n_instr161==2
replace edu=6+n_instr162 if n_instr161==3
replace edu=9+n_instr162 if n_instr161==4 & antec_esc==" "
replace edu=9+n_instr162 if n_instr161==4 & antec_esc=="2"
replace edu=9+n_instr162 if n_instr161==5 & antec_esc=="2"
replace edu=n_instr162 if n_instr161==6 & antec_esc=="1"
replace edu=9+n_instr162 if n_instr161==6 & antec_esc=="2"
replace edu=12+n_instr162 if n_instr161==5 & antec_esc=="3"
replace edu=12+n_instr162 if n_instr161==6 & antec_esc=="3"
replace edu=12+n_instr162 if n_instr161==7 & antec_esc=="3"
replace edu=16+n_instr162 if n_instr161==8 & antec_esc=="4"
replace edu=16+n_instr162 if n_instr161==9 & antec_esc=="4"
replace edu=18+n_instr162 if n_instr161==9 & antec_esc=="5"
label var edu "Years of Education"
gen work=trabajo==1
label var work "Work"
tostring sueldo23, replace
gen paidw=sueldo10=="1" | sueldo23=="1"
label var paidw "Paid Work"
tostring bus_trab, replace
tostring trabajo, replace
gen labor=trabajo=="1" | bus_trab=="10" | (bus_trab>"100" & bus_trab<"200" & bus_trab!=" ")
label var labor "Labor"
gen self_emp=posicion22>=4
label var self_emp "Self-Employed"
rename scian281 naics
label var naics "NAICS"
rename cmo251 occupa
label var occupa "Occupation"
rename horastrab hrs_work
label var hrs_work "Hours of Work"

order id hid state relation female age student stud_level stud_grade private ///
edu work verific labor paidw self_emp naics occupa hrs_work
keep id hid state relation female age student stud_level stud_grade private ///
edu work verific labor paidw self_emp naics occupa hrs_work

save "$base\2004.dta", replace

*========================================================================*
/* Household 2004 */
*========================================================================*
use "$data/hh04.dta", clear

rename folio hid
label var hid "Household ID"
rename ubica_geo mun_id
label var mun_id "Municipality ID"
rename residentes hh_size
label var hh_size "Household Size"
rename vehi06_1 car
label var car "Car"
rename vehi06_2 suv
label var suv "SUV"
rename vehi06_3 truck
label var truck "Truck"
rename vehi06_4 motorcycle
label var motorcycle "Motorcycle"
rename vehi06_5 bicycle
label var bicycle "Bicycle"
rename factor weight
label var weight "Weight"

order hid mun_id weight hh_size car suv truck motorcycle bicycle
keep hid mun_id weight hh_size car suv truck motorcycle bicycle

merge 1:m hid using "$base\2004.dta", nogen
save "$base\2004.dta", replace

*========================================================================*
/* Income 2004 */
*========================================================================*
use "$data/income04.dta", clear

gen folio_str=folio/10
tostring folio_str, replace
tostring num_ren, gen(num_ren_str)
gen str id=folio_str+num_ren_str
drop folio_str num_ren_str
label var id "ID"
rename ing_tri income
label var income "Income"
replace income=income/3
replace id=trim(id)
collapse (sum) income, by(id)

merge 1:1 id using "$base\2004.dta", nogen
save "$base\2004.dta", replace

*========================================================================*
/* Expenditure 2004 */
*========================================================================*
use "$data/expend04_1.dta", clear
append using "$data/expend04_2.dta"
append using "$data/expend04_3.dta"

rename folio hid
label var hid "Household ID"
gen subway=gas_tri/3 if clave=="B001"
label var subway "Expenditure in Subway"
gen bus=gas_tri/3 if clave=="B002"
label var bus "Expenditure in Bus"
gen train=gas_tri/3 if clave=="B003"
label var train "Expenditure in Train"
gen combi=gas_tri/3 if clave=="B004"
label var combi "Expenditue in Combi"
gen taxi=gas_tri/3 if clave=="B005"
label var taxi "Expenditure in Taxi"
gen gasoline=gas_tri/3 if clave=="F010"
label var gasoline "Expenditure in Gasoline"
collapse (sum) subway bus train combi taxi gasoline, by(hid)

keep hid subway bus train combi taxi gasoline
merge 1:m hid using "$base\2004.dta", nogen

gen year=2004

order id hid state year mun_id weight relation female age student stud_level ///
stud_grade private edu work verific labor paidw self_emp naics occupa ///
hrs_work income

save "$base\2004.dta", replace
