using QuEST
using Test

@show QuEST.Qureg

function test_env()
    env = QuEST.createQuESTEnv()
    test_qureg(env)
    test_densiQureg(env)
    QuEST.syncQuESTEnv(env)
    QuEST.destroyQuESTEnv(env)
end

function test_densiQureg(env ::QuEST.QuESTEnv)
    qureg = QuEST.createDensityQureg(8,env)
    test_2quregs(qureg,env)
    QuEST.destroyQureg(qureg,env)
end

function test_qureg(env ::QuEST.QuESTEnv)
    qureg = QuEST.createQureg(8,env)
    test_2quregs(qureg,env)
    QuEST.destroyQureg(qureg,env)
end

function test_2quregs(q1 ::QuEST.Qureg, q2 ::QuEST.Qureg, env ::QuEST.QuESTEnv)

    M = createComplexMatrixN(3)
    fill_ComplexMatrixN!(M, (k,ℓ) -> exp(i*(k+ℓ))/sqrt(8) )
    ...
    destroyComplexMatrixN(M)


    q11 = createCloneQureg(q1,env)
    q22 = createCloneQureg(q2,env)

end




test_env()

# EOF
