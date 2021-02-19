function mixDamping(qureg       :: Qureg,
                    targetQubit :: T where T<:Integer,
                    prob        :: Qreal)   ::Nothing

    ccall(:mixDamping, Cvoid, (Qureg, Cint, Qreal), qureg, targetQubit, prob)

    return nothing
end
     
function mixDensityMatrix(combineQureg      :: Qureg,
                          prob              :: Qreal,
                          otherQureg        :: Qureg)   :: Nothing

    ccall(:mixDensityMatrix, Cvoid, (Qureg, Qreal, Qureg), combineQureg, prob, otherQureg)

    return nothing
end

function mixDephasing(qureg         :: Qureg,
                      targetQubit   :: T where T<:Integer,
                      prob          :: Qreal)   ::Nothing

    ccall(:mixDephasing, Cvoid, (Qureg, Cint, Qreal), qureg, targetQubit, prob)

    return nothing
end
     
function mixDepolarising(qureg          :: Qureg,
                         targetQubit    :: T where T<:Integer,
                         prob           :: Qreal)   ::Nothing

    ccall(:mixDepolarising, Cvoid, (Qureg, Cint, Qreal), qureg, targetQubit, prob)

    return nothing
end

function mixKrausMap(qureg          :: Qureg,
                     target         :: T where T<:Integer,
                     ops            :: Base.Vector{ComplexMatrix2},
                     numOps         :: T where T<:Integer)   ::Nothing

    ccall(:mixKrausMap, 
          Cvoid, 
          (Qureg, Cint, Ptr{ComplexMatrix2}, Cint),
          qureg,
          target,
          ops,
          numOps)

    return nothing
end
     
function mixMultiQubitKrausMap(qureg        :: Qureg,
                               targets      :: Base.Vector{Cint},
                               numTargets   :: T where T<:Integer,
                               ops          :: Base.Vector{ComplexMatrixN},
                               numOps       :: T where T<:Integer)   ::Nothing

    ccall(:mixMultiQubitKrausMap, 
          Cvoid, 
          (Qureg, Ptr{Cint}, Cint, Ptr{ComplexMatrixN}, Cint),
          qureg,
          targets,
          numTargets,
          ops,
          numOps)

    return nothing
end
     
function mixPauli(qureg         :: Qureg,
                  targetQubit   :: T where T<:Integer,
                  probX         :: Qreal,
                  probY         :: Qreal,
                  probZ         :: Qreal)   ::Nothing

    ccall(:mixPauli, 
          Cvoid, 
          (Qureg, Cint, Qreal, Qreal, Qreal), 
          qureg,
          targetQubit,
          probX,
          probY,
          probZ)

    return nothing
end
     
function mixTwoQubitDephasing(qureg         :: Qureg,
                              qubit1        :: T where T<:Integer,
                              qubit2        :: T where T<:Integer,
                              prob          :: Qreal)     ::Nothing

    ccall(:mixTwoQubitDephasing, 
          Cvoid, 
          (Qureg, Cint, Cint, Qreal), 
          qureg, 
          qubit1, 
          qubit2, 
          prob)

    return nothing 
end
     
function mixTwoQubitDepolarising(qureg         :: Qureg,
                                 qubit1        :: T where T<:Integer,
                                 qubit2        :: T where T<:Integer,
                                 prob          :: Qreal)     ::Nothing

    ccall(:mixTwoQubitDepolarising, 
    Cvoid, 
    (Qureg, Cint, Cint, Qreal), 
    qureg, 
    qubit1, 
    qubit2, 
    prob)

    return nothing
end

function mixTwoQubitKrausMap(qureg         :: Qureg,
                             qubit1        :: T where T<:Integer,
                             qubit2        :: T where T<:Integer,
                             ops           :: Base.Vector{ComplexMatrix4},
                             numOps        :: T where T<:Integer)     ::Nothing

    ccall(:mixTwoQubitKrausMap, 
          Cvoid, 
          (Qureg, Cint, Cint, Ptr{ComplexMatrix4}, Cint), 
          qureg, 
          qubit1, 
          qubit2, 
          ops, 
          numOps)

    return nothing
    
end