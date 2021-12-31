"""
    RectangularCluster <: NeutralLandscapeMaker

    RectangularCluster(; minimum=2, maximum=4)
    RectangularCluster(minimum, [maximum=4])

Fills the landscape with rectangles containing a random value. The size of each
rectangle/patch is between `minimum` and `maximum` (the two can be equal for a
fixed size rectangle).
"""
@kwdef struct RectangularCluster <: NeutralLandscapeMaker
    minimum::Integer = 2
    maximum::Integer = 4
    function RectangularCluster(minimum::T, maximum::T=4) where {T <: Integer}
        @assert 0 < minimum <= maximum
        new(minimum, maximum)
    end
end

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
