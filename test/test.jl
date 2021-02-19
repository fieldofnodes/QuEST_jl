using QuEST
import QuEST.QuESTbase32
qjl=QuEST.QuESTbase32
qjl.prec_32__init__()


env = qjl.createQuESTEnv()

qubit = qjl.createQureg(4, env)
qjl.startRecordingQASM(qubit)
#initClassicalState()
qjl.hadamard(qubit, 1)
qjl.hadamard(qubit, 0)

for i=0:3
    print(qjl.getAmp(qubit, i),"\n")
end

#print(qubit)

probs = Array{qjl.Qreal, 1}(undef, 1)

#print(measureWithStats(qubit, 0, probs),"\n")

#print(probs)
print("\n")
qjl.stopRecordingQASM(qubit)
qjl.printRecordedQASM(qubit)
qjl.reportState(qubit)

print(qubit.numQubitsRepresented, "\n")
print(qubit.stateVec, "\n")