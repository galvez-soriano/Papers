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
keep if biare==1
/* Panel A: Full sample */
eststo clear
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if age>=18 ///
& age<=65 & paidw==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous i.edu [aw=weight] if ///
age>=18 & age<=65 & paidw==1, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1 & edu>9, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu>9, absorb(geo) vce(cluster geo)
esttab using "$doc\tab3_A.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
/* Panel B: Men */
eststo clear
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1 & female==0, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if age>=18 ///
& age<=65 & paidw==1 & female==0, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous i.edu [aw=weight] if ///
age>=18 & age<=65 & paidw==1 & female==0, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & female==0, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & female==0, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9 & female==0, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9 & female==0, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1 & edu>9 & female==0, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu>9 & female==0, absorb(geo) vce(cluster geo)
esttab using "$doc\tab3_B.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(Returns to English abilities) keep(eng) ///
stats(N r2, fmt(%9.0fc %9.3f)) replace
/* Panel C: Women */
eststo clear
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1 & female==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous [aw=weight] if age>=18 ///
& age<=65 & paidw==1 & female==1, vce(cluster geo)
eststo: reg lwage eng i.cohort female indigenous i.edu [aw=weight] if ///
age>=18 & age<=65 & paidw==1 & female==1, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & female==1, absorb(state) vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & female==1, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9 & female==1, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9 & female==1, absorb(geo) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng [aw=weight] if age>=18 & age<=65 & paidw==1 & edu>9 & female==1, vce(cluster geo)
eststo: areg lwage eng i.cohort female indigenous i.edu rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu>9 & female==1, absorb(geo) vce(cluster geo)
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
eststo: reg lwage eng_female eng female [aw=weight] if age>=18 & age<=65 & paidw==1, vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous [aw=weight] if age>=18 ///
& age<=65 & paidw==1, absorb(cohort cohort_fem) vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous [aw=weight] if ///
age>=18 & age<=65 & paidw==1, absorb(cohort cohort_fem edu edu_fem) vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1, absorb(cohort cohort_fem edu edu_fem state state_fem) vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1, absorb(cohort cohort_fem edu edu_fem geo geo_fem) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng_female eng female [aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9, vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu<=9, absorb(cohort cohort_fem edu edu_fem geo geo_fem) vce(cluster geo)
*========================================================================*
eststo: reg lwage eng_female eng female [aw=weight] if age>=18 & age<=65 & paidw==1 & edu>9, vce(cluster geo)
eststo: reghdfe lwage eng_female eng female indigenous rural married ///
[aw=weight] if age>=18 & age<=65 & paidw==1 & edu>9, absorb(cohort cohort_fem edu edu_fem geo geo_fem) vce(cluster geo)
esttab using "$doc\tab3_diff.tex", ar2 cells(b(star fmt(%9.3f)) p(par([ ]))) ///
star(* 0.10 ** 0.05 *** 0.01) title(Gender differences) keep(eng_female) replace
*========================================================================*
/* TABLE 4. Effect of English programs (staggered DiD) */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"

*gen engl=hrs_exp>=0.1
gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
keep if cohort>=1975 & cohort<=1996

/* Full sample (staggered DiD) */ 
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
esttab using "$doc\tab_StaggDD.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
*========================================================================*
/* Callaway and SantAnna (2021) */
destring geo, replace
destring id, replace
gen fist_cohort=0
/*
replace fist_cohort=1990 if state=="01"
replace fist_cohort=1988 if state=="05"
replace fist_cohort=1991 if state=="10"
replace fist_cohort=1987 if state=="19"
replace fist_cohort=1993 if state=="25"
replace fist_cohort=1993 if state=="26"
replace fist_cohort=1990 if state=="28"
*/
replace fist_cohort=1990 if state=="01" & engl==1
replace fist_cohort=1988 if state=="05" & engl==1
replace fist_cohort=1991 if state=="10" & engl==1
replace fist_cohort=1987 if state=="19" & engl==1
replace fist_cohort=1993 if state=="25" & engl==1
replace fist_cohort=1993 if state=="26" & engl==1
replace fist_cohort=1990 if state=="28" & engl==1

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23{
gen educ`x'=edu==`x'
}

csdid paidw female indigenous married educ* [iw=weight], time(cohort) gvar(fist_cohort) method(dripw) vce(cluster geo)
estat all
/*csdid student female indigenous married educ* [iw=weight], time(cohort) gvar(fist_cohort) method(dripw) vce(cluster geo)
estat all*/

keep if paidw==1
csdid hrs_exp female indigenous married educ* [iw=weight], time(cohort) gvar(fist_cohort) method(dripw) vce(cluster geo)
estat all
csdid eng female indigenous married educ* [iw=weight], time(cohort) gvar(fist_cohort) method(dripw) vce(cluster geo) 
estat all
csdid lwage edu female indigenous married educ* [iw=weight], time(cohort) gvar(fist_cohort) method(dripw) vce(cluster geo)
estat all

/* Sun and Abraham (2021) */
gen tgroup=fist_cohort
replace tgroup=. if state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"
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
/*eventstudyinteract student had_policy [aw=weight], absorb(geo cohort) ///
cohort(tgroup) control_cohort(cgroup) covariates(i.edu female indigenous married) ///
vce(cluster geo)*/

eststo clear
eststo: areg hrs_exp had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg eng had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg lwage had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
eststo: areg paidw had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)
/*eststo: areg student had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)*/
esttab using "$doc\tab_StaggDD.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(English abilities) keep(had_policy) ///
stats(N ar2, fmt(%9.0fc %9.3f)) replace
/*
/* Enrollment as a mechanism? */
use "$data/eng_abil.dta", clear
grstyle init
grstyle set plain, horizontal
keep if biare==1
keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
keep if cohort>=1975 & cohort<=1996

