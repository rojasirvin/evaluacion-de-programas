---
format:
  revealjs:
    title-slide-attributes:
      data-background-color: "#00573F"
      data-background-transition: "fade"
      class: portada
    slide-number: c/t
    width: 1600
    height: 900
    scrollable: false
    theme: [default, "./cide.scss"]
    logo: https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/122010/logo_cide_verde.png?itok=NUstTkpt
    title-slide: false
    includes:
      in-header:
        - fontawesome.html
---





# Errores estándar e inferencia {.portada}
<div style="text-align: center; font-size: 1.2em; font-weight: bold;">
  Inferencia Causal
</div>

<div style="text-align: center; margin-top: 1em;">
  <strong>Irvin Rojas</strong>  
  <br>
  <a href="https://rojasirvin.com" style="color: #ffffff;">rojasirvin.com</a>
</div>


<div style="text-align: center; margin-top: 1em;">
  <a href="https://github.com/rojasirvin" target="_blank" style="margin-right: 0 10px;">


    {{< bi github >}}



  </a>
  <a href="https://twitter.com/RojasIrvin" target="_blank" style="margin-right: 0 10px;">


    {{< bi twitter >}}



  </a>
  <a href="https://scholar.google.com/citations?user=FUwdSTMAAAAJ&hl=en" style="margin: 0 10px;">


    {{< bi google >}}



  </a>
</div>

**Centro de Investigación y Docencia Económicas**
División de Economía





::: {.cell}
<style type="text/css">
.huge .remark-code { /*Change made here*/
  font-size: 200% !important;
}
.tiny .remark-code { /*Change made here*/
  font-size: 60% !important;
}
</style>
:::





# Errores estándar no estándar {.inverse .center .middle}


# Errores estándar robustos

- Recordemos que con errores homocedásticos, la matriz de varianzas del estimador de MCO puede ser estimada como:

$$\hat{V}(\beta_{MCO}^H)=\hat{\sigma}^2(X'X)^{-1}$$
donde $\hat{\sigma}^2=\frac{1}{N-k}\hat{u}_i^2$ y $\hat{u}_i^2=(y_i-X_i'\hat{\beta}_{MCO})^2$

::: {.fragment}
- Una primera *desviación*  respecto a los errores clásicos ocurre cuando relajamos el supuesto de homocedasticidad
- En la [clase 3](https://eps-2021.netlify.app/clases/clase_5.html#20) estudiamos de manera general las propiedades asintóticas del estimador de MCO
- La varianza asintótica es:


$$V(\hat{\beta}_{MCO}^{R})=(X'X)^{-1}X'\Omega X(X'X)^{-1}$$
::::


# Errores robustos a la heterocedasticidad

- Un estimador de la varianza del estimador de MCO que no asume homocedasticidad es el estimador propuesto por White (1980)
- Sabemos que la matriz de varianzas del estimador de MCO robusta a la heterocedasticidad es:
$$\hat{V}(\beta_{MCO}^R)=(X'X)^{-1}\left(\sum_i\hat{u}_i^2x_ix_i'\right)(X'X)^{-1}$$
- [Aquí un recordatorio](http://mlwiki.org/index.php/Matrix-Matrix_Multiplication) de por qué podemos escribir $X'uu'X$ como una sumatoria
- Consideremos la *carnita* del sándwich
$$\sum_i\hat{u}_i^2x_ix_i \equiv \sum_i \hat{\psi}_i x_ix_i'$$



# Errores estándar robustos

- Dependiendo de cómo se especifique $\hat{\psi}_i$, obtenemos distintas versiones del estimador de varianzas robusto

- La propuesta de White original es:

$$HC0:\quad\hat{\psi}_i=\hat{u}_i^2$$

- Este estimador asintóticamente consistente

::: {.fragment}

- En muestras pequeñas, muchas veces se emplea la siguiente corrección:

$$HC1:\quad\hat{\psi}_i=\frac{N}{N-k}\hat{u}_i^2$$
:::

# Desviación a la influencia

- Un par de resultados nos ayudarán a entender qué hacen las otras correcciones a la matriz robusta en el software

- Definimos la **influencia** de la observación $i$ como:

$$h_{ii}=X_i'(X'X)^{-1}X_i$$

- $h_{ii}$ nos dice qué tanto *jala* la observación $i$ a la línea de regresión

- En una regresión con un solo regresor $x$, se puede mostrar que la influencia de la observación $i$ es:

$$h_{ii}=\frac{1}{N}+\frac{(x_i-\bar{x})^2}{\sum(x_j-\bar{x})^2}$$
es decir, que la influencia se incrementa cuando $x_i$ se aleja de la media

- La influencia es un número entre 0 y 1 y además $\sum_i h_{ii}=k$, siendo $k$ el número de regresores



# Errores estándar robustos

- Algunos autores sugieren usar la influencia en la matriz de varianzas robusta

- Se proponen algunas alternativas:

$$HC2:\quad\hat{\psi}_i=\frac{1}{1-h_{ii}}\hat{u}_i^2$$

$$HC3:\quad\hat{\psi}_i=\frac{1}{(1-h_{ii})^2}\hat{u}_i^2$$

::: {.fragment}
- Long & Ervin (2000) realizaron un experimento de simulación y recomendaron usar $HC3$ en muestras pequeñas, por lo que el paquete *sandwich* en R usa $HC3$ por default
- Es importante tener en cuenta qué tipo de errores estándar piden que el software calcule
:::


# Errores agrupados {.inverse .center .middle}


# Errores agrupados

- Surgen naturalmente cuando las observaciones están agrupadas

  - Niños en salones de clase
  - Hogares en localidades
  - Solicitudes de empleo en una empresa
  - Ahorradoras en un banco

- El supuesto de errores independientes claramente no se cumple

::: {.fragment}
- Pensemos en un problema simple para entender la intución:

$$y_{ig}=\beta_0+\beta_1 x_g+e_{ig}$$

- Aquí, $x_g$ es un regresor que es el mismo para todos los miembros del grupo $g$

- Asumamos que todos los grupos tienen tamaño $n$
:::


# Errores agrupados

- Podemos mostrar que la correlación de errores entre dos observaciones $i$ y $j$ que pertenecen a $g$ es $$E(e_{ig}e_{jg})=\overbrace{\rho_e}^{\substack{\text{coeficiente de correlación} \\ \text{intraclase residual}}} \underbrace{\sigma_e^2}_{\text{varianza residual}}$$

- Le damos una estructura aditiva a los errores:

$$e_{ig}=\nu_g+\eta_{ig}$$
donde $\nu_g$ captura toda la correlación dentro del grupo

- $\eta_{ig}$ es un error idiosincrático con media cero e independiente de cualquier otro $\eta_{jg}$

- Como queremos analizar el problema del agrupamiento, asumimos que tanto $v_g$ y $\eta_{ig}$ son homocedásticos




# Errores agrupados

- Con esta estructura de errores, el coeficiente de correlación intraclase es:

$$\rho_e=\frac{\sigma_{\nu}^2}{\sigma_{\nu}^2+\sigma_{\eta}^2}$$
- Deberíamos calcular la matriz de varianzas $V_C(\hat{\beta})$ tomando en cuenta esta estructura


::: {.fragment}

- ¿Qué pasa si hacemos MCO en el contexto de este problema?


- Moulton (1984) muestra que:

$$\frac{V_C(\hat{\beta})}{V_{MCO}(\hat{\beta})}=1+(n-1)\rho_e$$
- A $\sqrt{\frac{V_C(\hat{\beta})}{V_{MCO}(\hat{\beta})}}$ se le conoce como el *factor de Moulton*

:::

# Factor de Moulton

- El factor de Moulton nos dice qué tanto sobrestimamos la precisión al ignorar la correlación intra-clase

- Visto de otro modo:

$$V_C(\hat{\beta})=\left(1+(n-1)\rho_e\right)V_{MCO}(\hat{\beta})$$

- Es decir entre más grande sea la correlación dentro de los grupos, más deberíamos *inflar* los errores de MCO

::: {.fragment}

- Consideremos el caso extremo de que $\rho_e=1$, es decir, que todas las $y_{ig}$ dentro del mismo $g$ son iguales

- Entonces el factor de Moulton es simplemente $\sqrt{n}$

- Visto de otro modo, la matriz de varianzas correcta se obtendría multiplicando por $n$ la matriz $V_{MCO}(\hat{\beta})$

$$V_C(\hat{\beta})=n V_{MCO}(\hat{\beta})$$
:::

# Errores agrupados en general

- En general, $x_{ig}$ varía a nivel individual y tenemos grupos de tamaño $n_g$

- En este caso, el factor de Moulton es la raíz cuadrada de:

$$\frac{V_C(\hat{\beta})}{V_{MCO}(\hat{\beta})}=1+\left(\frac{V(n_g)}{\bar{n}}+\bar{n}-1\right)\rho_x\rho_e$$
donde $\bar{n}$ es el tamaño promedio del grupo y $\rho_x$ es la correlación intraclase de $x_{ig}$

- No es necesario asumir una forma para $\rho_x$ (se puede calcular)

::: {.fragment}

- Noten que el error que cometemos es más grande entre más heterogéneo es el tamaño de grupos y entre más grande es $\rho_x$

- Por tanto, cuando el tratamiento no varía entre grupos, este error es grande

:::

# Soluciones para errores agrupados

- Solución paramétrica: calcular directamente el factor de Moulton e inflar los errores de MCO

- Bootstrap por bloques: en vez de hacer muestras bootrstrap remuestreando individuos, se remuestrean grupos

- Estimar los errores agrupados (*clustered standard errors*)



# Errores estándar agrupados

- Con errores agrupados podemos escribir el estimador de MCO como

$$
\begin{aligned}
\hat{\beta}&=\beta+(X'X)^{-1}X'u \\
&=(X'X)^{-1}\left(\sum_{g=1}^G X_gu_g\right)
\end{aligned}
$$
- Suponiendo independencia entre $g$ y correlación dentro de cada grupo:

$$E(u_{ig}u_{jg'}|x_{ig}x_{jg'})=0$$
excepto cuando $g=g'$


- En este caso, el estimador de MCO tiene una varianza asintótica dada por

$$V({\hat{\beta}}_{MCO})=(X'X)^{-1}\left(\sum_{g=1}^G X_g'u_gu_g'X\right)(X'X)^{-1}$$


# Errores estándar agrupados

- Con errores heterocedásticos, pero sin agrupamiento, la matriz de varianzas de White (1980) tiene una estructura como sigue:

$$\hat{V}(\hat{\beta}_{R})=(X'X)^{-1}X'\hat{\Sigma} X (X'X)^{-1}$$

- Donde

$$\hat{\Sigma}=\left(\begin{matrix} \hat{u}_{1}^2 & 0  & 0  & \ldots & 0 \\ 0 & \hat{u}_{2}^2 & 0 & \ldots & 0 \\ \vdots & & & & \\ 0 & & &  \ldots & \hat{u}_{n}^2\end{matrix}\right)$$


# Errores estándar agrupados

- Para estimar la varianza con errores agrupados empleamos una generalización de la propuesta de White para errores robustos

- Si $G\to\infty$, el estimador de la matriz de errores agrupados robusta (CRVE) es consistente para estimar $V(\hat{\beta})$:

$$\hat{V}_{CR}(\hat{\beta})=(X'X)^{-1}\left(\sum_{g=1}^G X_g'\hat{u}_g\hat{u}_g'X_g\right)(X'X)^{-1}$$
donde $\hat{u}_g\hat{u}_g'$ es la matriz de varianzas para los individuos del grupo $g$

- De manera compacta

$$\hat{V}_{CR}(\hat{\beta})=(X'X)^{-1}X'\hat{\Sigma} X(X'X)^{-1}$$



# Errores estándar agrupados

- Y en este caso la matriz $\hat{\Sigma}$ tiene una estructura agrupada

$$\small \hat{\Sigma}=\left(\begin{matrix} \hat{u}_{1,1}^2 & \hat{u}_{1,1}\hat{u}_{2,1} & \ldots & \hat{u}_{1,1} \hat{u}_{n,1}& 0 & 0 & \ldots &  0 & \ldots & 0 & 0 & \ldots &  0 \\ \hat{u}_{2,1}\hat{u}_{1,1} & \hat{u}_{2,1}^2 & \ldots & \hat{u}_{2,1}\hat{u}_{n,1} & 0 & 0 & \ldots & 0 & \ldots  & 0 & 0 & \ldots &  0\\ 
\vdots & \vdots  & & \vdots & \vdots & \vdots  & &  \vdots& & \vdots & \vdots &  &  \vdots \\ \hat{u}_{n,1}\hat{u}_{1,1} & \hat{u}_{n,1}\hat{u}_{2,1}& \ldots & \hat{u}_{n,1}^2& 0 & 0 &\ldots & 0 & \ldots & 0 & 0 & \ldots &  0 \\  0 & 0 & \ldots &  0 & \hat{u}_{1,2}^2 & \hat{u}_{1,2}\hat{u}_{2,2} & \ldots & \hat{u}_{1,2}\hat{u}_{n,2} &\ldots & 0 & 0 & \ldots &  0  \\ 0 & 0 & \ldots &  0 & \hat{u}_{2,2}\hat{u}_{1,2} & \hat{u}_{2,2}^2 & \ldots & \hat{u}_{2,2}\hat{u}_{n,2} &\ldots & 0 & 0 & \ldots &  0 \\ \vdots & \vdots  & & \vdots & \vdots & \vdots  & &  \vdots& & \vdots & \vdots &  &  \vdots  \\ 0 & 0 & \ldots &  0 & \hat{u}_{n,2}\hat{u}_{1,2} & \hat{u}_{n,2}\hat{u}_{2,2} & \ldots & \hat{u}_{n,2}^2 &\ldots & 0 & 0 & \ldots &  0 \\ \vdots & \vdots  & & \vdots & \vdots & \vdots  & &  \vdots& & \vdots & \vdots &  &  \vdots \\ 0 & 0 & \ldots &  0 & 0 &  0 & \ldots & 0 &\ldots & \hat{u}_{1,G}^2 & \hat{u}_{12,G}\hat{u}_{2,G} & \ldots &  \hat{u}_{1,G}\hat{u}_{n,G} \\  0 & 0 & \ldots &  0 & 0 &  0 & \ldots & 0 &\ldots & \hat{u}_{2,G}\hat{u}_{1,G} & \hat{u}_{2,G}^2 & \ldots &  \hat{u}_{2,G}\hat{u}_{n,G} \\ \vdots & \vdots  & & \vdots & \vdots & \vdots  & &  \vdots& & \vdots & \vdots &  &  \vdots \\  0 & 0 & \ldots &  0 & 0 &  0 & \ldots & 0 &\ldots & \hat{u}_{n,G}\hat{u}_{1,G} & \hat{u}_{n,G}\hat{u}_{2,G} & \ldots &  \hat{u}_{n,G}^2 \end{matrix}\right)$$




# Errores estándar agrupados

- El resultado asintótico de consistencia depende de que $G\to\infty$

- Si $G$ está fijo, no importa qué tan grande sea $N$, $\hat{V}_{CRVE}(\hat{\beta})$ no será consistente

- Algunos paquetes ajustan esta matriz de varianzas haciendo una corrección parecida a $HC1$, pero ahora tomando en cuanta también $G$ y no solo $N$ (ver por ejemplo, *vcovCR* en R)

::: {.fragment}

- Con pocos grupos, subestimamos los errores estándar y rechazamos la $H_0$ más veces de lo que deberíamos (*over-rejection*)

- Si tenemos pocos grupos, recurrimos a otras soluciones (ver Cameron y Miller, 2015)
  - Inflar los errores con un corrector de sesgo
  - Bootstrap agrupado con refinamiento asintótico
  
- La recomendación práctica es que se tomen en serio el problema de los pocos clusters

- ¿Cuánto es poco? Cameron y Miller (2015) citan 50. (¡Qué raro, el número de estados en EUA!)

:::


# Bootstrap {.inverse .center .middle}



# Bootstrap

- A veces es difícil encontrar una expresión analítica de los errores estándar

- La idea de las técnicas bootstrap es consutrir una distribución empírica del estimador de interés

- Una muestra bootstrap es una muestra tomada de los mismos datos

::: {.fragment}

- En las rutinas para errores bootstrap, pensamos en $\{(y_1,x_1),\ldots,(y_N,X_n)\}$ como la población

- Una muestra bootstrap es una muestra de tamaño $N$ tomada de la muestra original

:::

::: {.fragment}
- El procedimiento bootstrap más usado es el bootstrap no paramétrico o bootstrap en parejas (nos enfocaremos en este tipo de bootstrap en el curso)

- La idea es remuestrear la pareja completa $(y_i,x_i)$

:::

# Algoritmo para errores estándar bootstrap

1. Dada una muestra $W_1,\ldots,W_N$, obtener una muestra de tamaño $N$, remuestreando de la muestra original **con reemplazo**

1. Calcular el estadístico $\hat{\theta}_b$ usado con la muestra bootstrap (coeficiente de regresión, diferencia de medias, función de coeficientes)

1. Repetir los pasos 1 y 2 $B$ veces, donde $B$ es lo suficientemente grande (usualmente 1000 es suficiente)

1. Usar las $B$ repeticiones para obtener el error estándar del estadístico como la raíz cuadrada de $s^2_{\hat{\theta},B}$:

$$s^2_{\hat{\theta},B}=\frac{1}{B-1}\sum_{b=1}^B(\hat{\theta}_{b}-\bar{\hat{\theta}})^2$$
donde $\bar{\hat{\theta}}=\frac{1}{B}\sum_{b=1}^B\hat{\theta}_b$



# ¿Cómo hacer remuestreo en R?

- Usaremos estos datos en las tareas. Veamos cómo luce una variable de gasto total en la muestra original:



::: {.cell}

```{.r .cell-code}
set.seed(927)

data.morocco<- read.csv("./crepon_morocco_analysis.csv")%>%
  select(treatment,client,expense_total )

obs <- nrow(data.morocco)
obs
```

::: {.cell-output .cell-output-stdout}

```
[1] 4934
```


:::

```{.r .cell-code}
#En la muestra original
mean(data.morocco$expense_total)
```

::: {.cell-output .cell-output-stdout}

```
[1] 23294.83
```


:::
:::




# ¿Cómo hacer remuestreo en R?

- Obtenemos una muestra bootstrap al obtener una muestra del tamaño original a partir de los datos originales, con remplazo:



::: {.cell}

```{.r .cell-code}
#Una muestra bootstrap
data.b <-data.morocco[sample(nrow(data.morocco),obs, replace = TRUE),]

mean(data.b$expense_total)
```

::: {.cell-output .cell-output-stdout}

```
[1] 24995.96
```


:::

```{.r .cell-code}
#Otra muestra bootstrap
data.b <-data.morocco[sample(nrow(data.morocco),obs, replace = TRUE),]

mean(data.b$expense_total)
```

::: {.cell-output .cell-output-stdout}

```
[1] 25587.57
```


:::
:::






# Aplicaciones comunes de bootstrap

- Métodos de varias etapas (por ejemplo, el estimador de dos etapas de Heckman)

- Funciones de estimadores (aunque aquí el método Delta también podría ser usado)

- Datos agrupados con pocos grupos

::: {.fragment}
- El consejo práctico es usar resultados teóricos cuando se puede (por ejemplo, las matrices robustas descritas antes)
- Pensemos siempre en la estructura de los datos antes de hacer bootstrap
- Usar una semilla siempre para poder reproducir sus resultados
:::


# Bootstrap salvaje

- En presencia de heterocedasticidad se prefiere usar bootstrap salvaje (*wild bootstrap*) ([MacKinnon, 2012](https://link.springer.com/chapter/10.1007%2F978-1-4614-1653-1_17#enumeration))

- Propuesto originalmente por Liu (1988), cada muestra bootstrap tiene la siguiente forma:

$$y_i^*=X_i\hat{\beta}+f(\hat{u}_i)v_i^*$$

- Noten que mantiene fijos los $X_i$ en cada muestra bootstrap

::: {.fragment}

- Una especificación comúnmente usada es hacer es $f(\hat{u}_i)=\hat{u}_i$ y 
$$v_i^*=\begin{cases} 1 \quad\text{con probabilidad 0.5} \\ -1 \quad\text{con probabilidad 0.5} \end{cases}$$

- $\hat{\beta}$ y $\hat{u}_i$ son estimados con la muestra original
:::


# Bootstrap salvaje

- En cada una de las $B$ muestras bootstrap, mantenemos a los mismos individuos (no hay remuestreo)

- Tendremos $B$ muestras bootstrap, pero ahora la aleatoriedad viene por $f(\hat{u}_i)v_i^*$

- Pueden usarse otras funciones más complicadas para $f(\hat{u}_i)$

- La ventaja de este método es que conserva la relación entre las varianzas residuales y las $X_i$ observadas en los datos originales

- [Davidson & Flachaire (2008)](https://www.sciencedirect.com/science/article/pii/S0304407608000833) utilizan simulaciones para mostrar que con esta forma para $f(\hat{u}_i)v_i^*$ la inferencia es más confiable que con otras especificaciones



# Refinamiento asintótico

- Una aplicación de las técnicas bootstrap es el *refinamiento asintótico* de la prueba $t$ de coeficientes de regresión

- Supongamos que $H_0:\quad \beta=0$ y trabajamos con un nivel $\alpha$ 

::: {.fragment}

- En cada repetición bootstrap el estadístico calculado es $t_b$

- Ordenamos los $B$ estadísticos obtenidos

- Rechazamos $H_0$ si $|t|$ está por encima del $(1-\alpha)$ésimo percentil de los $|t_b|$ en la distribución bootstrap

:::

::: {.fragment}

- A pesar de sus propiedades teóricas, el refinamiento asintótico es poco usado
:::


# Otras aplicaciones

- Bootstrap jacknife (útil para problemas con errores agrupados y pocos grupos)


#  {.inverse .center .middle}

Material de clase en versión preliminar.

**No reproducir, no distribuir, no citar.**



