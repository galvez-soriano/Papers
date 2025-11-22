*=================================================================================*
/* Paper: Unintended effects of universalizing social pensions
   Authors: Oscar Galvez-Soriano and Raymundo Ramirez */
*=================================================================================*
clear all
set more off

gl rd="C:\Users\Oscar Galvez Soriano\Documents\Papers\UniversalizationPAM\Data"
gl gr="C:\Users\Oscar Galvez Soriano\Documents\Papers\UniversalizationPAM\Doc"
*=================================================================================*
use "$rd\dbasePAM.dta", clear
*=================================================================================*
     				          /*Prep Data*/
*=================================================================================*

* GENERAMOS EL ICTPC SIN PAM
gen ictpc1 = ictpc - inc_pam
gen income = ln(ictpc1 + 1)


*LINEAS DE POBREZA RURAL Y URBANA

* 2016
local lpei_urb2016 = ln(1351.24)
local lpei_rur2016 = ln(1018.43)
local lpi_urb2016  = ln(2903.91)
local lpi_rur2016  = ln(2030.14)

* 2018
local lpei_urb2018 = ln(1544.07)
local lpei_rur2018 = ln(1164.75)
local lpi_urb2018  = ln(3325.40)
local lpi_rur2018  = ln(2316.57)

* 2020
local lpei_urb2020 = ln(1702.28)
local lpei_rur2020 = ln(1299.30)
local lpi_urb2020  = ln(3559.88)
local lpi_rur2020  = ln(2520.16)

* 2022
local lpei_urb2022 = ln(2086.21)
local lpei_rur2022 = ln(1600.18)
local lpi_urb2022  = ln(4158.35)
local lpi_rur2022  = ln(2970.76)

* 2024
local lpei_urb2024 = ln(2354.65)
local lpei_rur2024 = ln(1800.55)
local lpi_urb2024  = ln(4564.97)
local lpi_rur2024  = ln(3296.92)

*COLORES
local col_pam    "144 238 144"
local col_oran   "230 159 0"
local col_yellow "255 210 140"
local col_red    "200 0 0"
local col_lightred "255 150 150"

*MONTO MENSUAL DEL PAM
local m2016 = ln(580)
local m2018 = ln(580)
local m2020 = ln(1310)
local m2022 = ln(1925)
local m2024 = ln(3000)


*===============================================================*
				     	*\RURAL INCOME\*
*===============================================================*
* GENERAMOS EL LOGARITMO DEL INGRESO RURAL
gen rurincome = ln(ictpc+1) if rururb==1
* GENERAMOS EL INGRESO RURAL SIN PAM
gen rurictpc= ln(ictpc-inc_pam+1) if rururb==1

