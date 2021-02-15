
"""
    classify!(array, weights[, classifyMask])

Classify an array into proportions based upon a list of class weights.
"""
function classify!(array, weights, mask = nothing)
    quantiles = zeros(length(weights))
    cumsum!(quantiles, weights)
    quantiles ./= quantiles[end]
    boundaryvalues = isnothing(mask) ?
        quantile(filter(isfinite, array), quantiles) :
        quantile(array[mask .& isfinite.(array)], quantiles)
    for i in eachindex(array)
        array[i] = isnan(array[i]) ? NaN : searchsortedfirst(boundaryvalues, array[i])
    end
    array
end

"""
    blend(arrays[, scaling])

Blend arrays weighted by scaling factors.
"""
function blend(arrays, scaling = ones(length(arrays)))
    ret = sum(arrays .* scaling)
    rescale!(ret)
end

function _clusterMean(clusterArray, array)

end

"""
    blendClusterArray(primary, arrays[, scaling])

Blend a primary cluster NLM with other arrays in which the mean value per 
cluster is weighted by scaling factors.
"""
function blendClusterArray(primary, arrays, scaling = ones(length(arrays)))

end


