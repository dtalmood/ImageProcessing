CC := nvcc
CFLAGS := -std=c++11
LDFLAGS := `pkg-config --libs opencv`

all: sort_pixels

sort_pixels: main.o kernel.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

main.o: main.cu
	$(CC) $(CFLAGS) -c $<

kernel.o: kernel.cu
	$(CC) $(CFLAGS) -c $<

clean:
	rm -rf *.o sort_pixels
