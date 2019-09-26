abstract type CodingScheme end



################################################################################
#               ____ _  _ ____ ____ ___  _ _  _ ____                           #
#               |___ |\ | |    |  | |  \ | |\ | | __                           #
#               |___ | \| |___ |__| |__/ | | \| |__]                           #
################################################################################

struct Gray <: CodingScheme end

@inline encode(T::Type{<:CodingScheme}, n::Int) = encode(T, UInt(n))
@inline decode(T::Type{<:CodingScheme}, n::Int) = encode(T, UInt(n))

function encode( ::Type{Gray}, n::UInt )
    n ⊻ (n >> 1)
end

#=
function decode( ::Type{Gray}, n::UInt )
    mask = n >> 1
    while mask != 0
        n = n ⊻ mask
        mask = mask >> 1
    end
    return n
end
=#
function decode( ::Type{Gray}, n::UInt32) #Faster alg for 32 bit ints, see: https://en.wikipedia.org/wiki/Gray_code
    for shift in (16, 8, 4, 2, 1)
        n = n ⊻ (n >> shift);
    end
   return n
end

function decode( ::Type{Gray}, n::UInt64) #Faster alg for 64 bit ints, loop should unroll
    for shift in (32, 16, 8, 4, 2, 1)
        n = n ⊻ (n >> shift);
    end
   return n
end



encode(::Type{T}, N::AbstractVector ) where T= [ encode( T, n) for n in N ]
decode(::Type{T}, N::AbstractVector ) where T= [ decode( T, n) for n in N ]
