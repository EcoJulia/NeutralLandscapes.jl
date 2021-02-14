```@example gallery
using NeutralLandscapes
using Plots
```

## No gradient

```@example gallery
heatmap(rand(NoGradient(), (45, 45)))
```

## Planar gradient

```@example gallery
heatmap(rand(PlanarGradient(), (45, 45)))
```

## Edge gradient

```@example gallery
heatmap(rand(EdgeGradient(), (45, 45)))
```

## Wave surface

```@example gallery
heatmap(rand(WaveSurface(), (45, 45)))
```

## Distance gradient

```@example gallery
sources = unique(rand(1:2025, 15))
heatmap(rand(DistanceGradient(sources), (45, 45)))
```

## Rectangular cluster

```@example gallery
heatmap(rand(RectangularCluster(), (45, 45)))
```
