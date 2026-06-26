#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <shellapi.h>
#include <windows.h>

#include <string>
#include <vector>

#include "flutter_window.h"
#include "utils.h"

namespace {

constexpr wchar_t kVisualCppRedistributableUrl[] =
    L"https://learn.microsoft.com/pt-br/cpp/windows/"
    L"latest-supported-vc-redist";

bool System32DllExists(const wchar_t* dll_name) {
  wchar_t system_directory[MAX_PATH];
  const UINT length =
      ::GetSystemDirectoryW(system_directory, ARRAYSIZE(system_directory));
  if (length == 0 || length >= ARRAYSIZE(system_directory)) {
    return false;
  }

  std::wstring dll_path(system_directory);
  dll_path += L"\\";
  dll_path += dll_name;

  HMODULE module = ::LoadLibraryW(dll_path.c_str());
  if (module == nullptr) {
    return false;
  }
  ::FreeLibrary(module);
  return true;
}

bool VisualCppRuntimeAvailable() {
  // Flutter Windows builds and native plugins commonly require the Microsoft
  // Visual C++ Redistributable runtime. Check the usual runtime DLLs before
  // starting the Flutter engine so users get a clear message.
  const wchar_t* required_dlls[] = {
      L"MSVCP140.dll",
      L"VCRUNTIME140.dll",
      L"VCRUNTIME140_1.dll",
  };

  for (const wchar_t* dll_name : required_dlls) {
    if (!System32DllExists(dll_name)) {
      return false;
    }
  }
  return true;
}

void ShowVisualCppRuntimeMessage() {
  const int result = ::MessageBoxW(
      nullptr,
      L"This application requires the Microsoft Visual C++ Redistributable "
      L"2015-2022 (x64).\n\n"
      L"It was not found on this computer. Please install it from Microsoft "
      L"and run the application again.\n\n"
      L"Open the Microsoft download page now?\n\n"
      L"https://learn.microsoft.com/pt-br/cpp/windows/"
      L"latest-supported-vc-redist",
      L"Microsoft Visual C++ Runtime Required",
      MB_ICONERROR | MB_YESNO | MB_DEFBUTTON1);

  if (result == IDYES) {
    ::ShellExecuteW(nullptr, L"open", kVisualCppRedistributableUrl, nullptr,
                    nullptr, SW_SHOWNORMAL);
  }
}

}  // namespace

int APIENTRY wWinMain(_In_ HINSTANCE instance, _In_opt_ HINSTANCE prev,
                      _In_ wchar_t *command_line, _In_ int show_command) {
  if (!VisualCppRuntimeAvailable()) {
    ShowVisualCppRuntimeMessage();
    return EXIT_FAILURE;
  }

  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments =
      GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"Cloudflare DNS Manager", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
