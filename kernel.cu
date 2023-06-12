#include <cuda_runtime.h>

struct ComparePixel {
    __host__ __device__ bool operator()(const uchar3& pixel1, const uchar3& pixel2) const {
        if (pixel1.z != pixel2.z) {
            return pixel1.z < pixel2.z; // Sort by red channel
        }
        if (pixel1.y != pixel2.y) {
            return pixel1.y < pixel2.y; // Sort by green channel
        }
        return pixel1.x < pixel2.x; // Sort by blue channel
    }
};

extern "C" __global__ void sortPixels(uchar3* pixels, int size) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < size) {
        uchar3 currentPixel = pixels[idx];
        for (int i = idx + 1; i < size; i++) {
            uchar3 otherPixel = pixels[i];
            if (ComparePixel()(otherPixel, currentPixel)) {
                pixels[idx] = otherPixel;
                pixels[i] = currentPixel;
                currentPixel = pixels[idx];
            }
        }
    }

}
