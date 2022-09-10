using NeutralLandscapes
using Test
using SimpleSDMLayers


bbox = (left=-83.0, bottom=46.4, right=-55.2, top=63.7)
temp = convert(Float32, SimpleSDMPredictor(WorldClim, BioClim, 7; bbox...))


mpd = rand(MidpointDisplacement(), size(temp), mask=temp)
@test findall(isnan, mpd) == findall(isnothing, temp.grid)
