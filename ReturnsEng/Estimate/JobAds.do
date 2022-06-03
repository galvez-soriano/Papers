*========================================================================*
* The effect of the English program on labor market outcomes
*========================================================================*
* Oscar Galvez-Soriano
*========================================================================*
clear
set more off
gl data= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Data\English jobs"
gl doc= "C:\Users\galve\Documents\Papers\Current\English on labor outcomes\Doc"
*========================================================================*
use "$data\computrabajoFile.dta", clear
foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22{
replace category=1 if o_des`x'=="recepcionista" | o_des`x'=="secretaria" ///
| o_des`x'=="encuestador" | o_des`x'=="almacenista"  ///
| o_des`x'=="cajero" | o_des`x'=="capturista" ///
| o_des`x'=="verificador" | o_des`x'=="almacenistas" ///
| o_des`x'=="bodeguero" | o_des`x'=="encuestadoreas" | o_des`x'=="encuestadores" ///
| o_des`x'=="encuestadores" | o_des`x'=="documentador" | o_des`x'=="inventarios" ///
| o_des`x'=="telefonista" | o_des`x'=="telefonista" | o_des`x'=="encuestas" ///
| o_des`x'=="cajeros" | o_des`x'=="cajeras" | o_des`x'=="caja" ///
| o_des`x'=="almacen" | o_des`x'=="receptionist" | o_des`x'=="recepcion" ///
| o_des`x'=="administrativa" | o_des`x'=="asist" | o_des`x'=="cajera" ///
| o_des`x'=="cajeroa" | o_des`x'=="archivista" | o_des`x'=="capturistas" ///
| o_des`x'=="administrativo" | o_des`x'=="cobranza" | o_des`x'=="desk" ///
| o_des`x'=="encuestadorases" | o_des`x'=="encuestadoras"  ///
| o_des`x'=="bibliotecaria" | o_des`x'=="entrevistador" ///
| o_des`x'=="call" | o_des`x'=="telefonico" | o_des`x'=="callcenter" ///
| o_des`x'=="telefonicos" | o_des`x'=="telefonica" | o_des`x'=="center" ///
| o_des`x'=="recepcionsita" | o_des`x'=="archivonomo" | o_des`x'=="almecenista" ///
| o_des`x'=="archivistas" | o_des`x'=="documentacion" | o_des`x'=="encuestado" ///
| o_des`x'=="encuestados" & category==14

replace category=2 if o_des`x'=="grafico" | o_des`x'=="reporteros" ///
| o_des`x'=="arquitecto" | o_des`x'=="arquitecta" | o_des`x'=="dibujante" ///
| o_des`x'=="animador" | o_des`x'=="editorial" | o_des`x'=="video" ///
| o_des`x'=="animadora" | o_des`x'=="artes" | o_des`x'=="modista" ///
| o_des`x'=="cadista" | o_des`x'=="patronista" | o_des`x'=="modelista" ///
| o_des`x'=="instrumentista" | o_des`x'=="animadoras" | o_des`x'=="architect" ///
| o_des`x'=="fotografo" | o_des`x'=="videografo" | o_des`x'=="disenador" ///
| o_des`x'=="violinista" & category==14

replace category=3 if o_des`x'=="consultor" | o_des`x'=="proyecto" ///
| o_des`x'=="licenciada" | o_des`x'=="licenciado" | o_des`x'=="lic" ///
| o_des`x'=="consultores" | o_des`x'=="medico" | o_des`x'=="cirujano" ///
| o_des`x'=="dentista" | o_des`x'=="medicas" | o_des`x'=="licenciatura" ///
| o_des`x'=="urgencias" | o_des`x'=="odontologo" | o_des`x'=="tum" ///
| o_des`x'=="quimico" | o_des`x'=="geologo" | o_des`x'=="estudios" ///
| o_des`x'=="doctor" | o_des`x'=="ultrasonografista" | o_des`x'=="social" ///
| o_des`x'=="investigacion" | o_des`x'=="ortopedista" | o_des`x'=="topografo" ///
| o_des`x'=="agronomo" | o_des`x'=="psicologia" | o_des`x'=="mercados" ///
| o_des`x'=="investigador" | o_des`x'=="investigador" | o_des`x'=="consultoria" ///
| o_des`x'=="geografo" | o_des`x'=="terapeuta" | o_des`x'=="paramedico" ///
| o_des`x'=="optometrista" | o_des`x'=="proyectos" & category==14

replace category=4 if o_des`x'=="programador" | o_des`x'=="sistemas" ///
| o_des`x'=="java" | o_des`x'=="tester" | o_des`x'=="informatica" ///
| o_des`x'=="developer" | o_des`x'=="web" | o_des`x'=="linux" ///
| o_des`x'=="oracle" | o_des`x'=="digitalizador" | o_des`x'=="relaciones" ///
| o_des`x'=="sql" | o_des`x'=="desarrollo" | o_des`x'=="programacion" ///
| o_des`x'=="desarollador" | o_des`x'=="informatica" | o_des`x'=="sme" ///
| o_des`x'=="application" | o_des`x'=="programmer" | o_des`x'=="locutora" ///
| o_des`x'=="server" | o_des`x'=="devloper" | o_des`x'=="representante" ///
| o_des`x'=="representative" | o_des`x'=="desarrolladores" ///
| o_des`x'=="developers" | o_des`x'=="programadores" | o_des`x'=="comunicologo" ///
| o_des`x'=="desarrollador" | o_des`x'=="representatives" ///
| o_des`x'=="tph" | o_des`x'=="tph!" & category==14

replace category=5 if o_des`x'=="jefe" | o_des`x'=="gerente" ///
| o_des`x'=="director" | o_des`x'=="supervisor" | o_des`x'=="gastronomia" ///
| o_des`x'=="chef" | o_des`x'=="subdirector" | o_des`x'=="planeador" ///
| o_des`x'=="gerentee" | o_des`x'=="responsable" | o_des`x'=="manager" ///
| o_des`x'=="cordinador" | o_des`x'=="coordinador" | o_des`x'=="coordinadores" /// 
| o_des`x'=="supervisores" | o_des`x'=="supervisora" | o_des`x'=="planner" ///
| o_des`x'=="superintendente" | o_des`x'=="supervisor" | o_des`x'=="supervisora" ///
| o_des`x'=="cheff" | o_des`x'=="lead" | o_des`x'=="leader" | o_des`x'=="managment" ///
| o_des`x'=="coordinator" | o_des`x'=="management" | o_des`x'=="gte" ///
| o_des`x'=="ingles" & category==14

replace category=6 if o_des`x'=="contador" | o_des`x'=="business" ///
| o_des`x'=="analyst" | o_des`x'=="analista" | o_des`x'=="contadora" ///
| o_des`x'=="exterior" | o_des`x'=="exportaciones" | o_des`x'=="exterior" ///
| o_des`x'=="comercio" | o_des`x'=="internacional" | o_des`x'=="aduanal" ///
| o_des`x'=="financiero" | o_des`x'=="contabilidad" | o_des`x'=="facturista" ///
| o_des`x'=="cuenta" | o_des`x'=="administrador" | o_des`x'=="planeacion" ///
| o_des`x'=="erp" | o_des`x'=="inspector" | o_des`x'=="auditor" ///
| o_des`x'=="contralor" | o_des`x'=="contralora" | o_des`x'=="admin" ///
| o_des`x'=="bancaria" | o_des`x'=="fianzas" | o_des`x'=="sap" ///
| o_des`x'=="financieras" | o_des`x'=="billing" | o_des`x'=="analysta" ///
| o_des`x'=="cuentas" | o_des`x'=="forwarder" | o_des`x'=="transferencista" ///
| o_des`x'=="account" | o_des`x'=="importaciones" | o_des`x'=="scheduler" ///
| o_des`x'=="administracion" | o_des`x'=="admon" | o_des`x'=="credito" ///
| o_des`x'=="bancario" | o_des`x'=="translator" | o_des`x'=="traductor" ///
| o_des`x'=="bilingue" & category==14

replace category=7 if o_des`x'=="profesor" | o_des`x'=="pedagoga" ///
| o_des`x'=="prof" | o_des`x'=="coordinadora" | o_des`x'=="profesores" ///
| o_des`x'=="primaria" | o_des`x'=="preescolar" | o_des`x'=="maternal" ///
| o_des`x'=="secundaria" | o_des`x'=="kinder" | o_des`x'=="pedagogia" ///
| o_des`x'=="capacitador" | o_des`x'=="educadora" | o_des`x'=="academico" ///
| o_des`x'=="maestro" | o_des`x'=="maestra" & category==14

replace category=8 if o_des`x'=="turismo" | o_des`x'=="botones" ///
| o_des`x'=="hotel" & category==14

replace category=9 if o_des`x'=="ingeniero" | o_des`x'=="ingenieros" ///
| o_des`x'=="tecnico" | o_des`x'=="soporte" | o_des`x'=="plomero" ///
| o_des`x'=="electricista" | o_des`x'=="becarios" | o_des`x'=="becario" ///
| o_des`x'=="enfermera" | o_des`x'=="mecanico" | o_des`x'=="soldadura" ///
| o_des`x'=="ing" | o_des`x'=="enfermera" | o_des`x'=="carpintero" ///
| o_des`x'=="automotriz" | o_des`x'=="obra" | o_des`x'=="mantenimiento" ///
| o_des`x'=="laboratorista" | o_des`x'=="practicante" | o_des`x'=="comercio" ///
| o_des`x'=="trainee" | o_des`x'=="egresado" | o_des`x'=="egresada" ///
| o_des`x'=="electrico" | o_des`x'=="tecnicos" | o_des`x'=="automotriz" ///
| o_des`x'=="diesel" | o_des`x'=="electromecanico" | o_des`x'=="automovil" ///
| o_des`x'=="mecanicos" | o_des`x'=="mecanica" | o_des`x'=="maquinas" ///
| o_des`x'=="enfermeras" | o_des`x'=="carpinteros" | o_des`x'=="aparatista" ///
| o_des`x'=="tsu" | o_des`x'=="mtto" | o_des`x'=="industrial" ///
| o_des`x'=="control" | o_des`x'=="instalador" | o_des`x'=="electronico" ///
| o_des`x'=="engineer" | o_des`x'=="ingenieroa" | o_des`x'=="laboratoristas" ///
| o_des`x'=="gasolina" | o_des`x'=="enfermero" | o_des`x'=="autoelectrico" ///
| o_des`x'=="ingeniro" | o_des`x'=="metrologo" | o_des`x'=="electricista" ///
| o_des`x'=="egineer" | o_des`x'=="mecanico" | o_des`x'=="electricos" ///
| o_des`x'=="ingenieria" & category==14

replace category=10 if o_des`x'=="abogado" | o_des`x'=="gestor" ///
| o_des`x'=="gestores" | o_des`x'=="derecho" | o_des`x'=="abogados" ///
| o_des`x'=="revisor" | o_des`x'=="redactor" | o_des`x'=="writer" ///
| o_des`x'=="corrector" | o_des`x'=="editor" & category==14

replace category=11 if o_des`x'=="promovendedora" | o_des`x'=="comercial" ///
| o_des`x'=="ventas" | o_des`x'=="compras" | o_des`x'=="asesor" ///
| o_des`x'=="asesora" | o_des`x'=="comprador" | o_des`x'=="vendedor" ///
| o_des`x'=="promotor" | o_des`x'=="promovedor" | o_des`x'=="agente" ///
| o_des`x'=="promotora" | o_des`x'=="promovedora" | o_des`x'=="clientes" ///
| o_des`x'=="venta" | o_des`x'=="metlife" | o_des`x'=="cliente" ///
| o_des`x'=="telemarketing" | o_des`x'=="mostrador" | o_des`x'=="ejecutiva" ///
| o_des`x'=="demostradora" | o_des`x'=="promodemostradora" ///
| o_des`x'=="promotores" | o_des`x'=="vendedoras" | o_des`x'=="vendedora" ///
| o_des`x'=="charolero" | o_des`x'=="demostradoras" | o_des`x'=="marketing" ///
| o_des`x'=="mercadotecnia" | o_des`x'=="telefonicas" | o_des`x'=="vendedores" ///
| o_des`x'=="sales" | o_des`x'=="customer" | o_des`x'=="representative" ///
| o_des`x'=="compradora" | o_des`x'=="buyer" | o_des`x'=="demovendedora" ///
| o_des`x'=="promotoria" | o_des`x'=="promovendedoras" | o_des`x'=="asesoras" ///
| o_des`x'=="comisionista" | o_des`x'=="asesores" | o_des`x'=="compradoraor" ///
| o_des`x'=="vtas" | o_des`x'=="encargada" | o_des`x'=="demovendedor" ///
| o_des`x'=="promo" | o_des`x'=="seguros" | o_des`x'=="demovendedoras" ///
| o_des`x'=="tienda" | o_des`x'=="abarrotero" | o_des`x'=="mercadotencia" ///
| o_des`x'=="promotoras" | o_des`x'=="vendedoresas" | o_des`x'=="promovendedor" ///
| o_des`x'=="vendedores" | o_des`x'=="promovendedores" | o_des`x'=="custome" ///
| o_des`x'=="negociador" | o_des`x'=="dealer" | o_des`x'=="telemercadeo" ///
| o_des`x'=="telemarketng" | o_des`x'=="vendedorases" | o_des`x'=="encargado" & category==14

replace category=13 if o_des`x'=="humanos" | o_des`x'=="reclutador" ///
| o_des`x'=="reclutadora" | o_des`x'=="reclutamiento" | o_des`x'=="rh" & category==14

replace category=15 if o_des`x'=="mensajero" | o_des`x'=="hostess" ///
| o_des`x'=="ayudante" | o_des`x'=="auxiliar" | o_des`x'=="limpieza" ///
| o_des`x'=="ayudantes" | o_des`x'=="asistente" | o_des`x'=="repartidor" ///
| o_des`x'=="chofer" | o_des`x'=="cobrador" | o_des`x'=="mesero" ///
| o_des`x'=="lavador" | o_des`x'=="motociclista" | o_des`x'=="meseros" ///
| o_des`x'=="intendencia" | o_des`x'=="valet" | o_des`x'=="volantero" ///
| o_des`x'=="volanteros" | o_des`x'=="auxiliares" | o_des`x'=="choferes" ///
| o_des`x'=="cobradores" | o_des`x'=="aseo" | o_des`x'=="garrotero" ///
| o_des`x'=="lava" | o_des`x'=="garroteros" | o_des`x'=="aux" ///
| o_des`x'=="edecan" | o_des`x'=="intendente" | o_des`x'=="intendentes" ///
| o_des`x'=="afanadora" | o_des`x'=="cobranza" | o_des`x'=="repartidores" ///
| o_des`x'=="camarista" | o_des`x'=="personal" | o_des`x'=="estacionamiento" ///
| o_des`x'=="dmoedecanes" | o_des`x'=="lavadores" | o_des`x'=="meseras" ///
| o_des`x'=="conserje" | o_des`x'=="planchadoras" | o_des`x'=="muestrista" ///
| o_des`x'=="anfitriona" | o_des`x'=="conductores" | o_des`x'=="elevadorista" ///
| o_des`x'=="demostradora" | o_des`x'=="demostradoras" | o_des`x'=="meserao" ///
| o_des`x'=="autolavado" | o_des`x'=="lavandero" | o_des`x'=="lavandera" ///
| o_des`x'=="empacador" | o_des`x'=="shopper" | o_des`x'=="edecanes" ///
| o_des`x'=="camaristas" | o_des`x'=="lavaloza" | o_des`x'=="demostrador" ///
| o_des`x'=="demoedecan" | o_des`x'=="paquetero" | o_des`x'=="mensajeros" ///
| o_des`x'=="intendencia" | o_des`x'=="mostrador" | o_des`x'=="conductor" ///
| o_des`x'=="chhofer" | o_des`x'=="aydante" | o_des`x'=="empleada" ///
| o_des`x'=="shopping" | o_des`x'=="auxliar" | o_des`x'=="meserosas" ///
| o_des`x'=="demoedecanes" | o_des`x'=="boy" | o_des`x'=="boys" ///
| o_des`x'=="empleados" | o_des`x'=="empleado" | o_des`x'=="escolta" ///
| o_des`x'=="acomodador" | o_des`x'=="volanteo" | o_des`x'=="ama" ///
| o_des`x'=="domestica" | o_des`x'=="hostes" | o_des`x'=="repartido" & category==14

replace category=16 if o_des`x'=="operador" | o_des`x'=="extrusor" ///
| o_des`x'=="operadores" | o_des`x'=="lecturista" | o_des`x'=="operario" ///
| o_des`x'=="montacargas" | o_des`x'=="marinero" | o_des`x'=="montacarga" ///
| o_des`x'=="montacarguista" | o_des`x'=="impresor" | o_des`x'=="embarques" ///
| o_des`x'=="rotativa" | o_des`x'=="troquelador" | o_des`x'=="maquinista" ///
| o_des`x'=="operarios" | o_des`x'=="piloto" | o_des`x'=="trafico" ///
| o_des`x'=="embarcador" | o_des`x'=="maniobrista" | o_des`x'=="maniobristas" ///
| o_des`x'=="flexografia" | o_des`x'=="flexografista" & category==14

replace category=17 if o_des`x'=="seguridad" | o_des`x'=="vigilancia" ///
| o_des`x'=="cocinero" | o_des`x'=="vigilante" | o_des`x'=="preparador" ///
| o_des`x'=="cocinera" | o_des`x'=="vigilantes" | o_des`x'=="estilista" ///
| o_des`x'=="cocineros" | o_des`x'=="cantinero" | o_des`x'=="restaurante" ///
| o_des`x'=="repostero" | o_des`x'=="guardia" | o_des`x'=="taquero" ///
| o_des`x'=="cocineroa" | o_des`x'=="sushi" | o_des`x'=="respostero" ///
| o_des`x'=="accesos" | o_des`x'=="mayora" | o_des`x'=="guardia" ///
| o_des`x'=="pizzas" | o_des`x'=="guardias" | o_des`x'=="barista" ///
| o_des`x'=="bartender" | o_des`x'=="pizzeros" | o_des`x'=="parillero" ///
| o_des`x'=="panadero" | o_des`x'=="pastelero" | o_des`x'=="monitorista" ///
| o_des`x'=="monitoreo" | o_des`x'=="cocina" | o_des`x'=="restaurantes" ///
| o_des`x'=="bares" | o_des`x'=="velador" | o_des`x'=="officer" ///
| o_des`x'=="monitoristas" | o_des`x'=="vigilante" & category==14

replace category=16 if o_des`x'=="estructurista" | o_des`x'=="acero" ///
| o_des`x'=="soldador" | o_des`x'=="operaciones" | o_des`x'=="ensambladores" ///
| o_des`x'=="moldes" | o_des`x'=="tornero" | o_des`x'=="maquinados" ///
| o_des`x'=="matricero" | o_des`x'=="ensamblador" | o_des`x'=="ensamble" ///
| o_des`x'=="aluminio" | o_des`x'=="laminero" | o_des`x'=="planchador" ///
| o_des`x'=="infraestructura" | o_des`x'=="tubero" | o_des`x'=="soldadores" ///
| o_des`x'=="tuberos" | o_des`x'=="metalero" & category==14 

replace category=19 if o_des`x'=="jardinero" | o_des`x'=="jardineros" ///
| o_des`x'=="estilistas" | o_des`x'=="cosmetologa" | o_des`x'=="spa" ///
| o_des`x'=="manicurista" | o_des`x'=="estilistas" | o_des`x'=="esteticista" ///
| o_des`x'=="cosmeatra" | o_des`x'=="cosmetologas" | o_des`x'=="cosmetologa" ///
| o_des`x'=="unas" | o_des`x'=="ninera" | o_des`x'=="cuidar" ///
| o_des`x'=="cuidador" | o_des`x'=="cuidadora" | o_des`x'=="maquillista" ///
| o_des`x'=="visitador" & category==14 

replace category=18 if o_des`x'=="costurera" | o_des`x'=="foliador" ///
| o_des`x'=="obra" | o_des`x'=="fierrero" | o_des`x'=="techador" ///
| o_des`x'=="colocador" | o_des`x'=="costureras" | o_des`x'=="prensista" ///
| o_des`x'=="doblador" | o_des`x'=="punzonador" | o_des`x'=="pulidor" ///
| o_des`x'=="operativo" | o_des`x'=="construccion" | o_des`x'=="pintor" ///
| o_des`x'=="mezcladores" | o_des`x'=="costureros" | o_des`x'=="armador" ///
| o_des`x'=="albanil" | o_des`x'=="buzo" | o_des`x'=="buzos" ///
| o_des`x'=="sastre" | o_des`x'=="hojalatero" & category==14 
}

