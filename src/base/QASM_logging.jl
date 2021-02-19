function clearRecordedQASM(qureg ::Qureg) ::Nothing
        
    ccall(:clearRecordedQASM, Cvoid, (Qureg,), qureg)
    
    return nothing

end

function printRecordedQASM(qureg ::Qureg) ::Nothing
        
    ccall(:printRecordedQASM, Cvoid, (Qureg,), qureg)
    return nothing
    
end

function startRecordingQASM(qureg ::Qureg) ::Nothing
        
    ccall(:startRecordingQASM, Cvoid, (Qureg,), qureg)
    return nothing
    
end

function stopRecordingQASM(qureg ::Qureg) ::Nothing
        
    ccall(:stopRecordingQASM, Cvoid, (Qureg,), qureg)
    return nothing
    
end
  
function writeRecordedQASMToFile(qureg    ::Qureg,
                                 filename ::String) ::Nothing

    @assert begin
        ios = open(filename, "w")
        close(ios) === nothing
    end

    ccall(:writeRecordedQASMToFile, Cvoid, (Qureg, Cstring), qureg, filename)
    return nothing

end