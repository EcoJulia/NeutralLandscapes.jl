"""
    RectangularCluster

Fills the landscape with rectangles containing a random value. The size of each
rectangle/patch is between `minimum` and `maximum` (the two can be equal for a
fixed size rectangle).
"""
struct RectangularCluster <: NeutralLandscapeMaker
    minimum::Int
    maximum::Int
    function RectangularCluster(x::Int, y::Int)
        @assert 0 < x <= y
        new(x, y)
    end
end

"""
    RectangularCluster()

When given no arguments, the rectangular clusters will have dimensions between 2
and 4.
"""
RectangularCluster() = RectangularCluster(2,4)

function _landscape!(mat, alg::RectangularCluster)
    mat .= -1.0
    while minimum(mat) == -1.0
        width, height = rand(alg.minimum:alg.maximum, 2)
        row = rand(1:(size(mat,1)-(width-1)))
        col = rand(1:(size(mat,2)-(height-1)))
        mat[row:(row+(width-1)) , col:(col+(height-1))] .= rand()
    end
    return mat
end