label define category 1 "Administrative/office" 2 "Art/design/media" 3 ///
"Scientific/research" 4 "IT/telecommunications" 5 "Management" 6 ///
"Economics/accounting" 7 "Education/university" 8 "Lodging/tourism" 9 ///
"Engineering/technical" 10 "Legal/consulting" 11 "Marketing/sales" 12 ///
"Medicine/health" 13 "Human resources" 14 "Other" 15 "Elementary" 16 ///
"Operators" 17 "Services" 18 "Craft" 19 "Personal/home care"
label values category category

moss o_des, match("([0-9]+)") regex
destring _match*, replace
gen wage=.
replace wage=_match1 if _match1>=4000 & _match1<=100000 & salary==.
replace wage=salary
rename binary_english eng
drop o_des* salary _match* _pos*

save "$data\JobAds.dta", replace

recode eng (0=2)
catplot eng category, percent(category) ///
graphregion(fcolor(white)) scheme(s2mono) ///
var1opts(label(labsize(small))) ///
var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Percent of job ads requiring English abilities", size(small)) ///
asyvars stack ///
legend(off)
graph export "$doc\occup_job_ads.png", replace
*========================================================================*
use "$data\JobAds.dta", clear
gen occup=.
*replace occup=1 if 
replace occup=2 if category==15 & state!=34
replace occup=3 if category==18 & state!=34
replace occup=4 if category==8 | category==17 | category==19 & state!=34
replace occup=5 if category==11 & state!=34
replace occup=6 if category==16 & state!=34
replace occup=7 if category==1 | category==13 & state!=34
replace occup=8 if category==5 & state!=34
replace occup=9 if state==34
replace occup=10 if category==2 | category==3 | category==4 | category==6 ///
| category==7 | category==9 | category==10 | category==12 & state!=34

