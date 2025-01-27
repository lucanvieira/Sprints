-- Descripció

-- En aquest sprint, es simula una situació empresarial en la qual has de realitzar diverses manipulacions en les taules de la base de dades. Al seu torn, hauràs de treballar amb índexs i vistes. En aquesta activitat, continuaràs treballant amb la base de dades que conté informació d'una empresa dedicada a la venda de productes en línia. En aquesta tasca, començaràs a treballar amb informació relacionada amb targetes de crèdit.
-- Neste sprint, simula-se uma situação empresarial na qual você deve realizar diversas manipulações nas tabelas do banco de dados. Além disso, será necessário trabalhar com índices e visões (views). Nesta atividade, você continuará trabalhando com o banco de dados que contém informações de uma empresa dedicada à venda de produtos online. Nesta tarefa, você começará a trabalhar com informações relacionadas a cartões de crédito.


-- Nivell 1

-- Exercici 1
-- La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit. La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" i "company"). Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit". Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.

CREATE TABLE credit_card (
    id VARCHAR(20),
    iban VARCHAR (150),
    pan VARCHAR(150),
    pin VARCHAR(4),
    cvv VARCHAR(3),
    expiring_date VARCHAR(8), 
    PRIMARY KEY (id)
    );
    
    
show tableS;
show columns from transaction;
show columns from company;
show columns from credit_card;
show create table transaction;
    -- hice esto para visualisar y compreender mejor las tablas y columnas
    
ALTER TABLE transaction ADD CONSTRAINT fk_cardtransaction FOREIGN KEY ( credit_card_id ) REFERENCES credit_card (id);
ALTER TABLE credit_card MODIFY pin INT;
ALTER TABLE credit_card  MODIFY cvv int;


-- Tuve dificuldad en crear una nueva Fk, porque no comprendia el camino de creacion. Pero despues de la explicacion de Alana hice una investigacion y descobri que , claro, hay que hacer un alter table en la tabla "transaction" y no en la tabla "credit_card". Aun tengo dudas sobre el uso de los tipos de columnas y por eso hice todo com VARCHAR () y depués cambié su "tipo" con el MODIFY.




-- Exercici 2
-- El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb ID CcU-2938. La informació que ha de mostrar-se per a aquest registre és: R323456312213576817699999. Recorda mostrar que el canvi es va realitzar.
-- O departamento de Recursos Humanos identificou um erro no número da conta do usuário com ID CcU-2938. As informações que devem ser exibidas para este registro são: R323456312213576817699999. Lembre-se de mostrar que a alteração foi realizada.


UPDATE credit_card
SET iban = 'R323456312213576817699999'
WHERE id = "CcU-2938";

SELECT * 
FROM credit_card 
WHERE id = 'CcU-2938';







-- Exercici 3
-- En la taula "transaction" ingressa un nou usuari amb la següent informació:

-- Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD -- credit_card_id	CcU-9999 -- company_id	b-9999 -- user_id	9999 -- lat	829.999 -- longitude	-117.999 -- amount	111.11 -- declined	0


-- inseriro los datos

INSERT INTO credit_card (Id, iban, pin, cvv, expiring_date, fecha_actual) -- ok datos de credit_card
VALUES ('CcU-9999', '0000','000','000','000', '01/01/01'); 

INSERT INTO company (id, company_name, phone, email, country, website) -- ok datos de company
VALUES ('b-9999', '0000','000','000','000', '000'); 

INSERT INTO user (id, name, surname, phone, email, birth_date, country, city, postal_code, address) -- ok datos de user
VALUES ('9999', '0000','000','000','000', '000','000','000','000','000'); 

INSERT INTO transaction (Id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) -- ok datos de transaction
VALUES ("108B1D1D-5B23-A76C-55EF-C568E49A99DD",'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', '111.11', '0');

select *
from transaction
where id="108B1D1D-5B23-A76C-55EF-C568E49A99DD";


-- - Exercici 4
-- Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_*card. Recorda mostrar el canvi realitzat.

ALTER TABLE credit_card DROP COLUMN pan;

show columns from credit_card;












-- Nivell 2

-- Exercici 1
-- Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.

DELETE FROM
        transaction
        WHERE
        id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';
        
SELECT * 
FROM transaction 
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';









-- Exercici 2
-- La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

create view VistaMarketing as
		select company_name, phone, country, avg(transaction.amount)
		from company
		join transaction on transaction.company_id = company.id
		group by 1, 2, 3;

ALTER view VistaMarketing as
		select company_name AS nombre_empresa, phone as Telefono, country as pais, avg(transaction.amount) as media_compra
		from company
		join transaction on transaction.company_id = company.id
		group by 1, 2, 3;
        
select *
from VistaMarketing
order by 4 desc;


-- Exercici 3
-- Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"

select *
from VistaMarketing
where pais = 'germany';















-- Nivell 3
-- Exercici 1
-- La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. Un company del teu equip va realitzar modificacions en la base de dades, però no recorda com les va realitzar. Et demana que l'ajudis a deixar els comandos executats per a obtenir el següent diagrama:

-- 1) Creamos la tabla user con el archivo estructura_de_datos_user.
-- 2) Insertamos datos de user con el archivo datos_introducir_user.
-- 3) conferimos se los datos se han insertados bien con :

SELECT * FROM transactions.user;

-- 4) modificamos el tipo que son las columnas de la tabla credit_card

ALTER TABLE credit_card MODIFY iban VARCHAR(50);
ALTER TABLE credit_card MODIFY pin VARCHAR(4);
ALTER TABLE credit_card MODIFY expiring_date VARCHAR(20);

-- 5 creamos la columna "FECHA_ACTUAL" en credit_card

ALTER TABLE credit_card
ADD fecha_actual DATE;

-- 6 miramos el DIAGRAMA en database -> Reverse Engineer -> continue ->
-- 7 identificamos una foreign key en transaction

ALTER TABLE transaction ADD CONSTRAINT fk_usertransaction FOREIGN KEY ( user_id ) REFERENCES user (id);

-- 8 miramos una vez mas el DIAGRAMA en database -> Reverse Engineer -> continue ->
-- 9 excluimos la foreign key en USER

ALTER TABLE user DROP CONSTRAINT user_ibfk_1;

-- 10 ultimas modificaciones

ALTER TABLE company DROP COLUMN website;
ALTER TABLE user 
RENAME COLUMN email TO personal_email;
RENAME TABLE user to data_user;

-- 11 miramos una vez mas el DIAGRAMA en database -> Reverse Engineer -> continue -> y ya está todo perfecto














-- Exercici 2
-- L'empresa també et sol·licita crear una vista anomenada "InformeTecnico" que contingui la següent informació:

-- ID de la transacció -- Nom de l'usuari/ària -- Cognom de l'usuari/ària -- IBAN de la targeta de crèdit usada. -- Nom de la companyia de la transacció realitzada. -- Assegura't d'incloure informació rellevant de totes dues taules i utilitza àlies per a canviar de nom columnes segons sigui necessari. -- Mostra els resultats de la vista, ordena els resultats de manera descendent en funció de la variable ID de transaction.

CREATE VIEW InformeTecnico AS
	select transaction.id as id_transaction, data_user.name as Nombre_de_usuario, data_user.surname as Apelido,credit_card.iban,company.company_name as nombre_de_la_empresa
	from transaction
	join data_user on data_user.id = transaction.user_id
	join company on company.id = transaction.company_id
	join credit_card on credit_card.id = transaction.credit_card_id;
    
select *
from InformeTecnico
order by 1 desc;
