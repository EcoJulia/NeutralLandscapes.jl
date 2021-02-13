"""
    PerlinNoise
    PerlinNoise(; kw...)

Create a Perlin noise neutral landscape model with values ranging 0-1.

# Keywords

- `periods::Tuple{Int,Int}`: the number of periods of Perlin noise across row and 
    column dimensions for the first octave.
- `octaves::Int`: the number of octaves that will form the Perlin noise.
- `lacunarity::Int` : the rate at which the frequency of periods increases for each octive.
- `persistance::Real` : The rate at which the amplitude of periods decreases for each octive.
- `valley::String`: The kind of valley bottom that will be mimicked: `:u` (the defualt) 
    produces u-shaped valleys, `:v` produces v-shaped valleys, and `:-` 
    produces flat bottomed valleys.
"""
Base.@kwdef struct PerlinNoise{PT<:Real} <: NeutralLandscapeMaker 
    periods::Tuple{Int,Int}
    octaves::Int = 1
    lacunarity::Int = 2
    persistance::PT = 0.5
    valley::Symbol = :u
end

function _landscape!(A, alg::PerlinNoise)
    # nRow must equal nCol so determine the dimension of the smallest square
    dim = max(size(A)...)
    # Check the dim is a multiple of each octives maximum number of periods and 
    # expand dim if needed
    rperiodsmax = alg.periods[1] * alg.lacunarity^(alg.octaves - 1)
    cperiodsmax = alg.periods[2] * alg.lacunarity^(alg.octaves - 1)
    periodsmultiple = lcm(rperiodsmax, cperiodsmax) # lowest commom multiple
    if dim % periodsmultiple != 0
        dim = ceil(Int, dim / periodsmultiple) * periodsmultiple
    end

    # Generate the Perlin noise
    noise = zeros((dim, dim))
    for octave in alg.octaves
        newnoise = octave_noise(alg, octave, dim, dim)
        @show size(newnoise)
        @show size(noise)
        noise .+= newnoise
    end
    # If needed randomly extract the desired array size
    if size(A) != size(noise)
        noise = extract_from_square(noise, size(A))    
    end
    
    # Rescale the Perlin noise to mimic different kinds of valley bottoms
    return if alg.valley == :u
        noise
    elseif alg.valley == :v
        abs(noise)
    elseif alg.valley == :-
        noise ^ 2
    end
end

meshgrid(x, y) = [i for i in x, j in 1:length(y)], [j for i in 1:length(x), j in y]

function octave_noise(alg::PerlinNoise, octave, nrow, ncol)        
    f(t) = 6 * t ^ 5 - 15 * t ^ 4 + 10 * t ^ 3 # Wut

    rp, cp = alg.periods .* alg.lacunarity^octave
    # rp, cp = (2,3) .* 2^1
    delta = (rp / nrow, cp / ncol)
    d = (nrow ÷ rp, ncol ÷ cp)
    mg = meshgrid(0:delta[1]:rp-delta[1], 0:delta[2]:cp-delta[2])
    grid = cat(mg...; dims=3) .% 1
    size(grid)
    # Gradients
    angles = 2pi .* rand(rp + 1, cp + 1)
    size(angles)
    gradients = cat(cos.(angles), sin.(angles); dims=3)
    gradients = repeat(gradients, outer=[d[1], d[2], 1])
    heatmap(gradients)
    size(gradients)
    g00 = gradients[1:end-d[1], 1:end-d[2], :]
    g01 = gradients[1:end-d[1], d[2]+1:end, :]
    g10 = gradients[d[1]+1:end,   1:end-d[2], :]
    g11 = gradients[d[1]+1:end,   d[2]+1:end, :]
    size(g00)
    size(g01)
    size(g10)
    size(g11)
    # Ramps
    n00 = sum(cat(grid[:, :, 1],      grid[:, :, 1]     ; dims=3) .* g00, dims=3)
    n10 = sum(cat(grid[:, :, 1] .- 1, grid[:, :, 1]     ; dims=3) .* g10, dims=3)
    n01 = sum(cat(grid[:, :, 1],      grid[:, :, 1] .- 1; dims=3) .* g01, dims=3)
    n11 = sum(cat(grid[:, :, 1] .- 1, grid[:, :, 1] .- 1; dims=3) .* g11, dims=3)
    # Interpolation
    t = f.(grid)
    n0 = n00 .* (1 .- t[:, :, 1]) .+ t[:, :, 1] .* n10
    n1 = n01 .* (1 .- t[:, :, 1]) .+ t[:, :, 1] .* n11
    octave = sqrt(2) .* ((1 .- t[:, :, 1]) .* n0 .+ t[:, :, 1] .* n1)
    return dropdims(octave .* (alg.persistance .^ octave); dims=3)
end

function extract_from_square(A, ncol, nrow)
    # Extract a portion of the array to match the dimensions
    dim = size(A, 1)
    startrow = rand(1:(dim - nrow + 1))
    startcol = rand(1:(dim - ncol + 1))
    return A[startrow:startrow + nrow - 1, startcol:startcol + ncol - 1]
end
