# QuEST.jl/test/runtests.jl
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

using QuEST
using Test

function test_env_and_qureg()

    function test_2quregs(q ::QuEST.Qureg, env ::QuEST.QuESTEnv)
        q1 = QuEST.createCloneQureg(q,env)
        q2 = QuEST.createCloneQureg(q,env)
        @warn "need more here"
    end
    function test_qureg(env ::QuEST.QuESTEnv)
        qureg = QuEST.createQureg(8,env)
        test_2quregs(qureg,env)
        QuEST.destroyQureg(qureg,env)
        @warn "need more here"
    end
    
    function test_densiQureg(env ::QuEST.QuESTEnv)
        qureg = QuEST.createDensityQureg(8,env)
        test_2quregs(qureg,env)
        QuEST.destroyQureg(qureg,env)
        @warn "need more here"
    end
    
    function test_matrices()
        M = QuEST.createComplexMatrixN(3)
        QuEST.fill_ComplexMatrix!(M, (k,ℓ) -> exp(im*(k+ℓ))/sqrt(8) )
        QuEST.destroyComplexMatrixN(M)
        @warn "need more here"
    end


    env = QuEST.createQuESTEnv()
    test_qureg(env)
    test_densiQureg(env)
    QuEST.destroyQuESTEnv(env)

    test_matrices()
end

#
@testset "QuEST.jl" begin
    test_env_and_qureg()
end

# EOF
