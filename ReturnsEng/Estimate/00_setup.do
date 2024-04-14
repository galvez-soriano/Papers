*========================================================================*
/* English skills and labor market outcomes in Mexico */
*========================================================================*
/* Author: Oscar Galvez-Soriano */
*========================================================================*
/* Run this do file first to install the necessary packages */
*========================================================================*
clear
set more off
ssc install coefplot, replace
ssc install catplot, replace
ssc install estout, replace
ssc install grstyle, replace
ssc install spmap, replace
ssc install boottest, replace
ssc install reghdfe, replace
ssc install ftools, replace
ssc install drdid, replace
ssc install csdid, replace
ssc install eventstudyinteract, replace
ssc install did_multiplegt, replace
ssc install event_plot, replace
grstyle init
grstyle set plain, horizontal
