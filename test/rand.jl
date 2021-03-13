using NeutralLandscapes, Test

algorithms = (
   DiamondSquare(),
   DiamondSquare(; H=0.2),
   DiamondSquare(0.4),
   DiscreteVoronoi(),
   DiscreteVoronoi(; n=2),
   DiscreteVoronoi(3),
   DistanceGradient(),
   DistanceGradient(; sources=[2]),
   DistanceGradient([1, 2]),
   EdgeGradient(),
   EdgeGradient(; direction=120.0),
   EdgeGradient(90.0),
   MidpointDisplacement(),
   MidpointDisplacement(;),
   NearestNeighborElement(),
   NearestNeighborElement(; k=1),
   NearestNeighborElement(2),
   NearestNeighborCluster(),
   # NearestNeighborCluster(; n=:queen),
   NearestNeighborCluster(; n=:diagonal),
   NearestNeighborCluster(0.2, :diagonal),
   NoGradient(),
   PerlinNoise(),
   PerlinNoise(; octaves=3, lacunarity=3, persistance=0.3),
   PerlinNoise((1, 2), 3, 2, 0.2),
   PlanarGradient(),
   PlanarGradient(; direction=120.0),
   PlanarGradient(90),
   RectangularCluster(),
   RectangularCluster(; maximum=5),
   RectangularCluster(2),
   WaveSurface(), 
   WaveSurface(90.0), 
   WaveSurface(; periods=2), 
)

sizes = (50, 200), (100, 100), (301, 87)

for alg in algorithms, sze in sizes
    A = rand(alg, sze)
    @test size(A) == sze 
end
