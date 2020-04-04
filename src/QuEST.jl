module QuEST

include("QuEST_h.jl")

using .QuEST_h

## Env #------------------------------------------------------------------------
#
# QuEST Env
#
#    - create
#    - destroy
#    - sync
#
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

function syncQuESTEnv(env ::QuESTEnv) ::Nothing
    ccall(:syncQuESTEnv, Cvoid, (QuESTEnv,),
          env)
    return nothing
end

## Qureg #----------------------------------------------------------------------
#
# Qureg
#
#    1. Create & destroy
#    2. Complex N-matrix
#    3. Report & get
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

initStateFromAmps(Qureg qureg, reals ::Vector{Qreal}, imags ::Vector{Qreal} ) ::Nothing
void initStateFromAmps(Qureg qureg, qreal* reals, qreal* imags);



## Init #-----------------------------------------------------------------------
#
# Init
#
#-------------------------------------------------------------------------------

using Libdl

function __init__()
    dlopen("libQuEST",RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
end


end # module
