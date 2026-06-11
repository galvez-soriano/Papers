*========================================================================*
/* Bank de-regulation */
*========================================================================*
/* Hoanh Le and Oscar Galvez-Soriano */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano"
gl base= "C:\Users\ogalvez\OneDrive - The University of Chicago\Documents\Papers\BankDRegulation\Data"
gl doc= "C:\Users\ogalvez\OneDrive - The University of Chicago\Documents\Papers\BankDRegulation\Doc"

graph set window fontface "Times New Roman"
*========================================================================*
use "$base/Ag_RNA.dta", clear

gen lcropsP = log(CropPrcIdx)
gen lcropsQ = log(CropQty)
gen lenergyP = log(EngyPrcIdx)
gen lenergyQ = log(EngyQty)
gen lhlaborP = log(HiredLabPrcIdx)
gen lhlaborQ = log(HiredLabQty)
gen llivestockP = log(LvstkProdPrcIdx)
gen llivestockQ = log(LvstkProdQty)
gen lOInputsP = log(OtheInterInPrcIdx)
gen lOInputsQ = log(OtheInterInQty)
gen lulaborP = log(SelfEmplUnpaFamiLabPrcIdx)
gen lulaborQ = log(SelfEmplUnpaFamiLabQty)
gen lagP = log(TotAgriOutPrcIdx)
gen lagQ = log(TotAgriOutQty)
gen lTFP = log(TotFacProd)
gen lInputsP = log(TotInPrcIdx)
gen lInputsQ = log(TotInQty)
gen lIInputsP = log(TotInterInPrcIdx)
gen lIInputsQ = log(TotInterInQty)
rename Year year
encode Region, generate(region)
rename State state
drop if StateName==""

gen first_year=Eff_Year_RNA // first affected year
sum first_year
gen last_year = first_year==r(max) // dummy for the latest- or never-treated year

gen K=year-first_year
tab K
/* Define the leads and lags as the min and max values -1, respectively */
forvalues l = 0/14 {
	gen L`l'event = K==`l'
}
forvalues l = 1/35 {
	gen F`l'event = K==-`l'
}
gen L15event=K>=15
replace F1event=0 // normalize K=-1 to zero

*============================================================*
/* TWFE estimation */ 
*============================================================*
/* Crops Prices */
reghdfe lcropsP F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_cropsP

event_plot ols_cropsP, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in crops prices", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_cropsP.png", replace

/* Crops Quantity */
reghdfe lcropsQ F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_cropsQ

event_plot ols_cropsQ, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in crops quantity", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_cropsQ.png", replace

/* Energy Prices */
reghdfe lenergyP F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_energyP

event_plot ols_energyP, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in energy prices", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_energyP.png", replace

/* Energy Quantity */
reghdfe lenergyQ F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_energyQ

event_plot ols_energyQ, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in energy quantity", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_energyQ.png", replace

/* Hired Labor Price */
reghdfe lhlaborP F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_hlaborp

event_plot ols_hlaborp, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Hired Labor Price", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_HLaborP.png", replace

/* Hired Labor Quantity */
reghdfe lhlaborQ F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_hlaborq

event_plot ols_hlaborq, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1.6(0.8)1.6, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Hired Labor Quantity", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_HLaborQ.png", replace

/* Livestock Price */
reghdfe llivestockP F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_livestockp

event_plot ols_livestockp, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.8(0.4)0.8, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Livestock Price", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_LivestockP.png", replace

/* Livestock Quantity */
reghdfe llivestockQ F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_livestockq

event_plot ols_livestockq, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1.6(0.8)1.6, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Livestock Quantity", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_LivestockQ.png", replace

/* Other Inputs Price */
reghdfe lOInputsP F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_oinputp

event_plot ols_oinputp, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Other Inputs Price", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_OInputsP.png", replace

/* Other Inputs Quantity */
reghdfe lOInputsQ F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_oinputq

event_plot ols_oinputq, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1.6(0.8)1.6, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Other Inputs Quantity", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_OInputsQ.png", replace

/* Unpaid Labor Price */
reghdfe lulaborP F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_ulaborp

