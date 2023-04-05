*=====================================================================*
* Final data set
* Append of all years
*=====================================================================*
gl data="C:\Users\galve\Documents\Papers\Current\Social pension program\Data"
*=====================================================================*
use "$data\2008\Bases\65 y mas_2008.dta", clear
append using "$data\2010\Bases\65 y mas_2010.dta", force
append using "$data\2012\Bases\65 y mas_2012.dta", force
append using "$data\2014\Bases\65 y mas_2014.dta", force

order proyecto folioviv foliohog numren year factor tam_loc rururb ent ///
ubica_geo tenencia edad sexo tamhogesc parentesco ic_rezedu anac_e inas_esc niv_ed ///
a_educ alfabe asis_esc nivel grado nivelaprob gradoaprob ic_asalud serv_sal ///
ic_segsoc segsoc ss_aa ss_mm cont_ss ss_dir pea par htrab jef_ss cony_ss hijo_ss ///
s_salud pam ing_pens ing_pam ing_65mas ing_pam_otros ic_cv icv_pisos icv_muros ///
icv_techos icv_hac clase_hog ic_sbv isb_agua isb_dren isb_luz isb_combus ///
ic_ali id_men tot_iaad tot_iamen ins_ali plb_m plb ictpc est_dis upm ///
i_privacion pobreza pobreza_e pobreza_m  vul_car vul_ing no_pobv carencias ///
carencias3 cuadrantes prof_b1 prof_bm1 prof_b2 prof_bm2 profun int_pob ///
int_pobe int_vulcar int_caren ict ing_mon ing_lab ing_ren ing_tra nomon ///
pago_esp reg_esp hli discap

rename tenencia howner
label var howner "House owner"
replace howner=. if howner==-1
replace howner=0 if howner<=2 | howner>=5 & howner!=.
replace howner=1 if howner==3 | howner==4 & howner!=.
rename htrab hwork
replace hwork=0 if hwork==.
label var hwork "Hours worked"
rename rururb rural
label var rural "Rural"
rename sexo gender
rename edad age
rename ent state
recode gender (1=0) (2=1)
label define gender 1 "Female" 0 "Male"
label values gender gender
label var gender "Female"
label var pam "PAM"
replace pam=0 if pam==.
label var ictpc "Income"
replace ictpc=1 if ictpc==0
gen l_inc=log(ictpc)
label var l_inc "log(Income)"
gen labor=.
replace labor=1 if pea>=1
replace labor=0 if pea==0
label var labor "Labor"
label var hli "Indigenous"
rename remesas remitt
label var remitt "Remittances"
*replace remitt=1 if remitt==0
*gen lremitt=log(remitt)
gen remittd=0
replace remittd=1 if remitt!=0
label var remittd "Remittances"
rename discap disabil
label var disabil "Disability"
destring edocony, replace
label define edocony 1 "union libre" 2 "separado" 3 "divorciado" 4 "viudo" ///
5 "soltero" 6 "casado", replace
label values edocony edocony

recode edocony (2=7) if year==2012
recode edocony (3=2) if year==2012
recode edocony (4=3) if year==2012
recode edocony (5=4) if year==2012
recode edocony (6=5) if year==2012
recode edocony (7=6) if year==2012

gen married=.
replace married=1 if edocony==1 | edocony==6
replace married=0 if edocony!=1 & edocony!=6

destring segsoc, replace
recode segsoc (2=0)

cap gen ubica_geo_mun = substr(ubica_geo,1,5)
cap gen id_ind = hog+numren

rename pobreza poor
label var poor "Poverty"
rename pobreza_e epoor
label var epoor "X_poverty"
rename a_educ educ
label var educ "Education"
label var ss_dir "Health system"

merge m:m year folioviv foliohog numren using "$data\scian.dta"
drop _merge

gen naics=substr(scian,1,1)
destring naics, replace
replace naics=. if naics==0

replace naics=0 if naics==. & pea==0
replace naics=10 if naics==. & pea==2

save "$data\dbase65.dta", replace
*=====================================================================*
use "$data\dbase65.dta", clear
*drop tcheck more70 more65 bw60_65 bw65_70 n_pam
gen tcheck=1 if age>=70
replace tcheck=0 if tcheck==.
gen bw65_70=1 if age>=66 & age<70
replace bw65_70=0 if bw65_70==.
gen more70=tcheck
gen more65=1 if age>=66
replace more65=0 if more65==.
gen bw60_65=1 if age>=61 & age<65
replace bw60_65=0 if bw60_65==.
bysort folioviv foliohog: gen hh_members=_N
gen n_pam=pam

collapse (mean) tcheck hh_members (sum) more70 more65 bw60_65 bw65_70 n_pam, by(folioviv foliohog)
replace tcheck=1 if tcheck!=0
save "$data\tcheck.dta", replace

merge m:m folioviv foliohog using "$data\dbase65.dta"
drop _merge

merge m:m folioviv foliohog numren using "$data\health.dta"
drop _merge
label var poor_health "Poor Health"
label var weight_h "Weight measure"
label var diab_h "Diabetes measure"
label var ap_h "Arterial pressure"
recode weight_h (2=0)

merge m:m folioviv foliohog numren using "$data\labor_act.dta"
drop _merge

merge m:m folioviv foliohog using "$data\fem_hh.dta"
drop _merge
save "$data\dbase65.dta", replace
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
bysort folioviv foliohog: replace treat=. if tcheck==1 
label var treat "Treat"

keep folioviv foliohog treat
recode treat (1=10) (0=5)
bysort folioviv foliohog: gen mem1=_N
egen mem2=rowtotal(mem1 treat)
collapse (sum) mem*, by(folioviv foliohog)
drop if mem1==mem2
gen treat_hh=0
replace treat_hh=1 if mem2==mem1+10
label var treat_hh "Treated household"
drop mem*
save "$data\treat_hh.dta", replace

use "$data\dbase65.dta", clear
merge m:m folioviv foliohog using "$data\treat_hh.dta"
drop _merge
drop proyecto ic_rezedu inas_esc niv_ed alfabe nivel grado nivelaprob ///
gradoaprob ic_asalud ic_segsoc ss_aa ss_mm cont_ss jef_ss cony_ss hijo_ss ///
s_salud ic_cv icv_pisos icv_muros icv_techos icv_hac clase_hog ic_sbv ///
isb_agua isb_dren isb_luz isb_combus ic_ali id_men tot_iaad tot_iamen ///
ins_ali plb_m plb est_dis upm i_privacion pobreza_m vul_car vul_ing ///
no_pobv carencias carencias3 cuadrantes prof_b1 prof_bm1 prof_b2 prof_bm2 ///
profun int_pob int_pobe int_vulcar int_caren
label drop tam_loc
save "$data\dbase65.dta", replace
