# QuEST_jl Build Process

The build process in non-expert mode:

1. Git-clones QuEST, and cmakes the libraries in both 32-bit and 64-bit floating point precision.  The two compiled shared libraries go into two folders, `deps/QuEST/build32`, `deps/QuEST/build64`.
2. Uses `Clang.jl` to write the files `clangquest_common_32.jl` and `clangquest_common_64.jl`, which contain all the C-side types/structs of QuEST
3. Writes the file `build_setup.jl` with data about the build process, including whether or not expert mode was used.

The build process in expert mode: Only step 3.
