#include <windows.h>
#include "include/core/SkCanvas.h"
#include "include/core/SkSurface.h"
#include "include/core/SkPaint.h"
#include "include/core/SkBitmap.h"
#include "include/core/SkPath.h"
#include "./window/window.cpp"
#include <string>

/*

BITMAPINFO CreateBitmapInfoEEE(SkBitmap *bitmap) {
    BITMAPINFO bmi;
    memset(&bmi, 0, sizeof(bmi));
    bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
    bmi.bmiHeader.biWidth = bitmap->width();
    bmi.bmiHeader.biHeight = -bitmap->height(); // top-down image
    bmi.bmiHeader.biPlanes = 1;
    bmi.bmiHeader.biBitCount = 32;
    bmi.bmiHeader.biCompression = BI_RGB;
    bmi.bmiHeader.biSizeImage = 0;

    return bmi;
}

LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    switch (msg) {
        case WM_PAINT: {
            PAINTSTRUCT ps;
            HDC hdc = BeginPaint(hwnd, &ps);
            RECT rect;
            GetWindowRect(hwnd, &rect);

            int width = rect.right - rect.left;
            int height = rect.bottom - rect.top;


            // Get window dimensions
            auto surface = SkSurfaces::Raster(SkImageInfo::MakeN32Premul(width, height));

            SkCanvas *canvas = surface->getCanvas();


            SkBitmap bitmap;
            bitmap.allocPixels(surface->imageInfo());

            SkASSERT(bitmap.width() * bitmap.bytesPerPixel() == bitmap.rowBytes());


            BITMAPINFO bmi = CreateBitmapInfoEEE(&bitmap);

            SetDIBitsToDevice(hdc, 0, 0, width, height, 0, 0, 0, height, bitmap.getPixels(), &bmi, DIB_RGB_COLORS);






            // Clean up
            EndPaint(hwnd, &ps);
            return 0;
        }
        case WM_CLOSE:
            DestroyWindow(hwnd);
            return 0;
        case WM_DESTROY:
            PostQuitMessage(0);
            return 0;
        default:
            return DefWindowProc(hwnd, msg, wParam, lParam);
    }
}
*/


int SKa() {


    new Window("My Custom Window", 100, 122);

    return 0;
   /* // Register window class
    // Register window class
    WNDCLASS wc = {0};
    wc.lpfnWndProc = WndProc;
    wc.hInstance = GetModuleHandle(NULL);
    wc.hbrBackground = (HBRUSH) (COLOR_BACKGROUND);
    wc.lpszClassName = "SkiaWindowClass";
    RegisterClass(&wc);

    // Create window
    HWND hwnd = CreateWindow("SkiaWindowClass", "Skia Window", WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 800,
                             600, NULL, NULL, wc.hInstance, NULL);
    if (!hwnd) {
        return -1;
    }

    ShowWindow(hwnd, SW_SHOW);

    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    return msg.wParam;*/
}