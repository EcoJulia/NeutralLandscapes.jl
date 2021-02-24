using NeutralLandscapes, Test

algorithms = (
   DiamondSquare(),
   EdgeGradient(),
   MidpointDisplacement(),
   NearestNeighborElement(),
   NoGradient(),
   PerlinNoise(),
   PlanarGradient(),
   RectangularCluster(),
   WaveSurface(), 
)

sizes = (50, 200), (100, 100), (301, 87)

for alg in algorithms, sze in sizes
    A = rand(alg, sze)
    @test size(A) == sze 
end
