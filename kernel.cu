#include <stdio.h>

__global__ void sortPixels(Vec3b* pixelsReference, Vec3b* pixelsSource, pair<int, int>* position, int totalPixels) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    if (tid >= totalPixels)
        return;

    Vec3b swap;
    int currHue, tempHue;
    pair<int, int> tempPos;

    int counter, row, col;
    bool swapped;

    for (int k = 0; k < totalPixels; k++) {
        counter = 0;
        row = 0;
        col = 0;
        swapped = false;

        while (counter < totalPixels - k - 1) {
            currHue = pixelsReference[row * totalPixels + col][0];
            tempHue = pixelsReference[row * totalPixels + col + 1][0];
            if (currHue > tempHue) {
                swap = pixelsReference[row * totalPixels + col];
                pixelsReference[row * totalPixels + col] = pixelsReference[row * totalPixels + col + 1];
                pixelsReference[row * totalPixels + col + 1] = swap;
                swapped = true;
            }

            currHue = pixelsSource[row * totalPixels + col][0];
            tempHue = pixelsSource[row * totalPixels + col + 1][0];
            if (currHue > tempHue) {
                swap = pixelsSource[row * totalPixels + col];
                pixelsSource[row * totalPixels + col] = pixelsSource[row * totalPixels + col + 1];
                pixelsSource[row * totalPixels + col + 1] = swap;

                tempPos = position[row * totalPixels + col];
                position[row * totalPixels + col] = position[row * totalPixels + col + 1];
                position[row * totalPixels + col + 1] = tempPos;
                swapped = true;
            }

            col = (col + 1) % (totalPixels - 1);
            if (col == 0) {
                currHue = pixelsReference[row * totalPixels + totalPixels - 1][0];
                tempHue = pixelsReference[(row + 1) * totalPixels][0];
                if (row < totalPixels - 1 && currHue > tempHue) {
                    swap = pixelsReference[row * totalPixels + totalPixels - 1];
                    pixelsReference[row * totalPixels + totalPixels - 1] = pixelsReference[(row + 1) * totalPixels];
                    pixelsReference[(row + 1) * totalPixels] = swap;
                    swapped = true;
                }

                currHue = pixelsSource[row * totalPixels + totalPixels - 1][0];
                tempHue = pixelsSource[(row + 1) * totalPixels][0];
                if (row < totalPixels - 1 && currHue > tempHue) {
                    swap = pixelsSource[row * totalPixels + totalPixels - 1];
                    pixelsSource[row * totalPixels + totalPixels - 1] = pixelsSource[(row + 1) * totalPixels];
                    pixelsSource[(row + 1) * totalPixels] = swap;

                    tempPos = position[row * totalPixels + totalPixels - 1];
                    position[row * totalPixels + totalPixels - 1] = position[(row + 1) * totalPixels];
                    position[(row + 1) * totalPixels] = tempPos;
                    swapped = true;
                }
                counter++;
                row++;
            }
            counter++;
        }
        if (!swapped)
            break;
    }
}

void imageprocessing() {
    int blockSize = 256;
    int gridSize = (totalPixels + blockSize - 1) / blockSize;
    sortPixels<<<gridSize, blockSize>>>(d_pixelsReference, d_pixelsSource, d_position, totalPixels);
}