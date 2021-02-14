function _w2cp(vec) 
    v = cumsum(vec)
    v ./ v[end]
end

function _calcBoundaries(array, cumulativeProportions, classifyMask = nothing)
    if isnothing(classifyMask) 
        quantile(vec(array), cumulativeProportions) 
    else
        quantile(array[classifyMask], cumulativeProportions) 
    end
end

"""
    classify!(array, weights[, classifyMask])

Classify an array into proportions based upon a list of class weights.
"""
function classify!(array, weights, classifyMask = nothing)
    cumulativeProportions = _w2cp(weights)
    boundaryvalues = _calcBoundaries(array, cumulativeProportions, classifyMask)
    for i in eachindex(array)
        array[i] = isnan(array[i]) ? NaN : searchsortedfirst(boundaryvalues, array[i])
    end
    array
end
