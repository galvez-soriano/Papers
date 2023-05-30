/* ================================================================ */
/* Creating instrument */
/* ================================================================ */
clear
set more off
gl data= "https://raw.githubusercontent.com/galvez-soriano/Papers/main/RemittancesMex/Data"
/* ================================================================ */
use "$data/remitt_mex.dta", clear
keep year quarter ags
merge 1:1 year quarter using "$data/remitt_usa.dta", nogen
gen time=tq(2013q1)+_n-1
tset time

foreach i in al ak az ar ca co ct de fl ga hi id il ind ia ks ky la me md ma mi ///
mn ms mo mt ne nv nh nj nm ny nc nd oh ok or pa pr pi sc sd tn tx ut vt va ///
wa dc wv wi wy {
	 gen dl`i' = log(`i')-log(L4.`i')
}

reg ags dlal dlak dlaz dlar dlca dlco dlct dlde dlfl dlga dlhi dlid dlil ///
dlind dlia dlks dlky dlla dlme dlmd dlma dlmi dlmn dlms dlmo dlmt dlne dlnv ///
dlnh dlnj dlnm dlny dlnc dlnd dloh dlok dlor dlpa dlpr dlpi dlsc dlsd dltn ///
dltx dlut dlvt dlva dlwa dldc dlwv dlwi dlwy
