CXX = g++
CXXFLAGS = -std=c++11 -Wall -Wextra
LIBS = `pkg-config --libs opencv`

SRCS = cpu.cpp
OBJS = $(SRCS:.cpp=.o)
EXECUTABLE = Myproject

default: $(EXECUTABLE)

$(EXECUTABLE): $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) -o $@ $(LIBS)

.cpp.o:
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(EXECUTABLE)


NVCC        = nvcc
ifeq (,$(shell which nvprof))
NVCC_FLAGS  = -O3 -arch=sm_20
else
NVCC_FLAGS  = -O3 
endif
LD_FLAGS    = -lcudart
EXE	        = imageprocessing
OBJ	        = main.o

default: $(EXE)

main.o: main.cu kernel.cu
	$(NVCC) -c -o $@ $< $(NVCC_FLAGS)

$(EXE): $(OBJ)
	$(NVCC) $(OBJ) -o $(EXE) $(LD_FLAGS)

clean:
	rm -f $(OBJ) $(EXE)
