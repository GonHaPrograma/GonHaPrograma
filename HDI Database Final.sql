--HDI Record DataBase by Gonzalo Luis Romero.
/*Base de Datos sobre los paises que ocuparon el TOP 10 en terminos de IDH en el año 2017
y su situación en los años siguientes hasta 2021
El código se estructura primero DDL y luego DML, además se escribieron
comentado en Ingles y Español para una mejor comprención de las funcionalidades presentadas
Database on the countries that occupied the TOP 10 in terms of HDI in the year 2017
and its situation in the following years until 2021
The code is structured first DDL and then DML, in addition they were written
commented in English and Spanish for a better understanding of the functionalities presented*/

CREATE TABLE IDHRecord (
   country VARCHAR(100) PRIMARY KEY,
   idh_2017 DECIMAL,
   idh_2018 DECIMAL,
   idh_2019 DECIMAL,
   idh2020 DECIMAL,
   idh2021 DECIMAL,
   idh2022 DECIMAL,
   idh2023 DECIMAL
);

CREATE TABLE Changes (
   country VARCHAR(100) PRIMARY KEY,
   change DECIMAL
);

/*Alteracion de la tabla original eliminando 2 columnas innecesarias
Alteration of table taking out 2 unnecesary rows*/
ALTER TABLE IDHRecord
DROP COLUMN idh2022,
DROP COLUMN idh2023;

/*Ingreso de datos a tabla IDHRecord
Data entry to table IDHRecord*/
INSERT INTO IDHRecord (country, idh_2017, idh_2018, idh_2019, idh2020, idh2021)
VALUES ('Norway', 0.959, 0.962, 0.961, 0.959, 0.961),
       ('Switzerland', 0.957, 0.959, 0.962, 0.956, 0.962),
	   ('Iceland', 0.954, 0.959, 0.960, 0.957, 0.959),
	   ('Germany', 0.944, 0.945, 0.948, 0.944, 0.942),
	   ('Denmark', 0.944, 0.942, 0.946, 0.947, 0.948),
	   ('Hong Kong', 0.944, 0.949, 0.952, 0.949, 0.952),
	   ('Sweden', 0.941, 0.942, 0.947, 0.942, 0.947),
	   ('Australia', 0.937, 0.941, NULL, 0.947, 0.951),
	   ('Netherlands', 0.937, 0.939,0.943, 0.939, 0.941),
	   ('New Zealand', 0.935, NULL, 0.962, 0.956, 0.962)
       
;

/*Consulta Tabla IDHRecord
Query IDHRecord Table*/
SELECT*FROM IDHRecord

/*Consulta para conocer el crecimiento del IDH de cada país de la lista Top 10 original del 2017 
Devuelve una lista de los paises que más han crecido en terminos de IDH  desde el 2017 al 2021
Query to know the growth of the HDI of each country of the original Top 10 list of 2017
Returns a list of the countries that have grown the most in terms of HDI from 2017 to 2021*/
SELECT
    country,
    (idh2021 - idh_2017) AS idh_growth
FROM IDHRecord
ORDER BY idh_growth DESC;

/*Similar a la anterior pero limitando a los 3 primeros puestos, se puede módificar para devolver la cantidad que se requiera cambiando el número luego de LIMIT
Similar to the previous one but limited to the first 3 positions, it can be modified to return the amount that is required by changing the number after LIMIT*/
SELECT
    country,
    (idh2021 - idh_2017) AS idh_growth
FROM IDHRecord
ORDER BY idh_growth DESC
LIMIT 3;

/*En esta consulta realizamos una modificacion para reemplazar los valores "Null" por "Fuera del Top", mejorando la presentación de la tabla.
In this query we make a modification to replace the "Null" values with "Out of Top", improving the presentation of the table.*/
SELECT
    country,
    COALESCE(CAST(idh_2017 AS VARCHAR), 'Fuera del Top') AS idh_2017,
    COALESCE(CAST(idh_2018 AS VARCHAR), 'Fuera del Top') AS idh_2018,
    COALESCE(CAST(idh_2019 AS VARCHAR), 'Fuera del Top') AS idh_2019,
    COALESCE(CAST(idh2020 AS VARCHAR), 'Fuera del Top') AS idh2020,
    COALESCE(CAST(idh2021 AS VARCHAR), 'Fuera del Top') AS idh2021
FROM IDHRecord;

/*Esta consulta mide la diferencia entre los IDH de cada país entre los años 2018 y 2020. El objetivo es conocer como se modifico durante la pandemia Covid-19.
This query measures the difference between the HDI of each country between the years 2018 and 2020. The objective is to know how it changed during the Covid-19 pandemic.*/
SELECT
    country,
    (idh2020 - idh_2018) AS idh_change_2018_to_2020
FROM IDHRecord
ORDER BY idh_change_2018_to_2020 DESC;

/*En esta consulta conocemos el porcentaje de crecimiento de cada país desde el 2017 al 2021.
In this query we know the growth percentage of each country from 2017 to 2021.*/
SELECT
    country,
    ROUND(
        CASE
            WHEN idh2021 IS NOT NULL AND idh_2017 IS NOT NULL AND idh_2017 <> 0 
                THEN ((idh2021 - idh_2017) / idh_2017) * 100
            ELSE NULL
        END, 2
    ) AS growth_percentage
