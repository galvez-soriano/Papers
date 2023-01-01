* ROY MODEL
*** Date:    01 APR 2021
*** UPDATED: 11 APR 2021

*** Author:  Yona Rubinstein

/*
http://kaichen.work/?p=1198
*/

# delimit;
clear ;
clear mata ;
clear matrix ;
set more off ;

set matsize 11000 ;
set maxvar 24000 ;

clear mata ;

/*
PRO
*/

global LOG       "/Users/yonarubinstein/Dropbox/TEACHING/DISCRIMINATION/PROGRAMS/LOG" ;
global PROGRAMS  "/Users/yonarubinstein/Dropbox/TEACHING/DISCRIMINATION/PROGRAMS" ;
global DATA      "/Users/yonarubinstein/Dropbox/TEACHING/DISCRIMINATION/PROGRAMS" ;


capture log close ;

log using "$LOG/ROY MODEL.log", replace ;


/* ************************************************************************** */
/* ********************************* GLOBALS ******************************** */
/* ************************************************************************** */


/* ************************************************************************** */
/* *********************** SELECTION INTO THE SAMPLE ************************ */
/* ************************************************************************** */

/* ************************************************************************** */
/* ******************************* UPLOAD DATA ****************************** */
/* ************************************************************************** */

/*

set obs 1000001 ;

gen id = _n ;

gen     year = 1975 ;

gen ew = rnormal(0,1) ;
gen er = rnormal(0,1) ;

gen sf = rnormal(0,1) ;
gen sm = rnormal(0,1) ;


save "$LOG/data1.log", replace ;

use "$LOG/data1.log", clear ;

replace year = 1995 ;

append using "$LOG/data1.log" ;

sort id year ;

save "$LOG/data.log", replace ;

*/

use "$LOG/data.log", clear ;

gen rho = 0.5 ;

gen _Ew = ew ;
gen _Er = 1.00*ew + er ;

gen _Esf = sf ;
gen _Esm = 1.00*sf + sm ;



egen EwM = mean(_Ew) ;
egen EwS = sd(_Ew) ;

egen ErM = mean(_Er) ;
egen ErS = sd(_Er) ;

egen EsfM = mean(_Esf) ;
egen EsfS = sd(_Esf) ;

egen EsmM = mean(_Esm) ;
egen EsmS = sd(_Esm) ;

gen Ew  = (_Ew-EwM)/EwS ;
gen Er  = (_Er-ErM)/ErS ;

gen Esf = (_Esf-EsfM)/EsfS ;
gen Esm = (_Esm-EsmM)/EsmS ;


label variable Ew "market skill" ;
label variable Er "non-market skill" ;
label variable Esf "school skill female" ;
label variable Esm "school skill male" ;


gen S75w = 0.25 ;
gen S95w = 1.00 ;

gen     D95 = 0 ;
replace D95 = 1 if year==1995 ;

gen     Sf = 0;
replace Sf = 1 if Esf <-2 ;
replace Sf = 2 if Esf >=-2 & Esf<-1 ;
replace Sf = 3 if Esf >=-1 & Esf< 0 ;
replace Sf = 4 if Esf >= 0 & Esf< 1 ;
replace Sf = 5 if Esf >= 1 & Esf< 2 ;
replace Sf = 6 if Esf >= 2 ;


gen     Sm = 0;
replace Sm = 1 if Esm <-2 ;
replace Sm = 2 if Esm >=-2 & Esm<-1 ;
replace Sm = 3 if Esm >=-1 & Esm< 0 ;
replace Sm = 4 if Esm >= 0 & Esm< 1 ;
replace Sm = 5 if Esm >= 1 & Esm< 2 ;
replace Sm = 6 if Esm >= 2 ;



gen W = S75w*Ew*(1-D95) + S95w*Ew*D95 + Esf ; 
gen R = Er + 0.25*Esm ;

label variable W "Wage" ;
label variable R "Reservation Wage" ;

gen L = 0 ;
replace L=1 if W>R ;

gen W_ =W if L==1 ;


/* ************************************************************************** */
/* ******************************* ESTIMATION ******************************* */
/* ************************************************************************** */


