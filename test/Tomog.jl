# QuEST.jl/test/Tomog.jl
# (License stuff)

@doc raw"

Module `Tomog`

Hosts the code for quantum process tomography.

## Exports

...

"
module Tomog

import QuEST

function prepare(qureg ::QuEST.Qureg, x ::UInt16) ::QuEST.Qureg
    ...
end


function full_tomog()

end #^ module Tomog
#EOF
