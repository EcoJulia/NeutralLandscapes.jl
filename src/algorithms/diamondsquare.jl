"""
    DiamondSquare

This type generates a neutral landscape using the diamond-sqaures
algorithm, which produces fractals with variable spatialautocorrelation.

https://en.wikipedia.org/wiki/Diamond-square_algorithm

The algorithm is named diamond-square because it is an iterative procedure of
"diamond" and "square" steps.



The degree of spatial autocorrelation is controlled by a parameter `H`,
which varies from 0.0 (low autocorrelation) to 1.0 (high autocorrelation) --- note this is non-inclusive and H = 0 and H = 1 will not behavive as expected.
The result of the diamond-square algorithm is a fractal with dimension D = 2 + H.

A similar algorithm, midpoint displacement *TODO link to mpd in docs*, almost
identically, except that in DiamondSquare, the ed
"""
struct DiamondSquare <: NeutralLandscapeMaker
    H::Float64
    function DiamondSquare(H::T) where {T <: Real}
        @assert 0 < H && H < 1
        new(H)
    end
end

"""
    MPD()

    Creates a midpoint-displacement algorithm object `MPD`.
"""
struct MPD <: NeutralLandscapeMaker
    H::Float64
    function MPD(H::T) where {T <: Real}
        @assert 0 < H && H < 1
        new(H)
    end
end

"""
    DiamondSquare()

Creates a `DiamondSquare` with neutral spatial autocorrelation.
"""
DiamondSquare() = DiamondSquare(0.5)

"""
    _landscape!(mat, alg::DiamondSquare; kw...)

    Check if `mat` is the right size and already initialized.
    If mat is not the correct size (DiamondSquare can only run on a lattice of size NxN where N = (2^n)+1 for integer n),
    allocates the smallest lattice large enough to contain `mat` that can run DiamondSquare.
    Will initialize `mat` to all zeros before running DiamondSquare if it is not initialized already.
"""
function _landscape!(mat, alg::Union{DiamondSquare, MPD}; kw...) where {IT <: Integer}

    rightSize::Bool = isPowerOfTwo(size(mat)[1]-1) && isPowerOfTwo(size(mat)[2]-1)
    latticeSize::Int = size(mat)[1]

    dsMat = mat
    if !rightSize
        dim1, dim2 = size(mat)
        smallestContainingLattice::Int = 2^ceil(log2(max(dim1, dim2))) + 1
        @warn "$alg cannot be run on the input dimensions ($dim1 x $dim2),
                and will instead run on the next smallest valid size ($smallestContainingLattice x $smallestContainingLattice).
                This can slow performance as it involves additional memory allocation."
        dsMat = zeros(smallestContainingLattice, smallestContainingLattice)
    end
    diamondsquare!(dsMat, alg)

    mat .= dsMat[1:size(mat)[1], 1:size(mat)[2]]
end

"""
    diamondsquare!(mat, alg::DiamondSquare)

    Runs the diamond-square algorithm on a matrix `mat` of size
    `NxN`, where `N=(2^n)+1` for some integer `n`, i.e (N=5,9,17,33,65)

    Diamond-square is an iterative procedure, where the lattice is divided
    into subsquares in subsequent rounds. At each round, the subsquares shrink in size,
    as previously uninitialized values in the lattice are interpolated as a mean of nearby points plus random displacement.
    As the rounds increase, the magnitude of this displacement decreases. This creates spatioautocorrelation, which is controlled
    by a single parameter `H` which varies between `0` (no autocorrelation) and `1` (high autocorrelation)

"""
function diamondsquare!(mat, alg)
    latticeSize::Int = size(mat)[1]
    numberOfRounds::Int = log2(latticeSize-1)
    initializeDiamondSquare!(mat, alg)

    for round in 0:(numberOfRounds-1)    # counting from 0 saves us a headache later
        subsquareSideLength::Int = 2^(numberOfRounds-(round))
        numberOfSubsquaresPerAxis::Int = ((latticeSize-1) / subsquareSideLength)-1

        # iterate over the subsquares within the lattice at this side length
        for x in 0:numberOfSubsquaresPerAxis
            for y in 0:numberOfSubsquaresPerAxis
                subsquareCorners = subsquareCornerCoordinates(x,y,subsquareSideLength)

                diamond!(mat, alg, round, subsquareCorners)
                square!(mat, alg, round, subsquareCorners)
            end
        end
    end
