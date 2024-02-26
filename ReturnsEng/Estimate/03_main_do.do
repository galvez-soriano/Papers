*========================================================================*
/* English skills and labor market outcomes in Mexico */
*========================================================================*
/* Author: Oscar Galvez-Soriano */
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/ReturnsEng/Data"
gl base= "C:\Users\Oscar Galvez Soriano\Documents\Papers\ReturnsEng\Data"
gl doc= "C:\Users\Oscar Galvez Soriano\Documents\Papers\ReturnsEng\Doc"
*========================================================================*
/* TABLE 3: Returns to English abilities in Mexico */
*========================================================================*
use "$data/eng_abil.dta", clear
drop if state=="05" | state=="17"
keep if cohort>=1981 & cohort<=1996
keep if biare==1
/* Panel A: Full sample */
eststo clear
eststo: reg lwage eng [aw=weight] if paidw==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if age>=18 ///
& age<=65 & paidw==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous i.edu [aw=weight] if ///
paidw==1, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if paidw==1, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu<12, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if paidw==1 & edu<12, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu>=12, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if paidw==1 & edu>=12, absorb(geo) vce(cluster geo)
esttab using "$doc\tab3_A.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
/* Panel B: Men */
eststo clear
eststo: reg lwage eng [aw=weight] if paidw==1 & female==0, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if ///
paidw==1 & female==0, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous i.edu [aw=weight] if ///
paidw==1 & female==0, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if paidw==1 & female==0, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if paidw==1 & female==0, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu<12 & female==0, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if paidw==1 & edu<12 & female==0, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu>=12 & female==0, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if paidw==1 & edu>=12 & female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab3_B.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
/* Panel C: Women */
eststo clear
eststo: reg lwage eng [aw=weight] if paidw==1 & female==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if ///
paidw==1 & female==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous i.edu [aw=weight] if ///
paidw==1 & female==1, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if paidw==1 & female==1, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if paidw==1 & female==1, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu<12 & female==1, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if paidw==1 & edu<12 & female==1, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if paidw==1 & edu>=12 & female==1, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if paidw==1 & edu>=12 & female==1, absorb(geo) vce(cluster geo)
esttab using "$doc\tab3_C.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
/* Difference in estimate by gender */
gen eng_female=eng*female
gen cohort_fem=cohort*female
gen edu_fem=edu*female
gen state_fem=state*female
gen geo_fem=geo*female

eststo clear
eststo: reg lwage eng_female eng female [aw=weight] if paidw==1, vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous [aw=weight] if ///
paidw==1, absorb(cohort cohort_fem) vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous [aw=weight] if ///
paidw==1, absorb(cohort cohort_fem edu edu_fem) vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous rural married ///
[aw=weight] if paidw==1, absorb(cohort cohort_fem edu edu_fem state state_fem) vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous rural married ///
[aw=weight] if paidw==1, absorb(cohort cohort_fem edu edu_fem geo geo_fem) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng_female eng female [aw=weight] if paidw==1 & edu<12, vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous rural married ///
[aw=weight] if paidw==1 & edu<12, absorb(cohort cohort_fem edu edu_fem geo geo_fem) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng_female eng female [aw=weight] if paidw==1 & edu>=12, vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous rural married ///
[aw=weight] if paidw==1 & edu>=12, absorb(cohort cohort_fem edu edu_fem geo geo_fem) vce(cluster geo)
esttab using "$doc\tab3_diff.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(eng_female) replace
/* Difference in estimate by education (female) */
dis (0.840+0.379)/sqrt((0.741^2)+(0.329))
*========================================================================*
/* TABLE 4. Effect of English programs (staggered DiD) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
keep if cohort>=1981 & cohort<=1996
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
gen lhwork=log(hrs_work)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1
*========================================================================*
/* Full sample (staggered DiD) */ 
*========================================================================*
eststo clear
eststo: areg hrs_exp had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg eng had_policy i.cohort i.edu cohort female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg lwage had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg paidw had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg lhwork had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
eststo: areg formal had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
boottest had_policy, seed(6) noci
esttab using "$doc\tab_StaggDD.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Sun and Abraham (2021) */
*========================================================================*
gen first_cohort=0
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

