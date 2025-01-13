-- Mostre a quantidade de cidades que há na tabela city.
select count(name)
from city;

-- Mostre a quantidade de cidades que cada "countryCode" tem na tabela city.

select count(name), countrycode
from city
group by 2
order by 1 desc;

-- Mostre a "população" máxima de cada "countryCode" na tabela city.

select max(population), countrycode
from city
group by 2
order by 2;

-- Mostre a "expectativa de vida" média de cada continente e região na tabela country.

select avg(lifeexpectancy), continent, region
from country
group by 2, 3
order by 2;


-- Mostre a "população" total de cada continente.

select sum(population), continent
from country
group by 2
order by 1 desc;


-- Mostre a "área de superfície" mais pequena de cada região de cada continente.

select min(SurfaceArea), continent, region
from country
group by 2, 3
order by 1 desc;


-- Mostre quantos países tem cada continente.

select count(name), continent
from country
group by 2
order by 1 desc;

-- Mostre os continentes que têm mais de 50 países.
select count(name), continent
from country
group by 2
having count(name) > 50
order by 1 desc;

-- Mostre a quantidade de países por "língua" e por "é Oficial". Ou seja, quantos países falam uma língua dependendo de ser oficial ou não.

select IsOfficial as oficial_t_nao_oficial_F, count(language), countrycode
from countrylanguage
group by 1, 3
order by 2 desc;


-- Mostre o nome do país maior de cada continente *
            
select continent, name, surfacearea
from country
where (continent, surfacearea) in 
					(select continent, max(SurfaceArea)
                    from country
                    group by 1);

            
            

