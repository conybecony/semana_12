

*muestra el directorio de trabajo
 pwd
C:\Users\cony7\OneDrive\Desktop\Finanzas Personales\Stata18\Stata18

*ruta del proyecto
cd "C:\Users\cony7\OneDrive\Documentos\Fundamentos de programación\semana_12"

*confirmar si está
confirm file "data/raw/casen.dta"
confirm file "data\raw\casen_reducido.csv

use "data/raw/casen.dta", clear
display "hola hola"
di 2+2 

keep if edad > 30
* antonimo drop
drop genero 
* me borra solo genero, selecciono por columna
drop if edad <= 30 
* filtro por fila
 
generate y = ingreso/ 1000
* se puede usar g

preserve
* haré distorniones por un rato y luego restore, van juntos

restore 
*vuelve la base completa 

preserve
keep if sector == "Agricultura"
count
restore
count

*La estructura de un buen do-file
* ============================================
* Proyecto: Análisis CASEN
* Autor: Constanza Pinilla Fecha: 2026
* ============================================
cd "C:\Users\cony7\OneDrive\Documentos\Fundamentos de programación\semana_12" // pararse en la carpeta del proyecto
clear all // empezar sin estado previo
set more off // no pausar el output (vital en batch)
* --- 1. Cargar datos ---
import delimited "data/raw/casen_reducido.csv", clear
* --- 2. Limpiar y crear variables ---
* --- 3. Analizar ---

ndksda // sdmaldsamlfmaf
/// es para seguir el comando aunque este cortado
display 5 /// sldkfjafañk
+1
display 3 /* se ignora */ + 4


tabstat ingreso educ edad, /// // forma 1 (la del curso): /// al final
by(sector) stat(mean sd n)
#delimit ; // forma 2: cada comando termina en ;
tabstat ingreso educ edad,
by(sector) stat(mean n) ;
summarize ingreso ;
summarize educ ; 
#delimit cr // volver a la regla normal (Enter)

su ing // ingreso: ing es única
su e // e ambiguous abbreviation (educ y edad)
rep educ = educ // command rep is unrecognized
set varabbrev off // prohibir variables abreviadas
* replace no se abrevia

noisily
quietly 

capture mkdir "output" // crear la carpeta si no existe
capture log close // cerrar un log que quedó abierto
log using "output/analisis.log", replace text
* ... todo el análisis ...
log close

import delimited "data/raw/casen_reducido.csv", clear varnames(1) encoding("utf-8")
* La ENE (S6): separador ; y decimales con coma

sum ed*
list in 1/2
list in 45/60

* El "NA" de R: casen_ingresos.csv (S5) trae los faltantes como letras
import delimited "data/raw/casen_ingresos.csv", clear encoding("utf-8")
describe ing_total // str7: ¡texto!
destring ing_trabajo ing_capital ing_subsidios ing_total, replace ignore("NA")
summarize ing*



* casen_sucio.csv (lab S6): "$730.480" y "s/i"
import delimited "data/raw/casen_sucio.csv", clear encoding("utf-8")
describe
list in 1/4
capture noisily destring ingreso, generate(ingreso_num) ignore("$.")
tabulate ingreso if strpos(ingreso, "$") == 0, missing

replace ingreso = subinstr(ingreso, "$", "", .) // quitar el $
replace ingreso = subinstr(ingreso, ".", "", .) // quitar los puntos de miles
replace ingreso = "" if ingreso == "s/i" // sin información → vacío
destring ingreso, replace
sum ingreso

* ===== Análisis descriptivo CASEN =====
clear all
set more off
* 1. Cargar
import delimited "data/raw/casen_reducido.csv", clear varnames(1) encoding("utf-8")
* 2. Inspeccionar la estructura
describe
* 3. Crear una variable derivada (con intención económica)
generate ingreso_miles = ingreso/1000 // ingreso en miles para legibilidad
* 4. Describir
summarize ingreso educ edad

version 14
clear all
set more off
capture log close
log using "output/s12s1_casen.log", replace text
import delimited "data/raw/casen_reducido.csv", clear varnames(1) encoding("utf-8")
describe
generate ingreso_miles = ingreso/1000
sum ingreso educ edad 
log close 













