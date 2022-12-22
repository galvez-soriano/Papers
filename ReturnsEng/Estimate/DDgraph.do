*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/data/main"
gl base= "C:\Users\galve\Documents\Papers\Current\Returns to Eng Mex\Data"
gl doc= "C:\Users\galve\Documents\Papers\Current\Returns to Eng Mex\Doc"
*========================================================================*
/* Figure 4: Intention to Treat Effect */
*========================================================================*
eststo clear

use "$base\eng_abil.dta", clear
keep if state=="01" | state=="32"
gen treat=state=="01"
gen after=cohort>=1990
replace after=. if cohort<1986 | cohort>1995
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_ags
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_ags
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_ags
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_ags

use "$base\eng_abil.dta", clear
keep if state=="05" | state=="08"
gen treat=state=="05"
gen after=cohort>=1988
replace after=. if cohort<1979 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_coah
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_coah
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_coah
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_coah

use "$base\eng_abil.dta", clear
keep if state=="10" | state=="24"
gen treat=state=="10"
gen after=cohort>=1991
replace after=. if cohort<1985 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_dgo
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_dgo
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_dgo
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_dgo

use "$base\eng_abil.dta", clear
keep if state=="19" | state=="24"
gen treat=state=="19"
gen after=cohort>=1987
replace after=. if cohort<1981 | cohort>1996
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_nl
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_nl
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_nl
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_nl

use "$base\eng_abil.dta", clear
keep if state=="25" | state=="18"
gen treat=state=="25"
gen after=cohort>=1993
replace after=. if cohort<1989 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_sin
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_sin
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_sin
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_sin

use "$base\eng_abil.dta", clear
keep if state=="26" | state=="02" | state=="08"
gen treat=state=="26"
gen after=cohort>=1993
replace after=. if cohort<1991 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_son
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_son
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_son
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_son

use "$base\eng_abil.dta", clear
keep if state=="28" | state=="02"
gen treat=state=="28"
gen after=cohort>=1990
replace after=. if cohort<1983 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store hrs_tam
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store eng_tam
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight], absorb(geo) vce(cluster geo)
estimates store paid_tam
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1, absorb(geo) vce(cluster geo)
estimates store wage_tam

label var after_treat "Mexican states with English programs"
coefplot (hrs_ags, label(AGS)) ///
(hrs_coah, label(COAH)) ///
(hrs_dgo, label(DGO)) ///
(hrs_nl, label(NL)) ///
(hrs_sin, label(SIN)) ///
(hrs_son, label(SON)) ///
(hrs_tam, label(TAM)), ///
vertical keep(after_treat) yline(0) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-0.5(0.5)1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(3) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graphDDhrs.png", replace 

coefplot (eng_ags, label(AGS)) ///
(eng_coah, label(COAH)) ///
(eng_dgo, label(DGO)) ///
(eng_nl, label(NL)) ///
(eng_sin, label(SIN)) ///
(eng_son, label(SON)) ///
(eng_tam, label(TAM)), ///
vertical keep(after_treat) yline(0) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.2(0.1)0.2, labs(medium) grid format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graphDDeng.png", replace 