label define occup 1 "Farming" 2 "Elementary occupations" 3 "Crafts" ///
4 "Services" 5 "Commerce" 6 "Machine operators" 7 "Clerical support" ///
8 "Managerial" 9 "Abroad" 10 "Professionals/Technicians"
label values occup occup

eststo clear
eststo english: quietly estpost tabstat eng, by(occup) nototal c(stat) stat(mean)
eststo wage: quietly estpost tabstat wage, by(occup) nototal c(stat) stat(mean)
esttab english wage english using "$doc\JobAds_occup.tex", ///
cells("mean(fmt(%9.2fc))") nonumber noobs label replace
tab occup
*========================================================================*
gen econ_act=.
replace econ_act=1 if (naics_4>=1110 & naics_4<=1199)
replace econ_act=2 if (naics_4>1199 & naics_4<=2399)
replace econ_act=3 if (naics_4>=8111 & naics_4<=8140)
replace econ_act=4 if (naics_4>3399 & naics_4<=4699)
replace econ_act=5 if (naics_4>=7111 & naics_4<=7225)
replace econ_act=6 if (naics_4>2399 & naics_4<=3399)
replace econ_act=7 if (naics_4>4699 & naics_4<=4931)
replace econ_act=8 if (naics_4>=5611 & naics_4<=5622)
replace econ_act=9 if (naics_4>=9311 & naics_4<=9399)
replace econ_act=10 if (naics_4>=5411 & naics_4<=5419) | (naics_4>=6111 & naics_4<=6299) ///
| naics_4==5510 // Includes Professional, Technical and Management
replace econ_act=11 if state==34
replace econ_act=12 if (naics_4>=5110 & naics_4<=5399) //Includes telecommunications, finance and real state

label define econ_act 1 "Agriculture" 2 "Construction" 3 "Other Services" ///
4 "Commerce" 5 "Hospitality and Entertainment" 6 "Manufactures" ///
7 "Transportation" 8 "Administrative" 9 "Government" ///
10 "Professional/Technical" 11 "Abroad" 12"Telecom/Finance"
label values econ_act econ_act

eststo clear
eststo english: quietly estpost tabstat eng, by(econ_act) nototal c(stat) stat(mean)
eststo wage: quietly estpost tabstat wage, by(econ_act) nototal c(stat) stat(mean)
esttab english wage english using "$doc\JobAds_ea.tex", ///
cells("mean(fmt(%9.2fc))") nonumber noobs label replace
tab econ_act
