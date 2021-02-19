function cloneQureg(targetQureg ::Qureg, copyQureg ::Qureg) ::Nothing
    
    return ccall(:createCloneQureg, Cvoid, (Qureg, Qureg), targetQureg, copyQureg)

end

function initBlankState(qureg ::Qureg) ::Nothing

    ccall(:initBlankState, Cvoid, (Qureg,), qureg)
    return nothing

end

function initClassicalState(qureg ::Qureg, stateInd ::T where T<:Integer) ::Nothing

    ccall(:initClassicalState, Cvoid, (Qureg,Clonglong), qureg, Clonglong(stateInd))
    return nothing
    
end

function initPlusState(qureg ::Qureg) ::Nothing
        
    ccall(:initPlusState, Cvoid, (Qureg,), qureg)   
    return nothing
    
end     

function initPureState(qureg ::Qureg, pure ::Qureg) ::Nothing

    ccall(:initPureState, Cvoid, (Qureg,Qureg), qureg,pure)
    return nothing
    
end

function initStateFromAmps(qureg ::Qureg,
                           amps ::Base.Vector{Base.Complex{Qreal}}) ::Nothing

    reals = Base.Vector{Qreal}([real(x) for x in amps])
    imags = Base.Vector{Qreal}([imag(x) for x in amps])

    ccall(:initStateFromAmps, 
          Cvoid, 
          (Qureg, Ptr{Qreal}, Ptr{Qreal}), 
          qureg, 
          reals, 
          imags)

    return nothing

end

function initZeroState(qureg ::Qureg) ::Nothing

    ccall(:initZeroState, Cvoid, (Qureg,), qureg)
    return nothing
    
end

function setAmps(qureg                  ::Qureg,
                 startIdx               ::T where T<:Integer,
                 amps                   ::Base.Vector{Base.Complex{Qreal}},
                 numAmps                ::T where T<:Integer)          :: Nothing

    @assert length(amps) == numAmps
    @assert numAmps + startIdx <= qureg.numQubitsInStateVec
    reals = Base.Vector{Qreal}([real(x) for x in amps])
    imags = Base.Vector{Qreal}([imag(x) for x in amps])


    ccall(:setAmps, 
          Cvoid, 
          (Qureg, Clonglong, Ptr{Qreal}, Ptr{Qreal}, Clonglong), 
          qureg,  
          Clonglong(startIdx),  
          reals, 
          imags, 
          Clonglong(numAmps))
return nothing
end

function setWeightedQureg(fac1   ::Base.Complex{Qreal},   
                          qureg1 ::Qureg,
                          fac2   ::Base.Complex{Qreal},   
                          qureg2 ::Qureg,
                          facOut ::Base.Complex{Qreal},   
                          out    ::Qureg)           ::Nothing

    ccall(:setWeightedQureg,
          Cvoid,
          (QuEST_types.Complex, Qureg, QuEST_types.Complex, Qureg, QuEST_types.Complex, Qureg),
          QuEST_types.Complex(Qreal(real(fac1)),Qreal(real(fac1))), 
          qureg1,
          QuEST_types.Complex(Qreal(real(fac2)),Qreal(real(fac2))), 
          qureg2,
          QuEST_types.Complex(Qreal(real(facOut)),Qreal(real(facOut))), 
          out)

    return nothing

end