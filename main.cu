#include <iostream>
#include <opencv2/opencv.hpp>

//incompatibility issues with open cv, header was needed for compilation
#include "kernel.h"

using namespace cv;
using namespace std;

int main() {
    //use opencv to read image
    cout << "Welcome!\n Please type the name of the image you would like to sort!" << endl;
    
    cin >> 

    Mat image = imread("source.jpeg");
    Timer timer;

    // Check if the image was successfully loaded
    if (image.empty()) {
        cout << "cannot read image" << endl;
        return -1;
    }

    //issues with opencv 2D matrix and cuda
    //vector is used instead


    printf("\n Phase 1: Traverse the 2D matrix and extract each pixel"); fflush(stdout);
    startTime(&timer);
    vector<uchar3> pixels;
    //traverse 2D matrix to extract pixel
    for (int y = 0; y < image.rows; y++) {
        for (int x = 0; x < image.cols; x++) {
            Vec3b bgrPixel = image.at<Vec3b>(y, x);
            uchar3 rgbPixel = make_uchar3(bgrPixel[2], bgrPixel[1], bgrPixel[0]);
            pixels.push_back(rgbPixel);
        }
    }
    stopTime(&timer); printf("%f s\n", elapsedTime(timer));

    // Allocate host variables ----------------------------------------------

    // HOST VARIABLES ARE DYNAMIC HERE

    //==========================================


    // Allocate device variables ---------------------------------------------

    //incompatibility issues with opencv and cuda uchar3 is the solution
    uchar3* d_pixels;
    cudaMalloc((void**)&d_pixels, pixels.size() * sizeof(uchar3));


    // Copy host variables to device ------------------------------------------
    cudaMemcpy(d_pixels, pixels.data(), pixels.size() * sizeof(uchar3), cudaMemcpyHostToDevice);


    // Launch kernel ---------------------------
    printf("\n Phase 2: Launch the pixelSort Kernel"); fflush(stdout);
    startTime(&timer);
    pixelSort(d_pixels, pixels.size());
    stopTime(&timer); printf("%f s\n", elapsedTime(timer));

    // Copy device variables from host ----------------------------------------
    cudaMemcpy(pixels.data(), d_pixels, pixels.size() * sizeof(uchar3), cudaMemcpyDeviceToHost);

    //building 2D opencv image
    Mat sortedImage(image.size(), image.type());
    for (int y = 0; y < image.rows; y++) {
        for (int x = 0; x < image.cols; x++) {

            uchar3 rgbPixel = pixels[y * image.cols + x];
            Vec3b bgrPixel(rgbPixel.z, rgbPixel.y, rgbPixel.x);
            sortedImage.at<Vec3b>(y, x) = bgrPixel;
        }
    }

    // Save the sorted image
    imwrite("sortedPixels.jpeg", sortedImage);

  
    cudaFree(d_pixels);

    return 0;
}
