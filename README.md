# Neutral Landscapes

**Python source:** https://github.com/tretherington/nlmpy

This is a direct port of the NLMpy neutral landscape generation package to julia.
This code reproduces Fig 1 from the paper introducing the package: 

Etherington, T.R., Holland, E.P. & O’Sullivan, D. (2015) NLMpy: a python software package for the creation of neutral landscape models within a general numerical framework. _Methods in Ecology and Evolution_, __6__, 164–168.

```julia
using NeutralLandscapes, Plots
siz = 50, 50

# Random NLM
Fig1a = rand(NoGradient(), siz)
# Planar gradient NLM
Fig1b = rand(PlanarGradient(), siz)
# Edge gradient NLM
Fig1c = rand(EdgeGradient(), siz)
# Mask example
Fig1d = falses(siz)
Fig1d[10:25, 10:25] .= true
# Distance gradient NLM
Fig1e = rand(DistanceGradient(findall(vec(Fig1d))), siz)
# Midpoint displacement NLM
Fig1f = rand(MidpointDisplacement(0.75), siz)
# Random rectangular cluster NLM
Fig1g = rand(RectangularCluster(4, 8), siz)
# Random element nearest-neighbor NLM
Fig1h = rand(NearestNeighborElement(200), siz)
# Random cluster nearest-neighbor NLM
Fig1i = rand(NearestNeighborCluster(0.4), siz)
# Blended NLM
Fig1j = blend([Fig1f, Fig1c])
# Patch blended NLM
Fig1k = blend(Fig1h, Fig1e, 1.5)
# Classifiend random cluster nearest-neighbor NLM
Fig1l = classify(Fig1i, ones(4))
# Percolation NLM
Fig1m = classify(Fig1a, [1-0.5, 0.5])
# Binary random rectangular cluster NLM
Fig1n = classify(Fig1g, [1-0.75, 0.75])
# Classified midpoint displacement NLM
Fig1o = classify(Fig1f, ones(3))
# Classified midpoind displacement NLM, with limited classification
Fig1p = classify(Fig1f, ones(3), Fig1d)
# Masked planar gradient NLM
Fig1q = rand(PlanarGradient(90), siz, mask = Fig1n .== 2) #TODO mask as keyword + should mask be matrix or vec or both? (Fig1e)
# Hierarchical NLM
Fig1r = ifelse.(Fig1o .== 2, Fig1m .+ 2, Fig1o)
# Rotated NLM
Fig1s = rot(Fig1l) #TODO
# Transposed NLM
Fig1t = Fig1o'

gr(color = :fire, ticks = false, framestyle = :box, colorbar = false)
plot(
    heatmap(Fig1a), heatmap(Fig1b), heatmap(Fig1c), heatmap(Fig1d), heatmap(Fig1e),
    heatmap(Fig1f), heatmap(Fig1g), heatmap(Fig1h), heatmap(Fig1i), heatmap(Fig1j), 
    heatmap(Fig1k), heatmap(Fig1l), heatmap(Fig1m), heatmap(Fig1n), heatmap(Fig1o),
    heatmap(Fig1p), heatmap(Fig1q), heatmap(Fig1r), heatmap(Fig1t), heatmap(Fig1t),
    layout = (4,5), size = (1600, 1300)
)
```
![Fig1](https://user-images.githubusercontent.com/8429802/109274687-1613af80-7814-11eb-8a58-1fb0ee43c7e2.png)