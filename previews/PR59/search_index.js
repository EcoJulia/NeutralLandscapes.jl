var documenterSearchIndex = {"docs":
[{"location":"gallery/","page":"Gallery","title":"Gallery","text":"using NeutralLandscapes\nusing Plots\n\nfunction demolandscape(alg::T) where {T <: NeutralLandscapeMaker}\n    heatmap(rand(alg, (200, 200)), frame=:none, aspectratio=1, c=:davos)\nend","category":"page"},{"location":"gallery/#No-gradient","page":"Gallery","title":"No gradient","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"demolandscape(NoGradient())","category":"page"},{"location":"gallery/#Planar-gradient","page":"Gallery","title":"Planar gradient","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"demolandscape(PlanarGradient(35))","category":"page"},{"location":"gallery/#Edge-gradient","page":"Gallery","title":"Edge gradient","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"demolandscape(EdgeGradient(186))","category":"page"},{"location":"gallery/#Wave-surface","page":"Gallery","title":"Wave surface","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"demolandscape(WaveSurface(35, 3))","category":"page"},{"location":"gallery/#Rectangular-cluster","page":"Gallery","title":"Rectangular cluster","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"demolandscape(RectangularCluster())","category":"page"},{"location":"gallery/#Distance-gradient","page":"Gallery","title":"Distance gradient","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"sources = unique(rand(1:40000, 50))\ndemolandscape(DistanceGradient(sources))","category":"page"},{"location":"gallery/#Nearest-neighbor-element","page":"Gallery","title":"Nearest-neighbor element","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"heatmap(rand(NearestNeighborElement(20, 1), (45, 45)))","category":"page"},{"location":"gallery/#Voronoi","page":"Gallery","title":"Voronoi","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"demolandscape(DiscreteVoronoi(40))","category":"page"},{"location":"gallery/#Perlin-Noise","page":"Gallery","title":"Perlin Noise","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"demolandscape(PerlinNoise())","category":"page"},{"location":"gallery/#Classify-landscape","page":"Gallery","title":"Classify landscape","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"sources = unique(rand(1:40000, 50))\nheatmap(NeutralLandscapes.classify!(rand(DistanceGradient(sources), (200, 200)), [0.5, 1, 1, 0.5]))","category":"page"},{"location":"gallery/#Diamond-Square","page":"Gallery","title":"Diamond Square","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"demolandscape(DiamondSquare())","category":"page"},{"location":"gallery/#Midpoint-Displacement","page":"Gallery","title":"Midpoint Displacement","text":"","category":"section"},{"location":"gallery/","page":"Gallery","title":"Gallery","text":"demolandscape(MidpointDisplacement())","category":"page"},{"location":"#NeutralLandscapes.jl","page":"Index","title":"NeutralLandscapes.jl","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"A pure Julia port of https://github.com/tretherington/nlmpy","category":"page"},{"location":"#Landscape-models","page":"Index","title":"Landscape models","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"NeutralLandscapeMaker\nDiamondSquare\nDiscreteVoronoi\nDistanceGradient\nEdgeGradient\nMidpointDisplacement\nNearestNeighborCluster\nNearestNeighborElement\nNoGradient\nPerlinNoise\nPlanarGradient\nRectangularCluster\nWaveSurface","category":"page"},{"location":"#NeutralLandscapes.NeutralLandscapeMaker","page":"Index","title":"NeutralLandscapes.NeutralLandscapeMaker","text":"NeutralLandscapeMaker\n\nAbstract supertype that all algorithms are descended from. A new algorithm must minimally implement a _landscape! method for this type.\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.DiamondSquare","page":"Index","title":"NeutralLandscapes.DiamondSquare","text":"DiamondSquare <: NeutralLandscapeMaker\n\nDiamondSquare(; H = 0.5) \nDiamondSquare(H)\n\nThis type generates a neutral landscape using the diamond-squares algorithm, which produces fractals with variable spatial autocorrelation.\n\nhttps://en.wikipedia.org/wiki/Diamond-square_algorithm\n\nThe algorithm is named diamond-square because it is an iterative procedure of \"diamond\" and \"square\" steps.\n\nThe degree of spatial autocorrelation is controlled by a parameter H, which varies from 0.0 (low autocorrelation) to 1.0 (high autocorrelation) –-  note this is non-inclusive and H = 0 and H = 1 will not behave as expected. The result of the diamond-square algorithm is a fractal with dimension D = 2 + H.\n\nA similar algorithm, midpoint-displacement, functions almost identically, except that in DiamondSquare, the square step interpolates edge midpoints from the nearest two corners and the square's center, where as  midpoint-displacement only interpolates from the nearest corners (see MidpointDisplacement).\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.DiscreteVoronoi","page":"Index","title":"NeutralLandscapes.DiscreteVoronoi","text":"DiscreteVoronoi <: NeutralLandscapeMaker\n\nDiscreteVoronoi(; n=3) \nDiscreteVoronoi(n)\n\nThis type provides a rasterization of a Voronoi-like diagram. Assigns a value to each patch using a 1-NN algorithmm with n initial clusters. It is a NearestNeighborElement algorithmm with k neighbors set to 1. The default is to use three clusters.\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.DistanceGradient","page":"Index","title":"NeutralLandscapes.DistanceGradient","text":"DistanceGradient <: NeutralLandscapeMaker\n\nDistanceGradient(; sources=[1])\nDistanceGradient(sources)\n\nThe sources field is a Vector{Integer} of linear indices of the matrix,  from which the distance must be calculated.\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.EdgeGradient","page":"Index","title":"NeutralLandscapes.EdgeGradient","text":"EdgeGradient <: NeutralLandscapeMaker\n\nEdgeGradient(; direction=360rand())\nEdgeGradient(direction)\n\nThis type is used to generate an edge gradient landscape, where values change as a bilinear function of the x and y coordinates. The direction is expressed as a floating point value, which will be in [0,360]. The inner constructor takes the mod of the value passed and 360, so that a value that is out of the correct interval will be corrected.\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.MidpointDisplacement","page":"Index","title":"NeutralLandscapes.MidpointDisplacement","text":"MidpointDisplacement <: NeutralLandscapeMaker\n\nMidpointDisplacement(; H = 0.5)\n\nCreates a midpoint-displacement algorithm object MidpointDisplacement.  The degree of spatial autocorrelation is controlled by a parameter H, which varies from 0.0 (low autocorrelation) to 1.0 (high autocorrelation) –-  note this is non-inclusive and H = 0 and H = 1 will not behave as expected.\n\nA similar algorithm, diamond-square, functions almost identically, except that in diamond-square, the square step interpolates edge midpoints from the nearest two corners and the square's center, where as  MidpointDisplacement only interpolates from the nearest corners (see DiamondSquare).\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.NearestNeighborCluster","page":"Index","title":"NeutralLandscapes.NearestNeighborCluster","text":"NearestNeighborCluster <: NeutralLandscapeMaker\n\nNearestNeighborCluster(; p=0.5, n=:rook)\nNearestNeighborCluster(p, [n=:rook])\n\nCreate a random cluster nearest-neighbour neutral landscape model with  values ranging 0-1. p sets the density of original clusters, and n sets the neighborhood for clustering (see ?label for neighborhood options)\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.NearestNeighborElement","page":"Index","title":"NeutralLandscapes.NearestNeighborElement","text":"NearestNeighborElement <: NeutralLandscapeMaker\n\nNearestNeighborElement(; n=3, k=1)\nNearestNeighborElement(n, [k=1])\n\nAssigns a value to each patch using a k-NN algorithmm with n initial clusters and k neighbors. The default is to use three cluster and a single neighbor.\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.NoGradient","page":"Index","title":"NeutralLandscapes.NoGradient","text":"NoGradient <: NeutralLandscapeMaker\n\nNoGradient()\n\nThis type is used to generate a random landscape with no gradients\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.PerlinNoise","page":"Index","title":"NeutralLandscapes.PerlinNoise","text":"PerlinNoise <: NeutralLandscapeMaker\n\nPerlinNoise(; kw...)\nPerlinNoise(periods, [octaves=1, lacunarity=2, persistance=0.5, valley=:u])\n\nCreate a Perlin noise neutral landscape model with values ranging 0-1.\n\nKeywords\n\nperiods::Tuple{Int,Int}=(1,1): the number of periods of Perlin noise across row and    column dimensions for the first octave.\noctaves::Int=1: the number of octaves that will form the Perlin noise.\nlacunarity::Int=2 : the rate at which the frequency of periods increases for each    octive.\npersistance::Float64=0.5 : the rate at which the amplitude of periods decreases for each    octive.\nvalley::Symbol=:u: the kind of valley bottom that will be mimicked::uproduces    u-shaped valleys,:vproduces v-shaped valleys, and:-` produces flat bottomed    valleys.\n\nNote: This is a memory-intensive algorithm with some settings. Be careful using larger  prime numbers for period when also using a large array size, high lacuarity and/or many  octaves. Memory use scales with the lowest common multiple of periods.\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.PlanarGradient","page":"Index","title":"NeutralLandscapes.PlanarGradient","text":"PlanarGradient <: NeutralLandscapeMaker\n\nPlanarGradient(; direction=360rand())\nPlanarGradient(direction)\n\nThis type is used to generate a planar gradient landscape, where values change as a bilinear function of the x and y coordinates. The direction is expressed as a floating point value, which will be in [0,360]. The inner constructor takes the mod of the value passed and 360, so that a value that is out of the correct interval will be corrected.\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.RectangularCluster","page":"Index","title":"NeutralLandscapes.RectangularCluster","text":"RectangularCluster <: NeutralLandscapeMaker\n\nRectangularCluster(; minimum=2, maximum=4)\nRectangularCluster(minimum, [maximum=4])\n\nFills the landscape with rectangles containing a random value. The size of each rectangle/patch is between minimum and maximum (the two can be equal for a fixed size rectangle).\n\n\n\n\n\n","category":"type"},{"location":"#NeutralLandscapes.WaveSurface","page":"Index","title":"NeutralLandscapes.WaveSurface","text":"WaveSurface <: NeutralLandscapeMaker\n\nWaveSurface(; direction=360rand(), periods=1)\nWaveSurface(direction, [periods=1])\n\nCreates a sinusoidal landscape with a direction and a number of periods. If neither are specified, there will be a single period of random direction.\n\n\n\n\n\n","category":"type"},{"location":"#Landscape-generating-function","page":"Index","title":"Landscape generating function","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"rand\nrand!","category":"page"},{"location":"#Base.rand","page":"Index","title":"Base.rand","text":"rand(alg, dims::Tuple{Vararg{Int64,2}}; mask=nothing) where {T <: Integer}\n\nCreates a landscape of size dims (a tuple of two integers) following the model defined by alg. The mask argument accepts a matrix of boolean values, and is passed to mask! if it is not nothing. \n\n\n\n\n\n","category":"function"},{"location":"#Random.rand!","page":"Index","title":"Random.rand!","text":"rand!(mat, alg) where {IT <: Integer}\n\nFill the matrix mat with a landscape created following the model defined by alg. The mask argument accepts a matrix of boolean values, and is passed to mask! if it is not nothing. \n\n\n\n\n\n","category":"function"},{"location":"#Other-functions","page":"Index","title":"Other functions","text":"","category":"section"},{"location":"","page":"Index","title":"Index","text":"classify\nclassify!\nblend\nlabel\nNeutralLandscapes.mask!","category":"page"},{"location":"#NeutralLandscapes.classify","page":"Index","title":"NeutralLandscapes.classify","text":"classify(array, weights[, mask])\n\nClassify an array into proportions based upon a list of class weights.\n\n\n\n\n\n","category":"function"},{"location":"#NeutralLandscapes.classify!","page":"Index","title":"NeutralLandscapes.classify!","text":"classify!(array, weights[, mask])\n\nClassify an array in-place into proportions based upon a list of class weights.\n\n\n\n\n\n","category":"function"},{"location":"#NeutralLandscapes.blend","page":"Index","title":"NeutralLandscapes.blend","text":"blend(arrays[, scaling])\n\nBlend arrays weighted by scaling factors.\n\n\n\n\n\nblend(clusterarray, arrays[, scaling])\n\nBlend a primary cluster NLM with other arrays in which the mean value per  cluster is weighted by scaling factors.\n\n\n\n\n\n","category":"function"},{"location":"#NeutralLandscapes.label","page":"Index","title":"NeutralLandscapes.label","text":"label(mat[, neighborhood = :rook])\n\nAssign an arbitrary label to all clusters of contiguous matrix elements with the same value. Returns a matrix of values and the total number of final clusters. The neighborhood structure can be  :rook     :queen    :diagonal  0 1 0        1 1 1        0 1 1  1 x 1        1 x 1        1 x 1  0 1 0        1 1 1        1 1 0  :rook is the default\n\n\n\n\n\n","category":"function"},{"location":"#NeutralLandscapes.mask!","page":"Index","title":"NeutralLandscapes.mask!","text":"mask!(array::AbstractArray{<:AbstractFloat}, maskarray::AbstractArray{<:AbstractBool})\n\nModifies array so that the positions at which maskarray is false are replaced by NaN.\n\n\n\n\n\n","category":"function"}]
}
