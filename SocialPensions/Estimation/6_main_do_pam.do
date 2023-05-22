*=====================================================================*
/* Paper: Minimum Eligibility Age for Social Pensions and Household Poverty: 
   Evidence from Mexico
   Authors: Clemente Avila-Parra, David Escamilla-Guerrero and Oscar 
   Galvez-Soriano */
*=====================================================================*
/* INSTRUCTIONS:

   Before running this program, make sure to run the program 0_setup.do
   We also require that you create two folders in your computer. First, 
   a folder with the name "Data", which will store the master data set
   named "dbase65.dta", which can be downloaded along with this program. 
   Second, a folder with the name "Doc", which will store the 
   figures and tables created with this program. 
   
   Once you created these folders, you must define their paths in the 
   following globals (in lines 27 and 28 of this program), respectively: 
   
   gl data="C:\Users\Documents\Pensions\Data"
   gl doc="C:\Users\Documents\Pensions\Doc"   
   */
*=====================================================================*
/* Main do file */
*=====================================================================*
clear
set more off
gl data="C:\Users\iscot\Documents\GalvezSoriano\Papers\Pensions\Data"
gl doc="C:\Users\iscot\Documents\GalvezSoriano\Papers\Pensions\Doc"
*=====================================================================*
/* You could also pull directly the master database from Oscar Galvez-
Soriano's GitHub website by uncommenting and running lines 35-42 of 
this program. This avoids downloading all data sets to your computer */
*=====================================================================*
/*
gl base="https://raw.githubusercontent.com/galvez-soriano/Papers/main/SocialPensions/Data"
use "$base/dbase1.dta", clear
foreach x in 2 3 4 5 6 7 8 9 10 11 12 13 14 15{
    append using "$base/dbase`x'.dta"
}
save "$data\dbase65.dta", replace
*/
*=====================================================================*
* Figure 1. Pensions coverage by income decile, Mexico (2008-2014)
*=====================================================================*
use "$data\dbase65.dta", clear
graph set window fontface "Times New Roman"
gen inc_decile=.
foreach x in 2008 2010 2012 2014 {
xtile dec`x'=ictpc if year==`x', nq(10)
replace inc_decile=dec`x' if year==`x'
drop dec`x'
}
gen jubi_cat=.
replace jubi_cat=0 if ss_dir==1 & age>=65 & pam==0
replace jubi_cat=1 if ss_dir==0 & age>=65 & pam==1
replace jubi_cat=2 if ss_dir==1 & age>=65 & pam==1
replace jubi_cat=3 if ss_dir==0 & age>=65 & pam==0

catplot jubi_cat year inc_decile [fw=factor], ///
percent(inc_decile year) ///
graphregion(fcolor(white)) ///
var1opts(label(labsize(small))) ///
var2opts(label(labsize(vsmall))) ///
var3opts(label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Pensions coverage rate", size(small)) ///
ylabel(,labs(small)) ///
asyvars stack ///
bar(1, color(navy)) bar(2, color(170 94 190)) ///
bar(3, color(ebblue)) bar(4, color(gs11)) ///
legend(rows(1) stack size(vsmall) ///
order(1 "Contributory Pension Only" 2 "PAM Only" ///
3 "Both Contributory and PAM" 4 "Coverage Gap") symplacement(center))
graph export "$doc\fig1.png", replace
*=====================================================================* 
/* Figure 2: Parallel trend assumption 2008-2014 */
*=====================================================================*
use "$data\dbase65.dta", clear
replace ubica_geo=substr(ubica_geo,1,5)
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"

foreach x in 08 10 12 14{
gen treat_20`x'=0
replace treat_20`x'=1 if treat==1 & year==20`x'
label var treat_20`x' "20`x'"
}
replace treat_2012=0
*=====================================================================*
/* Figure 2: Parallel trend assumption 2008-2014
Panel A. ln(Income) */
*=====================================================================*
areg l_inc treat_20* treat i.year rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Percentage change of income (/100)", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(-0.525 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\fig2A.png", replace
*=====================================================================*
/* Figure 2: Parallel trend assumption 2008-2014
Panel B. Poverty and Extreme poverty */
*=====================================================================*
areg poor treat_20* treat i.year rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store poverty
areg epoor treat_20* treat i.year rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store xpoverty 

