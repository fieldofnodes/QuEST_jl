# QuEST_jl/src/base/data_structure_functions.jl
#

import .._QUEST_LIB

function createQuESTEnv() :: QuEST_Types.QuESTEnv
    if _QUEST_LIB[]==Ptr{Cvoid}(0)
        QuEST_init()
    else
        @assert 4*ccall(:getQuEST_PREC,Cint,(),) == sizeof(Qreal)
    end

    return ccall(:createQuESTEnv, QuEST_Types.QuESTEnv, () )
end

####################################################################################################

function createCloneQureg(qureg ::QuEST_Types.Qureg, env ::QuEST_Types.QuESTEnv) ::QuEST_Types.Qureg
    return ccall(:createCloneQureg, QuEST_Types.Qureg, (QuEST_Types.Qureg,QuEST_Types.QuESTEnv), qureg, env)
end

function createComplexMatrixN(numQubits ::Integer) ::QuEST_Types.ComplexMatrixN
    @assert 1 ≤ numQubits ≤ 50

    return ccall(:createComplexMatrixN, QuEST_Types.ComplexMatrixN, (Cint,), Cint(numQubits))
end

function createDensityQureg(numQubits ::Integer, env ::QuEST_Types.QuESTEnv) ::QuEST_Types.Qureg
    @assert 1 ≤ numQubits ≤ 50
    return ccall(:createDensityQureg, QuEST_Types.Qureg, (Cint,QuEST_Types.QuESTEnv), Cint(numQubits), env)
end

function createDiagonalOp(numQubits     :: Integer,
    env           :: QuEST_Types.QuESTEnv)    :: QuEST_Types.DiagonalOp
return ccall(:createDiagonalOp, QuEST_Types.DiagonalOp, (Cint, QuEST_Types.QuESTEnv), Cint(numQubits), env)
end

function createPauliHamil(numQubits     :: Integer,
    numSumTerms   :: Integer)     :: QuEST_Types.PauliHamil
return ccall(:createPauliHamil, QuEST_Types.PauliHamil, (Cint, Cint), Cint(numQubits), Cint(numSumTerms))
end


function createPauliHamilFromFile(fn        ::String)   :: QuEST_Types.PauliHamil
    return ccall(:createPauliHamilFromFile, QuEST_Types.PauliHamil, (Cstring,), fn)
end

function createQureg(numQubits ::Integer, env ::QuEST_Types.QuESTEnv) ::QuEST_Types.Qureg
    @assert 1 ≤ numQubits ≤ 50

    return ccall(:createQureg, QuEST_Types.Qureg, (Cint,QuEST_Types.QuESTEnv), Cint(numQubits), env)
end

function destroyComplexMatrixN(M ::QuEST_Types.ComplexMatrixN) ::Nothing
    ccall(:destroyComplexMatrixN, Cvoid, (QuEST_Types.ComplexMatrixN,), M)
    nothing
end

function destroyDiagonalOp(op       :: QuEST_Types.DiagonalOp,
                           env      :: QuEST_Types.QuESTEnv)    :: Nothing
    ccall(:destroyDiagonalOp, Cvoid, (QuEST_Types.DiagonalOp, QuEST_Types.QuESTEnv), op, env)
return nothing
end

function destroyPauliHamil(hamil        ::QuEST_Types.PauliHamil)   :: Nothing
    ccall(:destroyPauliHamil, Cvoid, (QuEST_Types.PauliHamil,), hamil)
    return nothing
end

function destroyQuESTEnv(env ::QuEST_Types.QuESTEnv) ::Nothing
    ccall(:destroyQuESTEnv, Cvoid, (QuEST_Types.QuESTEnv,), env)
    return nothing
end

function destroyQureg(qureg ::QuEST_Types.Qureg, env ::QuEST_Types.QuESTEnv) ::Nothing
    ccall(:destroyQureg, Cvoid, (QuEST_Types.Qureg,QuEST_Types.QuESTEnv), qureg, env)
    return nothing
end

function initComplexMatrixN(m       ::QuEST_Types.ComplexMatrixN,
                            m_j     ::Matrix{Base.Complex})    ::Nothing

    @assert 1<<m.numQubits == size(m_j)[1] == size(m_j)[1]
    real_ = Matrix{Qreal}(transpose(Qreal.(real(m_j))))
    imag_ = Matrix{Qreal}(transpose(Qreal.(imag(m_j))))
    ccall(:initComplexMatrixN, Cvoid, (QuEST_Types.ComplexMatrixN, Ptr{Qreal}, Ptr{Qreal}), m, real_, imag_)
    return nothing
end

function initDiagonalOp(op      :: QuEST_Types.DiagonalOp,
                        real_   :: Vector{Qreal},
                        imag_   :: Vector{Qreal})  ::Nothing

    @assert 1<<op.numQubits == length(real_) == length(imag)
    ccall(:initDiagonalOp, Cvoid, (QuEST_Types.DiagonalOp, Ptr{Qreal}, Ptr{Qreal}), op, real_, imag_)
    return nothing
end

function initPauliHamil(hamil       :: QuEST_Types.PauliHamil,
                        coeffs      :: Vector{Qreal},
                        codes       :: Vector{QuEST_Types.pauliOpType})    ::Nothing

    @assert length(codes) == hamil.numSumTerms*hamil.numQubits
    ccall(:initPauliHamil, Cvoid, (QuEST_Types.PauliHamil, Ptr{Qreal}, Ptr{QuEST_Types.pauliOpType}), hamil, coeffs, codes)
    return nothing
end

function setDiagonalOpElems(op          ::QuEST_Types.DiagonalOp,
    startInd    ::Integer,
    real_       ::Vector{Qreal},
    imag_       ::Vector{Qreal},
    numElems    ::Integer)  ::Nothing
ccall(:setDiagonalOpElems,
Cvoid,
(QuEST_Types.DiagonalOp, Clonglong, Ptr{Qreal}, Ptr{Qreal}, Clonglong),
op,
Clonglong(startInd),
real_,
imag_,
Clonglong(numElems))
return nothing
end

function syncDiagonalOp(op        ::QuEST_Types.DiagonalOp)     ::Nothing
    ccall(:syncDiagonalOp, Cvoid, (QuEST_Types.DiagonalOp,), op)
    return nothing
end
