*======================================================================*
/* Budget */
*======================================================================*
clear
gl doc= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Doc\Presentation"
cd "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Budget"
*======================================================================*
use budget2009, clear

rename ImportePresupuestodeEgresosdelaF budget
format %14.0g budget
rename unidadresponsable inst_gov
rename grupofuncional group
rename Función purpose
rename Subfunción sub_purp
rename actividadinstitucional activity
rename identificadordeprogramapresupues id_budget
rename programapresupuestario id_program

egen nepbe=sum(budget) if ramo=="11" & inst_gov=="312" & group==2 & ///
purpose==0 & sub_purp==1 & activity==16 & id_budget=="G" & id_program==3

egen edu=sum(budget) if ramo=="11"

egen t_bud=sum(budget)

gen eng_e=(nepbe/edu)*100
gen eng_b=(nepbe/t_bud)*100
sum eng_e eng_b
keep if eng_e!=.
keep ciclo budget nepbe edu t_bud eng_e eng_b
save b09, replace
*======================================================================*
use budget2010, clear

rename ImportePresupuestodeEgresosdelaF budget
format %14.0g budget
rename unidadresponsable inst_gov
rename finalidad group
rename Función purpose
rename Subfunción sub_purp
rename actividadinstitucional activity
rename identificadordelprogramapresupue id_budget
rename programapresupuestario id_program

egen nepbe=sum(budget) if ramo=="11" & inst_gov=="312" & group==2 & ///
purpose==0 & sub_purp==1 & activity==16 & id_budget=="G" & id_program==3

egen edu=sum(budget) if ramo=="11"

egen t_bud=sum(budget)

gen eng_e=(nepbe/edu)*100
gen eng_b=(nepbe/t_bud)*100
sum eng_e eng_b
keep if eng_e!=.
keep ciclo budget nepbe edu t_bud eng_e eng_b
save b10, replace
*======================================================================*
use budget2011, clear

rename ImportePresupuestodeEgresosdelaF budget
format %14.0g budget
rename unidadresponsable inst_gov
rename finalidad group
rename Función purpose
rename Subfunción sub_purp
rename actividadinstitucional activity
rename identificadordelprogramapresupue id_budget
rename programapresupuestario id_program

egen nepbe=sum(budget) if ramo=="11" & inst_gov=="312" & group==2 & ///
purpose==0 & sub_purp==1 & activity==16 & id_budget=="G" & id_program==3

egen edu=sum(budget) if ramo=="11"

egen t_bud=sum(budget)

gen eng_e=(nepbe/edu)*100
gen eng_b=(nepbe/t_bud)*100
sum eng_e eng_b
keep if eng_e!=.
keep ciclo budget nepbe edu t_bud eng_e eng_b
save b11, replace
*======================================================================*
use budget2012, clear

rename ImportePresupuestodeEgresosdelaF budget
format %14.0g budget
rename unidadresponsable inst_gov
rename finalidad group
rename Función purpose
rename Subfunción sub_purp
rename actividadinstitucional activity
rename identificadordelprogramapresupue id_budget
rename programapresupuestario id_program

egen nepbe=sum(budget) if ramo=="11" & inst_gov=="312" & group==2 & ///
sub_purp==1 & activity==16 & id_program==73

egen edu=sum(budget) if ramo=="11"

egen t_bud=sum(budget)

gen eng_e=(nepbe/edu)*100
gen eng_b=(nepbe/t_bud)*100
sum eng_e eng_b
keep if eng_e!=.
keep ciclo budget nepbe edu t_bud eng_e eng_b
save b12, replace
*======================================================================*
use budget2013, clear

rename ImportePresupuestodeEgresosdelaF budget
format %14.0g budget
rename unidadresponsable inst_gov
rename finalidad group
rename Función purpose
rename Subfunción sub_purp
rename actividadinstitucional activity
rename identificadordelprogramapresupue id_budget
rename programapresupuestario id_program

egen nepbe=sum(budget) if ramo=="11" & inst_gov=="312" & group==2 & ///
sub_purp==1 & activity==16 & id_program==73

egen edu=sum(budget) if ramo=="11"

egen t_bud=sum(budget)

gen eng_e=(nepbe/edu)*100
gen eng_b=(nepbe/t_bud)*100
sum eng_e eng_b
keep if eng_e!=.
keep ciclo budget nepbe edu t_bud eng_e eng_b
save b13, replace
*======================================================================*
use budget2017, clear

rename pef_bruto_2017 budget
format %14.0g budget
rename id_ur inst_gov
rename gpo_funcional group
rename id_funcion purpose
rename id_subfuncion sub_purp
rename id_ai activity
rename id_modalidad id_budget
rename id_pp id_program

egen nepbe=sum(budget) if id_ramo==11 & inst_gov=="312" & group==2 & ///
sub_purp==1 & activity==3 & id_program==270

egen edu=sum(budget) if id_ramo==11

egen t_bud=sum(budget)

gen eng_e=(nepbe/edu)*100
gen eng_b=(nepbe/t_bud)*100
sum eng_e eng_b
keep if eng_e!=.
keep ciclo budget nepbe edu t_bud eng_e eng_b
save b17, replace
*======================================================================*
clear
use b09
append using b10 b11 b12 b13 b17
rename ciclo year
collapse (sum) budget nepbe edu (mean) t_bud eng_e eng_b, by(year)

foreach x in 7 8 9{
set obs `x'
replace year = 2007+`x' in `x'
}
replace eng_e=0 if eng_e==.
replace eng_b=0 if eng_b==.
sort year
save budget_all, replace
*======================================================================*
use budget_all, clear

graph bar eng_e, over(year) ytitle(Budget of NEPBE as proportion of education ///
budget) graphregion(fcolor(white)) legend(off) scheme(s2mono) ///
note("Note: From 2014 to 2016 Mexican government cancelled the NEPBE.", span)
graph export "$doc\g_budget.png", replace


/*bro if id_ramo==11 & inst_gov=="312" & group==2 & ///
sub_purp==1 & activity==3 
*/
