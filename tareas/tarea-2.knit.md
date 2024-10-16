---
title: "Tarea 2"
lang: es
---

::: {.cell}

:::


# Preguntas

Fecha de entrega: **miércoles 2 de octubre a las 20:00**

La tarea deberá entregarse en Teams. Deberá incluir dos documentos:

Un primer documento de respuestas donde se incluyan las respuestas a las preguntas teóricas y conceptuales. Este documento debe estar en formato pdf y debe ser generado usando un software de procesamiento de textos científicos, por ejemplo, usando los leguajes LaTeX o Markdown. En este documento también se deben incluir las respuestas a preguntas sobre conclusiones que se desprenden de las secciones prácticas. Por ejemplo, si una pregunta pide obtener la media de la variable x en cierta base de datos, entonces el documento de respuestas debe incluir la pregunta y respuesta correspondiente: “la media de la variable x es 32.6”. En este documento también deberán incluirse las tablas y gráficas que se soliciten.

Un segundo archivo deberá contener el código replicable usado para generar los resultados de la sección práctica. El código debe también crear las tablas y gráficas solicitadas. Los archivos de código se verificarán para comprobar su replicabilidad.

## Datos

[crepon_morocco_balance.csv](../files/crepon_morocco_balance.csv)

[crepon_morocco_analysis.csv](../files/crepon_morocco_analysis.csv)

[STAR_public_use.csv](../files/STAR_public_use.csv)

## Pregunta 1

En esta pregunta usaremos un ejemplo de el estudio con asignación experimental de Banerjee et al. (2015)[^1] para fijar algunas ideas referentes al análisis de una intervención de este tipo. A diferencia de otros ejemplos vistos en clase, este es un experimento a gran escala. Por favor, utilice la versión publicada, así como el [material suplementario](https://www.science.org/doi/abs/10.1126/science.1260799).

a. [5 puntos] Describa brevemente en qué consiste la intervención que se discute en el artículo.

a. [5 puntos] Describa brevemente en qué consiste el diseño experimental, es decir, ¿cómo se construye la variación que permite identificar el efecto del tratamiento? ¿Cómo se construyen los grupos de tratamiento y control?

a. [5 puntos] En la página 1260799-7 se presenta una subsección denominada *Atrition*. Describa brevemente el propósito de este análisis y qué se concluye al respecto.

a. [5 puntos] En la página 1260799-7, la subsección *Compliance with treatment assignment* concluye que los efectos estimados en el artículo se refieren a un efecto de intención a tratar o *intent-to-treat* o *ITT*. ¿Por qué?

a. [5 puntos] En la página 1260799-8 se discuten dos métodos para tomar en cuenta la prueba de hipótesis múltiples. Describa brevemente por qué puede ser problemático probar múltiples hipótesis y cuáles son las dos formas en que los autores enfrentan este problema.

a. [5 puntos] En la página 1260799-12 se discute la posible presencia de efectos de derramamiento o *Spillovers*. Describa brevemente en qué consisten dichos efectos de derramamiento y cómo los autores muestran la presencia o ausencia de dichos efectos usando regresiones.


## Pregunta 2

En Crepon et al. (2015)[^2] se estudia una intervención en Marruecos en la que se analiza el efecto de la *adopción* de microfinanzas, a través de un experimento de campo. En 81 de 162 localidades estudiadas se introdujo aleatoriamente una empresa de microfinanzas. Para seleccionar las localidades de tratamiento, primero se *emparejaron* localidades de acuerdo a características observables y, para cada pareja se asignó a tratamiento y otra a control. La variable que identifica a las parejas es **paire**. La base de datos *crepon_morocco_balance.csv* contiene los datos de este estudio usados para mostrar la integridad del diseño. La variable **treatment** es la variable de asignación aleatoria, mientras que la variable **client** es la variable de adopción

a. [3 puntos] Primero recordaremos cómo mostrar que el tratamiento efectivamente fue asignado de manera aleatoria. El siguiente código lee los datos que debemos usar y se queda con las observaciones de la línea base. Con estos datos, mostraremos que la variable **members_resid_bl**, que indica el número de personas que viven en cada hogar está balanceado entre los grupos asignados a tratamiento y control. Noten que la media del número de personas que viven en el hogar en el grupo de control es 5.14 (d.e. 2.70) y que hay 2,266 hogares en dicho grupo de control. Esto es exactamente lo que se reporta en la fila correspondiente a *Number members* en la tabla 1 del artículo.


   ::: {.cell}
   
   ```{.r .cell-code}
   data.morocco<-read_csv("../files/crepon_morocco_balance.csv",
                          locale = locale(encoding = "latin1")) %>% 
     clean_names() %>% 
     filter(merge_indicator!=1)
       
   data.morocco %>% 
     group_by(treatment) %>%
     summarize(mean=mean(members_resid_bl, na.rm=T),
               std=sd(members_resid_bl, na.rm=T),
               n=n()) %>% 
     ungroup()
   ```
   
   ::: {.cell-output .cell-output-stdout}
   
   ```
   # A tibble: 2 × 4
     treatment  mean   std     n
         <dbl> <dbl> <dbl> <int>
   1         0  5.14  2.69  2266
   2         1  5.19  2.76  2199
   ```
   
   
   :::
   :::


   Obtenga ahora el valor de la diferencia entre el grupo de tratamiento y el de control, así como su valor $p$ (últimas dos columnas). Para ello, estime una regresión en la que la variable dependiente sea número de personas que vive en el hogar **members_resid_bl**, en función de la variable de asignación **treatment** y variables dummy de pareja de localidad (la variable **paire** indica cuáles son las parejas). La regresión permite recuperar la diferencia de 0.04 personas que se reporta en la fila correspondiente en la tabla 1. Para recuperar el valor $p$, estime errores agrupados usando la variable **demi_paire**, que es la clave de las distintas localidades, como variable de agrupación. Una forma de realizar esto es con la función *coef_test* del paquete *clubSandwich*.[^3]

a. [2 puntos] Ahora mostremos que efectivamente este es un ejemplo de una intervención con cumplimiento imperfecto. Genere un cuadro que indique: 1) cuántas personas que fueron asignadas a recibir el tratamiento efectivamente fueron clientes; 2) cuántas personas que fueron asignadas a recibir el tratamiento no se convirtieron en clientes; 3) cuántas personas que no fueron asignadas a recibir el tratamiento sí se convirtieron en clientes; y 4) cuántas personas que no fueron asignadas a recibir el tratamiento tampoco se convirtieron en clientes.

