function createCloneQureg(qureg ::Qureg, env ::QuESTEnv) ::Qureg
    return ccall(:createCloneQureg, Qureg, (Qureg,QuESTEnv), qureg, env)
end

function createComplexMatrixN(numQubits ::T where T<:Integer) ::ComplexMatrixN;
    @assert 1 ≤ numQubits ≤ 50
    
    return ccall(:createComplexMatrixN, ComplexMatrixN, (Cint,), Cint(numQubits))
end

function createDensityQureg(numQubits ::T where T<:Integer, env ::QuESTEnv) ::Qureg
    @assert 1 ≤ numQubits ≤ 50        
    return ccall(:createDensityQureg, Qureg, (Cint,QuESTEnv), Cint(numQubits), env)
end

function createDiagonalOp(numQubits     :: T where T<:Integer,
    env           :: QuESTEnv)    :: DiagonalOp
return ccall(:createDiagonalOp, DiagonalOp, (Cint, QuESTEnv), Cint(numQubits), env)
end

function createPauliHamil(numQubits     :: T where T<:Integer,
    numSumTerms   :: T where T<:Integer)     :: PauliHamil
return ccall(:createPauliHamil, PauliHamil, (Cint, Cint), Cint(numQubits), Cint(numSumTerms))
end


function createPauliHamilFromFile(fn        ::String)   :: PauliHamil
    return ccall(:createPauliHamilFromFile, PauliHamil, (Cstring,), fn)
end

function createQuESTEnv() :: QuESTEnv
    return ccall(:createQuESTEnv, QuESTEnv, () )
end

function createQureg(numQubits ::T where T<:Integer, env ::QuESTEnv) ::Qureg
    @assert 1 ≤ numQubits ≤ 50
    
    return ccall(:createQureg, Qureg, (Cint,QuESTEnv), Cint(numQubits), env)
end

function destroyComplexMatrixN(M ::ComplexMatrixN) ::Nothing
    ccall(:destroyComplexMatrixN, Cvoid, (ComplexMatrixN,), M)
    nothing
end

function destroyDiagonalOp(op       :: DiagonalOp,
                           env      :: QuESTEnv)    :: Nothing
    ccall(:destroyDiagonalOp, Cvoid, (DiagonalOp, QuESTEnv), op, env)
return nothing
end

function destroyPauliHamil(hamil        ::PauliHamil)   :: Nothing
    ccall(:destroyPauliHamil, Cvoid, (PauliHamil,), hamil)
    return nothing
end

function destroyQuESTEnv(env ::QuESTEnv) ::Nothing
    ccall(:destroyQuESTEnv, Cvoid, (QuESTEnv,), env)
    return nothing
end

function destroyQureg(qureg ::Qureg, env ::QuESTEnv) ::Nothing
    ccall(:destroyQureg, Cvoid, (Qureg,QuESTEnv), qureg, env)
    return nothing
end

function initComplexMatrixN(m       ::ComplexMatrixN,
                            m_j     ::Matrix{Base.Complex})    ::Nothing
    
    @assert 1<<m.numQubits == size(m_j)[1] == size(m_j)[1]
    real_ = Matrix{Qreal}(transpose(Qreal.(real(m_j))))
    imag_ = Matrix{Qreal}(transpose(Qreal.(imag(m_j))))
    ccall(:initComplexMatrixN, Cvoid, (ComplexMatrixN, Ptr{Qreal}, Ptr{Qreal}), m, real_, imag_)
    return nothing
end

function initDiagonalOp(op      :: DiagonalOp,
                        real_   :: Base.Vector{Qreal},
                        imag_   :: Base.Vector{Qreal})  ::Nothing

    @assert 1<<op.numQubits == length(real_) == length(imag)
    ccall(:initDiagonalOp, Cvoid, (DiagonalOp, Ptr{Qreal}, Ptr{Qreal}), op, real_, imag_)
    return nothing
end

function initPauliHamil(hamil       :: PauliHamil,
                        coeffs      :: Base.Vector{Qreal},
                        codes       :: Base.Vector{pauliOpType})    ::Nothing

    @assert length(codes) == hamil.numSumTerms*hamil.numQubits
    ccall(:initPauliHamil, Cvoid, (PauliHamil, Ptr{Qreal}, Ptr{pauliOpType}), hamil, coeffs, codes)
    return nothing
end

function setDiagonalOpElems(op          ::DiagonalOp,
    startInd    ::T where T<:Integer,
    real_       ::Base.Vector{Qreal},
    imag_       ::Base.Vector{Qreal},
    numElems    ::T where T<:Integer)  ::Nothing
ccall(:setDiagonalOpElems, 
Cvoid, 
(DiagonalOp, Clonglong, Ptr{Qreal}, Ptr{Qreal}, Clonglong), 
op, 
Clonglong(startInd), 
real_, 
imag_, 
Clonglong(numElems))
return nothing
end

function syncDiagonalOp(op        ::DiagonalOp)     ::Nothing
    ccall(:syncDiagonalOp, Cvoid, (DiagonalOp,), op)
    return nothing
end