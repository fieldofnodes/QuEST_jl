# Automatically generated using Clang.jl


const QuEST_PREC = 2
const MPI_QuEST_REAL = MPI_DOUBLE
const MPI_MAX_AMPS_IN_MSG = Int64(1) << 28
const REAL_STRING_FORMAT = "%.14f"
const REAL_QASM_FORMAT = "%.14g"
const REAL_EPS = 1.0e-13
const REAL_SPECIFIER = "%lf"

# Skipping MacroDefinition: absReal ( X ) fabs ( X )

const qreal = Cfloat

# Skipping MacroDefinition: float_complex ( r , i ) ( ( float ) ( r ) + ( ( float ) ( i ) ) * I )
# Skipping MacroDefinition: double_complex ( r , i ) ( ( double ) ( r ) + ( ( double ) ( i ) ) * I )
# Skipping MacroDefinition: long_double_complex ( r , i ) ( ( long double ) ( r ) + ( ( long double ) ( i ) ) * I )
# Skipping MacroDefinition: toComplex ( scalar ) ( ( Complex ) { . real = creal ( scalar ) , . imag = cimag ( scalar ) } )
# Skipping MacroDefinition: fromComplex ( comp ) qcomp ( comp . real , comp . imag )

struct Complex
    real::qreal
    imag::qreal
end

const float_complex = Complex
const double_complex = Complex
const long_double_complex = Complex

# Skipping MacroDefinition: UNPACK_ARR ( ... ) __VA_ARGS__

@cenum phaseGateType::UInt32 begin
    SIGMA_Z = 0
    S_GATE = 1
    T_GATE = 2
end


struct QASMLogger
    buffer::Cstring
    bufferSize::Cint
    bufferFill::Cint
    isLogging::Cint
end

struct ComplexArray
    real::Ptr{qreal}
    imag::Ptr{qreal}
end

@cenum pauliOpType::UInt32 begin
    PAULI_I = 0
    PAULI_X = 1
    PAULI_Y = 2
    PAULI_Z = 3
end


struct ComplexMatrix2
    real::NTuple{2, NTuple{2, qreal}}
    imag::NTuple{2, NTuple{2, qreal}}
end

struct ComplexMatrix4
    real::NTuple{4, NTuple{4, qreal}}
    imag::NTuple{4, NTuple{4, qreal}}
end

struct ComplexMatrixN
    numQubits::Cint
    real::Ptr{Ptr{qreal}}
    imag::Ptr{Ptr{qreal}}
end

struct Vector
    x::qreal
    y::qreal
    z::qreal
end

struct PauliHamil
    pauliCodes::Ptr{pauliOpType}
    termCoeffs::Ptr{qreal}
    numSumTerms::Cint
    numQubits::Cint
end

struct DiagonalOp
    numQubits::Cint
    numElemsPerChunk::Clonglong
    numChunks::Cint
    chunkId::Cint
    real::Ptr{qreal}
    imag::Ptr{qreal}
    deviceOperator::ComplexArray
end

struct Qureg
    isDensityMatrix::Cint
    numQubitsRepresented::Cint
    numQubitsInStateVec::Cint
    numAmpsPerChunk::Clonglong
    numAmpsTotal::Clonglong
    chunkId::Cint
    numChunks::Cint
    stateVec::ComplexArray
    pairStateVec::ComplexArray
    deviceStateVec::ComplexArray
    firstLevelReduction::Ptr{qreal}
    secondLevelReduction::Ptr{qreal}
    qasmLog::Ptr{QASMLogger}
end

struct QuESTEnv
    rank::Cint
    numRanks::Cint
end
