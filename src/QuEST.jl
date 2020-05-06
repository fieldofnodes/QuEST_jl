# QuEST.jl/src/QuEST.jl
#
# Authors:
#  - Dirk Oliver Theis, Ketita Labs
#
# Copyright (c) 2020 Ketita Labs oü, Tartu, Estonia
#
# MIT License
#
# Copyright (c) 2020 Ketita Labs oü, Tartu, Estonia
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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
    @assert  ! isempty(seedarray)

    ccall(:seedQuESTDefault, Cvoid, (Ptr{Clong},Cint),
          seedarray, length(seedarray))
    nothing;
end

function startRecordingQASM(qureg ::Qureg) ::Nothing
    ccall(:startRecordingQASM, Cvoid, (Qureg,),
          qureg)
    nothing;
end
function stopRecordingQASM(qureg ::Qureg) ::Nothing
    ccall(:stopRecordingQASM, Cvoid, (Qureg,),
          qureg)
    nothing;
end
function clearRecordedQASM(qureg ::Qureg) ::Nothing
    ccall(:clearRecordedQASM, Cvoid, (Qureg,),
          qureg)
    nothing;
end
function printRecordedQASM(qureg ::Qureg) ::Nothing
    ccall(:printRecordedQASM, Cvoid, (Qureg,),
          qureg)
    nothing;
end
function writeRecordedQASMToFile(qureg    ::Qureg,
                                 filename ::String) ::Nothing
    @assert begin
        ios = open(filename, "w")
        close(ios) == nothing
    end

    ccall(:writeRecordedQASMToFile, Cvoid, (Qureg, Cstring),
          qureg, filename)
    nothing;
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
    return ccall(:createQuESTEnv, QuESTEnv, () )
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
#    6. Measure Copenhagen
#
#-------------------------------------------------------------------------------

#
#  1. Create & Destroy
#


function createQureg(numQubits ::Int, env ::QuESTEnv) ::Qureg
    @assert 1 ≤ numQubits ≤ 50

    return ccall(:createQureg, Qureg, (Cint,QuESTEnv),
                 numQubits, env)
end

function createDensityQureg(numQubits ::Int, env ::QuESTEnv) ::Qureg
    @assert 1 ≤ numQubits ≤ 50

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
    @assert 1 ≤ numQubits ≤ 50

    return ccall(:createComplexMatrixN, ComplexMatrixN, (Cint,),
                 numQubits)
end

function make_QuEST_matrix(M ::Matrix{Qreal}) ::ComplexMatrixN
    (R,C) = size(M)
    @assert R==C
    @assert R ≥ 2
    numQubits = Int(round( log2(R) ))
    @assert 2^numQubits == R
    @assert 1 ≤ numQubits ≤ 50

    MQ = createComplexMatrixN(numQubits)
    for c = 1:R                       # Julia is column major
        for r = 1:R
            re_MQ_r = unsafe_load(M.real,r)
            im_MQ_r = unsafe_load(M.real,r)
            unsafe_store!(re_MQ_r, real(M[r,c]), c)
            unsafe_store!(im_MQ_r, imag(M[r,c]), c)
        end
    end
    return MQ
end

function destroyComplexMatrixN(M ::ComplexMatrixN) ::Nothing
    ccall(:destroyComplexMatrixN, Cvoid, (ComplexMatrixN,),
          M)
    nothing
end

function fill_ComplexMatrix!(M ::ComplexMatrixN, M_ ::Function) ::Nothing
    N = 2^M.numQubits
    for k = 1:N
        re_M_k = unsafe_load(M.real,k)
        im_M_k = unsafe_load(M.real,k)
        for ℓ = 1:N
            unsafe_store!(re_M_k, real(M_(k,ℓ)), ℓ)
            unsafe_store!(im_M_k, imag(M_(k,ℓ)), ℓ)
        end
    end
    nothing
end

#
# 3. Report & get
#


function reportState(qureg ::Qureg) ::Nothing
    ccall(:reportState, Cvoid, (Qureg,),
          qureg)
    nothing;
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


## WIP: CONTINUE HERE with adding `@assert`s

#
# 4. Init state
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


