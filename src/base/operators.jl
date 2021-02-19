function applyDiagonalOp(qureg          :: Qureg,
                         op             :: DiagonalOp)  ::Nothing

    ccall(:applyDiagonalOp, Cvoid, (Qureg, DiagonalOp), qureg, op)
nothing;
end

function applyMatrix2(qureg             :: Qureg,
    targetQubit       :: T where T<:Integer,
    u                 :: ComplexMatrix2)  ::Nothing

ccall(:applyMatrix2, Cvoid, (Qureg, Cint, ComplexMatrix2), qureg, Cint(targetQubit), u)
nothing;
end

function applyMatrix4(qureg             :: Qureg,
                      targetQubit1      :: T where T<:Integer,
                      targetQubit2      :: T where T<:Integer,
                      u                 :: ComplexMatrix4)   ::Nothing

    ccall(:applyMatrix4, 
          Cvoid, 
          (Qureg, Cint, Cint, ComplexMatrix4), 
          qureg, 
          Cint(targetQubit1), 
          Cint(targetQubit2), 
          u)
    return nothing
end

function applyMatrixN(qureg             :: Qureg,
                     targs             :: Base.Vector{Cint},
                     numTargs          ::  T where T<:Integer,
                     u                 :: ComplexMatrixN)   ::Nothing

    ccall(:applyMatrixN, 
          Cvoid, 
          (Qureg, Ptr{Cint}, Cint, ComplexMatrixN), 
          qureg, 
          targs, 
          Cint(numTargs), 
          u)

    return nothing
end

function applyMultiControlledMatrixN(qureg          :: Qureg,
                                     ctrls          :: Base.Vector{Cint},
                                     numCtrls       :: T where T<:Integer,
                                     targs          :: Base.Vector{Cint},
                                     numTargs       :: T where T<:Integer,
                                     u              :: ComplexMatrixN)  ::Nothing

    ccall(:applyMultiControlledMatrixN, 
          Cvoid, 
          (Qureg, Ptr{Cint}, Cint, Ptr{Cint}, Cint, ComplexMatrixN),
          qureg,
          ctrls,
          Cint(numCtrls),
          targs,
          Cint(numTargs),
          u)
    return nothing
end

function applyPauliHamil(inQureg        :: Qureg,
                         hamil          :: PauliHamil,
                         outQureg       :: Qureg)  ::Nothing

    ccall(:applyPauliHamil, Cvoid, (Qureg, PauliHamil, Qureg), inQureg, hamil, outQureg)
    return nothing
end

function applyPauliSum(inQureg        ::Qureg,
                       allPauliCodes  ::Base.Vector{pauliOpType},
                       termCoeffs     ::Base.Vector{Qreal},
                       numSumTerms    ::T where T<:Integer,
                       outQureg       ::Qureg)          ::Nothing

    @assert length(termCoeffs) == numSumTerms * getNumQubits(inQureg)

    ccall(:applyPauliSum, 
          Cvoid, 
          (Qureg, Ptr{pauliOpType}, Ptr{Qreal}, Cint, Qureg),
          inQureg, 
          allPauliCodes, 
          termCoeffs, 
          Cint(numSumTerms), 
          outQureg)

    return nothing
end

function applyTrotterCircuit(qureg          :: Qureg,
                             hamil          :: PauliHamil,
                             time           :: Qreal,
                             order          :: T where T<:Integer,
                             reps           :: T where T<:Integer)  ::Nothing

    ccall(:applyTrotterCircuit, 
          Cvoid, 
          (Qureg, PauliHamil, Qreal, Cint, Cint),
          qureg,
          hamil,
          time,
          Cint(order),
          Cint(reps))

return nothing
end