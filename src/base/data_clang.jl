module QuEST_types
using CEnum
import ..Qreal
export QASMLogger, ComplexMatrix2, ComplexArray, ComplexMatrix4, 
       ComplexMatrixN, DiagonalOp, PauliHamil, QuESTEnv, Qureg


const MPI_DOUBLE = Cdouble

include("../libclang_common.jl")


end # QuEST_types

using .QuEST_types