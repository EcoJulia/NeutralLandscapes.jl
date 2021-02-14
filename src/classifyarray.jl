function w2cp(vec) 
    v = cumsum(vec)
    v ./ v[end]
end

function calcBoundaries(array, cumulativeProportions, classifyMask = nothing)
    if isnothing(classifyMask) 
        quantile(vec(array), cumulativeProportions) 
    else
        quantile(array[classifyMask], cumulativeProportions) 
    end
end

function classifyArray!(array, weights, classifyMask = nothing)
    cumulativeProportions = w2cp(weights)
    boundaryvalues = calcBoundaries(array, cumulativeProportions, classifyMask)
    for i in eachindex(array)
        array[i] = isnan(array[i]) ? NaN : searchsortedfirst(boundaryvalues, array[i])
    end
    array
end
