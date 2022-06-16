SELECT * 
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
order by 3,4


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

--Death Percentage
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

--Death Percentage in USA
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2
--Death Percentage in Poland
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%Poland%'
ORDER BY 1,2

--Total Cases vs Popoulation
SELECT Location, date, total_cases, population, (total_cases/population)*100 as CasesPercentage
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

--Total Cases vs Popoulation in Poland
SELECT Location, date, total_cases, population, (total_cases/population)*100 as CasesPercentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%Poland%'
ORDER BY 1,2

-- Countries with highest infection rate compared to population

SELECT Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as CasesPercentage
FROM PortfolioProject..CovidDeaths
GROUP BY Location, population
ORDER BY CasesPercentage DESC

--Countries with highest death count per population

SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC

--Total death count grouped by continents 
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC


--Total Population vs Vaccinations

SELECT dea.continent,  dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

--USE CTE

With PopVsVac (Continent, Location, Date, Population, New_Vaccinations, rolling_people_vaccinated)
as 
(
SELECT dea.continent,  dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null 
)
SELECT *, (rolling_people_vaccinated/Population)*100
FROM PopVsVac

CREATE View PercentPopulationVaccinated as 
SELECT dea.continent,  dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location ORDER BY dea.location, dea.date) as rolling_people_vaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location
and dea.date = vac.date
WHERE dea.continent is not null 

Select * FROM PercentPopulationVaccinated

