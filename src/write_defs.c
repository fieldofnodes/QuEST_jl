#include <QuEST.h>


#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

const
char outfilename[] = "";


FILE * outf;
unsigned sizeof_qreal;

#define FPTYPE (  sizeof_qreal==4 ? "Float32" : "Float64"  )

static
int                // RET 0 iff successful
do_work()
{
     fprintf(outf,
             "module QuEST_h\n");
     fprintf(outf,
             "struct ComplexArray\n"
             "  real ::Ptr{%s}\n"
             "  imag ::Ptr{%s}\n"
             "end\n",
             FPTYPE, FPTYPE);
     fprintf(outf,
             "const PAULI_I=Int32(0)\n"
             "const PAULI_X=Int32(1)\n"
             "const PAULI_Y=Int32(2)\n"
             "const PAULI_Z=Int32(3)\n"
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
             "  numQubits ::Int32\n"
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
             sizeof(struct Qureg));
     ;                                                   _Static_assert(_Alignof(struct Qureg)==8,
                                                                        "Weird alignment of struct Qureg\n");

     fprintf(outf,
             "struct QuESTEnv\n"
             "  rank     ::Int32\n"
             "  numRanks ::Int32\n"
             "end\n");

     fprintf(outf,
             "end # moduel QuEST_h\n");

     fflush(outf);

     return 0;
} //^ do_work()

int main(int const argc, char const * argv[const])
{
     char * pchr;

     ;                                                      if (argc != 2)
                                                                 return fprintf(stderr,
                                                                                        "Give the size of the `qreal` type "
                                                                                        "that QuEST is compiled with ('4', or '8').\n"),
                                                                      1;

     long const
          l_sizeof_qreal = strtol(argv[1],&pchr,10);

     ;                                                      if (*pchr)
                                                                 return fprintf(stderr,
                                                                                      "Unable to read integer argument.\n"),
                                                                      1;
     ;                                                      if (l_sizeof_qreal<0
                                                                || l_sizeof_qreal > 100
                                                                || l_sizeof_qreal != sizeof(qreal) )
                                                                 return fprintf(stderr,
                                                                                "Size of libQuEST-qreal type doesn't match my setting.\n"),
                                                                      1;

     sizeof_qreal = (unsigned)l_sizeof_qreal;
     ;                                                      if (sizeof_qreal!=4 && sizeof_qreal!=8)
                                                                 return fprintf(stderr,
                                                                                "Sorry, I can only do sizeof(qreal) ∈ {4,8}\n"),
                                                                      1;
     outf = fopen(outfilename,"w");
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
     return 0;
} //^ main()