function setWeightedQureg(fac1   ::Complex{Float64},   qureg1 ::Qureg,
                          fac2   ::Complex{Float64},   qureg2 ::Qureg,
                          facOut ::Complex{Float64},   out    ::Qureg) ::Nothing
    ccall(:setWeightedQureg,
          Cvoid,
          (QuEST_h.Complex, Qureg,
           QuEST_h.Complex, Qureg,
           QuEST_h.Complex, Qureg),
          QuEST_h.Complex(Qreal(real(fac1)),Qreal(real(fac1))), qureg1,
          QuEST_h.Complex(Qreal(real(fac2)),Qreal(real(fac2))), qureg2,
          QuEST_h.Complex(Qreal(real(out)),Qreal(real(out))), out)
    nothing;
end

#
# 5. Query state
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



function calcExpecPauliProd(qureg        ::Qureg,
                            targetQubits ::Vector{Int32},
                            pauliCodes   ::Vector{Int32},
                            workspace    ::Qureg)          ::Float64
    @assert length(targetQubits) == length(pauliCodes)
    @assert all( σ -> 0 ≤ σ ≤ 3,   pauliCodes )

    ccall(:calcExpecPauliProd, Qreal, (Qureg, Ptr{Cint}, Ptr{Cint}, Cint, Qureg),
          qureg, targetQubits, pauliCodes, length(targetQubits),  workspace)

    return nothing
end

function calcExpecPauliSum(qureg         ::Qureg,
                           allPauliCodes ::Vector{Int32},
                           termCoeffs    ::Vector{Qreal},
                           workspace     ::Qureg)          ::Float64

    @assert length(allPauliCodes) ==  length(termCoeffs) * getNumQubits(qureg)
    @assert all( σ -> 0 ≤ σ ≤ 3,  allPauliCodes )

    ex = ccall(:calcExpecPauliSum, Qreal, (Qureg, Ptr{Cint}, Ptr{Qreal}, Cint, Qureg),
               qureg, allPauliCodes, termCoeffs, length(termCoeffs),  workspace)

    return ex
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

function calcPurity(qureg ::Qureg) ::Float64
    pu = ccall(:calcPurity, Qreal, (Qureg,),
               qureg)
    return pu
end

function calcFidelity(qureg ::Qureg, pureState ::Qureg) ::Float64
    fi = ccall(:calcFidelity, Qreal, (Qureg, Qureg),
               qureg, pureState)
    return fi
end

function calcHilbertSchmidtDistance(a ::Qureg, b ::Qureg) ::Float64
    hsd = ccall(:calcHilbertSchmidtDistance, Qreal, (Qureg, Qureg),
                a, b)
    return hsd
end

#
# 6. Copenhagen measure
#

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

## Apply operation #------------------------------------------------------------
#
# Apply quantum operation
#
#    1. Gates
#    2. Unitary matrices
#    3. Noise
#    4. Other ops
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
    ccall(:multiControlledPhaseShift, Cvoid, (Qureg, Ptr{Cint}, Cint, Qreal),
          qureg, controlQubits, length(controlQubits),  angle)
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
                       targetQubit   ::Int)   ::Nothing
    ccall(:controlledNot, Cvoid, (Qureg, Cint, Cint),
           qureg, controlQubit, targetQubit)
    return nothing
end

function controlledPauliY(qureg         ::Qureg,
                       controlQubit  ::Int,
                       targetQubit   ::Int)   ::Nothing
    ccall(:controlledPauliY, Cvoid, (Qureg, Cint, Cint),
           qureg, controlQubit, targetQubit)
    return nothing
end

function controlledPauliZ(qureg         ::Qureg,
                       controlQubit  ::Int,
                       targetQubit   ::Int)   ::Nothing
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

function multiRotateZ(qureg      ::Qureg,
                      qubits     ::Vector{Int32},
                      angle      ::Qreal)         ::Nothing
    ccall(:multiRotateZ, Cvoid, (Qureg, Ptr{Cint}, Cint, Qreal),
          qureg, qubits, length(qubits), angle)
    return nothing
end

function multiRotatePauli(qureg         ::Qureg,
                          targetQubits  ::Vector{Int32},
                          targetPaulis  ::Vector{Int32},
                          angle         ::Qreal)          ::Nothing
    @assert length(targetQubits) == length(targetPaulis)
    @assert all( σ -> 0 ≤ σ ≤ 3,   targetPaulis )

    ccall(:multiRotatePauli, Cvoid, (Qureg, Ptr{Cint}, Ptr{Cint}, Cint, Qreal),
          qureg, targetQubits, targetPaulis, length(targetPaulis), angle)

    return nothing
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