end


"""
    initializeDiamondSquare!(mat, alg)

    Initialize's the `DiamondSquare` algorithm by displacing the four corners of the
    lattice using `displace`, scaled by the algorithm's autocorrelation `H`.
"""
function initializeDiamondSquare!(mat, alg)
    latticeSize = size(mat)[1]
    corners = subsquareCornerCoordinates(0,0, latticeSize-1)
    for mp in corners
        mat[mp...] = displace(alg.H, 1)
        @assert isfinite(mat[mp...])

    end
end

"""
    subsquareCornerCoordinates(x::Int, y::Int, sideLength::Int)

    Returns the coordinates for the corners of the subsquare (x,y) given a side-length `sideLength`.
"""
function subsquareCornerCoordinates(x::Int, y::Int, sideLength::Int)
    corners = [(1+sideLength*x, 1+sideLength*y), (1+sideLength*(x+1), 1+sideLength*y), (1+sideLength*x, sideLength*(y+1)+1), (1+sideLength*(x+1), 1+sideLength*(y+1))]
end

"""
    centerCoordinate(corners::AbstractVector{Tuple{Int,Int}})

    Returns the center coordinate for a square defined by `corners` for the `DiamondSquare` algorithm.
"""
function centerCoordinate(corners::AbstractVector{Tuple{Int,Int}})
    bottomLeft,bottomRight,topLeft,topRight = corners
    x::Int = (bottomLeft[1]+bottomRight[1])/2
    y::Int = (topRight[2]+bottomRight[2])/2

    return (x,y)
end

"""
    edgeMidpointCoordinates(corners::AbstractVector{Tuple{Int,Int}})

    Returns an array of midpoints for a square defined by `corners` for the `DiamondSquare` algorithm.
"""
function edgeMidpointCoordinates(corners::AbstractVector{Tuple{Int,Int}})
    # bottom left, bottom right, top left, top right
    bottomLeft,bottomRight,topLeft,topRight = corners

    leftEdgeMidpoint::Tuple{Int,Int} = (bottomLeft[1], (bottomLeft[2]+topLeft[2])/2 )
    bottomEdgeMidpoint::Tuple{Int,Int} = ( (bottomLeft[1]+bottomRight[1])/2, bottomLeft[2])
    topEdgeMidpoint::Tuple{Int,Int} = ( (topLeft[1]+topRight[1])/2, topLeft[2] )
    rightEdgeMidpoint::Tuple{Int,Int} = ( bottomRight[1], (bottomRight[2]+topRight[2])/2)

    edgeMidpoints = [leftEdgeMidpoint, bottomEdgeMidpoint, topEdgeMidpoint, rightEdgeMidpoint]
    return edgeMidpoints
end


"""
    interpolate(mat, points::AbstractVector{Tuple{Int,Int}})

    Computes the mean of a set of points, represented as a list of indecies to a matrix `mat`.
"""
function interpolate(mat, points::AbstractVector{Tuple{Int,Int}})
    for pt in points
        @assert isfinite(mat[pt...])
    end

    return mean(collect(mat[pt...] for pt in points))
end

"""
     isPowerOfTwo(x::IT) where {IT <: Integer}

     Determines if `x`, an integer, can be expressed as `2^n`, where `n` is also an integer.
"""
function isPowerOfTwo(x::IT) where {IT <: Integer}
    return log2(x) == floor(log2(x))
