using NeutralLandscapes
using Test
using SpeciesDistributionToolkit


bbox = (left=-83.0, bottom=46.4, right=-55.2, top=63.7)
temp = SimpleSDMPredictor(RasterData(WorldClim2, AverageTemperature); bbox...) 

mpd = rand(MidpointDisplacement(), size(temp), mask=temp)
@test findall(isnan, mpd) == findall(isnothing, temp.grid)
