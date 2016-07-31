GHC = ghc

OBJS = bf.hs
PROGRAM = bf

.PHONY: all clean

all: $(PROGRAM)

$(PROGRAM): $(OBJS)
	$(GHC) -o $(PROGRAM) $(OBJS)

clean:
	rm -rf *.o *.hi $(PROGRAM)
