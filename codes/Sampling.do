cls
clear all

*------------------------------------------------
* 			Trabajo Parcial
*------------------------------------------------
* Rosmery Asto 
* Claudia Vivas

global main  "C:\Users\c3318\OneDrive\2022-2\Topicos de Econometria"
global dos   "$main/1. Do"
global dta   "$main/2. Data"
global works "$main/3. Procesadas"

* Parte 2
*------------------------------------------

	* 2.1
	import spss using "$main\01_PENALES_CARATULA.sav", clear
	gen pp_dcsp = (DELITO_GENERICO == "DELITOS CONTRA LA SEGURIDAD PUBLICA")
	
	* 2.2
		set seed 24042000

	
	* 2.3
	keep ID_CARATULA GENERO EST_PENIT_COD pp_dcsp
	gen reos = 1
	
	* EST_PENIT_COD -> conglomerado
	egen totreos = count(reos), by(EST_PENIT_COD) // total de reos por carcel
	gen estrato = totreos>2000 // estrato
	
	preserve
		keep if estrato == 0
		save "$main\estrato0", replace
	restore
	
	preserve
		keep if estrato == 1
		save "$main\estrato1", replace
	restore
	
	* estrato 1 
	use "$main\estrato1", clear
	
	preserve
		contract EST_PENIT_COD
		set seed 700000
		sample 5
		count 
		tempfile estrato1_e1
		save `estrato1_e1'
	restore
	
	merge m:1 EST_PENIT_COD using `estrato1_e1', keep(match) nogen
	

	* Definimos variables para svyset
	gen pwc1 = 13 / 1 
	gen fpcc1 = 13
		
	tempfile estrato1
	save `estrato1' 
	
	
	* estrato 0
	use "$main\estrato0", clear
	
	preserve
		contract EST_PENIT_COD
		set seed 700000
		sample 5
		count 
		tempfile estrato0_e1
		save `estrato0_e1'
	restore
	
	merge m:1 EST_PENIT_COD using `estrato0_e1', keep(match) nogen
	

	* Definimos variables para svyset
	gen pwc1 = 52 / 3 
	gen fpcc1 = 52
		
	tempfile estrato0
	save `estrato0' 
	
	*juntamos bases 
	*--------------
	
	use `estrato1' , clear
	append using `estrato0'
	
	svyset [pweight = pwc1] , fpc(fpcc1) psu(EST_PENIT_COD) strata(estrato)
	
	
	* item 4
	*---------
	svy: mean pp_dcsp
	svy: tabulate pp_dcsp
	
	gen dummy=1
	collapse (sum) dummy, by(pp_dcsp)
	tab dummy


* Parte 4
*-------------------------------------------------------------------------------

	* 4.1
	import spss using "$main\01_PENALES_CARATULA.sav", clear
	gen pp_dcsp = (DELITO_GENERICO == "DELITOS CONTRA LA SEGURIDAD PUBLICA")
	sum EDAD  // media poblacional de la edad
	
	
	* 4.2
	* 10 repeticiones
	gen iter_10 =_n
	forvalues j=1(1)10{
	preserve
	set seed `j' // muestra aleatoria
	sample 1 // 1%
	sum EDAD
	restore
	dis r(mean)
	replace  iter_10 = r(mean) if iter_10 ==`j'
	}
	replace iter_10=. in 11/L
	
	*Graficamos histograma		
	histogram iter_10, percent fcolor(purple) ytitle("Porcentaje") xtitle("Edad") ///
	title("Distribución muestral de la variable edad (N=10) ") ///
	graphregion(color(white)) ///
	note("Fuente: Elaboración propia en base a la CENPE, 2016 ")
	graph export "$main/histograma_10.png", replace
	
	*Test de normalidad	
	jb iter_10
	sktest iter_10

	* 100 repeticiones
	gen iter_100 =_n
	forvalues j=1(1)100{
	preserve
	set seed `j' // muestra aleatoria
	sample 1 // 1%
	sum EDAD
	restore
	dis r(mean)
	replace  iter_100 = r(mean) if iter_100 ==`j'
	}
	replace iter_100=. in 101/L
	
	*Graficamos histograma	
	histogram iter_100, percent fcolor(purple) ytitle("Porcentaje") xtitle("Edad") ///
	title("Distribución muestral de la variable edad (N=100) ") /// 
	graphregion(color(white)) ///
	note("Fuente: Elaboración propia en base a la CENPE, 2016 ")
	graph export "$main/histograma_100.png", replace
	
	*Test de normalidad	
	jb iter_100
	sktest iter_100	
	
	* 1 000 repeticiones
	gen iter_1000 =_n
	forvalues j=1(1)1000{
	preserve
	set seed `j' // muestra aleatoria
	sample 1 // 1%
	sum EDAD
	restore
	dis r(mean)
	replace  iter_1000 = r(mean) if iter_1000 ==`j'
	}
	replace iter_1000=. in 1001/L
	
	*Graficamos histograma	
	histogram iter_1000, percent fcolor(purple) ytitle("Porcentaje") xtitle("Edad") ///
	title("Distribución muestral de la variable edad (N=1 000) ") ///
	graphregion(color(white)) ///
	note("Fuente: Elaboración propia en base a la CENPE, 2016 ")
	graph export "$main/histograma_1000.png", replace
	
	*Test de normalidad
	jb iter_1000
	sktest iter_1000	
	
	* 10 000 repeticiones
	gen iter_10000 =_n
	forvalues j=1(1)10000{
	preserve
	set seed `j' // muestra aleatoria
	sample 1 // 1%
	sum EDAD
	restore
	dis r(mean)
	replace  iter_10000 = r(mean) if iter_10000 ==`j'
	}
	replace iter_10000=. in 10001/L

	*Graficamos histograma
	histogram iter_10000, percent fcolor(purple) ytitle("Porcentaje") xtitle("Edad") ///
	title("Distribución muestral de la variable edad (N=10 000) ") ///
	graphregion(color(white)) ///
	note("Fuente: Elaboración propia en base a la CENPE, 2016 ")
	graph export "$main/histograma_10000.png", replace

	*Test de normalidad
	jb iter_10000
	sktest iter_10000	
	



	

	
	


