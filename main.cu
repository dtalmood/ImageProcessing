#include <iostream>
#include <opencv2/opencv.hpp>
#include <ctime>
//incompatibility issues with open cv, header was needed for compilation
#include "kernel.h"

using namespace cv;
using namespace std;
Mat importImage();

int main() 
{
    // We call the importImage Function which 
    Mat image = importImage();
    
    if (image.empty())
    {
        cout << "Goodbye!" << endl;
        return 0;
    } 
    else 
    {
	    time_t start;
        time_t current_time;

        // Check if the image was successfully loaded
        if (image.empty()) {
            cout << "cannot read image" << endl;
            return -1;
        }

        //issues with opencv 2D matrix and cuda
        //vector is used instead


        printf("\n Phase 1: Traverse the 2D matrix and extract each pixel\n"); fflush(stdout);
	    start = time(NULL);
        vector<uchar3> pixels;
        //traverse 2D matrix to extract pixel
        for (int y = 0; y < image.rows; y++) {
            for (int x = 0; x < image.cols; x++) {
                Vec3b bgrPixel = image.at<Vec3b>(y, x);
                uchar3 rgbPixel = make_uchar3(bgrPixel[2], bgrPixel[1], bgrPixel[0]);
                pixels.push_back(rgbPixel);
            }
        }
	    current_time = time(NULL);
	    int time_passed = current_time - start;
        int min = time_passed / 60;
        int sec = time_passed % 60;
        printf("It took %d minute(s) and %d second(s)\n", min, sec);

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
        printf("\n Phase 2: Launch the pixelSort Kernel\n"); fflush(stdout);
	    start = time(NULL);
        pixelSort(d_pixels, pixels.size());
	    current_time = time(NULL);
	    time_passed = current_time - start;
        min = time_passed / 60;
        sec = time_passed % 60;
        printf("It took %d minute(s) and %d second(s)\n", min, sec);

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
    }

    return 0;
}


Mat importImage() {
    string imageName;
    Mat image;

    while (true) {
        cout << "Please enter the name of the image you want to import (or 'q' to quit): ";
        cin >> imageName;

        if (imageName == "q") {
            cout << "Program terminated." << endl;
            break;
        }

        image = imread(imageName);

        if (image.empty()) {
            cout << "Image not found. Please try again." << endl;
        } else {
            cout << "Image imported successfully." << endl;
            return image;
        }
    }

    // Return an empty image if program is terminated or image not found
    return Mat();
}
