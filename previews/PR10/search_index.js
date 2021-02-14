var documenterSearchIndex = {"docs":
[{"location":"gallery/","page":"Gallery","title":"Gallery","text":"using NeutralLandscapes\nusing Plots","category":"page"},{"location":"gallery/#No-gradient","page":"Gallery","title":"No gradient","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"heatmap(rand(NoGradient(), (45, 45)))","category":"page"},{"location":"gallery/#Planar-gradient","page":"Gallery","title":"Planar gradient","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"heatmap(rand(PlanarGradient(), (45, 45)))","category":"page"},{"location":"gallery/#Edge-gradient","page":"Gallery","title":"Edge gradient","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"heatmap(rand(EdgeGradient(), (45, 45)))","category":"page"},{"location":"gallery/#Wave-surface","page":"Gallery","title":"Wave surface","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"heatmap(rand(WaveSurface(), (45, 45)))","category":"page"},{"location":"gallery/#Rectangular-cluster","page":"Gallery","title":"Rectangular cluster","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"heatmap(rand(RectangularCluster(), (45, 45)))","category":"page"},{"location":"gallery/#Distance-gradient","page":"Gallery","title":"Distance gradient","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"sources = unique(rand(1:2025, 15))\nheatmap(rand(DistanceGradient(sources), (45, 45)))","category":"page"},{"location":"gallery/#Classify-landscape","page":"Gallery","title":"Classify landscape","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"sources = unique(rand(1:2025, 15))\nheatmap(NeutralLandscapes.classify!(rand(DistanceGradient(sources), (45, 45)), [0.5, 1, 1, 0.5]))","category":"page"},{"location":"#NeutralLandscapes.jl","page":"Index","title":"NeutralLandscapes.jl","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"A pure Julia port of https://github.com/tretherington/nlmpy","category":"page"},{"location":"#Landscape-models","page":"Index","title":"Landscape models","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"NeutralLandscapeMaker\nNoGradient\nPlanarGradient\nEdgeGradient\nWaveSurface\nDistanceGradient\nRectangularCluster","category":"page"},{"location":"#NeutralLandscapes.NoGradient","page":"Index","title":"NeutralLandscapes.NoGradient","text":"NoGradient\n\nThis type is used to generate a random landscape with no gradients\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.PlanarGradient","page":"Index","title":"NeutralLandscapes.PlanarGradient","text":"PlanarGradient\n\nThis type is used to generate a planar gradient landscape, where values change as a bilinear function of the x and y coordinates. The direction is expressed as a floating point value, which will be in [0,360]. The inner constructor takes the mod of the value passed and 360, so that a value that is out of the correct interval will be corrected.\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.EdgeGradient","page":"Index","title":"NeutralLandscapes.EdgeGradient","text":"EdgeGradient\n\nThis type is used to generate an edge gradient landscape, where values change as a bilinear function of the x and y coordinates. The direction is expressed as a floating point value, which will be in [0,360]. The inner constructor takes the mod of the value passed and 360, so that a value that is out of the correct interval will be corrected.\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.WaveSurface","page":"Index","title":"NeutralLandscapes.WaveSurface","text":"WaveSurface\n\nCreates a sinusoidal landscape with a direction and a number of periods. If neither are specified, there will be a single period of random direction.\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.DistanceGradient","page":"Index","title":"NeutralLandscapes.DistanceGradient","text":"DistanceGradient\n\nThe sources field is the linear indices of the matrix, from which the distance must be calculated.\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.RectangularCluster","page":"Index","title":"NeutralLandscapes.RectangularCluster","text":"RectangularCluster\n\nFills the landscape with rectangles containing a random value. The size of each rectangle/patch is between minimum and maximum (the two can be equal for a fixed size rectangle).\n\n\n\n\n\n","category":"type"},{"location":"#Landscape-generating-function","page":"Index","title":"Landscape generating function","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"rand!\nrand\n_landscape!","category":"page"},{"location":"#Random.rand!","page":"Index","title":"Random.rand!","text":"rand!(mat, alg) where {IT <: Integer}\n\nFill the matrix mat with a landscape created following the model defined by alg. The mask argument accepts a matrix of boolean values, and is passed to mask! if it is not nothing. \n\n\n\n\n\n","category":"function"},{"location":"#Base.rand","page":"Index","title":"Base.rand","text":"rand(alg, dims::Tuple{Vararg{Int64,2}}; mask=nothing) where {T <: Integer}\n\nCreates a landscape of size dims (a tuple of two integers) following the model defined by alg. The mask argument accepts a matrix of boolean values, and is passed to mask! if it is not nothing. \n\n\n\n\n\n","category":"function"},{"location":"#Other-functions","page":"Index","title":"Other functions","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"mask!","category":"page"}]
}
