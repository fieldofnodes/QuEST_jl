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

#include("./_QuEST_Internals.jl")
#include("./_C_QuEST.jl")

#import _C_QuEST: numQubits, isDensityMatrix # ...
#export numQubits, isDensityMatrix

export prec_32__init__
export prec_64__init__

################################################################################

module QuESTbase32
using Libdl: dlopen, dlclose, RTLD_LAZY, RTLD_DEEPBIND, RTLD_GLOBAL
const Qreal = Cfloat

export prec_32__init__

function prec_32__init__()
    lib = dlopen("libQuEST32.so",RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
    #dlopen(joinpath(@__DIR__,"C","lib_C_QuEST32.so"), RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)

    prec = ccall(:getQuEST_PREC , Cint, (),)

    @assert prec == 1 "Wrong precision. Please rebuild the package"

    return lib

end

function prec__32_close(lib)
    dlclose(lib)
end

#include("base/data_structures.jl")
module QuEST_types
using CEnum
import ..Qreal
export QASMLogger, ComplexMatrix2, ComplexArray, ComplexMatrix4, 
       ComplexMatrixN, DiagonalOp, PauliHamil, QuESTEnv, Qureg, pauliOpType


const MPI_DOUBLE = Cdouble

include("./libclang_common_32.jl")


end # QuEST_types

using .QuEST_types
include("base/data_structure_functions.jl")
include("base/QASM_logging.jl")
include("base/debugging.jl")
include("base/operators.jl")
include("base/decoherence.jl")
include("base/state_init.jl")
include("base/unitaries.jl")
include("base/calculations.jl")
include("base/gates.jl")

end

################################################################################

module QuESTbase64
using Libdl: dlopen, dlclose, RTLD_LAZY, RTLD_DEEPBIND, RTLD_GLOBAL
const Qreal = Cdouble

export prec_64__init__

function prec_64__init__()
    lib = dlopen("libQuEST64.so",RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
    #dlopen(joinpath(@__DIR__,"C","lib_C_QuEST64.so"), RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)

    prec = ccall(:getQuEST_PREC , Cint, (),)

    @assert prec == 2 "Wrong precision. Please rebuild the package"

    return lib

end

function prec__64_close(lib)
    dlclose(lib)
end

#include("base/data_structures.jl")
module QuEST_types
using CEnum
import ..Qreal
export QASMLogger, ComplexMatrix2, ComplexArray, ComplexMatrix4, 
       ComplexMatrixN, DiagonalOp, PauliHamil, QuESTEnv, Qureg, pauliOpType


const MPI_DOUBLE = Cdouble

include("./libclang_common_64.jl")


end # QuEST_types

using .QuEST_types
include("base/data_structure_functions.jl")
include("base/QASM_logging.jl")
include("base/debugging.jl")
include("base/operators.jl")
include("base/decoherence.jl")
include("base/state_init.jl")
include("base/unitaries.jl")
include("base/calculations.jl")
include("base/gates.jl")

end

end # module
# EOF