coefplot (poverty, label(Poverty) offset(-.03)) (xpoverty, ciopt(lc(black) ///
recast(rcap)) label(Extreme poverty) offset(.03) m(T) mcolor(white) mlcolor(black)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of living in (extreme) poverty", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.20, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) text(-0.21 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\fig2B.png", replace 
*=====================================================================*
/* Figure 2: Parallel trend assumption 2008-2014
Panel C. Labor force participation */
*=====================================================================*
areg labor treat_20* treat i.year rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of belonging to labor force", size(medium) height(5)) ///
ylabel(-0.3(0.15)0.3, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.3 0.3)) text(-0.315 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\fig2C.png", replace
*=====================================================================*
/* Figure 2: Parallel trend assumption 2008-2014
Panel D. Labor supply */
*=====================================================================*
areg hwork treat_20* treat i.year rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)

coefplot, vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Number of hours worked", size(medium) height(5)) ///
ylabel(-10(5)10, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-10 10)) text(-10.55 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\fig2D.png", replace 
*=====================================================================*
/* Figure 3: Simulated income distribution with and without PAM 
(eligible sample) */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
drop if ss_dir!=0
gen ictpc_pam=ictpc-ing_65mas
label var ictpc_pam "Income excluding PAM"
gen income_hip=ictpc
replace income_hip=ictpc+580 if treat_hh==1 & pam!=1
label var income_hip "Income with PAM (full compliance)"

drop if ictpc>1000000
gen lictpc=log(ictpc) if treat==1 & year==2014
gen lictpc_pam=log(ictpc_pam) if treat==1 & year==2014
gen lictpc_hip=log(income_hip) if treat==1 & year==2014
*=====================================================================*
/* Figure 3: Simulated income distribution with and without PAM 
Panel A. Rural */
*=====================================================================*
cumul lictpc [fw=factor] if rural==1, gen(income)
cumul lictpc_pam [fw=factor] if rural==1, gen(inc_pam)
cumul lictpc_hip [fw=factor] if rural==1, gen(inc_hip)

sort folioviv foliohog
set obs 440050
replace year = 2014 in 440050
replace income = 0 in 440050
replace inc_pam = 0 in 440050
replace ictpc_pam = 0 in 440050
replace income_hip = 0 in 440050
replace lictpc = 0 in 440050
replace rural = 1 in 440050

twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11), sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11), sort || line inc_hip ///
lictpc_hip if (lictpc>=0 & lictpc<=11), sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ///
legend(order(1 "Income excluding PAM" 2 "Total Income" 3 "Hypothesized Income with PAM") ///
pos(10) ring(0) col(1) region(lcolor(white))) ///
xline(7.38, lstyle(grid) lpattern(dash_dot) lcolor(gs8)) ///
text(1.08 7.1 "PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(6.76, lstyle(grid) lpattern(shortdash) lcolor(gs8)) ///
text(.68 4.1 "Food-based PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\fig3_rur.png", replace 
*=====================================================================*
/* Figure 3: Simulated income distribution with and without PAM 
Panel B. Urban */
*=====================================================================*
drop income inc_pam inc_hip
cumul lictpc [fw=factor] if rural==0, gen(income)
cumul lictpc_pam [fw=factor] if rural==0, gen(inc_pam)
cumul lictpc_hip [fw=factor] if rural==0, gen(inc_hip)
sort folioviv foliohog
replace lictpc = 0 in 1
replace lictpc_pam = 0 in 1
replace income = 0 in 1
replace inc_pam = 0 in 1
replace hli = 1 in 1
replace rural = 0 in 1

twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11), sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11), sort || line inc_hip ///
lictpc_hip if (lictpc>=0 & lictpc<=11), sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium) ) ///
graphregion(color(white)) scheme(s2mono) ///
legend(off) ///
xline(7.84, lstyle(grid) lpattern(dash_dot) lcolor(gs8)) ///
text(1.08 7.6 "PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(7.12, lstyle(grid) lpattern(shortdash) lcolor(gs8)) ///
text(0.68 4.4 "Food-based PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\fig3_urb.png", replace
*=====================================================================*
/* Table 1: Summary statistics */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"

eststo clear
eststo control_12: quietly estpost sum l_inc poor epoor labor hwork gender ///
educ hli cohab rural suburb urban city [aw=factor] if after==0 & treat==0 ///
& ss_dir==0
eststo treat_12: quietly estpost sum l_inc poor epoor labor hwork gender ///
educ hli cohab rural suburb urban city [aw=factor] if after==0 & treat==1 ///
& ss_dir==0
eststo control_14: quietly estpost sum l_inc poor epoor labor hwork gender ///
educ hli cohab rural suburb urban city [aw=factor] if after==1 & treat==0 ///
& ss_dir==0
eststo treat_14: quietly estpost sum l_inc poor epoor labor hwork gender ///
educ hli cohab rural suburb urban city [aw=factor] if after==1 & treat==1 ///
& ss_dir==0
eststo diff: quietly estpost ttest l_inc poor epoor labor hwork gender ///
educ hli cohab rural suburb urban city, by(treat) unequal
esttab control_12 treat_12 control_14 treat_14 diff using "$doc\tab1.tex", ///
cells("mean(pattern(1 1 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) label replace

/* Notes:

Fill in the last column of the table with the actual DiD estimate using
the following code for each variable y:
reg y after_treat after treat if ss_dir==0 [aw=factor], vce(cluster ubica_geo)

Standard errors are clustered at the municipality level. To obtain the SE use 
the following code for each case:
reg y treat if after==(0,1) & ss_dir==0 [aw=factor], vce(cluster ubica_geo)
*/
*=====================================================================*
/* Main Results */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
/* Table 2: The impact of expanding social pensions (DD estimation) 
Panel A. Baseline */
*=====================================================================*
* Dependent variable: Take up 
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
* Dependent variable: Income per capita
eststo: areg l_inc after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
* Dependent variable: Poverty. Welfare and minimum welfare lines
eststo: areg poor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
* Dependent variable: Labor
eststo: areg labor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tab2A.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab2}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
/* Robustness checks: DiD estimations */
*=====================================================================*
/* Table 2: The impact of expanding social pensions (DD estimation) 
Panel B. Narrowed age groups (63-64 v. 66-67) */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=67
bysort folioviv foliohog: replace treat=0 if age>=63 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat tamhogesc educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tab2B.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab2}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
/* Table 2: The impact of expanding social pensions (DD estimation) 
Panel C. Alternative control group (71-74) */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=71 & age<=74
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tab2C.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab2}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
/* Table 2: The impact of expanding social pensions (DD estimation) 
Panel D. Baseline including individuals 65 years old */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=65 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tab2D.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(DiD estimations ///
(\autoref{eq:1})\label{tab2}) keep(after_treat) stats(N ar2, fmt(%9.0fc %9.3f)) replace
*=====================================================================*
/* Table 3: Heterogeneous effects of expanding social pensions 
(DD estimation) */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================*
/* Table 3: Heterogeneous effects of expanding social pensions 
Panel A. Population group */
*=====================================================================*
/* Men */
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tab3_men.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
title(Women) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
/* Table 3: Heterogeneous effects of expanding social pensions 
Panel A. Population group */
*=====================================================================*
/* Women */
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tab3_women.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
title(Women) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
/* Table 3: Heterogeneous effects of expanding social pensions 
 Panel A. Population group */
