# NeutralLandscapes.jl

A pure Julia port of https://github.com/tretherington/nlmpy

## Landscape models

```@docs
NeutralLandscapeMaker
DiamondSquare
DiscreteVoronoi
DistanceGradient
EdgeGradient
MidpointDisplacement
NearestNeighborCluster
NearestNeighborElement
NoGradient
PerlinNoise
PlanarGradient
RectangularCluster
WaveSurface
```

## Landscape generating function

```@docs
rand
rand!
```

## Other functions

```@docs
classify
classify!
blend
label
NeutralLandscapes.mask!
```
