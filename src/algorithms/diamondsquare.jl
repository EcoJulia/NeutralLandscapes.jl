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

Creates a `DiamondSquare` that believes in centrism.
"""
DiamondSquare() = DiamondSquare(0.5)

function _landscape!(mat, alg::DiamondSquare; kw...) where {IT <: Integer}
    # diamond-squares only works on a square lattice of size N x N, 
    # where N =2^n for some integer n. 
    @assert isPowerOfTwo(size(mat)[1]) && isPowerOfTwo(size(mat)[2]) 
    latticeSize::Int = size(mat)[1]
    numberOfRounds::Int = log2(latticeSize)

    for i in 0:(numberOfRounds-1)    # counting from 0 saves us a headache later
        subsquareSideLength::Int = 2^(numberOfRounds-i)
        
        numberOfSubsquares::Int = latticeSize / subsquareSideLength

        @show subsquareSideLength, numberOfSubsquares
        # now we want to iterate over all squares of size sideLength x sideLength
        
        for x in 0:numberOfSubsquares
            for y in 0:numberOfSubsquares
                subsquareCorners = cornerCoordinates(x,y,subsquareSideLength) 
                square!(mat, alg, subsquareCorners)
                diamond!(mat, alg, subsquareCorners)
            end
        end

   
    end

    return mat
end

function cornerCoordinates(x::Int, y::Int, sideLength::Int)
    corners = [(sideLength*x, sideLength*y), (sideLength*(x+1), sideLength*y), (sideLength*x, sideLength*(y+1)), (sideLength*(x+1), sideLength*(y+1))]
end

function isPowerOfTwo(x::IT) where {IT <: Integer}
    return log2(x) == floor(log2(x))
end

function diamond!(mat, alg::DiamondSquare, corners::AbstractVector{Tuple{Int, Int}})
end

function square!(mat, alg::DiamondSquare, corners::AbstractVector{Tuple{Int, Int}})
    # compute the center of this square
    ll,lr,tl,tr = corners

end


