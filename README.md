# Netflix Movies and TV Shows Analysis

![Imagen del Proyecto](/src/1.netflix.png)

## Introducción
En este proyecto, trabajamos con el dataset de Netflix Movies and TV Shows de Kaggle. Nuestro objetivo es extraer, transformar y analizar los datos utilizando las herramientas MySQL, Tableau y Python. Este documento describe los procesos realizados en cada etapa.

## Datos del Dataset
- **Dataset:** [Netflix Movies and TV Shows](https://www.kaggle.com/datasets/rahulvyasm/netflix-movies-and-tv-shows)
- **Descripción:** Este dataset contiene información sobre películas y programas de televisión disponibles en Netflix, incluyendo detalles como el tipo de contenido, título, director, reparto, país de origen, año de lanzamiento, clasificación, duración, géneros y descripción.

## Problemas iniciales y soluciones

### Inconveniente
Al intentar cargar el archivo CSV directamente en MySQL utilizando `LOAD DATA INFILE`, encontramos varios problemas:
- **Error de Decodificación:** El archivo contenía caracteres especiales que no podían ser decodificados correctamente con UTF-8.
- **Comas Adicionales:** El archivo CSV contenía muchas columnas comas adicionales al final, lo que causaba un desajuste entre el número de columnas y el número de valores en algunas filas.
- **Valores Nulos:** La presencia de valores nulos en el archivo CSV generó errores durante la inserción de datos en MySQL.

### Solución Utilizando Python
Para resolver estos problemas, utilizamos Python para inspeccionar y limpiar el archivo CSV antes de hacer la carga en MySQL:
- **Paso 1: Inspección del Archivo:** Utilizamos la librería `csv` para leer las primeras filas del archivo y entender la estructura y los problemas de las comas adicionales.
- **Paso 2: Limpieza del Archivo:** Eliminamos las comas adicionales al final de cada fila y reemplazamos los valores nulos (`NaN`) por `None`.
- **Paso 3: Verificación:** Después de limpiar el archivo, lo cargamos en un DataFrame de `pandas` para asegurar que los problemas se hubieran resuelto correctamente.

## Herramientas Utilizadas

- **MySQL:** Para extracción y transformación de Datos.
- **Tableau:** Para la visualización de datos.
- **Python:** Para la análisis exploratorio de datos.

## Parte 1: Extracción y Transformación de Datos

### SQL

1. **Conexión y Exploración Inicial:**
    - Conectamos a una base de datos SQL (MySQL Workbench) e importamos el dataset.
    - Exploramos la estructura del dataset y proporcionamos una descripción de la tabla y las columnas disponibles.

2. **Consultas Específicas:**
    - **Top 10 países con más títulos en Netflix:**
    ```sql
    SELECT 
        country, 
        COUNT(*) AS Cantidad_titulos
    FROM 
        netflix
    WHERE 
        country IS NOT NULL
    GROUP BY 
        country
    ORDER BY 
        Cantidad_titulos DESC
    LIMIT 10;
    ```
    ![Top 10 países con más títulos en Netflix](/src/sql1.PNG)

    - **Géneros más populares:**
    ```sql
    SELECT 
        listed_in, 
        COUNT(*) AS Cantidad_titulos
    FROM 
        netflix
    WHERE 
        listed_in IS NOT NULL
    GROUP BY 
        listed_in
    ORDER BY 
        Cantidad_titulos DESC;
    ```
    ![Géneros más populares](/src/sql2.PNG)

    ```sql
    SELECT
        genre,
        COUNT(*) AS Cantidad_titulos
    FROM (
        -- Descomponer los géneros en filas individuales
            SELECT
                TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(listed_in, ',', numbers.n), ',', -1)) AS genre
            FROM
                netflix
            JOIN (
                SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
                UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8
                UNION ALL SELECT 9 UNION ALL SELECT 10
            ) numbers
            ON CHAR_LENGTH(listed_in) - CHAR_LENGTH(REPLACE(listed_in, ',', '')) >= numbers.n - 1
            WHERE listed_in IS NOT NULL
        ) AS genres
    GROUP BY genre
    ORDER BY Cantidad_titulos DESC;
    ```
    ![Géneros más populares](/src/sql2_2.PNG)

    - **Cantidad de títulos lanzados por año:**
    ```sql
    SELECT 
        release_year, 
        COUNT(*) AS Cantidad_titulos
    FROM 
        netflix
    GROUP BY 
        release_year
    ORDER BY 
        release_year DESC;
    ```
    ![Cantidad de títulos lanzados por año](/src/sql3.PNG)


## Parte 2: Visualización

### Tableau

**Dashboards:**
Se elaboró un dashboard interactivo en Tableau Public que incluye:

* Distribución de títulos por país.
* Géneros más populares.
* Evolución de la cantidad de títulos lanzados por año.

![Imagen del dashboard](/src/2.Dashboard.png)    

**Enlace:**
* El tablero se puede visualizar en el siguiente enlace:
* [Netflix Movies and TV Shows Dashboard.](https://public.tableau.com/views/NetflixMoviesandTVShows_17223540631210/ResumenEjecutivo?:language=es-ES&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)


## Parte 3: Análisis Avanzado

### Python

Se realiza un análisis exploratorio, buscando identificar patrones/tendencias en los datos, y se calculan las estadísticas principales de sus variables.

1. **Análisis de Duración:**
    - Se determina la distribución de la duración de los títulos (películas y series). Para dicho fin se utilizan histogramas y box plots para visualizarlos.
2. **Análisis de Tendencias:**
    - Se identifican tendencias en el tiempo, en relación a la cantidad de títulos en función de los años. Se utilizan gráficos de línea y acumulados para visualizar la progresión en cada caso.  
3. **Análisis Adicionales:**
    - Se exploran diferentes aspectos de los campos y sus valores, para obtener *Insights* significativos. 


![Imagen del world](/src/output1.png)  

## Parte 4: Generación de Insights para el Negocio

###  Documento PDF 

Se elabora un resumen ejecutivo con los Insights encontrados durante el proceso de análisis, y se presentan recomendaciones en base a las conclusiones parciales obtenidas. 

**Principales Hallazgos**
*   Principales Países Productores de Contenido: Estados Unidos, India y Reino Unido lideran la producción.
*   Géneros Más Populares: Drama, Comedia y Documentales son los géneros más comunes.
*   Tendencias Temporales: Crecimiento constante en la producción de títulos, con picos en ciertos años específicos.

**Recomendaciones Estratégicas**
*   Adquisición de Contenido: Invertir en producciones locales y contenido exclusivo.
*   Inversiones en Géneros: Enfocar en Dramas, Documentales y Series Limitadas.
*   Expansión Geográfica: Explorar mercados emergentes y formar colaboraciones internacionales.