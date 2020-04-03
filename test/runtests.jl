using QuEST
using Test

@show QuEST.Qureg

function test_env()
    env = QuEST.createQuESTEnv()
    @show env
    test_qureg(env)
    QuEST.syncQuESTEnv(env)
    QuEST.destroyQuESTEnv(env)
end

function test_qureg(env ::QuEST.QuESTEnv)
    qureg = QuEST.createQureg(10,env)
end





test_env()

# EOF
