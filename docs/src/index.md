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

## Temporal Change
```@docs 
    NeutralLandscapeUpdater
    TemporallyVariableUpdater
    SpatiallyAutocorrelatedUpdater
    SpatiotemporallyAutocorrelatedUpdater
    update
    update!
    spatialupdater,
    variability,
    rate
    normalize
```


## Other functions

```@docs
classify
classify!
blend
label
NeutralLandscapes.mask!
```
