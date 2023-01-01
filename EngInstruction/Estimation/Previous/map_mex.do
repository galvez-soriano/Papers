*========================================================================*
* Map of Mexico
*========================================================================*
gl data= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\Map\State"
gl base= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\New"
gl doc= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Doc"
*========================================================================*
shp2dta using mx_state, database(mxdb) coordinates(mxcoord) genid(id) replace
use "$doc\mxdb.dta", clear
sort name place
rename ref state
replace state="NAY" if name=="Nayarit"
replace state="1" if state=="AGU"
replace state="2" if state=="BCN"
replace state="3" if state=="BCS"
replace state="4" if state=="CAM"
replace state="5" if state=="COA"
replace state="6" if state=="COL"
replace state="7" if state=="CHP"
replace state="8" if state=="CHH"
replace state="9" if state=="DIF"
replace state="10" if state=="DUR"
replace state="11" if state=="GUA"
replace state="12" if state=="GRO"
replace state="13" if state=="HID"
replace state="14" if state=="JAL"
replace state="15" if state=="MEX"
replace state="16" if state=="MIC"
replace state="17" if state=="MOR"
replace state="18" if state=="NAY"
replace state="19" if state=="NLE"
replace state="20" if state=="OAX"
replace state="21" if state=="PUE"
replace state="22" if state=="QUE"
replace state="23" if state=="ROO"
replace state="24" if state=="SLP"
replace state="25" if state=="SIN"
replace state="26" if state=="SON"
replace state="27" if state=="TAB"
replace state="28" if state=="TAM"
replace state="29" if state=="TLA"
replace state="30" if state=="VER"
replace state="31" if state=="YUC"
replace state="32" if state=="ZAC"

destring state, replace
label define state 1 AGS 2 BC 3 BCS 4 CAMP 5 COAH 6 COL 7 CHIA 8 CHIH 9 MXC 10 ///
DGO 11 GTO 12 GRO 13 HGO 14 JAL 15 MEX 16 MICH 17 MOR 18 NAY 19 NL 20 OAX ///
21 PUE 22 QUER 23 QRO 24 SLP 25 SIN 26 SON 27 TAB 28 TAM 29 TLAX 30 VER ///
31 YUC 32 ZAC
label values state state

keep state id
save "mx_eng.dta", replace

merge m:m state using "eng_sch.dta"
drop _merge
save "mx_eng.dta", replace
*========================================================================*
use "$data/mx_eng.dta", clear
drop if state==.
format eng* %12.2f

spmap eng2008 using "$data/mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(9) eirange(0 1)
graph export "$doc\map01.png", replace

spmap eng2011 using "$data/mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(9) eirange(0 1) legend(off) 
graph export "$doc\map02.png", replace

spmap eng2008r using "$data/mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 1) legend(off)
graph export "$doc\map01r.png", replace 

spmap eng2011r using "$data/mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 1) legend(off) 
graph export "$doc\map02r.png", replace

spmap eng2008u using "$data/mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 1) legend(size(*3)) 
graph export "$doc\map01u.png", replace

spmap eng2011u using "$data/mxcoord.dta", id(id) ///
clmethod(eqint) clnumber(5) eirange(0 1) legend(size(*3)) 
graph export "$doc\map02u.png", replace