coefplot (paid_ags, label(AGS)) ///
(paid_coah, label(COAH)) ///
(paid_dgo, label(DGO)) ///
(paid_nl, label(NL)) ///
(paid_sin, label(SIN)) ///
(paid_son, label(SON)) ///
(paid_tam, label(TAM)), ///
vertical keep(after_treat) yline(0) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
legend(off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graphDDpaid.png", replace 

coefplot (wage_ags, label(AGS)) ///
(wage_coah, label(COAH)) ///
(wage_dgo, label(DGO)) ///
(wage_nl, label(NL)) ///
(wage_sin, label(SIN)) ///
(wage_son, label(SON)) ///
(wage_tam, label(TAM)), ///
vertical keep(after_treat) yline(0) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
legend( off) ///
graphregion(color(white)) scheme(s2mono) ciopts(recast(rcap))
graph export "$doc\graphDDwage.png", replace 

*========================================================================*
/* Figure A: Intention to Treat Effect */
*========================================================================*
eststo clear

use "$base\eng_abil.dta", clear
keep if state=="01" | state=="32"
gen treat=state=="01"
gen after=cohort>=1990
replace after=. if cohort<1986 | cohort>1995
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_ags
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_ags
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
estimates store paid_ags
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_ags

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_ags2
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_ags2
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu>9, absorb(geo) vce(cluster geo)
estimates store paid_ags2
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_ags2

use "$base\eng_abil.dta", clear
keep if state=="05" | state=="08"
gen treat=state=="05"
gen after=cohort>=1988
replace after=. if cohort<1979 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_coah
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_coah
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
estimates store paid_coah
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_coah

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_coah2
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_coah2
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu>9, absorb(geo) vce(cluster geo)
estimates store paid_coah2
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_coah2

use "$base\eng_abil.dta", clear
keep if state=="10" | state=="24"
gen treat=state=="10"
gen after=cohort>=1991
replace after=. if cohort<1985 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_dgo
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_dgo
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
estimates store paid_dgo
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_dgo

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_dgo2
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_dgo2
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu>9, absorb(geo) vce(cluster geo)
estimates store paid_dgo2
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_dgo2

use "$base\eng_abil.dta", clear
keep if state=="19" | state=="24"
gen treat=state=="19"
gen after=cohort>=1987
replace after=. if cohort<1981 | cohort>1996
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_nl
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_nl
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
estimates store paid_nl
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_nl

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_nl2
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_nl2
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu>9, absorb(geo) vce(cluster geo)
estimates store paid_nl2
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_nl2

use "$base\eng_abil.dta", clear
keep if state=="25" | state=="18"
gen treat=state=="25"
gen after=cohort>=1993
replace after=. if cohort<1989 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_sin
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_sin
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
estimates store paid_sin
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_sin

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_sin2
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_sin2
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu>9, absorb(geo) vce(cluster geo)
estimates store paid_sin2
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_sin2

use "$base\eng_abil.dta", clear
keep if state=="26" | state=="02" | state=="08"
gen treat=state=="26"
gen after=cohort>=1993
replace after=. if cohort<1991 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_son
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_son
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
estimates store paid_son
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_son

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_son2
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_son2
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu>9, absorb(geo) vce(cluster geo)
estimates store paid_son2
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_son2

use "$base\eng_abil.dta", clear
keep if state=="28" | state=="02"
gen treat=state=="28"
gen after=cohort>=1990
replace after=. if cohort<1983 | cohort>1996 
gen after_treat=after*treat

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store hrs_tam
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store eng_tam
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu<=9, absorb(geo) vce(cluster geo)
estimates store paid_tam
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu<=9, absorb(geo) vce(cluster geo)
estimates store wage_tam

areg hrs_exp after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store hrs_tam2
areg eng after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store eng_tam2
areg paidw after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if edu>9, absorb(geo) vce(cluster geo)
estimates store paid_tam2
areg lwage after_treat treat i.cohort i.edu female indigenous ///
married [aw=weight] if paidw==1 & edu>9, absorb(geo) vce(cluster geo)
estimates store wage_tam2

label var after_treat "Mexican states with English programs by educational attainment"
coefplot (hrs_ags, label(AGS low) offset(-.46) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(hrs_ags2, label(AGS high) offset(-.43) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_coah, label(COAH low) offset(-.28) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(hrs_coah2, label(COAH high) offset(-.25) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_nl, label(NL low) offset(-.10) msymbol(O) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(hrs_nl2, label(NL high) offset(-.07) msymbol(Oh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_sin, label(SIN low) offset(.08) msymbol(D) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(hrs_sin2, label(SIN high) offset(.11) msymbol(Dh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_son, label(SON low) offset(.26) msymbol(+) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(hrs_son2, label(SON high) offset(.29) msymbol(+) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(hrs_tam, label(TAM low) offset(.44) msymbol(X) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(hrs_tam2, label(TAM high) offset(.47) msymbol(X) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(after_treat) yline(0, lcolor(black)) ///
ytitle("Weekly hours of English instruction", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
legend( pos(8) ring(0) col(4) region(lcolor(white)) size(medium)) ///
graphregion(color(white)) ciopts(recast(rcap))
graph export "$doc\graphDDhrs2.png", replace

coefplot (eng_ags, label(AGS low) offset(-.46) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(eng_ags2, label(AGS high) offset(-.43) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_coah, label(COAH low) offset(-.28) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(eng_coah2, label(COAH high) offset(-.25) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_nl, label(NL low) offset(-.10) msymbol(O) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(eng_nl2, label(NL high) offset(-.07) msymbol(Oh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_sin, label(SIN low) offset(.08) msymbol(D) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(eng_sin2, label(SIN high) offset(.11) msymbol(Dh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_son, label(SON low) offset(.26) msymbol(+) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(eng_son2, label(SON high) offset(.29) msymbol(+) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(eng_tam, label(TAM low) offset(.44) msymbol(X) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(eng_tam2, label(TAM high) offset(.47) msymbol(X) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(after_treat) yline(0, lcolor(black)) ///
ytitle("Likelihood of having English speaking abilities", size(medium) height(5)) ///
ylabel(-0.5(0.25)0.5, labs(medium) grid format(%5.2f)) ///
legend(off) graphregion(color(white)) ciopts(recast(rcap))
graph export "$doc\graphDDeng2.png", replace 

coefplot (paid_ags, label(AGS low) offset(-.46) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(paid_ags2, label(AGS high) offset(-.43) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_coah, label(COAH low) offset(-.28) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(paid_coah2, label(COAH high) offset(-.25) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_nl, label(NL low) offset(-.10) msymbol(O) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(paid_nl2, label(NL high) offset(-.07) msymbol(Oh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_sin, label(SIN low) offset(.08) msymbol(D) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(paid_sin2, label(SIN high) offset(.11) msymbol(Dh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_son, label(SON low) offset(.26) msymbol(+) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(paid_son2, label(SON high) offset(.29) msymbol(+) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(paid_tam, label(TAM low) offset(.44) msymbol(X) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(paid_tam2, label(TAM high) offset(.47) msymbol(X) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(after_treat) yline(0, lcolor(black)) ///
ytitle("Likelihood working for pay", size(medium) height(5)) ///
ylabel(-1(0.5)1, labs(medium) grid format(%5.2f)) ///
legend(off) graphregion(color(white)) ciopts(recast(rcap))
graph export "$doc\graphDDpaid2.png", replace

coefplot (wage_ags, label(AGS low) offset(-.46) msymbol(S) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(wage_ags2, label(AGS high) offset(-.43) msymbol(Sh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_coah, label(COAH low) offset(-.28) msymbol(T) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(wage_coah2, label(COAH high) offset(-.25) msymbol(Th) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_nl, label(NL low) offset(-.10) msymbol(O) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(wage_nl2, label(NL high) offset(-.07) msymbol(Oh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_sin, label(SIN low) offset(.08) msymbol(D) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(wage_sin2, label(SIN high) offset(.11) msymbol(Dh) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_son, label(SON low) offset(.26) msymbol(+) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(wage_son2, label(SON high) offset(.29) msymbol(+) mcolor(blue) ciopt(lc(blue) recast(rcap))) ///
(wage_tam, label(TAM low) offset(.44) msymbol(X) mcolor(dkgreen) ciopt(lc(dkgreen) recast(rcap))) ///
(wage_tam2, label(TAM high) offset(.47) msymbol(X) mcolor(blue) ciopt(lc(blue) recast(rcap))), ///
vertical keep(after_treat) yline(0, lcolor(black)) ///
ytitle("Percentage change of wages (/100)", size(medium) height(5)) ///
ylabel(-3(1)3, labs(medium) grid format(%5.2f)) ///
legend(off) graphregion(color(white)) ciopts(recast(rcap))
graph export "$doc\graphDDwage2.png", replace
