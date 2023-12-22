*========================================================================*
* Working with ENIGH 2008
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/Metrobus/Data/2008"
gl base= "C:\Users\galve\Documents\Papers\Current\Metrobus\Data"
*========================================================================*
/* Sociodemographic 2008 */
*========================================================================*
use "$data/sdem08.dta", clear

gen folio=folioviv+foliohog
gen str id=folio+numren
label var id "ID"
rename folio hid
label var hid "Household ID"
rename parentesco relation
label var relation "Relation"
gen female=(sexo==2)
label var female "Gender"
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
gen private=tipoesc==2
label var private "Private School"
destring n_instr161 n_instr162, replace
tostring antec_esc, replace force
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
gen labor=trabajo==1 | bustrab_1==10 | (bustrab_1>100 & bustrab_1<200 & bustrab_1!= .)
label var labor "Labor"

order id hid state relation female age student stud_level stud_grade private ///
edu work verific labor
keep id hid state relation female age student stud_level stud_grade private ///
edu work verific labor

save "$base\2008.dta", replace

*========================================================================*
/* Household 2008 */
*========================================================================*
use "$data/hh08.dta", clear

gen folio=folioviv+foliohog
rename folio hid
label var hid "Household ID"
rename ubica_geo mun_id
label var mun_id "Municipality ID"
rename residentes hh_size
label var hh_size "Household Size"
rename vehi2_1 car
label var car "Car"
rename vehi2_2 suv
label var suv "SUV"
rename vehi2_3 truck
label var truck "Truck"
rename vehi2_4 motorcycle
label var motorcycle "Motorcycle"
rename vehi2_5 bicycle
label var bicycle "Bicycle"
rename factor weight
label var weight "Weight"

order hid mun_id weight hh_size car suv truck motorcycle bicycle
keep hid mun_id weight hh_size car suv truck motorcycle bicycle

merge 1:m hid using "$base\2008.dta", nogen
save "$base\2008.dta", replace

*========================================================================*
/* Income 2008 */
*========================================================================*
use "$data/income08.dta", clear

gen folio=folioviv+foliohog
gen str id=folio+numren
label var id "ID"
rename ing_tri income
label var income "Income"
replace income=income/3
collapse (sum) income, by(id)

merge 1:1 id using "$base\2008.dta", nogen
save "$base\2008.dta", replace

*========================================================================*
/* Expenditure 2008 */
*========================================================================*
use "$data/expend08_1.dta", clear
append using "$data/expend08_2.dta"

gen folio=folioviv+foliohog
rename folio hid
label var hid "Household ID"
gen subway=gas_tri/3 if clave=="B001"
label var subway "Expenditure in Subway"
gen bus=gas_tri/3 if clave=="B002"
label var bus "Expenditure in Bus"
gen train=gas_tri/3 if clave=="B003"
label var train "Expenditure in Train"
gen combi=gas_tri/3 if clave=="B004"
label var combi "Expenditure in Combi"
gen taxi=gas_tri/3 if clave=="B005"
label var taxi "Expenditure in Taxi"
gen gasoline=gas_tri/3 if clave=="F010"
label var gasoline "Expenditure in Gasoline"
collapse (sum) subway bus train combi taxi gasoline, by(hid)

keep hid subway bus train combi taxi gasoline
merge 1:m hid using "$base\2008.dta", nogen

gen year=2008

order id hid state year mun_id weight relation female age student stud_level ///
stud_grade private edu work verific labor ///
 income

save "$base\2008.dta", replace
