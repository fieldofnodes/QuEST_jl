function compactUnitary(qureg       ::Qureg,
                        targetQubit ::T where T<:Integer,
                        α           ::Base.Complex{Qreal},
                        β           ::Base.Complex{Qreal})   ::Nothing

    alpha = QuEST_types.Complex(real(α),imag(α))
    beta  = QuEST_types.Complex(real(β),imag(β))

    ccall(:compactUnitary, 
          Cvoid, 
          (Qureg, Cint, QuEST_types.Complex, QuEST_types.Complex), 
          qureg, 
          Cint(targetQubit), 
          alpha, 
          beta)

    return nothing
end

function controlledCompactUnitary(qureg          ::Qureg,
    controlQubit   ::T where T<:Integer,
    targetQubit    ::T where T<:Integer,
    α              ::Base.Complex{Qreal},
    β              ::Base.Complex{Qreal} ) ::Nothing
alpha = QuEST_types.Complex(real(α),imag(α))
beta  = QuEST_types.Complex(real(β),imag(β))

ccall(:controlledCompactUnitary, 
Cvoid, 
(Qureg, Cint, Cint, Complex, Complex), 
qureg, 
Cint(controlQubit), 
Cint(targetQubit), 
alpha, 
beta)
return nothing
end

function controlledMultiQubitUnitary(qureg   ::Qureg,
                                     ctrl    ::T where T<:Integer,
                                     targs   ::Base.Vector{Cint},
                                     u       ::ComplexMatrixN) ::Nothing
    
    ccall(:controlledMultiQubitUnitary, 
          Cvoid, 
          (Qureg, Cint, Ptr{Cint}, Cint, ComplexMatrixN), 
          qureg, 
          Cint(ctrl), 
          targs, 
          Cint(length(targs)), 
          u)
    return nothing
end


function controlledNot(qureg         ::Qureg,
    controlQubit  ::T where T<:Integer,
    targetQubit   ::T where T<:Integer)   ::Nothing

ccall(:controlledNot, 
Cvoid, 
(Qureg, Cint, Cint), 
qureg, 
Cint(controlQubit), 
Cint(targetQubit))
return nothing
end


function controlledPauliY(qureg         ::Qureg,
    controlQubit  ::T where T<:Integer,
    targetQubit   ::T where T<:Integer)   ::Nothing
ccall(:controlledPauliY, 
Cvoid, 
(Qureg, Cint, Cint), 
qureg, 
Cint(controlQubit), 
Cint(targetQubit))
return nothing
end

function controlledPhaseFlip(qureg         ::Qureg,
    controlQubit  ::T where T<:Integer,
    targetQubit   ::T where T<:Integer)   ::Nothing
ccall(:controlledPhaseFlip, 
Cvoid, 
(Qureg, Cint, Cint), 
qureg, 
Cint(controlQubit), 
Cint(targetQubit))
return nothing
end


function controlledPhaseShift(qureg    ::Qureg,
    idQubit1 ::T where T<:Integer,
    idQubit2 ::T where T<:Integer,
    angle    ::Qreal)   ::Nothing
ccall(:controlledPhaseShift, 
Cvoid, 
(Qureg, Cint, Cint, Qreal), 
qureg, 
Cint(idQubit1), 
Cint(idQubit2), 
angle)
return nothing
end


function controlledRotateAroundAxis(qureg        ::Qureg,
    controlQubit ::T where T<:Integer,
    targetQubit  ::T where T<:Integer,
    angle        ::Qreal,
    axis         ::Base.Vector{Qreal})  ::Nothing
@assert length axis == 3
q_axis = QuEST_types.Vector(axis[1], axis[2], axis[3])
ccall(:controlledRotateAroundAxis, 
Cvoid, 
(Qureg, Cint, Cint, Qreal, QuEST_types.Vector), 
qureg, 
Cint(controlQubit), 
Cint(targetQubit), 
angle, 
q_axis)
return nothing
end

function controlledRotateX(qureg         ::Qureg,
    controlQubit  ::T where T<:Integer,
    targetQubit   ::T where T<:Integer,
    angle         ::Qreal)  ::Nothing
ccall(:controlledRotateX, 
Cvoid, 
(Qureg, Cint, Cint, Qreal), 
qureg, 
Cint(controlQubit), 
Cint(targetQubit), 
angle)

return nothing
end


function controlledRotateY(qureg         ::Qureg,
    controlQubit  ::T where T<:Integer,
    targetQubit   ::T where T<:Integer,
    angle         ::Qreal)  ::Nothing

ccall(:controlledRotateY, 
Cvoid, 
(Qureg, Cint, Cint, Qreal), 
qureg, 
Cint(controlQubit), 
Cint(targetQubit), 
angle)
return nothing
end

function controlledRotateZ(qureg         ::Qureg,
    controlQubit  ::T where T<:Integer,
    targetQubit   ::T where T<:Integer,
    angle         ::Qreal)  ::Nothing

ccall(:controlledRotateZ, 
Cvoid, 
(Qureg, Cint, Cint, Qreal), 
qureg, 
Cint(controlQubit), 
Cint(targetQubit), 
angle)
return nothing
end

function _quest_mtx_2(U ::Matrix{Base.Complex{Qreal}}) ::ComplexMatrix2
    @assert size(U) == (2,2)
    u = ComplexMatrix2(
        ( (real(U[1,1]), real(U[1,2])), (real(U[2,1]), real(U[2,2])) ),
        ( (imag(U[1,1]), imag(U[1,2])), (imag(U[2,1]), imag(U[2,2])) )  )
    return u
end

function _quest_mtx_4(U ::Matrix{Base.Complex{Qreal}}) ::ComplexMatrix4
    @assert size(U) = (4,4)
    u = ComplexMatrix4( ( ( real(U[1,1]), real(U[1,2]), real(U[1,3]), real(U[1,4]) ),
                          ( real(U[2,1]), real(U[2,2]), real(U[2,3]), real(U[2,4]) ),
                          ( real(U[3,1]), real(U[3,2]), real(U[3,3]), real(U[3,4]) ),
                          ( real(U[4,1]), real(U[4,2]), real(U[4,3]), real(U[4,4]) ) ),
                        ( ( imag(U[1,1]), imag(U[1,2]), imag(U[1,3]), imag(U[1,4]) ),
                          ( imag(U[2,1]), imag(U[2,2]), imag(U[2,3]), imag(U[2,4]) ),
                          ( imag(U[3,1]), imag(U[3,2]), imag(U[3,3]), imag(U[3,4]) ),
                          ( imag(U[4,1]), imag(U[4,2]), imag(U[4,3]), imag(U[4,4]) ) )  )
end

function controlledTwoQubitUnitary(qureg         ::Qureg,
    controlQubit  ::T where T<:Integer,
    targetQubit1  ::T where T<:Integer,
    targetQubit2  ::T where T<:Integer,
    U             ::Matrix{Base.Complex{Qreal}}) ::Nothing

@assert size(U) == (2, 2)
u = _quest_mtx_4(U)
ccall(:controlledTwoQubitUnitary, 
Cvoid, 
(Qureg, Cint, Cint, Cint, ComplexMatrix4), 
qureg, 
Cint(controlQubit), 
Cint(targetQubit1), 
Cint(targetQubit2), 
u)
return nothing
end


function controlledUnitary(qureg        ::Qureg,
    controlQubit ::T where T<:Integer,
    targetQubit  ::T where T<:Integer,
    U            ::Matrix{Base.Complex{Qreal}}) ::Nothing
u = _quest_mtx_2(U)

ccall(:controlledUnitary, 
Cvoid, 
(Qureg, Cint, Cint, ComplexMatrix2), 
qureg, 
Cint(controlQubit), 
Cint(targetQubit), 
u)
return nothing
end

function hadamard(qureg ::Qureg,  targetQubit ::T where T<:Integer) ::Nothing

ccall(:hadamard, Cvoid, (Qureg, Cint), qureg, Cint(targetQubit))
return nothing
end

function multiControlledMultiQubitUnitary(qureg  ::Qureg,
                                          ctrls  ::Base.Vector{Cint},
                                          targs  ::Base.Vector{Cint},
                                          u      ::ComplexMatrixN) ::Nothing

    ccall(:multiControlledMultiQubitUnitary, 
          Cvoid,
          (Qureg, Ptr{Cint}, Cint, Ptr{Cint}, Cint, ComplexMatrixN), 
          qureg, 
          ctrls, 
          Cint(length(ctrls)), 
          targs, 
          Cint(length(targs)), 
          u)
    return nothing
end

function multiControlledPhaseFlip(qureg         ::Qureg,
                                  controlQubits ::Base.Vector{Cint}) ::Nothing

    ccall(:multiControlledPhaseFlip, 
          Cvoid, 
          (Qureg, Ptr{Cint}, Cint), 
          qureg, 
          controlQubits, 
          Cint(length(controlQubits)))
    return nothing
end

function multiControlledPhaseShift(qureg         ::Qureg,
                                   controlQubits ::Base.Vector{Cint},
                                   angle         ::Qreal)         ::Nothing

    ccall(:multiControlledPhaseShift, 
          Cvoid, 
          (Qureg, Ptr{Cint}, Cint, Qreal), 
          qureg, 
          controlQubits, 
          Cint(length(controlQubits)), 
          angle)
    return nothing
end

function multiControlledTwoQubitUnitary(qureg           ::Qureg,
                                        controlQubits   ::Base.Vector{Cint},
                                        targetQubit1    ::T where T<:Integer,
                                        targetQubit2    ::T where T<:Integer,
                                        U               ::Matrix{Base.Complex{Qreal}}) ::Nothing
    u = _quest_mtx_4(U)
    ccall(:multiControlledTwoQubitUnitary, 
          Cvoid, 
          (Qureg, Ptr{Cint}, Cint, Cint, Cint, ComplexMatrix4),
          qureg, 
          controlQubits, 
          Cint(length(controlQubits)),  
          Cint(targetQubit1), 
          Cint(targetQubit2), 
          u)
    return nothing
end

function multiControlledUnitary(qureg         ::Qureg,
                                controlQubits ::Base.Vector{Cint},
                                targetQubit   ::T where T<:Integer,
                                U             ::Matrix{Base.Complex{Qreal}}) ::Nothing

    u = _quest_mtx_2(U)

    ccall(:multiControlledUnitary, 
    Cvoid, 
    (Qureg, Ptr{Cint}, Cint, Cint, ComplexMatrix2),
    qureg, 
    controlQubits, 
    Cint(length(controlQubits)),  
    Cint(targetQubit), 
    u)
    return nothing
end

function multiQubitUnitary(qureg ::Qureg,
                           targs ::Base.Vector{Cint},
                           u     ::ComplexMatrixN)      ::Nothing

    ccall(:multiQubitUnitary, 
          Cvoid, 
          (Qureg, Ptr{Cint}, Cint, ComplexMatrixN),
          qureg, 
          targs, 
          Cint(length(targs)), 
          u)
    return nothing
end

function multiRotatePauli(qureg         ::Qureg,
                          targetQubits  ::Base.Vector{Cint},
                          targetPaulis  ::Base.Vector{pauliOpType},
                          angle         ::Qreal)          ::Nothing

    @assert length(targetQubits) == length(targetPaulis)
    @assert all( σ -> 0 ≤ σ ≤ 3,   targetPaulis )

    ccall(:multiRotatePauli, 
          Cvoid, 
          (Qureg, Ptr{Cint}, Ptr{pauliOpType}, Cint, Qreal), 
          qureg, 
          targetQubits, 
          targetPaulis, 
          Cint(length(targetPaulis)), 
          angle)

    return nothing
end

function multiRotateZ(qureg      ::Qureg,
                      qubits     ::Base.Vector{Cint},
                      angle      ::Qreal)         ::Nothing
    ccall(:multiRotateZ, 
          Cvoid, 
          (Qureg, Ptr{Cint}, Cint, Qreal),
          qureg, 
          qubits, 
          Cint(length(qubits)), 
          angle)
    return nothing

end

function multiStateControlledUnitary(qureg           ::Qureg,
                                     controlQubits   ::Base.Vector{Cint},
                                     controlState    ::Base.Vector{Cint},
                                     targetQubit     ::T where T<:Integer,
                                     U               ::Matrix{Base.Complex{Qreal}}) ::Nothing

    @assert length(controlQubits) == length(controlState)
    u = _quest_mtx_2(U)

    ccall(:multiStateControlledUnitary,
          Cvoid,
          (Qureg, Ptr{Cint}, Ptr{Cint}, Cint, Cint, ComplexMatrix2),
          qureg, 
          controlQubits, 
          controlState, 
          Cint(length(controlQubits)), 
          Cint(targetQubit), 
          u)
    return nothing
end

function pauliX(qureg ::Qureg, targetQubit ::T where T<:Integer):: Nothing

    ccall(:pauliX, 
          Cvoid, 
          (Qureg, Cint),
          qureg,
          Cint(targetQubit))

    return nothing
end
function pauliY(qureg ::Qureg, targetQubit ::T where T<:Integer):: Nothing

    ccall(:pauliY, 
          Cvoid,
          (Qureg, Cint),
          qureg, 
          Cint(targetQubit))

    return nothing
end
function pauliZ(qureg ::Qureg, targetQubit ::T where T<:Integer):: Nothing

    ccall(:pauliZ, 
          Cvoid, 
          (Qureg, Cint),
          qureg, 
          Cint(targetQubit))

    return nothing
end

function phaseShift(qureg       ::Qureg,
    targetQubit ::T where T<:Integer,
    angle       ::Qreal) ::Nothing

ccall(:phaseShift, 
Cvoid, 
(Qureg, Cint, Qreal),
qureg, 
Cint(targetQubit), 
angle)
return nothing
end

function rotateAroundAxis(qureg         ::Qureg, 
                          rotQubit      ::T where T<:Integer, 
                          angle         ::Qreal, 
                          axis          ::Base.Vector{Qreal}) ::Nothing

    @assert length axis == 3
    q_axis = QuEST_types.Vector(axis[1], axis[2], axis[3])
    ccall(:rotateAroundAxis, 
          Cvoid, 
          (Qureg, Cint, Qreal, QuEST_types.Vector),
          qureg, 
          Cint(rotQubit), 
          angle, q_axis)
    return nothing
end

function rotateX(qureg  ::Qureg, rotQubit ::T where T<:Integer, angle ::Qreal) ::Nothing

    ccall(:rotateX, 
          Cvoid, 
          (Qureg, Cint, Qreal),
          qureg, 
          Cint(rotQubit), 
          angle)
    return nothing
end

function rotateY(qureg ::Qureg, rotQubit ::T where T<:Integer, angle ::Qreal) ::Nothing

    ccall(:rotateY, 
          Cvoid, 
          (Qureg, Cint, Qreal),
          qureg, 
          Cint(rotQubit), 
          angle)
    return nothing
end
function rotateZ(qureg ::Qureg, rotQubit ::T where T<:Integer, angle ::Qreal) ::Nothing

    ccall(:rotateZ, 
          Cvoid, 
          (Qureg, Cint, Qreal),
          qureg, 
          Cint(rotQubit), 
          angle)
    return nothing
end

function sGate(qureg ::Qureg, targetQubit ::T where T<:Integer) ::Nothing

    ccall(:sGate, 
          Cvoid, 
          (Qureg, Cint),
          qureg,  
          Cint(targetQubit))
    return nothing
end

function sqrtSwapGate(qureg ::Qureg, qubit1 ::T where T<:Integer, qubit2 ::T where T<:Integer) ::Nothing

    ccall(:sqrtSwapGate, 
          Cvoid, 
          (Qureg, Cint, Cint),
          qureg, 
          Cint(qubit1), 
          Cint(qubit2))
    return nothing
end

function swapGate(qureg ::Qureg, qubit1 ::T where T<:Integer, qubit2 ::T where T<:Integer) ::Nothing

    ccall(:swapGate, 
          Cvoid, 
          (Qureg, Cint, Cint),
          qureg, 
          Cint(qubit1), 
          Cint(qubit2))

    return nothing
end

function tGate(qureg ::Qureg, targetQubit ::T where T<:Integer) ::Nothing

    ccall(:tGate, 
          Cvoid, 
          (Qureg, Cint),
          qureg, 
          Cint(targetQubit))
    return nothing
end

function twoQubitUnitary(qureg           ::Qureg,
                         targetQubit1    ::T where T<:Integer,
                         targetQubit2    ::T where T<:Integer,
                         U               ::Matrix{Base.Complex{Qreal}}) ::Nothing

    u = _quest_mtx_4(U)

    ccall(:twoQubitUnitary, 
    Cvoid, 
    (Qureg, Cint, Cint, ComplexMatrix4),
    qureg, 
    Cint(targetQubit1), 
    Cint(targetQubit2), 
    u)

    return nothing
end

function unitary(qureg           ::Qureg,
    targetQubit     ::T where T<:Integer,
    U               ::Matrix{Base.Complex{Qreal}}) ::Nothing

u = _quest_mtx_2(U)

ccall(:unitary, 
Cvoid, 
(Qureg, Cint, ComplexMatrix2),
qureg, 
Cint(targetQubit),  
u)

return nothing
end