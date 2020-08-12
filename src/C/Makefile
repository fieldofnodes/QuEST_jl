# QuEST.jl/src/C/Makefile
#
# Required Environment Variables:
#
#  - GCC                 (the gcc compiler)
#  - C_INCLUDES          (blank-separated list of -I... compiler include path instructions)
#  - C_LIBS              (blank-separated list of library path and link instructions for gcc)
#

SOURCES =
TARGETS = libhelpQuEST_d.so libhelpQuEST_f.so
OBJECTS = $(SOURCES:%.c=%.o)
DEPENDS = $(SOURCES:%.c=%.d)


CPPFLAGS = -D _GNU_SOURCE -MMD -MP $(C_INCLUDES)
CFLAGS   = -Wall -Wextra  -fPIC
LDFLAGS  = $(C_LIBS) -lm  -fPIC -fuse-ld=gold

CC      = $(GCC) $(CPPFLAGS) $(CFLAGS)
LD      = $(GCC) -Wall -Wextra

all: $(OBJECTS) $(TARGETS)
.PHONY: all

%.o: %.c
	$(CC) -c $<

libhelpQuEST_d.so: $(OBJECTS) Makefile
	$(CC) -c helpQuEST.c   -D QuEST_PREC=2
	$(LD) -shared -o $@ helpQuEST.o $(OBJECTS) $(LDFLAGS)

libhelpQuEST_f.so:  $(OBJECTS) Makefile
	$(CC) -c helpQuEST.c   -D QuEST_PREC=1
	$(LD) -shared -o $@ helpQuEST.o $(OBJECTS) $(LDFLAGS)

.PHONY: clean
clean: $(SUBDIRS)
	rm -f $(OBJECTS) $(DEPENDS)

# EOF
