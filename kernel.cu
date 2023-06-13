#include "kernel.h"

__device__ bool sorter(const uchar3& pixel1, const uchar3& pixel2) {
    
    //red channel
    if (pixel1.z != pixel2.z) {
        return pixel1.z < pixel2.z; 
    }
    // green channel
    if (pixel1.y != pixel2.y) {
        return pixel1.y < pixel2.y; 
    }
    // Sort by blue channel
    return pixel1.x < pixel2.x; 
}

__global__ void sortPixels(uchar3* pixels, int size) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < size) {
        uchar3 currentPixel = pixels[idx];
        for (int i = idx + 1; i < size; i++) {
            uchar3 otherPixel = pixels[i];

            if (sorter(otherPixel, currentPixel)) {
                pixels[idx] = otherPixel;
                pixels[i] = currentPixel;
                currentPixel = pixels[idx];
            }
        }
    }
}

void pixelSort(uchar3* pixels, int size) {
    const unsigned int BLOCK_SIZE = 256;
    const unsigned int NUM_BLOCKS = (size + BLOCK_SIZE - 1) / BLOCK_SIZE;

    sortPixels<<<NUM_BLOCKS, BLOCK_SIZE>>>(pixels, size);
    cudaDeviceSynchronize();
}
