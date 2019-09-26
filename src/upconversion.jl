#IQ to baseband

function upconvert(IQ::Vector{Complex{T}}; fc::Real, fs::Real) where T
    N = length(IQ)
    t = 0.0:(1/fs):(fs*(N-1))
    out = Vector{T}(undef, N)
    w = 2pi*fc
    Threads.@threads for i in 1:N
        out[i] = euler_baseband(IQ[i], t[i], w)
    end
    return out
end


euler_baseband(iq::Complex{T}, t::Real, w::Real) where T = cos(w*t)*real(iq) + sin(w*t)*imag(iq)
