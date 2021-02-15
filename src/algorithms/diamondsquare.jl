"""
    DiamondSquare

This type generates a neutral landscape using the diamond-sqaures
algorithm, which produces fractals with variable spatialautocorrelation.

https://en.wikipedia.org/wiki/Diamond-square_algorithm

The algorithm is named diamond-square because it is an iterative procedure of
"diamond" and "square" steps. 



The degree of spatial autocorrelation is controlled by a parameter `H`,
which varies from 0.0 (low autocorrelation) to 1.0 (high autocorrelation).
The result of the diamond-square algorithm is a fractal with dimension D = 2 + H.
"""

struct DiamondSquare <: NeutralLandscapeMaker
    H::Float64
    DiamondSquare(H::T) where {T <: Real} = new(H-floor(H)) # enforce H ∈ [0,1]
end


"""
    DiamondSquare()

Creates a `DiamondSquare` with neutral spatial autocorrelation.
"""
DiamondSquare() = DiamondSquare(0.5)


function _landscape!(mat, alg::DiamondSquare; kw...) where {IT <: Integer}
    # diamond-squares only works on a square lattice of size N x N, 
    # where N = (2^n)+1 for some integer n. 
    latticeSize::Int = size(mat)[1]
    @assert isPowerOfTwo(latticeSize-1) && isPowerOfTwo(latticeSize-1) 
   
    numberOfRounds::Int = log2(latticeSize-1)
    initializeDiamondSquare!(mat, alg)

    for round in 0:(numberOfRounds-1)    # counting from 0 saves us a headache later
        subsquareSideLength::Int = 2^(numberOfRounds-(round))
        numberOfSubsquaresPerAxis::Int = ((latticeSize-1) / subsquareSideLength)-1

        for x in 0:numberOfSubsquaresPerAxis
            for y in 0:numberOfSubsquaresPerAxis
                subsquareCorners = cornerCoordinates(x,y,subsquareSideLength) 
                square!(mat, alg, round, subsquareCorners)
                diamond!(mat, alg, round, subsquareCorners)
            end
        end

    end
end

function initializeDiamondSquare!(mat, alg)
    latticeSize = size(mat)[1]
    corners = cornerCoordinates(0,0, latticeSize-1)
    for mp in corners
        mat[mp...] = displace(alg.H, 1)
    end
end

function cornerCoordinates(x::Int, y::Int, sideLength::Int)
    corners = [(1+sideLength*x, 1+sideLength*y), (1+sideLength*(x+1), 1+sideLength*y), (1+sideLength*x, sideLength*(y+1)+1), (1+sideLength*(x+1), 1+sideLength*(y+1))]
end

function centerCoordinate(corners::AbstractVector{Tuple{Int,Int}})
    bottomLeft,bottomRight,topLeft,topRight = corners
    x::Int = (bottomLeft[1]+bottomRight[1])/2
    y::Int = (topRight[2]+bottomRight[2])/2

    return (x,y)
end

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

function interpolate(mat, points::AbstractVector{Tuple{Int,Int}})
    return mean(collect(mat[pt...] for pt in points))
end

function isPowerOfTwo(x::IT) where {IT <: Integer}
    return log2(x) == floor(log2(x))
end

function diamond!(mat, alg::DiamondSquare, round::Int, corners::AbstractVector{Tuple{Int, Int}})
    centerPt = centerCoordinate(corners)
    latticeSize = size(mat)[1]
    mat[centerPt...] = interpolate(mat, corners) + displace(alg.H, round)
end

function square!(mat, alg::DiamondSquare, round::Int, corners::AbstractVector{Tuple{Int, Int}})
    latticeSize::Int = size(mat)[1]
    edgeMidpoints = (edgeMidpointCoordinates(corners))
    centerPoint = centerCoordinate(corners)

    leftEdge, bottomEdge, topEdge, rightEdge = edgeMidpoints
    bottomLeft,bottomRight,topLeft,topRight = corners

    mat[leftEdge...] = interpolate(mat, [topLeft,bottomLeft,centerPoint])+ displace(alg.H, round)
    mat[bottomEdge...] = interpolate(mat, [bottomLeft,bottomRight,centerPoint])+ displace(alg.H, round)
    mat[topEdge...] = interpolate(mat, [topLeft,topRight,centerPoint])+ displace(alg.H, round)
    mat[rightEdge...] = interpolate(mat, [topRight,bottomRight,centerPoint])+displace(alg.H, round)

end

function displace(H::Float64, round::Int)
    σ = (0.5)^(round*H)
    return(rand(Normal(0, σ)))
end
