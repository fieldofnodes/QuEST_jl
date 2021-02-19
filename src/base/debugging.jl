function copyStateFromGPU(qureg ::Qureg) ::Nothing
        
    ccall(:copyStateFromGPU, Cvoid, (Qureg,), qureg)
    return nothing
    
end

function copyStateToGPU(qureg ::Qureg) ::Nothing
        
    ccall(:copyStateToGPU, Cvoid, (Qureg,), qureg)
    return nothing
    
end

function getEnvironmentString(env ::QuESTEnv, qureg ::Qureg) ::String
        
    cstr = Vector{Cchar}(undef,232)
    ccall(:getEnvironmentString, Cvoid, (QuESTEnv, Qureg, Ptr{Cchar}), env, qureg, cstr)
        
    return unsafe_string(pointer(cstr))
    
end

function initDebugState(qureg ::Qureg) ::Nothing
        
    ccall(:initDebugState, Cvoid, (Qureg,), qureg)
    return nothing
    
end

#
#void 	invalidQuESTInputError (const char *errMsg, const char *errFunc)
#An internal function called when invalid arguments are passed to a QuEST API call, which the user can optionally override by redefining.  More...
# 

function reportPauliHamil(hamil     ::PauliHamil)   ::Nothing

    ccall(:reportPauliHamil, Cvoid, (PauliHamil,), hamil)
    return nothing

end

function reportQuESTEnv(env ::QuESTEnv) ::Nothing
        
    ccall(:reportQuESTEnv, Cvoid, (QuESTEnv,), env)
    return nothing
    
end

function reportQuregParams(qureg ::Qureg) ::Nothing
        
    ccall(:reportQuregParams, Cvoid, (Qureg,), qureg)
    return nothing
    
end

function reportState(qureg ::Qureg) ::Nothing
            
    ccall(:reportState, Cvoid, (Qureg,), qureg)
    return nothing
        
end

function reportStateToScreen(qureg ::Qureg, env ::QuESTEnv, reportRank ::T where T<:Integer) ::Nothing
            
    ccall(:reportStateToScreen, 
          Cvoid, 
          (Qureg, QuESTEnv, Cint),
          qureg, 
          env, 
          Cint(reportRank))
    
    return nothing
        
end

function seedQuEST(seedarray ::Base.Vector{Clong}) ::Nothing

    @assert  ! isempty(seedarray)
        
    ccall(:seedQuESTDefault, 
          Cvoid, (Ptr{Clong}, Cint),
          Clong.(seedarray), 
          Cint(length(seedarray)))
            
    return nothing
        
end

function seedQuESTDefault() ::Nothing
            
    ccall(:seedQuESTDefault, Cvoid, () )
    return nothing
        
end

function syncQuESTEnv(env ::QuESTEnv) ::Nothing
    
    ccall(:syncQuESTEnv, Cvoid, (QuESTEnv,), env)
    return nothing

end
  
function syncQuESTSuccess(successCode       ::T where T<:Integer)       ::Cint

    ret = ccall(:syncQuESTSuccess, Cint, (Cint,), Cint(successCode))
    return ret

end