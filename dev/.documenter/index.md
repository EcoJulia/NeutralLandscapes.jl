
# NeutralLandscapes.jl {#NeutralLandscapes.jl}

A pure Julia port of https://github.com/tretherington/nlmpy

## Landscape models {#Landscape-models}
<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.NeutralLandscapeMaker' href='#NeutralLandscapes.NeutralLandscapeMaker'><span class="jlbinding">NeutralLandscapes.NeutralLandscapeMaker</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
NeutralLandscapeMaker
```


Abstract supertype that all algorithms are descended from. A new algorithm must minimally implement a `_landscape!` method for this type.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/landscape.jl#L3-L8" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.DiamondSquare' href='#NeutralLandscapes.DiamondSquare'><span class="jlbinding">NeutralLandscapes.DiamondSquare</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
DiamondSquare <: NeutralLandscapeMaker

DiamondSquare(; H = 0.5) 
DiamondSquare(H)
```


This type generates a neutral landscape using the diamond-squares algorithm, which produces fractals with variable spatial autocorrelation.

https://en.wikipedia.org/wiki/Diamond-square_algorithm

The algorithm is named diamond-square because it is an iterative procedure of &quot;diamond&quot; and &quot;square&quot; steps.

The degree of spatial autocorrelation is controlled by a parameter `H`, which varies from 0.0 (low autocorrelation) to 1.0 (high autocorrelation) –-  note this is non-inclusive and H = 0 and H = 1 will not behave as expected. The result of the diamond-square algorithm is a fractal with dimension D = 2 + H.

A similar algorithm, midpoint-displacement, functions almost identically, except that in DiamondSquare, the square step interpolates edge midpoints from the nearest two corners and the square&#39;s center, where as  midpoint-displacement only interpolates from the nearest corners (see `MidpointDisplacement`).


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/makers/diamondsquare.jl#L1-L26" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.DiscreteVoronoi' href='#NeutralLandscapes.DiscreteVoronoi'><span class="jlbinding">NeutralLandscapes.DiscreteVoronoi</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
DiscreteVoronoi <: NeutralLandscapeMaker

DiscreteVoronoi(; n=3) 
DiscreteVoronoi(n)
```


This type provides a rasterization of a Voronoi-like diagram. Assigns a value to each patch using a 1-NN algorithmm with `n` initial clusters. It is a `NearestNeighborElement` algorithmm with `k` neighbors set to 1. The default is to use three clusters.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/makers/discretevoronoi.jl#L1-L11" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.DistanceGradient' href='#NeutralLandscapes.DistanceGradient'><span class="jlbinding">NeutralLandscapes.DistanceGradient</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
DistanceGradient <: NeutralLandscapeMaker

DistanceGradient(; sources=[1])
DistanceGradient(sources)
```


The `sources` field is a `Vector{Integer}` of _linear_ indices of the matrix,  from which the distance must be calculated.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/makers/distancegradient.jl#L1-L9" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.EdgeGradient' href='#NeutralLandscapes.EdgeGradient'><span class="jlbinding">NeutralLandscapes.EdgeGradient</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
EdgeGradient <: NeutralLandscapeMaker

EdgeGradient(; direction=360rand())
EdgeGradient(direction)
```


This type is used to generate an edge gradient landscape, where values change as a bilinear function of the _x_ and _y_ coordinates. The direction is expressed as a floating point value, which will be in _[0,360]_. The inner constructor takes the mod of the value passed and 360, so that a value that is out of the correct interval will be corrected.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/makers/edgegradient.jl#L1-L12" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.MidpointDisplacement' href='#NeutralLandscapes.MidpointDisplacement'><span class="jlbinding">NeutralLandscapes.MidpointDisplacement</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
MidpointDisplacement <: NeutralLandscapeMaker

MidpointDisplacement(; H = 0.5)
```


Creates a midpoint-displacement algorithm object `MidpointDisplacement`.  The degree of spatial autocorrelation is controlled by a parameter `H`, which varies from 0.0 (low autocorrelation) to 1.0 (high autocorrelation) –-  note this is non-inclusive and H = 0 and H = 1 will not behave as expected.

A similar algorithm, diamond-square, functions almost identically, except that in diamond-square, the square step interpolates edge midpoints from the nearest two corners and the square&#39;s center, where as  `MidpointDisplacement` only interpolates from the nearest corners (see `DiamondSquare`).


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/makers/diamondsquare.jl#L35-L49" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.NearestNeighborCluster' href='#NeutralLandscapes.NearestNeighborCluster'><span class="jlbinding">NeutralLandscapes.NearestNeighborCluster</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
NearestNeighborCluster <: NeutralLandscapeMaker