destring geo, replace

gen tgroup=first_cohort
replace tgroup=. if state!="01" & state!="10" & state!="19" & state!="25" ///
& state!="26" & state!="28"
gen cgroup=tgroup==.

eventstudyinteract hrs_exp had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)
eventstudyinteract eng had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)
eventstudyinteract lwage had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)
eventstudyinteract paidw had_policy [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)
eventstudyinteract lhwork had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)
eventstudyinteract formal had_policy if paidw==1 [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)

*========================================================================*
/* Callaway and SantAnna (2021) */
*========================================================================*
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23{
gen educ`x'=edu==`x'
}

csdid hrs_exp female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid eng female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid lwage edu female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all 
csdid paidw female indigenous married educ* [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid lhwork female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid formal female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all

/* Robustness Check: Narrow cohorts */

keep if cohort>=1985 & cohort<=1995

csdid hrs_exp female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid eng female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid lwage edu female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all 
csdid paidw female indigenous married educ* [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid lhwork female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all
csdid formal female indigenous married educ* if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat all

*========================================================================*
/* Mechanisms */
*========================================================================*
/* Figure XX: Effect of English instruction on occupational decisions */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
drop if state=="05" | state=="17"
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1
keep if cohort>=1981 & cohort<=1996

destring sinco, replace
rename sinco sinco2011
merge m:1 sinco2011 using "$data/sinco_onet.dta"
drop if _merge==2
drop _merge

destring geo, replace
gen first_cohort=0
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23{
gen educ`x'=edu==`x'
}

sum pact, d
return list

gen phy_act=pact>=r(p75)
replace phy_act=. if paidw!=1

sum communica, d
return list

gen c_abil=communica>=r(p75)
replace c_abil=. if paidw!=1

csdid phy_act female indigenous married educ*  if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot seed(6) vce(cluster geo) long2
estat event, window(-6 8) estore(phys)
coefplot phys, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in physically-intensive jobs", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD_PhysicalOccup.png", replace

csdid phy_act female indigenous married educ* if paidw==1 & edu<12 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot vce(cluster geo) long2
estat event, window(-6 8) estore(phys_low)

csdid phy_act female indigenous married educ* if paidw==1 & edu>=12 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot vce(cluster geo) long2
estat event, window(-6 8) estore(phys_high)

coefplot ///
(phys_low, label("Low-education") connect(l) lc(gs14) msymbol(O) mcolor(gs14) ciopt(lc(gs14) recast(rcap connected))) ///
(phys_high, label("High-education") connect(l) lc(dknavy) msymbol(O) mcolor(dknavy) ciopt(lc(dknavy) recast(rcap connected))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in physically-demanding jobs", size(medium) height(5)) ///
ylabel(-1.5(.5)1.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white)) size(medium)) ///
ysc(r(-1.5 1.5)) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD_PhysicalOccup_Educa.png", replace

*========================================================================*

csdid c_abil female indigenous married educ*  if paidw==1 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot seed(6) vce(cluster geo) long2
estat event, window(-6 8) estore(c_abil)
coefplot c_abil, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in jobs requiring communication", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) recast(connected) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD_Communica.png", replace

csdid c_abil female indigenous married educ* if paidw==1 & edu<12 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot vce(cluster geo) long2
estat event, window(-6 8) estore(c_abil_low)

csdid c_abil female indigenous married educ* if paidw==1 & edu>=12 [iw=weight], time(cohort) gvar(first_cohort) method(dripw) wboot vce(cluster geo) long2
estat event, window(-6 8) estore(c_abil_high)

coefplot ///
(c_abil_low, label("Low-education") connect(l) lc(gs14) msymbol(O) mcolor(gs14) ciopt(lc(gs14) recast(rcap connected))) ///
(c_abil_high, label("High-education") connect(l) lc(dknavy) msymbol(O) mcolor(dknavy) ciopt(lc(dknavy) recast(rcap connected))) ///
, vertical yline(0) drop(Pre_avg Post_avg) omitted baselevels ///
xline(6.5, lstyle(grid) lpattern(dash) lcolor(ltblue)) ///
ytitle("Likelihood of working in jobs requiring communication", size(medium) height(5)) ///
ylabel(-1.5(.5)1.5, labs(medium) grid format(%5.2f)) ///
xtitle("Cohorts since policy intervention", size(medium) height(5)) ///
xlabel(, angle(vertical) labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ///
legend( pos(8) ring(0) col(1) region(lcolor(white)) size(medium)) ///
ysc(r(-1.5 1.5)) ///
coeflabels(Tm8 = "-8" Tm7 = "-7" Tm6 = "-6" Tm5 = "-5" Tm4 = "-4" Tm3 = "-3" ///
Tm2 = "-2" Tp0 = "0" Tp1 = "1" Tp2 = "2" Tp3 = "3" Tp4 = "4" ///
Tp5 = "5" Tp6 = "6" Tp7 = "7" Tp8 = "8")
graph export "$doc\PTA_SDD_Communica_Educa.png", replace

*========================================================================*
/* School Enrollment */
*========================================================================*
use "$data/eng_abil.dta", clear
grstyle init
grstyle set plain, horizontal
keep if biare==1
drop if state=="05" | state=="17"
sum hrs_exp, d
return list
gen engl=hrs_exp>=r(p90)
keep if cohort>=1981 & cohort<=1996

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1996) & engl==1
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996) & engl==1
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996) & engl==1
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996) & engl==1
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996) & engl==1
keep if cohort>=1981 & cohort<=1996

