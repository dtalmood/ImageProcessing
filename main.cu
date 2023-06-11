/*
     How to run code
        1. Make sure you are inside the directory of the file
        2. run command "make"
        3. run command "./imageprocessing"
*/
#include <stdio.h>
#include <stdint.h>
#include "kernel.cu"
#include <opencv2/opencv.hpp>
#include <iostream>
#include <utility>
#include <vector>
#include <ctime>

using namespace cv;
using namespace std;

int main() {
    
    //Reading the images into 2D arrays w/ opencv =============================

    Mat reference = imread("source.jpeg"); //enter for image 1
    // Check for failure
    if (reference.empty()) {
        cout << "Could not open or find the image for 1" << endl;
        cin.get(); //wait for any key press
        return -1;
    }

    // Read the image file
    Mat source = imread("reference.jpeg");
    // Check for failure
    if (source.empty()) {
        cout << "Could not open or find the image for 2" << endl;
        cin.get(); //wait for any key press
        return -2;
    }
    if ((reference.rows != source.rows) || (reference.cols != source.cols)) {
        cout << "Images are not the same size" << endl;
        cin.get(); //wait for any key press
        return -3;
    }
    //==========================================================================



    cudaError_t cuda_ret;

    // Initialize host variables ----------------------------------------------

    printf("\nSetting up the problem...\n"); fflush(stdout);
    
    int size = reference.rows * reference.cols;
    Vec3b* ref_h, source_h, franken_h;
    Vec3b* ref_d, source_d, franken_d;
    
    ref_h = (Vec3b*)malloc(sizeof(Vec3b)*size);
    source_h = (Vec3b*)malloc(sizeof(Vec3b)*size);
    franken_h = (Vec3b*)malloc(sizeof(Vec3b)*size);
    

    // Allocate device variables ----------------------------------------------

    printf("Allocating device variables...\n"); fflush(stdout);

    cudaMalloc((void**)&ref_d, size*sizeof(Vec3b));
    cudaMalloc((void**)&source_d, size*sizeof(Vec3b));
    cudaMalloc((void**)&franken_d, size*sizeof(Vec3b));



    cudaDeviceSynchronize();

    // Copy host variables to device ------------------------------------------

    printf("Copying data from host to device...\n"); fflush(stdout);
    
    cudaMemcpy(ref_d, ref_h, size*sizeof(Vec3b), cudaMemcpyHostToDevice);
    cudaMemcpy(source_d, source_h, size*sizeof(Vec3b), cudaMemcpyHostToDevice);



    cudaDeviceSynchronize();

    // Launch kernel ----------------------------------------------------------

    printf("Launching kernel...\n"); fflush(stdout);
    
    frankenImage(ref_d, source_d, franken_d, size);
    cuda_ret = cudaDeviceSynchronize();
	  if(cuda_ret != cudaSuccess) FATAL("Unable to launch kernel");

    // Copy device variables from host ----------------------------------------

    printf("Copying data from device to host...\n"); fflush(stdout);
    
    cudaMemcpy(franken_h, franken_d, size*sizeof(Vec3b), cudaMemcpyDeviceToHost);


    cudaDeviceSynchronize();
    //writing new image to image file =============================================
    //creating new image from source pixels using the reference image
    Mat frankenImage(reference.size(), reference.type());

    frankenImage = franken_d;

    imwrite("frankenImage.jpeg", frankenImage);

    
    // Free memory ------------------------------------------------------------

    free(ref_h);
    free(source_h);
    free(franken_h);

    cudaFree(ref_d);
    cudaFree(source_d);
    cudaFree(franken_d);


    


    return 0;
}