foreach yr in 2016 2018 2020 2022 2024 {

    preserve
    keep if year==`yr' & rururb==1 & !missing(rurincome, rurictpc, weight) & weight>0
    sort rurincome
    gen double w = weight
    replace w = 0 if missing(w)

    quietly summarize w, meanonly
    scalar TOTW = r(sum)

    bysort rurincome: egen double w_at_rurinc = total(w)
    bysort rurincome: gen byte first_ri = (_n==1)
    gen double wsum_ri = sum(cond(first_ri, w_at_rurinc, 0))
    drop first_ri
    gen double ecdf2 = wsum_ri / TOTW

    sort rurictpc
    bysort rurictpc: egen double w_at_rurictpc = total(w)
    bysort rurictpc: gen byte first_rp = (_n==1)
    gen double wsum_rp = sum(cond(first_rp, w_at_rurictpc, 0))
    drop first_rp
    gen double ecdf3 = wsum_rp / TOTW

    xtile q_rur = rurincome [aw=weight], nq(4)
	
    quietly summarize rurincome if q_rur==1, detail
    local p25 = r(max)
    quietly summarize rurincome if q_rur==2, detail
    local p50 = r(max)
    quietly summarize rurincome if q_rur==3, detail
    local p75 = r(max)
    quietly summarize rurincome, detail
    local p100 = r(max)

    local q1_mid = (0 + `p25') / 2
    local q2_mid = (`p25' + `p50') / 2
    local q3_mid = (`p50' + `p75') / 2
    local q4_mid = (`p75' + `p100') / 2

    local prog     = `m`yr'' 
    local lpi_rur  = `lpi_rur`yr'' 
    local lpei_rur = `lpei_rur`yr'' 

    replace rurincome = 0 in 1
    replace rurictpc  = 0 in 1
    replace ecdf2     = 0 in 1
    replace ecdf3     = 0 in 1

    quietly summarize rurincome rurictpc
    local xmin = floor(r(min))
    local xmax = ceil(r(max))
    if `xmax' == `xmin' local xmax = `xmax' + 1

twoway ///
    (line ecdf2 rurincome if !missing(rurincome), sort lcolor(black) lwidth(medthick)) ///
    || ///
    (line ecdf3 rurictpc  if !missing(rurictpc),  sort lcolor(gs8)   lwidth(medthick)), ///
    legend(label(1 "Income excluding PAM") ///
           label(2 "Income with PAM") pos(9) ring(0) cols(1) size(small)) ///
    xtitle("Natural log of household per capita income") ///
    ytitle("Cumulative Probability") ///
    xscale(range(0 `xmax')) ///
    xlabel(0(2)`xmax') ///
    yscale(range(0 1)) ///
    ylabel(0(0.2)1, format(%3.1f)) ///
    xline(`prog',     lcolor("`col_pam'")    lwidth(medthick)) ///
    xline(`lpei_rur', lcolor("255 150 150")  lwidth(medthick)) ///
    xline(`lpi_rur',  lcolor("`col_yellow'") lwidth(medthick)) ///
    text(-0.02 0         "[" ,          color("0 50 200") size(medium) place(c)) ///
    text(-0.02 `p25'     "][" ,         color("0 50 200") size(medium) place(c)) ///
    text(-0.02 `p50'     "][" ,         color("0 50 200") size(medium) place(c)) ///
    text(-0.02 `p75'     "][" ,         color("0 50 200") size(medium) place(c)) ///
    text(-0.02 `p100'    "]" ,          color("0 50 200") size(medium) place(c)) ///
    text(0.9  `=`prog' - 0.09'   `"PAM"',                    color("`col_pam'")    size(small) place(w)) ///
    text(1.01 `=`lpei_rur' - 0.1' `"Food-based rural PL"',   color("255 150 150")  size(small) place(w)) ///
    text(1.01 `=`lpi_rur' + 0.1'  `"Rural PL"',              color("`col_yellow'") size(small) place(e)) ///
    text(-0.045 `q1_mid' "Q1" , color("0 50 200") size(vsmall) place(c)) ///
    text(-0.045 `q2_mid' "Q2" , color("0 50 200") size(vsmall) place(c)) ///
    text(-0.045 `q3_mid' "Q3" , color("0 50 200") size(vsmall) place(c)) ///
    text(-0.045 `q4_mid' "Q4" , color("0 50 200") size(vsmall) place(c)) ///
    name(ruralcdf_`yr', replace)


    graph export "$gr/ruralcdf_`yr'.png", width(2000) replace
    graph drop _all
    restore
}





*===============================================================*
					*\URBAN INCOME\*
*===============================================================*

* GENERAMOS EL LOGARITMO DEL INGRESO URBANO
gen urbincome = income if rururb==0
* GENERAMOS EL INGRESO RURAL SIN PAM
gen urbictpc= l_inc if rururb==0

foreach yr in 2016 2018 2020 2022 2024 {

    preserve
    keep if year==`yr' & rururb==0 & !missing(urbincome, urbictpc, weight) & weight>0

    sort urbincome
    gen double w = weight
    replace w = 0 if missing(w)

    quietly summarize w, meanonly
    scalar TOTW = r(sum)

    bysort urbincome: egen double w_at_urbinc = total(w)
    bysort urbincome: gen byte first_ui = (_n==1)
    gen double wsum_ui = sum(cond(first_ui, w_at_urbinc, 0))
    drop first_ui
    gen double ecdf4 = wsum_ui / TOTW

    sort urbictpc
    bysort urbictpc: egen double w_at_urbictpc = total(w)
    bysort urbictpc: gen byte first_up = (_n==1)
    gen double wsum_up = sum(cond(first_up, w_at_urbictpc, 0))
    drop first_up
    gen double ecdf5 = wsum_up / TOTW

    xtile q_urb = urbincome [aw=weight], nq(4)

    quietly summarize urbincome if q_urb==1, detail
    local p25 = r(max)
    quietly summarize urbincome if q_urb==2, detail
    local p50 = r(max)
    quietly summarize urbincome if q_urb==3, detail
    local p75 = r(max)
    quietly summarize urbincome, detail
    local p100 = r(max)

    local q1_mid = (0 + `p25') / 2
    local q2_mid = (`p25' + `p50') / 2
    local q3_mid = (`p50' + `p75') / 2
    local q4_mid = (`p75' + `p100') / 2

    local prog     = `m`yr'' 
    local lpi_urb  = `lpi_urb`yr'' 
    local lpei_urb = `lpei_urb`yr'' 

    replace urbincome = 0 in 1
    replace urbictpc  = 0 in 1
    replace ecdf4     = 0 in 1
    replace ecdf5     = 0 in 1

    quietly summarize urbincome urbictpc
    local xmin = floor(r(min))
    local xmax = ceil(r(max))
    if `xmax' == `xmin' local xmax = `xmax' + 1

    twoway ///
        (line ecdf4 urbincome if !missing(urbincome), sort lcolor(black) lwidth(medthick)) ///
        || ///
        (line ecdf5 urbictpc  if !missing(urbictpc),  sort lcolor(gs8)   lwidth(medthick)), ///
        legend(label(1 "Income excluding PAM") ///
               label(2 "Income with PAM") pos(9) ring(0) cols(1) size(small)) ///
        xtitle("Natural log of household per capita income") ///
        ytitle("Cumulative Probability") ///
        xscale(range(0 `xmax')) ///
        xlabel(0(2)`xmax') ///
        yscale(range(0 1)) ///
        ylabel(0(0.2)1, format(%3.1f)) ///
        xline(`prog',     lcolor("`col_pam'")  lwidth(medthick)) ///
        xline(`lpei_urb', lcolor("`col_red'")  lwidth(medthick)) ///
        xline(`lpi_urb',  lcolor("`col_oran'") lwidth(medthick)) ///
        text(-0.02 0         "[" ,          color("0 50 200") size(medium) place(c)) ///
        text(-0.02 `p25'     "][" ,         color("0 50 200") size(medium) place(c)) ///
        text(-0.02 `p50'     "][" ,         color("0 50 200") size(medium) place(c)) ///
        text(-0.02 `p75'     "][" ,         color("0 50 200") size(medium) place(c)) ///
        text(-0.02 `p100'    "]" ,          color("0 50 200") size(medium) place(c)) ///
        text(0.9  `=`prog' - 0.07'   `"PAM"',                 color("`col_pam'")  size(small) place(w)) ///
        text(1.01 `=`lpei_urb' - 0.1' `"Food-based urban PL"', color("`col_red'")  size(small) place(w)) ///
        text(1.01 `=`lpi_urb' + 0.1'  `"Urban PL"',            color("`col_oran'") size(small) place(e)) ///
        text(-0.045 `q1_mid' "Q1" , color("0 50 200") size(vsmall) place(c)) ///
        text(-0.045 `q2_mid' "Q2" , color("0 50 200") size(vsmall) place(c)) ///
        text(-0.045 `q3_mid' "Q3" , color("0 50 200") size(vsmall) place(c)) ///
        text(-0.045 `q4_mid' "Q4" , color("0 50 200") size(vsmall) place(c)) ///
        name(urbcdf_`yr', replace)

    graph export "$gr/urbcdf_`yr'.png", width(2000) replace
    graph drop _all
    restore
}
