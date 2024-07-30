# Netflix Movies and TV Shows Analysis

![Imagen del Proyecto](/src/1.netflix.png)

## Introducción
En este proyecto, trabajamos con el dataset de Netflix Movies and TV Shows de Kaggle. Nuestro objetivo es extraer, transformar y analizar los datos utilizando herramientas como SQL, Tableau y Python. Este README describe los procesos realizados con cada herramienta.

## Datos del Dataset
- **Dataset:** [Netflix Movies and TV Shows](https://www.kaggle.com/datasets/rahulvyasm/netflix-movies-and-tv-shows)
- **Descripción:** Este dataset contiene información sobre películas y programas de televisión disponibles en Netflix, incluyendo detalles como el tipo de contenido, título, director, reparto, país de origen, fecha de adición, año de lanzamiento, clasificación, duración, géneros y descripción.

## Problemas Iniciales y Soluciones

### Problemas Iniciales
Al intentar cargar el archivo CSV directamente en MySQL utilizando `LOAD DATA INFILE`, encontramos varios problemas:
- **Error de Decodificación:** El archivo contenía caracteres especiales que no podían ser decodificados correctamente con UTF-8.
- **Comas Adicionales:** Muchas filas del archivo CSV tenían comas adicionales al final, lo que causaba un desajuste entre el número de columnas y el número de valores en algunas filas.
- **Valores Nulos:** La presencia de valores nulos en el archivo CSV generó errores durante la inserción de datos en MySQL.

### Solución Utilizando Python
Para resolver estos problemas, utilizamos Python para inspeccionar y limpiar el archivo CSV antes de cargarlo en MySQL:
- **Paso 1: Inspección del Archivo:** Utilizamos la librería `csv` para leer las primeras filas del archivo y entender la estructura y los problemas de las comas adicionales.
- **Paso 2: Limpieza del Archivo:** Eliminamos las comas adicionales al final de cada fila y reemplazamos los valores nulos (`NaN`) por `None`.
- **Paso 3: Verificación:** Después de limpiar el archivo, lo cargamos en un DataFrame de `pandas` para asegurar que los problemas se hubieran resuelto correctamente.

## Herramientas Utilizadas

- **MySQL:** Para extracción y transformación de Datos.
- **Tableau:** Para la visualización de datos.
- **Python:** Para la análisis exploratorio de datos.

## Extracción y Transformación de Datos

### Parte 1: SQL

1. **Conexión y Exploración Inicial:**
    - Conectamos a una base de datos SQL (puede ser PostgreSQL, MySQL, SQLite, etc.) e importamos el dataset.
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


## Visualización

### Parte 2: Visualización con Tableau

**Dashboards:**
*   Creación de un dashboard interactivo que incluye:
    * Distribución de títulos por país.
    * Géneros más populares.
    * Evolución de la cantidad de títulos lanzados por año.

![Imagen del dashboard](/2.Dashboard.png)    

**Enlace:**
* El dashboard interactivo se puede visualizar en el siguiente enlace:
* [Netflix Movies and TV Shows Dashboard.](https://public.tableau.com/views/NetflixMoviesandTVShows_17223540631210/ResumenEjecutivo?:language=es-ES&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)


## Análisis Avanzado

### Parte 3: Análisis Avanzado con Python

**Nota:** Puedes elegir entre Python o R para esta parte del desafío. No es necesario ambos.

1. **Análisis de Duración:**
    - Determinar la distribución de la duración de los títulos (películas y series). Utilizar histogramas y box plots para visualizar la distribución.
    - **Python:**
      - (Aquí se detallará el código y análisis específico en Python, si se opta por esta opción.)


## Generación de Insights para el Negocio

### Parte 4: Insights y Recomendaciones

**Principales Hallazgos**
*   Principales Países Productores de Contenido: Estados Unidos, India y Reino Unido lideran la producción.
*   Géneros Más Populares: Drama, Comedia y Documentales son los géneros más comunes.
*   Tendencias Temporales: Crecimiento constante en la producción de títulos, con picos en ciertos años específicos.

**Recomendaciones Estratégicas**
*   Adquisición de Contenido: Invertir en producciones locales y contenido exclusivo.
*   Inversiones en Géneros: Enfocar en Dramas, Documentales y Series Limitadas.
*   Expansión Geográfica: Explorar mercados emergentes y formar colaboraciones internacionales.