function swapGate(qureg ::Qureg, qubit1 ::Int, qubit2 ::Int) ::Nothing
    ccall(:swapGate, Cvoid, (Qureg, Cint, Cint),
          qureg, qubit1, qubit2)
    return nothing
end

function sqrtSwapGate(qureg ::Qureg, qubit1 ::Int, qubit2 ::Int) ::Nothing
    ccall(:sqrtSwapGate, Cvoid, (Qureg, Cint, Cint),
          qureg, qubit1, qubit2)
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

function _quest_mtx_2(U ::Matrix{Complex{Qreal}}) ::ComplexMatrix2
    @assert size(U) == (2,2)
    u = ComplexMatrix2(
        ( (real(u[1,1]), real(u[1,2])), (real(u[2,1]), real(u[2,2])) ),
        ( (imag(u[1,1]), imag(u[1,2])), (imag(u[2,1]), imag(u[2,2])) )  )
    return u
end

function unitary(qureg           ::Qureg,
                 targetQubit     ::Int,
                 U               ::Matrix{Complex{Qreal}}) ::Nothing

    u = _quest_mtx_2(U)

    ccall(:unitary, Cvoid, (Qureg, Cint, ComplexMatrix2),
          qureg, targetQubit,  u)
    return nothing
end

function controlledUnitary(qureg        ::Qureg,
                           controlQubit ::Int,
                           targetQubit  ::Int,
                           U            ::Matrix{Complex{Qreal}}) ::Nothing

    u = _quest_mtx_2(U)

    ccall(:controlledUnitary, Cvoid, (Qureg, Cint, Cint, ComplexMatrix2),
          qureg, controlQubit, targetQubit, u)
    return nothing
end

function multiControlledUnitary(qureg         ::Qureg,
                                controlQubits ::Vector{Int32},
                                targetQubit   ::Int,
                                U             ::Matrix{Complex{Qreal}}) ::Nothing
    u = _quest_mtx_2(U)

    ccall(:multiControlledUnitary, Cvoid, (Qureg, Ptr{Cint}, Cint, Cint, ComplexMatrix2),
          qureg, controlQubits, length(controlQubits),  targetQubit, u)
    return nothing
end

function multiStateControlledUnitary(qureg           ::Qureg,
                                     controlQubits   ::Vector{Int32},
                                     controlState    ::Vector{Int32},
                                     targetQubit     ::Int,
                                     U               ::Matrix{Complex{Qreal}}) ::Nothing

    @assert length(controlQubits) == length(controlState)
    u = _quest_mtx_2(U)

    ccall(:multiStateControlledUnitary,
          Cvoid,
          (Qureg, Ptr{Cint}, Ptr{Cint}, Cint, Cint, ComplexMatrix2),
          qureg, controlQubits, controlState, length(controlQubits), targetQubit, u)
    return nothing
end

function _quest_mtx_4(U ::Matrix{Complex{Qreal}}) ::ComplexMatrix4
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


function twoQubitUnitary(qureg           ::Qureg,
                         targetQubit1    ::Int,
                         targetQubit2    ::Int,
                         U               ::Matrix{Complex{Qreal}}) ::Nothing
    u = _quest_mtx_4(U)
    ccall(:twoQubitUnitary, Cvoid, (Qureg, Cint, Cint, ComplexMatrix4),
          qureg, targetQubit1, targetQubit2, u)

    return nothing
end



function controlledTwoQubitUnitary(qureg         ::Qureg,
                                   controlQubit  ::Int,
                                   targetQubit1  ::Int,
                                   targetQubit2  ::Int,
                                   U             ::Matrix{Complex{Qreal}}) ::Nothing
    u = _quest_mtx_4(U)
    ccall(:controlledTwoQubitUnitary, Cvoid, (Qureg, Cint, Cint, Cint, ComplexMatrix4),
          qureg, controlQubit, targetQubit1, targetQubit2, u)
    return nothing
end

