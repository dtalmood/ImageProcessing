CXX = g++
CXXFLAGS = -std=c++11 -Wall -Wextra
LIBS = `pkg-config --libs opencv`

SRCS = main.cpp
OBJS = $(SRCS:.cpp=.o)
EXECUTABLE = Myproject

all: $(EXECUTABLE)

$(EXECUTABLE): $(OBJS)
	$(CXX) $(CXXFLAGS) $(OBJS) -o $@ $(LIBS)

.cpp.o:
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS) $(EXECUTABLE)
