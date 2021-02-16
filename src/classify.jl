
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

function _clusterMean(clusterArray, array)
    clusters = Dict{Float64, Float64}()
    clustersum = Dict{Float64, Float64}()
    for ind in eachindex(clusterArray, array)
        temp = clusterArray[ind]
        if !haskey(clusters, temp)
            clusters[temp] = clustersum[temp] = 0.0
        end
        clusters[temp] += 1.0
        clustersum[temp] += array[ind]          
    end
    for cl in keys(clusters)
        clustersum[cl] /= clusters[cl]
    end
    clustersum[NaN] = NaN
    _rescale!(get.(Ref(clustersum), clusterArray, NaN))
end

"""
    blend(arrays[, scaling])

Blend arrays weighted by scaling factors.
"""
function blend(arrays, scaling::AbstractVector{<:Number} = ones(length(arrays)))
    if length(scaling) != length(arrays)
        throw(DimensionMismatch("The array of landscapes (n = $(length(arrays))) and scaling (n = $(length(scaling)) must have the same length")
    end
    ret = sum(arrays .* scaling)
    _rescale!(ret)
end

"""
    blend(clusterarray, arrays[, scaling])

Blend a primary cluster NLM with other arrays in which the mean value per 
cluster is weighted by scaling factors.
"""
function blend(clusterarray, arrays, scaling::AbstractVector{<:Number} = ones(length(arrays)))
    ret = sum(_clusterMean.(Ref(clusterarray), arrays) .* scaling)
    _rescale!(clusterarray + ret)
end
