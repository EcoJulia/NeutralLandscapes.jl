function w2cp(vec) 
    v = cumsum(vec)
    v ./= v[end]
end

function calcBoundaries(array, cumulativeProportions, classifyMask = nothing)
    maskedarray = isnothing(classifyMask) ? array : mask!(copy(array))
    nCells = count(isfinite, maskedarray)
    boundaryIndexes = ceil.(Int, cumulativeProportions * nCells)
    boundaryValues = sort(vec(maskedarray))[boundaryIndexes]
    boundaryValues
end