*=====================================================================*
/* Indigenous */
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tab3_ind.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
title(Indigenous) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
/* Table 3: Heterogeneous effects of expanding social pensions 
Panel A. Population group */
*=====================================================================*
/* Non-Indigenous */
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==0 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tab3_non_ind.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
title(Non-Indigenous) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
/* Table 3: Heterogeneous effects of expanding social pensions 
Panel B. Locality size (sl) */
*=====================================================================*
/*
tam_loc=1: inhabitants>=100,000
tam_loc=2: 15,000<=inhabitants<=99,999
tam_loc=3: 2,500<=inhabitants<=14,999
tam_loc=4: inhabitants<2,500 
*/
*=====================================================================*
/* Rural: sl<2,500 */
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==4 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==4 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==4 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==4 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==4 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==4 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tab3_rur.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab3}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
/* Table 3: Heterogeneous effects of expanding social pensions 
Panel B. Locality size (sl) */
*=====================================================================*
/* Urban: 2,500≤sl<15,000 */
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==3 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==3 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==3 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==3 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==3 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==3 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tab3_subur.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab3}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
/* Table 3: Heterogeneous effects of expanding social pensions 
Panel B. Locality size (sl) */
*=====================================================================*
/* Urban: 15,000≤sl<100,000 */
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==2 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==2 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==2 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==2 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==2 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==2 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tab3_urb.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab3}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
/* Table 3: Heterogeneous effects of expanding social pensions 
Panel B. Locality size (sl) */
*=====================================================================*
/* Urban: sl≥100,000 */
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & tam_loc==1 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tab3_city.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab3}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================* 
/* Table 4: Substitution and anticipation effects of expanding social 
pensions (DD estimation) */
*=====================================================================* 
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================* 
/* Table 4: Substitution and anticipation effects of expanding social pensions 
Panel A. Substitution of subordinate work for self-employment */
*=====================================================================* 
gen selfemp=indep==1

