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
#    - create
#
#
#-------------------------------------------------------------------------------

function createQureg(numQubits ::Int, env ::QuESTEnv) ::Qureg
    return ccall(:createQureg, Qureg, (Int32,QuESTEnv),
                 numQubits, env)
end

function destroyQureg(qureg ::Qureg, env ::QuESTEnv) ::Nothing
    ccall(:destroyQureg, Qureg, (Int32,QuESTEnv),
          qureg, env)
    return nothing
end

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
