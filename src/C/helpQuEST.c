/* QuEST.jl/src/write_defs.c
 *
 * Authors:
 *     - Dirk Oliver Theis, Ketita Labs
 *
 * Copyright (c) 2020 Ketita Labs oü, Tartu, Estonia
 *
 * MIT License
 *
 * Copyright (c) 2020 Ketita Labs oü, Tartu, Estonia
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge,
 * publish, distribute, sublicense, and/or sell copies of the Software,
 * and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
*/

#include "QuEST.h"

extern  int      helpQuEST__numQubits         (Qureg qr)        { return qr.numQubitsRepresented; }
extern  int      helpQuEST__isDensityMatrix   (Qureg qr)        { return qr.isDensityMatrix;      }


//
// Run-time check of matching QuEST_PREC
//

#include <stdio.h>
#include <stdlib.h>

extern
int  getQuEST_PREC(void);          // undocumented function in "QuEST.c"

__attribute__((constructor(1000)))
static
void check_QuEST_prec(void)
{
     if (getQuEST_PREC() != QuEST_PREC) {
          fprintf(stderr,
                  "Error in libhelpQuEST:\n"
                  "libhelpQuEST is compiled with QuEST_PREC=%d,\n"
                  "but libQuEST is compiled with QuEST_PRED=%d.\n"
                  "Bailing out.",
                  QuEST_PREC,getQuEST_PREC());
          exit(199);
     }
}

// EOF
