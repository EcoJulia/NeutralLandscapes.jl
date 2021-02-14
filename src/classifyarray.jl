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

