using Distributions, FFTW, Plots

function exponential_increase(α, n)
    H = zeros(2n)
    H[begin] = 1.0 
    for i in eachindex(H)[2:end]
        H[i] = (1+H[i-1]) * 0.5α  * (i - 1)/i
    end 
    H
end

signal(f, n) = [Float32(f(i)) for i in 1:n]
white_noise(n) = rand(Normal(0,1), 2n) 

n = 300
noise_mag = 0.05

α = 2.

H = exponential_increase(α, n)
W = white_noise(n)

H_ft, W_ft = fft(H), fft(W)
noise_spectra = H_ft .* W_ft

# choose real or im here, the only difference is π/2
noise = real.(ifft(noise_spectra))[1:n] 

noise ./= std(noise)
noise .-= mean(noise)

x = signal(x->sin(0.2x)+0.0005x,n) 
x ./= sum(x)
x .-= mean(x)

X = x .+ noise_mag*noise


plot(x, label="signal")
plot!(noise .* noise_mag, label="noise")
plot!(x.+noise_mag*noise, label="received")