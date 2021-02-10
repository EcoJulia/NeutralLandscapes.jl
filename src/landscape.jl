
function rescale!(mat)
  mat .-= NaNMath.minimum(mat)
  mat ./= NaNMath.maximum(mat)
end 

function mask!(array::AbstractArray{<:Float64}, maskarray::AbstractArray{<:Bool}) 
    array[.!maskarray] .= NaN
    array
end

function landscape(alg, size; mask = nothing, kw...) 
    ret = Matrix{Float64}(undef, size...)
    landscape!(ret, alg; mask = mask, kw...)
  end
  
  function landscape!(mat, alg; mask = nothing, kw...)
    _landscape!(mat, alg; kw...)
    isnothing(mask) || mask!(mat, mask)
    rescale!(mat)
  end