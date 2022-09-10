import Random.rand!

"""
    NeutralLandscapeMaker

Abstract supertype that all algorithms are descended from. A new
algorithm must minimally implement a `_landscape!` method for this type.
"""
abstract type NeutralLandscapeMaker end

"""
    rand(alg, dims::Tuple{Vararg{Int64,2}}; mask=nothing) where {T <: Integer}

Creates a landscape of size `dims` (a tuple of two integers) following the model
defined by `alg`. The `mask` argument accepts a matrix of boolean values, and is
passed to `mask!` if it is not `nothing`. 
"""
function Base.rand(alg::T, dims::Tuple{Int64,Int64}; mask=nothing) where {T <: NeutralLandscapeMaker}
    ret = Matrix{Float64}(undef, dims...)
    rand!(ret, alg; mask=mask)
end
Base.rand(alg::T, dims::Integer...; mask=nothing) where {T <: NeutralLandscapeMaker} = rand(alg, dims; mask = mask)

"""
    rand!(mat, alg) where {IT <: Integer}

Fill the matrix `mat` with a landscape created following the model defined by
`alg`. The `mask` argument accepts a matrix of boolean values, and is passed to
`mask!` if it is not `nothing`. 
"""
function rand!(mat::AbstractArray{<:AbstractFloat,2} where N, alg::T; mask=nothing) where {T <: NeutralLandscapeMaker}
    _landscape!(mat, alg)
    isnothing(mask) || mask!(mat, mask)
    _rescale!(mat)
end

"""
    mask!(array::AbstractArray{<:AbstractFloat}, maskarray::AbstractArray{<:AbstractBool}) 

Modifies `array` so that the positions at which `maskarray` is `false` are
replaced by `NaN`.
"""
function mask!(array::AbstractArray{<:Float64}, maskarray::AbstractArray{<:Bool}) 
    (size(array) == size(maskarray)) || throw(DimensionMismatch("The dimensions of array, $(size(array)), and maskarray, $(size(maskarray)), must match. "))
    array[.!maskarray] .= NaN
    return array
end


# Changes the matrix `mat` so that it is between `0` and `1`.
function _rescale!(mat)
    mn, mx = NaNMath.extrema(mat)
    mat .= (mat .- mn) ./ (mx - mn)
end 
