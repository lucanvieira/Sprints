-- Nivell 1
-- Descàrrega els arxius CSV, estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, almenys 4 taules de les quals puguis realitzar les següents consultes:



CREATE DATABASE IF NOT EXISTS empresas;
    USE empresas;
    
    
show global variables like 'local_infile';    
SET GLOBAL local_infile=on;    

    -- Creamos la tabla companies.    OK
    CREATE TABLE IF NOT EXISTS companies (
        company_id varchar(255) PRIMARY KEY,
        company_name VARCHAR(255),
        phone VARCHAR(15),
        email VARCHAR(100),
        country VARCHAR(100),
        website VARCHAR(255)
    );	
    
    LOAD DATA LOCAL INFILE "/Users/lucanvieira/Downloads/companies.csv" INTO TABLE companies FIELDS terminated by ',' ignore 1 LINES;

    -- Creamos la tabla credit_cards.    OK
    CREATE TABLE IF NOT EXISTS credit_cards (
        id varchar(255) PRIMARY KEY,
		user_id INT REFERENCES user(id),
        iban VARCHAR(100),
		pan VARCHAR(20),
        pin VARCHAR(4),
        cvv VARCHAR(3),
        track1 VARCHAR(100),
		track2 VARCHAR(100),
        expiring_date varchar(15)
    );
    LOAD DATA LOCAL INFILE "/Users/lucanvieira/Downloads/credit_cards.csv" INTO TABLE credit_cards FIELDS terminated by ',' ignore 1 LINES;
    
    -- Creamos la tabla products        ok 
    CREATE TABLE IF NOT EXISTS products (
        id int PRIMARY KEY,
        product_name VARCHAR(255),
        price varchar(100),
        colour VARCHAR(20),
        weight FLOAT,
        warehouse_id VARCHAR(255)
    );
        LOAD DATA LOCAL INFILE "/Users/lucanvieira/Downloads/products.csv" INTO TABLE products FIELDS terminated by ',' ignore 1 LINES;
        
    -- Creamos la tabla transactions
    CREATE TABLE IF NOT EXISTS transactions (
        id VARCHAR(225) PRIMARY KEY,
        card_id VARCHAR(15) REFERENCES credit_cards(id),
        business_id VARCHAR(20) REFERENCES companies(company_id), 
        timestamp TIMESTAMP,
		amount DECIMAL(10, 2),
        declined BOOLEAN,
        product_ids VARCHAR(255),
        user_id INT REFERENCES users(id),
        lat FLOAT,
        longitude FLOAT
       );
      LOAD DATA LOCAL INFILE "/Users/lucanvieira/Downloads/transactions.csv" INTO TABLE transactions FIELDS terminated by ';' ignore 1 LINES;
      
  -- Creamos la tabla users
  
    CREATE TABLE IF NOT EXISTS users (
        id INT PRIMARY KEY,
        name VARCHAR(255),
        surname VARCHAR(255),
        phone VARCHAR(15),
        email VARCHAR(100),
        birth_date varchar(50),
        country VARCHAR(100),
        city VARCHAR(100),
        postal_code VARCHAR(100),
        address VARCHAR(255)
    );
    LOAD DATA LOCAL INFILE "/Users/lucanvieira/Downloads/users_uk.csv" INTO TABLE users FIELDS terminated by ','ENCLOSED BY '"' LINES TERMINATED BY '\r\n' ignore 1 LINES;
    LOAD DATA LOCAL INFILE "/Users/lucanvieira/Downloads/users_usa.csv" INTO TABLE users FIELDS terminated by ','ENCLOSED BY '"' LINES TERMINATED BY '\r\n' ignore 1 LINES;
    LOAD DATA LOCAL INFILE "/Users/lucanvieira/Downloads/users_ca.csv" INTO TABLE users FIELDS terminated by ','ENCLOSED BY '"' LINES TERMINATED BY '\r\n' ignore 1 LINES;
    
    
-- ----------------------------------------------

-- apuntar las FK

ALTER TABLE transactions ADD CONSTRAINT fk_companiestransactions FOREIGN KEY ( business_id ) REFERENCES companies (company_id);
ALTER TABLE transactions ADD CONSTRAINT fk_cardtransactions FOREIGN KEY ( card_id ) REFERENCES credit_cards (id);
ALTER TABLE transactions ADD CONSTRAINT fk_usertransactions FOREIGN KEY ( user_id ) REFERENCES users (id);



-- Exercici 1
-- Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.

SELECT users.id, users.name, users.surname
FROM users
WHERE users.id IN (
    SELECT transactions.user_id
    FROM transactions
    GROUP BY transactions.user_id
    HAVING COUNT(transactions.id) > 30
);
                
                
                
                
                

                

-- Exercici 2
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.


                            
SELECT company_name, iban, round(AVG(amount),3) AS media
FROM credit_cards
JOIN transactions ON transactions.card_id = credit_cards.id
JOIN companies ON companies.company_id = transactions.business_id
WHERE company_name = 'Donec Ltd'
GROUP BY iban, company_name;
                   
                   
                   
                   
                   
