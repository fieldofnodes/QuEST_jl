# QuEST.jl/src/QuEST.jl
#
# Authors:
#  - Dirk Oliver Theis, Ketita Labs & Uni Tartu
#  - Bahman Ghandchi, Uni Tartu
#
# MIT License
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
#
module QuEST_jl

################################################################################
# 32 bit QuEST
################################################################################

"""
Module `QuEST`𝑥𝑦 — Julia wrapper for QuEST with 𝑥𝑦-bit floating point precision.
"""
module QuEST32
using Libdl: dlopen, dlclose, RTLD_LAZY, RTLD_DEEPBIND, RTLD_GLOBAL

"""
Function `QuEST𝑥𝑦_init()` — initializes 𝑥𝑦-bit QuEST module
"""
function QuEST32_init()
    lib = dlopen("libQuEST32.so",RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
    prec = ccall(:getQuEST_PREC , Cint, (),)
    @assert prec == 1 "Wrong precision. Please rebuild the package"
    return lib
end

function prec__32_close(lib)  # unused
    dlclose(lib)
end

module QuEST_Types  # 32 bit qreal
using CEnum

const MPI_FLOAT  = Cfloat   # This is needed, because ...
const MPI_DOUBLE = Cdouble  # ...

include("../deps/questclang_common_32.jl")

@assert sizeof(Float32)==sizeof(qreal)
end #^ module QuEST_Types
const Qreal = Float32

#
# Include C-wrappers, with correct data types
#

using .QuEST_Types

include("base/data_structure_functions.jl")
include("base/QASM_logging.jl")
include("base/debugging.jl")
include("base/operators.jl")
include("base/decoherence.jl")
include("base/state_init.jl")
include("base/unitaries.jl")
include("base/calculations.jl")
include("base/gates.jl")

end #^ module QuEST32

################################################################################
# 32 bit QuEST
################################################################################

"""
Module `QuEST`𝑥𝑦 — Julia wrapper for QuEST with 𝑥𝑦-bit floating point precision.
"""
module QuEST64
using Libdl: dlopen, dlclose, RTLD_LAZY, RTLD_DEEPBIND, RTLD_GLOBAL

"""
Function `QuEST𝑥𝑦_init()` — initializes 𝑥𝑦-bit QuEST module
"""
function QuEST64_init()
    lib = dlopen("libQuEST64.so",RTLD_LAZY|RTLD_DEEPBIND|RTLD_GLOBAL)
    prec = ccall(:getQuEST_PREC , Cint, (),)
    @assert prec == 2 "Wrong precision. Please rebuild the package"
    return lib
end

function prec__64_close(lib)
    dlclose(lib)
end

module QuEST_Types  # 64 bit qreal
using CEnum

const MPI_FLOAT  = Cfloat   # This is needed, because ...
const MPI_DOUBLE = Cdouble  # ...

include("../deps/questclang_common_64.jl")

@assert sizeof(Float64)==sizeof(qreal)
end #^ module QuEST_Types
const Qreal = Float64

#
# Include C-wrappers, with correct data types
#

using .QuEST_Types

include("base/data_structure_functions.jl")
include("base/QASM_logging.jl")
include("base/debugging.jl")
include("base/operators.jl")
include("base/decoherence.jl")
include("base/state_init.jl")
include("base/unitaries.jl")
include("base/calculations.jl")
include("base/gates.jl")

end #^ module QuEST64

end # module QuEST_jl
# EOF
