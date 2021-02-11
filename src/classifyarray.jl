function w2cp(vec) 
    v = cumsum(vec)
    v ./= v[end]
end

