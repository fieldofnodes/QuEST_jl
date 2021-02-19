# QuEST_jl
#### Julia wrapper for the Quantum Exact Simulation Toolkit (QuEST)

This package makes available the high-performance quantum circuit
simulator as a package in the the Matlab-like rapid-prototyping
scientific computing language [Julia](https://julialang.org/).

## Installation

#### Non-expert QuEST users

Download and build the Julia package like this:

```{julia}
] add QuEST_jl
```

QuEST is automatically cloned from GitHub (from this fork:
https://github.com/Ketita/QuEST) to your Julia packages folder, and
built in two versions, one for 32-bit precision and one for 64-bit
precision.

After that, just it!  Whenever you use it, you have to decide which
"QuEST precision" you want: wither `Qreal` is 32-bit (Float32) or
64-bit (Float64).  The two variants are in different sub-modules of
QuEST_jl.  For example, to use 32-bit precision, just do this:

```{julia}
using QuEST_jl
const QuEST = QuEST32
qenv = QuEST.createQuESTenv()
```

The QuEST dynamic libary is loaded when you create your (first) QuEST
environment.  In order to switch to another precision, you have to
terminate Julia, and start it again.

#### Expert QuEST users

**This hasn't been tested!**

To activate "expert" mode, before building the QuEST_jl package, you have to set the environment variable
```{bash}
export QUEST_JL_EXPERT_BUILD=1
```

The value doesn't matter, the build process checks only *whether* the
environment variable is set or not.

If it is set, QuEST will *not* be cloned from GitHub.  Instead you are
expected to make it available in your own, expertly tuned version.

You need to make available for automatic loading two dynamically loaded libraries, with the names

* `libQuEST_32`  -- compiled with 32-bit precision
* `libQuEST_64`  -- compiled with 64-bit precision.

As in the non-expert version, once you create a QuEST environment with
a precision, the library is loaded, and Julia is bound to that
precision, until you stop Julia.

## Documentation

We refer to QuEST for the documentation of all functions and types.

In Julia:
* The module QuEST_jl.QuESTxx contains all functions (`createQureg()` and whatnot)
* The module QuEST_jl.QuESTxx.QuEST_Types contains all types (`Qureg` and whatnot)

## Version History

* Feb 19, 2021: v0.1.0
   * Non-expert build system is running
   * Todo: Tests, expert build system
* May 2020: Project started
