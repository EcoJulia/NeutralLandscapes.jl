
```julia
using NeutralLandscapes
using Plots

function demolandscape(alg::T) where {T <: NeutralLandscapeMaker}
    heatmap(rand(alg, (200, 200)), frame=:none, aspectratio=1, c=:davos)
end
```


```ansi
demolandscape (generic function with 1 method)
```


## No gradient {#No-gradient}

```julia
demolandscape(NoGradient())
```

![](hzxpsrm.png){width=600px height=400px}

## Planar gradient {#Planar-gradient}

```julia
demolandscape(PlanarGradient(35))
```

![](foskcwl.png){width=600px height=400px}

## Edge gradient {#Edge-gradient}

```julia
demolandscape(EdgeGradient(186))
```

![](gbxsywa.png){width=600px height=400px}

## Wave surface {#Wave-surface}

```julia
demolandscape(WaveSurface(35, 3))
```

![](cjvhihh.png){width=600px height=400px}

## Rectangular cluster {#Rectangular-cluster}

```julia
demolandscape(RectangularCluster())
```

![](xqmmtkc.png){width=600px height=400px}

## Distance gradient {#Distance-gradient}

```julia
sources = unique(rand(1:40000, 50))
demolandscape(DistanceGradient(sources))
```

![](rpngypb.png){width=600px height=400px}

## Nearest-neighbor element {#Nearest-neighbor-element}

```julia
heatmap(rand(NearestNeighborElement(20, 1), (45, 45)))
```

![](sjxsuva.png){width=600px height=400px}

## Voronoi {#Voronoi}

```julia
demolandscape(DiscreteVoronoi(40))
```

![](tybujik.png){width=600px height=400px}

## Perlin Noise {#Perlin-Noise}

```julia
demolandscape(PerlinNoise())
```

![](oqddydh.png){width=600px height=400px}

## Classify landscape {#Classify-landscape}

```julia
sources = unique(rand(1:40000, 50))
heatmap(NeutralLandscapes.classify!(rand(DistanceGradient(sources), (200, 200)), [0.5, 1, 1, 0.5]))
```

![](khbufqh.png){width=600px height=400px}

## Diamond Square {#Diamond-Square}

```julia
demolandscape(DiamondSquare())
```

![](hnrvgxc.png){width=600px height=400px}

## Midpoint Displacement {#Midpoint-Displacement}

```julia
demolandscape(MidpointDisplacement())
```

![](tbxekav.png){width=600px height=400px}
