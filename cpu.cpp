/*
     How to run code
        1. Make sure you are inside the Build file
        2. if not in build file run command "cd build"
        3. run command "make"
        4. run command "./Myproject"
*/
#include <opencv2/opencv.hpp>
#include <iostream>
#include <utility>
#include <vector>
#include <ctime>

using namespace cv;
using namespace std;

int main() {
    // Took 2 hrs and 6 mins for a 800 x 800
    // Read the image file
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
/*/
    // convert image to HSV color space
    Mat hsvReference;
    cvtColor(reference, hsvReference, COLOR_BGR2HSV);
    // lets grab the pixels and store them inside of a 3D matrix 
    Vec3b pixelsReference[reference.rows][reference.cols];
    
    // convert image to HSV color space
    Mat hsvSource;
    cvtColor(source, hsvSource, COLOR_BGR2HSV);
    // lets grab the pixels and store them inside of a 3D matrix 
    Vec3b pixelsSource[source.rows][source.cols];

    vector<vector<pair <int, int>>> position;
    vector<pair<int, int>> temp;
    for (int row = 0; row < reference.rows; ++row) {
        for (int col = 0; col < reference.cols; ++col) {
            pixelsReference[row][col] = hsvReference.at<Vec3b>(row, col);
            pixelsSource[row][col] = hsvSource.at<Vec3b>(row, col);
            temp.push_back(make_pair(row, col));
        }
        position.push_back(temp);
        temp.clear();
    }
/**/
    //----------------------------------
	time_t start;
	time_t current_time;
	start = time(NULL);
    // convert image to HSV color space
    Mat bgrReference;
    cvtColor(reference, bgrReference, COLOR_HSV2BGR);
    
    // convert image to BGR color space
    Mat bgrSource;
    cvtColor(source, bgrSource, COLOR_HSV2BGR);
    
    Mat newReference;
    cvtColor(reference, newReference, COLOR_HSV2BGR);

    vector<pair<int, int>> position;
    position.push_back(make_pair(-1, -1));
    cout << reference.rows * reference.cols << endl;

    for (int refRow = 0; refRow < reference.rows; refRow++) {
        for (int refCol = 0; refCol < reference.cols; refCol++) {
            if (((refRow * reference.cols) + refCol) % 1000 == 0) cout << (refRow * reference.cols) + refCol << endl;

            double near_neighbor_dist = 9999999;

            for (int souRow = 0; souRow < source.rows; souRow++) {
                for (int souCol = 0; souCol < source.cols; souCol++) {

                    bool dupli = false;
                    for (int i = 0; i < position.size(); i++) {
                        if (souRow == position[i].first && souCol == position[i].second) {

                            dupli = true;
                            break;
                        }
                    }

                    if (!dupli) {

                        double dist = 0.0;
                        dist = pow(bgrReference.at<Vec3b>(refRow, refCol)[0] - bgrSource.at<Vec3b>(souRow, souCol)[0], 2);
                        dist += pow(bgrReference.at<Vec3b>(refRow, refCol)[1] - bgrSource.at<Vec3b>(souRow, souCol)[1], 2);
                        dist += pow(bgrReference.at<Vec3b>(refRow, refCol)[2] - bgrSource.at<Vec3b>(souRow, souCol)[2], 2);
                        dist = sqrt(dist);

                        if (dist < near_neighbor_dist) {

                            near_neighbor_dist = dist;
                            position.pop_back();
                            position.push_back(make_pair(souRow, souCol));
                        }
                    }
                }
            }

            newReference.at<Vec3b>(refRow, refCol) = bgrSource.at<Vec3b>(position.back().first, position.back().second);
        }
    }

/*/
	Vec3b swap;
    int currHue = 0;
    int tempHue = 0;
    pair<int, int> tempPos = make_pair(0, 0);
    int totalPixels = source.rows * source.cols;
    cout << totalPixels << endl;
    
	for (int k = 0; k < totalPixels; k++) {
        int counter = 0;
        int row = 0;
        int col = 0;
        bool swapped = false;
        while (counter < totalPixels - k - 1) {
            currHue = pixelsReference[row][col][0];
            tempHue = pixelsReference[row][col + 1][0];
			if (currHue > tempHue) {
				swap = pixelsReference[row][col];
				pixelsReference[row][col] = pixelsReference[row][col + 1];
				pixelsReference[row][col + 1] = swap;
                swapped = true;
			}

            currHue = pixelsSource[row][col][0];
            tempHue = pixelsSource[row][col + 1][0];
			if (currHue > tempHue) {
				swap = pixelsSource[row][col];
				pixelsSource[row][col] = pixelsSource[row][col + 1];
				pixelsSource[row][col + 1] = swap;

                tempPos = position[row][col];
                position[row][col] = position[row][col + 1];
                position[row][col + 1] = tempPos;
                swapped = true;
			}

            col = (col + 1) % (source.cols - 1);
            if (col == 0) {
                currHue = pixelsReference[row][source.cols - 1][0];
                tempHue = pixelsReference[row + 1][0][0];
    			if (row < source.rows - 1 && currHue > tempHue) {
			    	swap = pixelsReference[row][source.cols - 1];
		    		pixelsReference[row][source.cols - 1] = pixelsReference[row + 1][0];
	    			pixelsReference[row + 1][0] = swap;
                    swapped = true;
    			}

                currHue = pixelsSource[row][source.cols - 1][0];
                tempHue = pixelsSource[row + 1][0][0];
			    if (row < source.rows - 1 && currHue > tempHue) {
		    		swap = pixelsSource[row][source.cols - 1];
	    			pixelsSource[row][source.cols - 1] = pixelsSource[row + 1][0];
    				pixelsSource[row + 1][0] = swap;

                    tempPos = position[row][source.cols - 1];
                    position[row][source.cols - 1] = position[row + 1][0];
                    position[row + 1][0] = tempPos;
                    swapped = true;
                }
                counter++;
                row++;
		    }
            counter++;
	    }
        if (!swapped) break;
        if (k % 1000 == 0) cout << k << endl;
    }

    Vec3b newReferencePixels[source.rows][source.cols];
    for (int row = 0; row < reference.rows; ++row) {
        for (int col = 0; col < reference.cols; ++col) {
            newReferencePixels[position[row][col].first][position[row][col].second] = pixelsReference[row][col];
        }
    }

    for (int row = 0; row < reference.rows; ++row) {
        for (int col = 0; col < reference.cols; ++col) {
            hsvReference.at<Vec3b>(row, col) = newReferencePixels[row][col];
        }
    }
/**/

	current_time = time(NULL);
	int time_passed = current_time - start;
	int min = time_passed / 60;
	int sec = time_passed % 60;
	cout << "It took " << min << " minute(s) and " << sec << " second(s) to sort the vector" << endl << endl;

    imwrite("test1.jpeg", newReference);

    return 0;
}