merge m:1 age using "$data/cumm_enroll_15.dta", nogen

quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=22, absorb(geo) vce(cluster geo)
estimates store age22
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=23, absorb(geo) vce(cluster geo)
estimates store age23
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=24, absorb(geo) vce(cluster geo)
estimates store age24
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=25, absorb(geo) vce(cluster geo)
estimates store age25
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=26, absorb(geo) vce(cluster geo)
estimates store age26
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=27, absorb(geo) vce(cluster geo)
estimates store age27
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=28, absorb(geo) vce(cluster geo)
estimates store age28
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=29, absorb(geo) vce(cluster geo)
estimates store age29
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight] if age<=30, absorb(geo) vce(cluster geo)
estimates store age30
quietly areg stud had_policy i.cohort i.edu female indigenous married ///
[aw=weight], absorb(geo) vce(cluster geo)
estimates store age_all

label var had_policy " "

coefplot ///
age22 age23 age24 age25 age26 age27 age28 age29 age30, ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
xtitle("Likelihood of being enrolled in school", size(medium) height(5)) ///
xlabel(-.1(0.1).3, labs(medium) format(%5.2f)) scheme(s2mono) ///
legend( pos(5) ring(0) col(1) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(95) legend(off)
graph save "$doc\graphSDDenroll",replace
graph export "$doc\graphSDDenroll.png", replace

graph hbar (mean) enroll if age>=22 & age<=30, over(age) scheme(s2mono) ///
graphregion(color(white)) ytitle("School enrollment", size(medium) height(5)) ///
ylabel(0(0.1).3, labs(medium) format(%5.2f) nogrid)
graph save "$doc\graph_enroll",replace
graph export "$doc\graph_enroll.png", replace

graph combine "$doc\graphSDDenroll" "$doc\graph_enroll", ///
graphregion(color(white) margin()) cols(2) imargin(1 1.2 1.2 1) scale(0.9)
graph export "$doc\fig_edu_enroll.png", replace
*/
*========================================================================*
/* FIGURE 4: Effect of English instruction on occupational decisions */
*========================================================================*
use "$data/eng_abil.dta", clear
keep if biare==1
keep if state=="01" | state=="05" | state=="10" ///
| state=="19" | state=="25" | state=="26" | state=="28" ///
| state=="02" | state=="03" | state=="08" | state=="18" ///
| state=="14" | state=="24" | state=="32" | state=="06" | state=="11"

gen had_policy=0 
replace had_policy=1 if state=="01" & (cohort>=1990 & cohort<=1995)
replace had_policy=1 if state=="05" & (cohort>=1988 & cohort<=1996)
replace had_policy=1 if state=="10" & (cohort>=1991 & cohort<=1996)
replace had_policy=1 if state=="19" & (cohort>=1987 & cohort<=1996)
replace had_policy=1 if state=="25" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="26" & (cohort>=1993 & cohort<=1996)
replace had_policy=1 if state=="28" & (cohort>=1990 & cohort<=1996)
keep if cohort>=1975 & cohort<=1996

destring sinco, replace
gen occup=.
replace occup=1 if (sinco>6101 & sinco<=6131) | (sinco>6201 & sinco<=6231) ///
| sinco==6999
replace occup=2 if (sinco>=9111 & sinco<=9899) 
replace occup=3 if sinco==6311 | (sinco>=8111 & sinco<=8199) | (sinco>=8211 ///
& sinco<=8212) | (sinco>=8311 & sinco<=8999)
replace occup=4 if (sinco>=7111 & sinco<=7135) | (sinco>=7211 & sinco<=7223) ///
| (sinco>=7311 & sinco<=7353) | (sinco>=7411 & sinco<=7412) | (sinco>=7511 & ///
sinco<=7517) | (sinco>=7611 & sinco<=7999)
replace occup=5 if (sinco>=5111 & sinco<=5116) | (sinco>=5211 & sinco<=5254) ///
| (sinco>=5311 & sinco<=5314) | (sinco>=5411 & sinco<=5999)
replace occup=6 if sinco==4111 | (sinco>=4211 & sinco<=4999)
replace occup=7 if (sinco>=3111 & sinco<=3142) | (sinco>=3211 & sinco<=3999)
replace occup=8 if (sinco>=2111 & sinco<=2625) | (sinco>=2631 & sinco<=2639) ///
| (sinco>=2641 & sinco<=2992)
replace occup=9 if (sinco>=1111 & sinco<=1999) | sinco==2630 ///
| sinco==2630 | sinco==2640 | sinco==3101 | sinco==3201 | sinco==4201 ///
| sinco==5101 | sinco==5201 | sinco==5301 | sinco==5401 | sinco==6101 ///
| sinco==6201 | sinco==7101 | sinco==7201 | sinco==7301 | sinco==7401 ///
| sinco==7501 | sinco==7601 | sinco==8101 | sinco==8201 | sinco==8301
replace occup=10 if sinco==980

label define occup 1 "Farming" 2 "Elementary occupations" 3 "Machine operators" ///
4 "Crafts" 5 "Customer service" 6 "Sales" 7 "Clerical support" ///
8 "Professionals/Technicians" 9 "Managerial" 10 "Abroad" 
label values occup occup

gen farm=occup==1
gen elem=occup==2
gen mach=occup==3
gen craf=occup==4
gen cust=occup==5
gen sale=occup==6
gen cler=occup==7
gen prof=occup==8
gen mana=occup==9
gen abro=occup==10

eststo clear
quietly areg farm had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store farm
quietly areg farm had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store farm_low
quietly areg farm had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store farm_high

quietly areg elem had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store elem
quietly areg elem had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store elem_low
quietly areg elem had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store elem_high

quietly areg mach had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store mach
quietly areg mach had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store mach_low
quietly areg mach had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store mach_high

quietly areg craf had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store craf
quietly areg craf had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store craf_low
quietly areg craf had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store craf_high

quietly areg cust had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store cust
quietly areg cust had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store cust_low
quietly areg cust had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store cust_high

quietly areg sale had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store sale
quietly areg sale had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store sale_low
quietly areg sale had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store sale_high

quietly areg cler had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store cler
quietly areg cler had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store cler_low
quietly areg cler had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store cler_high

quietly areg prof had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store prof
quietly areg prof had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store prof_low
quietly areg prof had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store prof_high

quietly areg mana had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store mana
quietly areg mana had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store mana_low
quietly areg mana had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store mana_high

quietly areg abro had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store abro
quietly areg abro had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu<=9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store abro_low
quietly areg abro had_policy i.cohort i.edu female rural ///
indigenous married [aw=weight] if edu>9 & paidw==1, absorb(geo) vce(cluster geo)
estimates store abro_high

label var had_policy " "
/* Panel (a) Farming */
coefplot ///
(farm_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(farm, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(farm_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in farming occupations", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend( pos(5) ring(0) col(1) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterFarm.png", replace
/* Panel (b) Elementary */
coefplot ///
(elem_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(elem, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(elem_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in elementary occupations", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterElem.png", replace
/* Panel (c) Machine operator */
coefplot ///
(mach_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(mach, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(mach_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in machine operator occupations", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterMach.png", replace
/* Panel (d) Crafts */
coefplot ///
(craf_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(craf, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(craf_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in crafts occupations", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterCraft.png", replace
/* Panel (e) Customer service */
coefplot ///
(cust_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(cust, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(cust_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in customer service", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterCust.png", replace
/* Panel (f ) Sales */
coefplot ///
(sale_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(sale, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(sale_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in sales", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterSale.png", replace
/* Panel (g) Clerks */
coefplot ///
(cler_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(cler, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(cler_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in clerical occupations", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterCler.png", replace
/* Panel (h) Professionals */
coefplot ///
(prof_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(prof, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(prof_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in professional occupations", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterProf.png", replace
/* Panel (i) Managerial */
coefplot ///
(mana_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(mana, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(mana_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working in managerial occupations", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterMana.png", replace
/* Panel (j) Abroad */
coefplot ///
(abro_high, label(High-education) msymbol(S) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(abro, label(Full sample) msymbol(S) mcolor(black) ciopt(lc(black) recast(rcap))) ///
(abro_low, label(Low-education) msymbol(S) mcolor(ltblue) ciopt(lc(ltblue) recast(rcap))), ///
keep(had_policy) xline(0, lstyle(grid) lpattern(dash) lcolor(black)) ///
ytitle("Likelihood of working abroad", size(medium) height(5)) ///
xlabel(-.2(0.1).2, labs(medium) format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) ciopts(recast(rcap)) levels(90)
graph export "$doc\graphSDDheterAbro.png", replace
