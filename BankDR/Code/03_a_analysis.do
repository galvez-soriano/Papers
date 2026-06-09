*========================================================================*
/* Bank de-regulation */
*========================================================================*
/* Hoanh Le and Oscar Galvez-Soriano */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\Bank DR\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\Bank DR\Doc"

graph set window fontface "Times New Roman"
*========================================================================*
use "$base/Ag_RNA.dta", clear

rename State state

* Gen relative year to merger year
gen Event_Year = year - Eff_Year_RNA 
label var Event_Year "Relative time to Adoption"


foreach k in -6 -5 -4 -3 -2 0 1 2 3 4 5 6{
    local vname = cond(`k'<0, "D_b" + string(abs(`k')), "D_a" + string(`k'))
    gen byte `vname' = (Event_Year == `k') 
     replace `vname' = 0 if missing(`vname')
}

* Labels 
label var D_b6 "t-6"
label var D_b5 "t-5"
label var D_b4 "t-4"
label var D_b3 "t-3"
label var D_b2 "t-2"
label var D_a0  "t0"
label var D_a1  "t1"
label var D_a2  "t2"
label var D_a3  "t3"
label var D_a4  "t4"
label var D_a5  "t5"
label var D_a6  "t6"

* Outcome 1: AG SERVICES - EXPENSE, MEASURED IN $
gen lvalue37 = log(value37)
reghdfe lvalue37 D_*, absorb(state year) vce(cluster state)
eststo lvalue37
test D_b5 D_b4 D_b3 D_b2

coefplot lvalue37, ///
    keep(D_b5 D_b4 D_b3 D_b2 D_a0 D_a1 D_a2 D_a3 D_a4 D_a5 D_a6) ///
    relocate(D_b5=1 D_b4=2 D_b3=3 D_b2=4 D_a0=6 D_a1=7 D_a2=8 D_a3=9 D_a4=10 D_a5=11 D_a6=12) ///
    vertical ///
    xlabel(1 "-5" 2 "-4" 3 "-3" 4 "-2" 5 "-1" 6 "0" 7 "1" 8 "2" 9 "3" 10 "4" 11 "5" 12 "6") ///
    yline(0, lcolor(gs8)) ///         
    xline(5.5, lpattern(dash) lcolor(gs6)) ///
    msymbol(O) mcolor(black) ///
    ciopts(lcolor(black%60)) ///
    lcolor(navy) ///
    scheme(s2color) ///
    addplot(scatteri 0 5, msymbol(O) mcolor(black)) ///
	graphregion(color(white)) ///
    bgcolor(white) ///
	ytitle("Estimated Coefficients", size(medium)) /// 
	xtitle("Year Relative Adoption", size(medium)) 

	