SELECT *
FROM PortfolioProject..['covid vaccinations$']
where continent is NOT NULL
ORDER BY 3,4;
--SELECT *
--FROM PortfolioProject..['covid deaths$']
--ORDER BY 3,4

--select data that we are going to be using 
Select location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..['covid deaths$']
where continent is NOT NULL
order by 1,2

--looking at total cases v/s total deaths
--shows likelihood of dying if you contract covid in US
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..['covid deaths$']
where location like '%states%'
order by 1,2


--looking at total cases v/s population
--shows what percentage of population got covid in US
Select location, date,population, total_cases, (total_cases/population)*100 AS CasesPercentage
FROM PortfolioProject..['covid deaths$']
where location like '%states%'
order by 1,2

--looking at countries with highest infection rate compared to population
Select location,population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject..['covid deaths$']
--where location like '%states%'
where continent is NOT NULL
group by location, population
order by PercentPopulationInfected DESC;


--Showing the countries with Highest Death Count per Population
Select location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..['covid deaths$']
--where location like '%states%'
where continent is NOT NULL
group by location
order by TotalDeathCount DESC;

--LET'S BREAK THINGS DOWN BY CONTINENT

--Showing the continents with the highest death counts per population
Select continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM PortfolioProject..['covid deaths$']
--where location like '%states%'
where continent is NOT NULL
group by continent
order by TotalDeathCount DESC;

--GLOBAL NUMBERS

Select date, sum(new_cases) AS GlobalCases, sum(cast(new_deaths as int)) AS GlobalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 AS GLobalDeathPercentage
FROM PortfolioProject..['covid deaths$']
--where location like '%states%'
where continent is NOT NULL
group by date
order by 1,2


Select sum(new_cases) AS GlobalCases, sum(cast(new_deaths as int)) AS GlobalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 AS GLobalDeathPercentage
FROM PortfolioProject..['covid deaths$']
--where location like '%states%'
where continent is NOT NULL
order by 1,2

--Looking at total population vs vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) AS CumulativePeopleVaccinated
--(CumulativePeopleVaccinated/population)*100
from PortfolioProject..['covid deaths$'] dea
Join PortfolioProject..['covid vaccinations$'] vac
   On dea.location=vac.location
   and dea.date=vac.date
where dea.continent is NOT NULL
order by 2,3;


--USE  CTE

With PopVsVac(Continent, location, date, population, new_vaccinations,cumulativePeopleVaccinated)
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) AS CumulativePeopleVaccinated
--(CumulativePeopleVaccinated/population)*100
from PortfolioProject..['covid deaths$'] dea
Join PortfolioProject..['covid vaccinations$'] vac
   On dea.location=vac.location
   and dea.date=vac.date
where dea.continent is NOT NULL
)
select * , (CumulativePeopleVaccinated/population)*100 AS PopulationVaccinated
from PopVsVac


--TEMP TABLE
Drop Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
continent  nvarchar(255),
location  nvarchar(255),
date  datetime,
population  numeric,
new_vaccinations  numeric,
CumulativePeopleVaccinated  numeric
)

Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) AS CumulativePeopleVaccinated
--(CumulativePeopleVaccinated/population)*100
from PortfolioProject..['covid deaths$'] dea
Join PortfolioProject..['covid vaccinations$'] vac
   On dea.location=vac.location
   and dea.date=vac.date
where dea.continent is NOT NULL

select * , (CumulativePeopleVaccinated/population)*100 AS PopulationVaccinated
from PercentPopulationVaccinated


--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

Create View PercentPopulation_Vaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) AS CumulativePeopleVaccinated
--(CumulativePeopleVaccinated/population)*100
from PortfolioProject..['covid deaths$'] dea
Join PortfolioProject..['covid vaccinations$'] vac
   On dea.location=vac.location
   and dea.date=vac.date
where dea.continent is NOT NULL

Select *
from PercentPopulation_Vaccinated

Create View GlobalNumbers as
Select date, sum(new_cases) AS GlobalCases, sum(cast(new_deaths as int)) AS GlobalDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 AS GLobalDeathPercentage
FROM PortfolioProject..['covid deaths$']
--where location like '%states%'
where continent is NOT NULL
group by date

Select *
from GlobalNumbers