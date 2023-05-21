*=============================================================================================*
/* README file
Paper: Minimum Eligibility Age for Social Pensions and Household Poverty: Evidence from Mexico
Authors: Clemente Avila-Parra, David Escamilla-Guerrero and Oscar Galvez-Soriano */
*=============================================================================================*
/* Data Availability Statement */
*=============================================================================================*

/* The data we use in this paper is publicly available on the Mexico's National Institute of 
Statistics and Geography website. We use the Mexico's National Household Income and Expenditure 
Survey (ENIGH), for the rounds 2008, 2010, 2012 and 2014, which are the comparable years under
the ENIGH's "New Construction" data set. You can download the raw microdata from the following 
links:

ENIGH 2008: http://en.www.inegi.org.mx/programas/enigh/nc/2008/
ENIGH 2010: http://en.www.inegi.org.mx/programas/enigh/nc/2010/
ENIGH 2012: http://en.www.inegi.org.mx/programas/enigh/nc/2012/
ENIGH 2014: http://en.www.inegi.org.mx/programas/enigh/nc/2014/
*/
*=============================================================================================*
Statement about Rights
*=============================================================================================*
/*
=> We certify that the authors of the manuscript have legitimate access to and permission to 
   use the data used in this manuscript.
=> We certify that the authors of the manuscript have documented permission to 
   redistribute/publish the data contained within this replication package. Appropriate 
   permission are documented in the LICENSE.pdf file, also available in the following website:
   https://www.inegi.org.mx/contenidos/inegi/doc/terminos_info.pdf
*/
*=============================================================================================*
/* Computational Requirements */
*=============================================================================================*
/*
We recommend running our code on a dual-core, multicore, or multiprocessor computer.
If working on Windows, we recommend a 64-bit Windows for x86-64 processors made by Intel® or 
AMD (Core i3 equivalent or better).
*/
*=============================================================================================*
/* Software Requirements */
*=============================================================================================*
/*
=> Our codes were last run with STATA version 14.
=> The program "0_setup.do" will install all dependencies locally, and should be run once.
*/
*=============================================================================================*
/* Description of Programs */
*=============================================================================================*
/*
We have uploaded seven different programs
0_setup.do: installs all dependencies
1_2008.do: preparation data of ENIGH 2008
2_2010.do: preparation data of ENIGH 2010
3_2012.do: preparation data of ENIGH 2012
4_2014.do: preparation data of ENIGH 2014
5_Append.do: appends all rounds of ENIGH database
6_main_do_pam.do: main do file
*/
*=============================================================================================*
/* Instructions to Replicators */
*=============================================================================================*
/*
If you want to replicate the main figures and tables you just need to run the following 
programs in the indicated order:

0_setup.do: installs all dependencies (STATA packages)
6_main_do_pam.do: main do file that produces all figures and tables

If, additionally, you want to reconstruct the final database, run the following programs:

1_2008.do: preparation data of ENIGH 2008
2_2010.do: preparation data of ENIGH 2010
3_2012.do: preparation data of ENIGH 2012
4_2014.do: preparation data of ENIGH 2014
5_Append.do: appends all rounds of ENIGH database

Each program has detailed instructions on how to run them. In summary, each program requires 
that the user defines three different paths using globals, as follows:

gl base="https://raw.githubusercontent.com/galvez-soriano/Papers/main/SocialPensions/Data"
gl data="C:\Users\iscot\Documents\GalvezSoriano\Papers\Pensions\Data"
gl doc="C:\Users\iscot\Documents\GalvezSoriano\Papers\Pensions\Doc"

=> The global "base" pulls the data from the Internet.
=> The global "data" defines the path (in user's computer) were new data will be stored.
=> The global "data" defines the path (in user's computer) were the figures and tables will be
   stored.

Inquiries regarding the code and data can be sent to Oscar Galvez-Soriano's email:
ogalvez-soriano@uh.edu
*/
*=============================================================================================*
/* Some notes on the results */
*=============================================================================================*
/*
The program 6_main_do_pam.do, produces the main figures and tables. Please consider the 
following notes.

Figure 2. Each panel of this figure is generated in one single code with an output graph named 
fig2X.png, where X={A,B,C,D}.

Figure 3. Each panel of this figure is generated in one single code with an output graph named 
fig3_X.png, where X={rur,urb}.

Table 1. The four columns of this table are generated in one single code with an output table
named tab1.tex. However, it is necessary to replace the last column generated with the actual 
DiD estimator. Similarly, the standard errors are obtained from a regression with clustering 
at the municipality level. Please see the notes in lines 103-112 of 6_main_do_pam.do for more 
details.

Table 2. Each panel of this table is generated in one single code with an output table named 
tab2X.tex, where X={A,B,C,D}.

Table 3. Each panel and subpanel of this table is generated in one single code with an output 
table named tab3_X.tex, where X={men,women,ind,no_ind,rur,subur,urb,city}.

Table 4. Each panel of this table is generated in one single code with an output table named 
tab2X.tex, where X={A,B}.

APPENDIX

Figure A.4. Each panel of this figure is generated in one single code with an output graph named 
figA4_X.png, where X={A,B,C,D}.

Figure A.5. Each panel of this figure is generated in one single code with an output graph named 
figA5_X.png, where X={m_rur,m_urb,w_rur,w_urb,i_rur,i_urb}.

Table A.1. The content of this table is not autogenerated by the code, but the values of each 
column are computed by the program (from left to right).

Table A.3. The six columns of this table are generated in one single code with an output table
named tabA3.tex. However, it is necessary to replace the "difference" columns generated with 
the correct difference. Similarly, the standard errors are obtained from a regression with 
clustering at the municipality level. Please see the notes in lines 1215-1226 of 6_main_do_pam.do 
for more details.

Table A.4. Each panel of this table is generated in one single code with an output table named 
tabA4_X.tex, where X={A,B,C,D}.
*/