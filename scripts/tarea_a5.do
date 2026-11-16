
cd "C:\Users\cony7\OneDrive\Documentos\Fundamentos de programación\semana_12"

* 1
* ============================================================
* A5 — Limpieza y descriptivos de CASEN
* Autor: Constanza Pinilla     Fecha: Noviembre 2026
* ============================================================

clear all
set more off
capture mkdir "output"
capture log close
log using "output/tarea_a5.log", replace text


* 2
import delimited "data/raw/casen_reducido.csv", clear varnames(1) encoding("utf-8")
describe
summarize

* 3
generate experiencia = max(edad - educ - 6, 0)

generate alta_educ = (educ >= 13) if !missing(educ)

replace experiencia = 0 if experiencia < 0

* 4
label variable experiencia "Experiencia potencial (años)"

label variable alta_educ "Indicador de educación superior (13+ años)"
label define lb_alta 0 "Menos de 13 años" 1 "13+ años"
label values alta_educ lb_alta

* 5
count if missing(ingreso) //5

* ¿por qué `summarize ingreso` no se equivoca con los missing, pero `count if 
* ingreso > 500000` **sí** puede equivocarse? porque summarize omite los valores
* perdidos y count if ingreso > 500000 sin excluir los missing, estos valores 
* estarán dentro del conteo.

* 6
summarize ingreso edad educ experiencia
tabulate sector
tabulate region

tabulate sector alta_educ, row

correlate ingreso educ experiencia

summarize ingreso, meanonly
scalar media_ingreso = r(mean)
display "La media de ingreso calculada es: " media_ingreso

* 7
log close

* ============================================================
* INTERPRETACIÓN DE RESULTADOS
* ============================================================
* Los descriptivos muestran un ingreso medio de $655.291 en la muestra, con una
* amplia brecha entre el mínimo y el máximo. Ñuble concentra la mayor proporción 
* de la muestra (25%), mientras que por sector lidera Servicios (28.3%). Además,
* se observa una fuerte correlación positiva (0.68) entre ingresos y educación, * destacando que el sector educación concentra un 100% de alta escolaridad. 
* Estas cifras no implican causalidad directa sin un modelo econométrico adecuado.










