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

## Rectangular cluster

```@example gallery
heatmap(rand(RectangularCluster(), (45, 45)))
```

## Diamond Square
```@example gallery
heatmap(rand!(zeros(65,65), DiamondSquare()))
```
