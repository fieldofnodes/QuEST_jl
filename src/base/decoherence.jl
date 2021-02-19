# QuEST_jl/src/base/decoherence.jl
#

function mixDamping(qureg       :: QuEST_Types.Qureg,
                    targetQubit :: Cint,
                    prob        :: Qreal)   ::Nothing

    ccall(:mixDamping, Cvoid, (QuEST_Types.Qureg, Cint, Qreal), qureg, targetQubit, prob)

    return nothing
end

function mixDensityMatrix(combineQureg      :: QuEST_Types.Qureg,
                          prob              :: Qreal,
                          otherQureg        :: QuEST_Types.Qureg)   :: Nothing

    ccall(:mixDensityMatrix, Cvoid, (QuEST_Types.Qureg, Qreal, QuEST_Types.Qureg), combineQureg, prob, otherQureg)

    return nothing
end

function mixDephasing(qureg         :: QuEST_Types.Qureg,
                      targetQubit   :: Cint,
                      prob          :: Qreal)   ::Nothing

    ccall(:mixDephasing, Cvoid, (QuEST_Types.Qureg, Cint, Qreal), QuEST_Types.Qureg, targetQubit, prob)

    return nothing
end

function mixDepolarising(qureg          :: QuEST_Types.Qureg,
                         targetQubit    :: Cint,
                         prob           :: Qreal)   ::Nothing

    ccall(:mixDepolarising, Cvoid, (QuEST_Types.Qureg, Cint, Qreal), qureg, targetQubit, prob)

    return nothing
end

function mixKrausMap(qureg          :: QuEST_Types.Qureg,
                     target         :: Cint,
                     ops            :: Vector{QuEST_Types.ComplexMatrix2},
                     numOps         :: Cint)   ::Nothing

    ccall(:mixKrausMap,
          Cvoid,
          (QuEST_Types.Qureg, Cint, Ptr{QuEST_Types.ComplexMatrix2}, Cint),
          qureg,
          target,
          ops,
          numOps)

    return nothing
end

function mixMultiQubitKrausMap(qureg        :: QuEST_Types.Qureg,
                               targets      :: Vector{Cint},
                               numTargets   :: Cint,
                               ops          :: Vector{QuEST_Types.ComplexMatrixN},
                               numOps       :: Cint)   ::Nothing

    ccall(:mixMultiQubitKrausMap,
          Cvoid,
          (QuEST_Types.Qureg, Ptr{Cint}, Cint, Ptr{QuEST_Types.ComplexMatrixN}, Cint),
          qureg,
          targets,
          numTargets,
          ops,
          numOps)

    return nothing
end

function mixPauli(qureg         :: QuEST_Types.Qureg,
                  targetQubit   :: Cint,
                  probX         :: Qreal,
                  probY         :: Qreal,
                  probZ         :: Qreal)   ::Nothing

    ccall(:mixPauli,
          Cvoid,
          (QuEST_Types.Qureg, Cint, Qreal, Qreal, Qreal),
          qureg,
          targetQubit,
          probX,
          probY,
          probZ)

    return nothing
end

function mixTwoQubitDephasing(qureg         :: QuEST_Types.Qureg,
                              qubit1        :: Cint,
                              qubit2        :: Cint,
                              prob          :: Qreal)     ::Nothing

    ccall(:mixTwoQubitDephasing,
          Cvoid,
          (QuEST_Types.Qureg, Cint, Cint, Qreal),
          qureg,
          qubit1,
          qubit2,
          prob)

    return nothing
end

function mixTwoQubitDepolarising(qureg         :: QuEST_Types.Qureg,
                                 qubit1        :: Cint,
                                 qubit2        :: Cint,
                                 prob          :: Qreal)     ::Nothing

    ccall(:mixTwoQubitDepolarising,
    Cvoid,
    (QuEST_Types.Qureg, Cint, Cint, Qreal),
    qureg,
    qubit1,
    qubit2,
    prob)

    return nothing
end

function mixTwoQubitKrausMap(qureg         :: QuEST_Types.Qureg,
                             qubit1        :: Cint,
                             qubit2        :: Cint,
                             ops           :: Vector{QuEST_Types.ComplexMatrix4},
                             numOps        :: Cint)     ::Nothing

    ccall(:mixTwoQubitKrausMap,
          Cvoid,
          (QuEST_Types.Qureg, Cint, Cint, Ptr{QuEST_Types.ComplexMatrix4}, Cint),
          qureg,
          qubit1,
          qubit2,
          ops,
          numOps)

    return nothing

end
