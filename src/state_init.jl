# QuEST_jl/src/base/state_init.jl
#

function cloneQureg(targetQureg ::QuEST_Types.Qureg, copyQureg ::QuEST_Types.Qureg) ::Nothing

    return ccall(:cloneQureg, Cvoid, (QuEST_Types.Qureg, QuEST_Types.Qureg), targetQureg, copyQureg)

end

function initBlankState(qureg ::QuEST_Types.Qureg) ::Nothing

    ccall(:initBlankState, Cvoid, (QuEST_Types.Qureg,), qureg)
    return nothing

end

function initClassicalState(qureg ::QuEST_Types.Qureg, stateInd ::Integer) ::Nothing

    ccall(:initClassicalState, Cvoid, (QuEST_Types.Qureg,Clonglong), qureg, Clonglong(stateInd))
    return nothing

end

function initPlusState(qureg ::QuEST_Types.Qureg) ::Nothing

    ccall(:initPlusState, Cvoid, (QuEST_Types.Qureg,), qureg)
    return nothing

end

function initPureState(qureg ::QuEST_Types.Qureg, pure ::QuEST_Types.Qureg) ::Nothing

    ccall(:initPureState, Cvoid, (QuEST_Types.Qureg,QuEST_Types.Qureg), qureg,pure)
    return nothing

end

function initStateFromAmps(qureg ::QuEST_Types.Qureg,
                           amps ::Vector{Complex{Qreal}}) ::Nothing

    reals = Vector{Qreal}([real(x) for x in amps])
    imags = Vector{Qreal}([imag(x) for x in amps])

    ccall(:initStateFromAmps,
          Cvoid,
          (QuEST_Types.Qureg, Ptr{Qreal}, Ptr{Qreal}),
          qureg,
          reals,
          imags)

    return nothing

end

function initZeroState(qureg ::QuEST_Types.Qureg) ::Nothing

    ccall(:initZeroState, Cvoid, (QuEST_Types.Qureg,), qureg)
    return nothing

end

function setAmps(qureg                  ::QuEST_Types.Qureg,
                 startIdx               ::Integer,
                 amps                   ::Vector{Complex{Qreal}},
                 numAmps                ::Integer)          :: Nothing

    @assert length(amps) == numAmps
    @assert numAmps + startIdx <= 2^qureg.numQubitsInStateVec
    reals = Vector{Qreal}([real(x) for x in amps])
    imags = Vector{Qreal}([imag(x) for x in amps])


    ccall(:setAmps,
          Cvoid,
          (QuEST_Types.Qureg, Clonglong, Ptr{Qreal}, Ptr{Qreal}, Clonglong),
          qureg,
          Clonglong(startIdx),
          reals,
          imags,
          Clonglong(numAmps))
return nothing
end

function setWeightedQureg(fac1   ::Complex{Qreal},
                          qureg1 ::QuEST_Types.Qureg,
                          fac2   ::Complex{Qreal},
                          qureg2 ::QuEST_Types.Qureg,
                          facOut ::Complex{Qreal},
                          out    ::QuEST_Types.Qureg)           ::Nothing

    ccall(:setWeightedQureg,
          Cvoid,
          (QuEST_Types.Complex, QuEST_Types.Qureg, QuEST_Types.Complex, QuEST_Types.Qureg, QuEST_Types.Complex, QuEST_Types.Qureg),
          QuEST_Types.Complex(real(fac1), imag(fac1) ),
          qureg1,
          QuEST_Types.Complex(real(fac2), imag(fac2)),
          qureg2,
          QuEST_Types.Complex(real(facOut), imag(facOut)),
          out)

    return nothing

end