event_plot ols_ulaborp, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Unpaid Labor Price", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_ULaborP.png", replace

/* Unpaid Labor Quantity */
reghdfe lulaborQ F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_ulaborq

event_plot ols_ulaborq, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1.6(0.8)1.6, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Unpaid Labor Quantity", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_ULaborQ.png", replace

/* Ag Price */
reghdfe lagP F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_agp

event_plot ols_agp, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Ag Price", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_AgP.png", replace

/* Ag Output */
reghdfe lagQ F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_agq

event_plot ols_agq, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Ag Output", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_AgQ.png", replace

/* TFP */
reghdfe lTFP F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_tfp

event_plot ols_tfp, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.6(0.3)0.6, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in TFP", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_TFP.png", replace

/* Inputs Price */
reghdfe lInputsP F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_inputp

event_plot ols_inputp, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Inputs Price", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_InputsP.png", replace

/* Inputs Quantity */
reghdfe lInputsQ F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_inputq

event_plot ols_inputq, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Inputs Quantity", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_InputsQ.png", replace

/* Intermediate Inputs Price */
reghdfe lIInputsP F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_iinputp

event_plot ols_iinputp, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.4(0.2)0.4, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Intermediate Inputs Price", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_IInputsP.png", replace

/* Intermediate Inputs Quantity */
reghdfe lIInputsQ F*event L*event, ///
absorb(state year) vce(cluster state)
estimates store ols_iinputq