end

"""
     diamond!(mat, alg::DiamondSquare, round::Int, corners::AbstractVector{Tuple{Int, Int}})

     Runs the diamond step of the `DiamondSquare` algorithm on the square defined by
     `corners` on the matrix `mat`. The center of the square is interpolated from the
     four corners, and is displaced. The displacement is drawn according to `alg.H` and round using `displace`
"""
function diamond!(mat, alg, round::Int, corners::AbstractVector{Tuple{Int, Int}})
    centerPt = centerCoordinate(corners)
    mat[centerPt...] = interpolate(mat, corners) + displace(alg.H, round)
    @assert isfinite(mat[centerPt...])
end

"""
    square!(mat, alg::DiamondSquare, round::Int, corners::AbstractVector{Tuple{Int,Int}})

    Runs the square step of the `DiamondSquare` algorithm on the square defined
    by `corners` on the matrix `mat`. The midpoint of each edge of this square is interpolated
    by computing the mean value of the two corners on the edge and the center of the square, and the
    displacing it. The displacement is drawn according to `alg.H` and round using `displace`

    Note that this is the function to change to implement `mpd`
"""
function square!(mat, alg::DiamondSquare, round::Int, corners::AbstractVector{Tuple{Int, Int}})
    bottomLeft,bottomRight,topLeft,topRight = corners
    leftEdge, bottomEdge, topEdge, rightEdge = edgeMidpointCoordinates(corners)
    centerPoint = centerCoordinate(corners)



    # NOTE: the only difference between mpd and diamond-square is that
    # mpd would not pass centerPoint to interpolate
    mat[leftEdge...] = interpolate(mat, [topLeft,bottomLeft,centerPoint]) + displace(alg.H, round)
    mat[bottomEdge...] = interpolate(mat, [bottomLeft,bottomRight,centerPoint]) + displace(alg.H, round)
    mat[topEdge...] = interpolate(mat, [topLeft,topRight,centerPoint]) + displace(alg.H, round)
    mat[rightEdge...] = interpolate(mat, [topRight,bottomRight,centerPoint]) + displace(alg.H, round)

    @assert isfinite(mat[leftEdge...])
    @assert isfinite(mat[rightEdge...])
    @assert isfinite(mat[bottomEdge...])
    @assert isfinite(mat[topEdge...])

end

function square!(mat, alg::MPD, round::Int, corners::AbstractVector{Tuple{Int, Int}})
    bottomLeft,bottomRight,topLeft,topRight = corners
    leftEdge, bottomEdge, topEdge, rightEdge = edgeMidpointCoordinates(corners)

    mat[leftEdge...] = interpolate(mat, [topLeft,bottomLeft]) + displace(alg.H, round)
    mat[bottomEdge...] = interpolate(mat, [bottomLeft,bottomRight]) + displace(alg.H, round)
    mat[topEdge...] = interpolate(mat, [topLeft,topRight]) + displace(alg.H, round)
    mat[rightEdge...] = interpolate(mat, [topRight,bottomRight]) + displace(alg.H, round)

    @assert isfinite(mat[leftEdge...])
    @assert isfinite(mat[rightEdge...])
    @assert isfinite(mat[bottomEdge...])
    @assert isfinite(mat[topEdge...])

end

"""
    displace(H::Float64, round::Int)

    `displace` produces a random value as a function of  `H`, which is the
    autocorrelation parameter used in `DiamondSquare` and must be between `0`
    and `1`, and `round` which describes the current tiling size for the
    DiamondSquare() algorithm.

    Random value are drawn from a Gaussian distribution using `Distribution.Normal`
    The standard deviation of this Gaussian, σ, is set to (1/2)^(round*H), which will
    move from 1.0 to 0 as `round` increases.

"""
function displace(H::Float64, round::Int)
    σ = (0.5)^(round*H)
    return(rand(Normal(0, σ)))
end
