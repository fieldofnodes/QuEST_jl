function  collapseToOutcome(qureg        ::Qureg,
                            measureQubit ::T where T<:Integer,
                            outcome      ::T where T<:Integer)   ::Float64

    p = ccall(:collapseToOutcome, 
              Qreal, 
              (Qureg, Cint, Cint), 
              qureg, 
              Cint(measureQubit), 
              Cint(outcome))
    return p

end

function measure(qureg ::Qureg, measureQubit ::T where T<:Integer) ::Int32

    i = ccall(:measure, Cint, (Qureg, Cint), qureg, Cint(measureQubit))
    return i

end

function measureWithStats(qureg             ::Qureg,
                          measureQubit      ::T where T<:Integer,
                          outcomeProb       ::Base.Vector{Qreal}) ::Int32

    outcome = ccall(:measureWithStats, 
                    Cint, 
                    (Qureg, Cint, Ptr{Qreal}), 
                    qureg, 
                    Cint(measureQubit), 
                    outcomeProb)
    return outcome
end