event_plot ols_iinputq, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(F#event) ///
    stub_lag(L#event) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1.4(0.7)1.4, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Intermediate Inputs Quantity", size(medium) height(5)) ///
	xlabel(-35(1)15, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_TWFE_IInputsQ.png", replace

*========================================================================*
/* Borusyak, Jaravel, and Spiess (2024) */
*========================================================================*
/* Crops Prices */
did_imputation lcropsP state year first_year, ///
horizons(0/5) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_cropsP

event_plot bjs_cropsP, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in crops prices", size(medium) height(5)) ///
	xlabel(-13(1)5, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_cropsP_ID.png", replace

/* Crops Quantity */
did_imputation lcropsQ state year first_year, ///
horizons(0/5) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_cropsQ

event_plot bjs_cropsQ, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in crops quantity", size(medium) height(5)) ///
	xlabel(-13(1)5, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_cropsQ_ID.png", replace

/* Energy Prices */
did_imputation lenergyP state year first_year, ///
horizons(0/5) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_energyP

event_plot bjs_energyP, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in energy prices", size(medium) height(5)) ///
	xlabel(-13(1)5, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_energyP_ID.png", replace

/* Energy Quantity */
did_imputation lenergyQ state year first_year, ///
horizons(0/5) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_energyQ

event_plot bjs_energyQ, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in energy quantity", size(medium) height(5)) ///
	xlabel(-13(1)5, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_energyQ_ID.png", replace

/* Hired Labor Price */
did_imputation lhlaborP state year first_year, ///
horizons(0/9) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_hlaborp

event_plot bjs_hlaborp, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.8(0.4)0.8, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Hired Labor Price", size(medium) height(5)) ///
	xlabel(-13(1)9, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_HLaborP_ID.png", replace

/* Hired Labor Quantity */
did_imputation lhlaborQ state year first_year, ///
horizons(0/9) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_hlaborq

event_plot bjs_hlaborq, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.8(0.4)0.8, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Hired Labor Quantity", size(medium) height(5)) ///
	xlabel(-13(1)9, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_HLaborQ_ID.png", replace

/* Livestock Price */
did_imputation llivestockP state year first_year, ///
horizons(0/9) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_livestockp

event_plot bjs_livestockp, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Livestock Price", size(medium) height(5)) ///
	xlabel(-13(1)9, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_LivestockP_ID.png", replace

/* Livestock Quantity */
did_imputation llivestockQ state year first_year, ///
horizons(0/9) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_livestockq

event_plot bjs_livestockq, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.8(0.4)0.8, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Livestock Quantity", size(medium) height(5)) ///
	xlabel(-13(1)9, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_LivestockQ_ID.png", replace

/* Other Inputs Price */
did_imputation lOInputsP state year first_year, ///
horizons(0/9) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_oinputp

event_plot bjs_oinputp, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Other Inputs Price", size(medium) height(5)) ///
	xlabel(-13(1)9, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_OInputsP_ID.png", replace

/* Other Inputs Quantity */
did_imputation lOInputsQ state year first_year, ///
horizons(0/9) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_oinputq

event_plot bjs_oinputq, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Other Inputs Quantity", size(medium) height(5)) ///
	xlabel(-13(1)9, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_OInputsQ_ID.png", replace

/* Unpaid Labor Price */
did_imputation lulaborP state year first_year, ///
horizons(0/9) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_ulaborp

event_plot bjs_ulaborp, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.8(0.4)0.8, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Unpaid Labor Price", size(medium) height(5)) ///
	xlabel(-13(1)9, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_ULaborP_ID.png", replace

/* Unpaid Labor Quantity */
did_imputation lulaborQ state year first_year, ///
horizons(0/9) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_ulaborq

event_plot bjs_ulaborq, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.8(0.4)0.8, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Unpaid Labor Quantity", size(medium) height(5)) ///
	xlabel(-13(1)9, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_ULaborQ_ID.png", replace

/* Ag Price */
did_imputation lagP state year first_year, ///
horizons(0/9) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_agp

event_plot bjs_agp, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Ag Price", size(medium) height(5)) ///
	xlabel(-13(1)9, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_AgP_ID.png", replace

/* Ag Output */
did_imputation lagQ state year first_year, ///
horizons(0/9) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_agq

event_plot bjs_agq, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.8(0.4)0.8, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Ag Output", size(medium) height(5)) ///
	xlabel(-13(1)9, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_AgQ_ID.png", replace

/* TFP */
did_imputation lTFP state year first_year, ///
horizons(0/9) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_tfp

event_plot bjs_tfp, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in TFP", size(medium) height(5)) ///
	xlabel(-13(1)9, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_TFP_ID.png", replace

/* Inputs Price */
did_imputation lInputsP state year first_year, ///
horizons(0/9) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_inputp

event_plot bjs_inputp, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Inputs Price", size(medium) height(5)) ///
	xlabel(-13(1)9, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_InputsP_ID.png", replace

/* Inputs Quantity */
did_imputation lInputsQ state year first_year, ///
horizons(0/9) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_inputq

event_plot bjs_inputq, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.8(0.4)0.8, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Inputs Quantity", size(medium) height(5)) ///
	xlabel(-13(1)9, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_InputsQ_ID.png", replace

/* Intermediate Inputs Price */
did_imputation lIInputsP state year first_year, ///
horizons(0/9) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_iinputp

event_plot bjs_iinputp, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Intermediate Inputs Price", size(medium) height(5)) ///
	xlabel(-13(1)9, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_IInputsP_ID.png", replace

/* Intermediate Inputs Quantity */
did_imputation lIInputsQ state year first_year, ///
horizons(0/9) pretrend(13) ///
cluster(state) fe(state year region#year) autos minn(0)
estimates store bjs_iinputq

event_plot bjs_iinputq, ///
    plottype(scatter) ciplottype(rspike) alpha(0.05) ///
    stub_lead(pre#) ///
    stub_lag(tau#) ///
    together noautolegend ///
	graph_opt( ///
	ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
	ytitle("Percentage change in Intermediate Inputs Quantity", size(medium) height(5)) ///
	xlabel(-13(1)9, angle(90)) yline(0, lpattern(solid)) ///
	xline(-0.5, lstyle(grid) lpattern(dash) lcolor(red)) ///
	xtitle("Years since policy intervention", size(medium) height(5)) ///
	legend(off) ///
	) ///
    lag_opt1(msize(small) msymbol(O) mfcolor(navy) mlcolor(navy) mlwidth(thin)) lag_ci_opt1(color(navy) lwidth(medthick))
graph export "$doc\PTA_BJS_IInputsQ_ID.png", replace