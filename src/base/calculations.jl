function calcDensityInnerProduct(ϱ1 ::Qureg, ϱ2 ::Qureg) ::Qreal

    w = ccall(:calcDensityInnerProduct, 
              Qreal, 
              (Qureg, Qureg), 
              ϱ1, 
              ϱ2)

    return Qreal(w)
end

function calcExpecDiagonalOp(qureg      ::Qureg, op         ::DiagonalOp)  ::QuEST_types.Complex

    ret= ccall(:calcExpecDiagonalOp,
               QuEST_types.Complex,
               (Qureg, DiagonalOp),
               qureg,
               op)
     
    return ret
end

function calcExpecPauliHamil(qureg           ::Qureg,
                             hamil           ::PauliHamil,
                             workspace       ::Qureg)       Qreal

    ret = ccall(:calcExpecPauliHamil, Qreal, (Qureg, PauliHamil, Qureg), qureg, hamil, workspace)
    
    return ret

end

function calcExpecPauliProd(qureg        ::Qureg,
                            targetQubits ::Base.Vector{Cint},
                            pauliCodes   ::Base.Vector{pauliOpType},
                            workspace    ::Qureg)          ::Qreal

    @assert length(targetQubits) == length(pauliCodes)
    @assert all( σ -> 0 ≤ σ ≤ 3,   pauliCodes )

    expval = ccall(:calcExpecPauliProd, 
                   Qreal, 
                   (Qureg, Ptr{Cint}, Ptr{pauliOpType}, Cint, Qureg), 
                   qureg, 
                   targetQubits, 
                   pauliCodes, 
                   Cint(length(targetQubits)), 
                   workspace)

    return expval
end

function calcExpecPauliSum(qureg         ::Qureg,
                           allPauliCodes ::Base.Vector{pauliOpType},
                           termCoeffs    ::Base.Vector{Qreal},
                           workspace     ::Qureg)          ::Float64

    @assert length(allPauliCodes) ==  length(termCoeffs) * getNumQubits(qureg)
    @assert all( σ -> 0 ≤ σ ≤ 3,  allPauliCodes )

    ex = ccall(:calcExpecPauliSum, 
               Qreal, 
               (Qureg, Ptr{pauliOpType}, Ptr{Qreal}, Cint, Qureg), 
               qureg, 
               allPauliCodes, 
               termCoeffs, 
               Cint(length(termCoeffs)), 
               workspace)

    return ex

end

function calcFidelity(qureg ::Qureg, pureState ::Qureg) ::Qreal

    fi = ccall(:calcFidelity, Qreal, (Qureg, Qureg), qureg, pureState)
    return fi

end
    
function calcHilbertSchmidtDistance(a ::Qureg, b ::Qureg) ::Qreal

    hsd = ccall(:calcHilbertSchmidtDistance, Qreal, (Qureg, Qureg), a, b)
    return hsd
    
end

function calcInnerProduct(bra ::Qureg, ket ::Qureg) ::Base.Complex{Qreal}

    w = ccall(:calcInnerProduct, QuEST_types.Complex, (Qureg, Qureg), bra, ket)
    return Base.Complex{Qreal}(w.real,w.imag)
    
end

function calcProbOfOutcome(qureg        ::Qureg,
    measureQubit ::T where T<:Integer,
    outcome      ::T where T<:Integer)   ::Qreal

p = ccall(:calcProbOfOutcome, 
Qreal, 
(Qureg, Cint, Cint), 
qureg, 
Cint(measureQubit), 
Cint(outcome))

return p

end

function calcPurity(qureg ::Qureg) ::Qreal

    pu = ccall(:calcPurity, Qreal, (Qureg,), qureg)
    return pu
    
end

function calcTotalProb(qureg ::Qureg) ::Qreal
        
    one = ccall(:calcTotalProb, Qreal, (Qureg,), qureg)
    return one
        
end

function getAmp(qureg ::Qureg,  idx ::T where T<:Integer) ::Base.Complex{Qreal}
        
    α = ccall(:getAmp, QuEST_types.Complex, (Qureg, Clonglong), qureg, Clonglong(idx))
    return Base.Complex{Qreal}(α.real,α.imag)
    
end

function getDensityAmp(qureg ::Qureg, row ::T where T<:Integer, col ::T where T<:Integer) ::Complex{Qreal}
        
    α = ccall(:getDensityAmp, 
              QuEST_types.Complex, 
              (Qureg, Clonglong, Clonglong),
              qureg, 
              Clonglong(row), 
              Clonglong(col))
    
    return Base.Complex{Qreal}(α.real, α.imag)

end

function getImagAmp(qureg       ::Qureg, index      ::T where T<:Integer)      ::Qreal

    ret = ccall(:getImagAmp, Qreal, (Qureg, Clonglong), qureg, Clonglong(index))
    return ret

end

function getNumAmps(qureg ::Qureg) ::Clonglong

    return ccall(:getNumAmps, Clonglong, (Qureg,), qureg)

end

function getNumQubits(qureg ::Qureg) ::Cint

    return ccall(:getNumQubits, Cint, (Qureg,), qureg)

end

function getProbAmp(qureg ::Qureg, idx ::T where T<:Integer) :: Qreal

    p = ccall(:getProbAmp, Qreal, (Qureg, Clonglong), qureg, Clonglong(idx))
    return p
    
end

function getRealAmp(qureg ::Qureg, idx ::T where T<:Integer) :: Qreal

    p = ccall(:getRealAmp, Qreal, (Qureg, Clonglong), qureg, Clonglong(idx))
    return p
    
end