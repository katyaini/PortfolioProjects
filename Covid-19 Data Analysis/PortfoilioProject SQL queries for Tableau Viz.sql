--1.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..['covid deaths$']
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


--2.
---- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe
Select location, SUM(cast(new_deaths as int)) as total_deaths
from PortfolioProject..['covid deaths$']
where continent is null
and location not in('European Union', 'World' , 'International')
group by location order by total_deaths Desc;


--3.
Select location, Max(total_cases) AS HighestInfectionCount, Max((total_cases/population))*100 AS PercentagePopulationInfected
from PortfolioProject..['covid deaths$']
group by location, population
order by PercentagePopulationInfected desc;

--4.
Select location,population,date,Max(total_cases) AS HighestInfectionCount, Max((total_cases/population))*100 AS PercentagePopulationInfected
from PortfolioProject..['covid deaths$']
group by location, population, date
order by PercentagePopulationInfected desc;