a. [5 puntos] Ahora mostraremos que la adopción, es decir, convertirse en cliente, no es independiente de las características de los hogares. Considere las variables **members_resid_bl** y **act_number_bl**, que indican el número de miembros del hogar y el número de actividades económicas del hogar. Para cada una de estas dos variables, utilice la misma especificación que en la parte a., pero ahora usando la variable **cliente** como regresor. ¿Qué concluye?

a. [5 puntos] Con estos elementos estamos convencidos de que es necesario emplear lo que sabemos sobre cumplimiento imperfecto. Usaremos ahora los datos en *crepon_morocco_analysis.csv*, que contiene los datos empleados para evaluar el impacto de la adopción. Estos datos están listos para analizarse. Estime la forma reducida del efecto de ser asignado al tratamiento sobre gasto total, **expense_total**. Comente los resultados, en particular, comente sobre la magnitud y la significancia estadística de la variable **treatment**. Aquí y en adelante, incluya los siguientes controles en la regresión: **members_resid_bl**, **nadults_resid_bl**, **head_age_bl**, **act_livestock_bl**, **act_business_bl**, **borrowed_total_bl**, **members_resid_d_bl**, **nadults_resid_d_bl**, **head_age_d_bl**, **act_livestock_d_bl**, **act_business_d_bl**, **borrowed_total_d_bl**, **ccm_resp_activ**, **other_resp_activ**, **ccm_resp_activ_d** y **other_resp_activ_d**. Además, incluya efectos fijos por pareja introduciendo la variable **paire** como factor. Use los mismos errores estándar que en la parte a. Con esto deberá poder recuperar el coeficiente y el error estándar de la columna (3) de la tabla 3.

a. [5 puntos] Estime ahora la **primera etapa**, es decir, estime por MCO el efecto causal de la asignación sobre la adopción. Comente sobre la magnitud, la significancia estadística y la interpretación de la variable **treatment** en términos del comportamiento de los **cumplidores**. Debería poder replicar el coeficiente y el error estándar de la columna 1 en la tabla 2 del artículo.

a. [5 puntos] Considere la columna 3 del panel A en la Tabla 9 del artículo. Aquí se reporta la estimación por MCO de la relación entre **client** y gasto total, con los mismos controles y tipo de errores que antes. Replique este resultado. ¿Se puede interpretar de forma causal el coeficiente sobre **client**?

a.	[5 puntos] ¿Cuáles son los dos supuestos econométricos que permiten la estimación del Local Average Treatment Effect (LATE) en el contexto de este problema? Comente sobre la evidencia que respalda el supuesto de que los instrumentos no son débiles en este problema.

a.	[5 puntos] Estime el efecto del cumplimiento sobre el gasto total, usando la asignación aleatoria como instrumento del cumplimiento. Es decir, estime el LATE. Use los mismos controles y tipo de errores que en c. Este resultado se reporta en la columna 3 del panel B en la Tabla 9. ¿Cuál es la interpretación del coeficiente de la variable **client**? En R, la función *ivreg* del paquete *AER* le permite hacer la estimación de MC2E.

## Pregunta 3

Sea una variable de resultados $y_i$, una variable de asignación aleatoria $Z_i$ y una variable de adopción $D_i$. El estimador de Wald se define como:

   $$\hat{\beta}_{Wald}=\frac{\bar{Y}_{Z_i=1}-\bar{Y}_{Z_i=0}}{\bar{D}_{Z_i=1}-\bar{D}_{Z_i=0}}$$

   En esta pregunta mostraremos cómo el estimador de Wald es equivalente al estimador de VI cuando no hay controles. Use nuevamente los datos en *crepon_morocco_analysis.csv*.
   
