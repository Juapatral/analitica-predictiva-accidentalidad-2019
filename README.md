# **Informe técnico de Analítica Predictiva** 
<font size = "4"> Posgrado en Ingeniería - Analítica

Universidad Nacional de Colombia, sede Medellín

11 de agosto de 2019
</font>

---

## **Título del informe**
<font size = "3">

### *Análisis y pronóstico de la información accidentalidad vehicular en el municipio de Medellín entre 2014 y 2018*

</font>

## **Descripción**
La materia de Analítica Predictiva en el Posgrado de Ingeniería - Analítica de la Universidad Nacional enseña algunas técnicas estadísticas del *Aprendizaje de Máquinas* [*Machine Learning*](https://en.wikipedia.org/wiki/Machine_learning) supervisado, no supervisado y reforzado, para el pronóstico (*forecast*), clasificación (*classification*) y agrupación (*clusters*) de datos, utilizando los conceptos de la estadística descriptiva y probabilística como cálculo de probabilidades, Teorema de Bayes, medidas de  tendencia, funciones de distribuciones de probabilidad, pruebas de hipótesis, entre otros. Algunos de los modelos vistos en clase fueron:

* K vecinos cercanos (*K-Nearest-Neighbors*)
* Regresión lineal (univariada y multivariada) 
* Regresión Ridge y Lasso (Casos de multicolinealidad de la regresión lineal)
* Regresión logística (*logit*)
* Árboles de decisión y regresión (*Decision Tree*)
* Bosques aleatorios (*Random Forest*)
* K medias (*K-means*)
* Agrupamiento jerárquico (*Hierarchical Clustering*)
* Máquinas de soporte vectorial (*SVM*)
* Redes neuronales (*Neural Network*)
* Validación cruzada (*Cross validation*)
* Muestreo Bootstrap (*Bootstrappin*)

El objetivo de este trabajo es entrenar un modelo predictivo que permita encontrar solución a un problema propuesto por los estudiantes.

Los entregables del trabajo son:

1. Código de ejecución del modelo. (disponible [aquí](https://juapatral.github.io/analitica-predictiva-accidentalidad-2019/app/accidentalidad-2014-2018.Rmd))
2. Reporte que contenga el entendimiento desarrollado en el trabajo, bibliografía de soporte y la metodología seguida debidamente justificada. (disponible [aquí](https://juapatral.github.io/analitica-predictiva-accidentalidad-2019/app/accidentalidad-2014-2018.html))
3. Aplicativo web que permita visualizar los datos y la predicción del modelo. (disponible [aquí](https://google.com.co))
4. Video promocional del aplicativo web, explicando su funcionalidad. (disponible [aquí](https://youtube.com)) 

## **Contexto del conjunto de datos**

Para este trabajo se decidió utilizar la información de la accidentalidad vehicular en el municipio de Medellín para los años 2014 a 2018, disponibles al público en general en [este enlace.](https://geomedellin-m-medellin.opendata.arcgis.com/datasets/accidentalidad-georreferenciada-2018)

El conjunto de datos se compone de los accidentes de tránsito registrados por la Secretaría de Movilidad de la Alcaldía de Medellín, entre los años especificados. Se entiende por accidente de tránsito: "evento, generalmente involuntario, generado al menos por un  un vehículo en movimiento, que causa daños a personas y bienes involucrados en él, e igualmente afecta la normal circulación de los vehículos que se movilizan por la vía o vías comprendidas en el lugar o dentro de la zona de influencia del hecho". (Ley 769 de 2002 - Código Nacional de Tránsito)

Los conjuntos de datos tienen variables descriptivas del accidente como:

+ Fecha y hora.
+ Ubicación exacta (coordenadas planas MAGNA Medellín, diferentes a las del sistema internacional `wgs84`).
+ Ubicación general (barrio, comuna y lote).
+ Tipo de accidente: choque, caída de pasajero, incendio, entre otros.
+ Gravedad del accidente: herido, muerto, entre otros. 

El objetivo propuesto es pronosticar la cantidad de accidentes para el año 2019 de acuerdo con su tipo de accidente.  

## **Metodología**

Para el desarrollo de este trabajo se utilizarán los softwares libres *R* y *R-Studio* y se seguirá la metodología [*CRISP-DM*](https://jdvelasq.github.io/ruta-n-predictiva/_downloads/5731da83c31e211e9b774ae8713246ed/CRISP-DM.pdf).

## **Resumen**

>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## **Contacto**

* Juan Camilo Agudelo Marín: juagudelom@unal.edu.co
* Lina María Grajales Vanegas: lgrajalesv@unal.edu.co
* Jhon Anderson Londoño Herrera: jalondonh@unal.edu.co
* Juan Pablo Trujillo Alviz: juanptrujilloalviz@gmail.com