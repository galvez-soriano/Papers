*========================================================================*
/* How to remove numbers from a string variable */
*========================================================================*
import delimited "https://raw.githubusercontent.com/galvez-soriano/data/main/biare/isco.csv", clear

split v1, generate(sinco) limit(1)
forval n = 0/9{
    replace v1 = subinstr(v1, "`n'", "",.)
}

rename sinco1 sinco_sub
rename v1 sinco_d