function multiControlledTwoQubitUnitary(qureg         ::Qureg,
                                        controlQubits ::Vector{Int32},
                                        targetQubit1 ::Int,
                                        targetQubit2 ::Int,
                                        U            ::Matrix{Complex{Qreal}}) ::Nothing
    u = _quest_mtx_4(U)
    ccall(:multiControlledTwoQubitUnitary, Cvoid, (Qureg, Ptr{Cint}, Cint, Cint, Cint, ComplexMatrix4),
          qureg, controlQubits, length(controlQubits),  targetQubit1, targetQubit2, u)
    return nothing
end

function multiQubitUnitary(qureg ::Qureg,
                           targs ::Vector{Int32},
                           u     ::ComplexMatrixN) ::Nothing
    ccall(:multiQubitUnitary, Cvoid, (Qureg, Ptr{Cint}, Cint, ComplexMatrixN),
          qureg, targs, length(targs), u)
    return nothing
end

function controlledMultiQubitUnitary(qureg   ::Qureg,
                                     ctrl    ::Int,
                                     targs   ::Vector{Int32},
                                     u       ::ComplexMatrixN) ::Nothing
    ccall(:controlledMultiQubitUnitary, Cvoid, (Qureg, Cint, Ptr{Cint}, Cint, ComplexMatrixN),
          qureg, ctrl, targs, length(targs), u)
    return nothing
end

function multiControlledMultiQubitUnitary(qureg  ::Qureg,
                                          ctrls  ::Vector{Int32},
                                          targs  ::Vector{Int32},
                                          u      ::ComplexMatrixN) ::Nothing
    ccall(:multiControlledMultiQubitUnitary,
          Cvoid,
          (Qureg, Ptr{Cint}, Cint, Ptr{Cint}, Cint, ComplexMatrixN),
          qureg, ctrls, length(ctrls), targs, length(targs), u)
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

function mixDensityMatrix(combineQureg ::Qureg,
                          prob         ::Qreal,
                          otherQureg   ::Qureg)  ::Nothing
    ccall(:mixDensityMatrix, Cvoid, (Qureg, Qreal, Qureg),
          combineQureg, prob, otherQureg)
    return nothing
end

function mixKrausMap(qureg   ::Qureg,
                     target  ::Int,
                     ops     ::Vector{Matrix{Complex{Qreal}}}) ::Nothing

    @assert 1 ≤ length(ops) ≤ 4
    qops = [ _quest_mtx_2(op) for op in ops ]
    ccall(:mixKrausMap, Cvoid, (Qureg, Cint, Ptr{ComplexMatrix2}, Cint),
          qureg, target, qops, length(ops))
    nothing;
end

function mixTwoQubitKrausMap(qureg    ::Qureg,
                             target1  ::Int,
                             target2  ::Int,
                             ops      ::Vector{Matrix{Complex{Qreal}}}) ::Nothing
    @assert 1 ≤ length(ops) ≤ 16
    qops = [ _quest_mtx_4(op) for op in ops ]
    ccall(:mixTwoQubitKrausMap,
          Cvoid,
          (Qureg, Cint, Cint, Ptr{ComplexMatrix4}, Cint),
          qureg, target1, target2, qops, length(ops))
    nothing;
end

function mixMultiQubitKrausMap(qureg    ::Qureg,
                               targets  ::Vector{Int32},
                               ops      ::Vector{ComplexMatrixN}) ::Nothing
    N = length(targets)
    @assert 1 ≤ length(ops) ≤ (2N)^2
    ccall(:mixMultiQubitKrausMap, Cvoid,
          (Qureg, Ptr{Cint}, Cint, Ptr{ComplexMatrixN}, Cint),
           qureg, targets, length(targets), ops, length(ops))
    nothing;
end

#
# 4. Other ops
#

function applyPauliSum(inQureg        ::Qureg,
                       allPauliCodes  ::Vector{Int32},
                       termCoeffs     ::Vector{Qreal},
                       numSumTerms    ::Int,
                       outQureg       ::Qureg)          ::Nothing
    @assert length(termCoeffs) == numSumTerms * getNumQubits(qureg)

    ccall(:applyPauliSum, Cvoid, (Qureg, Ptr{Cint}, Ptr{Qreal}, Cint, Qureg),
          inQureg, allPauliCodes, termCoeffs, numSumTerms, outQureg)

    nothing;
end

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
# EOF
