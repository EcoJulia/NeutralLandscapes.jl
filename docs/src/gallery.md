```@example gallery
using NeutralLandscapes
using Plots

function demolandscape(alg::T) where {T <: NeutralLandscapeMaker}
    heatmap(rand(alg, (200, 200)), frame=:none, aspectratio=1, c=:davos)
end
```

## No gradient

```@example gallery
demolandscape(NoGradient())
```

## Planar gradient

```@example gallery
demolandscape(PlanarGradient(35))
```

## Edge gradient

```@example gallery
demolandscape(EdgeGradient(186))
```

## Wave surface

```@example gallery
demolandscape(WaveSurface(35, 3))
```

## Distance gradient

```@example gallery
sources = unique(rand(1:40000, 50))
demolandscape(DistanceGradient(sources))
```

## Rectangular cluster

```@example gallery
demolandscape(RectangularCluster())
```
