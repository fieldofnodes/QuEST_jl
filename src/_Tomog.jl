# QuEST.jl/src/_Tomog.jl
# (License stuff)

@doc raw"

Module `_Tomog`

Hosts the code for quantum process tomography.

## Exports
* Iterator type `StateTomog_Iter`
* Function `distance()` between two iterators

# Extended Help

## State tomography

State tomography is based on iterators.  That avoids having to store the whole matrix.
Julia iterators involve 3 concepts: Items, Iters, and State. Here:
* Items: Float64
* Iters: struct `StateTomog_Iter`
* State: UInt64 number representing the Pauli observable (4 bit per qubit)

## Process tomography
...
"
module _Tomog

export StateTomog_Iter
export distance

import ..QuEST
using ..QuEST: Qureg, numQubits, isDensityMatrix
using ..QuEST: QuESTEnv, createCloneQureg, destroyQureg
using ..QuEST: calcExpecPauliProd

import Base: iterate, eltype, length              # Iterator interface

import LinearAlgebra

using  Quadmath: Float128
const LngDbl = Float128

############################################################################
#                                                                          #
#   State tomography                                                       #
#                                                                          #
############################################################################
@doc raw"
Struct `StateTomog_Iter`

Iterator type for state tomograpy.
Constructor function:
    StateTomog_Iter( ::Qureg, ::QuESTEnv)
"
struct StateTomog_Iter
    qr        ::Qureg
    questenv  ::QuESTEnv
    qubits    ::Vector{Cint}   # = [0,1,2, ..., n-1] -- this will not change!

    # constructor
    function StateTomog_Iter(qr::Qureg, questenv::QuESTEnv)
        @assert numQubits(qr) ≤ 31

        local n = numQubits(qr)
        qubits = Cint[ j   for j =  0 : n-1 ]
        new(qr,questenv,qubits)
    end
end

struct StateTomog_State
    σ             ::Vector{Cint}
    count         ::UInt64
    workspace     ::Qureg
end
function StateTomog_State(iter::StateTomog_Iter) ::StateTomog_State
    workspace = createCloneQureg(iter.qr,iter.questenv)
    σ = [ Cint(3) for j = 1 : numQubits(iter.qr) ]
    return StateTomog_State(σ,0,workspace)
end

"""
Helper function `_inc(σ)`

Moves to the next multi-qubit Pauli (in lexicographic ordering)
"""
function _inc!(σ ::Vector{Cint}) ::Vector{Cint}
    @assert 0 < length(σ) ≤ 31
    local n = length(σ)

    for idx = 1:n
        @assert σ[idx] ∈ 0:3
        σ[idx] = ( σ[idx] + 1 ) % 4
        if σ[idx] != 0    break   end
    end
    return σ
end

function iterate(iter  ::StateTomog_Iter,
                 state ::StateTomog_State =StateTomog_State(iter)) ::Union{ Nothing, Tuple{Float64, StateTomog_State} }
    local n ::UInt64  = numQubits(iter.qr)
    if state.count ≥ (  1<<(2*n)  )
        destroyQureg(state.workspace,iter.questenv)
        return nothing
    else
        _inc!(state.σ)
        local expval = calcExpecPauliProd(iter.qr, iter.qubits,
                                          state.σ,
                                          state.workspace)
        return (  expval,
                  StateTomog_State(state.σ,
                                   state.count + 1,
                                   state.workspace)  )
    end
end

eltype(::Type{StateTomog_Iter})      =    Float64
length(iter ::StateTomog_Iter) ::Int =    1 << (2*length(iter.qubits))

@doc raw"
Function `distance(::StateTomog_Iter, ::StateTomog_Iter ; 𝑝=1)`

Computes the 𝑝-norm distance between the Pauli-basis vector representations of the two states given as state-tomography iterators.
"
function distance(ψ ::StateTomog_Iter,
                  ϕ ::StateTomog_Iter
                  ;
                  p ::Real = 1)             ::Float64
    @assert numQubits(ψ.qr) == numQubits(ϕ.qr)
    @assert 0 < p

    if p == Inf
        local maxval ::Float64 = 0
        for (e1,e2) ∈ zip(ψ,ϕ)
            maxval = max(maxval,
                         abs(e1 - e2) )
        end
        return maxval
    else
        local q   ::Float64 = 1/p
        local sum ::LngDbl  = 0
        for (e1,e2) ∈ zip(ψ,ϕ)
            sum += abs( LngDbl(e1)-LngDbl(e2) )^q
        end
        return Float64( sum^p )
    end
end

@doc raw"
Function `distance(ψ ::StateTomog_Iter, ϕ::Function ; 𝑝=1)`

Computes the 𝑝-norm distance between the Pauli-basis vector representations
of the state ψ and the vector defined by the function ϕ.

The function ϕ allow as argument a vector containing a Pauli code for each qubit.
It must return the expectation value of that observable for whatever state it represents.
"
function distance(ψ ::StateTomog_Iter,
                  ϕ ::Function
                  ;
                  p ::Real = 1)
    @assert 0 < p

    if p == Inf
        local maxval ::Float64 = 0
        local it = iterate(ψ)
        while it !== nothing
            (v,s) = it
            maxval = max(maxval,
                         abs(v - ϕ(s.σ) ))
            it = iterate(ψ,s)
        end
        return maxval
    else
        local q   ::Float64 = 1/p
        local sum ::LngDbl  = 0
        local it = iterate(ψ)
        while it !== nothing
            (v,s) = it
            sum += abs( LngDbl(v)-LngDbl(ϕ(s.σ)) )^q
            it = iterate(ψ,s)
        end
        return Float64( sum^p )
    end
end

############################################################################
#                                                                          #
#   Process tomography                                                     #
#                                                                          #
############################################################################

@doc raw"
Function `prepare!(qureg ::Qureg, 𝑥 ::UInt16) ::Qureg`

Prepares the given quantum register in the state |𝑥⟩.

### Requires
* 0 ≤ 𝑥 < 2ⁿ, where 𝑛 is the number of qubits in `qureg`
"
function prepare!(qureg ::Qureg, x ::UInt16) ::Qureg
    @assert 0 ≤ x < numQubits(qureg)

    @error "Not yet implemented"
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

    @error "Not yet implemented"
end

struct ProcTomog_Iter
    things
end

# function iterate()
# function eltype()
# function isequal()

end #^ module _Tomog
#EOF
