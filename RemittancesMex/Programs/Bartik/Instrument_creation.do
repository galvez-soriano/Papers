

********************************************************************************
***Network Shift Share - Predicted Deportees due to the SC Shock 
********************************************************************************			
	***A. Merge Network Base 2005 with SC Rollout and Mexican Deportations to create 2 Different Shocks: Activation & Deportation
		**A.1) SC rollout Continuous Indicator Shock (Fraction of the year SC was active)
			**C.1) SC rollout Continuous Indicator Shock
			forval y=2003(1)2014{
				use $inter/SCP_Complete_Rollout_2003_2014_SCcontinuous.dta, clear 
				keep if year==`y'
				keep SCcont FIPS
				*Merge With Network Ratios 
				merge 1:m FIPS using $inter/pair_list_NetworkRatio05.dta
				*Gen mult 
				gen mult=SCcont* Rnetwork05
				*Gen pi 
				bys cve_ent cve_mun: egen pi=total(mult)
				*Clean 
				keep cve_ent cve_mun pi
				duplicates drop 
				drop if cve_ent==""
				drop if cve_mun==""
				gen year=`y'
				*save 
				compress 
				save $inter/pi_`y'.dta, replace 
			}
			*Append by year 
				clear
				forval y=2003(1)2014{
					append using $inter/pi_`y'.dta
				}
			*Save Activation Shock Dset
				rename pi SC_ActShockC
				compress
				save $inter/SC_ContinuousActivationShock_2003_2014_yearly_MXmun.dta, replace 
				*Erase inter
					forval y=2003(1)2014{
						erase $inter/pi_`y'.dta
					}	
		**A.2) SC rollout Dummy Indicator Shock
			forval y=2003(1)2014{
				use $inter/SCP_Complete_Rollout_2003_2014.dta, clear 
				keep if year==`y'
				keep SC FIPS
				*Merge With Network Ratios 
				merge 1:m FIPS using $inter/pair_list_NetworkRatio05.dta
				*Gen mult 
				gen mult=SC* Rnetwork05
				*Gen pi 
				bys cve_ent cve_mun: egen pi=total(mult)
				*Clean 
				keep cve_ent cve_mun pi
				duplicates drop 
				drop if cve_ent==""
				drop if cve_mun==""
				gen year=`y'
				*save 
				compress 
				save $inter/pi_`y'.dta, replace 
			}
			*Append by year 
				clear
				forval y=2003(1)2014{
					append using $inter/pi_`y'.dta
				}
			*Save Activation Shock Dset
				rename pi SC_ActShockD
				compress
				save $inter/SC_DummyActivationShock_2003_2014_yearly_MXmun.dta, replace 
				*Erase inter
					forval y=2003(1)2014{
						erase $inter/pi_`y'.dta
					}	
		**A.3) Mexican Deportations Shock		
			forval y=2005(1)2014{
				*use $inter/SCP_Complete_Deportations.dta, clear 
				use $inter/SC_MexSCRem_TRACAdmin_County_2005_2014.dta, clear 
				keep if year==`y'
				keep MX_SCremoval FIPS
				*Merge With Network Ratios 
				merge 1:m FIPS using $inter/pair_list_NetworkRatio05.dta
				drop if _merge!=3
				drop _merge
				*Gen mult 
				gen mult=MX_SCremoval* Rnetwork05
				*Gen pi 
				bys cve_ent cve_mun: egen pi=total(mult)
				*Clean 
				keep cve_ent cve_mun pi
				duplicates drop 
				drop if cve_ent==""
				drop if cve_mun==""
				gen year=`y'
				*save 
				compress 
				save $inter/pi_`y'.dta, replace 
			}
			*Append by year 
				clear
				forval y=2005(1)2014{
					append using $inter/pi_`y'.dta
				}
			*Save Activation Shock Dset
				rename pi SC_DepShock
				compress
				save $inter/SC_DeportationShock_2003_2014_yearly_MXmun.dta, replace 
				*Erase inter
					forval y=2005(1)2014{
						erase $inter/pi_`y'.dta
					}	
	***B. Save final data set 
			use $inter/SC_ContinuousActivationShock_2003_2014_yearly_MXmun.dta, clear 
			merge 1:1 cve_ent cve_mun year using $inter/SC_DummyActivationShock_2003_2014_yearly_MXmun.dta
			drop _merge 
			merge 1:1 cve_ent cve_mun year using $inter/SC_DeportationShock_2003_2014_yearly_MXmun.dta
			drop if year==2015
			replace SC_DepShock=0 if _merge==1
			drop _merge 
			order cve_ent cve_mun year SC_ActShockD
			sort cve_ent cve_mun year 
			compress
			*save $inter/SC_Shocks_2003_2014_MXmun.dta, replace // Old version of V3 panel 
			*save $inter/SC_Shocks_2003_2014_MXmun_v2.dta, replace  // New version of V3 panel 
			save $inter/SC_Shocks_2003_2014_MXmun_v3.dta, replace  // New version TRAC Admin Deport  
			*Erase	
				erase $inter/SC_ContinuousActivationShock_2003_2014_yearly_MXmun.dta
				erase $inter/SC_DeportationShock_2003_2014_yearly_MXmun.dta
				erase $inter/SC_DummyActivationShock_2003_2014_yearly_MXmun.dta
********************************************************************************		