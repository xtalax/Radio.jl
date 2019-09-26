module Radio
using Revise
using DSP, FFTW

abstract type Modulation end

include( "AGC.jl" )
include( "coding.jl" )
include( "PLL.jl" )
include( "PSK.jl" )
include( "QAM.jl" )
include( "raised_cosine.jl" )
include( "modem.jl" )
include( "noise.jl" )
include( "complex_z_transform.jl" )
include( "graphics.jl" )
include( "utils.jl" )


export
    AGC,
    Modem,
    PSK,
    QAM,
    exec,
    modulate,
    demodulate,
    pskmod,
    wgn,
    bandwidth
export plot_constellation, freqz, plot_spectrum
end # Radio module
