#

@doc raw"

Module `_CHelpers`

Functions for reading members of QuEST's C structs.

## Exports
* numQubits()
...
"
module _CHelpers
export numQubits, isDensityMatrix

import ..QuEST
using ..QuEST: Qreal, Qureg

function numQubits(qr ::Qureg) ::Int
    local n = ccall(:CHelpQuEST__numQubits, Cint, (Qureg,),
                    qr)
    @assert 0 < n < 200
end

function isDensityMatrix(qr ::Qureg) ::Int
    local yes = ccall(:CHelpQuEST__isDensityMatrix, Cint, (Qureg,),
                      qr)
    @assert yes ∈ 0:1
end

## Julia Module Init #----------------------------------------------------------
#
# Init
#
#-------------------------------------------------------------------------------

using Libdl: dlopen, RTLD_LAZY, RTLD_DEEPBIND, RTLD_GLOBAL

function __init__()
    @assert Qreal ∈ [ Cdouble, Cfloat ]
    if Qreal == Cdouble
        dlopen("libCHelpQuEST_d",RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
    else Qreal == Cfloat
        dlopen("libCHelpQuEST_f",RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
    end
end #^ module _CHelpers
#EOF