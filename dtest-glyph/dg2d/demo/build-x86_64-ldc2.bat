@ECHO OFF

set PATH=C:\D\ldc2-1.23.0-windows-x64\bin;%PATH%

dub build --arch=x86_64  --compiler=ldc2.exe  --build=release
