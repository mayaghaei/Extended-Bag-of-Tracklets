CC=g++

LAPACKCFLAGS=-Dinteger=int
#LAPACKLDFLAGS=/usr/lib64/atlas/libf77blas.so.3   # non multi-threaded blas
LAPACKLDFLAGS=-ljpeg -lpng /usr/lib64/atlas/libptf77blas.so.3  # multi-threaded blas
STATICLAPACKLDFLAGS=-static -static-libstdc++ /usr/lib64/libjpeg.a /usr/lib64/libpng.a /usr/lib64/libz.a /usr/lib64/libblas.a /usr/lib/gcc/x86_64-redhat-linux/4.7.2/libgfortran.a  # statically linked version

CFLAGS= -fPIC -Wall -g -std=c++11 $(LAPACKCFLAGS) -fopenmp -DUSE_OPENMP -O3
LDFLAGS=-fPIC -Wall -g -fopenmp 

SOURCES := $(shell find . -name '*.cpp')
OBJ := $(SOURCES:%.cpp=%.o)
HEADERS := $(shell find . -name '*.h')

all: deepmatching 

.cpp.o:  %.cpp %.h
	$(CC) -o $@ $(CFLAGS) -c $+

deepmatching: $(HEADERS) $(OBJ)
	$(CC) $(LDFLAGS) $(LAPACKLDFLAGS) -o $@ $^

deepmatching-static: $(HEADERS) $(OBJ)
	$(CC) $(LDFLAGS) -o $@ $^ $(STATICLAPACKLDFLAGS)


clean:
	rm -f $(OBJ) deepmatching *~ *.pyc .gdb_history

