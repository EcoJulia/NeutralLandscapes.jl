
rescale!(mat) = (mat .- NaNMath.minimum(mat)) ./ (NaNMath.maximum(mat) - NaNMath.minimum(mat))

function mask!(array::AbstractArray{<:Float64}, maskarray::AbstractArray{<:Bool}) 
    for i in eachindex(array, maskarray)
        array[i] = maskarray[i] ? array[i] : NaN
    end
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