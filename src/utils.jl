# utils
function bandwidth(signal, fs::Real = 1.0; dB::Real = -60)
    spectrum = DSP.periodogram( signal, fs = fs)
    spectrum = FFTW.fftshift( spectrum )
    power = 10 .*log10.(spectrum.power)
    f = freq(spectrum)
    overthresh = power .>= maximum(power)+dB
    (a,b) = findfirst(overthresh), findlast(overthresh)
    if (a == Nothing) | (b == Nothing )
        return Inf
    elseif (a == 1) | (b == length(power))
        return Inf
    else
        return f[b]-f[a]
    end
end
