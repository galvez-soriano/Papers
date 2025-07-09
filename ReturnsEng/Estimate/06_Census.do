*========================================================================*
* English programs and migration
*========================================================================*
/* Oscar Galvez-Soriano */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base0= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Data"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\ReturnsEng\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\ReturnsEng\Doc"
*========================================================================*
import delimited "$data/data/main/MexCensus/2020/Migrantes00.CSV", clear
keep ent mun factor id_viv id_mii mper factor msexo medad mfecemim mfecemia ///
mpaires mfecretm mfecreta mperls tamloc mlugori_c mpaides_c mcausaemig_v

replace mperls=. if mperls==99
tostring id_viv, replace format(%012.0f) force
tostring id_mii, replace format(%014.0f) force
tostring mperls, replace format(%05.0f) force
tostring mper, replace format(%05.0f) force
gen str id=(id_viv+mper)
gen str id_hh=(id_viv+mperls)
gen migrant=1
rename ent state
rename msexo female
recode female (1=0) (3=1)
replace medad=. if medad==999
replace mfecemim=. if mfecemim==99
replace mfecemia=. if mfecemia==9999
replace mfecretm=. if mfecretm==99
replace mfecreta=. if mfecreta==9999
replace mlugori_c=. if mlugori_c==999
replace mpaides_c=. if mlugori_c==999
rename mlugori_c migrant_state
rename mpaides_c destination_c
rename mcausaemig_v mreason
replace mreason=. if mreason==9999
gen dest_us=destination_c==221
gen cohort=mfecemia-medad
gen yearmig=medad-12
gen rural=tamloc==1
gen time_migra=(mfecreta-mfecemia)*12
replace time_migra=time_migra+(mfecretm-mfecemim) if time_migra==0
replace time_migra=time_migra-mfecemim+mfecretm if time_migra>=12
keep state mun factor id_viv id id_hh id_mii female rural cohort migrant time_migra mperls migrant_state destination_c dest_us yearmig mreason
save "$base\migrant.dta", replace
*========================================================================*
keep if mperls=="."
keep state mun factor id_viv id id_mii cohort migrant female rural time_migra migrant_state destination_c dest_us yearmig mreason
save "$base\migrantAppend.dta", replace
*========================================================================*
use "$base\migrant.dta", clear
keep if mperls!="."
keep id_hh migrant time_migra migrant_state destination_c dest_us yearmig mreason
duplicates drop id_hh, force
rename id_hh id
save "$base\migrantMerge.dta", replace
*========================================================================*
use "$base0\personas00.dta", clear

keep ent mun id_viv id_persona factor sexo edad asisten mun_asi ent_pais_asi escoacum ///
ent_pais_res_5a mun_res_5a conact ocupacion_c aguinaldo vacaciones servicio_medico ///
incap_sueldo sar_afore credito_vivienda ingtrmen hortra actividades_c ///
mun_trab ent_pais_trab tamloc utilidades perte_indigena hlengua qdialect_inali ///
hespanol elengua ent_pais_nac

rename id_persona id
tostring id_viv, replace format(%012.0f) force
rename ent state
rename sexo female
recode female (1=0) (3=1)
rename edad age
rename asisten student
recode student (3=0) (9=.)
replace student=1 if conact==50
rename escoacum edu
replace edu=. if edu==99
rename ent_pais_res_5a state5
rename mun_res_5a mun5
gen work=conact<=30

gen indigenous=perte_indigena==1
drop perte_indigena

rename ingtrmen wage
replace wage=. if wage==999999
rename hortra hrs_w
replace hrs_w=. if hrs_w==999
rename mun_trab mun_w 
rename ent_pais_trab state_w
gen rural=tamloc==1
replace state5=. if state5>32
tostring state5, replace format(%02.0f) force
tostring mun5, replace format(%03.0f) force
gen str geo=(state5+mun5)
replace geo="." if mun5=="."

recode hlengua (3=0) (9=.)
recode hespanol (3=0) (9=.)
recode elengua (5=1) (7=0) (9=.)
rename ent_pais_nac countryborn

merge 1:1 id using "$base\migrantMerge.dta", nogen

save "$base\census20.dta", replace
*========================================================================*
use "$base\census20.dta", clear

gen cohort=.
replace cohort=2020-age
keep if cohort>=1979 & cohort<=1996
label var cohort "Cohorts"

replace migrant=0 if migrant==.
append using "$base\migrantAppend.dta"
keep if cohort!=.
keep if cohort>=1979 & cohort<=1996

gen wpaid=wage>0 & work==1 & wage!=.

gen lwage=log(wage) if wpaid==1
gen age2=age^2

tostring migrant_state, replace format(%02.0f) force
tostring state, replace format(%02.0f) force
tostring mun, replace format(%03.0f) force
replace geo=(state+mun) if geo=="." & migrant==1
replace geo=(state+mun) if geo=="" & migrant==1
replace state5=migrant_state if state5=="" & migrant==1
drop migrant_state 

save "$base\census20.dta", replace
*========================================================================* 
use "$base\census20.dta", clear

keep if cohort>=1984 & cohort<=1994
gen str geo_mun = state5 + mun5
replace geo_mun=state+mun if geo=="."

merge m:1 geo_mun cohort using "$data/Papers/main/ReturnsEng/Data/exposure_mun.dta"
drop if _merge==2
drop _merge