NearestNeighborCluster(; p=0.5, n=:rook)
NearestNeighborCluster(p, [n=:rook])
```


Create a random cluster nearest-neighbour neutral landscape model with  values ranging 0-1. `p` sets the density of original clusters, and `n` sets the neighborhood for clustering (see `?label` for neighborhood options)


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/makers/nncluster.jl#L1-L10" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.NearestNeighborElement' href='#NeutralLandscapes.NearestNeighborElement'><span class="jlbinding">NeutralLandscapes.NearestNeighborElement</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
NearestNeighborElement <: NeutralLandscapeMaker

NearestNeighborElement(; n=3, k=1)
NearestNeighborElement(n, [k=1])
```


Assigns a value to each patch using a k-NN algorithmm with `n` initial clusters and `k` neighbors. The default is to use three cluster and a single neighbor.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/makers/nnelement.jl#L1-L9" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.NoGradient' href='#NeutralLandscapes.NoGradient'><span class="jlbinding">NeutralLandscapes.NoGradient</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
NoGradient <: NeutralLandscapeMaker

NoGradient()
```


This type is used to generate a random landscape with no gradients


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/makers/nogradient.jl#L1-L7" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.PerlinNoise' href='#NeutralLandscapes.PerlinNoise'><span class="jlbinding">NeutralLandscapes.PerlinNoise</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
PerlinNoise <: NeutralLandscapeMaker

PerlinNoise(; kw...)
PerlinNoise(periods, [octaves=1, lacunarity=2, persistance=0.5, valley=:u])
```


Create a Perlin noise neutral landscape model with values ranging 0-1.

**Keywords**
- `periods::Tuple{Int,Int}=(1,1)`: the number of periods of Perlin noise across row and    column dimensions for the first octave.
  
- `octaves::Int=1`: the number of octaves that will form the Perlin noise.
  
- `lacunarity::Int=2` : the rate at which the frequency of periods increases for each    octive.
  
- `persistance::Float64=0.5` : the rate at which the amplitude of periods decreases for each    octive.
  
- `valley::Symbol=`:u`: the kind of valley bottom that will be mimicked:`:u`produces    u-shaped valleys,`:v`produces v-shaped valleys, and`:-` produces flat bottomed    valleys.
  

Note: This is a memory-intensive algorithm with some settings. Be careful using larger  prime numbers for `period` when also using a large array size, high lacuarity and/or many  octaves. Memory use scales with the lowest common multiple of `periods`.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/makers/perlinnoise.jl#L1-L25" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.PlanarGradient' href='#NeutralLandscapes.PlanarGradient'><span class="jlbinding">NeutralLandscapes.PlanarGradient</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
PlanarGradient <: NeutralLandscapeMaker

PlanarGradient(; direction=360rand())
PlanarGradient(direction)
```


This type is used to generate a planar gradient landscape, where values change as a bilinear function of the _x_ and _y_ coordinates. The direction is expressed as a floating point value, which will be in _[0,360]_. The inner constructor takes the mod of the value passed and 360, so that a value that is out of the correct interval will be corrected.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/makers/planargradient.jl#L1-L12" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.RectangularCluster' href='#NeutralLandscapes.RectangularCluster'><span class="jlbinding">NeutralLandscapes.RectangularCluster</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
RectangularCluster <: NeutralLandscapeMaker

RectangularCluster(; minimum=2, maximum=4)
RectangularCluster(minimum, [maximum=4])
```


Fills the landscape with rectangles containing a random value. The size of each rectangle/patch is between `minimum` and `maximum` (the two can be equal for a fixed size rectangle).


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/makers/rectangularcluster.jl#L1-L10" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.WaveSurface' href='#NeutralLandscapes.WaveSurface'><span class="jlbinding">NeutralLandscapes.WaveSurface</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
WaveSurface <: NeutralLandscapeMaker

WaveSurface(; direction=360rand(), periods=1)
WaveSurface(direction, [periods=1])
```


Creates a sinusoidal landscape with a `direction` and a number of `periods`. If neither are specified, there will be a single period of random direction.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/makers/wavesurface.jl#L1-L9" target="_blank" rel="noreferrer">source</a></Badge>

</details>


## Landscape generating function {#Landscape-generating-function}
<details class='jldocstring custom-block' open>
<summary><a id='Base.rand' href='#Base.rand'><span class="jlbinding">Base.rand</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
rand(alg, dims::Tuple{Vararg{Int64,2}}; mask=nothing) where {T <: Integer}
```


Creates a landscape of size `dims` (a tuple of two integers) following the model defined by `alg`. The `mask` argument accepts a matrix of boolean values, and is passed to `mask!` if it is not `nothing`. 


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/landscape.jl#L11-L17" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='Random.rand!' href='#Random.rand!'><span class="jlbinding">Random.rand!</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
rand!(mat, alg) where {IT <: Integer}
```