/* ******************************** HECKMAN ********************************* */


probit L Esf if D95==0 ;
predict z0, xb ;

probit L Esf if D95==1 ;
predict z1, xb ;


gen     z=z0 ;
replace z=z1 if D95==1 ;

gen PDF = normalden(z) ; 
gen CDF = normal(z)  ;
gen IMR = PDF/CDF ;


reg     W_ Esf     if D95==0 ;
estimates store E751 ;

reg     W_ Esf IMR if D95==0 ;
estimates store E752 ;

heckman W_ Esf if D95==0, select(L = Esf) twostep ;
estimates store E753 ;

reg     W_ Esf     if D95==1 ;
estimates store E951 ;

reg     W_ Esf IMR if D95==1 ;
estimates store E952 ;

heckman W_ Esf if D95==1, select(L = Esf) twostep ;
estimates store E953 ;


/* ******************************** INFINITY ******************************** */


reg     W_ Esf     if D95==0 ;
estimates store E75_0 ;
gen G_P0 = _b[_cons] ;

reg     W_ Esf     if D95==0 & CDF>=0.50 ;
estimates store E75_1 ;
gen G_P50 = _b[_cons] ;

reg     W_ Esf     if D95==0 & CDF>=0.75 ;
estimates store E75_2 ;
gen G_P75 = _b[_cons] ;


reg     W_ Esf     if D95==0 & CDF>=0.85 ;
estimates store E75_3 ;
gen G_P85 = _b[_cons] ;


reg     W_ Esf     if D95==0 & CDF>=0.95 ;
estimates store E75_4 ;
gen G_P95 = _b[_cons] ;




reg     W_ Esf     if D95==1 ;
estimates store E95_0 ;
gen G95_P0 = _b[_cons] ;

reg     W_ Esf     if D95==1 & CDF>=0.50 ;
estimates store E95_1 ;
gen G95_P50 = _b[_cons] ;

reg     W_ Esf     if D95==1 & CDF>=0.75 ;
estimates store E95_2 ;
gen G95_P75 = _b[_cons] ;


reg     W_ Esf     if D95==1 & CDF>=0.85 ;
estimates store E95_3 ;
gen G95_P85 = _b[_cons] ;


reg     W_ Esf     if D95==1 & CDF>=0.95 ;
estimates store E95_4 ;
gen G95_P95 = _b[_cons] ;

label variable G_P0  "P>=0.00" ;
label variable G_P50 "P>=0.50" ;
label variable G_P75 "P>=0.75" ;
label variable G_P85 "P>=0.85" ;
label variable G_P95 "P>=0.95" ;




reg     W_ Esf D95       ;
estimates store E0 ;

reg     W_ Esf D95     if CDF>=0.50 ;
estimates store E1 ;

reg     W_ Esf D95    if CDF>=0.75 ;
estimates store E2 ;


reg     W_ Esf D95    if CDF>=0.85 ;
estimates store E3 ;


reg     W_ Esf D95    if CDF>=0.95 ;
estimates store E4 ;


reg     W_ Esf D95    if CDF>=0.99 ;
estimates store E5 ;


label variable G_P0  "P>=0.00" ;
label variable G_P50 "P>=0.50" ;
label variable G_P75 "P>=0.75" ;
label variable G_P85 "P>=0.85" ;
label variable G_P95 "P>=0.95" ;


estout 

E75_0 E75_1 E75_2 E75_3 E75_4 
E95_0 E95_1 E95_2 E95_3 E95_4 

E0 E1 E2 E3 E4 E5
using "$LOG/II.txt", replace 

keep(_cons D95)
cells(b(star fmt(3)) se(par fmt (3)))
legend label varlabels(_cons Constant)  
stats(N num_singletons N_all r2 , fmt(0 0 0 3) labels(Observations Singletons All R-square))
starlevels(* 0.10 ** 0.05 *** 0.01)
prehead("IDENTIFICATION AT THE INFINTY") 
posthead("")
prefoot("")
postfoot("" 
"Notes."
"TBA"
) ;



log close ;
