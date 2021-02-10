
function rescale!(mat)
  mat .-= NaNMath.minimum(mat)
  mat ./= NaNMath.maximum(mat)
end 

function mask!(array::AbstractArray{<:Float64}, maskarray::AbstractArray{<:Bool}) 
    array[.!maskarray] .= NaN
    array
end

"""
    landscape(alg, s::Tuple{IT,IT}=(10,30)) where {IT <: Integer}

Creates a landscape of size `s` following the model defined by `alg`. The
additional arguments `kw...` are passed to the post-processing function, see the
documentation of **TODO**. 
"""
function landscape(alg, size; mask = nothing, kw...) 
    ret = Matrix{Float64}(undef, size...)
    landscape!(ret, alg; mask = mask, kw...)
end

"""
    landscape!(mat, alg) where {IT <: Integer}

Fill the matrix `mat` with a landscape of size `s` following the model defined by `alg`. The
additional arguments `kw...` are passed to the post-processing function, see the
documentation of **TODO**. 
"""
function landscape!(mat, alg; mask = nothing, kw...)
  _landscape!(mat, alg; kw...)
  isnothing(mask) || mask!(mat, mask)
  rescale!(mat)
end