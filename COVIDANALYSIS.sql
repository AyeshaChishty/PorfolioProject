SELECT *
FROM [Portfolio Project]..['covid deaths']
WHERE continent is not null
ORDER BY 3,4

--SELECT *
--FROM [Portfolio Project]..['covid vaccination']
--ORDER BY 3,4

SELECT Location, date, total_cases,new_cases, total_deaths, population
FROM [Portfolio Project]..['covid deaths']
WHERE continent is not null
ORDER BY 1,2


SELECT Location, date, total_cases,new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM [Portfolio Project]..['covid deaths']
WHERE location like 'India'
and continent is not null
ORDER BY 1,2

SELECT Location,population , max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentpopulationInfected
FROM [Portfolio Project]..['covid deaths']
--WHERE location like 'India'
WHERE continent is not null
GROUP BY Location,population
ORDER BY PercentpopulationInfected desc


SELECT Location, MAX(CAST(Total_deaths as int)) as TotalDeathCount
FROM [Portfolio Project]..['covid deaths']
--WHERE location like 'India'
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc


SELECT continent, MAX(CAST(Total_deaths as int)) as TotalDeathCount
FROM [Portfolio Project]..['covid deaths']
--WHERE location like 'India'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc



SELECT continent, MAX(CAST(Total_deaths as int)) as TotalDeathCount
FROM [Portfolio Project]..['covid deaths']
--WHERE location like 'India'
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc


SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM [Portfolio Project]..['covid deaths']
--WHERE location like 'India'
WHERE continent is not null
--GROUP BY date
ORDER BY 1,2



SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT (int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated 
-- RollingPeopleVaccinated
From [Portfolio Project]..['covid deaths'] dea
Join [Portfolio Project]..['covid vaccination'] vac
     on dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3


with PopvsVac (Continent, Location, Date, Population,new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT (int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated 
-- RollingPeopleVaccinated
From [Portfolio Project]..['covid deaths'] dea
Join [Portfolio Project]..['covid vaccination'] vac
     on dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac



DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition by dea.Location Order by dea.location,
dea.Date) as RollingPeopleVaccinated 
-- RollingPeopleVaccinated
From [Portfolio Project]..['covid deaths'] dea
Join [Portfolio Project]..['covid vaccination'] vac
     on dea.location = vac.location
	 and dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated



CREATE View PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated 
-- RollingPeopleVaccinated
From [Portfolio Project]..['covid deaths'] dea
Join [Portfolio Project]..['covid vaccination'] vac
     on dea.location = vac.location
	 and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated