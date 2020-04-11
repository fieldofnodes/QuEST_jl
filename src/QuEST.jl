module QuEST

include("QuEST_h.jl")

using .QuEST_h


## Misc #-----------------------------------------------------------------------
#
# QuEST Env
#
#-------------------------------------------------------------------------------

function seedQuESTDefault() ::Nothing
    ccall(:seedQuESTDefault, Cvoid, () )
    return nothing
end

function seedQuEST(seedarray ::Vector{Int}) ::Nothing
    ccall(:seedQuESTDefault, Cvoid, (Ptr{Clong},Cint),
          seedarray, length(seedarray))
    return nothing
end

function void startRecordingQASM(qureg ::Qureg) ::Nothing
    ccall(:startRecordingQASM, Cvoid, (Qureg),
          qureg)
    return nothing
end
function void stopRecordingQASM(qureg ::Qureg) ::Nothing
    ccall(:stopRecordingQASM, Cvoid, (Qureg),
          qureg)
    return nothing
end
function void clearRecordedQASM(qureg ::Qureg) ::Nothing
    ccall(:clearRecordedQASM, Cvoid, (Qureg),
          qureg)
    return nothing
end
function void printRecordedQASM(qureg ::Qureg) ::Nothing
    ccall(:printRecordedQASM, Cvoid, (Qureg),
          qureg)
    return nothing
end
function void writeRecordedQASMToFile(qureg    ::Qureg,
                                      filename ::String) ::Nothing
    ccall(:writeRecordedQASMToFile, Cvoid, (Qureg, Cstring),
          qureg, filename)
    return nothing
end

## Env #------------------------------------------------------------------------
#
# QuEST Env
#
#    - create
#    - destroy
#
#    - seed
#-------------------------------------------------------------------------------

function createQuESTEnv() :: QuESTEnv
    return ccall(:createQuESTEnv, QuESTEnv, ()
                 )
end

function destroyQuESTEnv(env ::QuESTEnv) ::Nothing
    ccall(:destroyQuESTEnv, Cvoid, (QuESTEnv,),
          env)
    return nothing
end

function reportQuESTEnv(env ::QuESTEnv) ::Nothing
    ccall(:reportQuESTEnv, Cvoid, (QuESTEnv,),
          env)
    return nothing
end

function getEnvironmentString(env ::QuESTEnv, qureg ::Qureg) ::String
    cstr = Vector{Cchar}(undef,232)
    ccall(:getEnvironmentString, Cvoid, (QuESTEnv, Qureg, Ptr{Cchar}),
          env, qureg, cstr)
    return unsafe_string(pointer(cstr))
end

function copyStateToGPU(qureg ::Qureg) ::Nothing
    ccall(:copyStateToGPU, Cvoid, (Qureg,),
          qureg)
    return nothing
end

function copyStateFromGPU(qureg ::Qureg) ::Nothing
    ccall(:copyStateFromGPU, Cvoid, (Qureg,),
          qureg)
    return nothing
end

# function syncQuESTEnv(env ::QuESTEnv) ::Nothing
#     ccall(:syncQuESTEnv, Cvoid, (QuESTEnv,),
#           env)
#     return nothing
# end

## Qureg #----------------------------------------------------------------------
#
# Qureg
#
#    1. Create & destroy
#    2. Complex N-matrix
#    3. Report & get
#    4. Init
#    5. Query
#
#-------------------------------------------------------------------------------

#
#  1. Create & Destroy
#


function createQureg(numQubits ::Int, env ::QuESTEnv) ::Qureg
    return ccall(:createQureg, Qureg, (Cint,QuESTEnv),
                 numQubits, env)
end

function createDensityQureg(numQubits ::Int, env ::QuESTEnv) ::Qureg
    return ccall(:createDensityQureg, Qureg, (Cint,QuESTEnv),
                 numQubits, env)
end

function createCloneQureg(qureg ::Qureg, env ::QuESTEnv) ::Qureg
    return ccall(:createCloneQureg, Qureg, (Qureg,QuESTEnv),
                 qureg, env)
end

function destroyQureg(qureg ::Qureg, env ::QuESTEnv) ::Nothing
    ccall(:destroyQureg, Qureg, (Cint,QuESTEnv),
          qureg, env)
    return nothing
end

#
# 2. Complex N-Matrix
#

function createComplexMatrixN(numQubits ::Int) ::ComplexMatrixN;
    return ccall(:createComplexMatrixN, ComplexMatrixN, (Cint,),
                 numQubits)
end

function destroyComplexMatrixN(M ::ComplexMatrixN) ::Nothing
    ccall(:destroyComplexMatrixN, Cvoid, (ComplexMatrixN,),
          M)
    return nothing
end

function fill_ComplexMatrix!(M ::ComplexMatrixN, M_ ::Function) ::Nothing where T
    N = 2^M.numQubits
    for k = 1:N
        re_M_k = unsafe_load(M.real,k)
        im_M_k = unsafe_load(M.real,k)
        for ℓ = 1:N
            unsafe_store!(re_M_k,ℓ) = real( M_(k,ℓ) )
            unsafe_store!(im_M_k,ℓ) = imag( M_(k,ℓ) )
        end
    end
    return nothing
end

#
# 3. Report & get
#


function reportState(qureg ::Qureg) ::Nothing
    ccall(:reportState, Qureg, (),
          qureg)
    return nothing
end

function reportStateToScreen(qureg ::Qureg, env ::QuESTEnv, reportRank ::Int) ::Nothing
    ccall(:reportStateToScreen, Cvoid, (Qureg, QuESTEnv, Cint),
          qureg, env, reportRank)
    return nothing
end


function reportQuregParams(qureg ::Qureg) ::Nothing
    ccall(:reportQuregParams, Cvoid, (Qureg,),
          qureg)
    return nothing
end

function getNumQubits(qureg ::Qureg) ::Int
    return ccall(:getNumQubits, Cint, (Qureg,),
                 qureg)
end


function getNumAmps(qureg ::Qureg) ::Int
    return ccall(:getNumAmps, Clonglong, (Qureg,),
                 qureg)
end


#
# 5. Init state
#

function initBlankState(qureg ::Qureg) ::Nothing
    ccall(:initBlankState, Cvoid, (Qureg,),
          qureg)
    return nothing
end

function initZeroState(qureg ::Qureg) ::Nothing
    ccall(:initZeroState, Cvoid, (Qureg,),
          qureg)
    return nothing
end

function initPlusState(qureg ::Qureg) ::Nothing
    ccall(:initPlusState, Cvoid, (Qureg,),
          qureg)
    return nothing
end

function initClassicalState(qureg ::Qureg, stateInd ::Int64) ::Nothing
    ccall(:initClassicalState, Cvoid, (Qureg,Clonglong),
          qureg,stateInd)
    return nothing
end

function initPureState(qureg ::Qureg, pure ::Qureg) ::Nothing
    ccall(:initPureState, Cvoid, (Qureg,Qureg),
          qureg,pure)
    return nothing
end

function initDebugState(qureg ::Qureg) ::Nothing
    ccall(:initDebugState, Cvoid, (Qureg,),
          qureg)
    return nothing
end

function initStateFromAmps(qureg ::Qureg,
                           reals ::Vector{Qreal},
                           imags ::Vector{Qreal}  ) ::Nothing
    ccall(:initStateFromAmps, Cvoid, (Qureg, Ptr{Qreal}, Ptr{Qreal}),
          qureg, reals, imags)
    return nothing
end

function setAmps(qureg    ::Qureg,
                 startIdx ::Int64,
                 reals    ::Vector{Qreal},
                 imags    ::Vector{Qreal},
                 numAmps  ::Int64)          :: Nothing
    ccall(:setAmps, Cvoid, (Qureg, Clonglong, Ptr{Qreal}, Ptr{Qreal}, Clonglong),
          qureg,  startIdx,  reals, imags, numAmps)
    return nothing
end

function cloneQureg(targetQureg ::Qureg, copyQureg ::Qureg) ::Nothing
    ccall(:cloneQureg, Cvoid, (Qureg, Qureg),
          targetQureg, copyQureg)
    return nothing
end

#
# 7. Query state
#


function getAmp(qureg ::Qureg,  idx ::Int) ::Complex{Qreal}
    α = ccall(:getAmp, QuEST_h.Complex, (Qureg, Clonglong),
               qureg, idx)
    return Complex{Qreal}(α.real,α.imag)
end

function getProbAmp(qureg ::Qureg, idx ::Int) :: Qreal
    ccall(:getProbAmp, Qreal, (Qureg, Clonglong),
               qureg, idx)
    return p
end

function getDensityAmp(qureg ::Qureg, row ::Int, col ::Int) ::Complex{Qreal}
    α = ccall(:getDensityAmp, QuEST_h.Complex, (Qureg, Clonglong, Clonglong),
              qureg, row, col)
    return Complex{Qreal}(α.real, α.imag)
end

function calcTotalProb(qureg ::Qureg) ::Float64
    one = ccall(:calcTotalProb, Qreal, (Qureg,),
                qureg)
    return one
end

function calcProbOfOutcome(qureg        ::Qureg,
                           measureQubit ::Int,
                           outcome      ::Int)   ::Float64
    p = ccall(:calcProbOfOutcome, Qreal, (Qureg, Cint, Cint),
              qureg, measureQubit, outcome)
    return p
end

function  collapseToOutcome(qureg        ::Qureg,
                            measureQubit ::Int,
                            outcome      ::Int)   ::Float64
    p = ccall(:collapseToOutcome, Qreal, (Qureg, Cint, Cint),
              qureg, measureQubit, outcome)
    return p
end

function measure(qureg ::Qureg, measureQubit ::Int) ::Int
    i = ccall(:measure, Cint, (Qureg, Cint),
              qureg, measureQubit)
    return i
end

function measureWithStats(qureg        ::Qureg,
                          measureQubit ::Int     ) ::Tuple{Int,Float64}
    p = Qreal(0.)
    i = ccall(:measureWithStats, Cint, (Qureg, Cint, Ref{Qreal}),
          qureg, measureQubit, p)
    return (Int(i),Float64(p))
end

function calcInnerProduct(bra ::Qureg, ket ::Qureg) ::Complex{Float64}
    w = ccall(:calcInnerProduct, QuEST_h.Complex, (Qureg, Qureg),
          bra, ket)
    return Complex{Float64}(w.real,w.imag)
end

function calcDensityInnerProduct(ϱ1 ::Qureg, ϱ2 ::Qureg) ::Float64
    w = ccall(:calcDensityInnerProduct, Qreal, (Qureg, Qureg),
              ϱ1, ϱ2)
    return Float64(w)
end

## Apply operation #------------------------------------------------------------
#
# Apply quantum operation
#
#    1. Gates
#    2. Unitary matrices
#    3. Noise
#
#-------------------------------------------------------------------------------

#
# 1. Gates
#

function phaseShift(qureg       ::Qureg,
                    targetQubit ::Int,
                    angle       ::Qreal) ::Nothing
    ccall(:phaseShift, Cvoid, (Qureg, Cint, Qreal),
           qureg, targetQubit, angle)
    return nothing
end

function controlledPhaseShift(qureg    ::Qureg,
                              idQubit1 ::Int,
                              idQubit2 ::Int,
                              angle    ::Qreal)   ::Nothing
    ccall(:controlledPhaseShift, Cvoid, (Qureg, Cint, Cint, Qreal),
          qureg, idQubit1, idQubit2, angle)
    return nothing
end

function multiControlledPhaseShift(qureg         ::Qureg,
                                   controlQubits ::Vector{Int32},
                                   angle         ::Qreal)         ::Nothing
    ccall(:multiControlledPhaseShift, Cvoid, (Qureg, Ptr{Cint}, Cint, Qreal)
          qureg, controlQubits, length(controlQubits),  angle),
    return nothing
end

function controlledPhaseFlip(qureg ::Qureg, idQubit1 ::Int, idQubit2 ::Int) ::Nothing
    ccall(:controlledPhaseFlip, Cvoid, (Qureg, Cint, Cint),
           qureg, idQubit1, idQubit2)
    return nothing
end

function multiControlledPhaseFlip(qureg         ::Qureg,
                                  controlQubits ::Vector{Int32}) ::Nothing
    ccall(:multiControlledPhaseFlip, Cvoid, (Qureg, Ptr{Cint}, Cint),
          qureg, controlQubits, length(controlQubits))
    return nothing
end

function sGate(qureg ::Qureg, targetQubit ::Int) ::Nothing
    ccall(:sGate, Cvoid, (Qureg, Cint),
           qureg,  targetQubit)
    return nothing
end

function tGate(qureg ::Qureg, targetQubit ::Int) ::Nothing
    ccall(:tGate, Cvoid, (Qureg, Cint),
          qureg, targetQubit)
    return nothing
end

function pauliX(qureg ::Qureg, targetQubit ::Int):: Nothing
    ccall(:pauliX, Cvoid, (Qureg, Cint),
          qureg,  targetQubit)
    return nothing
end
function pauliY(qureg ::Qureg, targetQubit ::Int):: Nothing
    ccall(:pauliY, Cvoid, (Qureg, Cint),
          qureg,  targetQubit)
    return nothing
end
function pauliZ(qureg ::Qureg, targetQubit ::Int):: Nothing
    ccall(:pauliZ, Cvoid, (Qureg, Cint),
          qureg,  targetQubit)
    return nothing
end

function hadamard(qureg ::Qureg,  targetQubit ::Int) ::Nothing
    ccall(:hadamard, Cvoid, (Qureg, Cint),
          qureg, targetQubit)
    return nothing
end

function controlledNot(qureg         ::Qureg,
                       controlQubit  ::Int,
                       targetQubit   ::int)   ::Nothing
    ccall(:controlledNot, Cvoid, (Qureg, Cint, Cint),
           qureg, controlQubit, targetQubit)
    return nothing
end

function controlledPauliY(qureg         ::Qureg,
                       controlQubit  ::Int,
                       targetQubit   ::int)   ::Nothing
    ccall(:controlledPauliY, Cvoid, (Qureg, Cint, Cint),
           qureg, controlQubit, targetQubit)
    return nothing
end

function controlledPauliZ(qureg         ::Qureg,
                       controlQubit  ::Int,
                       targetQubit   ::int)   ::Nothing
    ccall(:controlledPauliZ, Cvoid, (Qureg, Cint, Cint),
           qureg, controlQubit, targetQubit)
    return nothing
end

function rotateX(qureg ::Qureg, rotQubit ::Int, angle ::Float64) ::Nothing
    ccall(:rotateX, Cvoid, (Qureg, Cint, Qreal),
          qureg, rotQubit, angle)
    return nothing
end
function rotateY(qureg ::Qureg, rotQubit ::Int, angle ::Float64) ::Nothing
    ccall(:rotateY, Cvoid, (Qureg, Cint, Qreal),
          qureg, rotQubit, angle)
    return nothing
end
function rotateZ(qureg ::Qureg, rotQubit ::Int, angle ::Float64) ::Nothing
    ccall(:rotateZ, Cvoid, (Qureg, Cint, Qreal),
          qureg, rotQubit, angle)
    return nothing
end

function rotateAroundAxis(qureg ::Qureg, rotQubit ::Int, angle ::Float64, axis ::Vector) ::Nothing
    ccall(:rotateAroundAxis, Cvoid, (Qureg, Cint, Qreal, Vector),
          qureg, rotQubit, angle, axis)
    return nothing
end

function controlledRotateX(qureg         ::Qureg,
                           controlQubit  ::Int,
                           targetQubit   ::Int,
                           angle         ::Qreal)  ::Nothing
    ccall(:controlledRotateX, Cvoid, (Qureg, Cint, Cint, Qreal),
          qureg, controlQubit, targetQubit, angle)
    return nohting
end

function controlledRotateY(qureg         ::Qureg,
                           controlQubit  ::Int,
                           targetQubit   ::Int,
                           angle         ::Qreal)  ::Nothing
    ccall(:controlledRotateY, Cvoid, (Qureg, Cint, Cint, Qreal),
          qureg, controlQubit, targetQubit, angle)
    return nohting
end

function controlledRotateZ(qureg         ::Qureg,
                           controlQubit  ::Int,
                           targetQubit   ::Int,
                           angle         ::Qreal)  ::Nothing
    ccall(:controlledRotateZ, Cvoid, (Qureg, Cint, Cint, Qreal),
          qureg, controlQubit, targetQubit, angle)
    return nohting
end

function controlledRotateAroundAxis(qureg        ::Qureg,
                                    controlQubit ::Int,
                                    targetQubit  ::Int,
                                    angle        ::Qreal,
                                    axis         ::Vector)  ::Nothing
    ccall(:controlledRotateAroundAxis, Cvoid, (Qureg, Cint, Cint, Qreal, Vector),
          qureg, controlQubit, targetQubit, angle, axis)
    return nothing
end


#
# 2. Apply unitary matrices
#

function compactUnitary(qureg       ::Qureg,
                        targetQubit ::Int,
                        α           ::Complex{Qreal},
                        β           ::Complex{Qreal})   ::Nothing
    alpha = QuEST_h.Complex(real(α),imag(α))
    beta  = QuEST_h.Complex(real(β),imag(β))

    ccall(:compactUnitary, Cvoid, (Qureg, Cint, QuEST_h.Complex, QuEST_h.Complex),
          qureg, targetQubit, alpha, beta)

    return nothing
end

function controlledCompactUnitary(qureg          ::Qureg,
                                  controlQubit   ::Int,
                                  targetQubit    ::Int,
                                  α              ::Complex{Qreal},
                                  β              ::Complex{Qreal} ) ::Nothing
    alpha = QuEST_h.Complex(real(α),imag(α))
    beta  = QuEST_h.Complex(real(β),imag(β))

    ccall(:controlledCompactUnitary, Cvoid, (Qureg, Int, Cint, Complex, Complex),
          qureg, controlQubit, targetQubit, alpha, beta)
    return nothing
    end

function unitary(qureg           ::Qureg,
                 targetQubit     ::Int,
                 U               ::Array{Qreal,2}) ::Nothing
    @assert size(U) == (2,2)
    u = ComplexMatrix2(
        ( (real(u[1,1]), real(u[1,2])), (real(u[2,1]), real(u[2,2])) ),
        ( (imag(u[1,1]), imag(u[1,2])), (imag(u[2,1]), imag(u[2,2])) )  )

    ccall(:unitary, Cvoid, (Qureg, Cint, ComplexMatrix2),
          qureg, targetQubit,  u)
    return nothing
end

function controlledUnitary(qureg        ::Qureg,
                           controlQubit ::Int,
                           targetQubit  ::Int,
                           U            ::Array{Qreal,2}) ::Nothing
    @assert size(U) == (2,2)
    u = ComplexMatrix2(
        ( (real(u[1,1]), real(u[1,2])), (real(u[2,1]), real(u[2,2])) ),
        ( (imag(u[1,1]), imag(u[1,2])), (imag(u[2,1]), imag(u[2,2])) )  )

    ccall(:controlledUnitary, Cvoid, (Qureg, Cint, Cint, u),
          qureg, controlQubit, targetQubit, ComplexMatrix2)
    return nothing
end

function multiControlledUnitary(qureg         ::Qureg,
                                controlQubits ::Vector{Int32},
                                targetQubit   ::Int,
                                U             ::Array{Qreal,2})
    @assert size(U) == (2,2)
    u = ComplexMatrix2(
        ( (real(u[1,1]), real(u[1,2])), (real(u[2,1]), real(u[2,2])) ),
        ( (imag(u[1,1]), imag(u[1,2])), (imag(u[2,1]), imag(u[2,2])) )  )

    ccall(:multiControlledUnitary, Cvoid, (Qureg, Ptr{Cint}, Cint, Cint, ComplexMatrix2),
          qureg, controlQubits, length(controlQubits),  targetQubit, u)
    return nothing
end


#
# 3. Noise
#

function mixDephasing(qureg ::Qureg, targetQubit ::Int, prob ::Float64) ::Nothing
    ccall(:mixDephasing, Cvoid, (Qureg, Cint, Qreal),
          qureg, targetQubit, prob)
    return nothing
end

function mixDepolarising(qureg ::Qureg, targetQubit ::Int, prob ::Float64) ::Nothing
    ccall(:mixDepolarising, Cvoid, (Qureg, Cint, Qreal),
          qureg, targetQubit, prob)
    return nothing
end

function mixDamping(qureg ::Qureg, targetQubit ::Int, prob ::Float64) ::Nothing
    ccall(:mixDamping, Cvoid, (Qureg, Cint, Qreal),
          qureg, targetQubit, prob)
    return nothing
end

function mixTwoQubitDephasing(qureg  ::Qureg,
                              qubit1 ::Int,
                              qubit2 ::Int,
                              prob   ::Float64)   ::Nothing
    ccall(:mixTwoQubitDephasing, Cvoid, (Qureg, Cint, Cint, Qreal),
          qureg, qubit1, qubit2, prob)
    return nothing
end

function mixTwoQubitDepolarising(qureg  ::Qureg,
                              qubit1 ::Int,
                              qubit2 ::Int,
                              prob   ::Float64)   ::Nothing
    ccall(:mixTwoQubitDepolarising, Cvoid, (Qureg, Cint, Cint, Qreal),
          qureg, qubit1, qubit2, prob)
    return nothing
end

function mixPauli(qureg       ::Qureg,
                  targetQubit ::Int,
                  probX       ::Float64,
                  probY       ::Float64,
                  probZ       ::Float64)   ::Nothing
    ccall(:mixPauli, Cvoid, (Qureg, Cint, Qreal, Qreal, Qreal),
          qureg, targetQubit, probX, probY, probZ)
    return nothing
end

CONTINUE HERE 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄 🡄


## Julia Module Init #----------------------------------------------------------
#
# Init
#
#-------------------------------------------------------------------------------

using Libdl

function __init__()
    dlopen("libQuEST",RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
end


end # module
