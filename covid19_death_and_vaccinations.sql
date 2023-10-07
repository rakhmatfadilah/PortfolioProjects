--Total Cases vs Population
-- CREATE PROCEDURE CasePerPopulation AS
/*
SELECT [location], date, population, total_cases, total_deaths, 
        CONCAT(
            CAST((1.0*total_cases/population)*100 AS decimal(8,5)),'%') AS deaths_per_pop,
        CONCAT(
            CAST((1.0*total_deaths/total_cases)*100 AS decimal(8,5)),'%') AS deaths_per_case
FROM CovidDeaths
ORDER BY 1,2
*/
-- GO

-- Looking out Country with Highest Infection Rate compared with Population
-- CREATE PROCEDURE HighestCasePerPop AS
/*
SELECT location, population, MAX(total_cases) AS highest_case, 
        MAX (CONCAT(
            CAST((1.0*total_cases/population)*100 AS decimal(8,5)),'%')) AS cases_per_pop
FROM CovidDeaths
GROUP BY location, population
ORDER BY cases_per_pop DESC
-- GO
*/

/*
-- Showing Countries with Highest Death Count per Population
SELECT location, population, MAX(total_deaths) AS highest_death_rate,
    MAX (CONCAT(
            CAST((1.0*total_deaths/population)*100 AS decimal(8,5)),'%')) AS deaths_per_pop
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY highest_death_rate DESC
*/

/*
-- Showing the Continent with the Highest Death Count per Population
SELECT continent, SUM(population) AS avg_population, MAX(total_deaths) AS total_death_count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count
*/

/*
-- Looking at Total Vaccinations vs Total Populations
SELECT dea.continent, dea.[date], dea.[location], dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS people_vaccinations
FROM CovidVaccinations vac
JOIN CovidDeaths dea 
ON dea.[location] = vac.[location] AND dea.[date] = vac.[date]
WHERE dea.continent IS NOT NULL
ORDER BY dea.[location], dea.[date]
*/

/*
-- USE CTE's
WITH PopVac (Continent, Date, Location, Population, New_Vaccination, People_Vaccinations) -- bikin tabel
AS
(
SELECT dea.continent, dea.[date], dea.[location], dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS People_Vaccinations
FROM CovidVaccinations vac
JOIN CovidDeaths dea 
ON dea.[location] = vac.[location] AND dea.[date] = vac.[date]
WHERE dea.continent IS NOT NULL
-- ORDER BY dea.[location], dea.[date]    
)
SELECT *, (1.0*People_Vaccinations/population)*100 AS Percentages
FROM PopVac
*/

/*
-- USE TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent NVARCHAR(255),
Date DATE,
Location NVARCHAR(255),
Population NUMERIC,
New_Vaccination NUMERIC,
People_Vaccinations NUMERIC
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.[date], dea.[location], dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS People_Vaccinations
FROM CovidVaccinations vac
JOIN CovidDeaths dea 
ON dea.[location] = vac.[location] AND dea.[date] = vac.[date]
WHERE dea.continent IS NOT NULL
-- ORDER BY dea.[location], dea.[date]    

SELECT *, (1.0*People_Vaccinations/Population)*100 AS Percentages
FROM #PercentPopulationVaccinated
*/

/*
-- GLOBAL VIEWS
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, 1.0*SUM(new_deaths)/SUM(new_cases)*100 AS death_percentage
FROM CovidDeaths
WHERE continent IS NOT NULL
*/