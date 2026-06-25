# escape=`
FROM mcr.microsoft.com/windows/servercore:ltsc2022

SHELL ["powershell", "-NoLogo", "-ExecutionPolicy", "Bypass", "-Command"]

ENV FLUTTER_VERSION=3.22.0
ENV FLUTTER_HOME=C:\flutter
ENV PUB_CACHE=C:\pub-cache
ENV PATH="C:\flutter\bin;C:\Program Files\Git\cmd;C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin;C:\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja;C:\BuildTools\MSBuild\Current\Bin;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0"

WORKDIR C:\app

RUN $ErrorActionPreference = 'Stop'; `
    $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vs_BuildTools.exe' -OutFile "$env:TEMP\vs_buildtools.exe"; `
    $process = Start-Process -FilePath "$env:TEMP\vs_buildtools.exe" -ArgumentList `
      '--quiet', '--wait', '--norestart', '--nocache', '--installPath', 'C:\BuildTools', `
      '--add', 'Microsoft.VisualStudio.Workload.VCTools', `
      '--add', 'Microsoft.VisualStudio.Component.VC.Tools.x86.x64', `
      '--add', 'Microsoft.VisualStudio.Component.Windows11SDK.22621', `
      '--add', 'Microsoft.VisualStudio.Component.VC.CMake.Project', `
      '--includeRecommended' -Wait -PassThru; `
    if ($process.ExitCode -ne 0 -and $process.ExitCode -ne 3010) { exit $process.ExitCode }; `
    Remove-Item "$env:TEMP\vs_buildtools.exe" -Force

RUN $ErrorActionPreference = 'Stop'; `
    $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/download/v2.45.2.windows.1/Git-2.45.2-64-bit.exe' -OutFile "$env:TEMP\git-installer.exe"; `
    $process = Start-Process -FilePath "$env:TEMP\git-installer.exe" -ArgumentList '/VERYSILENT', '/NORESTART', '/NOCANCEL', '/SP-' -Wait -PassThru; `
    if ($process.ExitCode -ne 0) { exit $process.ExitCode }; `
    Remove-Item "$env:TEMP\git-installer.exe" -Force

RUN $ErrorActionPreference = 'Stop'; `
    $ProgressPreference = 'SilentlyContinue'; `
    Invoke-WebRequest -Uri "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_$env:FLUTTER_VERSION-stable.zip" -OutFile "$env:TEMP\flutter.zip"; `
    Expand-Archive -Path "$env:TEMP\flutter.zip" -DestinationPath C:\ -Force; `
    Remove-Item "$env:TEMP\flutter.zip" -Force; `
    git config --global --add safe.directory C:/flutter; `
    flutter config --enable-windows-desktop --no-analytics; `
    flutter precache --windows

CMD ["flutter", "--version"]
