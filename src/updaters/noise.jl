
# Kasdin, N. J. (1995). 
# Discrete simulation of colored noise and stochastic processes and 1/f^α power
# law noise generation. Proceedings of the IEEE, 83(5), 802-827. 
@kwdef struct NoiseGenerator{I<:Integer,F<:AbstractFloat}
    signal::Function = x -> x 
    timesteps::I = 100 
    α::F = 2.0
    noise_ratio::F = 0.25
end

function _pulse_values(α, n)
    H = zeros(n)
    H[begin] = 1.0 
    for i in eachindex(H)[2:end]
        H[i] = (H[i-1]) * 0.5α  * (i - 1)/i
    end 
    return H
end

# Ensures noise has mean 0 and std. dev. 1.
function standardize!(x) 
    x ./= sum(x)
    x ./= std(x)
    x .-= mean(x)
    return x
end 

function _generate_signal(ng::NoiseGenerator{I,F}) where {I,F}
    signal = F[ng.signal(x) for x in 1:ng.timesteps]  
    signal .-= mean(signal)
    signal ./= std(signal)
    return signal
end 

function _generate_noise(ng::NoiseGenerator{I,F}) where {I,F}
    # The original algorithm doubles the sequence length for numerical stability
    # of FFT recovering frequency over the 1:n interval for pulse value  
    n = ng.timesteps
    H, W = _pulse_values(ng.α, 2n), Distributions.rand(Normal(0,1), 2n)
    H_ft, W_ft = imag.([fft(H), fft(W)])
    convolved_frequency_spectrum = H_ft .* W_ft
    noise = imag.(ifft(convolved_frequency_spectrum))[1:n] 
    standardize!(noise)
    return noise
end 

function Base.rand(ng::NoiseGenerator{I,F}) where {I,F}
    signal = _generate_signal(ng)
    noise = _generate_noise(ng)
    return ng.noise_ratio * noise .+ signal
end 