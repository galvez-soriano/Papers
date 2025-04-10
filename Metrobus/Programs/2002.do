*========================================================================*
* Working with ENIGH 2002
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/Metrobus/Data/2002"
gl base= "C:\Users\galve\Documents\Papers\Current\Metrobus\Data"
*========================================================================*
/* Sociodemographic 2002 */
*========================================================================*
use "$data/sdem02.dta", clear

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
gen student=asis_esc_f==1
label var student "Student"

gen nivel=.
replace nivel=1 if ed_formal==1 | ed_formal==2
replace nivel=2 if inlist(ed_formal, 3, 4, 5, 6, 7, 8)
replace nivel=3 if inlist(ed_formal, 9, 10, 11)
replace nivel=4 if ed_tecnica==6 | ed_tecnica==7
replace nivel=5 if inlist(ed_formal, 12, 13, 14, 15, 16, 17, 18)
replace nivel=6 if ed_tecnica==8 | ed_tecnica==9
replace nivel=7 if ed_formal==19 | ed_formal==20
replace nivel=8 if inlist(ed_formal, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31)
replace nivel=9 if ed_formal==32 | ed_formal==33
label var nivel "Student Level"

gen private=tipo_esc==2
label var private "Private School"

gen n_instr141=.
replace n_instr141=0 if ed_formal==1
replace n_instr141=1 if ed_formal==2
replace n_instr141=2 if inlist(ed_formal, 3, 4, 5, 6, 7, 8)
replace n_instr141=3 if inlist(ed_formal, 9, 10, 11)
replace n_instr141=4 if inlist(ed_formal, 12, 13, 14, 15, 16, 17, 18, 19)
replace n_instr141=5 if ed_formal==20
replace n_instr141=6 if inlist(ed_tecnica, 3, 5, 7, 9)
replace n_instr141=7 if inlist(ed_formal, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31)
replace n_instr141=8 if ed_formal==32
replace n_instr141=9 if ed_formal==33

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

save "$base\2002.dta", replace

*========================================================================*
/* Household 2002 */
*========================================================================*
use "$data/hh02.dta", clear

rename folio hid
label var hid "Household ID"
rename ubica_geo mun_id
label var mun_id "Municipality ID"
rename tot_resi hh_size
label var hh_size "Household Size"
rename vehi56_1 car
label var car "Car"
rename vehi56_2 suv
label var suv "SUV"
rename vehi56_3 truck
label var truck "Truck"
rename vehi56_4 motorcycle
label var motorcycle "Motorcycle"
rename vehi56_5 bicycle
label var bicycle "Bicycle"
rename factor weight
label var weight "Weight"

order hid mun_id weight hh_size car suv truck motorcycle bicycle
keep hid mun_id weight hh_size car suv truck motorcycle bicycle

merge 1:m hid using "$base\2002.dta", nogen
save "$base\2002.dta", replace

*========================================================================*
/* Income 2002 */
*========================================================================*
use "$data/income02.dta", clear

gen folio_str=folio/10
tostring folio_str, replace
tostring num_ren, gen(num_ren_str)
gen str id=folio_str+num_ren_str
drop folio_str num_ren_str
label var id "ID"
rename ing_tri income
label var income "Income"
replace income=income/3
collapse (sum) income, by(id)

merge 1:1 id using "$base\2002.dta", nogen
save "$base\2002.dta", replace

*========================================================================*
/* Expenditure 2002 */
*========================================================================*
use "$data/expend02_1.dta", clear
append using "$data/expend02_2.dta"

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

keep hid subway bus train combi taxi
merge 1:m hid using "$base\2002.dta", nogen

order id hid state mun_id weight relation female age student stud_level ///
stud_grade private edu work verific labor paidw self_emp naics occupa ///
hrs_work income

save "$base\2002.dta", replace

*========================================================================*
/* Year 2002 */
*========================================================================*
gen year=2002
