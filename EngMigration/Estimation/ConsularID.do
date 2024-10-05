*========================================================================*
/* Migration Project */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\EngMigration\Doc"
*========================================================================*
/* Working with Consular ID */
*========================================================================*
use "$base\consulate_id.dta", clear

rename añodeexpedición year
rename mesdeemisión month
rename consulado consulate
rename añodenacimiento cohort
rename paísdeorigen country
rename estadodeorigen state
rename municipioorigen mun
rename paísderesidencia country_r
rename estadoderesidencia state_r
rename condadodedestinoresidencia county_r 
rename educación edu
rename ocupación occupation
rename estadocivil married
rename edadcuandosolicitamatrícula age
rename cuantosdocumentoshaobtenido ids_issued
rename idúnico id
gen female=sexo=="mujer"
drop v18 sexo

keep if country=="MEXICO"
keep if cohort>=1984 & cohort<=1994
order id year month female edu cohort age

replace edu="0" if edu=="SIN ESTUDIOS"
replace edu="0" if edu=="MENORES DE EDAD"
replace edu="1" if edu=="1o. PRIMARIA"
replace edu="2" if edu=="2o. PRIMARIA"
replace edu="3" if edu=="3o. PRIMARIA"
replace edu="4" if edu=="4o. PRIMARIA"
replace edu="5" if edu=="5o. PRIMARIA"
replace edu="6" if edu=="6o. PRIMARIA"
replace edu="6" if edu=="PRIMARIA CON CERTIFICADO"
replace edu="6" if edu=="DESCONOCIDO"

replace edu="7" if edu=="1o. SECUNDARIA"
replace edu="8" if edu=="2o. SECUNDARIA"
replace edu="9" if edu=="3o. SECUNDARIA"
replace edu="9" if edu=="SECUNDARIA CON CERTIFICADO"
replace edu="9" if edu=="CAPACITACION TECNICA"

replace edu="11" if edu=="PREPARATORIA SIN CERTIFICADO"
replace edu="12" if edu=="PREPARATORIA CON CERTIFICADO"

replace edu="13" if edu=="1o. ANO DE PROFESIONAL"
replace edu="14" if edu=="20. ANO DE PROFESIONAL"
replace edu="15" if edu=="3er. ANO DE PROFESIONAL"
replace edu="15" if edu=="PROFESIONAL PASANTE"
replace edu="16" if edu=="4o. ANO DE PROFESIONAL"
replace edu="16" if edu=="PROFESIONAL TITULADO"

replace edu="18" if edu=="POSGRADO [MAESTRIA]"

replace edu="24" if edu=="POSGRADO [DOCTORADO]"

destring edu age, replace

drop if state=="NE" | state=="NT"
replace state="01" if state=="AGUASCALIENTES"
replace state="02" if state=="BAJA CALIFORNIA"
replace state="03" if state=="BAJA CALIFORNIA SUR"
replace state="04" if state=="CAMPECHE"
replace state="05" if state=="COAHUILA DE ZARAGOZA"
replace state="06" if state=="COLIMA"
replace state="07" if state=="CHIAPAS"
replace state="08" if state=="CHIHUAHUA"
replace state="09" if state=="DISTRITO FEDERAL"
replace state="10" if state=="DURANGO"
replace state="11" if state=="GUANAJUATO"
replace state="12" if state=="GUERRERO"
replace state="13" if state=="HIDALGO"
replace state="14" if state=="JALISCO"
replace state="15" if state=="MEXICO"
replace state="16" if state=="MICHOACAN DE OCAMPO"
replace state="17" if state=="MORELOS"
replace state="18" if state=="NAYARIT"
replace state="19" if state=="NUEVO LEON"
replace state="20" if state=="OAXACA"
replace state="21" if state=="PUEBLA"
replace state="22" if state=="QUERETARO DE ARTEAGA"
replace state="23" if state=="QUINTANA ROO"
replace state="24" if state=="SAN LUIS POTOSI"
replace state="25" if state=="SINALOA"
replace state="26" if state=="SONORA"
replace state="27" if state=="TABASCO"
replace state="28" if state=="TAMAULIPAS"
replace state="29" if state=="TLAXCALA"
replace state="30" if state=="VERACRUZ DE IGNACIO DE LA LLAVE"
replace state="31" if state=="YUCATAN"
replace state="32" if state=="ZACATECAS"
destring state, replace

gen migrant=1
*========================================================================*

label var year "Year"
bysort year: egen migra_year=sum(migrant) 
replace migra_year=migra_year/1000

bysort year: egen migra_year_treat=sum(migrant) if (state==1 | state==10 ///
 | state==19 | state==25 | state==26 | state==28)
replace migra_year_treat=migra_year_treat/1000

gen migra_year_control=migra_year-migra_year_treat

set scheme s1color
twoway line migra_year year, msymbol(diamond) xlabel(2002(1)2020, angle(vertical)) ///
ytitle(Migrants registered at Mexican Consulate (thousands)) ///
ylabel(0(50)350, labs(medium) nogrid format(%5.0f)) ///
graphregion(fcolor(white)) bgcolor(white) ///
legend(pos(10) ring(0) col(1) region(lcolor(white)) size(medium)) ///
|| line migra_year_treat year || line migra_year_control year, ///
legend(label(1 "All migrants") label(2 "Treated states") label(3 "Comparison states"))
graph export "$doc\FlowMigrants.png", replace


/* We must work on the codes for the municipalities and the states 

Once we have done that, what is the dependent variable of interest? 

Occupation
Mobility
Diversification?

What are we going to do with the years? FEs?

*/