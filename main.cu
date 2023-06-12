#include <iostream>
#include <opencv2/opencv.hpp>
using namespace cv;
using namespace std;

// Custom comparator function for sorting pixels based on RGB values
bool comparePixels(const Vec3b& pixel1, const Vec3b& pixel2);

// Declaration of sortPixels function
extern "C" void sortPixels(uchar3* pixels, int numPixels);

int main() {
    // Load JPEG image using OpenCV
    // Read the image file
    Mat image = imread("source.jpeg");

    // Check if the image was successfully loaded
    if (image.empty()) {
        cout << "Could not open or find the image" << endl;
        return -1;
    }

    // Extract pixel values into a vector
    vector<Vec3b> pixels;
    for (int y = 0; y < image.rows; y++) {
        for (int x = 0; x < image.cols; x++) {
            pixels.push_back(image.at<Vec3b>(y, x));
        }
    }

    // Sort the pixels based on RGB values
    sortPixels(reinterpret_cast<uchar3*>(pixels.data()), pixels.size());

    // Create a new image with sorted pixels
    Mat sortedImage(image.size(), image.type());
    int index = 0;
    for (int y = 0; y < image.rows; y++) {
        for (int x = 0; x < image.cols; x++) {
            sortedImage.at<Vec3b>(y, x) = pixels[index++];
        }
    }

    imwrite("sortedPixels.jpeg", sortedImage);
    waitKey(0);

    return 0;
}

bool comparePixels(const Vec3b& pixel1, const Vec3b& pixel2) {
    if (pixel1[2] != pixel2[2]) {
        return pixel1[2] < pixel2[2]; // Sort by red channel
    }
    if (pixel1[1] != pixel2[1]) {
        return pixel1[1] < pixel2[1]; // Sort by green channel
    }
    return pixel1[0] < pixel2[0]; // Sort by blue channel
}
