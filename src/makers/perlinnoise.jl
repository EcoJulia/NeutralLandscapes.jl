"""
    PerlinNoise <: NeutralLandscapeMaker

    PerlinNoise(; kw...)
    PerlinNoise(periods, [octaves=1, lacunarity=2, persistance=0.5, valley=:u])

Create a Perlin noise neutral landscape model with values ranging 0-1.

# Keywords

- `periods::Tuple{Int,Int}=(1,1)`: the number of periods of Perlin noise across row and 
    column dimensions for the first octave.
- `octaves::Int=1`: the number of octaves that will form the Perlin noise.
- `lacunarity::Int=2` : the rate at which the frequency of periods increases for each 
    octive.
- `persistance::Float64=0.5` : the rate at which the amplitude of periods decreases for each 
    octive.
- `valley::Symbol=`:u`: the kind of valley bottom that will be mimicked: `:u` produces 
    u-shaped valleys, `:v` produces v-shaped valleys, and `:-` produces flat bottomed 
    valleys.

Note: This is a memory-intensive algorithm with some settings. Be careful using larger 
prime numbers for `period` when also using a large array size, high lacuarity and/or many 
octaves. Memory use scales with the lowest common multiple of `periods`.
"""
@kwdef struct PerlinNoise <: NeutralLandscapeMaker
    periods::Tuple{Int,Int} = (1, 1)
    octaves::Int = 1
    lacunarity::Int = 2
    persistance::Float64 = 0.5
    valley::Symbol = :u
    function PerlinNoise(periods, octaves=1, lacunarity=2, persistance=0.5, valley=:u)
        new(periods, octaves, lacunarity, persistance, valley)
    end
end

function _landscape!(A, alg::PerlinNoise)
    # nRow must equal nCol so determine the dimension of the smallest square
    dim = max(size(A)...)
    # Check the dim is a multiple of each octives maximum number of periods and 
    # expand dim if needed
    rperiodsmax = alg.periods[1] * alg.lacunarity^(alg.octaves - 1)
    cperiodsmax = alg.periods[2] * alg.lacunarity^(alg.octaves - 1)
    periodsmultiple = lcm(rperiodsmax, cperiodsmax) # lowest common multiple
    if dim % periodsmultiple != 0
        dim = ceil(Int, dim / periodsmultiple) * periodsmultiple
    end

    # Generate the Perlin noise
    noise = zeros(eltype(A), (dim, dim))
    meshbuf1 = Array{eltype(A),2}(undef, dim, dim)
    meshbuf2 = Array{eltype(A),2}(undef, dim, dim)
    nbufs = ntuple(_ -> Array{eltype(A),2}(undef, dim, dim), 4)
    for octave in 0:alg.octaves-1
        octave_noise!(noise, meshbuf1, meshbuf2, nbufs, alg, octave, dim, dim)
    end

    # Randomly extract the desired array size
    noiseview = _view_from_square(noise, size(A)...)

    # Rescale the Perlin noise to mimic different kinds of valley bottoms
    return if alg.valley == :u
        A .= noiseview
    elseif alg.valley == :v
        A .= abs.(noiseview)
    elseif alg.valley == :-
        A .= noiseview .^ 2
    else
        error("$(alg.valley) not recognised for `valley` use `:u`, `:v` or `:-`")
    end
end

function octave_noise!(
    noise, m1, m2, (n11, n21, n12, n22), alg::PerlinNoise, octave, nrow, ncol
)
    f(t) = @fastmath 6 * t^5 - 15 * t^4 + 10 * t^3 # Wut

    # Mesh
    rp, cp = alg.periods .* alg.lacunarity^(octave)
    delta = (rp / nrow, cp / ncol)
    ranges = range(0, rp - delta[1], length=nrow), range(0, cp - delta[2], length=ncol)
    _rem_meshes!(m1, m2, ranges...)

    # Gradients
    # This allocates, but the gradients size changes with octave so it needs to 
    # be a very smart in-place `repeat!` or some kind of generator, and the improvement 
    # may not be that large (~20%). 
    angles = 2pi .* rand(rp + 1, cp + 1)
    @fastmath gradients = cat(cos.(angles), sin.(angles); dims=3)
    d = (nrow ÷ rp, ncol ÷ cp)
    grad = repeat(gradients, inner=[d[1], d[2], 1])

    g111 = @view grad[1:ncol, 1:ncol, 1]
    g211 = @view grad[end-nrow+1:end, 1:ncol, 1]
    g121 = @view grad[1:ncol, end-ncol+1:end, 1]
    g221 = @view grad[end-nrow+1:end, end-ncol+1:end, 1]
    g112 = @view grad[1:ncol, 1:ncol, 2]
    g212 = @view grad[end-nrow+1:end, 1:ncol, 2]
    g122 = @view grad[1:ncol, end-ncol+1:end, 2]
    g222 = @view grad[end-nrow+1:end, end-ncol+1:end, 2]

    # Ramps
    n11 .= (m1 .* g111 .+ m2 .* g112)  # Bottom-left
    n21 .= ((m1 .- 1) .* g211 .+ m2 .* g212)  # Top-left
    n12 .= (m1 .* g121 .+ (m2 .- 1) .* g122)  # Bottom-right
    n22 .= ((m1 .- 1) .* g221 .+ (m2 .- 1) .* g222)  # Top-right

    # Interpolation
    m1 .= f.(m1)
    m2 .= f.(m2)
    noise .+= sqrt(2) .* (alg.persistance^octave) .*
              ((1 .- m2) .* (n11 .* (1 .- m1) .+ m1 .* n21) .+
               m2 .* (n12 .* (1 .- m1) .+ m1 .* n22))
    return noise
end

function _rem_meshes!(m1, m2, x, y)
    for (i, ival) in enumerate(x), j in 1:length(y)
        @fastmath m1[i, j] = ival % 1
    end
    for i in 1:length(x), (j, jval) in enumerate(y)
        @fastmath m2[i, j] = jval % 1
    end
    return
end

function _view_from_square(source, nrow, ncol)
    # Extract a portion of the array to match the dimensions
    dim = size(source, 1)
    startrow = rand(1:(dim-nrow+1))
    startcol = rand(1:(dim-ncol+1))
    return @view source[startrow:startrow+nrow-1, startcol:startcol+ncol-1]
end
