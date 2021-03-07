"""
    DiamondSquare <: NeutralLandscapeMaker

    DiamondSquare(; H = 0.5) 
    DiamondSquare(H) 

This type generates a neutral landscape using the diamond-squares
algorithm, which produces fractals with variable spatial autocorrelation.

https://en.wikipedia.org/wiki/Diamond-square_algorithm

The algorithm is named diamond-square because it is an iterative procedure of
"diamond" and "square" steps.


The degree of spatial autocorrelation is controlled by a parameter `H`,
which varies from 0.0 (low autocorrelation) to 1.0 (high autocorrelation) --- 
note this is non-inclusive and H = 0 and H = 1 will not behave as expected.
The result of the diamond-square algorithm is a fractal with dimension D = 2 + H.

A similar algorithm, midpoint-displacement, functions almost
identically, except that in DiamondSquare, the square step interpolates
edge midpoints from the nearest two corners and the square's center, where as 
midpoint-displacement only intepolates from the nearest corners (see `MidpointDisplacement`).

"""
@kwdef struct DiamondSquare <: NeutralLandscapeMaker
    H::Float64 = 0.5
    function DiamondSquare(H::T) where {T <: Real}
        @assert 0 <=  H < 1
        new(H)
    end
end

"""
    MidpointDisplacement <: NeutralLandscapeMaker

    MidpointDisplacement(; H = 0.5)

Creates a midpoint-displacement algorithm object `MidpointDisplacement`. 
The degree of spatial autocorrelation is controlled by a parameter `H`,
which varies from 0.0 (low autocorrelation) to 1.0 (high autocorrelation) --- 
note this is non-inclusive and H = 0 and H = 1 will not behavive as expected.

A similar algorithm, diamond-square, functions almost
identically, except that in diamond-square, the square step interpolates
edge midpoints from the nearest two corners and the square's center, where as 
`MidpointDisplacement` only intepolates from the nearest corners (see `DiamondSquare`).
"""
@kwdef struct MidpointDisplacement <: NeutralLandscapeMaker
    H::Float64 = 0.5
    function MidpointDisplacement(H::T) where {T <: Real}
        @assert 0 <= H < 1
        new(H)
    end
end

# Check if `mat` is the right size. If mat is not the correct size (DiamondSquare
# can only run on a lattice of size NxN where N = (2^n)+1 for integer n),
# allocates the smallest lattice large enough to contain `mat` that can run
# DiamondSquare.
function _landscape!(mat, alg::Union{DiamondSquare, MidpointDisplacement}; kw...) where {IT <: Integer}

    rightSize::Bool = _isPowerOfTwo(size(mat)[1]-1) && _isPowerOfTwo(size(mat)[2]-1)
    latticeSize::Int = size(mat)[1]

    dsMat = mat
    if !rightSize
        dim1, dim2 = size(mat)
        smallestContainingLattice::Int = 2^ceil(log2(max(dim1, dim2))) + 1
        dsMat = zeros(smallestContainingLattice, smallestContainingLattice)
    end
    _diamondsquare!(dsMat, alg)

    mat .= dsMat[1:size(mat)[1], 1:size(mat)[2]]
end

# Runs the diamond-square algorithm on a matrix `mat` of size
# `NxN`, where `N=(2^n)+1` for some integer `n`, i.e (N=5,9,17,33,65)

# Diamond-square is an iterative procedure, where the lattice is divided
# into subsquares in subsequent rounds. At each round, the subsquares shrink in size,
# as previously uninitialized values in the lattice are interpolated as a mean of nearby points plus random displacement.
# As the rounds increase, the magnitude of this displacement decreases. This creates spatioautocorrelation, which is controlled
# by a single parameter `H` which varies between `0` (no autocorrelation) and `1` (high autocorrelation)
function _diamondsquare!(mat, alg)
    latticeSize = size(mat)[1]
    numberOfRounds::Int = log2(latticeSize-1)
    _initializeDiamondSquare!(mat, alg)

    for round in 0:(numberOfRounds-1)    # counting from 0 saves us a headache later
        subsquareSideLength::Int = 2^(numberOfRounds-(round))
        numberOfSubsquaresPerAxis::Int = ((latticeSize-1) / subsquareSideLength)-1

        for x in 0:numberOfSubsquaresPerAxis         # iterate over the subsquares within the lattice at this side length
            for y in 0:numberOfSubsquaresPerAxis
                subsquareCorners = _subsquareCornerCoordinates(x,y,subsquareSideLength)

                _diamond!(mat, alg, round, subsquareCorners)
                _square!(mat, alg, round, subsquareCorners)
            end
        end
    end
end

# Initialize's the `DiamondSquare` algorithm by displacing the four corners of the
# lattice using `displace`, scaled by the algorithm's autocorrelation `H`.
function _initializeDiamondSquare!(mat, alg)
    latticeSize = size(mat)[1]
    corners = _subsquareCornerCoordinates(0,0, latticeSize-1)
    for mp in corners
        mat[mp...] = _displace(alg.H, 1)
    end
end

# Returns the coordinates for the corners of the subsquare (x,y) given a side-length `sideLength`.
function _subsquareCornerCoordinates(x::Int, y::Int, sideLength::Int)
    corners = [1 .+ sideLength.*i for i in [(x,y), (x+1, y), (x, y+1), (x+1, y+1)]]
end