Fill the matrix `mat` with a landscape created following the model defined by `alg`. The `mask` argument accepts a matrix of boolean values, and is passed to `mask!` if it is not `nothing`. 


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/landscape.jl#L24-L30" target="_blank" rel="noreferrer">source</a></Badge>

</details>


## Temporal Change {#Temporal-Change}
<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.NeutralLandscapeUpdater' href='#NeutralLandscapes.NeutralLandscapeUpdater'><span class="jlbinding">NeutralLandscapes.NeutralLandscapeUpdater</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
NeutralLandscapeUpdater
```


NeutralLandscapeUpdater is an abstract type for methods for updating a landscape matrix


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/updaters/update.jl#L1-L6" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.TemporallyVariableUpdater' href='#NeutralLandscapes.TemporallyVariableUpdater'><span class="jlbinding">NeutralLandscapes.TemporallyVariableUpdater</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
TemporallyVariableUpdater{D,S} <: NeutralLandscapeUpdater
```


A `NeutralLandscapeUpdater` that has a prescribed level of temporal variation (`variability`) and rate of change (`rate`), but no spatial correlation in where change is distributed.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/updaters/temporal.jl#L1-L7" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.SpatiallyAutocorrelatedUpdater' href='#NeutralLandscapes.SpatiallyAutocorrelatedUpdater'><span class="jlbinding">NeutralLandscapes.SpatiallyAutocorrelatedUpdater</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
SpatiallyAutocorrelatedUpdater{SU,R,V}
```


A `NeutralLandscapeUpdater` that has a prescribed level of  spatial variation (`variability`) and rate of change (`rate`), and where the spatial distribution of this change is proportional to a neutral landscape generated with `spatialupdater` at every time step. 

TODO: make it possible to fix a given spatial updater at each timestep.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/updaters/spatial.jl#L2-L12" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.SpatiotemporallyAutocorrelatedUpdater' href='#NeutralLandscapes.SpatiotemporallyAutocorrelatedUpdater'><span class="jlbinding">NeutralLandscapes.SpatiotemporallyAutocorrelatedUpdater</span></a> <Badge type="info" class="jlObjectType jlType" text="Type" /></summary>



```julia
SpatiotemporallyAutocorrelatedUpdater{SU,R,V}
```


A `NeutralLandscapeUpdater` that has a prescribed level of spatial and temporal variation (`variability`) and rate of change (`rate`), and where the spatial distribution of this change is proportional to a neutral landscape generated with `spatialupdater` at every time step. 

TODO: perhaps spatial and temporal should each have their own variability param


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/updaters/spatiotemporal.jl#L2-L12" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.update' href='#NeutralLandscapes.update'><span class="jlbinding">NeutralLandscapes.update</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
update(updater::T, mat)
```


Returns one-timestep applied to `mat` based on the `NeutralLandscapeUpdater` provided (`updater`).


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/updaters/update.jl#L54-L59" target="_blank" rel="noreferrer">source</a></Badge>



```julia
update(updater::T, mat, n::I)
```


Returns a sequence of length `n` where the original neutral landscape `mat` is updated by the `NeutralLandscapeUpdater` `update` for `n` timesteps.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/updaters/update.jl#L65-L70" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.update!' href='#NeutralLandscapes.update!'><span class="jlbinding">NeutralLandscapes.update!</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
update!(updater::T, mat)
```


Updates a landscape `mat` in-place by directly mutating `mat`.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/updaters/update.jl#L81-L85" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.normalize' href='#NeutralLandscapes.normalize'><span class="jlbinding">NeutralLandscapes.normalize</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
normalize(mats::Vector{M})
```


Normalizes a vector of neutral landscapes `mats` such that all values between 0 and 1. Note that this does not preserve the `rate` parameter for a given `NeutralLandscapeUpdater`, and instead rescales it proportional to the difference between the total maximum and total minimum across all `mats`.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/updaters/update.jl#L35-L42" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.rate' href='#NeutralLandscapes.rate'><span class="jlbinding">NeutralLandscapes.rate</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
spatialupdater(up::NeutralLandscapeUpdater)
```


All `NeutralLandscapeUpdater`s have a field `rate` which defines the expected (or mean) change across all cells per timestep.  


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/updaters/update.jl#L9-L14" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.variability' href='#NeutralLandscapes.variability'><span class="jlbinding">NeutralLandscapes.variability</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
variability(up::NeutralLandscapeUpdater)
```