eststo clear
eststo: areg selfemp after_treat after treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg selfemp after_treat after treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg selfemp after_treat after treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg selfemp after_treat after treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
esttab using "$doc\tab4A.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
title(Paid full) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) /// 
label replace keep(after_treat)
*=====================================================================* 
/* Table 4: Substitution and anticipation effects of expanding social pensions
Panel B. Anticipation effects (61-62 v. 63-64) */
*=====================================================================* 
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=63 & age<=64
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=62
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"

eststo clear
eststo: areg labor after_treat after treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tab4B.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) ///
title(DiD estimations\label{tab3}) star(* 0.10 ** 0.05 *** 0.01) ///
stats(N ar2, fmt(%9.0fc %9.3f)) label replace keep(after_treat)
*=====================================================================*
/* Table 5: The impact of expanding social pensions
(IV estimation) */
*=====================================================================* 
use "$data\dbase65.dta", clear

keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
*=====================================================================* 
/* Table 5: The impact of expanding social pensions
Panel A. Poverty */
*=====================================================================* 
/* Structural Equation */
eststo clear
eststo: areg poor pam after treat rural educ gender hli cohab ///
i.age i.tam_loc if ss_dir==0 & after_treat!=. [aw=factor], ///
absorb(state) vce(cluster ubica_geo)
/* First Stage Equation */
eststo: areg pam after_treat after treat rural educ gender hli cohab ///
i.age i.tam_loc if ss_dir==0 [aw=factor], ///
absorb(state) vce(cluster ubica_geo)
/* Reduced Form Equation */
eststo: areg poor after_treat after treat rural educ gender hli cohab ///
i.age i.tam_loc if ss_dir==0 & pam!=. [aw=factor], ///
absorb(state) vce(cluster ubica_geo)
/* IV estimation */
eststo: ivregress 2sls poor (pam=after_treat) after treat rural educ gender hli cohab ///
i.state i.age i.tam_loc if ss_dir==0 [aw=factor], vce(cluster ubica_geo)

esttab using "$doc\tab5A.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(IV ///
\label{tab5}) keep(pam after_treat) star(* 0.10 ** 0.05 *** 0.01) ///
stats(N ar2, fmt(%9.0fc %9.3f)) label replace
*=====================================================================* 
/* Table 5: The impact of expanding social pensions
Panel B. Extreme Poverty */
*=====================================================================* 
eststo clear
eststo: areg epoor pam after treat rural educ gender hli cohab ///
i.age i.tam_loc if ss_dir==0 & after_treat!=. [aw=factor], ///
absorb(state) vce(cluster ubica_geo)
eststo: areg pam after_treat after treat rural educ gender hli cohab ///
i.age i.tam_loc if ss_dir==0 [aw=factor], ///
absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat rural educ gender hli cohab ///
i.age i.tam_loc if ss_dir==0 & pam!=. [aw=factor], ///
absorb(state) vce(cluster ubica_geo)
eststo: ivregress 2sls epoor (pam=after_treat) after treat rural educ gender hli cohab ///
i.state i.age i.tam_loc if ss_dir==0 [aw=factor], vce(cluster ubica_geo)

esttab using "$doc\tab5B.tex", cells(b(star fmt(%9.3f)) se(par)) title(IV ///
\label{tab5}) keep(pam after_treat) star(* 0.10 ** 0.05 *** 0.01) ///
stats(N ar2, fmt(%9.0fc %9.3f)) label replace
*=====================================================================*
/* Online Appendix */
*=====================================================================* <<<=====================================================
/* Figure A.1: PAM beneficiaries, 2013-2016
This table was generated in Excel, file XXX.xls */
*=====================================================================*
/* Figure A.2: Outcomes related to health */
*=====================================================================*
use "$data\dbase65.dta", clear
replace ubica_geo=substr(ubica_geo,1,5)
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"

foreach x in 08 10 12 14{
gen treat_20`x'=0
replace treat_20`x'=1 if treat==1 & year==20`x'
label var treat_20`x' "20`x'"
}
replace treat_2012=0

eststo clear
areg poor_health treat_20* i.year treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store phealth
areg weight_h treat_20* i.year treat rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store weight

