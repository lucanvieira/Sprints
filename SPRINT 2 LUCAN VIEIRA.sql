--                                                          NIVEL 1                                                                   -- 

-- Exercici 1

-- A partir dels documents adjunts (estructura_dades i dades_introduir), importa les dues taules. Mostra les característiques principals de l'esquema creat i explica les diferents taules i variables que existeixen. Assegura't d'incloure un diagrama que il·lustri la relació entre les diferents taules i variables.

-- respuesta: Es un esquema relacional donde una compañía puede tener varias transacciones, es decir, una relación 1-N. Las dos tablas están conectadas por el campo id de la tabla Company (clave primaria, PK) y el campo id_company de la tabla Transaction (clave foránea, FK). En la tabla Company se encuentran las características de las empresas que tienen al menos una transacción registrada, con datos como nombre, país, correo electrónico, entre otros. Por otro lado, en la tabla Transaction se almacenan los datos específicos de cada transacción realizada por las empresas. Cuando combinamos ambas tablas, podemos identificar las empresas y sus respectivas transacciones de manera clara. Estas tablas fueron separadas para evitar la repetición de datos, como el nombre de la empresa, que de otro modo se duplicaría en cada transacción registrada.

-- Ejercici 2 

-- Llistat dels països que estan fent compres.

select DISTINCT COUNTRY
from company
join transaction on transaction.company_id=company.id
WHERE DECLINED LIKE "0";


-- Des de quants països es realitzen les compres.

SELECT COUNT(distinct COUNTRY) AS NUMPAISOS
from company
join transaction on transaction.company_id=company.id
WHERE DECLINED LIKE "0";



-- Identifica la companyia amb la mitjana més gran de vendes.

SELECT company_name, round(avg(TRANSACTION.AMOUNT),2) as media
	from company
	join transaction on transaction.company_id=company.id
	WHERE DECLINED LIKE "0"
	GROUP BY 1
    order by 2 desc
    limit 1;







    
    -- EJERCICI 3
    
-- Mostra totes les transaccions realitzades per empreses d'Alemanya.

SELECT *
from company, transaction
where transaction.company_id=company.id and company.country like "Germany";




-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.

SELECT distinct company.company_name
from company, transaction
where transaction.company_id=company.id 
and transaction.amount > 
							(SELECT AVG(AMOUNT)
							from transaction
                            );





-- Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.

SELECT distinct company.id, company_name
from company, transaction
where transaction.company_id=company.id and company.id is null and transaction.company_id is not null;
-- ps. (no hay ninguna empresa que no tenga al menos una transaccion registrada)



--                                                          NIVEL 2                                                               -- 

-- Exercici 1
-- Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. Mostra la data de cada transacció juntament amb el total de les vendes.

SELECT distinct date(timestamp) as Fecha, sum(amount) as Ingressos
from transaction
where declined = '0' 
group by Fecha
order by 2 desc 
limit 5;






-- Exercici 2
-- Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.
select company.country, round(avg(amount),2) as media_de_ventas
from company
join transaction on transaction.company_id=company.id
where declined = '0' 
group by 1
order by 2 desc;






-- Exercici 3
-- En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia "Non Institute". Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.

-- Mostra el llistat aplicant JOIN i subconsultes.
select *
from company
join transaction on transaction.company_id=company.id
where country = (
				select country 
				from company
				where company_name = "Non Institute")
                and 
company_name not like "Non Institute";

-- he quitado de la consulta la empresa "Non Institute" porque, como se trata de una pesquisa publicitária creo que nuestra empresa tiene mas interes en saber somente los datos de las otras empresas.

-- Mostra el llistat aplicant solament subconsultes.

select *
from company, transaction
where transaction.company_id=company.id and country = (
				select country 
				from company
				where company_name = "Non Institute")
                and 
company_name not like "Non Institute";

-- he quitado de la consulta la empresa "Non Institute" porque, como se trata de una pesquisa publicitária creo que nuestra empresa tiene mas interes en saber somente los datos de las otras empresas.



--                                                          NIVEL 3                                                                   -- 

-- Exercici 1
-- Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès entre 100 i 200 euros i en alguna d'aquestes dates: 29 d'abril del 2021, 20 de juliol del 2021 i 13 de març del 2022. Ordena els resultats de major a menor quantitat.

select company_name, phone, country, date(timestamp) as data, amount
from company
join transaction on transaction.company_id=company.id
where amount between 100 and 200 and date(timestamp) in ('2021-04-29', "2021-07-20", "2022-03-13")
order by amount desc;



-- Exercici 2
-- Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen més de 4 transaccions o menys.
-- Precisamos otimizar a alocação de recursos, e isso dependerá da capacidade operacional necessária. Por essa razão, solicitam informações sobre a quantidade de transações realizadas pelas empresas. No entanto, o departamento de recursos humanos é exigente e quer uma lista das empresas especificando se realizam mais de 4 transações ou menos.

select company_name, if (count(company.id) > 4, 'Más de 4 transacciones', 'Menos de 4 transacciones') as Cantidad_de_transac
from company
join transaction on transaction.company_id=company.id
group by 1
order by 2;


