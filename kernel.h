#ifndef KERNEL_H_
#define KERNEL_H_

#include <stdio.h>

__global__ void sortPixels(uchar3* pixels, int size);

void pixelSort(uchar3* pixels, int size);

#endif 
