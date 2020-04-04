#include "QuEST.h"

extern
int  getQuEST_PREC(void);          // undocumented function in "QuEST.c"

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

const
char outfilename[] = "QuEST_h.jl";


FILE * outf;
unsigned sizeof_qreal;

#define FPTYPE (  sizeof_qreal==4 ? "Cfloat" : "Cdouble"  )

static
int                // RET 0 iff successful
do_work()
{
     fprintf(outf,
             "module QuEST_h\n");
     fprintf(outf,"export Qreal, ComplexArray, PAULI_I, PAULI_X, PAULI_Y, PAULI_Z, Complex, ComplexMatrix2, ComplexMatrix4, ComplexMatrixN, Vector, Qureg, QuESTEnv\n");
     fprintf(outf,"const Qreal = %s",FPTYPE);
     fprintf(outf,
             "struct ComplexArray\n"
             "  real ::Ptr{%s}\n"
             "  imag ::Ptr{%s}\n"
             "end\n",
             FPTYPE, FPTYPE);
     fprintf(outf,
             "const PAULI_I=Cint(0)\n"
             "const PAULI_X=Cint(1)\n"
             "const PAULI_Y=Cint(2)\n"
             "const PAULI_Z=Cint(3)\n"
          );

     fprintf(outf,
             "struct Complex\n"
             "  real ::%s\n"
             "  imag ::%s\n"
             "end\n",
             FPTYPE, FPTYPE);

     fprintf(outf,
             "struct ComplexMatrix2\n"
             "  real ::NTuple{2,NTuple{2,%s}}\n"
             "  imag ::NTuple{2,NTuple{2,%s}}\n"
             "end\n",
             FPTYPE, FPTYPE);
     fprintf(outf,
             "struct ComplexMatrix4\n"
             "  real ::NTuple{4,NTuple{4,%s}}\n"
             "  imag ::NTuple{4,NTuple{4,%s}}\n"
             "end\n",
             FPTYPE, FPTYPE);
     fprintf(outf,
             "struct ComplexMatrixN\n"
             "  numQubits ::Cint\n"
             "  real      ::Ptr{Ptr{%s}}\n"
             "  imag      ::Ptr{Ptr{%s}}\n"
             "end\n",
             FPTYPE, FPTYPE);

     fprintf(outf,
             "struct Vector\n"
             "  x ::%s\n"
             "  y ::%s\n"
             "  z ::%s\n"
             "end\n",
             FPTYPE,FPTYPE,FPTYPE);

     fprintf(outf,
             "primitive type Qureg %lu end\n",
             8*sizeof(struct Qureg));                    // number of 𝙗𝙞𝙩𝙨
     ;                                                   _Static_assert(_Alignof(struct Qureg)==8,
                                                                        "Weird alignment of struct Qureg\n");

     fprintf(outf,
             "struct QuESTEnv\n"
             "  rank     ::Cint\n"
             "  numRanks ::Cint\n"
             "end\n");

     fprintf(outf,
             "end # moduel QuEST_h\n");

     fflush(outf);

     return 0;
} //^ do_work()

int main(int const    argc,
         char const * argv[const])
{
     ;                                                      if (argc != 1)
                                                                 return fprintf(stderr,
                                                                                "Doof use.\n"),
                                                                      1;

     const size_t
          l_sizeof_qreal = 4*getQuEST_PREC();
     ;                                                      if (l_sizeof_qreal!=4 && l_sizeof_qreal!=8)
                                                                 return fprintf(stderr,
                                                                                "libQuEST reports size of qreal no int {4,8}.\n"),
                                                                      1;
     ;                                                      if ( l_sizeof_qreal != sizeof(qreal) )
                                                                 return fprintf(stderr,
                                                                                "Size of libQuEST-qreal type doesn't match this compilation setting.\n"),
                                                                      1;

     sizeof_qreal = (unsigned)l_sizeof_qreal;
     outf         = fopen(outfilename,"w");
     ;                                                      if (!outf)
                                                                 return fprintf(stderr, "Failed to open file %s for writing.\n", outfilename),
                                                                      1;

     if ( do_work() )                                       return fprintf(stderr, "Writing to file %s faied.\n",outfilename),
                                                                      1;


     ;                                                      if (ferror(outf))
                                                                 return fprintf(stderr, "Writing to file %s faied somewhere.\n",outfilename),
                                                                      1;
     if ( fclose(outf) )                                    return fprintf(stderr, "Closing file %s after writing failed.\n",outfilename),
                                                                 1;
     printf("%s: Done.\n", argv[0]);
     return 0;
} //^ main()