coefplot (phealth, label(Sickness) offset(-.03)) (weight, ciopt(lc(black) ///
recast(rcap)) label(Visit to health center) offset(.03) m(T) mcolor(white) mlcolor(black)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of the outcome", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.20, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-0.2 0.2)) text(-0.21 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\figA2.png", replace 
*=====================================================================*
/* Figure A.3: Take-up rate and altitude by locality size */
*=====================================================================*




*=====================================================================*
/* Figure A.4: PAM effect on other household members */
*=====================================================================*
use "$data\dbase65.dta", clear
foreach x in 08 10 12 14{
gen treat_20`x'=0
replace treat_20`x'=1 if treat_hh==1 & year==20`x'
label var treat_20`x' "20`x'"
}
replace treat_2012=0
rename tcheck cohab
replace labor=0 if hwork==.
gen ages=.
replace ages=1 if age>=6 & age<=10
replace ages=2 if age>=11 & age<=17
replace ages=3 if age>=18 & age<=54
replace ages=4 if age>=55
*=====================================================================*
/* Figure A.4: PAM effect on other household members 
Panel A. Labor force participation */
*=====================================================================*
/* Women */
eststo clear
eststo: areg labor treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==2 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw1
eststo: areg labor treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==3 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw2
/* Men */
eststo: areg labor treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==2 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw3
eststo: areg labor treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==3 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw4

coefplot (labw1, label(Girls (11-17)) offset(-.09) msym(D) mcolor(gs13) ciopts(recast(rcap) color(gs13))) /// 
(labw3, label(Boys (11-17)) offset(-.03) msym(S) mcolor(gs11) ciopts(recast(rcap) color(gs11))) ///
(labw2, label(Prime-age adult (women, 18-54)) offset(0.03) msym(Dh) mcolor(gs8) ciopts(recast(rcap) color(gs8))) ///
(labw4, label(Prime-age adult (men, 18-54)) offset(0.09) msym(Sh) mcolor(gs3) ciopts(recast(rcap) color(gs3))), ///
vertical keep(treat_20*) yline(0, lcolor(black)) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of belonging to labor force", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.50, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white))) ///
graphregion(color(white)) ciopts(recast(rcap)) ///
ysc(r(-0.5 0.5)) text(-0.53 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\figA4_A.png", replace
*=====================================================================*
/* Figure A.4: PAM effect on other household members 
Panel B. Labor Supply */
*=====================================================================*
/* Women */
eststo clear
eststo: areg hwork treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==2 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw1
eststo: areg hwork treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==3 & gender==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw2
/* Men */
eststo: areg hwork treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==2 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw3
eststo: areg hwork treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==3 & gender==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw4

coefplot (labw1, label(Young women (11-17)) offset(-.09) msym(D) mcolor(gs13) ciopts(recast(rcap) color(gs13))) /// 
(labw3, label(Young men (11-17)) offset(-.03) msym(S) mcolor(gs11) ciopts(recast(rcap) color(gs11))) ///
(labw2, label(Prime-age adult (women, 18-54)) offset(0.03) msym(Dh) mcolor(gs8) ciopts(recast(rcap) color(gs8))) ///
(labw4, label(Prime-age adult (men, 18-54)) offset(0.09) msym(Sh) mcolor(gs3) ciopts(recast(rcap) color(gs3))), ///
vertical keep(treat_20*) yline(0, lcolor(black)) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Number of hours worked", size(medium) height(5)) ///
ylabel(-20(10)20, labs(medium) grid format(%5.0f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-20 20)) text(-21 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\figA4_B.png", replace
*=====================================================================*
/* Figure A.4: PAM effect on other household members 
Panel C. Labor force participation (indigenous) */
*=====================================================================*
eststo clear
eststo: areg labor treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==2 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw1
eststo: areg labor treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==3 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw2

coefplot (labw1, label(Adolescents (11-17)) offset(-.03)) ///
(labw2, label(Prime-age adults (18-54)) offset(0.03) ciopt(lc(black) recast(rcap)) ///
m(T) mcolor(white) mlcolor(black)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Probability of belong to labor force", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
legend( pos(8) ring(0) col(1) region(lcolor(white))) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-1 1)) text(-1.05 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\figA4_C.png", replace  
*=====================================================================*
/* Figure A.4: PAM effect on other household members 
Panel D. Labor Supply (indigenous) */
*=====================================================================*
eststo clear
eststo: areg hwork treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==2 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw1
eststo: areg hwork treat_20* i.year treat_hh rural educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 & ages==3 & hli==1 [aw=factor], absorb(state) vce(cluster ubica_geo)
estimates store labw2

coefplot (labw1, label(Young individuals (11-17)) offset(-.03)) ///
(labw2, label(Prime-age adults (18-54)) offset(0.03) ciopt(lc(black) recast(rcap)) ///
m(T) mcolor(white) mlcolor(black)), ///
vertical keep(treat_20*) yline(0) omitted baselevels ///
xline(3.48, lstyle(grid) lpattern(dash) lcolor(red)) ///
ytitle("Number of hours worked", size(medium) height(5)) ///
ylabel(-60(30)60, labs(medium) grid format(%5.0f)) ///
legend(off) ///
xtitle("Year", size(medium) height(5)) xlabel(,labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap)) ///
ysc(r(-60 60)) text(-63 3.12 "Feb 2013", linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\figA4_D.png", replace
*=====================================================================*
/* Figure A.5: Income distribution with and without PAM 
(treated sample) */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen ictpc_pam=ictpc-ing_65mas
label var ictpc_pam "Income excluding PAM"

drop if ictpc>1000000
gen lictpc=log(ictpc) if pam==1 & year==2014
gen lictpc_pam=log(ictpc_pam) if pam==1 & year==2014
*=====================================================================*
/* Figure A.5: Income distribution with and without PAM 
Panel A. Men (rural) */
*=====================================================================*
cumul lictpc [fw=factor] if gender==0 & rural==1, gen(income)
cumul lictpc_pam [fw=factor] if gender==0 & rural==1, gen(inc_pam)

sort folioviv foliohog
set obs 440050
replace year = 2014 in 440050
replace income = 0 in 440050
replace inc_pam = 0 in 440050
replace ictpc_pam = 0 in 440050
replace lictpc = 0 in 440050
replace rural = 1 in 440050
replace gender = 0 in 440050

twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11) & gender==0, sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11) & gender==0, sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ///
legend(order(1 "Income excluding PAM" 2 "Total Income" ) pos(10) ring(0) ///
col(1) region(lcolor(white))) ///
xline(7.38, lstyle(grid) lpattern(dash_dot) lcolor(gs8)) ///
text(1.08 7.1 "PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(6.76, lstyle(grid) lpattern(shortdash) lcolor(gs8)) ///
text(.68 4.1 "Food-based PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\figA5_m_rur.png", replace 
*=====================================================================*
/* Figure A.5: Income distribution with and without PAM 
Panel B. Men (urban) */
*=====================================================================*
drop income inc_pam
cumul lictpc [fw=factor] if gender==0 & rural==0, gen(income)
cumul lictpc_pam [fw=factor] if gender==0 & rural==0, gen(inc_pam)
sort folioviv foliohog
replace lictpc = 0 in 1
replace lictpc_pam = 0 in 1
replace income = 0 in 1
replace inc_pam = 0 in 1
replace hli = 1 in 1
replace rural = 0 in 1

twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11) & gender==0, sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11) & gender==0, sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium) ) ///
graphregion(color(white)) scheme(s2mono) ///
legend(off) ///
xline(7.84, lstyle(grid) lpattern(dash_dot) lcolor(gs8)) ///
text(1.08 7.6 "PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(7.12, lstyle(grid) lpattern(shortdash) lcolor(gs8)) ///
text(0.68 4.4 "Food-based PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\figA5_m_urb.png", replace 
*=====================================================================*
/* Figure A.5: Income distribution with and without PAM 
Panel C. Women (rural) */
*=====================================================================*
drop income inc_pam
cumul lictpc [fw=factor] if gender==1 & rural==1, gen(income)
cumul lictpc_pam [fw=factor] if gender==1 & rural==1, gen(inc_pam)
sort folioviv foliohog
replace income = 0 in 1
replace inc_pam = 0 in 1
replace lictpc = 0 in 1
replace lictpc_pam = 0 in 1
replace gender = 1 in 1
replace rural = 1 in 1

twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11) & gender==1, sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11) & gender==1, sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ///
legend(off) ///
xline(7.38, lstyle(grid) lpattern(dash_dot) lcolor(gs8)) ///
text(1.08 7.1 "PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(6.76, lstyle(grid) lpattern(shortdash) lcolor(gs8)) ///
text(.68 4.1 "Food-based PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\figA5_w_rur.png", replace 
*=====================================================================*
/* Figure A.5: Income distribution with and without PAM 
Panel D. Women (urban) */
*=====================================================================*
drop income inc_pam
cumul lictpc [fw=factor] if gender==1 & rural==0, gen(income)
cumul lictpc_pam [fw=factor] if gender==1 & rural==0, gen(inc_pam)
sort folioviv foliohog
replace income = 0 in 1
replace inc_pam = 0 in 1
replace ictpc_pam = 0 in 1
replace lictpc = 0 in 1
replace lictpc_pam = 0 in 1
replace rural = 0 in 1

twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11) & gender==1, sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11) & gender==1, sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium) ) ///
graphregion(color(white)) scheme(s2mono) ///
legend(off) ///
xline(7.84, lstyle(grid) lpattern(dash_dot) lcolor(gs8)) ///
text(1.08 7.6 "PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(7.12, lstyle(grid) lpattern(shortdash) lcolor(gs8)) ///
text(0.68 4.4 "Food-based PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\figA5_w_urb.png", replace 
*=====================================================================*
/* Figure A.5: Income distribution with and without PAM 
Panel E. Indigenous (rural) */
*=====================================================================*
drop income inc_pam
cumul lictpc [fw=factor] if hli==1 & rural==1, gen(income)
cumul lictpc_pam [fw=factor] if hli==1 & rural==1, gen(inc_pam)
sort folioviv foliohog
replace income = 0 in 1
replace inc_pam = 0 in 1
replace lictpc = 0 in 1
replace lictpc_pam = 0 in 1
replace gender = 1 in 1
replace rural = 1 in 1

twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11) & hli==1, sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11) & hli==1, sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium)) ///
graphregion(color(white)) scheme(s2mono) ///
legend(off) ///
xline(7.38, lstyle(grid) lpattern(dash_dot) lcolor(gs8)) ///
text(1.08 7.1 "PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(6.76, lstyle(grid) lpattern(shortdash) lcolor(gs8)) ///
text(.68 4.1 "Food-based PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\figA5_i_rur.png", replace 
*=====================================================================*
/* Figure A.5: Income distribution with and without PAM 
Panel F. Indigenous (urban) */
*=====================================================================*
drop income inc_pam
cumul lictpc [fw=factor] if hli==1 & rural==0, gen(income)
cumul lictpc_pam [fw=factor] if hli==1 & rural==0, gen(inc_pam)
sort folioviv foliohog
replace income = 0 in 1
replace inc_pam = 0 in 1
replace ictpc_pam = 0 in 1
replace lictpc = 0 in 1
replace lictpc_pam = 0 in 1
replace rural = 0 in 1

twoway line inc_pam lictpc_pam if (lictpc>=0 & lictpc<=11) & hli==1, sort || line income ///
lictpc if (lictpc>=0 & lictpc<=11) & hli==1, sort ///
xtitle("Natural log of household per-capita income", size(medium) height(5)) ///
xlabel(0(2)10.5, labs(medium)) ///
ylabel(0(0.2)1, labs(medium) ) ///
graphregion(color(white)) scheme(s2mono) ///
legend(off) ///
xline(7.84, lstyle(grid) lpattern(dash_dot) lcolor(gs8)) ///
text(1.08 7.6 "PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75)) ///
xline(7.12, lstyle(grid) lpattern(shortdash) lcolor(gs8)) ///
text(0.68 4.4 "Food-based PL", color(gs8) linegap(.2cm) ///
size(medium) place(se) nobox just(left) margin(l+4 t+2 b+2) width(75))
graph export "$doc\figA5_i_urb.png", replace
*=====================================================================*
/* Table A.1: Proportion of beneficiaries and income from PAM */
*=====================================================================*
use "$data\dbase65.dta", clear
*=====================================================================*
/* Panel A: Full sample */
*=====================================================================*
tabstat pam [fw=factor] if year==2008, stats(mean) by(tam_loc)
tabstat pam [fw=factor] if year==2010, stats(mean) by(tam_loc)
tabstat pam [fw=factor] if year==2012, stats(mean) by(tam_loc)
tabstat pam [fw=factor] if year==2014, stats(mean) by(tam_loc)

tabstat ing_65mas [fw=factor] if year==2008 & pam==1, stats(mean) by(tam_loc)
tabstat ing_65mas [fw=factor] if year==2010 & pam==1, stats(mean) by(tam_loc)
tabstat ing_65mas [fw=factor] if year==2012 & pam==1, stats(mean) by(tam_loc)
tabstat ing_65mas [fw=factor] if year==2014 & pam==1, stats(mean) by(tam_loc)
*=====================================================================*
/* Panel B: Sample excluding Mexico City */
*=====================================================================*
tabstat pam [fw=factor] if year==2008 & state!=9, stats(mean) by(tam_loc)
tabstat pam [fw=factor] if year==2010 & state!=9, stats(mean) by(tam_loc)
tabstat pam [fw=factor] if year==2012 & state!=9, stats(mean) by(tam_loc)
tabstat pam [fw=factor] if year==2014 & state!=9, stats(mean) by(tam_loc)

tabstat ing_65mas [fw=factor] if year==2008 & pam==1 & state!=9, stats(mean) by(tam_loc)
tabstat ing_65mas [fw=factor] if year==2010 & pam==1 & state!=9, stats(mean) by(tam_loc)
tabstat ing_65mas [fw=factor] if year==2012 & pam==1 & state!=9, stats(mean) by(tam_loc)
tabstat ing_65mas [fw=factor] if year==2014 & pam==1 & state!=9, stats(mean) by(tam_loc)
*=====================================================================*
/* Table A.2: Value of poverty lines 
The values of this table are directly obtained from CONEVAL. See the 
notes of the table for more details */
*=====================================================================*
/* Table A.3: Summary statistics by cohabitation status */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=-1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"

eststo clear
eststo control_wo: quietly estpost sum l_inc poor epoor labor hwork gender ///
educ hli [aw=factor] if cohab!=1 & after==1 & treat==0 & ss_dir==0
eststo treat_wo: quietly estpost sum l_inc poor epoor labor hwork gender ///
educ hli [aw=factor] if cohab!=1 & after==1 & treat==-1 & ss_dir==0
eststo diff_wo: quietly estpost ttest l_inc poor epoor labor hwork gender ///
educ hli if cohab!=1 & after==1 & ss_dir==0, by(treat) unequal 

eststo control_c: quietly estpost sum l_inc poor epoor labor hwork gender ///
educ hli [aw=factor] if treat==0 & after==1 & ss_dir==0
eststo treat_c: quietly estpost sum l_inc poor epoor labor hwork gender ///
educ hli [aw=factor] if treat==-1 & after==1 & ss_dir==0
eststo diff_c: quietly estpost ttest l_inc poor epoor labor hwork gender ///
educ hli if after==1 & ss_dir==0, by(treat) unequal 

esttab control_wo treat_wo diff_wo control_c treat_c diff_c using "$doc\tabA3.tex", ///
cells("mean(pattern(1 1 0 1 1 0) fmt(%9.2fc)) b(star pattern(0 0 1 0 0 1) fmt(%9.2fc))") ///
star(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(%9.0fc)) label replace

/* Notes:

Fill in the "difference" column of the table with the correct difference using
the following codes for each variable y:
reg y treat if ss_dir==0 & after==1 & cohab!=1 [aw=factor], vce(cluster ubica_geo)
reg y treat if ss_dir==0 & after==1 [aw=factor], vce(cluster ubica_geo)

Standard errors are clustered at the municipality level. To obtain the SE use 
the following code for each case:
reg y treat if after==1 & ss_dir==0 & cohab!=1 [aw=factor], vce(cluster ubica_geo)
reg y treat if after==1 & ss_dir==0 [aw=factor], vce(cluster ubica_geo)
*/
*=====================================================================*
/* Table A.4: The impact of expanding social pensions
(DD estimation excluding households with cohabitation) */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
drop if cohab==1
*=====================================================================*
/* Table A.4: The impact of expanding social pensions
Panel A. Baseline results */
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tabA4_A.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab2}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
/* Table A.4: The impact of expanding social pensions
Panel B. Narrowed age groups (63-64 v. 66-67) */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=67
bysort folioviv foliohog: replace treat=0 if age>=63 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
drop if cohab==1
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat tamhogesc educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tabA4_B.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab2}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
/* Table A.4: The impact of expanding social pensions
Panel C. Alternative control group (71-74) */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=66 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=71 & age<=74
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
drop if cohab==1
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age cohab ///
i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tabA4_C.tex", ar2 cells(b(star fmt(%9.3f)) se(par)) title(DiD estimations ///
(\autoref{eq:1})\label{tab2}) star(* 0.10 ** 0.05 *** 0.01) stats(N ar2, fmt(%9.0fc %9.3f)) ///
label replace keep(after_treat)
*=====================================================================*
/* Table A.4: The impact of expanding social pensions
Panel D. Baseline including individuals 65 years old */
*=====================================================================*
use "$data\dbase65.dta", clear
keep if year>=2012
bysort folioviv foliohog: gen treat=1 if age>=65 & age<=69
bysort folioviv foliohog: replace treat=0 if age>=61 & age<=64
rename tcheck cohab
label var treat "Treat"
gen after=.
replace after=1 if year==2014
replace after=0 if year==2012
label var after "After"
gen after_treat=after*treat
label var after_treat "After_Treat"
drop if cohab==1
*=====================================================================*
eststo clear
eststo: areg pam after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg l_inc after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg poor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg epoor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg labor after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)
eststo: areg hwork after_treat after treat educ gender hli i.age ///
cohab i.tam_loc if ss_dir==0 [aw=factor], absorb(state) vce(cluster ubica_geo)

esttab using "$doc\tabA4_D.tex", cells(b(star fmt(%9.3f)) se(par)) ///
star(* 0.10 ** 0.05 *** 0.01) title(DiD estimations ///
(\autoref{eq:1})\label{tab2}) keep(after_treat) stats(N ar2, fmt(%9.0fc %9.3f)) replace
*=====================================================================*
/* End of do file */
*=====================================================================*
