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

int main(int argc, char** argv)
{
    // Read the image file
    Mat image = imread("/Users/dylantalmood/Desktop/JoeRogan.png");

    // Check for failure
    if (image.empty()) 
    {
        cout << "Could not open or find the image" << endl;
        cin.get(); //wait for any key press
        return -1;
    }

    String windowName = "User Custom Image"; //Name of the window

    namedWindow(windowName); // Create a window

    imshow(windowName, image); // Show our image inside the created window.

    waitKey(0); // Wait for any keystroke in the window

    destroyWindow(windowName); //destroy the created window

    // lets grab the pixels and store them inside of a 3D matrix 
    cout << "Rows = " << image.rows << "\n" << "Col = " << image.cols << endl; 
    int pixels[image.rows][image.cols][3];
    int count = 0;

    for (int row = 0; row < image.rows; ++row)
    {
        for (int col = 0; col < image.cols; ++col)
        {
            count++;

            // Get the RGB values of the pixel at (row, col)
            Vec3b rgb = image.at<Vec3b>(row, col);
            int blue = rgb[0];
            int green = rgb[1];
            int red = rgb[2];
            pixels[row][col][0] = red;
            pixels[row][col][1] = green;
            pixels[row][col][2] = blue;

            // Process the RGB values as needed
        }
    }
    
    cout << "Count = "<< count << endl;
    return 0;
}
