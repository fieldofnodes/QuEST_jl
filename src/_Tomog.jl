# QuEST.jl/src/_Tomog.jl
# (License stuff)

@doc raw"

Module `_Tomog`

Hosts the code for quantum process tomography.

## Exports

...

"
module _Tomog

import ..QuEST
using ..QuEST: Qureg, numQubits, isDensityMatrix
using ..QuEST: createCloneQureg
using ..QuEST: calcExpecPauliProd

import Base.iterate, eltype

#
# State tomography based on Julia iterators avoids having to store the whole matrix
#
# Items: Float64
# Iters: struct `State_Tomog_Iter`
# State: UInt64 number representing the Pauli observable
#

struct State_Tomog_Iter
    qr        ::Qureg
    qubits    ::Vector{Cint}   # = [0,1,2, ..., n-1] -- this will not change!
    pauli     ::Vector{Cint}
    workspace ::Qureg

    # constructor
    function State_Tomog_Iter(qr::Qureg
                              ;
                              workspace::Qureg=createCloneQureg(qr))
        @assert numQubits(qr) ≤ 32
        @assert numQubits(qr)==numQubits(workspace)
        @assert isDensityMatrix(qr) == isDensityMatrix(workspace)

        local n = numQubits(qr)
        qubits = Cint[  j   for j =  0 : n-1]
        new(qr,qubits,zeros(Cint,n),workspace)
    end
end

function _inc(σ ::Vector{Cint}) ::Vector{Cint}
    @assert 0 < length(σ) ≤ 32
    local n = length(σ)

    for idx = 1:n
        @assert σ[idx] ∈ 0:3
        σ[idx] = ( σ[idx] + 1 ) % 4
        if σ[idx]==0    break   end
    end
    return σ
end

function iterate(sti ::State_Tomog_Iter,
                 σ   ::UInt64          =UInt64(0)) ::Union{ Nothing, Pair{Float64, UInt64} }
    local n = numQubits(sti.qr)
    if σ > ( 1 << (2*n) )
        return nothing
    else
        local expval = calcExpecPauliProd(sti.qr, sti.qubits,
                                          sti.pauli,
                                          n, sti.workspace)
        _inc(sti.pauli)
        σ += 1
        return (expval, σ)
end

eltype(State_Tomog_Iter) = UInt64

@doc raw"
Function `prepare!(qureg ::Qureg, 𝑥 ::UInt16) ::Qureg`

Prepares the given quantum register in the state |𝑥⟩.

### Requires
* 0 ≤ 𝑥 < 2ⁿ, where 𝑛 is the number of qubits in `qureg`
"
function prepare!(qureg ::Qureg, x ::UInt16) ::Qureg
    @assert 0 ≤ x < numQubits(qureg)

    ...
end

@doc raw"
Function `prepareX!(qureg ::Qureg, 𝑥 ::UInt16, 𝑦 ::UInt16, minus::Bool) ::Qureg`

Prepares the given quantum register in the state ( |𝑥⟩ ± |𝑦⟩ )/√2, where the sign is determined by `minus`.

### Requires
* 0 ≤ 𝑥,y < 2ⁿ, where 𝑛 is the number of qubits in `qureg`
* 𝑥 ≠ 𝑦
"
function prepare!(qureg ::Qureg, x ::UInt16, y::UInt16, minus::Bool) ::Qureg
    @assert 0 ≤ x < numQubits(qureg)
    @assert 0 ≤ y < numQubits(qureg)
    @assert x ≠ y

    ...
end

function is_proc_tomog_equal
end

end #^ module _Tomog
#EOF
