# QuEST.jl/src/Makefile

QUEST_PREC = 2  # 1=float, 2=double

#______________________________________________________________________________

SOURCES =
TARGETS = write_defs.x
OBJECTS = $(SOURCES:%.c=%.o)
DEPENDS = $(SOURCES:%.c=%.d)


QUEST_INCL_DIR = $(HOME)/my.local/include/
QUEST_LIB_DIR  = $(HOME)/my.local/lib/

CPPFLAGS = -D QuEST_PREC=$(QUEST_PREC) -D _GNU_SOURCE -MMD -MP -I$(QUEST_INCL_DIR)
CFLAGS   = -Wall -Wextra
LDFLAGS  = -L$(QUEST_LIB_DIR) -lm

CC      = $(GCC) $(CPPFLAGS) $(CFLAGS)
LD      = $(GCC) -Wall -Wextra

all: $(OBJECTS) $(TARGETS)
.PHONY: all

%.o: %.c
	$(CC) -c $<

%.x: %.c $(OBJECTS) Makefile
	$(CC) -c $< -o $(<:.c=.o)
	$(LD) $(<:.c=.o) -o $@ $(OBJECTS) $(LOCAL_LDFLAGS) $(LDFLAGS) -lQuEST


.PHONY: clean
clean: $(SUBDIRS)
	rm -f $(OBJECTS) $(DEPENDS) $(TARGETS:%.x=%.o) $(TARGETS:%.x=%.d)

# EOF