-- Nivell 2


-- Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les últimes tres transaccions van ser declinades i genera la següent consulta:

-- Exercici 1
-- Quantes targetes estan actives?

-- PRIMERO TENGO QUE DESCROBIR OS TRES ULTIMOS REGISTROS DE CADA TARJETA 

SELECT card_id, declined
FROM (
    SELECT card_id, declined, timestamp, RANK() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS ultimas
    FROM transactions
) AS subconsulta
WHERE ultimas <= 3
ORDER BY card_id;

-- DESPUES NECESITO CREAR LA CONDICION CON IF

SELECT card_id, IF(SUM(declined) > 3, 'Desactiva', 'Activa') AS 'status de las tarjetas'
FROM (
    SELECT card_id, declined, timestamp, RANK() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS ultimas
    FROM transactions
) AS subconsulta
WHERE ultimas <= 3
GROUP BY card_id;

-- DEPUES CREAR LA TAULA

CREATE TABLE Status_transac AS 
SELECT card_id, IF(SUM(declined) > 3, 'Desactiva', 'Activa') AS 'status de las tarjetas'
FROM (
    SELECT card_id, declined, timestamp, RANK() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS ultimas
    FROM transactions
) AS subconsulta
WHERE ultimas <= 3
GROUP BY card_id;



ALTER TABLE Status_transac RENAME COLUMN `status de las tarjetas` TO status_tarjetas;

-- CREAR FOREING KEY

SELECT status_tarjetas, count(*) AS CANTIDAD_DE_TARJETAS
from Status_transac
group by 1;

select *
from status_transac;















-- todas las tarjetas estan activas

-- Nivell 3
-- Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada, tenint en compte que des de transaction tens product_ids. Genera la següent consulta:

-- Exercici 1
-- Necessitem conèixer el nombre de vegades que s'ha venut cada producte.


SELECT id, user_id, DECLINED, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', n), ',', -1)) AS product_id
-- utilizamos el SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', n), ',', -1) para hacer una extraciòn de la cantidad n de lod IDS
FROM transactions
JOIN 
				(SELECT 1 AS n 
                UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) AS numbers
                -- esta fue la manera que encontre de crear una especie de loop  
				ON CHAR_LENGTH(product_ids) - CHAR_LENGTH(REPLACE(product_ids, ',', '')) >= n - 1;
   -- `CHAR_LENGTH(product_ids) - CHAR_LENGTH(REPLACE(product_ids, ',', ''))` cuenta  el número de comas, que corresponde al número de IDs menos uno.
   
   -- despues creamos la taula 
   
-- create table transactions_products as
-- SELECT id, user_id, SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', n), ',', -1) AS product_id
-- FROM transactions
-- JOIN (
	-- 				SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) AS numbers
	-- 				ON CHAR_LENGTH(product_ids) - CHAR_LENGTH(REPLACE(product_ids, ',', '')) >= n - 1;

-- ESTA PRIMERA MANERA ME DEJABA CON ESPACIOS ENTRE LOS IDS Y ESO HACIA CON QUE NO HUBIERA MANERA DE CONECTAR CON OTRAS TAULAS POR ESO FUA NECESÀRIO EL USO DEL TRIM() PARA QUITAR LOS ESPACIOS ENTRE

CREATE TABLE transactions_products AS
SELECT id, user_id, DECLINED, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(product_ids, ',', n), ',', -1)) AS product_id
FROM transactions
JOIN (
					SELECT 1 AS n UNION ALL 
                    SELECT 2 UNION ALL 
                    SELECT 3 UNION ALL 
                    SELECT 4) AS numbers
					ON CHAR_LENGTH(product_ids) - CHAR_LENGTH(REPLACE(product_ids, ',', '')) >= n - 1
;


	--  RENOMBRAMOS LA COLUMNA ID DE LA NUEVA TAULA
    
ALTER TABLE transactions_products RENAME COLUMN id TO transaction_id;
	
    --  MODIFICAMOS SU CARACTERISTICA 
    
ALTER TABLE transactions_products MODIFY product_id INT;
	
	-- CREAMOS LAS RELACIONES FK 
    
ALTER TABLE transactions_products ADD CONSTRAINT fk_transtransprod FOREIGN KEY ( transaction_id ) REFERENCES transactions (id);
ALTER TABLE transactions_products ADD CONSTRAINT fk_prodtrans FOREIGN KEY ( product_id ) REFERENCES products (id);

-- ----------------------------------------------------------------------------------------------------------------------------
-- Exercici 1
-- Necessitem conèixer el nombre de vegades que s'ha venut cada producte.
-- CONSIDERAR EL DECLINED

SELECT id, product_name, count(declined) as cantidad_dcompras
FROM PRODUCTS
JOIN transactions_products ON transactions_products.product_id = PRODUCTs.id
where declined = 0
group by 1,2
order by 1
;






ALTER TABLE Status_transac ADD CONSTRAINT fk_transsatatus FOREIGN KEY ( card_id ) REFERENCES credit_cards (id);

