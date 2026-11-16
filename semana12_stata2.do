version 16
clear all
set more off
 
cd "C:\Users\cony7\OneDrive\Documentos\Fundamentos de programación\semana_12"

confirm file "data/raw/casen_reducido.csv"

import delimited "data/raw/casen_reducido", clear varnames(1) encoding("utf-8")

*uff-8 para los tildes y ñ

use "data/raw/casen.dta", clear

describe

list in 1/5

save "data/processed/casen_copia.dta", replace

erase "data/processed/casen_copia.dta"

keep region sector ingreso
list in 1/3

drop if genero == M 
describe, short

count if ingreso > 500000

count if ingreso > 500000 & !missing(ingreso)

use "data/raw/casen.dta",clear

rename educ anios_educ
describe, short 
rename anios_educ educ

rename *, upper

rename *, lower
* todas las variables a minúsculas 

generate ingreso_miles = ingreso/1000
generate experiencia = edad - educ - 6 
replace experiencia = 0 if experiencia < 0

generate pobre_mal = (ingreso < 216000)
generate pobre = (ingreso < 216000) if !missing(ingreso)

tabulate pobre_mal, missing
tabulate pobre, missing 

drop pobre_mal

geb = mujer = (genero == "F")
tabulate mujer

bysort sector: egen ing_medio_sector = mean(ingreso)


import delimited "data/raw/casen_sucio.csv", clear varnames(1) encoding("utf-8")

split sector_region, parse("_") generate(parte)

rename(parte1 parte2) (sector region)


generate pos = strpos(sector_region, "_") // ¿en qué posición está el _?
generate sector2 = substr(sector_region, 1, pos - 1) // lo mismo que split, a mano
assert sector == sector2

generate etiqueta = sector + " (" + region + ")" // pegar textos con +

generate region_ascii = subinstr(region, "í", "i",.)

tostring educ, generate(educ_txt)
destring educ_txt, replace 


display "[" strtrim(" Maule ") "]"
display "[" " Maule " "]"

display strlen("Ñuble") " " ustrlen("Ñuble")
display lower("ÑUBLE") " " ustrlower("ÑUBLE")
display upper("Biobío") " " ustrupper("Biobío")

label variable ingreso "Ingreso mensual ($)" // etiqueta de la variable
label variable experiencia "Experiencia potencial (años)"
label define sino 0 "No pobre" 1 "Pobre" // etiqueta de valores
label values pobre sino

recode educ (0/8 = 1 "Básica") (9/12 = 2 "Media") (13/max = 3 "Superior"), ///
generate(nivel_educ)

label define nivel_educ 3 "Superior (13+ años)", modify 

regress ingreso educ 
regress ingreso educ if sector != "Agricultura"

