merge m:1 age using "$data/cumm_enroll_15.dta", nogen

destring geo, replace
gen first_cohort=0
replace first_cohort=1990 if state=="01" & engl==1
replace first_cohort=1991 if state=="10" & engl==1
replace first_cohort=1987 if state=="19" & engl==1
replace first_cohort=1993 if state=="25" & engl==1
replace first_cohort=1993 if state=="26" & engl==1
replace first_cohort=1990 if state=="28" & engl==1

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23{
gen educ`x'=edu==`x'
}

eststo clear
csdid stud female indigenous married educ* if age<=23 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat simple, estore(age23)
csdid stud female indigenous married educ* if age<=24 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat simple, estore(age24)
csdid stud female indigenous married educ* if age<=25 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat simple, estore(age25)
csdid stud female indigenous married educ* if age<=26 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat simple, estore(age26)
csdid stud female indigenous married educ* if age<=27 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat simple, estore(age27)
csdid stud female indigenous married educ* if age<=28 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat simple, estore(age28)
csdid stud female indigenous married educ* if age<=29 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat simple, estore(age29)
csdid stud female indigenous married educ* if age<=30 [iw=weight], time(cohort) gvar(first_cohort) vce(cluster geo) wboot seed(6)
estat simple, estore(age30)

coefplot ///
age23 age24 age25 age26 age27 age28 age29 age30, ///
keep(ATT) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
xtitle("Likelihood of being enrolled in school", size(medium) height(5)) ///
xlabel(-.1(0.1).3, labs(medium) format(%5.2f)) scheme(s2mono) ///
legend( pos(5) ring(0) col(1) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(95) legend(off)
graph save "$doc\graphSDDenroll",replace
graph export "$doc\graphSDDenroll.png", replace

graph hbar (mean) enroll if age>=23 & age<=30, over(age) scheme(s2mono) ///
graphregion(color(white)) ytitle("School enrollment", size(medium) height(5)) ///
ylabel(0(0.1).3, labs(medium) format(%5.2f) nogrid)
graph save "$doc\graph_enroll",replace
graph export "$doc\graph_enroll.png", replace

graph combine "$doc\graphSDDenroll" "$doc\graph_enroll", ///
graphregion(color(white) margin()) cols(2) imargin(1 1.2 1.2 1) scale(0.9)
graph export "$doc\fig_edu_enroll.png", replace