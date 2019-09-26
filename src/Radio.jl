module Radio

import DSP: FIRFilter, filt

abstract type Modulation end

include( "AGC.jl" )
include( "coding.jl" )
include( "PLL.jl" )
include( "PSK.jl" )
include( "QAM.jl" )
include( "Nyquist.jl" )
include( "Modem.jl" )

export
    AGC,
    Modem,
    PSK,
    QAM,
    exec,
    modulate,
    demodulate

end # Radio module
