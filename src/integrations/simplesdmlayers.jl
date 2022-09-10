@info "Loading NeutralLandscapes support for SimpleSDMLayers.jl..."

function NeutralLandscapes.mask!(array::AbstractArray{<:Float64}, masklayer::T) where {T<:SimpleSDMLayers.SimpleSDMLayer} 
    I = findall(isnothing, masklayer.grid)
    array[I] .= NaN
    return array
end