Returns the `variability` of a given `NeutralLandscapeUpdater`. The variability of an updater is how much temporal variation there will be in a generated time-series of landscapes.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/updaters/update.jl#L26-L32" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.spatialupdater' href='#NeutralLandscapes.spatialupdater'><span class="jlbinding">NeutralLandscapes.spatialupdater</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
spatialupdater(up::NeutralLandscapeUpdater)
```


All `NeutralLandscapeUpdater`&#39;s have a `spatialupdater` field which is either a `NeutralLandscapeMaker`, or `Missing` (in the case of temporally correlated updaters).


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/updaters/update.jl#L17-L23" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes._update' href='#NeutralLandscapes._update'><span class="jlbinding">NeutralLandscapes._update</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
_update(tvu::TemporallyVariableUpdater, mat)
```


Updates `mat` using temporally autocorrelated change, using the direction and rate parameters from `tvu`.

TODO: this doesn&#39;t have to be a Normal distribution, could be arbitrary distribution that is continuous and can have mean 0 (or that can be transformed to have mean 0)


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/updaters/temporal.jl#L14-L23" target="_blank" rel="noreferrer">source</a></Badge>



```julia
_update(sau::SpatiallyAutocorrelatedUpdater, mat; transform=ZScoreTransform)
```


Updates `mat` using spatially autocorrelated change, using the direction, rate, and spatial updater parameters from `sau`.

TODO: doesn&#39;t necessarily have to be a ZScoreTransform, could be arbitrary argument


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/updaters/spatial.jl#L19-L27" target="_blank" rel="noreferrer">source</a></Badge>



```julia
_update(stau::SpatiotemporallyAutocorrelatedUpdater, mat)
```


Updates `mat` using temporally autocorrelated change, using the direction, rate, and spatialupdater parameters from `stau`.

TODO: doesn&#39;t necessarily have to be a Normal distribution or ZScoreTransform, could be arbitrary argument


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/updaters/spatiotemporal.jl#L20-L28" target="_blank" rel="noreferrer">source</a></Badge>

</details>


## Other functions {#Other-functions}
<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.classify' href='#NeutralLandscapes.classify'><span class="jlbinding">NeutralLandscapes.classify</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
classify(array, weights[, mask])
```


Classify an array into proportions based upon a list of class weights.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/classify.jl#L22-L26" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.classify!' href='#NeutralLandscapes.classify!'><span class="jlbinding">NeutralLandscapes.classify!</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
classify!(array, weights[, mask])
```


Classify an array in-place into proportions based upon a list of class weights.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/classify.jl#L1-L5" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.blend' href='#NeutralLandscapes.blend'><span class="jlbinding">NeutralLandscapes.blend</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
blend(arrays[, scaling])
```


Blend arrays weighted by scaling factors.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/classify.jl#L49-L53" target="_blank" rel="noreferrer">source</a></Badge>



```julia
blend(clusterarray, arrays[, scaling])
```


Blend a primary cluster NLM with other arrays in which the mean value per  cluster is weighted by scaling factors.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/classify.jl#L62-L67" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.label' href='#NeutralLandscapes.label'><span class="jlbinding">NeutralLandscapes.label</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
label(mat[, neighborhood = :rook])
```


Assign an arbitrary label to all clusters of contiguous matrix elements with the same value. Returns a matrix of values and the total number of final clusters. The `neighborhood` structure can be  `:rook`     `:queen`    `:diagonal`  0 1 0        1 1 1        0 1 1  1 x 1        1 x 1        1 x 1  0 1 0        1 1 1        1 1 0  `:rook` is the default


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/classify.jl#L81-L92" target="_blank" rel="noreferrer">source</a></Badge>

</details>

<details class='jldocstring custom-block' open>
<summary><a id='NeutralLandscapes.mask!' href='#NeutralLandscapes.mask!'><span class="jlbinding">NeutralLandscapes.mask!</span></a> <Badge type="info" class="jlObjectType jlFunction" text="Function" /></summary>



```julia
mask!(array::AbstractArray{<:AbstractFloat}, maskarray::AbstractArray{<:AbstractBool})
```


Modifies `array` so that the positions at which `maskarray` is `false` are replaced by `NaN`.


<Badge type="info" class="source-link" text="source"><a href="https://github.com/EcoJulia/NeutralLandscapes.jl/blob/4f0eaae6fc678e0bdab3950d9520acab443555f0/src/landscape.jl#L37-L42" target="_blank" rel="noreferrer">source</a></Badge>

</details>

