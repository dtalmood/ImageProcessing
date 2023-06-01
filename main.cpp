/*
     How to run code
        1. Make sure you are inside the Build file
        2. if not in build file run command "cd build"
        3. run command "make"
        4. run command "./Myproject"
*/

#include <opencv2/opencv.hpp>
#include <iostream>

using namespace cv;
using namespace std;

int main() {
    string dir1 = ""; //enter directory for image 1
    
    // Read the image file
    Mat image1 = imread(dir1);

    // Check for failure
    if (image1.empty()) {
        cout << "Could not open or find the image for 1" << endl;
        cin.get(); //wait for any key press
        return -1;
    }

    string dir2 = ""; //enter directory for image 2
    
    // Read the image file
    Mat image2 = imread(dir2);

    // Check for failure
    if (image2.empty()) {
        cout << "Could not open or find the image for 2" << endl;
        cin.get(); //wait for any key press
        return -2;
    }

    if ((image1.rows != image2.rows) || (image1.cols != image2.cols)) {
        cout << "Images are not the same size" << endl;
        cin.get(); //wait for any key press
        return -3;
    }

    String windowName1 = "User Custom Image 1"; //Name of the window
    namedWindow(windowName1); // Create a window
    imshow(windowName1, image1); // Show our image inside the created window.
    waitKey(0); // Wait for any keystroke in the window
    destroyWindow(windowName1); //destroy the created window

    String windowName2 = "User Custom Image 2"; //Name of the window
    namedWindow(windowName2); // Create a window
    imshow(windowName2, image2); // Show our image inside the created window.
    waitKey(0); // Wait for any keystroke in the window
    destroyWindow(windowName2); //destroy the created window
    
    // convert image to HSV color space
    Mat hsvImage1;
    cvtColor(image1, hsvImage1, COLOR_BGR2HSV);
    // lets grab the pixels and store them inside of a 3D matrix 
    Vec3b pixels1[image1.rows][image1.cols];
    
    // convert image to HSV color space
    Mat hsvImage2;
    cvtColor(image2, hsvImage2, COLOR_BGR2HSV);
    // lets grab the pixels and store them inside of a 3D matrix 
    Vec3b pixels2[image2.rows][image2.cols];

    for (int row = 0; row < image1.rows; ++row) {
        for (int col = 0; col < image1.cols; ++col) {
            pixels1[row][col] = hsvImage1.at<Vec3b>(row, col);
            pixels2[row][col] = hsvImage2.at<Vec3b>(row, col);
        }
    }
    
    return 0;
}
