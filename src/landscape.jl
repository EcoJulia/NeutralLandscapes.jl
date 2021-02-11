import Random.rand!

"""
    _rescale!(mat)

Changes the matrix `mat` so that it is between `0` and `1`.
"""
function _rescale!(mat)
    mat .-= NaNMath.minimum(mat)
    mat ./= NaNMath.maximum(mat)
end 

"""
    mask!(array::AbstractArray{<:AbstractFloat}, maskarray::AbstractArray{<:AbstractBool}) 

Modifies `array` so that the positions at which `maskarray` is `false` are
replaced by `NaN`.
"""
function mask!(array::AbstractArray{<:Float64}, maskarray::AbstractArray{<:Bool}) 
    (size(array) == size(maskarray)) || throw(DimensionMismatch("The dimensions of array, $(size(array)), and maskarray, $(size(maskarray)), must match. "))
    array[.!maskarray] .= NaN
    array
end

"""
    rand(alg, dims::Tuple{Vararg{Int64,2}}; mask=nothing) where {T <: Integer}

Creates a landscape of size `dims` (a tuple of two integers) following the model
defined by `alg`. The `mask` argument accepts a matrix of boolean values, and is
passed to `mask!` if it is not `nothing`. 
"""
function Base.rand(alg, dims::Tuple{Vararg{Int64,2}}; mask=nothing) where {T <: Integer}
    ret = Matrix{Float64}(undef, dims...)
    rand!(ret, alg; mask=mask)
end

"""
    rand!(mat, alg) where {IT <: Integer}

Fill the matrix `mat` with a landscape created following the model defined by
`alg`. The `mask` argument accepts a matrix of boolean values, and is passed to
`mask!` if it is not `nothing`. 
"""
function rand!(mat, alg; mask=nothing)
    _landscape!(mat, alg)
    isnothing(mask) || mask!(mat, mask)
    _rescale!(mat)
end