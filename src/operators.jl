# QuEST_jl/src/base/operators.jl
#

function applyDiagonalOp(qureg          :: QuEST_Types.Qureg,
                         op             :: QuEST_Types.DiagonalOp)  ::Nothing

    ccall(:applyDiagonalOp, Cvoid, (QuEST_Types.Qureg, QuEST_Types.DiagonalOp), qureg, op)
    nothing;
end

function applyMatrix2(qureg             :: QuEST_Types.Qureg,
    targetQubit       :: Integer,
    u                 :: QuEST_Types.ComplexMatrix2)  ::Nothing

    ccall(:applyMatrix2, Cvoid, (QuEST_Types.Qureg, Cint, QuEST_Types.ComplexMatrix2), qureg, Cint(targetQubit), u)
    nothing;
end

function applyMatrix4(qureg             :: QuEST_Types.Qureg,
    targetQubit1      :: Integer,
    targetQubit2      :: Integer,
    u                 :: QuEST_Types.ComplexMatrix4)   ::Nothing

    ccall(:applyMatrix4,
          Cvoid,
          (QuEST_Types.Qureg, Cint, Cint, QuEST_Types.ComplexMatrix4),
          qureg,
          Cint(targetQubit1),
          Cint(targetQubit2),
          u)
    return nothing
end

function applyMatrixN(qureg             :: QuEST_Types.Qureg,
                     targs             :: Vector{Cint},
                     numTargs          ::  Integer,
                     u                 :: QuEST_Types.ComplexMatrixN)   ::Nothing

    ccall(:applyMatrixN,
          Cvoid,
          (QuEST_Types.Qureg, Ptr{Cint}, Cint, QuEST_Types.ComplexMatrixN),
          qureg,
          targs,
          Cint(numTargs),
          u)

    return nothing
end

function applyMultiControlledMatrixN(qureg          :: QuEST_Types.Qureg,
    ctrls          :: Vector{T} where T<:Integer,
    numCtrls       :: Integer,
    targs          :: Vector{T} where T<:Integer,
    numTargs       :: Integer,
    u              :: QuEST_Types.ComplexMatrixN)  ::Nothing

    ccall(:applyMultiControlledMatrixN,
          Cvoid,
          (QuEST_Types.Qureg, Ptr{Cint}, Cint, Ptr{Cint}, Cint, QuEST_Types.ComplexMatrixN),
          qureg,
          Cint.(ctrls),
          Cint(numCtrls),
          Cint.(targs),
          Cint(numTargs),
          u)
    nothing;
end

function applyPauliHamil(inQureg        :: QuEST_Types.Qureg,
                         hamil          :: QuEST_Types.PauliHamil,
                         outQureg       :: QuEST_Types.Qureg)  ::Nothing

    ccall(:applyPauliHamil, Cvoid, (QuEST_Types.Qureg, QuEST_Types.PauliHamil, QuEST_Types.Qureg), inQureg, hamil, outQureg)
    nothing;
end

function applyPauliSum(inQureg        ::QuEST_Types.Qureg,
                       allPauliCodes  ::Vector{QuEST_Types.pauliOpType},
                       termCoeffs     ::Vector{Qreal},
                       numSumTerms    ::Integer,
                       outQureg       ::QuEST_Types.Qureg)          ::Nothing

    @assert length(allPauliCodes) == numSumTerms * getNumQubits(inQureg)

    ccall(:applyPauliSum,
          Cvoid,
          (QuEST_Types.Qureg, Ptr{QuEST_Types.pauliOpType}, Ptr{Qreal}, Cint, QuEST_Types.Qureg),
          inQureg,
          allPauliCodes,
          termCoeffs,
          Cint(numSumTerms),
          outQureg)

    return nothing
end

function applyTrotterCircuit(qureg          :: QuEST_Types.Qureg,
    hamil          :: QuEST_Types.PauliHamil,
    time           :: Qreal,
    order          :: Integer,
    reps           :: Integer)  ::Nothing

    ccall(:applyTrotterCircuit,
          Cvoid,
          (QuEST_Types.Qureg, QuEST_Types.PauliHamil, Qreal, Cint, Cint),
          qureg,
          hamil,
          time,
          Cint(order),
          Cint(reps))
    return nothing
end

#EOF
