#include <opencv2/opencv.hpp>

int OPenCam() {
    // Open a connection to the default webcam (index 0)
    cv::VideoCapture cap(0);

    // Check if the webcam opened successfully
    if (!cap.isOpened()) {
        std::cerr << "Error: Could not open webcam." << std::endl;
        return -1;
    }

    // Create a window to display the webcam feed
    cv::namedWindow("Webcam", cv::WINDOW_NORMAL);

    while (true) {
        cv::Mat frame;

        // Capture a frame from the webcam
        cap >> frame;

        // Check if the frame was captured successfully
        if (frame.empty()) {
            std::cerr << "Error: Could not capture frame." << std::endl;
            break;
        }

        // Display the captured frame
        cv::imshow("Webcam", frame);

        // Exit the loop if the 'q' key is pressed
        if (cv::waitKey(1) == 'q') {
            break;
        }
    }

    // Release the webcam and close the window
    cap.release();
    cv::destroyAllWindows();

    return 0;
}