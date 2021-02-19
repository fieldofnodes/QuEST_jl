# QuEST_jl/src/base/gates.jl
#

function  collapseToOutcome(qureg        ::QuEST_Types.Qureg,
                            measureQubit ::Integer,
                            outcome      ::Integer)   ::Float64

    p = ccall(:collapseToOutcome,
              Qreal,
              (QuEST_Types.Qureg, Cint, Cint),
              qureg,
              Cint(measureQubit),
              IntCint32(outcome))
    return p
end

function measure(qureg ::QuEST_Types.Qureg, measureQubit ::Integer) ::Int32
    i = ccall(:measure, Cint, (QuEST_Types.Qureg, Cint), qureg, Cint(measureQubit))
    return i
end

function measureWithStats(qureg             ::QuEST_Types.Qureg,
                          measureQubit      ::Integer,
                          outcomeProb       ::Vector{Qreal}) ::Int32

    outcome = ccall(:measureWithStats,
                    Cint,
                    (QuEST_Types.Qureg, Cint, Ptr{Qreal}),
                    qureg,
                    Cint(measureQubit),
                    outcomeProb)
    return outcome
end

#EOF