merge m:1 state cohort using "$data/Papers/main/ReturnsEng/Data/exposure_state.dta"
drop if _merge!=3

rename hrs_exp2 hrs_exp 
replace hrs_exp=hrs_exp3 if hrs_exp==.
drop _merge hrs_exp3

gen imputed_state=geo=="."
drop geo
gen str geo=(state+mun)
order geo

gen labor=conact<=30

gen dmigrant=geo!=geo_mun
drop geo_mun mun_asi ent_pais_asi aguinaldo

save "$base\labor_census20.dta", replace
*========================================================================* 
/* Exposure variable check */
*========================================================================* 
use "$base\labor_census20.dta", clear

collapse hrs_exp, by(geo cohort)
rename hrs_exp hrs_exp2
save "$base\exp_mun_cohort.dta", replace
merge 1:m geo cohort using "$base\labor_census20.dta", nogen

order geo cohort hrs_exp hrs_exp2
save "$base\labor_census20.dta", replace

*========================================================================* 
/* Treatment variable */
*========================================================================* 
use "$base\labor_census20.dta", clear
keep geo hrs_exp2 state cohort
collapse hrs_exp2, by(geo cohort)
sort geo cohort
gen state=substr(geo,1,2)

sum hrs_exp2 if state=="01" & cohort>=1990 & cohort<=1996, d
gen engl=hrs_exp2>=r(p50) & state=="01"
sum hrs_exp2 if state=="10" & cohort>=1991 & cohort<=1996, d
replace engl=1 if hrs_exp2>=r(p50) & state=="10"
sum hrs_exp2 if state=="19" & cohort>=1987 & cohort<=1996, d
replace engl=1 if hrs_exp2>=r(p50) & state=="19"
sum hrs_exp2 if state=="25" & cohort>=1993 & cohort<=1996, d
replace engl=1 if hrs_exp2>=r(p50) & state=="25"
sum hrs_exp2 if state=="26" & cohort>=1993 & cohort<=1996, d
replace engl=1 if hrs_exp2>=r(p50) & state=="26"
sum hrs_exp2 if state=="28" & cohort>=1990 & cohort<=1996, d
replace engl=1 if hrs_exp2>=r(p50) & state=="28"

bysort geo: replace engl=1 if engl[_n-1]==1 & engl[_n+1]==1 & engl==0
bysort geo: replace engl=1 if engl[_n-1]==1 & engl==0 & cohort==1994
bysort geo: replace engl=0 if engl[_n-1]==0 & engl[_n+1]==0 & engl==1
bysort geo: replace engl=0 if engl[_n+1]==0 & engl==1 & cohort==1984

gen ftreat=.
bysort geo: gen ncount=_n if engl!=0
bysort geo: replace ftreat=cohort if ncount[_n-1]==. & ncount[_n+1]>ncount & ncount!=. // this identifies the first treated cohort but exclude never treated
bysort geo: egen first_treat = total(ftreat) // assigning the value of the first treated cohort to all observations within a municipality

replace engl=0 if first_treat>1994
sum hrs_exp2 if engl==1, d
replace engl=1 if hrs_exp2>=r(p75) & first_treat>1994
drop ftreat ncount first_treat

sort geo cohort

gen ftreat=.
bysort geo: gen ncount=_n if engl!=0
bysort geo: replace ftreat=cohort if ncount[_n-1]==. & ncount[_n+1]>ncount & ncount!=.
bysort geo: egen first_treat = total(ftreat)

rename first_treat first_cohort
keep geo cohort first_cohort

replace first_cohort = 1995 if first_cohort==0
gen K = cohort-first_cohort
gen D = K>=0 & first_cohort!=.

save "$base\treatment_mun.dta", replace
*=======================================================================* 
use "$base\labor_census20.dta", clear

merge m:1 geo cohort using "$base\treatment_mun.dta", nogen

save "$base\labor_census20.dta", replace
*=========================================================================* 
/* Keeping only individuals likely to be treated */
*=========================================================================* 
use "$base\labor_census20.dta", clear
destring state5, replace

drop if state=="05" | state=="17"
drop lwage
gen lwage=log(wage+1)
replace wpaid=. if work==0
gen migra_ret=migrant==1 & conact!=.

drop if imputed_state==1

drop countryborn state5 mun5 conact mun_w state_w id_mii imputed_state
destring geo, replace

save "$base\labor_census20.dta", replace

*=========================================================================* 
/* Effects on Migration */
*=========================================================================* 
use "$base\labor_census20.dta", clear
destring state, replace 

did_imputation migrant geo cohort first_cohort ///
[aw=factor], horizons(0/6) pretrend(6) ///
controls(female) cluster(geo) fe(geo cohort state#cohort) autos minn(0)

estimates store bjs_m

event_plot bjs_m, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.02(0.01)0.02, labs(medium) grid format(%5.2f)) ///
	ytitle("Likelihood of migrating abroad", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_migrant.png", replace

did_imputation dest_us geo cohort first_cohort if migrant==1 ///
[aw=factor], horizons(0/6) pretrend(6) ///
controls(female) cluster(geo) fe(geo cohort state#cohort) autos minn(0)

estimates store bjs_us

event_plot bjs_us, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-.6(0.3).6, labs(medium) grid format(%5.1f)) ///
	ytitle("Likelihood of migrating to the US", size(medium) height(5)) ///
	xlabel(-6(1)6) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick)) 
graph export "$doc\PTA_BJS_USmigrant.png", replace