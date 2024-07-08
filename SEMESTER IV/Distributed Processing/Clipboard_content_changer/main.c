#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_BUFFER_SIZE 4000
HWND hwndNextViewer;

int isIbanNumer(const char* num_str) {
    if (strlen(num_str) == 28 && strncmp(num_str, "PL", 2) == 0) {
        for (int i = 2; i < 28; ++i) {
            if (!isdigit(num_str[i])) {
                return 0;
            }
        }
        return 1;
    }
    return 0; 
}

char* changeIbanNumber(const char* num_str) {
    char* new_str = (char*)malloc(sizeof(char) * MAX_BUFFER_SIZE);
    sprintf(new_str, "%s", "Don't copy IBAN number!");
    char* console_info = (char*)malloc(sizeof(char) * MAX_BUFFER_SIZE);
    strcat(console_info, " IBN num:");
    strcat(console_info, num_str);
    printf("%s\n", console_info);
    free(console_info);
    return new_str;
}


LRESULT CALLBACK ClipboardViewerProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    switch (uMsg) {
        case WM_DRAWCLIPBOARD:
            // Clipboard content has changed
            if (OpenClipboard(hwnd)) {
                HANDLE hClipboardData = GetClipboardData(CF_TEXT);
                if (hClipboardData != NULL) {
                    char* clipboard_data = (char*)GlobalLock(hClipboardData);
                    if (clipboard_data != NULL) {
                        if (isIbanNumer(clipboard_data)) {
                            char* newContent = changeIbanNumber(clipboard_data);
                            if (newContent != NULL) {
                                EmptyClipboard();
                                HGLOBAL hMem = GlobalAlloc(GMEM_MOVEABLE, strlen(newContent) + 1);
                                if (hMem != NULL) {
                                    memcpy(GlobalLock(hMem), newContent, strlen(newContent) + 1);
                                    GlobalUnlock(hMem);
                                    SetClipboardData(CF_TEXT, hMem);
                                }
                                free(newContent);
                            }
                        }
                        GlobalUnlock(hClipboardData);
                    }
                }
                CloseClipboard();
            }
            break;

        default:
            return DefWindowProc(hwnd, uMsg, wParam, lParam);
    }
    return 0;
}

int main() {
    HWND hwnd = NULL;
    WNDCLASS wc = {0};
    wc.lpfnWndProc = ClipboardViewerProc;
    wc.hInstance = GetModuleHandle(NULL);
    wc.lpszClassName = "ClipboardViewer";
    RegisterClass(&wc);
    hwnd = CreateWindow(wc.lpszClassName, NULL, 0, 0, 0, 0, 0, HWND_MESSAGE, NULL, wc.hInstance, NULL);

    hwndNextViewer = SetClipboardViewer(hwnd);

    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    ChangeClipboardChain(hwnd, hwndNextViewer);
    DestroyWindow(hwnd);

    return 0;
}