a. [5 puntos] Obtenga el estimador de Wald como el cociente de la diferencia en gasto total promedio entre los hogares asignados a tratamiento y control dividido por la diferencia en la probabilidad de adopción entre los hogares asignados a tratamiento y control. Recuerde que la variable del gasto total es **expense_total**.

a. [5 puntos] Ahora estime por MC2E el efecto de la adopción sobre el gasto total, usando la variable de asignación como instrumento para la adopción. ¿Qué ventaja observa con respecto al estimador de Wald?


## Pregunta 4

Considere nuevamente la base *STAR_public_use.csv* usada en la Tarea 1 del artículo Angrist, Lang y Oreopoulos (2009)[^4]. En esta pregunta nos concentraremos en los efectos de la intervención en el año 2, mostrados en la columna (4) de la Tabla 6, sobre dos variables, el promedio de calificaciones **gpa_year2** y los créditos completados **credits_earned2**.

El propósito de esta pregunta es mostrar la función de los $z$-scores en el análisis de efectos de tratamiento. De nuevo, puede quedarse solo con las observaciones que tienen **noshow** igual a 0. Antes de comenzar su análisis, sustituya por NA los valores en **credits_earned2** para aquellas observaciones que tienen $NA$ en la variable **prob_year1**.

a. [5 puntos] Para tener un punto de comparación, estime la ecuación del efecto de tratamiento para **gpa_year2** usando la misma especificación que en la pregunta 5 de la Tarea 1. Use también errores robustos. Deberá poder replicar los coeficientes y errores estándar del panel A, columna (4). ¿Cómo se interpretan el coeficiente sobre la variable **ssp**?

a. [5 puntos] Genere un $z$-score para la variable **gpa_year2** al que llame **gpa_year2_sd**. Para ello, calcule la media y desviación estándar de **gpa_year2** para el grupo de control y luego genere **gpa_year2_sd** restándole a **gpa_year2** la media obtenida y dividiendo esta diferencia por la desviación estándar obtenida. Compruebe que si calcula la media y la desviación estándar de **gpa_year2_sd**, en el grupo de control estas deberían ser 0 y 1, respectivamente.

a. [5 puntos] Realice la misma estimación que en la parte a., pero ahora use como variable dependiente **gpa_year2_sd**. ¿Cómo se interpreta el coeficiente sobre **ssp**? ¿Qué es diferente y qué es igual entre los resultados obtenidos en esta parte y los obtenidos en la parte a.?

a. [5 puntos] Ahora realizaremos un índice de mejora en educación, al agregar los resultados de estos dos indicadores en una sola variable, como se describe en Banerjee et al. (2015)[^1]. Para ello, primero genere **credits_earned2_sd**, que será la versión estandarizada de **credits_earned2**, siguiendo el mismo procedimiento que en la parte b. En seguida, genere una nueva variable llamada **indice_escolar**, que será el promedio de **credits_earned2_sd** y **gpa_year2_sd**. Luego, calcule la media y la desviación estándar de **indice_escolar** en el grupo de control. Finalmente, genere una nueva variable **indice_escolar_sd** restándole a **indice_escolar** la media antes calculada y dividiendo esta diferencia por la desviación estándar antes calculada. Muestre que la variable **indice_escolar_sd** tiene media 0 y desviación estándar 1 en el grupo de control.

a. [5 puntos] Estime ahora el efecto de tratamiento sobre **indice_escolar_sd**, siguiendo la misma especificación econométrica que en la parte a. y usando errores robustos. ¿Qué concluye?

[^1]: Banerjee, A. et al. (2015). A multifaceted program causes lasting progress for the very poor: Evidence from six countries. *Science*, 348(6236).

[^2]: Por ejemplo, suponga que estima un modelo al que llame *modelo1*. Entonces, si ejecuta


    ::: {.cell}
    
    ```{.r .cell-code}
    coef_test(modelo1,
              vcov="CR1S",
              cluster=mis_datos$demi_paire)[1:2,]
    ```
    :::


    obtendrá los coeficientes con los errores agrupados requeridos. La opción *CR1S* toma en cuenta el número de grupos o *clusters* para realizar inferencia. Puede leer más al respecto en la ayuda al ejecutar *?vcovCR*. Este es el tipo de ajuste de muestras finitas que usan los autores. Esta corrección consiste en multiplicar la matriz de sándwich agrupada CR0 por $\frac{G(N-1)}{(G-1)(N-p)}$, donde $G$ es el número de grupos, $N$ es el número total de observaciones y $p$ es el número de regresores.

[^3]: Crépon, B., Devoto, F., Duflo, E., & Parienté, W. (2015). Estimating the impact of microcredit on those who take it up: Evidence from a randomized experiment in Morocco. *American Economic Journal: Applied Economics*, 7(1), 123-50.

[^4]: Angrist, J., Lang, D., y Oreopoulos, P. (2009). Incentives and services for college achievement: Evidence from a randomized trial. *American Economic Journal: Applied Economics*, 1(1), 136-63.


