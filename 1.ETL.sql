# Parte 1

-- Previamente se eliminaron las columnas vacías y se modificó encoding a UFT-8. El dataset se guardó como 'netflix_titles_cleaned', 
-- SELECT @@global.secure_file_priv; -- Para ver la ruta de origen donde guardar el .csv

-- Verificar que esté activada en ON la variable local_infile, caso contrario setearla = 1.
-- SHOW VARIABLES LIKE 'local_infile';
-- SET GLOBAL local_infile = 1;
# ----------------------------------------------------------------------------------------------------------------------------------------

# 1) Conexión y Exploración Inicial:
-- Creación de nuevo database y tabla.

CREATE DATABASE netflix;
USE netflix;

DROP TABLE IF EXISTS netflix;

CREATE TABLE IF NOT EXISTS netflix (
    show_id VARCHAR(255),
    type_ text,
    title VARCHAR(255),
    director VARCHAR(255),
    cast TEXT,
    country VARCHAR(255),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(50),
    duration VARCHAR(50),
    listed_in TEXT,
    description_ TEXT)
    ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

# Carga de datos.
-- Importar los datos desde el archivo CSV guardado.

LOAD DATA LOCAL INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\netflix_titles_cleaned.csv' -- modificar ruta según corresponda
INTO TABLE netflix 
CHARACTER SET utf8mb4 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
ESCAPED BY '\\' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(show_id, type_, title, director, cast, country, date_added, release_year, rating, duration, listed_in, description_);

# Verificamos estructura de la tabla
-- Columnas y su tipo de dato
describe netflix; -- El campo duration aloja información en formato texto, y será necesario transformarlo para realizar cálculos estadísticos. 

-- Visualización de las primeras filas
select * from netflix limit 10; -- No se encuentran columnan redundantes

-- Cantidad de filas
select count(*) from netflix; -- 8809 

-- Contabilizamos la cantidad de nulos por columna
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN type_ IS NULL THEN 1 ELSE 0 END) AS type_nulls,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_nulls,
    SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS director_nulls,
    SUM(CASE WHEN cast IS NULL THEN 1 ELSE 0 END) AS cast_nulls,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
    SUM(CASE WHEN date_added IS NULL THEN 1 ELSE 0 END) AS date_added_nulls,
    SUM(CASE WHEN release_year IS NULL THEN 1 ELSE 0 END) AS release_year_nulls,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS rating_nulls,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_nulls,
    SUM(CASE WHEN listed_in IS NULL THEN 1 ELSE 0 END) AS listed_in_nulls,
    SUM(CASE WHEN description_ IS NULL THEN 1 ELSE 0 END) AS description_nulls
FROM netflix;
-- La columna con mayor cantidad de nulos es "director" con 2634 registros vacíos de un total de 8809.
-- Columnas importantes para el análisis exploratorio como title, type y release_year, no presentan registros nulos.


# ----------------------------------------------------------------------------------------------------------------------------------------

# 2) Consultas Específicas:

-- Top 10 países con más títulos en Netflix:
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
LIMIT 10; -- Se filtran los registros con país nulo para el top 10. 

-- Top 10 de países con columna de porcentaje
SELECT 
    country,
    COUNT(*) AS Cantidad_titulos,
    COUNT(*) / (SELECT 
            COUNT(*) AS total
        FROM
            netflix) AS Porcentaje
FROM
    netflix
WHERE
    country IS NOT NULL
GROUP BY country
ORDER BY Cantidad_titulos DESC
LIMIT 10; -- USA es el país con mayor cantidad de títulos, aportando practicamente un tercio del total. 


-- Géneros más populares:
SELECT 
    listed_in AS genre, COUNT(*) AS Cantidad_titulos
FROM
    netflix
GROUP BY listed_in
ORDER BY Cantidad_titulos DESC; -- Se contabilizan por los nombres completos, habría que abrir la descripción para un análisis correcto. 

-- Separación de generos 

-- Separar los géneros y contar la cantidad de títulos para cada uno.
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

    
-- Cantidad de títulos lanzados por año:    
SELECT 
    release_year, 
    COUNT(*) AS Cantidad_titulos
FROM 
    netflix
GROUP BY 
    release_year
ORDER BY 
    release_year DESC; -- Luego del 2021 no hay registros, a excepción de un título del 2024.

-- Buscar la única serie de 2024    
select * from netflix where release_year = 2024; -- Parasyte: The Grey    