*========================================================================*
* Working with ENIGH 2010
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/Metrobus/Data/2010"
gl base= "C:\Users\galve\Documents\Papers\Current\Metrobus\Data"
*========================================================================*
/* Sociodemographic 2010 */
*========================================================================*
use "$data/sdem10_1.dta", clear
append using "$data/sdem10_2.dta"

gen folio=folioviv+foliohog
gen str id=folio+numren
label var id "ID"
rename folio hid
label var hid "Household ID"
rename parentesco relation
label var relation "Relation"
gen female=(sexo=="2")
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
gen private=tipoesc=="2"
label var private "Private School"
destring nivelaprob gradoaprob, replace
gen edu=.
replace edu=0 if nivelaprob==0 | nivelaprob==1
replace edu=gradoaprob if nivelaprob==2
replace edu=6+gradoaprob if nivelaprob==3
replace edu=9+gradoaprob if nivelaprob==4 & antec_esc==" "
replace edu=9+gradoaprob if nivelaprob==4 & antec_esc=="2"
replace edu=9+gradoaprob if nivelaprob==5 & antec_esc=="2"
replace edu=gradoaprob if nivelaprob==6 & antec_esc=="1"
replace edu=9+gradoaprob if nivelaprob==6 & antec_esc=="2"
replace edu=12+gradoaprob if nivelaprob==5 & antec_esc=="3"
replace edu=12+gradoaprob if nivelaprob==6 & antec_esc=="3"
replace edu=12+gradoaprob if nivelaprob==7 & antec_esc=="3"
replace edu=16+gradoaprob if nivelaprob==8 & antec_esc=="4"
replace edu=16+gradoaprob if nivelaprob==9 & antec_esc=="4"
replace edu=18+gradoaprob if nivelaprob==9 & antec_esc=="5"
label var edu "Years of Education"
gen work=trabajo=="1"
label var work "Work"
gen labor=trabajo=="1" | bustrab_1=="10" | (bustrab_1>"100" & bustrab_1<"200" & bustrab_1!=" ")
label var labor "Labor"
rename hor_1 hrs_work
label var hrs_work "Hours of Work"

order id hid state relation female age student stud_level stud_grade private ///
edu work verific labor hrs_work
keep id hid state relation female age student stud_level stud_grade private ///
edu work verific labor hrs_work

save "$base\2010.dta", replace

*========================================================================*
/* Household 2010 */
*========================================================================*
use "$data/hh10.dta", clear

gen folio=folioviv+foliohog
rename folio hid
tostring hid, replace
label var hid "Household ID"
rename ubica_geo mun_id
label var mun_id "Municipality ID"
rename residentes hh_size
label var hh_size "Household Size"
rename vehi1_n car
label var car "Car"
rename vehi2_n suv
label var suv "SUV"
rename vehi3_n truck
label var truck "Truck"
rename vehi4_n motorcycle
label var motorcycle "Motorcycle"
rename vehi5_n bicycle
label var bicycle "Bicycle"
rename factor weight
label var weight "Weight"

order hid mun_id weight hh_size car suv truck motorcycle bicycle
keep hid mun_id weight hh_size car suv truck motorcycle bicycle

merge 1:m hid using "$base\2004.dta", nogen
save "$base\2004.dta", replace

*========================================================================*
/* Income 2010 */
*========================================================================*
use "$data/income10_1.dta", clear
append using "$data/income10_2.dta"

gen folio=folioviv+foliohog
gen str id=folio+numren
label var id "ID"
rename ing_tri income
label var income "Income"
replace income=income/3
collapse (sum) income, by(id)

merge 1:1 id using "$base\2010.dta", nogen
save "$base\2010.dta", replace

*========================================================================*
/* Expenditure 2010 */
*========================================================================*
import delimited "https://raw.githubusercontent.com/galvez-soriano/Papers/main/Metrobus/Data/2010/expend10_1.dta", clear
append using "$data/expend10_2.dta"

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
merge 1:m hid using "$base\2010.dta", nogen

gen year=2010

order id hid state year relation female age student stud_level ///
stud_grade private edu work verific labor ///
hrs_work income

save "$base\2010.dta", replace
