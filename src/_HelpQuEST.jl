#

@doc raw"

Module `_HelpQuEST`

Functions for reading members of QuEST's C structs.

## Exports
* numQubits()
...
"
module _HelpQuEST
export numQubits, isDensityMatrix

import ..QuEST
using ..QuEST: Qreal, Qureg

function numQubits(qr ::Qureg) ::Int
    local n = ccall(:helpQuEST__numQubits, Cint, (Qureg,),
                    qr)
    @assert 0 < n < 200
    return n
end

function isDensityMatrix(qr ::Qureg) ::Bool
    local yes❔ = ccall(:helpQuEST__isDensityMatrix, Cint, (Qureg,),
                      qr)
    @assert yes❔ ∈ 0:1
    return yes❔==1
end

## Julia Module Init #----------------------------------------------------------
#
# Init
#
#-------------------------------------------------------------------------------

using Libdl: dlopen, RTLD_LAZY, RTLD_DEEPBIND, RTLD_GLOBAL

function __init__()
    dlopen("libQuEST",RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)

    @assert Qreal ∈ [ Cdouble, Cfloat ]

    if Qreal == Cdouble
        dlopen(joinpath(@__DIR__,"C","libhelpQuEST_d.so"),
               RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
    else Qreal == Cfloat
        dlopen(joinpath(@__DIR__,"C","libhelpQuEST_f.so"),
               RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
    end
end

end #^ module _HelpQuEST
#EOF