FROM IDHRecord;

/*Esta consulta permite saber el porcentaje de crecimiento de los paises de la lista con la posibilidad de elegir entre que años realizar el calculo.
Para seleccionar entre que años calcular simplemente cambia los valores de year_start y year_end en la subconsulta Parametros.
This query allows you to know the growth percentage of the countries on the list with the possibility of choosing between which years to perform the calculation.
To select between which years to calculate simply change the values of year_start and year_end in the subquery Parameters.*/
WITH Parametros AS (
    SELECT
        2017 AS year_start,
        2020 AS year_end
)
SELECT
    country,
    ROUND(
        CASE
            WHEN idh2021 IS NOT NULL AND idh_2017 IS NOT NULL AND idh_2017 <> 0 
                THEN ((idh2021 - idh_2017) / idh_2017) * 100
            ELSE NULL
        END, 2
    ) AS growth_percentage
FROM IDHRecord
CROSS JOIN Parametros
ORDER BY growth_percentage DESC;

/*Esta consulta permite calcular la variacion absoluta entre 2017 y 2021 para cada país.
Devuelve el país que menos haya fluctuado en terminos de IDH desde 2017 hasta 2021.
Eliminando el LIMIT podemos obtener los resultados de todos los paises de la lista.
This query allows us to calculate the absolute variation between 2017 and 2021 for each country.
Returns the country that has fluctuated the least in terms of HDI from 2017 to 2021.
Eliminating the LIMIT we can obtain the results of all the countries of the list.*/
SELECT
    country,
    ABS(idh2021 - idh_2017) AS idh_fluctuation
FROM IDHRecord
ORDER BY idh_fluctuation ASC
LIMIT 1;

/*Similar a la consulta anterior, pero devuelve la lista completa de paises ordenados desde el que menos fluctuo, al que más.
Similar to the previous query, but it returns the complete list of countries ordered from the one that fluctuated the least, to the one that fluctuated the most.*/
SELECT
    country,
    ABS(idh2021 - idh_2017) AS idh_fluctuation
FROM IDHRecord
ORDER BY idh_fluctuation ASC;

/*Esta consulta nos permite sacar la tasa de crecimiento anual de los paises de la lista
This query allows us to extract the annual growth rate of the countries in the list*/
SELECT
    country,
    year,
    idh,
    ROUND(
        (idh - LAG(idh) OVER (PARTITION BY country ORDER BY year)) / LAG(idh) OVER (PARTITION BY country ORDER BY year) * 100,
        2
    ) AS annual_growth_rate
FROM (
    SELECT
        country,
        2017 AS year,
        idh_2017 AS idh
    FROM IDHRecord
    UNION ALL
    SELECT
        country,
        2018 AS year,
        idh_2018 AS idh
    FROM IDHRecord
    UNION ALL
    SELECT
        country,
        2019 AS year,
        idh_2019 AS idh
    FROM IDHRecord
    UNION ALL
    SELECT
        country,
        2020 AS year,
        idh2020 AS idh
    FROM IDHRecord
    UNION ALL
    SELECT
        country,
        2021 AS year,
        idh2021 AS idh
    FROM IDHRecord
) AS all_years
ORDER BY country, year;
/*Otra forma de obtener los resultados de la consulta anterior pero en una vista más sintetica
Another way to obtain the results of the previous query but in a more synthetic view */
SELECT
    country,
    ARRAY[
        (idh_2018 - idh_2017) / idh_2017,
        (idh_2019 - idh_2018) / idh_2018,
        (idh2020 - idh_2019) / idh_2019,
        (idh2021 - idh2020) / idh2020
    ] AS idh_growth_rates
FROM IDHRecord;

/*Tabla con la lista de paises y sus IDH ordenados por años, es una vista más sintetica
que nos permite dar un pantallazo general. Table with the list of countries and their HDI ordered by years, it is a more synthetic view
which allows us to give a general overview*/
SELECT
    country,
    ARRAY[idh_2017, idh_2018, idh_2019, idh2020, idh2021] AS idh_values
FROM IDHRecord;

/*Creacion de una vista de la taza de crecimiento anual de cada país, esto nos permite
encapsular las consultas que ya hemos construido y facilitar el acceso a los resultados*/
CREATE OR REPLACE VIEW IDHGrowthRates AS
SELECT
    country,
    year,
    idh,
    ROUND(
        (idh - LAG(idh) OVER (PARTITION BY country ORDER BY year)) / LAG(idh) OVER (PARTITION BY country ORDER BY year) * 100,
        2
    ) AS idh_growth_rate
FROM (
    SELECT
        country,
        2017 AS year,
        idh_2017 AS idh
    FROM IDHRecord
    UNION ALL
    SELECT
        country,
        2018 AS year,
        idh_2018 AS idh
    FROM IDHRecord
    UNION ALL
    SELECT
        country,
        2019 AS year,
        idh_2019 AS idh
    FROM IDHRecord
    UNION ALL
    SELECT
        country,
        2020 AS year,
        idh2020 AS idh
    FROM IDHRecord
    UNION ALL
    SELECT
        country,
        2021 AS year,
        idh2021 AS idh
    FROM IDHRecord
) AS all_years;

--Consulta sobre la Vista de taza de crecimiento
SELECT * FROM IDHGrowthRates;



