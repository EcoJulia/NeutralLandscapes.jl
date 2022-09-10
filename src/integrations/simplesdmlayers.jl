@info "Loading NeutralLandscapes support for SimpleSDMLayers.jl..."

"""
    NeutralLandscapes.mask!(array::AbstractArray{<:Float64}, masklayer::T) where {T<:SimpleSDMLayers.SimpleSDMLayer} 

Masks an `array` by the values of `nothing` in `masklayer`, where `masklayer` is
a `SimpleSDMLayer`

"""
function NeutralLandscapes.mask!(array::AbstractArray{<:Float64}, masklayer::T) where {T<:SimpleSDMLayers.SimpleSDMLayer} 
    I = findall(isnothing, masklayer.grid)
    array[I] .= NaN
    return array
end