# Runs the diamond step of the `DiamondSquare` algorithm on the square defined by
# `corners` on the matrix `mat`. The center of the square is interpolated from the
# four corners, and is displaced. The displacement is drawn according to `alg.H` and round using `displace`
function _diamond!(mat, alg, round::Int, corners::AbstractVector{Tuple{Int, Int}})
    centerPt = _centerCoordinate(corners)
    mat[centerPt...] = _interpolate(mat, corners) + _displace(alg.H, round)
end

# Runs the square step of the `DiamondSquare` algorithm on the square defined
# by `corners` on the matrix `mat`. The midpoint of each edge of this square is interpolated
# by computing the mean value of the two corners on the edge and the center of the square, and the
# displacing it. The displacement is drawn according to `alg.H` and round using `displace`
function _square!(mat, alg::DiamondSquare, round::Int, corners::AbstractVector{Tuple{Int, Int}})
    bottomLeft,bottomRight,topLeft,topRight = corners
    leftEdge, bottomEdge, topEdge, rightEdge = _edgeMidpointCoordinates(corners)
    centerPoint = _centerCoordinate(corners)

    mat[leftEdge...] = _interpolate(mat, [topLeft,bottomLeft,centerPoint]) + _displace(alg.H, round)
    mat[bottomEdge...] = _interpolate(mat, [bottomLeft,bottomRight,centerPoint]) + _displace(alg.H, round)
    mat[topEdge...] = _interpolate(mat, [topLeft,topRight,centerPoint]) + _displace(alg.H, round)
    mat[rightEdge...] = _interpolate(mat, [topRight,bottomRight,centerPoint]) + _displace(alg.H, round)
end

# Runs the square step of the `MidpointDisplacement` algorithm on the square defined
# by `corners` on the matrix `mat`. The midpoint of each edge of this square is interpolated
# by computing the mean value of the two corners on the edge and the center of the square, and the
# displacing it. The displacement is drawn according to `alg.H` and round using `displace`
function _square!(mat, alg::MidpointDisplacement, round::Int, corners::AbstractVector{Tuple{Int, Int}})
    bottomLeft,bottomRight,topLeft,topRight = corners
    leftEdge, bottomEdge, topEdge, rightEdge = _edgeMidpointCoordinates(corners)
    mat[leftEdge...] = _interpolate(mat, [topLeft,bottomLeft]) + _displace(alg.H, round)
    mat[bottomEdge...] = _interpolate(mat, [bottomLeft,bottomRight]) + _displace(alg.H, round)
    mat[topEdge...] = _interpolate(mat, [topLeft,topRight]) + _displace(alg.H, round)
    mat[rightEdge...] = _interpolate(mat, [topRight,bottomRight]) + _displace(alg.H, round)
end

# Computes the mean of a set of points, represented as a list of indecies to a matrix `mat`.
function _interpolate(mat, points::AbstractVector{Tuple{Int,Int}})
    return mean(mat[pt...] for pt in points)
end

# `displace` produces a random value as a function of  `H`, which is the
# autocorrelation parameter used in `DiamondSquare` and must be between `0`
# and `1`, and `round` which describes the current tiling size for the
# DiamondSquare() algorithm.

# Random value are drawn from a Gaussian distribution using `Distribution.Normal`
# The standard deviation of this Gaussian, σ, is set to (1/2)^(round*H), which will
# move from 1.0 to 0 as `round` increases.
function _displace(H::Float64, round::Int)
    σ = 0.5^(round*H)
    return(rand(Normal(0, σ)))
end

# Returns the center coordinate for a square defined by `corners` for the
# `DiamondSquare` algorithm.
function _centerCoordinate(corners::AbstractVector{Tuple{Int,Int}})
    bottomLeft,bottomRight,topLeft,topRight = corners
    centerX::Int = (_xcoord(bottomLeft)+_xcoord(bottomRight)) ÷ 2
    centerY::Int = (_ycoord(topRight)+_ycoord(bottomRight)) ÷ 2
    return (centerX, centerY)
end

# Returns the x-coordinate from a lattice coordinate `pt`.
_xcoord(pt::Tuple{Int,Int}) = pt[1]
# Returns the y-coordinate from a lattice coordinate `pt`.
_ycoord(pt::Tuple{Int,Int}) = pt[2]

# Returns an array of midpoints for a square defined by `corners` for the `DiamondSquare` algorithm.
function _edgeMidpointCoordinates(corners::AbstractVector{Tuple{Int,Int}})
    # bottom left, bottom right, top left, top right
    bottomLeft,bottomRight,topLeft,topRight = corners

    leftEdgeMidpoint::Tuple{Int,Int} = (_xcoord(bottomLeft), (_ycoord(bottomLeft)+_ycoord(topLeft))÷2 )
    bottomEdgeMidpoint::Tuple{Int,Int} = ( (_xcoord(bottomLeft)+ _xcoord(bottomRight))÷2, _ycoord(bottomLeft) )
    topEdgeMidpoint::Tuple{Int,Int} = ( (_xcoord(topLeft)+_xcoord(topRight))÷2, _ycoord(topLeft))
    rightEdgeMidpoint::Tuple{Int,Int} = ( _xcoord(bottomRight), (_ycoord(bottomRight)+_ycoord(topRight))÷2)

    edgeMidpoints = [leftEdgeMidpoint, bottomEdgeMidpoint, topEdgeMidpoint, rightEdgeMidpoint]
    return edgeMidpoints
end

# Determines if `x`, an integer, can be expressed as `2^n`, where `n` is also an integer.
function _isPowerOfTwo(x::IT) where {IT <: Integer}
    return x & (x-1) == 0
end
