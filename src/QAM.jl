################################################################################
#                                ____ ____ _  _                                #
#                                |  | |__| |\/|                                #
#                                |_\| |  | |  |                                #
################################################################################
struct QAM{M, T, I} <: Modulation
    m::I                              # Bits per symbol
    α::T                             # Symbol scaling factor
    β::T                             # Symbol offset
    constellation::Vector{ComplexF64}               # Constellation of symbols in original
    grayConstellation::Vector{ComplexF64}           # Constellation of symbols inn gray-code order
    bitsMap::Vector{I}                     # bitsMap[i] maps to constellation[i]
end

function QAM(M::I ) where {I<:Integer}
    isinteger(sqrt(M)) || error( "sqrt(M) must be an integer value" )
    m                 = int(log2( M ))
    width             = int(sqrt(M))
    constellation     = Array( Complex64, M )
    grayConstellation = Array( Complex64, M )
    bitsMap           = Array(UInt, M )
    α                 = 2/sqrt( (M-1) * 2/3 ) # scaling factor
    β                 = (-width+1)/2

    # http://www.gaussianwaves.com/2012/10/constructing-a-rectangular-constellation-for-16-qam/

    for idx in 0:M-1
        inPhase                    = idx >> div( m, 2 )
        quadrature                 = idx & int(exp2(m/2)-1)
        constellation[idx + 1]     = α * Complex( inPhase+β, quadrature+β )
        bitsMap[idx + 1]           = (encode(Gray, inPhase) << div( m, 2 )) | encode(Gray, quadrature)
        inPhase                    = decode(Gray, inPhase)
        quadrature                 = decode(Gray, quadrature)
        grayConstellation[idx + 1] = α * Complex( inPhase+β, quadrature+β )
    end

    QAM{M, Union{typeof(α),typeof(β)}, I}(m, α, β, constellation, grayConstellation, bitsMap )
end

function Base.show( io::IO, modem::QAM )
    print( io, "QAM{$(modem.m)}\n")
end




################################################################################
#                                _  _ ____ ___                                 #
#                                |\/| |  | |  \                                #
#                                |  | |__| |__/                                #
################################################################################

function modulate( modem::QAM, bits::Integer )
    modem.grayConstellation[ bits+1 ]
end


function modulate( modem::QAM, data::Vector )
    [ modulate( modem, datum ) for datum in data ]
end




################################################################################
#                           ___  ____ _  _ ____ ___                            #
#                           |  \ |___ |\/| |  | |  \                           #
#                           |__/ |___ |  | |__| |__/                           #
################################################################################

function demodulate( modem::QAM, symbol::Complex )
    symbol     = symbol / modem.α
    inPhase    = int( real( symbol ) - modem.β )
    quadrature = int( imag( symbol ) - modem.β )
    bits       = ( inPhase << div( modem.m, 2 )) | quadrature
    bits       = clamp( bits, 0, modem.M-1 )
    bits       = modem.bitsMap[bits+1]
end


function demodulate( modem::QAM, symbols::Vector )
    Int[ demodulate( modem, symbol ) for symbol in symbols ]
end




################################################################################
#                      ____ _  _ ____ _  _ ___  _    ____                      #
#                      |___  \/  |__| |\/| |__] |    |___                      #
#                      |___ _/\_ |  | |  | |    |___ |___                      #
################################################################################

#=

M         = 16
modem     = QAM( M )
modData   = rand(0:M-1, M*4)
symbols   = modulate( modem, modData)
symbols   = symbols .* 1.05
demodData = demodulate( modem, symbols )

Test.@test_approx_eq modData demodData

using PyPlot

function PyPlot.plot( modem::QAM )
    fig = figure()
    scatter( real(modem.constellation), imag(modem.constellation) )

    for i in 0:modem.M-1
        symbol = modem.constellation[ i + 1 ]
        x      = real( symbol )
        y      = imag( symbol )
        bits   = modem.bitsMap[i+1]
        strVal = modem.M > 16 ? string(bits) : bin(bits)
        annotate( strVal, (x, y+0.05), ha="center" )
    end

    setp( axes(), aspect = 1  )
    xlabel( "In Phase" )
    ylabel( "Quadrature" )

    return fig
end

plot( modem )

=#
